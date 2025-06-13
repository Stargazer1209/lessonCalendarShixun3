<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>编辑用户 - 管理员面板</title>
    <link rel="stylesheet" href="../css/index.css">
    <style>
        .checkbox-group {
            margin-bottom: 1rem;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 0.5rem;
        }

        .checkbox-label {
            color: #333;
            font-weight: 500;
        }

        .role-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            border: 1px solid #e9ecef;
        }

        .role-info ul {
            margin: 0.5rem 0;
            padding-left: 1.5rem;
        }

        .role-info strong {
            color: #495057;
        }

        .password-field {
            transition: all 0.3s ease;
        }

        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
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
        
        <!-- 主要内容 -->
        <div class="main-container">
            <div class="form-container">
                <h1 class="page-title">编辑用户信息</h1>
                <a href="<%= request.getContextPath() %>/admin/users" class="back-home" title="返回用户管理">
                    返回用户管理
                </a>

                <!-- 错误和成功消息 -->
                <% String error = (String) session.getAttribute("errorMessage"); %>
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <%= error %>
                    </div>
                    <% session.removeAttribute("errorMessage"); %>
                <% } %>

                <% String success = (String) session.getAttribute("successMessage"); %>
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <%= success %>
                    </div>
                    <% session.removeAttribute("successMessage"); %>
                <% } %>

                <%
                    User editUser = (User) request.getAttribute("editUser");
                    if (editUser == null) {
                %>
                    <div class="alert alert-danger">用户信息不存在</div>
                    <div class="form-actions">
                        <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-primary">返回用户管理</a>
                    </div>
                <%
                    } else {
                %>
                    <!-- 用户信息编辑表单 -->
                    <form id="userEditForm" action="<%= request.getContextPath() %>/admin/users" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                        
                        <div class="form-grid">
                            <!-- 用户名（只读） -->
                            <div class="form-group">
                                <label for="username" class="form-label">用户名</label>
                                <input type="text" id="username" name="username" class="form-input" 
                                       value="<%= editUser.getUsername() %>" readonly 
                                       style="background: #f8f9fa; color: #6c757d;">
                                <div class="help-text">用户名创建后不可修改</div>
                            </div>

                            <!-- 用户角色 -->
                            <div class="form-group">
                                <label for="role" class="form-label">
                                    用户角色 <span class="required">*</span>
                                </label>
                                <select id="role" name="role" class="form-input" required onchange="showRoleInfo()">
                                    <option value="student" <%= "student".equals(editUser.getRole()) ? "selected" : "" %>>学生</option>
                                    <option value="teacher" <%= "teacher".equals(editUser.getRole()) ? "selected" : "" %>>教师</option>
                                    <option value="admin" <%= "admin".equals(editUser.getRole()) ? "selected" : "" %>>管理员</option>
                                </select>
                                <div id="roleInfo" class="role-info" style="display: none;">
                                    <div id="roleDescription"></div>
                                </div>
                            </div>

                            <!-- 邮箱 -->
                            <div class="form-group">
                                <label for="email" class="form-label">
                                    邮箱地址 <span class="required">*</span>
                                </label>
                                <input type="email" id="email" name="email" class="form-input" required
                                       value="<%= editUser.getEmail() %>"
                                       placeholder="请输入邮箱地址">
                                <div class="error-message" id="emailError"></div>
                                <div class="success-message" id="emailSuccess"></div>
                            </div>

                            <!-- 姓名 -->
                            <div class="form-group">
                                <label for="fullName" class="form-label">
                                    姓名 <span class="required">*</span>
                                </label>
                                <input type="text" id="fullName" name="fullName" class="form-input" required maxlength="50"
                                       value="<%= editUser.getFullName() %>"
                                       placeholder="请输入真实姓名">
                                <div class="error-message" id="fullNameError"></div>
                                <div class="success-message" id="fullNameSuccess"></div>
                            </div>

                            <!-- 密码修改选项 -->
                            <div class="form-group full-width">
                                <div class="checkbox-group">
                                    <input type="checkbox" id="changePassword" name="changePassword" 
                                           onchange="togglePasswordFields()">
                                    <label for="changePassword" class="checkbox-label">修改用户密码</label>
                                </div>
                            </div>

                            <!-- 新密码 -->
                            <div class="form-group password-field" id="passwordField" style="display: none;">
                                <label for="password" class="form-label">新密码</label>
                                <input type="password" id="password" name="password" class="form-input" 
                                       minlength="8" placeholder="至少8个字符">
                                <div class="error-message" id="passwordError"></div>
                                <div class="password-strength" id="passwordStrength"></div>
                            </div>

                            <!-- 确认密码 -->
                            <div class="form-group password-field" id="confirmPasswordField" style="display: none;">
                                <label for="confirmPassword" class="form-label">确认新密码</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" 
                                       placeholder="请再次输入新密码">
                                <div class="error-message" id="confirmPasswordError"></div>
                                <div class="success-message" id="confirmPasswordSuccess"></div>
                            </div>
                        </div>

                        <!-- 账户信息 -->
                        <div class="form-group full-width" style="margin-top: 30px;">
                            <h3 style="color: #333; margin-bottom: 15px;">账户信息</h3>
                            <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; color: #666;">
                                <p><strong>注册时间：</strong> <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm").format(java.sql.Timestamp.valueOf(editUser.getCreatedAt())) %></p>
                                <% if (editUser.getUpdatedAt() != null) { %>
                                    <p><strong>最后更新：</strong> <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm").format(java.sql.Timestamp.valueOf(editUser.getUpdatedAt())) %></p>
                                <% } %>
                                <p><strong>用户ID：</strong> <%= editUser.getUserId() %></p>
                            </div>
                        </div>

                        <!-- 提交按钮 -->
                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">保存修改</button>
                            <a href="javascript:history.back()" class="btn btn-secondary">取消</a>
                        </div>
                    </form>

                    <!-- 管理员操作提示 -->
                    <div style="background: #fff3cd; padding: 20px; border-radius: 10px; margin-top: 30px; border-left: 4px solid #ffc107;">
                        <h4 style="color: #856404; margin-bottom: 10px;">⚠️ 管理员操作提示</h4>
                        <ul style="color: #856404; line-height: 1.6; margin-left: 20px;">
                            <li>修改用户角色时请谨慎操作，角色变更会影响用户的系统权限</li>
                            <li>管理员权限较高，请确认用户身份后再分配管理员角色</li>
                            <li>密码修改后用户需要使用新密码重新登录</li>
                            <li>邮箱地址修改后可能需要用户重新验证</li>
                            <li>所有操作都会被系统记录，请确保操作的合理性</li>
                        </ul>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script charset="utf-8" src="<%= request.getContextPath() %>/js/admin-user-edit.js"></script>
</body>
</html>
