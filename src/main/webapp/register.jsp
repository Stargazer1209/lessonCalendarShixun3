<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - 课灵通</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/form.css" charset="UTF-8">
</head>
<body>
    <div class="register-container">
        <!-- 返回首页链接 -->
        <a href="<%= request.getContextPath() %>/index.jsp" class="back-home" title="返回首页">
            返回首页
        </a>

        <div class="register-header">
            <h1>课灵通</h1>
            <p>创建您的新账户</p>
        </div>

        <!-- 显示错误消息 -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>        <form id="registerForm" action="RegisterServlet" method="post">
            <div class="form-group">
                <label for="username">用户名 *</label>
                <input type="text" id="username" name="username" class="form-control" 
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                       placeholder="3-20个字符，只能包含字母、数字和下划线" required>
                <div class="error-message" id="usernameError"></div>
                <div class="success-message" id="usernameSuccess"></div>
            </div>

            <div class="form-group">
                <label for="email">邮箱 *</label>
                <input type="email" id="email" name="email" class="form-control" 
                       value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                       placeholder="请输入有效的邮箱地址" required>
                <div class="error-message" id="emailError"></div>
                <div class="success-message" id="emailSuccess"></div>
            </div>

            <div class="form-group">
                <label for="fullName">姓名 *</label>
                <input type="text" id="fullName" name="fullName" class="form-control" 
                       value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : "" %>"
                       placeholder="请输入您的真实姓名" required>
                <div class="error-message" id="fullNameError"></div>
                <div class="success-message" id="fullNameSuccess"></div>
            </div>

            <div class="form-group">
                <label for="password">密码 *</label>
                <input type="password" id="password" name="password" class="form-control" 
                       placeholder="至少6个字符" required>
                <div class="error-message" id="passwordError"></div>
                <div class="password-strength" id="passwordStrength"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">确认密码 *</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                       placeholder="请再次输入密码" required>
                <div class="error-message" id="confirmPasswordError"></div>
                <div class="success-message" id="confirmPasswordSuccess"></div>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="agreement" name="agreement" required>
                <label for="agreement">
                    我已阅读并同意 <a href="#" onclick="showTerms()">用户协议</a> 和 <a href="#" onclick="showPrivacy()">隐私政策</a>
                </label>
            </div>

            <button type="submit" class="btn" id="registerBtn">注册</button>
        </form>        <div class="login-link">
            已有账户？<a href="<%= request.getContextPath() %>/LoginServlet">立即登录</a>
        </div>
    </div>    <script src="<%= request.getContextPath() %>/js/register.js"></script>
</body>
</html>