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
import java.io.InputStream;
import java.util.List;
import java.util.Map;

/**
 * 二维码导入Servlet
 */
@WebServlet("/QRImportServlet")
@MultipartConfig(
    maxFileSize = 5242880,      // 5MB
    maxRequestSize = 10485760,  // 10MB
    fileSizeThreshold = 1048576 // 1MB
)
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
        Part filePart = null;
        
        try {
            filePart = request.getPart("qrImage");
            
            if (filePart == null || filePart.getSize() == 0) {
                session.setAttribute("errorMessage", "请选择要导入的二维码图片");
                response.sendRedirect("add-course.jsp");
                return;
            }
            
            // 使用 try-with-resources 自动关闭流
            BufferedImage image;
            try (InputStream inputStream = filePart.getInputStream()) {
                image = ImageIO.read(inputStream);
            }
            
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
        } finally {
            // 手动清理临时文件
            if (filePart != null) {
                try {
                    filePart.delete();
                } catch (IOException e) {
                    // 记录日志但不影响主流程
                    System.err.println("清理临时文件失败: " + e.getMessage());
                }
            }
        }
    }
    
    /**
     * 导入单个课程
     */
    private void importSingleCourse(String qrContent, User user, HttpSession session) throws Exception {
        Map<String, Object> courseData = CourseDataUtil.jsonToCourseData(qrContent);
        Course course = CourseDataUtil.mapToCourse(courseData, user.getUserId());
        
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
            Course course = CourseDataUtil.mapToCourse(courseData, user.getUserId());
            
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