<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.schedule.model.User" %>
<%@ page import="com.schedule.model.Course" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    // 获取课程列表
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    
    // 获取错误信息和成功消息
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    
    // 时间格式化
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的课程表 - 课灵通</title>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: bold;
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 8px;
        }

        .nav-links a:hover, .nav-links a.active {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            transform: translateY(-2px);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .welcome-text {
            color: #666;
            font-size: 0.9rem;
        }

        .logout-btn {
            background: linear-gradient(45deg, #ff6b6b, #ee5a24);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(238, 90, 36, 0.4);
        }

        /* 主内容区域 */
        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header h1 {
            color: white;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .header p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
        }

        /* 消息提示样式 */
        .alert {
            padding: 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            font-weight: 500;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .alert.success {
            background: linear-gradient(45deg, #00b894, #00a085);
            color: white;
        }

        .alert.error {
            background: linear-gradient(45deg, #e17055, #d63031);
            color: white;
        }

        /* 操作按钮区域 */
        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            background: rgba(255, 255, 255, 0.95);
            padding: 1.5rem;
            border-radius: 16px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }

        .add-course-btn {
            background: linear-gradient(45deg, #00b894, #00a085);
            color: white;
            border: none;
            padding: 0.8rem 2rem;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .add-course-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0, 184, 148, 0.4);
        }

        .course-count {
            color: #666;
            font-size: 1rem;
        }

        /* 课程表样式 */
        .schedule-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 2rem;
            backdrop-filter: blur(10px);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
        }

        .schedule-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        }

        .schedule-table th {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            font-size: 1rem;
        }

        .schedule-table td {
            padding: 1rem;
            text-align: center;
            border-bottom: 1px solid #f0f0f0;
            vertical-align: middle;
        }

        .schedule-table tr:hover {
            background: rgba(102, 126, 234, 0.05);
        }

        .course-card {
            background: linear-gradient(45deg, #74b9ff, #0984e3);
            color: white;
            padding: 0.8rem;
            border-radius: 8px;
            margin: 0.2rem 0;
            font-size: 0.9rem;
            font-weight: 500;
            box-shadow: 0 2px 8px rgba(116, 185, 255, 0.3);
        }

        .course-name {
            font-weight: 600;
            margin-bottom: 0.2rem;
        }

        .course-info {
            font-size: 0.8rem;
            opacity: 0.9;
        }

        .course-actions {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
            margin-top: 0.5rem;
        }

        .btn {
            padding: 0.4rem 0.8rem;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn-edit {
            background: linear-gradient(45deg, #fdcb6e, #e17055);
            color: white;
        }

        .btn-edit:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(253, 203, 110, 0.4);
        }

        .btn-delete {
            background: linear-gradient(45deg, #e17055, #d63031);
            color: white;
        }

        .btn-delete:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(225, 112, 85, 0.4);
        }

        /* 空状态样式 */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #666;
        }

        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 0.5rem;
            color: #333;
        }

        .empty-state p {
            font-size: 1rem;
            margin-bottom: 2rem;
        }

        /* 时间轴样式 */
        .time-slot {
            font-weight: 600;
            color: #333;
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding-left: 0.5rem;
        }

        /* 星期标题样式 */
        .day-header {
            position: relative;
            overflow: hidden;
        }

        .day-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(255, 255, 255, 0.1));
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 1rem;
                padding: 0 1rem;
            }

            .nav-links {
                gap: 1rem;
            }

            .container {
                padding: 0 1rem;
            }

            .header h1 {
                font-size: 2rem;
            }

            .actions {
                flex-direction: column;
                gap: 1rem;
            }

            .schedule-container {
                padding: 1rem;
                overflow-x: auto;
            }

            .schedule-table {
                min-width: 800px;
            }

            .schedule-table th,
            .schedule-table td {
                padding: 0.5rem;
                font-size: 0.9rem;
            }
        }

        /* 动画效果 */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .schedule-container {
            animation: fadeInUp 0.6s ease-out;
        }

        .course-card {
            animation: fadeInUp 0.4s ease-out;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="logo">课灵通</div>
            <div class="nav-links">
                <a href="ViewScheduleServlet" class="active">我的课程表</a>
                <a href="add-course.jsp">添加课程</a>
            </div>            <div class="user-info">
                <span class="welcome-text">欢迎，<%= currentUser.getUsername() %></span>
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout-btn">退出登录</a>
            </div>
        </div>
    </nav>

    <!-- 主内容 -->
    <div class="container">
        <!-- 页面标题 -->
        <div class="header">
            <h1>我的课程表</h1>
            <p>管理您的课程安排，让学习更有条理</p>
        </div>

        <!-- 消息提示 -->
        <% if (successMessage != null) { %>
            <div class="alert success">
                <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert error">
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- 操作按钮区域 -->
        <div class="actions">
            <div class="course-count">
                <% if (courses != null) { %>
                    共 <%= courses.size() %> 门课程
                <% } else { %>
                    暂无课程
                <% } %>
            </div>
            <a href="add-course.jsp" class="add-course-btn">
                ➕ 添加新课程
            </a>
        </div>

        <!-- 课程表 -->
        <div class="schedule-container">
            <% if (courses != null && !courses.isEmpty()) { %>
                <table class="schedule-table">
                    <thead>
                        <tr>
                            <th class="time-slot">时间</th>
                            <th class="day-header">周一</th>
                            <th class="day-header">周二</th>
                            <th class="day-header">周三</th>
                            <th class="day-header">周四</th>
                            <th class="day-header">周五</th>
                            <th class="day-header">周六</th>
                            <th class="day-header">周日</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // 创建一个二维数组来存储课程表
                            String[][] schedule = new String[7][13]; // 7天 x 13个时间段 (8:00-21:00)
                            String[][] courseData = new String[7][13]; // 存储完整的课程信息
                            
                            // 初始化数组
                            for (int i = 0; i < 7; i++) {
                                for (int j = 0; j < 13; j++) {
                                    schedule[i][j] = "";
                                    courseData[i][j] = "";
                                }
                            }
                            
                            // 填充课程数据
                            for (Course course : courses) {
                                int dayIndex = course.getDayOfWeek() - 1; // 周一=1，转换为数组索引0
                                if (dayIndex >= 0 && dayIndex < 7) {                                    // 解析开始时间，转换为时间段索引
                                    String startTime = course.getStartTime().format(timeFormatter);
                                    int hour = course.getStartTime().getHour();
                                    int timeIndex = hour - 8; // 8点开始为索引0
                                      if (timeIndex >= 0 && timeIndex < 13) {
                                        schedule[dayIndex][timeIndex] = course.getCourseName();
                                        courseData[dayIndex][timeIndex] = course.getCourseId() + "|" + 
                                            course.getCourseName() + "|" + 
                                            course.getInstructor() + "|" + 
                                            course.getClassroom() + "|" + 
                                            startTime + "|" + 
                                            course.getEndTime().format(timeFormatter);
                                    }
                                }
                            }
                            
                            // 生成时间表
                            for (int timeSlot = 0; timeSlot < 13; timeSlot++) {
                                int hour = timeSlot + 8;
                                String timeLabel = String.format("%02d:00", hour);
                        %>
                                <tr>
                                    <td class="time-slot"><%= timeLabel %></td>
                                    <% for (int day = 0; day < 7; day++) { %>
                                        <td>
                                            <% if (!schedule[day][timeSlot].isEmpty()) { 
                                                String[] data = courseData[day][timeSlot].split("\\|");
                                                String courseId = data[0];
                                                String courseName = data[1];
                                                String teacher = data[2];
                                                String location = data[3];
                                                String startTime = data[4];
                                                String endTime = data[5];
                                            %>
                                                <div class="course-card">
                                                    <div class="course-name"><%= courseName %></div>
                                                    <div class="course-info">
                                                        👨‍🏫 <%= teacher %><br>
                                                        📍 <%= location %><br>
                                                        ⏰ <%= startTime %>-<%= endTime %>
                                                    </div>                                                    <div class="course-actions">
                                                        <a href="EditCourseServlet?id=<%= courseId %>" class="btn btn-edit">编辑</a>
                                                        <a href="DeleteCourseServlet?id=<%= courseId %>" 
                                                           class="btn btn-delete" 
                                                           onclick="return confirm('确定要删除这门课程吗？')">删除</a>
                                                    </div>
                                                </div>
                                            <% } %>
                                        </td>
                                    <% } %>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="empty-state">
                    <div class="icon">📚</div>
                    <h3>还没有课程安排</h3>
                    <p>开始添加您的第一门课程，让学习更有规律！</p>
                    <a href="add-course.jsp" class="add-course-btn">
                        ➕ 添加第一门课程
                    </a>
                </div>
            <% } %>
        </div>
    </div>

    <script>
        // 确认删除功能
        function confirmDelete(courseName) {
            return confirm('确定要删除课程 "' + courseName + '" 吗？此操作不可撤销。');
        }
        
        // 自动隐藏成功消息
        setTimeout(function() {
            const successAlert = document.querySelector('.alert.success');
            if (successAlert) {
                successAlert.style.opacity = '0';
                setTimeout(function() {
                    successAlert.remove();
                }, 300);
            }
        }, 3000);
    </script>
</body>
</html>
