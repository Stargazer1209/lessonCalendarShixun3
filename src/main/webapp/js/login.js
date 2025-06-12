// 登录页面JavaScript功能

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
