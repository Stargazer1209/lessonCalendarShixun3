<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import="com.schedule.model.User" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人设置 - 课灵通</title>
    
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

            <!-- 已登录用户的导航菜单 -->
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

    <!-- 主要内容 -->
    <div class="main-container">
        <div class="form-container">
            <h1 class="page-title">个人设置</h1>
            <a href="<%= request.getContextPath() %>/index.jsp" class="back-home" title="返回首页">
                返回首页
            </a>

            <!-- 错误和成功消息 -->
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div class="alert alert-danger">
                    <%= error %>
                </div>
            <% } %>

            <% String success = (String) request.getAttribute("success"); %>
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <%= success %>
                </div>
            <% } %>

            <!-- 个人信息表单 -->
            <form id="profileForm" action="ProfileServlet" method="post">
                <div class="form-grid">
                    <!-- 用户名（只读） -->
                    <div class="form-group">
                        <label for="username" class="form-label">用户名</label>
                        <input type="text" id="username" name="username" class="form-input" 
                               value="<%= currentUser.getUsername() %>" readonly 
                               style="background: #f8f9fa; color: #6c757d;">
                        <div class="help-text">用户名无法修改</div>
                    </div>

                    <!-- 角色（只读） -->
                    <div class="form-group">
                        <label for="role" class="form-label">用户角色</label>
                        <input type="text" id="role" name="role" class="form-input" 
                               value="<%= roleDisplay %>" readonly 
                               style="background: #f8f9fa; color: #6c757d;">
                        <div class="help-text">角色由管理员分配</div>
                    </div>

                    <!-- 邮箱 -->
                    <div class="form-group">
                        <label for="email" class="form-label">
                            邮箱 <span class="required">*</span>
                        </label>
                        <input type="email" id="email" name="email" class="form-input" required
                               value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : currentUser.getEmail() %>"
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
                               value="<%= request.getAttribute("fullName") != null ? request.getAttribute("fullName") : currentUser.getFullName() %>"
                               placeholder="请输入真实姓名">
                        <div class="error-message" id="fullNameError"></div>
                        <div class="success-message" id="fullNameSuccess"></div>
                    </div>

                    <!-- 新密码 -->
                    <div class="form-group">
                        <label for="password" class="form-label">新密码</label>
                        <input type="password" id="password" name="password" class="form-input" 
                               placeholder="如不修改密码请留空，至少8个字符">
                        <div class="error-message" id="passwordError"></div>
                        <div class="password-strength" id="passwordStrength"></div>
                    </div>

                    <!-- 确认密码 -->
                    <div class="form-group">
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
                        <p><strong>注册时间：</strong> <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm").format(java.sql.Timestamp.valueOf(currentUser.getCreatedAt())) %></p>
                        <% if (currentUser.getUpdatedAt() != null) { %>
                            <p><strong>最后更新：</strong> <%= new java.text.SimpleDateFormat("yyyy年MM月dd日 HH:mm").format(java.sql.Timestamp.valueOf(currentUser.getUpdatedAt())) %></p>
                        <% } %>
                    </div>
                </div>

                <!-- 提交按钮 -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">保存修改</button>
                    <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-secondary">取消</a>
                </div>
            </form>

            <!-- 温馨提示 -->
            <div style="background: #e3f2fd; padding: 20px; border-radius: 10px; margin-top: 30px;">
                <h4 style="color: #1976d2; margin-bottom: 10px;">🔒 安全提示</h4>
                <ul style="color: #1565c0; line-height: 1.6; margin-left: 20px;">
                    <li>为了账户安全，请使用强密码并定期更换</li>
                    <li>不要与他人分享您的账户信息</li>
                    <li>如果发现异常活动，请及时联系管理员</li>
                    <li>更新邮箱后可能需要重新验证</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- 引入JavaScript文件 -->
    <script charset="utf-8" src="<%= request.getContextPath() %>/js/profile.js"></script>
</body>

</html>
