package com.schedule.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.UserDAO;
import com.schedule.model.User;
// import com.schedule.util.SecurityUtil;

/**
 * 用户个人信息管理Servlet
 * 处理用户个人信息的查看和修改
 */
@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查用户登录状态
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 显示个人信息页面
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 检查用户登录状态
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        // 获取表单参数
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        try {
            // 输入验证
            String validationError = validateInput(email, fullName, password, confirmPassword);
            if (validationError != null) {
                request.setAttribute("error", validationError);
                preserveFormData(request, email, fullName);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // 检查邮箱唯一性（如果邮箱有变化）
            if (!email.equals(currentUser.getEmail()) && userDAO.isEmailExists(email)) {
                request.setAttribute("error", "该邮箱已被其他用户注册，请使用其他邮箱");
                preserveFormData(request, email, fullName);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // 更新用户信息
            User updatedUser = new User();
            updatedUser.setUserId(currentUser.getUserId());
            updatedUser.setEmail(email);
            updatedUser.setFullName(fullName);

            boolean updatePassword = (password != null && !password.trim().isEmpty());
            if (updatePassword) {
                updatedUser.setPassword(password);
            }

            // 执行更新
            boolean success = userDAO.updateUserProfile(updatedUser, updatePassword);

            if (success) {
                // 更新session中的用户信息
                currentUser.setEmail(email);
                currentUser.setFullName(fullName);
                session.setAttribute("user", currentUser);

                request.setAttribute("success", "个人信息更新成功！");
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "更新失败，请稍后重试");
                preserveFormData(request, email, fullName);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            preserveFormData(request, email, fullName);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        }
    }

    /**
     * 验证用户输入
     */
    private String validateInput(String email, String fullName, String password, String confirmPassword) {
        // 基本验证
        if (email == null || email.trim().isEmpty()) {
            return "邮箱不能为空";
        }

        if (fullName == null || fullName.trim().isEmpty()) {
            return "姓名不能为空";
        }

        // 邮箱格式验证
        if (!email.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            return "邮箱格式不正确";
        }

        // 姓名长度验证
        if (fullName.trim().length() < 2 || fullName.trim().length() > 50) {
            return "姓名长度应为2-50个字符";
        }

        // 密码验证（如果提供了密码）
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 8 || password.length() > 100) {
                return "密码长度应为8-100个字符";
            }

            if (!password.matches(".*[a-zA-Z].*") || !password.matches(".*[0-9].*")) {
                return "密码必须包含字母和数字";
            }

            if (confirmPassword == null || !password.equals(confirmPassword)) {
                return "两次输入的密码不一致";
            }
        }

        return null;
    }

    /**
     * 保持表单数据，以便验证失败时重新显示
     */
    private void preserveFormData(HttpServletRequest request, String email, String fullName) {
        request.setAttribute("email", email);
        request.setAttribute("fullName", fullName);
    }
}
