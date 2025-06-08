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
        response.sendRedirect("ViewScheduleServlet?error=课程信息未找到");
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
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-size: 1.8rem;
            font-weight: bold;
            color: #667eea;
            text-decoration: none;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        .nav-link {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }

        .nav-link:hover, .nav-link.active {
            background: #667eea;
            color: white;
        }

        /* 主要内容区域 */
        .main-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .form-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
        }

        .page-title {
            font-size: 2rem;
            font-weight: bold;
            color: #333;
            text-align: center;
            margin-bottom: 10px;
        }

        .course-info {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            background: white;
        }

        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-textarea {
            resize: vertical;
            min-height: 100px;
        }

        .time-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .week-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
            transform: translateY(-2px);
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        /* 消息样式 */
        .alert {
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* 必填字段标记 */
        .required {
            color: #dc3545;
        }

        /* 帮助文本 */
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        /* 响应式设计 */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .nav-menu {
                display: none;
            }

            .form-container {
                padding: 20px;
                margin: 20px;
            }

            .time-inputs, .week-inputs {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
                align-items: center;
            }
        }

        /* 删除确认样式 */
        .delete-section {
            border-top: 1px solid #e1e5e9;
            margin-top: 30px;
            padding-top: 30px;
        }

        .delete-warning {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand">课灵通</a>
            <ul class="nav-menu">
                <li><a href="index.jsp" class="nav-link">首页</a></li>                <li><a href="ViewScheduleServlet" class="nav-link">课程表</a></li>
                <li><a href="add-course.jsp" class="nav-link">添加课程</a></li>
                <li><a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-link">退出登录</a></li>
            </ul>
        </div>
    </nav>

    <!-- 主要内容 -->
    <div class="main-container">
        <div class="form-container">
            <h1 class="page-title">编辑课程</h1>
            <div class="course-info">
                课程ID: <%= course.getCourseId() %> | 创建时间: <%= course.getCreatedAt() != null ? course.getCreatedAt() : "未知" %>
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
    </div>

    <script>
        // 表单验证
        document.getElementById('editCourseForm').addEventListener('submit', function(e) {
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

            // 确认修改
            return confirm('确定要保存对课程的修改吗？');
        });

        // 实时字符计数
        const descriptionTextarea = document.getElementById('description');
        const helpText = descriptionTextarea.nextElementSibling;
        
        descriptionTextarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            const maxLength = 500;
            helpText.textContent = `已输入 ${currentLength}/${maxLength} 字符`;
            
            if (currentLength > maxLength * 0.9) {
                helpText.style.color = '#dc3545';
            } else {
                helpText.style.color = '#6c757d';
            }
        });

        // 页面加载时更新字符计数
        descriptionTextarea.dispatchEvent(new Event('input'));
    </script>
</body>
</html>
