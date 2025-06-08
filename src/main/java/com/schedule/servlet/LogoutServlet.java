package com.schedule.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleLogout(request, response);
    }

    /**
     * 处理用户退出逻辑
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 获取当前会话
            HttpSession session = request.getSession(false);
            
            if (session != null) {
                // 记录退出日志
                String username = (String) session.getAttribute("username");
                if (username != null) {
                    System.out.println("用户退出登录: " + username + ", 时间: " + new java.util.Date());
                }
                
                // 清除所有会话属性
                session.removeAttribute("user");
                session.removeAttribute("userId");
                session.removeAttribute("username");
                session.removeAttribute("sessionToken");
                
                // 销毁会话
                session.invalidate();
            }
            
            // 设置响应头防止缓存
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            
            // 创建新会话并设置退出成功消息
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("logoutMessage", "您已成功退出登录");
            
            // 重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            
        } catch (Exception e) {
            // 异常处理
            System.err.println("退出登录异常: " + e.getMessage());
            e.printStackTrace();
            
            // 即使出现异常，也要确保用户退出
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            
            // 重定向到登录页面
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
        }
    }
}