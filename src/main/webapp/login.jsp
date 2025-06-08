<%-- filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\webapp\login.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 课灵通</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            padding: 40px;
        }

        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .login-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .login-header p {
            color: #666;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-control.error {
            border-color: #e74c3c;
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .alert {
            padding: 12px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 14px;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 8px;
        }

        .checkbox-group label {
            margin-bottom: 0;
            font-size: 14px;
            color: #666;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .register-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .register-link a {
            color: #667eea;
            text-decoration: none;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 20px;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="login-container">
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
        %>

        <form id="loginForm" action="<%= request.getContextPath() %>/login" method="post">
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
        </form>

        <div class="register-link">
            还没有账户？<a href="<%= request.getContextPath() %>/register">立即注册</a>
        </div>
    </div>

    <script>
        // 表单验证
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username');
            const password = document.getElementById('password');
            let isValid = true;

            // 清除之前的错误状态
            clearErrors();

            // 验证用户名
            if (!username.value.trim()) {
                showError('username', '请输入用户名');
                isValid = false;
            } else if (username.value.trim().length < 3) {
                showError('username', '用户名至少3个字符');
                isValid = false;
            }

            // 验证密码
            if (!password.value) {
                showError('password', '请输入密码');
                isValid = false;
            } else if (password.value.length < 6) {
                showError('password', '密码至少8个字符, 包含字母和数字');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            } else {
                // 禁用提交按钮防止重复提交
                document.getElementById('loginBtn').disabled = true;
                document.getElementById('loginBtn').textContent = '登录中...';
            }
        });

        function showError(fieldName, message) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + 'Error');
            
            field.classList.add('error');
            errorDiv.textContent = message;
            errorDiv.classList.add('show');
        }

        function clearErrors() {
            const errorFields = ['username', 'password'];
            errorFields.forEach(function(fieldName) {
                const field = document.getElementById(fieldName);
                const errorDiv = document.getElementById(fieldName + 'Error');
                
                field.classList.remove('error');
                errorDiv.classList.remove('show');
            });
        }

        // 输入时清除错误状态
        ['username', 'password'].forEach(function(fieldName) {
            document.getElementById(fieldName).addEventListener('input', function() {
                this.classList.remove('error');
                document.getElementById(fieldName + 'Error').classList.remove('show');
            });
        });

        // 自动聚焦到用户名输入框
        document.addEventListener('DOMContentLoaded', function() {
            const usernameField = document.getElementById('username');
            if (usernameField && !usernameField.value) {
                usernameField.focus();
            }
        });

        // 支持回车键提交表单
        document.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                document.getElementById('loginForm').dispatchEvent(new Event('submit'));
            }
        });

        // 防止重复提交
        let isSubmitting = false;
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            if (isSubmitting) {
                e.preventDefault();
                return false;
            }
        });
    </script>
</body>
</html>
