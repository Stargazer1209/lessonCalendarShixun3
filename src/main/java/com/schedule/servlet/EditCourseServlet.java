package com.schedule.servlet;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
// import java.net.URLEncoder;

/**
 * 编辑课程Servlet
 * 处理课程编辑页面的显示
 */
public class EditCourseServlet extends HttpServlet {
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 设置请求和响应编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // 检查用户登录状态
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }        // 获取课程ID参数
        String courseIdStr = request.getParameter("id");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "缺少课程ID参数");
            response.sendRedirect("ViewScheduleServlet");
            return;
        }
        
        try {
            int courseId = Integer.parseInt(courseIdStr);
            
            // 获取课程信息
            Course course = courseDAO.findById(courseId);
              if (course == null) {
                session.setAttribute("errorMessage", "课程不存在或已被删除");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }
            
            // 检查课程是否属于当前用户
            if (course.getUserId() != currentUser.getUserId()) {
                session.setAttribute("errorMessage", "您无权编辑此课程");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }
            
            // 将课程信息设置到请求属性中
            request.setAttribute("course", course);
            
            // 转发到编辑页面
            request.getRequestDispatcher("edit-course.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "无效的课程ID");
            response.sendRedirect("ViewScheduleServlet");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "获取课程信息时发生错误：" + e.getMessage());
            response.sendRedirect("ViewScheduleServlet");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST请求重定向到GET请求
        doGet(request, response);
    }
}
