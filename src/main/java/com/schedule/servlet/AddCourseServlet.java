package com.schedule.servlet;

import java.io.IOException;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;
import com.schedule.util.SecurityUtil;

/**
 * 添加课程Servlet
 * 处理课程添加请求，包括输入验证、时间冲突检测等
 */
public class AddCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // 显示添加课程页面
        request.getRequestDispatcher("/add-course.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        try {            // 获取并验证表单参数
            String courseName = SecurityUtil.sanitizeHtml(request.getParameter("courseName"));
            String instructor = SecurityUtil.sanitizeHtml(request.getParameter("instructor"));
            String classroom = SecurityUtil.sanitizeHtml(request.getParameter("classroom"));
            String dayOfWeekStr = request.getParameter("dayOfWeek");
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String weekStartStr = request.getParameter("weekStart");
            String weekEndStr = request.getParameter("weekEnd");
            String courseType = SecurityUtil.sanitizeHtml(request.getParameter("courseType"));
            String creditsStr = request.getParameter("credits");
            String description = SecurityUtil.sanitizeHtml(request.getParameter("description"));

            // 验证必填字段
            if (courseName == null || courseName.trim().isEmpty()) {
                setErrorAndForward(request, response, "课程名称不能为空");
                return;
            }

            if (dayOfWeekStr == null || startTimeStr == null || endTimeStr == null) {
                setErrorAndForward(request, response, "时间信息不能为空");
                return;
            }

            // 解析和验证数据
            int dayOfWeek;
            LocalTime startTime;
            LocalTime endTime;
            int weekStart = 1;
            int weekEnd = 18;
            int credits = 0;

            try {
                dayOfWeek = Integer.parseInt(dayOfWeekStr);
                if (dayOfWeek < 1 || dayOfWeek > 7) {
                    setErrorAndForward(request, response, "星期参数无效");
                    return;
                }
            } catch (NumberFormatException e) {
                setErrorAndForward(request, response, "星期参数格式错误");
                return;
            }

            try {
                startTime = LocalTime.parse(startTimeStr);
                endTime = LocalTime.parse(endTimeStr);
                
                if (!startTime.isBefore(endTime)) {
                    setErrorAndForward(request, response, "开始时间必须早于结束时间");
                    return;
                }
            } catch (DateTimeParseException e) {
                setErrorAndForward(request, response, "时间格式错误，请使用HH:MM格式");
                return;
            }

            // 解析周次范围
            if (weekStartStr != null && !weekStartStr.trim().isEmpty()) {
                try {
                    weekStart = Integer.parseInt(weekStartStr.trim());
                    if (weekStart < 1 || weekStart > 30) {
                        setErrorAndForward(request, response, "开始周次应在1-30之间");
                        return;
                    }
                } catch (NumberFormatException e) {
                    setErrorAndForward(request, response, "开始周次格式错误");
                    return;
                }
            }

            if (weekEndStr != null && !weekEndStr.trim().isEmpty()) {
                try {
                    weekEnd = Integer.parseInt(weekEndStr.trim());
                    if (weekEnd < 1 || weekEnd > 30) {
                        setErrorAndForward(request, response, "结束周次应在1-30之间");
                        return;
                    }
                } catch (NumberFormatException e) {
                    setErrorAndForward(request, response, "结束周次格式错误");
                    return;
                }
            }

            if (weekStart > weekEnd) {
                setErrorAndForward(request, response, "开始周次不能大于结束周次");
                return;
            }

            // 解析学分
            if (creditsStr != null && !creditsStr.trim().isEmpty()) {
                try {
                    credits = Integer.parseInt(creditsStr.trim());
                    if (credits < 0 || credits > 10) {
                        setErrorAndForward(request, response, "学分应在0-10之间");
                        return;
                    }
                } catch (NumberFormatException e) {
                    setErrorAndForward(request, response, "学分格式错误");
                    return;
                }
            }

            // 创建课程对象
            Course newCourse = new Course();
            newCourse.setUserId(currentUser.getUserId());
            newCourse.setCourseName(courseName.trim());
            newCourse.setInstructor(instructor != null ? instructor.trim() : "");
            newCourse.setClassroom(classroom != null ? classroom.trim() : "");
            newCourse.setDayOfWeek(dayOfWeek);
            newCourse.setStartTime(startTime);
            newCourse.setEndTime(endTime);
            newCourse.setWeekStart(weekStart);
            newCourse.setWeekEnd(weekEnd);
            newCourse.setCourseType(courseType != null ? courseType.trim() : "");
            newCourse.setCredits(credits);
            newCourse.setDescription(description != null ? description.trim() : "");

            // 检查时间冲突
            List<Course> conflictCourses = courseDAO.checkTimeConflict(newCourse);
            if (!conflictCourses.isEmpty()) {
                StringBuilder conflictMsg = new StringBuilder("时间冲突！与以下课程时间重叠：");
                for (Course conflict : conflictCourses) {
                    conflictMsg.append("\n- ").append(conflict.getCourseName())
                              .append("（").append(conflict.getDayOfWeekName())
                              .append(" ").append(conflict.getStartTime())
                              .append("-").append(conflict.getEndTime()).append("）");
                }
                setErrorAndForward(request, response, conflictMsg.toString());
                return;
            }

            // 检查课程名称是否重复
            if (courseDAO.isCourseNameExists(courseName.trim(), currentUser.getUserId(), 0)) {
                setErrorAndForward(request, response, "课程名称已存在，请使用不同的名称");
                return;
            }

            // 添加课程
            boolean success = courseDAO.addCourse(newCourse);
              if (success) {
                // 添加成功，重定向到课程表页面
                session.setAttribute("successMessage", "课程添加成功！");
                response.sendRedirect("ViewScheduleServlet");
            } else {
                setErrorAndForward(request, response, "添加课程失败，请稍后重试");
            }

        } catch (Exception e) {
            e.printStackTrace();
            setErrorAndForward(request, response, "系统错误：" + e.getMessage());
        }
    }

    /**
     * 设置错误信息并转发到添加课程页面
     */
    private void setErrorAndForward(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        
        // 保留用户输入的数据
        request.setAttribute("courseName", request.getParameter("courseName"));
        request.setAttribute("instructor", request.getParameter("instructor"));
        request.setAttribute("classroom", request.getParameter("classroom"));
        request.setAttribute("dayOfWeek", request.getParameter("dayOfWeek"));
        request.setAttribute("startTime", request.getParameter("startTime"));
        request.setAttribute("endTime", request.getParameter("endTime"));
        request.setAttribute("weekStart", request.getParameter("weekStart"));
        request.setAttribute("weekEnd", request.getParameter("weekEnd"));
        request.setAttribute("courseType", request.getParameter("courseType"));
        request.setAttribute("credits", request.getParameter("credits"));
        request.setAttribute("description", request.getParameter("description"));
        
        request.getRequestDispatcher("/add-course.jsp").forward(request, response);
    }
}
