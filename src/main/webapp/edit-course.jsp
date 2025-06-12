<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.schedule.model.User" %>
<%@ page import="com.schedule.model.Course" %>
<%
    // 检查用户登录状态
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect("LoginServlet");
        return;
    }
      // 获取课程信息
    Course course = (Course) request.getAttribute("course");
    if (course == null) {
        response.sendRedirect("ViewScheduleServlet");
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
    <title>编辑课程 - 课灵通</title>
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

    <!-- 主要内容 -->
    <div class="main-container">
        <div class="form-container">            <h1 class="page-title">编辑课程</h1>
            <a href="<%= request.getContextPath() %>/ViewScheduleServlet" class="back-home" title="返回课程管理页面">
                返回课程管理页面
            </a>
            <div class="course-info">
                课程ID: <%= course.getCourseId() %>
            </div>
            
            <!-- 显示消息 -->
            <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
                <div class="alert alert-error">
                    <%= errorMessage.replace("\n", "<br>") %>
                </div>
            <% } %>

            <form action="UpdateCourseServlet" method="post" id="editCourseForm">
                <!-- 隐藏字段：课程ID -->
                <input type="hidden" name="courseId" value="<%= course.getCourseId() %>">

                <div class="form-grid">
                    <!-- 课程名称 -->
                    <div class="form-group">
                        <label for="courseName" class="form-label">
                            课程名称 <span class="required">*</span>
                        </label>
                        <input type="text" id="courseName" name="courseName" 
                               class="form-input" required maxlength="100"
                               value="<%= course.getCourseName() != null ? course.getCourseName() : "" %>"
                               placeholder="请输入课程名称">
                        <div class="help-text">例如：高等数学、大学英语</div>
                    </div>

                    <!-- 任课教师 -->
                    <div class="form-group">
                        <label for="instructor" class="form-label">任课教师</label>
                        <input type="text" id="instructor" name="instructor" 
                               class="form-input" maxlength="50"
                               value="<%= course.getInstructor() != null ? course.getInstructor() : "" %>"
                               placeholder="请输入教师姓名">
                    </div>

                    <!-- 教室 -->
                    <div class="form-group">
                        <label for="classroom" class="form-label">教室</label>
                        <input type="text" id="classroom" name="classroom" 
                               class="form-input" maxlength="50"
                               value="<%= course.getClassroom() != null ? course.getClassroom() : "" %>"
                               placeholder="请输入教室编号">
                    </div>

                    <!-- 星期 -->
                    <div class="form-group">
                        <label for="dayOfWeek" class="form-label">
                            上课星期 <span class="required">*</span>
                        </label>
                        <select id="dayOfWeek" name="dayOfWeek" class="form-select" required>
                            <option value="">请选择星期</option>
                            <option value="1" <%= course.getDayOfWeek() == 1 ? "selected" : "" %>>星期一</option>
                            <option value="2" <%= course.getDayOfWeek() == 2 ? "selected" : "" %>>星期二</option>
                            <option value="3" <%= course.getDayOfWeek() == 3 ? "selected" : "" %>>星期三</option>
                            <option value="4" <%= course.getDayOfWeek() == 4 ? "selected" : "" %>>星期四</option>
                            <option value="5" <%= course.getDayOfWeek() == 5 ? "selected" : "" %>>星期五</option>
                            <option value="6" <%= course.getDayOfWeek() == 6 ? "selected" : "" %>>星期六</option>
                            <option value="7" <%= course.getDayOfWeek() == 7 ? "selected" : "" %>>星期日</option>
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
                                       value="<%= course.getStartTime() != null ? course.getStartTime().toString() : "" %>">
                                <div class="help-text">开始时间</div>
                            </div>
                            <div>
                                <input type="time" id="endTime" name="endTime" 
                                       class="form-input" required
                                       value="<%= course.getEndTime() != null ? course.getEndTime().toString() : "" %>">
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
                                       value="<%= course.getWeekStart() %>">
                                <div class="help-text">开始周次</div>
                            </div>
                            <div>
                                <input type="number" id="weekEnd" name="weekEnd" 
                                       class="form-input" min="1" max="30"
                                       value="<%= course.getWeekEnd() %>">
                                <div class="help-text">结束周次</div>
                            </div>
                        </div>
                    </div>

                    <!-- 课程类型 -->
                    <div class="form-group">
                        <label for="courseType" class="form-label">课程类型</label>
                        <select id="courseType" name="courseType" class="form-select">
                            <option value="">请选择类型</option>
                            <option value="必修课" <%= "必修课".equals(course.getCourseType()) ? "selected" : "" %>>必修课</option>
                            <option value="选修课" <%= "选修课".equals(course.getCourseType()) ? "selected" : "" %>>选修课</option>
                            <option value="实验课" <%= "实验课".equals(course.getCourseType()) ? "selected" : "" %>>实验课</option>
                            <option value="实习课" <%= "实习课".equals(course.getCourseType()) ? "selected" : "" %>>实习课</option>
                        </select>
                    </div>

                    <!-- 学分 -->
                    <div class="form-group">
                        <label for="credits" class="form-label">学分</label>
                        <input type="number" id="credits" name="credits" 
                               class="form-input" min="0" max="10" step="1"
                               value="<%= course.getCredits() %>"
                               placeholder="0-10">
                    </div>

                    <!-- 课程描述 -->
                    <div class="form-group full-width">
                        <label for="description" class="form-label">课程描述</label>
                        <textarea id="description" name="description" 
                                  class="form-textarea" maxlength="500"
                                  placeholder="请输入课程描述（选填）"><%= course.getDescription() != null ? course.getDescription() : "" %></textarea>
                        <div class="help-text">最多500字符</div>
                    </div>
                </div>

                <!-- 表单操作按钮 -->
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">保存修改</button>
                    <a href="ViewScheduleServlet" class="btn btn-secondary">取消</a>
                </div>
            </form>

            <!-- 删除课程区域 -->
            <div class="delete-section">
                <div class="delete-warning">
                    <strong>危险操作：</strong> 删除课程将永久移除所有相关数据，此操作无法撤销。
                </div>
                <div class="form-actions">                    <a href="DeleteCourseServlet?courseId=<%= course.getCourseId() %>" 
                       class="btn btn-danger"
                       onclick="return confirm('确定要删除课程「<%= course.getCourseName() %>」吗？此操作无法撤销！')">
                        删除课程
                    </a>
                </div>
            </div>
        </div>
    </div>    <script src="<%= request.getContextPath() %>/js/edit-course.js"></script>
</body>
</html>
