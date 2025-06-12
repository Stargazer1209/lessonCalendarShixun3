package com.schedule.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.UserDAO;
import com.schedule.dao.CourseDAO;
import com.schedule.model.User;

/**
 * 管理员主页面Servlet
 * 处理管理员界面的显示和统计信息
 */
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查用户是否已登录且为管理员
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            // 非管理员用户，重定向到普通用户首页
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        try {
            // 获取用户统计信息
            Map<String, Integer> userStats = userDAO.getUserStats();
            request.setAttribute("userStats", userStats);

            // 获取课程统计信息
            Map<String, Object> courseStats = courseDAO.getCourseStats();
            request.setAttribute("courseStats", courseStats);

            // 获取所有用户列表（用于管理）
            List<User> allUsers = userDAO.getAllUsers();
            request.setAttribute("allUsers", allUsers);

            // 转发到管理员页面
            request.getRequestDispatcher("/admin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取数据时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
