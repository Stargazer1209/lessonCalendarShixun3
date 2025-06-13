<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.schedule.model.User" %>
<%@ page import="com.schedule.model.Course" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    boolean isLoggedIn = (currentUser != null);
    
    // 获取统计数据
    Map<String, Integer> userStats = (Map<String, Integer>) request.getAttribute("userStats");
    Map<String, Object> courseStats = (Map<String, Object>) request.getAttribute("courseStats");
    Map<String, Object> detailedStats = (Map<String, Object>) request.getAttribute("detailedStats");
    List<User> recentUsers = (List<User>) request.getAttribute("recentUsers");
%>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>统计报告 - 管理员面板</title>
    <link rel="stylesheet" href="../css/index.css">
    <style>
        .main-content {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        h1 {
            text-align: center;
            color: white;
            margin-bottom: 2rem;
        }

        .stats-overview {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .stats-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: #4caf50;
            margin-bottom: 0.5rem;
        }

        .stats-label {
            color: #666;
            font-size: 1.1rem;
            font-weight: 500;
        }

        .stats-detail {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .stats-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: #333;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 0.5rem;
        }

        .distribution-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .distribution-item {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            border: 1px solid #e9ecef;
        }

        .distribution-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }

        .distribution-value {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }

        .progress-bar {
            width: 100%;
            height: 20px;
            background: #e9ecef;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 0.5rem;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(45deg, #4caf50, #45a049);
            transition: width 0.3s ease;
        }

        .recent-activity {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .user-list {
            list-style: none;
            padding: 0;
        }

        .user-list li {
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .user-list li:last-child {
            border-bottom: none;
        }

        .user-item {
            display: flex;
            align-items: center;
            gap: 1rem;
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

        .highlight-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .highlight-title {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .highlight-content {
            font-size: 1.1rem;
            line-height: 1.6;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .day-chart {
            display: flex;
            justify-content: space-between;
            align-items: end;
            height: 200px;
            margin-top: 1rem;
            padding: 1rem 0;
            border-bottom: 2px solid #e9ecef;
        }

        .day-bar {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            margin: 0 5px;
        }

        .bar {
            width: 30px;
            background: linear-gradient(45deg, #4caf50, #45a049);
            border-radius: 4px 4px 0 0;
            margin-bottom: 10px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .bar:hover {
            background: linear-gradient(45deg, #45a049, #388e3c);
            transform: scaleY(1.1);
        }

        .bar-label {
            font-size: 0.8rem;
            color: #666;
            font-weight: 500;
        }

        .bar-value {
            font-size: 0.7rem;
            color: #333;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .refresh-btn {
            position: fixed;
            bottom: 30px;
            right: 30px;
            background: linear-gradient(45deg, #4caf50, #45a049);
            color: white;
            border: none;
            border-radius: 50%;
            width: 60px;
            height: 60px;
            font-size: 1.5rem;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
            transition: all 0.3s ease;
        }

        .refresh-btn:hover {
            transform: scale(1.1) rotate(180deg);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
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
                <li><a href="<%= request.getContextPath() %>/admin/stats" class="action-btn active">统计报告</a></li>
            </ul>

            <div class="nav-user">
                <div class="user-avatar" onclick="location.href='<%= request.getContextPath() %>/profile.jsp'">
                    <%= currentUser.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <div class="user-info">
                    <div class="user-name">
                        <%= currentUser.getFullName() %>
                    </div>
                    <div class="user-role">管理员</div>
                </div>
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger" style="margin-left: 15px;">退出</a>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <h1>📊 数据统计报告</h1>

        <!-- 错误消息显示 -->
        <%
            if (request.getAttribute("error") != null) {
        %>
        <div class="alert alert-error">
            <strong>错误：</strong>
            <%= request.getAttribute("error") %>
        </div>
        <%
            }
        %>

        <!-- 基础统计概览 -->
        <div class="stats-overview">
            <div class="stats-card">
                <div class="stats-icon">👥</div>
                <div class="stats-number">
                    <%= userStats != null ? userStats.getOrDefault("total", 0) : 0 %>
                </div>
                <div class="stats-label">总用户数</div>
            </div>
            <div class="stats-card">
                <div class="stats-icon">📚</div>
                <div class="stats-number">
                    <%= courseStats != null ? (Integer) courseStats.getOrDefault("totalCourses", 0) : 0 %>
                </div>
                <div class="stats-label">总课程数</div>
            </div>
            <div class="stats-card">
                <div class="stats-icon">🎓</div>
                <div class="stats-number">
                    <%= userStats != null ? userStats.getOrDefault("student", 0) : 0 %>
                </div>
                <div class="stats-label">学生用户</div>
            </div>
            <div class="stats-card">
                <div class="stats-icon">👨‍🏫</div>
                <div class="stats-number">
                    <%= userStats != null ? userStats.getOrDefault("teacher", 0) : 0 %>
                </div>
                <div class="stats-label">教师用户</div>
            </div>
        </div>

        <!-- 详细统计信息 -->
        <%
            if (detailedStats != null) {
        %>
        
        <!-- 平均课程数信息 -->
        <div class="highlight-card">
            <div class="highlight-title">📈 系统概况</div>
            <div class="highlight-content">
                平均每位用户拥有 <strong><%= detailedStats.getOrDefault("avgCoursesPerUser", 0.0) %></strong> 门课程<br>
                <%
                    if (detailedStats.get("mostActiveUser") != null) {
                        Map<String, Object> mostActiveUserInfo = (Map<String, Object>) detailedStats.get("mostActiveUser");
                        User mostActiveUser = (User) mostActiveUserInfo.get("user");
                        Integer courseCount = (Integer) mostActiveUserInfo.get("courseCount");
                %>
                最活跃用户：<strong><%= mostActiveUser.getFullName() %></strong> (共 <%= courseCount %> 门课程)
                <%
                    }
                %>
            </div>
        </div>

        <!-- 课程按星期分布 -->
        <div class="chart-container">
            <div class="stats-title">📅 课程时间分布</div>
            <%
                Map<String, Integer> dayDistribution = (Map<String, Integer>) detailedStats.get("dayDistribution");
                if (dayDistribution != null) {
                    int maxCount = dayDistribution.values().stream().mapToInt(Integer::intValue).max().orElse(1);
            %>
            <div class="day-chart">
                <%
                    String[] dayNames = {"周一", "周二", "周三", "周四", "周五", "周六", "周日"};
                    for (String dayName : dayNames) {
                        int count = dayDistribution.getOrDefault(dayName, 0);
                        int height = maxCount > 0 ? (count * 150 / maxCount) : 0;
                %>
                <div class="day-bar">
                    <div class="bar-value"><%= count %></div>
                    <div class="bar" style="height: <%= Math.max(height, 5) %>px;" 
                         title="<%= dayName %>: <%= count %>门课程"></div>
                    <div class="bar-label"><%= dayName %></div>
                </div>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
        </div>

        <!-- 用户课程数量分布 -->
        <div class="stats-detail">
            <div class="stats-title">📊 用户课程数量分布</div>
            <%
                Map<String, Integer> courseCountDistribution = (Map<String, Integer>) detailedStats.get("courseCountDistribution");
                if (courseCountDistribution != null) {
                    int totalUsers = courseCountDistribution.values().stream().mapToInt(Integer::intValue).sum();
            %>
            <div class="distribution-grid">
                <%
                    for (Map.Entry<String, Integer> entry : courseCountDistribution.entrySet()) {
                        String category = entry.getKey();
                        Integer count = entry.getValue();
                        double percentage = totalUsers > 0 ? (count * 100.0 / totalUsers) : 0;
                %>
                <div class="distribution-item">
                    <div class="distribution-label"><%= category %></div>
                    <div class="distribution-value"><%= count %></div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: <%= percentage %>%"></div>
                    </div>
                    <small><%= String.format("%.1f", percentage) %>%</small>
                </div>
                <%
                    }
                %>
            </div>
            <%
                }
            %>
        </div>

        <!-- 学分统计 -->
        <div class="stats-detail">
            <div class="stats-title">🎯 学分统计</div>
            <div class="distribution-grid">
                <div class="distribution-item">
                    <div class="distribution-label">总学分数</div>
                    <div class="distribution-value">
                        <%= detailedStats.getOrDefault("totalCredits", 0.0) %>
                    </div>
                </div>
                <div class="distribution-item">
                    <div class="distribution-label">平均学分/课程</div>
                    <div class="distribution-value">
                        <%= detailedStats.getOrDefault("avgCreditsPerCourse", 0.0) %>
                    </div>
                </div>
            </div>
        </div>

        <%
            }
        %>

        <!-- 最近注册用户 -->
        <div class="recent-activity">
            <div class="stats-title">🆕 最近注册用户</div>
            <%
                if (recentUsers != null && !recentUsers.isEmpty()) {
            %>
            <ul class="user-list">
                <%
                    for (User user : recentUsers) {
                %>
                <li>
                    <div class="user-item">
                        <div class="user-avatar">
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
            <p style="text-align: center; color: #666; padding: 2rem;">暂无最近注册用户</p>
            <%
                }
            %>
        </div>
    </div>

    <!-- 刷新按钮 -->
    <button class="refresh-btn" onclick="refreshStats()" title="刷新统计数据">
        🔄
    </button>

    <script src="../js/admin-stats.js"></script>
</body>
</html>
