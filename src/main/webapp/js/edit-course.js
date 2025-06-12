// 编辑课程页面JavaScript功能

// 表单验证
document.getElementById('editCourseForm').addEventListener('submit', function(e) {
    const startTime = document.getElementById('startTime').value;
    const endTime = document.getElementById('endTime').value;
    const weekStart = parseInt(document.getElementById('weekStart').value);
    const weekEnd = parseInt(document.getElementById('weekEnd').value);

    // 验证时间
    if (startTime && endTime && startTime >= endTime) {
        alert('开始时间必须早于结束时间！');
        e.preventDefault();
        return false;
    }

    // 验证周次
    if (weekStart && weekEnd && weekStart > weekEnd) {
        alert('开始周次不能大于结束周次！');
        e.preventDefault();
        return false;
    }

    // 确认修改
    return confirm('确定要保存对课程的修改吗？');
});

// 实时字符计数
const descriptionTextarea = document.getElementById('description');
const helpText = descriptionTextarea.nextElementSibling;

descriptionTextarea.addEventListener('input', function() {
    const currentLength = this.value.length;
    const maxLength = 500;
    helpText.textContent = `已输入 ${currentLength}/${maxLength} 字符`;
    
    if (currentLength > maxLength * 0.9) {
        helpText.style.color = '#dc3545';
    } else {
        helpText.style.color = '#6c757d';
    }
});

// 页面加载时更新字符计数
descriptionTextarea.dispatchEvent(new Event('input'));
