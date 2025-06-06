<!-- filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\webapp\index.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>课灵通 - 课程表管理系统</title>
    <style>
        body {
            font-family: 'Microsoft YaHei', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        h1 {
            color: #4CAF50;
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1em;
        }

        .status {
            background: #e8f5e8;
            color: #2d5a2d;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border-left: 4px solid #4CAF50;
        }

        .info {
            background: #f0f8ff;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
        }

        .version-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin: 20px 0;
        }

        .version-item {
            background: #f9f9f9;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }

        .btn {
            background: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
            font-size: 16px;
            transition: background 0.3s;
            cursor: pointer;
        }

        .btn:hover {
            background: #45a049;
        }

        .btn-secondary {
            background: #2196F3;
        }

        .btn-secondary:hover {
            background: #1976D2;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>🎓 课灵通</h1>
        <div class="subtitle">支持文本导入导出离线交互的可视化排课引擎</div>

        <div class="status">
            ✅ Hello World - 系统环境测试成功！
        </div>

        <div class="info">
            <h3>📋 系统信息</h3>
            <div class="version-info">
                <div class="version-item">
                    <strong>Java版本</strong><br>
                    OpenJDK 11
                </div>
                <div class="version-item">
                    <strong>Servlet容器</strong><br>
                    Apache Tomcat 9
                </div>
                <div class="version-item">
                    <strong>数据库</strong><br>
                    MySQL 8
                </div>
                <div class="version-item">
                    <strong>技术栈</strong><br>
                    JSP + Servlet + JDBC
                </div>
            </div>
        </div>

        <div class="info">
            <h3>🔧 环境检查</h3>
            <p><strong>服务器时间：</strong>
                <%= new java.util.Date() %>
            </p>
            <p><strong>字符编码：</strong>
                <%= request.getCharacterEncoding() %>
            </p>
            <p><strong>上下文路径：</strong>
                <%= request.getContextPath() %>
            </p>
            <p><strong>服务器信息：</strong>
                <%= application.getServerInfo() %>
            </p>
        </div>

        <div style="margin-top: 30px;">
            <a href="#" class="btn" onclick="testDatabase()">🔍 测试数据库连接</a>
            <a href="login.jsp" class="btn btn-secondary">🚀 开始使用系统</a>
        </div>

        <div id="dbStatus" style="margin-top: 20px;"></div>
    </div>
    
    <script type="text/javascript">
        function testDatabase() {
            var statusDiv = document.getElementById('dbStatus');
            statusDiv.innerHTML = '<div style="color: #666;">正在测试数据库连接...</div>';

            // 发送AJAX请求测试数据库连接
            fetch('TestDatabaseServlet', {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
            .then(function(response) {
                console.log('Response status:', response.status);
                return response.text();
            })
            .then(function(text) {
                console.log('Raw response:', text);
                var data = JSON.parse(text);
                console.log('Parsed data:', data);

                if (data.status === 'success') {
                    var userCountText = (typeof data.userCount !== 'undefined' && data.userCount !== -1) ? data.userCount : '获取失败';
                    statusDiv.innerHTML = 
                        '<div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; border-left: 4px solid #28a745;">' +
                            '<h4>✅ 数据库连接成功！</h4>' +
                            '<p><strong>数据库：</strong> ' + (data.database || '未知') + '</p>' +
                            '<p><strong>版本：</strong> ' + (data.version || '未知') + '</p>' +
                            '<p><strong>用户数量：</strong> ' + userCountText + '</p>' +
                            '<p><strong>测试时间：</strong> ' + (data.timestamp || '未知') + '</p>' +
                            '<p><small>调试信息: ' + JSON.stringify(data) + '</small></p>' +
                        '</div>';
                } else {
                    statusDiv.innerHTML = 
                        '<div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; border-left: 4px solid #dc3545;">' +
                            '<h4>❌ 数据库连接失败</h4>' +
                            '<p><strong>错误信息：</strong> ' + (data.message || '未知错误') + '</p>' +
                            '<p><strong>时间：</strong> ' + (data.timestamp || '未知') + '</p>' +
                            '<small>请检查MySQL服务是否启动，JAR包是否正确配置</small>' +
                        '</div>';
                }
            })
            .catch(function(error) {
                console.error('Request failed:', error);
                statusDiv.innerHTML = 
                    '<div style="background: #fff3cd; color: #856404; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;">' +
                        '<h4>⚠️ 请求失败</h4>' +
                        '<p><strong>可能原因：</strong></p>' +
                        '<ul>' +
                            '<li>JAR包依赖未正确配置</li>' +
                            '<li>MySQL服务未启动</li>' +
                            '<li>数据库未初始化</li>' +
                            '<li>Servlet未正确编译</li>' +
                        '</ul>' +
                        '<p><strong>错误：</strong> ' + error.message + '</p>' +
                    '</div>';
            });
        }
    </script>
</body>
</html>