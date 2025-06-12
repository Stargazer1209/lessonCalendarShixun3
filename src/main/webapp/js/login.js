// 登录页面JavaScript功能

// 防止重复提交的标记
let isSubmitting = false;

// 表单验证和提交处理
document.getElementById('loginForm').addEventListener('submit', function(e) {
    // 防止重复提交
    if (isSubmitting) {
        e.preventDefault();
        return false;
    }

    const username = document.getElementById('username');
    const password = document.getElementById('password');
    const loginBtn = document.getElementById('loginBtn');
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
    }    // 验证密码
    if (!password.value) {
        showError('password', '请输入密码');
        isValid = false;
    } else if (password.value.length < 8) {
        showError('password', '密码至少8个字符, 包含字母和数字');
        isValid = false;
    }

    if (!isValid) {
        e.preventDefault();
        return false;
    }

    // 验证通过，设置提交状态
    isSubmitting = true;
    loginBtn.disabled = true;
    loginBtn.textContent = '登录中...';

    // 如果提交失败（比如网络错误），5秒后恢复按钮状态
    setTimeout(function() {
        if (isSubmitting) {
            isSubmitting = false;
            loginBtn.disabled = false;
            loginBtn.textContent = '登录';
        }
    }, 5000);
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

// 支持回车键提交表单 - 移除这个部分，因为HTML表单本身就支持回车提交
// 删除原来可能冲突的回车键处理逻辑
