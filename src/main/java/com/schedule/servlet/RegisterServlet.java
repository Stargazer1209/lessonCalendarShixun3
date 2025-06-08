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
import com.schedule.util.SecurityUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果用户已登录，重定向到首页
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        // 显示注册页面
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 获取表单参数
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");

        try {
            // 输入验证
            String validationError = validateInput(username, password, confirmPassword, email, fullName);
            if (validationError != null) {
                request.setAttribute("error", validationError);
                preserveFormData(request, username, email, fullName);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 清理输入数据（XSS防护）
            // 待安全加固功能完成后取消注释
            // username = SecurityUtil.cleanXSS(username.trim());
            // email = SecurityUtil.cleanXSS(email.trim());
            // fullName = SecurityUtil.cleanXSS(fullName.trim());

            // 检查用户名唯一性
            if (userDAO.isUsernameExists(username)) {
                request.setAttribute("error", "用户名已存在，请选择其他用户名");
                preserveFormData(request, username, email, fullName);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 检查邮箱唯一性
            if (userDAO.isEmailExists(email)) {
                request.setAttribute("error", "该邮箱已被注册，请使用其他邮箱");
                preserveFormData(request, username, email, fullName);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                return;
            }

            // 创建新用户对象
            User newUser = new User();
            newUser.setUsername(username);
            newUser.setPassword(password); // UserDAO会处理密码哈希
            newUser.setEmail(email);
            newUser.setFullName(fullName);

            // 注册用户
            boolean success = userDAO.addUser(newUser);
            
            if (success) {
                // 注册成功
                System.out.println("用户注册成功: " + username + ", 时间: " + new java.util.Date());
                
                // 设置成功消息并重定向到登录页面
                HttpSession session = request.getSession(true);
                session.setAttribute("successMessage", "注册成功！请使用您的用户名和密码登录。");
                response.sendRedirect(request.getContextPath() + "/login");
                
            } else {
                // 注册失败
                request.setAttribute("error", "注册失败，请稍后重试");
                preserveFormData(request, username, email, fullName);
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // 异常处理
            System.err.println("注册处理异常: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "注册过程中发生错误，请稍后重试");
            preserveFormData(request, username, email, fullName);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    /**
     * 验证用户输入
     */
    private String validateInput(String username, String password, String confirmPassword, 
                                String email, String fullName) {
        
        // 检查必填字段
        if (username == null || username.trim().isEmpty()) {
            return "用户名不能为空";
        }
        if (password == null || password.isEmpty()) {
            return "密码不能为空";
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "请确认密码";
        }
        if (email == null || email.trim().isEmpty()) {
            return "邮箱不能为空";
        }
        if (fullName == null || fullName.trim().isEmpty()) {
            return "姓名不能为空";
        }

        // 格式验证
        if (!SecurityUtil.isValidUsername(username.trim())) {
            return "用户名格式不正确（3-20个字符，只能包含字母、数字和下划线）";
        }
        if (!SecurityUtil.isValidPassword(password)) {
            return "密码格式不正确（至少8个字符, 包含字母和数字）";
        }
        if (!SecurityUtil.isValidEmail(email.trim())) {
            return "邮箱格式不正确";
        }

        // 密码确认
        if (!password.equals(confirmPassword)) {
            return "两次输入的密码不一致";
        }

        return null; // 验证通过
    }

    /**
     * 保持表单数据，以便验证失败时重新显示
     */
    private void preserveFormData(HttpServletRequest request, String username, String email, String fullName) {
        request.setAttribute("username", username);
        request.setAttribute("email", email);
        request.setAttribute("fullName", fullName);
    }
}