package com.schedule.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;

/**
 * 查看课程表Servlet
 * 处理课程表数据查询、格式化和不同视图展示
 */
public class ViewScheduleServlet extends HttpServlet {
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

        User currentUser = (User) session.getAttribute("user");

        try {
            // 获取视图类型参数
            String viewType = request.getParameter("view");
            if (viewType == null || viewType.trim().isEmpty()) {
                viewType = "week"; // 默认为周视图
            }

            // 获取特定日期的课程（用于日视图）
            String dayParam = request.getParameter("day");
            int specificDay = 0;
            if (dayParam != null && !dayParam.trim().isEmpty()) {
                try {
                    specificDay = Integer.parseInt(dayParam);
                    if (specificDay < 1 || specificDay > 7) {
                        specificDay = 0; // 无效日期，使用周视图
                    }
                } catch (NumberFormatException e) {
                    specificDay = 0;
                }
            }

            // 获取课程类型过滤参数
            String courseTypeFilter = request.getParameter("courseType");

            // 查询课程数据
            List<Course> userCourses;
            
            if (specificDay > 0) {
                // 查询特定日期的课程
                userCourses = courseDAO.findByUserIdAndDay(currentUser.getUserId(), specificDay);
                viewType = "day";
            } else if (courseTypeFilter != null && !courseTypeFilter.trim().isEmpty() && !"all".equals(courseTypeFilter)) {
                // 按课程类型过滤
                userCourses = courseDAO.findByCourseType(currentUser.getUserId(), courseTypeFilter);
            } else {
                // 查询所有课程
                userCourses = courseDAO.findByUserId(currentUser.getUserId());
            }            // 根据视图类型格式化数据
            if ("day".equals(viewType) && specificDay > 0) {
                // 日视图：显示特定日期的课程
                request.setAttribute("viewType", "day");
                request.setAttribute("currentDay", specificDay);
                request.setAttribute("currentDayName", getDayName(specificDay));
                request.setAttribute("dayCourses", userCourses);
                
            } else if ("list".equals(viewType)) {
                // 列表视图：按课程名称排序的简单列表
                request.setAttribute("viewType", "list");
                request.setAttribute("allCourses", userCourses);
                
            } else {
                // 周视图：按星期分组的课程表格
                request.setAttribute("viewType", "week");
                Map<Integer, List<Course>> weekSchedule = organizeByWeek(userCourses);
                request.setAttribute("weekSchedule", weekSchedule);
            }

            // 无论什么视图类型，都设置courses属性供JSP使用
            request.setAttribute("courses", userCourses);

            // 计算统计信息
            int totalCourses = userCourses.size();
            double totalCredits = courseDAO.getTotalCredits(currentUser.getUserId());
            
            // 按课程类型统计
            Map<String, Integer> courseTypeStats = new HashMap<>();
            for (Course course : userCourses) {
                String type = course.getCourseType();
                if (type == null || type.trim().isEmpty()) {
                    type = "未分类";
                }
                courseTypeStats.put(type, courseTypeStats.getOrDefault(type, 0) + 1);
            }

            // 检查时间冲突
            List<String> conflictWarnings = checkAllTimeConflicts(userCourses);

            // 设置请求属性
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("totalCredits", totalCredits);
            request.setAttribute("courseTypeStats", courseTypeStats);
            request.setAttribute("conflictWarnings", conflictWarnings);
            request.setAttribute("selectedCourseType", courseTypeFilter);

            // 获取成功或错误消息
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = request.getParameter("error");
            
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
                session.removeAttribute("successMessage");
            }
            
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
            }

            // 转发到课程表页面
            request.getRequestDispatcher("/view-schedule.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "加载课程表失败：" + e.getMessage());
            request.getRequestDispatcher("/view-schedule.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST请求重定向到GET请求
        doGet(request, response);
    }

    /**
     * 按星期组织课程数据
     */
    private Map<Integer, List<Course>> organizeByWeek(List<Course> courses) {
        Map<Integer, List<Course>> weekSchedule = new HashMap<>();
        
        // 初始化每天的课程列表
        for (int day = 1; day <= 7; day++) {
            weekSchedule.put(day, new ArrayList<>());
        }
        
        // 将课程分配到对应的星期
        for (Course course : courses) {
            int dayOfWeek = course.getDayOfWeek();
            if (dayOfWeek >= 1 && dayOfWeek <= 7) {
                weekSchedule.get(dayOfWeek).add(course);
            }
        }
        
        // 对每天的课程按开始时间排序
        for (List<Course> dayCourses : weekSchedule.values()) {
            dayCourses.sort((c1, c2) -> c1.getStartTime().compareTo(c2.getStartTime()));
        }
        
        return weekSchedule;
    }

    /**
     * 检查所有课程的时间冲突
     */
    private List<String> checkAllTimeConflicts(List<Course> courses) {
        List<String> warnings = new ArrayList<>();
        
        for (int i = 0; i < courses.size(); i++) {
            Course course1 = courses.get(i);
            
            for (int j = i + 1; j < courses.size(); j++) {
                Course course2 = courses.get(j);
                
                // 检查是否为同一天
                if (course1.getDayOfWeek() == course2.getDayOfWeek()) {
                    // 检查时间是否重叠
                    if (course1.isTimeConflict(course2)) {
                        String warning = String.format("时间冲突：%s 与 %s 在%s的时间重叠（%s-%s 与 %s-%s）",
                            course1.getCourseName(),
                            course2.getCourseName(),
                            course1.getDayOfWeekName(),
                            course1.getStartTime(),
                            course1.getEndTime(),
                            course2.getStartTime(),
                            course2.getEndTime()
                        );
                        warnings.add(warning);
                    }
                }
            }
        }
        
        return warnings;
    }

    /**
     * 获取星期几的中文名称
     */
    private String getDayName(int dayOfWeek) {
        String[] dayNames = {"", "周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        if (dayOfWeek >= 1 && dayOfWeek <= 7) {
            return dayNames[dayOfWeek];
        }
        return "未知";
    }
}
