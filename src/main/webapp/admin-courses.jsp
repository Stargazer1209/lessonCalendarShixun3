<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.schedule.model.User" %>
<%@ page import="com.schedule.model.Course" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    boolean isLoggedIn = (currentUser != null);
    
    // 获取课程和用户数据
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>课程管理 - 管理员面板</title>
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

        .content-section {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .filters-section {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-group label {
            font-weight: 600;
            color: #333;
            font-size: 0.9rem;
        }

        .filter-select {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 0.9rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }

        th {
            background: #a0b2ff;
            color: white;
            font-weight: 600;
            padding: 1rem;
            text-align: left;
            border-radius: 8px;
        }

        td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.4rem 0.8rem;
            font-size: 0.875rem;
            border-radius: 6px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .btn-info {
            background: #17a2b8;
            color: white;
        }

        .btn-info:hover {
            background: #138496;
            color: white;
        }

        .btn-warning {
            background: #ffc107;
            color: #212529;
        }

        .btn-warning:hover {
            background: #e0a800;
            color: #212529;
        }

        .course-time {
            font-size: 0.9rem;
            color: #666;
        }

        .course-owner {
            font-weight: 600;
            color: #333;
        }

        .day-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: bold;
            color: white;
        }

        .day-1 { background: #ff6b6b; }
        .day-2 { background: #4ecdc4; }
        .day-3 { background: #45b7d1; }
        .day-4 { background: #96ceb4; }
        .day-5 { background: #ffeaa7; color: #333; }
        .day-6 { background: #fab1a0; }
        .day-7 { background: #a29bfe; }

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

        .stats-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stats-card {
            background: white;
            color: black;
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
        }

        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        /* 弹窗样式 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: white;
            margin: 5% auto;
            padding: 0;
            border-radius: 15px;
            width: 90%;
            max-width: 800px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease;
        }

        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 20px 30px;
            border-radius: 15px 15px 0 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            font-size: 1.5rem;
        }

        .modal-body {
            padding: 30px;
        }

        .close {
            color: white;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            opacity: 0.8;
            transition: opacity 0.3s;
        }

        .close:hover {
            opacity: 1;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: #333;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        .course-details {
            display: grid;
            gap: 1rem;
        }

        .detail-item {
            display: flex;
            padding: 1rem;
            border-left: 4px solid #667eea;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .detail-label {
            font-weight: 600;
            color: #333;
            min-width: 120px;
        }

        .detail-value {
            color: #666;
        }

        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .modal-content {
                width: 95%;
                margin: 10px auto;
                max-height: 95vh;
            }
            
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .form-actions button {
                width: 100%;
                margin-bottom: 0.5rem;
            }
            
            .stats-cards {
                grid-template-columns: 1fr;
            }
            
            .filters-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .action-buttons {
                flex-direction: column;
                gap: 0.25rem;
            }
            
            .btn-sm {
                width: 100%;
                text-align: center;
            }
        }

        /* 表格响应式 */
        @media (max-width: 1024px) {
            table {
                font-size: 0.9rem;
            }
            
            th, td {
                padding: 0.5rem;
            }
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
                <li><a href="<%= request.getContextPath() %>/admin/courses" class="action-btn active">课程管理</a></li>
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
                    <div class="user-role">管理员</div>
                </div>
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger" style="margin-left: 15px;">退出</a>
            </div>
        </div>
    </nav>

    <div class="main-content">
        <h1>📚 课程管理</h1>

        <!-- 统计卡片 -->
        <div class="stats-cards">
            <div class="stats-card">
                <div class="stats-number"><%= courses != null ? courses.size() : 0 %></div>
                <div class="stats-label">总课程数</div>
            </div>
            <div class="stats-card">
                <div class="stats-number"><%= users != null ? users.size() : 0 %></div>
                <div class="stats-label">用户数量</div>
            </div>
            <%
                int activeCourses = 0;
                if (courses != null) {
                    activeCourses = courses.size();
                }
            %>
            <div class="stats-card">
                <div class="stats-number"><%= activeCourses %></div>
                <div class="stats-label">活跃课程</div>
            </div>
        </div>

        <!-- 课程管理内容 -->
        <div class="content-section">
            <!-- 筛选区域 -->
            <div class="filters-section">
                <div class="filter-group">
                    <label for="userFilter">按用户筛选：</label>
                    <select id="userFilter" class="filter-select" onchange="filterCourses()">
                        <option value="">所有用户</option>
                        <%
                            if (users != null) {
                                for (User user : users) {
                        %>
                        <option value="<%= user.getUserId() %>"><%= user.getFullName() %> (<%= user.getEmail() %>)</option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="dayFilter">按星期筛选：</label>
                    <select id="dayFilter" class="filter-select" onchange="filterCourses()">
                        <option value="">所有日期</option>
                        <option value="1">周一</option>
                        <option value="2">周二</option>
                        <option value="3">周三</option>
                        <option value="4">周四</option>
                        <option value="5">周五</option>
                        <option value="6">周六</option>
                        <option value="7">周日</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label>&nbsp;</label>
                    <button class="btn btn-secondary" onclick="clearFilters()">清除筛选</button>
                </div>
            </div>

            <!-- 错误/成功消息显示 -->
            <%
                String successMessage = (String) session.getAttribute("successMessage");
                String errorMessage = (String) session.getAttribute("errorMessage");
                
                if (successMessage != null) {
                    session.removeAttribute("successMessage");
            %>
            <div class="alert alert-success">
                <%= successMessage %>
            </div>
            <%
                }
                
                if (errorMessage != null) {
                    session.removeAttribute("errorMessage");
            %>
            <div class="alert alert-error">
                <%= errorMessage %>
            </div>
            <%
                }
                
                if (request.getParameter("error") != null) {
            %>
            <div class="alert alert-error">
                <%= request.getParameter("error") %>
            </div>
            <%
                }
            %>

            <!-- 课程列表 -->
            <%
                if (courses != null && !courses.isEmpty()) {
            %>
            <table id="coursesTable">
                <thead>
                    <tr>
                        <th>课程名称</th>
                        <th>授课教师</th>
                        <th>教室</th>
                        <th>时间安排</th>
                        <th>所属用户</th>
                        <th>学分</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String[] dayNames = {"", "周一", "周二", "周三", "周四", "周五", "周六", "周日"};
                        Map<Integer, User> userMap = new HashMap<>();
                        if (users != null) {
                            for (User user : users) {
                                userMap.put(user.getUserId(), user);
                            }
                        }
                        
                        for (Course course : courses) {
                            User courseOwner = userMap.get(course.getUserId());
                    %>
                    <tr data-user-id="<%= course.getUserId() %>" data-day="<%= course.getDayOfWeek() %>">
                        <td>
                            <strong><%= course.getCourseName() %></strong>
                            <% if (course.getCourseType() != null && !course.getCourseType().trim().isEmpty()) { %>
                            <br><small style="color: #666;">类型：<%= course.getCourseType() %></small>
                            <% } %>
                        </td>
                        <td><%= course.getInstructor() != null ? course.getInstructor() : "-" %></td>
                        <td><%= course.getClassroom() != null ? course.getClassroom() : "-" %></td>
                        <td>
                            <span class="day-badge day-<%= course.getDayOfWeek() %>">
                                <%= dayNames[course.getDayOfWeek()] %>
                            </span>
                            <div class="course-time">
                                <%= course.getStartTime().format(DateTimeFormatter.ofPattern("HH:mm")) %> - 
                                <%= course.getEndTime().format(DateTimeFormatter.ofPattern("HH:mm")) %>
                            </div>
                            <% if (course.getWeekStart() > 0 && course.getWeekEnd() > 0) { %>
                            <small style="color: #666;">第<%= course.getWeekStart() %>-<%= course.getWeekEnd() %>周</small>
                            <% } %>
                        </td>
                        <td>
                            <div class="course-owner">
                                <%= courseOwner != null ? courseOwner.getFullName() : "未知用户" %>
                            </div>
                            <small style="color: #666;">
                                <%= courseOwner != null ? courseOwner.getEmail() : "" %>
                            </small>
                        </td>
                        <td><%= course.getCredits() > 0 ? course.getCredits() + "学分" : "-" %></td>                        <td>
                            <div class="action-buttons">
                                <button class="btn-sm btn-info" 
                                        onclick="viewCourse(<%= course.getCourseId() %>)">
                                    查看
                                </button>
                                <button class="btn-sm btn-warning" 
                                        onclick="editCourse(<%= course.getCourseId() %>)">
                                    编辑
                                </button>
                                <button class="btn-sm btn-danger" 
                                        onclick="deleteCourse(<%= course.getCourseId() %>, '<%= course.getCourseName() %>')">
                                    删除
                                </button>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } else {
            %>
            <div class="empty-state">
                <div class="icon">📚</div>
                <h3>暂无课程数据</h3>
                <p>系统中还没有任何课程信息</p>
            </div>            <%
                }
            %>
        </div>
    </div>

    <!-- 课程详情查看弹窗 -->
    <div id="viewModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>📚 课程详情</h2>
                <span class="close" onclick="closeModal('viewModal')">&times;</span>
            </div>
            <div class="modal-body">
                <div id="viewCourseDetails" class="course-details">
                    <!-- 课程详情将通过JavaScript动态填充 -->
                </div>
            </div>
        </div>
    </div>

    <!-- 课程编辑弹窗 -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>✏️ 编辑课程</h2>
                <span class="close" onclick="closeModal('editModal')">&times;</span>
            </div>
            <div class="modal-body">
                <form id="editCourseForm" onsubmit="submitEditForm(event)">
                    <input type="hidden" id="editCourseId" name="courseId">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label for="editCourseName">课程名称 *</label>
                        <input type="text" id="editCourseName" name="courseName" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="editInstructor">授课教师</label>
                            <input type="text" id="editInstructor" name="instructor">
                        </div>
                        <div class="form-group">
                            <label for="editClassroom">教室</label>
                            <input type="text" id="editClassroom" name="classroom">
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="editDayOfWeek">星期 *</label>
                            <select id="editDayOfWeek" name="dayOfWeek" required>
                                <option value="1">周一</option>
                                <option value="2">周二</option>
                                <option value="3">周三</option>
                                <option value="4">周四</option>
                                <option value="5">周五</option>
                                <option value="6">周六</option>
                                <option value="7">周日</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editStartTime">开始时间 *</label>
                            <input type="time" id="editStartTime" name="startTime" required>
                        </div>
                        <div class="form-group">
                            <label for="editEndTime">结束时间 *</label>
                            <input type="time" id="editEndTime" name="endTime" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="editWeekStart">开始周</label>
                            <input type="number" id="editWeekStart" name="weekStart" min="1" max="20">
                        </div>
                        <div class="form-group">
                            <label for="editWeekEnd">结束周</label>
                            <input type="number" id="editWeekEnd" name="weekEnd" min="1" max="20">
                        </div>
                        <div class="form-group">
                            <label for="editCredits">学分</label>
                            <input type="number" id="editCredits" name="credits" min="0" step="0.5">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="editCourseType">课程类型</label>
                        <input type="text" id="editCourseType" name="courseType" placeholder="如：必修课、选修课等">
                    </div>
                    
                    <div class="form-group">
                        <label for="editDescription">课程描述</label>
                        <textarea id="editDescription" name="description" rows="3" placeholder="课程详细描述..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeModal('editModal')">取消</button>
                        <button type="submit" class="btn btn-primary">保存修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="../js/admin-courses.js"></script>
</body>
</html>
