package com.schedule.servlet;

import java.io.IOException;

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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");        String courseIdStr = request.getParameter("courseId");
        String confirm = request.getParameter("confirm");

        if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
            response.sendRedirect("ViewScheduleServlet?error=课程ID无效");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
              // 查找课程
            Course course = courseDAO.findById(courseId);
            
            if (course == null) {
                response.sendRedirect("ViewScheduleServlet?error=课程不存在");
                return;
            }

            // 检查权限：用户只能删除自己的课程
            if (course.getUserId() != currentUser.getUserId()) {
                response.sendRedirect("ViewScheduleServlet?error=无权限删除此课程");
                return;
            }

            // 如果用户已确认删除
            if ("true".equals(confirm)) {
                boolean success = courseDAO.deleteCourse(courseId, currentUser.getUserId());
                  if (success) {
                    session.setAttribute("successMessage", "课程 \"" + course.getCourseName() + "\" 已成功删除！");
                    response.sendRedirect("ViewScheduleServlet");
                } else {
                    response.sendRedirect("ViewScheduleServlet?error=删除课程失败，请稍后重试");
                }            } else {
                // 显示确认删除页面
                request.setAttribute("course", course);
                request.getRequestDispatcher("/confirm-delete.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewScheduleServlet?error=课程ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewScheduleServlet?error=系统错误");
        }
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");

        try {
            // 获取课程ID
            String courseIdStr = request.getParameter("courseId");            if (courseIdStr == null || courseIdStr.trim().isEmpty()) {
                response.sendRedirect("ViewScheduleServlet?error=课程ID无效");
                return;
            }

            int courseId = Integer.parseInt(courseIdStr);

            // 验证课程存在且属于当前用户
            Course existingCourse = courseDAO.findById(courseId);
            if (existingCourse == null) {
                response.sendRedirect("ViewScheduleServlet?error=课程不存在");
                return;
            }

            if (existingCourse.getUserId() != currentUser.getUserId()) {
                response.sendRedirect("ViewScheduleServlet?error=无权限删除此课程");
                return;
            }

            // 执行删除操作
            boolean success = courseDAO.deleteCourse(courseId, currentUser.getUserId());
              if (success) {
                session.setAttribute("successMessage", "课程 \"" + existingCourse.getCourseName() + "\" 已成功删除！");
                response.sendRedirect("ViewScheduleServlet");
            } else {
                response.sendRedirect("ViewScheduleServlet?error=删除课程失败，请稍后重试");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("ViewScheduleServlet?error=课程ID格式错误");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ViewScheduleServlet?error=系统错误");
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
