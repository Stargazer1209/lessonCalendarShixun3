// 显示角色信息
function showRoleInfo() {
    const role = document.getElementById('role').value;
    const roleInfo = document.getElementById('roleInfo');
    const roleDescription = document.getElementById('roleDescription');

    const descriptions = {
        'student': '<strong>学生权限：</strong><ul><li>管理个人课程表</li><li>查看个人统计信息</li><li>修改个人资料</li></ul>',
        'teacher': '<strong>教师权限：</strong><ul><li>管理个人课程表</li><li>查看个人统计信息</li><li>修改个人资料</li></ul>',
        'admin': '<strong>管理员权限：</strong><ul><li>管理所有用户账户</li><li>管理所有课程数据</li><li>查看系统统计信息</li><li>系统配置和维护</li></ul><div style="color: #e74c3c; margin-top: 0.5rem;"><strong>警告：</strong>管理员权限较高，请谨慎分配！</div>'
    };

    roleDescription.innerHTML = descriptions[role] || '';
    roleInfo.style.display = 'block';
}        // 切换密码字段显示
function togglePasswordFields() {
    const changePassword = document.getElementById('changePassword');
    const passwordField = document.getElementById('passwordField');
    const confirmPasswordField = document.getElementById('confirmPasswordField');
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');

    if (changePassword.checked) {
        passwordField.style.display = 'block';
        confirmPasswordField.style.display = 'block';
        passwordInput.required = true;
        confirmPasswordInput.required = true;
    } else {
        passwordField.style.display = 'none';
        confirmPasswordField.style.display = 'none';
        passwordInput.required = false;
        confirmPasswordInput.required = false;
        passwordInput.value = '';
        confirmPasswordInput.value = '';
        // 清除错误信息
        document.getElementById('passwordError').textContent = '';
        document.getElementById('confirmPasswordError').textContent = '';
        document.getElementById('passwordStrength').textContent = '';
    }
}

// 表单验证
function validateForm() {
    const changePassword = document.getElementById('changePassword');
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (changePassword.checked) {
        if (password.length < 8) {
            alert('密码长度至少8位');
            return false;
        }

        if (password !== confirmPassword) {
            alert('两次输入的密码不一致');
            return false;
        }
    }

    return true;
}

// 页面加载时显示角色信息
document.addEventListener('DOMContentLoaded', function () {
    showRoleInfo();
});