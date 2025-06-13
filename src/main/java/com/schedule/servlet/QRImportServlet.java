package com.schedule.servlet;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;
import com.schedule.util.CourseDataUtil;
import com.schedule.util.QRCodeUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

/**
 * 二维码导入Servlet
 */
@WebServlet("/QRImportServlet")
@MultipartConfig
public class QRImportServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        // 检查用户登录状态
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        try {
            Part filePart = request.getPart("qrImage");
            
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMessage", "请选择要导入的二维码图片");
                response.sendRedirect("add-course.jsp");
                return;
            }
            
            // 读取图片
            BufferedImage image = ImageIO.read(filePart.getInputStream());
            if (image == null) {
                session.setAttribute("errorMessage", "无效的图片格式");
                response.sendRedirect("add-course.jsp");
                return;
            }
            
            // 解析二维码
            String qrContent = QRCodeUtil.decodeQRCode(image);
            
            // 判断是单个课程还是多个课程
            if (qrContent.trim().startsWith("[")) {
                // 多个课程
                importMultipleCourses(qrContent, currentUser, session);
            } else {
                // 单个课程
                importSingleCourse(qrContent, currentUser, session);
            }
            
            response.sendRedirect("ViewScheduleServlet");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "导入失败：" + e.getMessage());
            response.sendRedirect("add-course.jsp");
        }
    }
    
    /**
     * 导入单个课程
     */
    private void importSingleCourse(String qrContent, User user, HttpSession session) throws Exception {
        Map<String, Object> courseData = CourseDataUtil.jsonToCourseData(qrContent);
        
        Course course = new Course();
        course.setUserId(user.getUserId());
        course.setCourseName((String) courseData.get("courseName"));
        course.setInstructor((String) courseData.get("instructor"));
        course.setClassroom((String) courseData.get("classroom"));
        course.setDayOfWeek((Integer) courseData.get("dayOfWeek"));
        course.setStartTime(LocalTime.parse((String) courseData.get("startTime")));
        course.setEndTime(LocalTime.parse((String) courseData.get("endTime")));
        course.setWeekStart((Integer) courseData.get("weekStart"));
        course.setWeekEnd((Integer) courseData.get("weekEnd"));
        course.setCourseType((String) courseData.get("courseType"));
        course.setCredits((Integer) courseData.get("credits"));
        course.setDescription((String) courseData.get("description"));
        
        // 检查时间冲突
        List<Course> conflicts = courseDAO.checkTimeConflict(course);
        if (!conflicts.isEmpty()) {
            session.setAttribute("errorMessage", "导入的课程与现有课程时间冲突");
            return;
        }
        
        if (courseDAO.addCourse(course)) {
            session.setAttribute("successMessage", "课程导入成功");
        } else {
            session.setAttribute("errorMessage", "课程导入失败");
        }
    }
    
    /**
     * 导入多个课程
     */
    private void importMultipleCourses(String qrContent, User user, HttpSession session) throws Exception {
        List<Map<String, Object>> coursesData = CourseDataUtil.jsonToCoursesData(qrContent);
        
        int successCount = 0;
        int conflictCount = 0;
        
        for (Map<String, Object> courseData : coursesData) {
            Course course = new Course();
            course.setUserId(user.getUserId());
            course.setCourseName((String) courseData.get("courseName"));
            course.setInstructor((String) courseData.get("instructor"));
            course.setClassroom((String) courseData.get("classroom"));
            course.setDayOfWeek((Integer) courseData.get("dayOfWeek"));
            course.setStartTime(LocalTime.parse((String) courseData.get("startTime")));
            course.setEndTime(LocalTime.parse((String) courseData.get("endTime")));
            course.setWeekStart((Integer) courseData.get("weekStart"));
            course.setWeekEnd((Integer) courseData.get("weekEnd"));
            course.setCourseType((String) courseData.get("courseType"));
            course.setCredits((Integer) courseData.get("credits"));
            course.setDescription((String) courseData.get("description"));
            
            // 检查时间冲突
            List<Course> conflicts = courseDAO.checkTimeConflict(course);
            if (!conflicts.isEmpty()) {
                conflictCount++;
                continue;
            }
            
            if (courseDAO.addCourse(course)) {
                successCount++;
            }
        }
        
        session.setAttribute("successMessage", 
            String.format("批量导入完成：成功 %d 门，冲突跳过 %d 门", successCount, conflictCount));
    }
}