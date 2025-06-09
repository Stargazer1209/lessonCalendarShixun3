<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
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
    
    <!-- 引入CSS文件 -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css" charset="UTF-8">
</head>

<body data-logged-in="<%= isLoggedIn %>" data-context="<%= request.getContextPath() %>">
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
                🎓 课灵通
            </a>

            <% if (isLoggedIn) { %>
                <!-- 已登录用户的导航菜单 -->
                <ul class="nav-links">
                    <li><a href="<%= request.getContextPath() %>/index.jsp">首页</a></li>
                    <li><a href="ViewScheduleServlet">我的课表</a></li>
                    <li><a href="add-course.jsp">添加课程</a></li>
                    <li><a href="ViewScheduleServlet">课程管理</a></li>
                </ul>

                <div class="nav-user">
                    <div class="user-avatar">
                        <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                    </div>
                    <div class="user-info">
                        <div class="user-name">
                            <%= currentUser.getFullName() %>
                        </div>
                        <div class="user-role">
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
                    </div>
                    <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger"
                        style="margin-left: 15px;">退出</a>
                </div>
            <% } else { %>
                <!-- 未登录用户的导航菜单 -->
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
                    <p>📅 今天是 <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 EEEE").format(new java.util.Date()) %></p>
                    <p>🎯 让我们开始高效的学习计划管理吧！</p>
                </div>
            </div>

            <!-- 快速操作区域 -->
            <div class="quick-actions">
                <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/ViewScheduleServlet'">
                    <div class="action-icon">📅</div>
                    <div class="action-title">查看课表</div>
                    <div class="action-desc">查看和管理您的完整课程安排</div>
                </div>

                <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/add-course.jsp'">
                    <div class="action-icon">➕</div>
                    <div class="action-title">添加课程</div>
                    <div class="action-desc">快速添加新的课程到您的课表</div>
                </div>

                <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/course-list.jsp'">
                    <div class="action-icon">📚</div>
                    <div class="action-title">课程管理</div>
                    <div class="action-desc">编辑、删除和管理您的所有课程</div>
                </div>

                <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/profile.jsp'">
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
                <p>支持课程添加、时间冲突检测、可视化课表显示等功能。</p>
                <div class="login-actions">
                    <a href="<%= request.getContextPath() %>/LoginServlet" class="btn">立即登录</a>
                    <a href="<%= request.getContextPath() %>/RegisterServlet" class="btn btn-secondary">免费注册</a>
                    <a href="#" class="btn btn-secondary" onclick="showSystemInfo()">系统信息</a>
                </div>

                <!-- 系统信息区域（默认隐藏） -->
                <div id="systemInfo" style="display: none; margin-top: 30px; text-align: left;">
                    <h3>🔧 系统环境信息</h3>
                    <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin-top: 15px;">
                        <p><strong>服务器时间：</strong> <%= new java.util.Date() %></p>
                        <p><strong>字符编码：</strong> <%= request.getCharacterEncoding() %></p>
                        <p><strong>上下文路径：</strong> <%= request.getContextPath() %></p>
                        <p><strong>服务器信息：</strong> <%= application.getServerInfo() %></p>

                        <div style="margin-top: 20px;">
                            <a href="#" class="btn" onclick="testDatabase()">🔍 测试数据库连接</a>
                        </div>
                        <div id="dbStatus" style="margin-top: 15px;"></div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- 引入JavaScript文件 -->
    <script charset="utf-8" src="<%= request.getContextPath() %>/js/index.js"></script>
</body>

</html>