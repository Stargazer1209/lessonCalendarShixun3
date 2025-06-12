// 个人设置页面JavaScript功能

// 表单验证
document.getElementById('profileForm').addEventListener('submit', function(e) {
    // 清空之前的错误信息
    clearAllErrors();
    
    let hasErrors = false;
    
    // 验证邮箱
    if (!validateEmail()) {
        hasErrors = true;
    }
    
    // 验证姓名
    if (!validateFullName()) {
        hasErrors = true;
    }
    
    // 验证密码（如果输入了密码）
    const password = document.getElementById('password').value;
    if (password.trim() !== '') {
        if (!validatePassword()) {
            hasErrors = true;
        }
        if (!validateConfirmPassword()) {
            hasErrors = true;
        }
    }
    
    if (hasErrors) {
        e.preventDefault();
        return false;
    }
    
    // 确认提交
    return confirm('确定要保存这些修改吗？');
});

// 实时验证邮箱
document.getElementById('email').addEventListener('blur', validateEmail);
document.getElementById('email').addEventListener('input', function() {
    clearMessages('email');
});

// 实时验证姓名
document.getElementById('fullName').addEventListener('blur', validateFullName);
document.getElementById('fullName').addEventListener('input', function() {
    clearMessages('fullName');
});

// 实时验证密码
document.getElementById('password').addEventListener('input', function() {
    const password = this.value;
    if (password.trim() !== '') {
        validatePassword();
        // 如果确认密码框有内容，也要重新验证
        const confirmPassword = document.getElementById('confirmPassword').value;
        if (confirmPassword.trim() !== '') {
            validateConfirmPassword();
        }
    } else {
        clearMessages('password');
        clearMessages('confirmPassword');
        document.getElementById('passwordStrength').textContent = '';
        document.getElementById('passwordStrength').className = 'password-strength';
    }
});

// 实时验证确认密码
document.getElementById('confirmPassword').addEventListener('input', function() {
    const password = document.getElementById('password').value;
    if (password.trim() !== '') {
        validateConfirmPassword();
    }
});

// 验证邮箱
function validateEmail() {
    const email = document.getElementById('email');
    const value = email.value.trim();

    if (!value) {
        showError('email', '请输入邮箱地址');
        return false;
    }

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(value)) {
        showError('email', '邮箱格式不正确');
        return false;
    }

    showSuccess('email', '邮箱格式正确');
    return true;
}

// 验证姓名
function validateFullName() {
    const fullName = document.getElementById('fullName');
    const value = fullName.value.trim();

    if (!value) {
        showError('fullName', '请输入姓名');
        return false;
    }

    if (value.length < 2) {
        showError('fullName', '姓名至少需要2个字符');
        return false;
    }

    if (value.length > 50) {
        showError('fullName', '姓名不能超过50个字符');
        return false;
    }

    showSuccess('fullName', '姓名格式正确');
    return true;
}

// 验证密码
function validatePassword() {
    const password = document.getElementById('password');
    const value = password.value;
    const strengthDiv = document.getElementById('passwordStrength');

    if (value.length === 0) {
        return true; // 密码为空是允许的（不修改密码）
    }

    if (value.length < 8) {
        showError('password', '密码至少需要8个字符');
        strengthDiv.textContent = '';
        strengthDiv.className = 'password-strength';
        return false;
    }

    if (value.length > 100) {
        showError('password', '密码不能超过100个字符');
        strengthDiv.textContent = '';
        strengthDiv.className = 'password-strength';
        return false;
    }

    if (!value.match(/[a-zA-Z]/) || !value.match(/[0-9]/)) {
        showError('password', '密码必须包含字母和数字');
        strengthDiv.textContent = '';
        strengthDiv.className = 'password-strength';
        return false;
    }

    // 计算密码强度
    let strength = 0;
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

// 验证确认密码
function validateConfirmPassword() {
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword');
    const value = confirmPassword.value;

    if (password.trim() === '' && value.trim() === '') {
        return true; // 都为空，允许
    }

    if (value !== password) {
        showError('confirmPassword', '两次输入的密码不一致');
        return false;
    }

    showSuccess('confirmPassword', '密码确认一致');
    return true;
}

// 显示错误信息
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

// 显示成功信息
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

// 清除消息
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

// 清除所有错误信息
function clearAllErrors() {
    const errorFields = ['email', 'fullName', 'password', 'confirmPassword'];
    errorFields.forEach(function(fieldName) {
        clearMessages(fieldName);
    });
}

// 页面加载完成后的初始化
document.addEventListener('DOMContentLoaded', function() {
    // 自动聚焦到邮箱输入框
    const emailField = document.getElementById('email');
    if (emailField) {
        emailField.focus();
    }
    
    // 如果页面有错误信息，滚动到顶部
    const alert = document.querySelector('.alert');
    if (alert) {
        alert.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
});
