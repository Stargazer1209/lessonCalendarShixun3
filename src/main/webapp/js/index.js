/**
 * 课灵通首页JavaScript脚本
 */

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', function() {
    // 获取登录状态
    const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
    const contextPath = document.body.getAttribute('data-context');
    
    if (isLoggedIn) {
        // 已登录用户加载统计数据
        loadUserStats();
    }
});

/**
 * 加载用户统计数据
 */
function loadUserStats() {
    // 这里可以通过AJAX从后端获取真实数据
    // 目前使用模拟数据
    document.getElementById('totalCourses').textContent = '12';
    document.getElementById('thisWeekCourses').textContent = '8';
    document.getElementById('todayCourses').textContent = '3';
    document.getElementById('completionRate').textContent = '85';
}

/**
 * 显示/隐藏系统信息
 */
function showSystemInfo() {
    const systemInfo = document.getElementById('systemInfo');
    if (systemInfo.style.display === 'none') {
        systemInfo.style.display = 'block';
    } else {
        systemInfo.style.display = 'none';
    }
}

/**
 * 测试数据库连接
 */
function testDatabase() {
    const contextPath = document.body.getAttribute('data-context');
    const statusDiv = document.getElementById('dbStatus');
    
    statusDiv.innerHTML = '<div style="color: #666; padding: 10px;">正在测试数据库连接...</div>';

    fetch(contextPath + '/TestDatabaseServlet', {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(function(response) {
        return response.text();
    })
    .then(function(text) {
        const data = JSON.parse(text);

        if (data.status === 'success') {
            const userCountText = (typeof data.userCount !== 'undefined' && data.userCount !== -1) 
                ? data.userCount : '获取失败';
            
            statusDiv.innerHTML = createSuccessMessage(data, userCountText);
        } else {
            statusDiv.innerHTML = createErrorMessage(data);
        }
    })
    .catch(function(error) {
        statusDiv.innerHTML = createRequestErrorMessage(error);
    });
}

/**
 * 创建成功消息HTML
 */
function createSuccessMessage(data, userCountText) {
    return `
        <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; border-left: 4px solid #28a745; margin-top: 10px;">
            <h4>✅ 数据库连接成功！</h4>
            <p><strong>数据库：</strong> ${data.database || '未知'}</p>
            <p><strong>版本：</strong> ${data.version || '未知'}</p>
            <p><strong>用户数量：</strong> ${userCountText}</p>
            <p><strong>测试时间：</strong> ${data.timestamp || '未知'}</p>
        </div>
    `;
}

/**
 * 创建错误消息HTML
 */
function createErrorMessage(data) {
    return `
        <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; border-left: 4px solid #dc3545; margin-top: 10px;">
            <h4>❌ 数据库连接失败</h4>
            <p><strong>错误信息：</strong> ${data.message || '未知错误'}</p>
            <p><strong>时间：</strong> ${data.timestamp || '未知'}</p>
        </div>
    `;
}

/**
 * 创建请求错误消息HTML
 */
function createRequestErrorMessage(error) {
    return `
        <div style="background: #fff3cd; color: #856404; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107; margin-top: 10px;">
            <h4>⚠️ 请求失败</h4>
            <p><strong>错误：</strong> ${error.message}</p>
        </div>
    `;
}

/**
 * 页面跳转功能
 */
function navigateTo(url) {
    window.location.href = url;
}

/**
 * 工具函数：格式化日期
 */
function formatDate(date) {
    const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric',
        weekday: 'long'
    };
    return new Intl.DateTimeFormat('zh-CN', options).format(date);
}