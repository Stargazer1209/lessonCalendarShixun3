<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.schedule.model.User" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
    
    // 获取错误信息和成功消息
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>添加课程 - 课灵通</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/index.css" charset="UTF-8">
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand">课灵通</a>
            <ul class="nav-menu">
                <li><a href="index.jsp" class="nav-link">首页</a></li>                <li><a href="ViewScheduleServlet" class="nav-link">课程表</a></li>
                <li><a href="add-course.jsp" class="nav-link active">添加课程</a></li>
                <li><a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-link">退出登录</a></li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <div class="main-container">
        <div class="form-container">
            <h1 class="page-title">添加新课程</h1>
            
            <!-- 显示消息 -->
            <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
                <div class="alert alert-error">
                    <%= errorMessage %>
                </div>
            <% } %>

            <form action="AddCourseServlet" method="post" id="addCourseForm">
                <div class="form-grid">
                    <!-- 课程名称 -->
                    <div class="form-group">
                        <label for="courseName" class="form-label">
                            课程名称 <span class="required">*</span>
                        </label>
                        <input type="text" id="courseName" name="courseName" 
                               class="form-input" required maxlength="100"
                               value="<%= request.getParameter("courseName") != null ? request.getParameter("courseName") : "" %>"
                               placeholder="请输入课程名称">
                        <div class="help-text">例如：高等数学、大学英语</div>
                    </div>

                    <!-- 任课教师 -->
                    <div class="form-group">
                        <label for="instructor" class="form-label">任课教师</label>
                        <input type="text" id="instructor" name="instructor" 
                               class="form-input" maxlength="50"
                               value="<%= request.getParameter("instructor") != null ? request.getParameter("instructor") : "" %>"
                               placeholder="请输入教师姓名">
                    </div>

                    <!-- 教室 -->
                    <div class="form-group">
                        <label for="classroom" class="form-label">教室</label>
                        <input type="text" id="classroom" name="classroom" 
                               class="form-input" maxlength="50"
                               value="<%= request.getParameter("classroom") != null ? request.getParameter("classroom") : "" %>"
                               placeholder="请输入教室编号">
                    </div>

                    <!-- 星期 -->
                    <div class="form-group">
                        <label for="dayOfWeek" class="form-label">
                            上课星期 <span class="required">*</span>
                        </label>
                        <select id="dayOfWeek" name="dayOfWeek" class="form-select" required>
                            <option value="">请选择星期</option>
                            <option value="1" <%= "1".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期一</option>
                            <option value="2" <%= "2".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期二</option>
                            <option value="3" <%= "3".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期三</option>
                            <option value="4" <%= "4".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期四</option>
                            <option value="5" <%= "5".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期五</option>
                            <option value="6" <%= "6".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期六</option>
                            <option value="7" <%= "7".equals(request.getParameter("dayOfWeek")) ? "selected" : "" %>>星期日</option>
                        </select>
                    </div>

                    <!-- 上课时间 -->
                    <div class="form-group">
                        <label class="form-label">
                            上课时间 <span class="required">*</span>
                        </label>
                        <div class="time-inputs">
                            <div>
                                <input type="time" id="startTime" name="startTime" 
                                       class="form-input" required
                                       value="<%= request.getParameter("startTime") != null ? request.getParameter("startTime") : "" %>">
                                <div class="help-text">开始时间</div>
                            </div>
                            <div>
                                <input type="time" id="endTime" name="endTime" 
                                       class="form-input" required
                                       value="<%= request.getParameter("endTime") != null ? request.getParameter("endTime") : "" %>">
                                <div class="help-text">结束时间</div>
                            </div>
                        </div>
                    </div>

                    <!-- 周次范围 -->
                    <div class="form-group">
                        <label class="form-label">周次范围</label>
                        <div class="week-inputs">
                            <div>
                                <input type="number" id="weekStart" name="weekStart" 
                                       class="form-input" min="1" max="30" 
                                       value="<%= request.getParameter("weekStart") != null ? request.getParameter("weekStart") : "1" %>">
                                <div class="help-text">开始周次</div>
                            </div>
                            <div>
                                <input type="number" id="weekEnd" name="weekEnd" 
                                       class="form-input" min="1" max="30"
                                       value="<%= request.getParameter("weekEnd") != null ? request.getParameter("weekEnd") : "18" %>">
                                <div class="help-text">结束周次</div>
                            </div>
                        </div>
                    </div>

                    <!-- 课程类型 -->
                    <div class="form-group">
                        <label for="courseType" class="form-label">课程类型</label>
                        <select id="courseType" name="courseType" class="form-select">
                            <option value="">请选择类型</option>
                            <option value="必修课" <%= "必修课".equals(request.getParameter("courseType")) ? "selected" : "" %>>必修课</option>
                            <option value="选修课" <%= "选修课".equals(request.getParameter("courseType")) ? "selected" : "" %>>选修课</option>
                            <option value="实验课" <%= "实验课".equals(request.getParameter("courseType")) ? "selected" : "" %>>实验课</option>
                            <option value="实习课" <%= "实习课".equals(request.getParameter("courseType")) ? "selected" : "" %>>实习课</option>
                        </select>
                    </div>

                    <!-- 学分 -->
                    <div class="form-group">
                        <label for="credits" class="form-label">学分</label>
                        <input type="number" id="credits" name="credits" 
                               class="form-input" min="0" max="10" step="1"
                               value="<%= request.getParameter("credits") != null ? request.getParameter("credits") : "" %>"
                               placeholder="0-10">
                    </div>

                    <!-- 课程描述 -->
                    <div class="form-group full-width">
                        <label for="description" class="form-label">课程描述</label>
                        <textarea id="description" name="description" 
                                  class="form-textarea" maxlength="500"
                                  placeholder="请输入课程描述（选填）"><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                        <div class="help-text">最多500字符</div>
                    </div>
                </div>

                <!-- 表单操作按钮 -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">添加课程</button>
                    <a href="ViewScheduleServlet" class="btn btn-secondary">取消</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // 表单验证
        document.getElementById('addCourseForm').addEventListener('submit', function(e) {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;
            const weekStart = parseInt(document.getElementById('weekStart').value);
            const weekEnd = parseInt(document.getElementById('weekEnd').value);

            // 验证时间
            if (startTime && endTime && startTime >= endTime) {
                alert('开始时间必须早于结束时间！');
                e.preventDefault();
                return false;
            }

            // 验证周次
            if (weekStart && weekEnd && weekStart > weekEnd) {
                alert('开始周次不能大于结束周次！');
                e.preventDefault();
                return false;
            }
        });

        // 自动设置结束时间（开始时间+2小时）
        document.getElementById('startTime').addEventListener('change', function() {
            const startTime = this.value;
            const endTimeInput = document.getElementById('endTime');
            
            if (startTime && !endTimeInput.value) {
                const start = new Date('2000-01-01 ' + startTime);
                start.setHours(start.getHours() + 2);
                const endTime = start.toTimeString().slice(0, 5);
                endTimeInput.value = endTime;
            }
        });
    </script>
</body>
</html>
