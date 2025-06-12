// 注册页面JavaScript功能

// 防止重复提交的标记
let isSubmitting = false;

// 实时验证
document.getElementById('username').addEventListener('input', validateUsername);
document.getElementById('email').addEventListener('input', validateEmail);
document.getElementById('fullName').addEventListener('input', validateFullName);
document.getElementById('password').addEventListener('input', validatePassword);
document.getElementById('confirmPassword').addEventListener('input', validateConfirmPassword);

// 表单提交验证和防重复提交
document.getElementById('registerForm').addEventListener('submit', function(e) {
    // 防止重复提交
    if (isSubmitting) {
        e.preventDefault();
        return false;
    }

    let isValid = true;
    const registerBtn = document.getElementById('registerBtn');

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
        return false;
    }

    // 验证通过，设置提交状态
    isSubmitting = true;
    registerBtn.disabled = true;
    registerBtn.textContent = '注册中...';

    // 如果提交失败（比如网络错误），8秒后恢复按钮状态
    setTimeout(function() {
        if (isSubmitting) {
            isSubmitting = false;
            registerBtn.disabled = false;
            registerBtn.textContent = '注册';
        }
    }, 8000);
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
