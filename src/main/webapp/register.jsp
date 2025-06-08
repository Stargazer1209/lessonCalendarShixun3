<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 - 课灵通</title>
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
            padding: 20px 0;
        }

        .register-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            padding: 40px;
        }

        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-header h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .register-header p {
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

        .form-control.success {
            border-color: #27ae60;
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .success-message {
            color: #27ae60;
            font-size: 14px;
            margin-top: 5px;
            display: none;
        }

        .error-message.show, .success-message.show {
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

        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }

        .strength-weak {
            color: #e74c3c;
        }

        .strength-medium {
            color: #f39c12;
        }

        .strength-strong {
            color: #27ae60;
        }

        .checkbox-group {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 8px;
            margin-top: 2px;
        }

        .checkbox-group label {
            margin-bottom: 0;
            font-size: 14px;
            color: #666;
            line-height: 1.4;
        }

        .checkbox-group a {
            color: #667eea;
            text-decoration: none;
        }

        .checkbox-group a:hover {
            text-decoration: underline;
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

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .register-container {
                margin: 20px;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="register-header">
            <h1>课灵通</h1>
            <p>创建您的新账户</p>
        </div>

        <!-- 显示错误消息 -->
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form id="registerForm" action="<%= request.getContextPath() %>/register" method="post">
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
        </form>

        <div class="login-link">
            已有账户？<a href="<%= request.getContextPath() %>/login">立即登录</a>
        </div>
    </div>

    <script>
        // 实时验证
        document.getElementById('username').addEventListener('input', validateUsername);
        document.getElementById('email').addEventListener('input', validateEmail);
        document.getElementById('fullName').addEventListener('input', validateFullName);
        document.getElementById('password').addEventListener('input', validatePassword);
        document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);

        // 表单提交验证
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            let isValid = true;

            // 验证所有字段
            if (!validateUsername()) isValid = false;
            if (!validateEmail()) isValid = false;
            if (!validateFullName()) isValid = false;
            if (!validatePassword()) isValid = false;
            if (!validateConfirmPassword()) isValid = false;

            // 验证协议勾选
            const agreement = document.getElementById('agreement');
            if (!agreement.checked) {
                alert('请先阅读并同意用户协议和隐私政策');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            } else {
                // 禁用提交按钮防止重复提交
                document.getElementById('registerBtn').disabled = true;
                document.getElementById('registerBtn').textContent = '注册中...';
            }
        });

        function validateUsername() {
            const username = document.getElementById('username');
            const value = username.value.trim();

            if (!value) {
                showError('username', '请输入用户名');
                return false;
            }

            if (value.length < 3 || value.length > 20) {
                showError('username', '用户名长度应为3-20个字符');
                return false;
            }

            if (!/^[a-zA-Z0-9_]+$/.test(value)) {
                showError('username', '用户名只能包含字母、数字和下划线');
                return false;
            }

            showSuccess('username', '用户名格式正确');
            return true;
        }

        function validateEmail() {
            const email = document.getElementById('email');
            const value = email.value.trim();

            if (!value) {
                showError('email', '请输入邮箱地址');
                return false;
            }

            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(value)) {
                showError('email', '请输入有效的邮箱地址');
                return false;
            }

            showSuccess('email', '邮箱格式正确');
            return true;
        }

        function validateFullName() {
            const fullName = document.getElementById('fullName');
            const value = fullName.value.trim();

            if (!value) {
                showError('fullName', '请输入姓名');
                return false;
            }

            if (value.length < 2 || value.length > 50) {
                showError('fullName', '姓名长度应为2-50个字符');
                return false;
            }

            showSuccess('fullName', '姓名格式正确');
            return true;
        }

        function validatePassword() {
            const password = document.getElementById('password');
            const value = password.value;
            const strengthDiv = document.getElementById('passwordStrength');

            if (!value) {
                showError('password', '请输入密码');
                strengthDiv.textContent = '';
                return false;
            }

            if (value.length < 8) {
                showError('password', '密码至少需要8个字符');
                strengthDiv.textContent = '';
                return false;
            }

            // 密码强度检查
            let strength = 0;
            if (value.length >= 8) strength++;
            if (/[a-z]/.test(value)) strength++;
            if (/[A-Z]/.test(value)) strength++;
            if (/[0-9]/.test(value)) strength++;
            if (/[^a-zA-Z0-9]/.test(value)) strength++;

            clearMessages('password');

            if (strength < 2) {
                strengthDiv.textContent = '密码强度：弱';
                strengthDiv.className = 'password-strength strength-weak';
            } else if (strength < 4) {
                strengthDiv.textContent = '密码强度：中等';
                strengthDiv.className = 'password-strength strength-medium';
            } else {
                strengthDiv.textContent = '密码强度：强';
                strengthDiv.className = 'password-strength strength-strong';
            }

            return true;
        }

        function validateConfirmPassword() {
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            const value = confirmPassword.value;

            if (!value) {
                showError('confirmPassword', '请确认密码');
                return false;
            }

            if (value !== password.value) {
                showError('confirmPassword', '两次输入的密码不一致');
                return false;
            }

            showSuccess('confirmPassword', '密码确认正确');
            return true;
        }

        function showError(fieldName, message) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + 'Error');
            const successDiv = document.getElementById(fieldName + 'Success');
            
            field.classList.add('error');
            field.classList.remove('success');
            
            if (errorDiv) {
                errorDiv.textContent = message;
                errorDiv.classList.add('show');
            }
            
            if (successDiv) {
                successDiv.classList.remove('show');
            }
        }

        function showSuccess(fieldName, message) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + 'Error');
            const successDiv = document.getElementById(fieldName + 'Success');
            
            field.classList.remove('error');
            field.classList.add('success');
            
            if (errorDiv) {
                errorDiv.classList.remove('show');
            }
            
            if (successDiv) {
                successDiv.textContent = message;
                successDiv.classList.add('show');
            }
        }

        function clearMessages(fieldName) {
            const field = document.getElementById(fieldName);
            const errorDiv = document.getElementById(fieldName + 'Error');
            const successDiv = document.getElementById(fieldName + 'Success');
            
            field.classList.remove('error', 'success');
            
            if (errorDiv) {
                errorDiv.classList.remove('show');
            }
            
            if (successDiv) {
                successDiv.classList.remove('show');
            }
        }

        function showTerms() {
            alert('用户协议：\n\n1. 用户应当遵守相关法律法规\n2. 不得发布违法信息\n3. 保护个人隐私\n4. 合理使用系统资源\n\n详细条款请联系管理员获取。');
        }

        function showPrivacy() {
            alert('隐私政策：\n\n1. 我们重视您的隐私保护\n2. 仅收集必要的个人信息\n3. 不会向第三方泄露您的信息\n4. 采用安全措施保护数据\n\n详细政策请联系管理员获取。');
        }

        // 自动聚焦到用户名输入框
        document.addEventListener('DOMContentLoaded', function() {
            const usernameField = document.getElementById('username');
            if (usernameField && !usernameField.value) {
                usernameField.focus();
            }
        });

        // 防止重复提交
        let isSubmitting = false;
        const registerForm = document.getElementById('registerForm');
        if (registerForm) {
            registerForm.addEventListener('submit', function(e) {
                if (isSubmitting) {
                    e.preventDefault();
                    return false;
                }
            });
        }

        // 实时检查用户名可用性（模拟功能）
        let usernameCheckTimeout;
        document.getElementById('username').addEventListener('input', function() {
            const username = this.value.trim();
            if (username.length >= 3) {
                clearTimeout(usernameCheckTimeout);
                usernameCheckTimeout = setTimeout(function() {
                    // 这里可以添加AJAX检查用户名是否已存在
                    // checkUsernameAvailability(username);
                }, 800);
            }
        });

        // 密码强度指示器增强
        function getPasswordStrengthText(strength) {
            const texts = [
                '非常弱', '弱', '一般', '良好', '强', '非常强'
            ];
            return texts[Math.min(strength, 5)] || '非常弱';
        }
    </script>
</body>
</html>