package com.schedule.servlet;

import java.io.IOException;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.CourseDAO;
import com.schedule.dao.UserDAO;
import com.schedule.model.Course;
import com.schedule.model.User;
import com.schedule.util.SecurityUtil;

/**
 * 管理员课程管理Servlet
 * 处理管理员对课程的增删改查操作
 */
public class AdminCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员权限
        if (!checkAdminPermission(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listCourses(request, response);
                    break;
                case "edit":
                    editCourse(request, response);
                    break;
                case "view":
                    viewCourse(request, response);
                    break;
                case "userCourses":
                    viewUserCourses(request, response);
                    break;
                default:
                    listCourses(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败：" + e.getMessage());
            listCourses(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员权限
        if (!checkAdminPermission(request, response)) {
            return;
        }

        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        try {
            switch (action) {
                case "update":
                    updateCourse(request, response, session);
                    break;
                case "delete":
                    deleteCourse(request, response, session);
                    break;
                case "deleteUserCourses":
                    deleteUserCourses(request, response, session);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/courses");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "操作失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        }
    }

    /**
     * 检查管理员权限
     */
    private boolean checkAdminPermission(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return false;
        }

        User currentUser = (User) session.getAttribute("user");
        if (!"admin".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return false;
        }
        return true;
    }

    /**
     * 显示所有课程列表
     */
    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Course> courses = courseDAO.getAllCourses();
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("courses", courses);
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin-courses.jsp").forward(request, response);
    }

    /**
     * 编辑课程页面
     */
    private void editCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程ID无效");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.findById(courseId);
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程不存在");
                return;
            }

            // 获取课程所属用户信息
            User courseOwner = userDAO.findById(course.getUserId());
            List<User> allUsers = userDAO.getAllUsers();

            request.setAttribute("editCourse", course);
            request.setAttribute("courseOwner", courseOwner);
            request.setAttribute("allUsers", allUsers);
            request.getRequestDispatcher("/admin-course-edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程ID格式错误");
        }
    }

    /**
     * 查看课程详情
     */
    private void viewCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程ID无效");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.findById(courseId);
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程不存在");
                return;
            }

            // 获取课程所属用户信息
            User courseOwner = userDAO.findById(course.getUserId());

            request.setAttribute("viewCourse", course);
            request.setAttribute("courseOwner", courseOwner);
            request.getRequestDispatcher("/admin-course-view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=课程ID格式错误");
        }
    }

    /**
     * 查看指定用户的课程
     */
    private void viewUserCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=用户ID无效");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/courses?error=用户不存在");
                return;
            }

            List<Course> userCourses = courseDAO.findByUserId(userId);

            request.setAttribute("selectedUser", user);
            request.setAttribute("userCourses", userCourses);
            request.getRequestDispatcher("/admin-user-courses.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?error=用户ID格式错误");
        }
    }

    /**
     * 更新课程信息
     */
    private void updateCourse(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String courseIdStr = request.getParameter("courseId");
        String courseName = request.getParameter("courseName");
        String instructor = request.getParameter("instructor");
        String classroom = request.getParameter("classroom");
        String dayOfWeekStr = request.getParameter("dayOfWeek");
        String startTimeStr = request.getParameter("startTime");
        String endTimeStr = request.getParameter("endTime");
        String weekStartStr = request.getParameter("weekStart");
        String weekEndStr = request.getParameter("weekEnd");
        String courseType = request.getParameter("courseType");
        String creditsStr = request.getParameter("credits");
        String description = request.getParameter("description");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "课程ID无效");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course existingCourse = courseDAO.findById(courseId);
            if (existingCourse == null) {
                session.setAttribute("errorMessage", "课程不存在");
                response.sendRedirect(request.getContextPath() + "/admin/courses");
                return;
            }

            // 验证必填字段
            if (courseName == null || courseName.trim().isEmpty()) {
                session.setAttribute("errorMessage", "课程名称不能为空");
                response.sendRedirect(request.getContextPath() + "/admin/courses?action=edit&courseId=" + courseId);
                return;
            }

            if (dayOfWeekStr == null || startTimeStr == null || endTimeStr == null) {
                session.setAttribute("errorMessage", "时间信息不能为空");
                response.sendRedirect(request.getContextPath() + "/admin/courses?action=edit&courseId=" + courseId);
                return;
            }

            // 清理和验证输入数据
            courseName = SecurityUtil.cleanXSS(courseName.trim());
            instructor = instructor != null ? SecurityUtil.cleanXSS(instructor.trim()) : "";
            classroom = classroom != null ? SecurityUtil.cleanXSS(classroom.trim()) : "";
            courseType = courseType != null ? SecurityUtil.cleanXSS(courseType.trim()) : "";
            description = description != null ? SecurityUtil.cleanXSS(description.trim()) : "";

            // 解析数值字段
            int dayOfWeek = Integer.parseInt(dayOfWeekStr);
            LocalTime startTime = LocalTime.parse(startTimeStr);
            LocalTime endTime = LocalTime.parse(endTimeStr);

            if (startTime.compareTo(endTime) >= 0) {
                session.setAttribute("errorMessage", "开始时间必须早于结束时间");
                response.sendRedirect(request.getContextPath() + "/admin/courses?action=edit&courseId=" + courseId);
                return;
            }

            int weekStart = 0, weekEnd = 0, credits = 0;
            if (weekStartStr != null && !weekStartStr.trim().isEmpty()) {
                weekStart = Integer.parseInt(weekStartStr);
            }
            if (weekEndStr != null && !weekEndStr.trim().isEmpty()) {
                weekEnd = Integer.parseInt(weekEndStr);
            }
            if (creditsStr != null && !creditsStr.trim().isEmpty()) {
                credits = Integer.parseInt(creditsStr);
            }

            // 更新课程对象
            Course updatedCourse = new Course();
            updatedCourse.setCourseId(courseId);
            updatedCourse.setUserId(existingCourse.getUserId()); // 保持原用户ID
            updatedCourse.setCourseName(courseName);
            updatedCourse.setInstructor(instructor);
            updatedCourse.setClassroom(classroom);
            updatedCourse.setDayOfWeek(dayOfWeek);
            updatedCourse.setStartTime(startTime);
            updatedCourse.setEndTime(endTime);
            updatedCourse.setWeekStart(weekStart);
            updatedCourse.setWeekEnd(weekEnd);
            updatedCourse.setCourseType(courseType);
            updatedCourse.setCredits(credits);
            updatedCourse.setDescription(description);

            boolean success = courseDAO.adminUpdateCourse(updatedCourse);
            if (success) {
                session.setAttribute("successMessage", "课程信息更新成功");
            } else {
                session.setAttribute("errorMessage", "更新失败，请稍后重试");
            }

            response.sendRedirect(request.getContextPath() + "/admin/courses");

        } catch (NumberFormatException | java.time.format.DateTimeParseException e) {
            session.setAttribute("errorMessage", "数据格式错误");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        }
    }

    /**
     * 删除课程
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String courseIdStr = request.getParameter("courseId");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "课程ID无效");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.findById(courseId);
            if (course == null) {
                session.setAttribute("errorMessage", "课程不存在");
                response.sendRedirect(request.getContextPath() + "/admin/courses");
                return;
            }

            boolean success = courseDAO.adminDeleteCourse(courseId);
            if (success) {
                session.setAttribute("successMessage", "课程 \"" + course.getCourseName() + "\" 已成功删除");
            } else {
                session.setAttribute("errorMessage", "删除失败，请稍后重试");
            }

            response.sendRedirect(request.getContextPath() + "/admin/courses");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "课程ID格式错误");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        }
    }

    /**
     * 删除指定用户的所有课程
     */
    private void deleteUserCourses(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "用户ID无效");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/admin/courses");
                return;
            }

            boolean success = courseDAO.deleteAllCoursesByUserId(userId);
            if (success) {
                session.setAttribute("successMessage", "用户 \"" + user.getFullName() + "\" 的所有课程已成功删除");
            } else {
                session.setAttribute("errorMessage", "删除失败，请稍后重试");
            }

            response.sendRedirect(request.getContextPath() + "/admin/courses?action=userCourses&userId=" + userId);

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "用户ID格式错误");
            response.sendRedirect(request.getContextPath() + "/admin/courses");
        }
    }
}
