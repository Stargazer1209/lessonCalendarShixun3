<%-- filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\webapp\login.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 - 课灵通</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }
        .logo {
            text-align: center;
            margin-bottom: 30px;
        }
        .logo h1 {
            color: #333;
            margin: 0;
            font-size: 2.5em;
        }
        .logo p {
            color: #666;
            margin: 5px 0 0 0;
            font-size: 0.9em;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .btn {
            width: 100%;
            background: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn:hover {
            background: #45a049;
        }
        .links {
            text-align: center;
            margin-top: 20px;
        }
        .links a {
            color: #667eea;
            text-decoration: none;
            margin: 0 10px;
        }
        .links a:hover {
            text-decoration: underline;
        }
        .alert {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #dc3545;
        }
        .demo-info {
            background: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #17a2b8;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <h1>🎓 课灵通</h1>
            <p>支持文本导入导出离线交互的可视化排课引擎</p>
        </div>
        
        <div class="demo-info">
            <strong>🚧 开发阶段提示</strong><br>
            当前为阶段一环境测试版本。<br>
            登录功能将在阶段二开发。<br>
            <strong>演示账户</strong>：admin / password123
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert">
                登录失败：用户名或密码错误
            </div>
        <% } %>
        
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">用户名</label>
                <input type="text" id="username" name="username" 
                       placeholder="请输入用户名" required 
                       value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
            </div>
            
            <div class="form-group">
                <label for="password">密码</label>
                <input type="password" id="password" name="password" 
                       placeholder="请输入密码" required>
            </div>
            
            <button type="submit" class="btn">登录</button>
        </form>
        
        <div class="links">
            <a href="register.jsp">注册账户</a>
            <a href="index.jsp">返回首页</a>
        </div>
        
        <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee; font-size: 12px; color: #666; text-align: center;">
            <p><strong>开发状态</strong>：阶段一 - 环境配置</p>
            <p><strong>当前时间</strong>：<%= new java.util.Date() %></p>
        </div>
    </div>
</body>
</html>
