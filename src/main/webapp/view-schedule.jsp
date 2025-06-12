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
    <title>课程管理 - 课灵通</title>
    <!-- 引入CSS文件 -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css" charset="UTF-8">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="<%= request.getContextPath() %>/index.jsp" class="nav-brand">
                🎓 课灵通
            </a>
            <ul class="nav-links">
                    <li><a href="add-course.jsp">添加课程</a></li>
                    <li><a href="ViewScheduleServlet">课程管理</a></li>
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
                    <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger"
                        style="margin-left: 15px;">退出</a>
                </div>
        </div>
    </nav>

    <!-- 主内容 -->
    <div class="container">
        <!-- 页面标题 -->
        <div class="header">
            <h1>课程管理</h1>
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
                ➕ 添加课程
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
                                                           onclick="return confirmDelete('<%= courseName %>')">删除</a>
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
            <% } %>        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/view-schedule.js"></script>
</body>
</html>
