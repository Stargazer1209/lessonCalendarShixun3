<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>页面未找到 - 课灵通</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            max-width: 600px;
            width: 90%;
        }
        
        .error-code {
            font-size: 2rem;
            font-weight: bold;
            color: #4CAF50;
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
            background: #f0f8ff;
            padding: 20px;
            border-radius: 10px;
            margin: 30px 0;
            border-left: 4px solid #4CAF50;
        }
        
        .comfort-message p {
            color: #4CAF50;
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
            content: "🔍";
            position: absolute;
            left: 0;
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
        
        .contact-info {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 10px;
            padding: 20px;
            margin-top: 30px;
        }
        
        .contact-info h3 {
            color: #856404;
            margin-bottom: 15px;
        }
        
        .contact-info p {
            color: #856404;
            margin-bottom: 5px;
        }
        
        @media (max-width: 768px) {
            .error-container {
                padding: 30px 20px;
            }
            
            .error-code {
                font-size: 1.5rem;
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