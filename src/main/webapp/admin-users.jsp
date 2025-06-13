<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
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
    <title>用户管理 - 管理员面板</title>
    <link rel="stylesheet" href="../css/index.css">
    <style>
        h1 {
            text-align: center;
            color: white;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f8f9fa;
            font-weight: 600;
            color: #495057;
        }

        th,
        td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 4px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }

        .btn-warning {
            background: #ffc107;
            color: #ffffff;
            border: 1px solid #ffc107;
        }

        .btn-warning:hover {
            background: #e0a800;
            color: #ffffff;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 1rem;
            gap: 0.5rem;
        }

        .pagination a {
            padding: 0.5rem 1rem;
            text-decoration: none;
            color: #495057;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            transition: all 0.3s ease;
        }

        .pagination a:hover,
        .pagination a.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .role-admin {
            background: #e74c3c;
            color: white;
        }

        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
            font-weight: bold;
        }

        .role-student {
            background: #27ae60;
            color: white;
        }

        .role-teacher {
            background: #f39c12;
            color: white;
        }

        .search-box {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .search-box input {
            padding: 0.5rem;
            border: none;
            border-radius: 4px;
            width: 250px;
        }

        .table-container {
            overflow-x: auto;
        }

        .table-header {
            background: #a0b2ff;
            color: white;
            padding: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .users-table {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
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
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger" 
                   style="margin-left: 15px;">退出</a>
            </div>
        </div>
    </nav>

    <!-- 主要内容 -->
    <div class="main-content">
        <h1>用户管理</h1>

        <!-- 成功/错误消息 -->
        <% if (session.getAttribute("successMessage") != null) { %>
            <div class="success-message">
                <%= session.getAttribute("successMessage") %>
            </div>
            <% session.removeAttribute("successMessage"); %>
        <% } %>

        <% if (session.getAttribute("errorMessage") != null) { %>
            <div class="error-message">
                <%= session.getAttribute("errorMessage") %>
            </div>
            <% session.removeAttribute("errorMessage"); %>
        <% } %>

        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                <%= request.getParameter("error") %>
            </div>
        <% } %>

        <!-- 用户表格 -->
        <div class="users-table">
            <div class="table-header">
                <h3>用户列表</h3>
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="搜索用户名或邮箱..." 
                           onkeyup="filterUsers()">
                    <span>总计: <%= ((List<User>)request.getAttribute("users")).size() %> 用户</span>
                </div>
            </div>
            
            <div class="table-container">
                <table id="usersTable">
                    <thead>
                        <tr>
                            <th>用户ID</th>
                            <th>用户名</th>
                            <th>姓名</th>
                            <th>邮箱</th>
                            <th>角色</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<User> users = (List<User>) request.getAttribute("users");
                            if (users != null && !users.isEmpty()) {
                                for (User user : users) {
                        %>
                            <tr>
                                <td><%= user.getUserId() %></td>
                                <td><%= user.getUsername() %></td>
                                <td><%= user.getFullName() %></td>
                                <td><%= user.getEmail() %></td>
                                <td>
                                    <span class="role-badge role-<%= user.getRole() %>">
                                        <%= "admin".equals(user.getRole()) ? "管理员" : 
                                            "teacher".equals(user.getRole()) ? "教师" : "学生" %>
                                    </span>
                                </td>
                                <td>
                                    <%= user.getCreatedAt() != null ? 
                                        user.getCreatedAt().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd")) : 
                                        "未知" %>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="?action=edit&userId=<%= user.getUserId() %>" 
                                           class="btn-sm btn-warning" title="编辑用户">查看或编辑</a>
                                        <% if (user.getUserId() != ((User)session.getAttribute("user")).getUserId()) { %>
                                            <a href="javascript:deleteUser(<%= user.getUserId() %>, '<%= user.getFullName() %>')" 
                                               class="btn-sm btn-danger" title="删除用户">删除</a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="7" style="text-align: center; padding: 2rem;">暂无用户数据</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script charset="utf-8" src="<%= request.getContextPath() %>/js/admin-users.js"></script>
</body>

</html>
