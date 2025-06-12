<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>服务器错误 - 课灵通</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/error.css">
</head>
<body class="error-500">
    <div class="error-container">
        <div class="error-code">500</div>
        <h1 class="error-title">服务器开小差了！</h1>
        <p class="error-message">
            非常抱歉，服务器遇到了内部错误，无法完成您的请求。我们的技术团队已经收到通知并正在紧急处理。
        </p>
        
        <div class="comfort-message">
            <p>🛠️ 别着急！我们的工程师正在全力修复，通常几分钟内就能恢复正常。</p>
        </div>
        
        <div class="possible-reasons">
            <h3>🔧 可能的原因：</h3>
            <ul>
                <li>数据库连接异常或超时</li>
                <li>服务器负载过高，正在处理大量请求</li>
                <li>应用程序代码出现异常错误</li>
                <li>系统正在进行维护更新</li>
                <li>网络连接问题或服务依赖异常</li>
                <li>临时的配置文件错误</li>
            </ul>
        </div>
        
        <div class="tech-info">
            <h3>📋 技术信息：</h3>
            <p><strong>错误代码：</strong> HTTP 500 Internal Server Error</p>
            <p><strong>发生时间：</strong> <%= new java.util.Date() %></p>
            <p><strong>请求路径：</strong> <%= request.getRequestURI() %></p>
            <p><strong>用户代理：</strong> <%= request.getHeader("User-Agent") != null ? request.getHeader("User-Agent").substring(0, Math.min(50, request.getHeader("User-Agent").length())) + "..." : "未知" %></p>
        </div>
        
        <div class="action-buttons">
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">🏠 返回首页</a>
            <a href="javascript:location.reload()" class="btn btn-refresh">🔄 刷新页面</a>
            <a href="javascript:history.back()" class="btn btn-secondary">↩️ 返回上页</a>
        </div>
        
        <div class="urgent-note">
            <h4>🚨 问题持续？</h4>
            <p>如果多次刷新后问题仍然存在，请联系我们的技术支持团队。请保存此页面以便技术人员快速定位问题。</p>
        </div>
        
        <div class="contact-info">
            <h3>📞 技术支持：</h3>
            <p><strong>技术支持邮箱：</strong> emergency@kelingtong.com</p>
            <p><strong>紧急热线：</strong> 400-123-4567 (24小时)</p>
            <p><strong>QQ技术群：</strong> 123456789</p>
            <p><strong>微信客服：</strong> kelingtong_support</p>
        </div>
    </div>
</body>
</html>