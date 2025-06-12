// 添加课程页面JavaScript功能

// 表单验证
document.getElementById('addCourseForm').addEventListener('submit', function(e) {
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
});

// 自动设置结束时间（开始时间+2小时）
document.getElementById('startTime').addEventListener('change', function() {
    const startTime = this.value;
    const endTimeInput = document.getElementById('endTime');
    
    if (startTime && !endTimeInput.value) {
        const start = new Date('2000-01-01 ' + startTime);
        start.setHours(start.getHours() + 2);
        const endTime = start.toTimeString().slice(0, 5);
        endTimeInput.value = endTime;
    }
});
