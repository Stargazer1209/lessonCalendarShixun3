<%-- filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\webapp\login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 课灵通</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/form.css" charset="UTF-8">
</head>
<body>
    <div class="login-container">
        <!-- 返回首页链接 -->
        <a href="<%= request.getContextPath() %>/index.jsp" class="back-home" title="返回首页">
            返回首页
        </a>

        <div class="login-header">
            <h1>课灵通</h1>
            <p>登录您的账户</p>
        </div>

        <!-- 显示错误消息 -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- 显示成功消息（来自注册或退出） -->
        <% 
            HttpSession currentSession = request.getSession(false);
            if (currentSession != null) {
                String successMessage = (String) currentSession.getAttribute("successMessage");
                String logoutMessage = (String) currentSession.getAttribute("logoutMessage");
                
                if (successMessage != null) {
                    currentSession.removeAttribute("successMessage");
        %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
        <% 
                } else if (logoutMessage != null) {
                    currentSession.removeAttribute("logoutMessage");
        %>
            <div class="alert alert-success">
                <%= logoutMessage %>
            </div>
        <% 
                }
            }
        %>        <form id="loginForm" action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" class="form-control" 
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       required>
                <div class="error-message" id="usernameError"></div>
            </div>

            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" class="form-control" required>
                <div class="error-message" id="passwordError"></div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="rememberMe" name="rememberMe">
                <label for="rememberMe">记住我（7天内免登录）</label>
            </div>

            <button type="submit" class="btn" id="loginBtn">登录</button>
        </form>        <div class="register-link">
            还没有账户？<a href="<%= request.getContextPath() %>/RegisterServlet">立即注册</a>
        </div>
    </div>    <script src="<%= request.getContextPath() %>/js/login.js"></script>
</body>
</html>
