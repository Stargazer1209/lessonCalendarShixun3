<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - 课灵通</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css" charset="UTF-8">
</head>
<body>
    <div class="error-container">
        <div class="error-code">404</div>
        <h1 class="error-title">页面走丢了！</h1>
        <p class="error-message">
            抱歉，您访问的页面似乎不存在或已被移动到其他位置。
        </p>
        
        <div class="comfort-message">
            <p>😊 别担心，这种情况很常见！让我们帮您找到正确的方向。</p>
        </div>
        
        <div class="possible-reasons">
            <h3>🤔 可能的原因：</h3>
            <ul>
                <li>URL地址输入错误或拼写有误</li>
                <li>您点击的链接已过期或失效</li>
                <li>页面已被删除或重新组织</li>
                <li>您没有访问该页面的权限</li>
                <li>服务器临时维护中</li>
            </ul>
        </div>
        
        <div class="action-buttons">
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">🏠 返回首页</a>
            <a href="javascript:history.back()" class="btn btn-secondary">↩️ 返回上页</a>
        </div>
        
        <div class="contact-info">
            <h3>📞 需要帮助？</h3>
            <p><strong>技术支持邮箱：</strong> support@kelingtong.com</p>
            <p><strong>客服热线：</strong> 400-123-4567</p>
            <p><strong>在线时间：</strong> 周一至周五 9:00-18:00</p>
            <p>我们的技术团队会尽快为您解决问题！</p>
        </div>
    </div>
</body>
</html>