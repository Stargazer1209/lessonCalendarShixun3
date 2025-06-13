// 课程管理页面JavaScript功能

// 确认删除功能
function confirmDelete(courseName) {
    return confirm('确定要删除课程 "' + courseName + '" 吗？此操作不可撤销。');
}

// 自动隐藏成功消息
setTimeout(function() {
    const successAlert = document.querySelector('.alert.success');
    if (successAlert) {
        successAlert.style.opacity = '0';
        setTimeout(function() {
            successAlert.remove();
        }, 300);
    }
}, 3000);

/**
 * 导出单个课程二维码
 */
function exportCourseQR(courseId) {
    window.open(`QRCodeServlet?action=single&courseId=${courseId}`, '_blank');
}

/**
 * 导出所有课程二维码
 */
function exportAllCoursesQR() {
    window.open('QRCodeServlet?action=all', '_blank');
}