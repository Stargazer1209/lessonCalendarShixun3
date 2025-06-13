<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.schedule.model.User" %>
<%@ page import="java.util.*" %>
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
    <title>管理员面板 - 课程表管理系统</title>    <link rel="stylesheet" href="css/index.css">
    <style>
        .recent-activity {
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .user-list {
            list-style: none;
            padding: 0;
        }

        .user-list li {
            padding: 0.8rem 0;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-list li:last-child {
            border-bottom: none;
        }

        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .role-admin {
            background: #e74c3c;
            color: white;
        }

        .role-teacher {
            background: #f39c12;
            color: white;
        }

        .role-student {
            background: #27ae60;
            color: white;
        }
    </style>
</head>

<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/admin" class="nav-brand">
                🎓 课灵通-管理员面板
            </a>
            <ul class="nav-links">
                <li><a href="<%= request.getContextPath() %>/admin/users" class="action-btn">用户管理</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/courses" class="action-btn">课程管理</a></li>
                <li><a href="<%= request.getContextPath() %>/admin/stats" class="action-btn">统计报告</a></li>
            </ul>

            <div class="nav-user">
                <div class="user-avatar" onclick="location.href='<%= request.getContextPath() %>/profile.jsp'">
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
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger" style="margin-left: 15px;">退出</a>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <div class="welcome-section">
            <h1 class="welcome-title">欢迎，<%= ((User)session.getAttribute("user")).getFullName() %></h1>
            <div class="welcome-message">
                <p>📅 今天是 <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 EEEE").format(new java.util.Date()) %></p>
            </div>
        </div>

        <!-- 错误消息显示 -->
        <%
            if (request.getAttribute("error") != null) {
        %>
        <div class="error-message">
            <strong>错误：</strong>
            <%= request.getAttribute("error") %>
        </div>
        <%
            }
        %>        
        
        <!-- 快速操作区域 -->
        <div class="quick-actions">
            <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/admin/users'">
                <div class="action-icon">👤</div>
                <div class="action-title">用户管理</div>
            </div>

            <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/admin/courses'">
                <div class="action-icon">📚</div>
                <div class="action-title">课程管理</div>
            </div>

            <div class="action-card" onclick="location.href='<%= request.getContextPath() %>/admin/stats'">
                <div class="action-icon">📊</div>
                <div class="action-title">统计报告</div>
            </div>
        </div>

        <!-- 统计信息区域 -->
        <div class="stats-section">
            <%
                Map<String, Integer> userStats = (Map<String, Integer>) request.getAttribute("userStats");
                Map<String, Object> courseStats = (Map<String, Object>) request.getAttribute("courseStats");
                
                int totalUsers = userStats != null ? userStats.getOrDefault("total", 0) : 0;
                int totalCourses = 0;
                if (courseStats != null) {
                    totalCourses = (Integer) courseStats.getOrDefault("totalCourses", 0);
                }
            %>
            <h2 class="stats-title" onclick="location.href='<%= request.getContextPath() %>/admin/stats'" style="cursor: pointer;">📊 数据统计</h2>
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number" id="totalUsers">
                        <%= totalUsers %>
                    </div>
                    <div class="stat-label">总用户数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="totalCourses">
                        <%= totalCourses %>
                    </div>
                    <div class="stat-label">总课程数</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="totalStudents">
                        <%= userStats != null ? userStats.getOrDefault("student", 0) : 0 %>
                    </div>
                    <div class="stat-label">学生数量</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number" id="totalTeachers">
                        <%= userStats != null ? userStats.getOrDefault("teacher", 0) : 0 %>
                    </div>
                    <div class="stat-label">教师数量</div>
                </div>
            </div>
        </div>

        <!-- 最近用户活动 -->
        <div class="recent-activity">
            <h3>最近注册用户</h3>
            <%
                List<User> allUsers = (List<User>) request.getAttribute("allUsers");
                if (allUsers != null && !allUsers.isEmpty()) {
            %>
            <ul class="user-list">
                <%
                    int displayCount = Math.min(3, allUsers.size());
                    for (int i = 0; i < displayCount; i++) {
                        User user = allUsers.get(i);
                %>
                <li>
                    <div class="nav-user">
                        <div class="user-avatar" onclick="location.href='admin/users?action=edit&userId=<%= user.getUserId() %>'">
                            <%= user.getFullName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="user-info">
                            <div class="user-name">
                                <%= user.getFullName() %>
                            </div>
                            <small>
                                <%= user.getEmail() %>
                            </small>
                        </div>
                    </div>
                    <span class="role-badge role-<%= user.getRole() %>">
                        <%= "admin".equals(user.getRole()) ? "管理员" : "teacher".equals(user.getRole()) ? "教师" : "学生" %>
                    </span>
                </li>
                <%
                    }
                %>
            </ul>
            <%
                } else {
            %>
            <p>暂无用户数据</p>
            <%
                }
            %>
        </div>
    </div>
</body>

</html>