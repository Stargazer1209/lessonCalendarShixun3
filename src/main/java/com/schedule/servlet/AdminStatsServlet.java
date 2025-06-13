package com.schedule.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.CourseDAO;
import com.schedule.dao.UserDAO;
import com.schedule.model.Course;
import com.schedule.model.User;

/**
 * 管理员统计信息Servlet
 * 提供系统的统计数据和概览信息
 */
public class AdminStatsServlet extends HttpServlet {
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

        try {
            // 获取用户统计信息
            Map<String, Integer> userStats = userDAO.getUserStats();
            request.setAttribute("userStats", userStats);

            // 获取课程统计信息
            Map<String, Object> courseStats = courseDAO.getCourseStats();
            request.setAttribute("courseStats", courseStats);

            // 获取详细统计信息
            Map<String, Object> detailedStats = getDetailedStats();
            request.setAttribute("detailedStats", detailedStats);

            // 获取最近活动信息
            List<User> recentUsers = getRecentUsers();
            request.setAttribute("recentUsers", recentUsers);

            // 转发到统计页面
            request.getRequestDispatcher("/admin-stats.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "获取统计数据时发生错误：" + e.getMessage());
            request.getRequestDispatcher("/admin-stats.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
     * 获取详细统计信息
     */
    private Map<String, Object> getDetailedStats() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            // 获取所有用户和课程
            List<User> allUsers = userDAO.getAllUsers();
            List<Course> allCourses = courseDAO.getAllCourses();
            
            // 计算平均课程数
            if (!allUsers.isEmpty()) {
                double avgCoursesPerUser = (double) allCourses.size() / allUsers.size();
                stats.put("avgCoursesPerUser", Math.round(avgCoursesPerUser * 100.0) / 100.0);
            } else {
                stats.put("avgCoursesPerUser", 0.0);
            }
            
            // 按星期统计课程分布
            Map<String, Integer> dayDistribution = new HashMap<>();
            String[] dayNames = {"", "周一", "周二", "周三", "周四", "周五", "周六", "周日"};
            for (int i = 1; i <= 7; i++) {
                dayDistribution.put(dayNames[i], 0);
            }
            
            for (Course course : allCourses) {
                String dayName = dayNames[course.getDayOfWeek()];
                dayDistribution.put(dayName, dayDistribution.get(dayName) + 1);
            }
            stats.put("dayDistribution", dayDistribution);
            
            // 按用户统计课程数量分布
            Map<String, Integer> courseCountDistribution = new HashMap<>();
            courseCountDistribution.put("0门课程", 0);
            courseCountDistribution.put("1-5门课程", 0);
            courseCountDistribution.put("6-10门课程", 0);
            courseCountDistribution.put("11门以上课程", 0);
            
            for (User user : allUsers) {
                int courseCount = courseDAO.getCourseCount(user.getUserId());
                if (courseCount == 0) {
                    courseCountDistribution.put("0门课程", courseCountDistribution.get("0门课程") + 1);
                } else if (courseCount <= 5) {
                    courseCountDistribution.put("1-5门课程", courseCountDistribution.get("1-5门课程") + 1);
                } else if (courseCount <= 10) {
                    courseCountDistribution.put("6-10门课程", courseCountDistribution.get("6-10门课程") + 1);
                } else {
                    courseCountDistribution.put("11门以上课程", courseCountDistribution.get("11门以上课程") + 1);
                }
            }
            stats.put("courseCountDistribution", courseCountDistribution);
            
            // 最活跃用户（课程数量最多的用户）
            User mostActiveUser = null;
            int maxCourses = 0;
            for (User user : allUsers) {
                int courseCount = courseDAO.getCourseCount(user.getUserId());
                if (courseCount > maxCourses) {
                    maxCourses = courseCount;
                    mostActiveUser = user;
                }
            }
            if (mostActiveUser != null) {
                Map<String, Object> mostActiveUserInfo = new HashMap<>();
                mostActiveUserInfo.put("user", mostActiveUser);
                mostActiveUserInfo.put("courseCount", maxCourses);
                stats.put("mostActiveUser", mostActiveUserInfo);
            }
            
            // 统计学分信息
            double totalCredits = 0;
            int coursesWithCredits = 0;
            for (Course course : allCourses) {
                if (course.getCredits() > 0) {
                    totalCredits += course.getCredits();
                    coursesWithCredits++;
                }
            }
            stats.put("totalCredits", totalCredits);
            if (coursesWithCredits > 0) {
                stats.put("avgCreditsPerCourse", Math.round((totalCredits / coursesWithCredits) * 100.0) / 100.0);
            } else {
                stats.put("avgCreditsPerCourse", 0.0);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            // 如果出错，返回空统计
            stats.put("error", "统计数据计算失败");
        }
        
        return stats;
    }
    
    /**
     * 获取最近注册的用户
     */
    private List<User> getRecentUsers() {
        List<User> allUsers = userDAO.getAllUsers();
        
        // 返回最近的5个用户（按创建时间倒序）
        if (allUsers.size() <= 5) {
            return allUsers;
        } else {
            return allUsers.subList(0, 5);
        }
    }
}
