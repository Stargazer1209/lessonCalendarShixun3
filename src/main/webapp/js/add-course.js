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

// 文件选择预览
document.getElementById('qrImage').addEventListener('change', function(e) {
    const file = e.target.files[0];
    const label = document.querySelector('.file-label');
    
    if (file) {
        label.textContent = `📷 ${file.name}`;
        label.style.background = '#28a745';
    } else {
        label.textContent = '📂 选择二维码图片';
        label.style.background = '#6c757d';
    }
});

// 二维码导入表单验证
document.getElementById('qrImportForm').addEventListener('submit', function(e) {
    const fileInput = document.getElementById('qrImage');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        alert('请选择要导入的二维码图片！');
        e.preventDefault();
        return false;
    }
    
    const file = fileInput.files[0];
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
    
    if (!allowedTypes.includes(file.type)) {
        alert('请选择有效的图片格式（JPG、PNG、GIF）！');
        e.preventDefault();
        return false;
    }
    
    if (file.size > 5 * 1024 * 1024) { // 5MB
        alert('图片文件大小不能超过5MB！');
        e.preventDefault();
        return false;
    }
    
    return confirm('确定要导入此二维码中的课程数据吗？');
});