package com.schedule.servlet;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;
import com.schedule.util.CourseDataUtil;
import com.schedule.util.QRCodeUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * 二维码生成Servlet
 */
@WebServlet("/QRCodeServlet")
public class QRCodeServlet extends HttpServlet {
    
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 检查用户登录状态
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "用户未登录");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        String courseId = request.getParameter("courseId");
        
        try {
            if ("single".equals(action) && courseId != null) {
                // 生成单个课程的二维码
                generateSingleCourseQR(request, response, currentUser, Integer.parseInt(courseId));
            } else if ("all".equals(action)) {
                // 生成所有课程的二维码
                generateAllCoursesQR(request, response, currentUser);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "无效的参数");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "生成二维码失败");
        }
    }
    
    /**
     * 生成单个课程的二维码
     */
    private void generateSingleCourseQR(HttpServletRequest request, HttpServletResponse response, 
                                      User user, int courseId) throws Exception {
        Course course = courseDAO.findById(courseId);
        
        if (course == null || course.getUserId() != user.getUserId()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "课程不存在或无权限");
            return;
        }
        
        String courseJson = CourseDataUtil.courseToJson(course);
        byte[] qrCodeImage = QRCodeUtil.generateQRCode(courseJson);
        
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"course_" + courseId + "_qr.png\"");
        response.getOutputStream().write(qrCodeImage);
    }
    
    /**
     * 生成所有课程的二维码
     */
    private void generateAllCoursesQR(HttpServletRequest request, HttpServletResponse response, 
                                    User user) throws Exception {
        List<Course> courses = courseDAO.findByUserId(user.getUserId());
        
        if (courses.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "暂无课程数据");
            return;
        }
        
        String coursesJson = CourseDataUtil.coursesToJson(courses);
        byte[] qrCodeImage = QRCodeUtil.generateQRCode(coursesJson);
        
        response.setContentType("image/png");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"all_courses_qr.png\"");
        response.getOutputStream().write(qrCodeImage);
    }
}