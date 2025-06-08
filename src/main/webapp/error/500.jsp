<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>服务器错误 - 课灵通</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }
        
        .error-container {
            background: white;
            border-radius: 20px;
            padding: 50px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 650px;
            width: 90%;
        }
        
        .error-code {
            font-size: 8rem;
            font-weight: bold;
            color: #f44336;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 1.1rem;
            color: #666;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .comfort-message {
            background: #f8f5f0;
            padding: 20px;
            border-radius: 10px;
            margin: 30px 0;
            border-left: 4px solid #ff9800;
        }
        
        .comfort-message p {
            color: #ff6f00;
            font-weight: 500;
            font-size: 1.1rem;
        }
        
        .possible-reasons {
            text-align: left;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        
        .possible-reasons h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }
        
        .possible-reasons ul {
            list-style: none;
            padding-left: 0;
        }
        
        .possible-reasons li {
            margin-bottom: 10px;
            padding-left: 25px;
            position: relative;
            color: #666;
        }
        
        .possible-reasons li:before {
            content: "⚠️";
            position: absolute;
            left: 0;
        }
        
        .tech-info {
            background: #e3f2fd;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #2196F3;
            text-align: left;
        }
        
        .tech-info h3 {
            color: #1976D2;
            margin-bottom: 15px;
            font-size: 1.2rem;
        }
        
        .tech-info p {
            color: #1565C0;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }
        
        .btn-secondary {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
        }
        
        .btn-secondary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
        }
        
        .btn-refresh {
            background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%);
            color: white;
        }
        
        .btn-refresh:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255, 152, 0, 0.3);
        }
        
        .contact-info {
            background: #ffebee;
            border: 1px solid #ffcdd2;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
        }
        
        .contact-info h3 {
            color: #d32f2f;
            margin-bottom: 15px;
        }
        
        .contact-info p {
            color: #c62828;
            margin-bottom: 5px;
        }
        
        .urgent-note {
            background: #fff3e0;
            border: 2px solid #ff9800;
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }
        
        .urgent-note h4 {
            color: #ef6c00;
            margin-bottom: 10px;
        }
        
        .urgent-note p {
            color: #e65100;
            font-size: 0.95rem;
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 30px 20px;
            }
            
            .error-code {
                font-size: 6rem;
            }
            
            .error-title {
                font-size: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 250px;
            }
        }
    </style>
</head>
<body>
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