package com.schedule.servlet;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;

/**
 * 删除课程Servlet
 * 处理课程删除请求，包括权限检查和确认机制
 */
public class DeleteCourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(DeleteCourseServlet.class.getName());
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("DeleteCourseServlet doGet - 开始处理删除课程请求");

        // 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            logger.warning("DeleteCourseServlet doGet - 用户未登录，重定向到登录页面");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User currentUser = (User) session.getAttribute("user");

        // 获取课程ID参数，支持id和courseId两种参数名
        String courseIdStr = request.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            courseIdStr = request.getParameter("id");
        }
        String confirm = request.getParameter("confirm");

        logger.info("DeleteCourseServlet doGet - 接收到参数: courseId=" + courseIdStr + ", confirm=" + confirm);

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            logger.warning("DeleteCourseServlet doGet - 课程ID无效或为空");
            session.setAttribute("errorMessage", "课程ID无效");
            response.sendRedirect("ViewScheduleServlet");
            return;
        }
        try {
            int courseId = Integer.parseInt(courseIdStr);
            logger.info("DeleteCourseServlet doGet - 正在查找课程ID: " + courseId);

            // 查找课程
            Course course = courseDAO.findById(courseId);

            if (course == null) {
                logger.warning("DeleteCourseServlet doGet - 课程不存在，courseId: " + courseId);
                session.setAttribute("errorMessage", "课程不存在");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }            // 检查权限：用户只能删除自己的课程
            if (course.getUserId() != currentUser.getUserId()) {
                logger.warning("DeleteCourseServlet doGet - 用户无权删除此课程，用户ID: " + currentUser.getUserId() + ", 课程所有者ID: "
                        + course.getUserId());
                session.setAttribute("errorMessage", "您无权删除此课程");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }

            // 直接执行删除操作（JSP页面已经通过JavaScript确认）
            logger.info("DeleteCourseServlet doGet - 开始执行删除操作，课程ID: " + courseId + ", 课程名称: " + course.getCourseName());
            boolean success = courseDAO.deleteCourse(courseId, currentUser.getUserId());
            if (success) {
                logger.info("DeleteCourseServlet doGet - 删除成功，课程: " + course.getCourseName());
                session.setAttribute("successMessage", "课程 \"" + course.getCourseName() + "\" 已成功删除！");
                response.sendRedirect("ViewScheduleServlet");
            } else {
                logger.severe("DeleteCourseServlet doGet - 删除失败，课程ID: " + courseId + ", 课程名称: " + course.getCourseName());
                session.setAttribute("errorMessage", "删除课程失败，请稍后重试");
                response.sendRedirect("ViewScheduleServlet");
            }
        } catch (NumberFormatException e) {
            logger.severe("DeleteCourseServlet doGet - 课程ID格式错误: " + courseIdStr);
            session.setAttribute("errorMessage", "课程ID格式错误");
            response.sendRedirect("ViewScheduleServlet");
        } catch (Exception e) {
            logger.severe("DeleteCourseServlet doGet - 系统错误: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "系统错误：" + e.getMessage());
            response.sendRedirect("ViewScheduleServlet");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        logger.info("DeleteCourseServlet doPost - 开始处理POST删除课程请求");

        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            logger.warning("DeleteCourseServlet doPost - 用户未登录，重定向到登录页面");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        try {
            // 获取课程ID，支持id和courseId两种参数名
            String courseIdStr = request.getParameter("courseId");
            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                courseIdStr = request.getParameter("id");
            }
            logger.info("DeleteCourseServlet doPost - 接收到课程ID参数: " + courseIdStr);

            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                logger.warning("DeleteCourseServlet doPost - 课程ID无效或为空");
                session.setAttribute("errorMessage", "课程ID无效");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);
            logger.info("DeleteCourseServlet doPost - 正在查找课程ID: " + courseId); // 验证课程存在且属于当前用户
            Course existingCourse = courseDAO.findById(courseId);
            if (existingCourse == null) {
                logger.warning("DeleteCourseServlet doPost - 课程不存在，courseId: " + courseId);
                session.setAttribute("errorMessage", "课程不存在");
                response.sendRedirect("ViewScheduleServlet");
                return;
            }

            if (existingCourse.getUserId() != currentUser.getUserId()) {
                logger.warning("DeleteCourseServlet doPost - 用户无权删除此课程，用户ID: " + currentUser.getUserId() + ", 课程所有者ID: "
                        + existingCourse.getUserId());
                session.setAttribute("errorMessage", "您无权删除此课程");
                response.sendRedirect("ViewScheduleServlet");
                return;
            } // 执行删除操作
            logger.info("DeleteCourseServlet doPost - 开始执行删除操作，课程ID: " + courseId + ", 课程名称: "
                    + existingCourse.getCourseName());
            boolean success = courseDAO.deleteCourse(courseId, currentUser.getUserId());
            if (success) {
                logger.info("DeleteCourseServlet doPost - 删除成功，课程: " + existingCourse.getCourseName());
                session.setAttribute("successMessage", "课程 \"" + existingCourse.getCourseName() + "\" 已成功删除！");
                response.sendRedirect("ViewScheduleServlet");
            } else {
                logger.severe("DeleteCourseServlet doPost - 删除失败，课程ID: " + courseId + ", 课程名称: "
                        + existingCourse.getCourseName());
                session.setAttribute("errorMessage", "删除课程失败，请稍后重试");
                response.sendRedirect("ViewScheduleServlet");
            }
        } catch (NumberFormatException e) {
            logger.severe("DeleteCourseServlet doPost - 课程ID格式错误: " + request.getParameter("courseId"));
            session.setAttribute("errorMessage", "课程ID格式错误");
            response.sendRedirect("ViewScheduleServlet");
        } catch (Exception e) {
            logger.severe("DeleteCourseServlet doPost - 系统错误: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "系统错误");
            response.sendRedirect("ViewScheduleServlet");
        }
    }

    /**
     * 批量删除课程（用于清空所有课程等场景）
     */
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置请求编码
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // 检查用户是否已登录
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"用户未登录\"}");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("deleteAll".equals(action)) {
                // 删除用户的所有课程
                boolean success = courseDAO.deleteAllCoursesByUserId(currentUser.getUserId());

                if (success) {
                    response.getWriter().write("{\"success\": true, \"message\": \"所有课程已成功删除\"}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"删除失败，请稍后重试\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"无效的操作\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"系统错误\"}");
        }
    }
}
