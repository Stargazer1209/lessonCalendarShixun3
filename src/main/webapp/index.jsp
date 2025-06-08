<!-- filepath: d:\0PROJECTS\BTBU-INCLASS\lessonCalendarShixun3\src\main\webapp\index.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.schedule.model.User" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    boolean isLoggedIn = (currentUser != null);
%>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>课灵通 - 课程表管理系统</title>
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
                    color: #333;
                }

                /* 导航栏样式 */
                .navbar {
                    background: rgba(255, 255, 255, 0.95);
                    backdrop-filter: blur(10px);
                    box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
                    padding: 1rem 0;
                    position: sticky;
                    top: 0;
                    z-index: 1000;
                }

                .nav-container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 0 20px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .nav-brand {
                    font-size: 1.8rem;
                    font-weight: bold;
                    color: #4CAF50;
                    text-decoration: none;
                }

                .nav-links {
                    display: flex;
                    list-style: none;
                    gap: 2rem;
                    align-items: center;
                }

                .nav-links a {
                    color: #333;
                    text-decoration: none;
                    font-weight: 500;
                    transition: color 0.3s;
                }

                .nav-links a:hover {
                    color: #4CAF50;
                }

                .nav-user {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .user-avatar {
                    width: 40px;
                    height: 40px;
                    border-radius: 50%;
                    background: #4CAF50;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-weight: bold;
                }

                .user-info {
                    display: flex;
                    flex-direction: column;
                }

                .user-name {
                    font-weight: 600;
                    color: #333;
                }

                .user-role {
                    font-size: 0.8rem;
                    color: #666;
                }

                /* 主要内容区域 */
                .main-content {
                    max-width: 1200px;
                    margin: 40px auto;
                    padding: 0 20px;
                }

                /* 欢迎区域 */
                .welcome-section {
                    background: white;
                    border-radius: 15px;
                    padding: 40px;
                    margin-bottom: 30px;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                    text-align: center;
                }

                .welcome-title {
                    font-size: 2.5rem;
                    color: #4CAF50;
                    margin-bottom: 10px;
                }

                .welcome-subtitle {
                    color: #666;
                    font-size: 1.1rem;
                    margin-bottom: 20px;
                }

                .welcome-message {
                    background: linear-gradient(135deg, #e8f5e8 0%, #f0f8ff 100%);
                    padding: 20px;
                    border-radius: 10px;
                    margin: 20px 0;
                }

                /* 快速操作区域 */
                .quick-actions {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                    margin-bottom: 30px;
                }

                .action-card {
                    background: white;
                    border-radius: 10px;
                    padding: 30px;
                    text-align: center;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                    transition: transform 0.3s, box-shadow 0.3s;
                    cursor: pointer;
                }

                .action-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                }

                .action-icon {
                    font-size: 3rem;
                    margin-bottom: 15px;
                }

                .action-title {
                    font-size: 1.2rem;
                    font-weight: 600;
                    margin-bottom: 10px;
                    color: #333;
                }

                .action-desc {
                    color: #666;
                    font-size: 0.9rem;
                    line-height: 1.4;
                }

                /* 统计信息区域 */
                .stats-section {
                    background: white;
                    border-radius: 15px;
                    padding: 30px;
                    margin-bottom: 30px;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                }

                .stats-title {
                    font-size: 1.5rem;
                    font-weight: 600;
                    margin-bottom: 20px;
                    color: #333;
                }

                .stats-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 20px;
                }

                .stat-item {
                    text-align: center;
                    padding: 20px;
                    background: #f8f9fa;
                    border-radius: 10px;
                }

                .stat-number {
                    font-size: 2rem;
                    font-weight: bold;
                    color: #4CAF50;
                    margin-bottom: 5px;
                }

                .stat-label {
                    color: #666;
                    font-size: 0.9rem;
                }

                /* 按钮样式 */
                .btn {
                    display: inline-block;
                    padding: 12px 24px;
                    background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
                    color: white;
                    text-decoration: none;
                    border-radius: 8px;
                    font-weight: 500;
                    transition: all 0.3s;
                    border: none;
                    cursor: pointer;
                    font-size: 16px;
                }

                .btn:hover {
                    transform: translateY(-2px);
                    box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
                }

                .btn-secondary {
                    background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
                }

                .btn-secondary:hover {
                    box-shadow: 0 5px 15px rgba(33, 150, 243, 0.3);
                }

                .btn-danger {
                    background: linear-gradient(135deg, #f44336 0%, #d32f2f 100%);
                }

                .btn-danger:hover {
                    box-shadow: 0 5px 15px rgba(244, 67, 54, 0.3);
                }

                /* 响应式设计 */
                @media (max-width: 768px) {
                    .nav-container {
                        flex-direction: column;
                        gap: 1rem;
                    }

                    .nav-links {
                        flex-wrap: wrap;
                        justify-content: center;
                    }

                    .main-content {
                        margin: 20px auto;
                        padding: 0 15px;
                    }

                    .welcome-section {
                        padding: 30px 20px;
                    }

                    .welcome-title {
                        font-size: 2rem;
                    }

                    .quick-actions {
                        grid-template-columns: 1fr;
                    }

                    .stats-grid {
                        grid-template-columns: repeat(2, 1fr);
                    }
                }

                @media (max-width: 480px) {
                    .stats-grid {
                        grid-template-columns: 1fr;
                    }
                }

                /* 登录提示区域 */
                .login-prompt {
                    background: white;
                    border-radius: 15px;
                    padding: 40px;
                    text-align: center;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                }

                .login-prompt h2 {
                    color: #333;
                    margin-bottom: 20px;
                }

                .login-prompt p {
                    color: #666;
                    margin-bottom: 30px;
                    line-height: 1.6;
                }

                .login-actions {
                    display: flex;
                    gap: 15px;
                    justify-content: center;
                    flex-wrap: wrap;
                }
            </style>        </head>


        <body data-logged-in="<%= isLoggedIn %>" data-context="<%= request.getContextPath() %>">
                <!-- 导航栏 -->
                <nav class="navbar">
                    <div class="nav-container">
                        <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
                            🎓 课灵通
                        </a>

                        <% if (isLoggedIn) { %>
                            <!-- 已登录用户的导航菜单 -->                            <ul class="nav-links">
                                <li><a href="<%= request.getContextPath() %>/index.jsp">首页</a></li>
                                <li><a href="ViewScheduleServlet">我的课表</a></li>
                                <li><a href="add-course.jsp">添加课程</a></li>
                                <li><a href="ViewScheduleServlet">课程管理</a></li>
                            </ul>

                            <div class="nav-user">
                                <div class="user-avatar">
                                    <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                                </div>                                <div class="user-info">
                                    <div class="user-name">
                                        <%= currentUser.getFullName() %>
                                    </div>                                    <div class="user-role">
                                        <%
                                            String role = currentUser.getRole();
                                            String roleDisplay = "未知角色";
                                            if ("admin".equals(role)) {
                                                roleDisplay = "管理员";
                                            } else if ("teacher".equals(role)) {
                                                roleDisplay = "教师";
                                            } else if ("student".equals(role)) {
                                                roleDisplay = "学生";
                                            }
                                        %>
                                        <%= roleDisplay %>
                                    </div>
                                </div>                            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger"
                                style="margin-left: 15px;">退出</a>
                            </div>
                            <% } else { %>                            <!-- 未登录用户的导航菜单 -->
                            <ul class="nav-links">
                                <li><a href="<%= request.getContextPath() %>/index.jsp">首页</a></li>
                                <li><a href="<%= request.getContextPath() %>/LoginServlet">登录</a></li>
                                <li><a href="<%= request.getContextPath() %>/RegisterServlet">注册</a></li>
                            </ul>
                                <% } %>
                    </div>
                </nav>

                <!-- 主要内容区域 -->
                <div class="main-content">
                    <% if (isLoggedIn) { %>
                        <!-- 已登录用户的首页 -->
                        <div class="welcome-section">
                            <h1 class="welcome-title">欢迎回来，<%= currentUser.getFullName() %>！</h1>
                            <p class="welcome-subtitle">您的智能课程表管理助手</p>
                            <div class="welcome-message">
                                <p>📅 今天是 <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 EEEE").format(new
                                        java.util.Date()) %>
                                </p>
                                <p>🎯 让我们开始高效的学习计划管理吧！</p>
                            </div>
                        </div>

                        <!-- 快速操作区域 -->
                        <div class="quick-actions">
                            <div class="action-card"
                                onclick="location.href='<%= request.getContextPath() %>/ViewScheduleServlet'">
                                <div class="action-icon">📅</div>
                                <div class="action-title">查看课表</div>
                                <div class="action-desc">查看和管理您的完整课程安排</div>
                            </div>

                            <div class="action-card"
                                onclick="location.href='<%= request.getContextPath() %>/add-course.jsp'">
                                <div class="action-icon">➕</div>
                                <div class="action-title">添加课程</div>
                                <div class="action-desc">快速添加新的课程到您的课表</div>
                            </div>

                            <div class="action-card"
                                onclick="location.href='<%= request.getContextPath() %>/course-list.jsp'">
                                <div class="action-icon">📚</div>
                                <div class="action-title">课程管理</div>
                                <div class="action-desc">编辑、删除和管理您的所有课程</div>
                            </div>

                            <div class="action-card"
                                onclick="location.href='<%= request.getContextPath() %>/profile.jsp'">
                                <div class="action-icon">👤</div>
                                <div class="action-title">个人设置</div>
                                <div class="action-desc">修改个人信息和系统偏好设置</div>
                            </div>
                        </div>

                        <!-- 统计信息区域 -->
                        <div class="stats-section">
                            <h2 class="stats-title">📊 数据统计</h2>
                            <div class="stats-grid">
                                <div class="stat-item">
                                    <div class="stat-number" id="totalCourses">--</div>
                                    <div class="stat-label">总课程数</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number" id="thisWeekCourses">--</div>
                                    <div class="stat-label">本周课程</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number" id="todayCourses">--</div>
                                    <div class="stat-label">今日课程</div>
                                </div>
                                <div class="stat-item">
                                    <div class="stat-number" id="completionRate">--%</div>
                                    <div class="stat-label">完成度</div>
                                </div>
                            </div>
                        </div>

                        <% } else { %>
                            <!-- 未登录用户的首页 -->
                            <div class="login-prompt">
                                <h2>🎓 欢迎使用课灵通</h2>
                                <p>课灵通是一个智能化的课程表管理系统，帮助您轻松管理学习计划。</p>
                                <p>支持课程添加、时间冲突检测、可视化课表显示等功能。</p>                            <div class="login-actions">
                                <a href="<%= request.getContextPath() %>/LoginServlet" class="btn">立即登录</a>
                                <a href="<%= request.getContextPath() %>/RegisterServlet"
                                    class="btn btn-secondary">免费注册</a>
                                <a href="#" class="btn btn-secondary" onclick="showSystemInfo()">系统信息</a>
                            </div>

                                <!-- 系统信息区域（默认隐藏） -->
                                <div id="systemInfo" style="display: none; margin-top: 30px; text-align: left;">
                                    <h3>🔧 系统环境信息</h3>
                                    <div
                                        style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin-top: 15px;">
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

                                        <div style="margin-top: 20px;">
                                            <a href="#" class="btn" onclick="testDatabase()">🔍 测试数据库连接</a>
                                        </div>
                                        <div id="dbStatus" style="margin-top: 15px;"></div>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                </div>

                <script type="text/javascript">
                    // 获取登录状态
                    const isLoggedIn = document.body.getAttribute('data-logged-in') === 'true';
                    const contextPath = document.body.getAttribute('data-context');

                    if (isLoggedIn) {
                        // 已登录用户的 JavaScript 代码
                        function loadUserStats() {
                            document.getElementById('totalCourses').textContent = '12';
                            document.getElementById('thisWeekCourses').textContent = '8';
                            document.getElementById('todayCourses').textContent = '3';
                            document.getElementById('completionRate').textContent = '85';
                        }

                        document.addEventListener('DOMContentLoaded', function () {
                            loadUserStats();
                        });
                    } else {
                        // 未登录用户的 JavaScript 代码
                        function showSystemInfo() {
                            const systemInfo = document.getElementById('systemInfo');
                            if (systemInfo.style.display === 'none') {
                                systemInfo.style.display = 'block';
                            } else {
                                systemInfo.style.display = 'none';
                            }
                        }
                    }

                    // 通用的数据库测试功能
                    function testDatabase() {
                        var statusDiv = document.getElementById('dbStatus');
                        statusDiv.innerHTML = '<div style="color: #666; padding: 10px;">正在测试数据库连接...</div>';

                        fetch(contextPath + '/TestDatabaseServlet', {
                            method: 'GET',
                            headers: {
                                'Content-Type': 'application/json'
                            }
                        })
                            .then(function (response) {
                                return response.text();
                            })
                            .then(function (text) {
                                var data = JSON.parse(text);

                                if (data.status === 'success') {
                                    var userCountText = (typeof data.userCount !== 'undefined' && data.userCount !== -1) ? data.userCount : '获取失败';
                                    statusDiv.innerHTML =
                                        '<div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; border-left: 4px solid #28a745; margin-top: 10px;">' +
                                        '<h4>✅ 数据库连接成功！</h4>' +
                                        '<p><strong>数据库：</strong> ' + (data.database || '未知') + '</p>' +
                                        '<p><strong>版本：</strong> ' + (data.version || '未知') + '</p>' +
                                        '<p><strong>用户数量：</strong> ' + userCountText + '</p>' +
                                        '<p><strong>测试时间：</strong> ' + (data.timestamp || '未知') + '</p>' +
                                        '</div>';
                                } else {
                                    statusDiv.innerHTML =
                                        '<div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; border-left: 4px solid #dc3545; margin-top: 10px;">' +
                                        '<h4>❌ 数据库连接失败</h4>' +
                                        '<p><strong>错误信息：</strong> ' + (data.message || '未知错误') + '</p>' +
                                        '<p><strong>时间：</strong> ' + (data.timestamp || '未知') + '</p>' +
                                        '</div>';
                                }
                            })
                            .catch(function (error) {
                                statusDiv.innerHTML =
                                    '<div style="background: #fff3cd; color: #856404; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107; margin-top: 10px;">' +
                                    '<h4>⚠️ 请求失败</h4>' +
                                    '<p><strong>错误：</strong> ' + error.message + '</p>' +
                                    '</div>';
                            });
                    }
                </script>
        </body>

        </html>