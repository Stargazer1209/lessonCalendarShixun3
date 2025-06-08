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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
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
        
        // 显示登录页面
        request.getRequestDispatcher("/login.jsp").forward(request, response);
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
        String rememberMe = request.getParameter("rememberMe");

        try {
            // 输入验证
            if (username == null || username.trim().isEmpty()) {
                request.setAttribute("error", "用户名不能为空");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "密码不能为空");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // 待安全加固功能完成后取消注释 清理输入数据
            // username = SecurityUtil.cleanXSS(username.trim());
            
            // 验证输入格式
            if (!SecurityUtil.isValidUsername(username)) {
                request.setAttribute("error", "用户名格式不正确");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            // 用户认证
            User user = userDAO.authenticate(username, password);
            
            if (user != null) {
                // 登录成功 - 创建会话
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                
                // 生成并设置会话令牌
                String sessionToken = SecurityUtil.generateSessionToken();
                session.setAttribute("sessionToken", sessionToken);
                
                // 设置会话超时时间（30分钟）
                session.setMaxInactiveInterval(30 * 60);
                
                // 记住我功能
                if ("on".equals(rememberMe)) {
                    // 设置更长的会话时间（7天）
                    session.setMaxInactiveInterval(7 * 24 * 60 * 60);
                }
                
                // 记录登录日志
                System.out.println("用户登录成功: " + username + ", 时间: " + new java.util.Date());
                
                // 重定向到首页
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                
            } else {
                // 登录失败
                request.setAttribute("error", "用户名或密码错误");
                request.setAttribute("username", username); // 保持用户名输入
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // 异常处理
            System.err.println("登录处理异常: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "登录过程中发生错误，请稍后重试");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}