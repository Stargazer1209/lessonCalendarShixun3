package com.schedule.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.UserDAO;
import com.schedule.dao.CourseDAO;
import com.schedule.model.User;
import com.schedule.util.SecurityUtil;

/**
 * 管理员用户管理Servlet
 * 处理管理员对用户的增删改查操作
 */
public class AdminUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private CourseDAO courseDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        courseDAO = new CourseDAO();
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
                    listUsers(request, response);
                    break;
                case "edit":
                    editUser(request, response);
                    break;
                case "view":
                    viewUser(request, response);
                    break;
                default:
                    listUsers(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败：" + e.getMessage());
            listUsers(request, response);
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
                    updateUser(request, response, session);
                    break;
                case "delete":
                    deleteUser(request, response, session);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/users");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "操作失败：" + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
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
     * 显示用户列表
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin-users.jsp").forward(request, response);
    }

    /**
     * 编辑用户页面
     */
    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=用户ID无效");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=用户不存在");
                return;
            }

            request.setAttribute("editUser", user);
            request.getRequestDispatcher("/admin-user-edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=用户ID格式错误");
        }
    }

    /**
     * 查看用户详情
     */
    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=用户ID无效");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=用户不存在");
                return;
            }

            // 获取用户的课程列表
            List<com.schedule.model.Course> userCourses = courseDAO.findByUserId(userId);

            request.setAttribute("viewUser", user);
            request.setAttribute("userCourses", userCourses);
            request.getRequestDispatcher("/admin-user-view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users?error=用户ID格式错误");
        }
    }

    /**
     * 更新用户信息
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String userIdStr = request.getParameter("userId");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "用户ID无效");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 验证输入
            if (email == null || email.trim().isEmpty()) {
                session.setAttribute("errorMessage", "邮箱不能为空");
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                return;
            }

            if (fullName == null || fullName.trim().isEmpty()) {
                session.setAttribute("errorMessage", "姓名不能为空");
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                return;
            }

            if (role == null || role.trim().isEmpty()) {
                session.setAttribute("errorMessage", "角色不能为空");
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                return;
            }

            // 清理输入数据
            email = SecurityUtil.cleanXSS(email.trim());
            fullName = SecurityUtil.cleanXSS(fullName.trim());
            role = role.trim();

            // 验证角色
            if (!role.equals("student") && !role.equals("teacher") && !role.equals("admin")) {
                session.setAttribute("errorMessage", "无效的角色");
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                return;
            }

            // 验证邮箱格式
            if (!SecurityUtil.isValidEmail(email)) {
                session.setAttribute("errorMessage", "邮箱格式不正确");
                response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                return;
            }

            // 检查邮箱是否已被其他用户使用
            User existingUser = userDAO.findByUsername(user.getUsername()); // 先通过用户名找到原用户
            if (existingUser != null && !existingUser.getEmail().equals(email)) {
                // 邮箱有变更，检查新邮箱是否已存在
                if (userDAO.isEmailExists(email)) {
                    session.setAttribute("errorMessage", "该邮箱已被其他用户使用");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                    return;
                }
            }

            // 更新用户信息
            user.setEmail(email);
            user.setFullName(fullName);
            user.setRole(role);

            boolean updatePassword = password != null && !password.trim().isEmpty();
            if (updatePassword) {
                // 验证密码强度
                if (password.length() < 8) {
                    session.setAttribute("errorMessage", "密码长度至少8位");
                    response.sendRedirect(request.getContextPath() + "/admin/users?action=edit&userId=" + userId);
                    return;
                }
                user.setPassword(password);
            }

            boolean success = userDAO.adminUpdateUser(user, updatePassword);
            if (success) {
                session.setAttribute("successMessage", "用户信息更新成功");
            } else {
                session.setAttribute("errorMessage", "更新失败，请稍后重试");
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "用户ID格式错误");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    /**
     * 删除用户
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws IOException {
        String userIdStr = request.getParameter("userId");

        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            session.setAttribute("errorMessage", "用户ID无效");
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDAO.findById(userId);
            if (user == null) {
                session.setAttribute("errorMessage", "用户不存在");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 防止删除管理员自己
            User currentUser = (User) request.getSession().getAttribute("user");
            if (userId == currentUser.getUserId()) {
                session.setAttribute("errorMessage", "不能删除自己的账户");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }

            // 删除用户（会级联删除相关课程）
            boolean success = userDAO.adminDeleteUser(userId);
            if (success) {
                session.setAttribute("successMessage", "用户 \"" + user.getFullName() + "\" 已成功删除");
            } else {
                session.setAttribute("errorMessage", "删除失败，请稍后重试");
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "用户ID格式错误");
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
