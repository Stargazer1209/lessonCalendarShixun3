package com.schedule.servlet;

import com.schedule.dao.CourseDAO;
import com.schedule.model.Course;
import com.schedule.model.User;
import com.schedule.util.JsonResponse;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
// import java.time.DayOfWeek;
import java.time.LocalDate;
// import java.time.temporal.TemporalAdjusters;
import java.util.List;

/**
 * 用户统计数据Servlet
 * 提供用户课程统计信息
 */
@WebServlet("/UserStatsServlet")
public class UserStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO = new CourseDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        PrintWriter out = response.getWriter();
        
        try {
            // 检查用户登录状态
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("user") == null) {
                out.print(JsonResponse.error("用户未登录"));
                return;
            }
            
            User user = (User) session.getAttribute("user");
            int userId = user.getUserId();
            
            // 获取用户所有课程
            List<Course> allCourses = courseDAO.findByUserId(userId);
            
            // 计算统计数据
            int totalCourses = allCourses.size();
            int thisWeekCourses = calculateThisWeekCourses(allCourses);
            int todayCourses = calculateTodayCourses(allCourses);
            int completionRate = calculateCompletionRate(allCourses);
            
            // 构建响应数据
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("{")
                      .append("\"status\":\"success\",")
                      .append("\"totalCourses\":").append(totalCourses).append(",")
                      .append("\"thisWeekCourses\":").append(thisWeekCourses).append(",")
                      .append("\"todayCourses\":").append(todayCourses).append(",")
                      .append("\"completionRate\":").append(completionRate).append(",")
                      .append("\"timestamp\":\"").append(java.time.LocalDateTime.now()).append("\"")
                      .append("}");
            
            out.print(jsonBuilder.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print(JsonResponse.error("获取统计数据失败: " + e.getMessage()));
        }
    }
    
    /**
     * 计算本周课程数量
     */
    private int calculateThisWeekCourses(List<Course> courses) {
        // LocalDate today = LocalDate.now();
        // LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        // LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));
        
        int currentWeek = getCurrentWeekNumber();
        int count = 0;
        
        for (Course course : courses) {
            // 检查课程是否在当前周次范围内
            if (currentWeek >= course.getWeekStart() && currentWeek <= course.getWeekEnd()) {
                count++;
            }
        }
        
        return count;
    }
    
    /**
     * 计算今天的课程数量
     */
    private int calculateTodayCourses(List<Course> courses) {
        int todayOfWeek = LocalDate.now().getDayOfWeek().getValue(); // 1=Monday, 7=Sunday
        int currentWeek = getCurrentWeekNumber();
        int count = 0;
        
        for (Course course : courses) {
            // 检查是否是今天，并且在当前周次范围内
            if (course.getDayOfWeek() == todayOfWeek && 
                currentWeek >= course.getWeekStart() && 
                currentWeek <= course.getWeekEnd()) {
                count++;
            }
        }
        
        return count;
    }
    
    /**
     * 计算完成率（这里简化为活跃课程的百分比）
     */
    private int calculateCompletionRate(List<Course> courses) {
        if (courses.isEmpty()) {
            return 0;
        }
        
        int currentWeek = getCurrentWeekNumber();
        int activeCourses = 0;
        
        for (Course course : courses) {
            // 计算当前周次内的活跃课程
            if (currentWeek >= course.getWeekStart() && currentWeek <= course.getWeekEnd()) {
                activeCourses++;
            }
        }
        
        // 计算活跃课程占总课程的百分比
        return courses.size() > 0 ? (activeCourses * 100) / courses.size() : 0;
    }
    
    /**
     * 获取当前周次（简化计算，假设学期从第1周开始）
     * 实际项目中可能需要配置学期开始日期
     */
    private int getCurrentWeekNumber() {
        // 这里简化处理，假设当前是第10周
        // 实际应用中需要根据学期开始日期计算
        LocalDate today = LocalDate.now();
        LocalDate semesterStart = LocalDate.of(2024, 9, 1); // 假设学期开始日期
        
        long daysDiff = java.time.temporal.ChronoUnit.DAYS.between(semesterStart, today);
        int weekNumber = (int) (daysDiff / 7) + 1;
        
        // 限制在合理范围内
        return Math.max(1, Math.min(20, weekNumber));
    }
}