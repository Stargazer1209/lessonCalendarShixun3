package com.schedule.dao;

import com.schedule.model.Course;
import com.schedule.util.DatabaseUtil;

import java.sql.*;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

/**
 * 课程数据访问对象
 * 提供课程的增删改查、时间冲突检测、批量操作等功能
 */
public class CourseDAO {
      /**
     * 添加新课程
     * @param course 课程对象
     * @return 添加成功返回true，否则返回false
     */
    public boolean addCourse(Course course) {
        String sql = "INSERT INTO courses (user_id, course_name, instructor, classroom, " +
                    "day_of_week, start_time, end_time, week_start, week_end, course_type, credits, description) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, course.getUserId());
            pstmt.setString(2, course.getCourseName());
            pstmt.setString(3, course.getInstructor());
            pstmt.setString(4, course.getClassroom());
            pstmt.setInt(5, course.getDayOfWeek());
            pstmt.setTime(6, Time.valueOf(course.getStartTime()));
            pstmt.setTime(7, Time.valueOf(course.getEndTime()));
            pstmt.setInt(8, course.getWeekStart());
            pstmt.setInt(9, course.getWeekEnd());
            pstmt.setString(10, course.getCourseType());
            pstmt.setInt(11, course.getCredits());
            pstmt.setString(12, course.getDescription());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // 获取生成的课程ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        course.setCourseId(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 根据ID查找课程
     * @param courseId 课程ID
     * @return 课程对象，如果不存在返回null
     */
    public Course findById(int courseId) {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * 根据用户ID查询所有课程
     * @param userId 用户ID
     * @return 课程列表
     */
    public List<Course> findByUserId(int userId) {
        String sql = "SELECT * FROM courses WHERE user_id = ? ORDER BY day_of_week, start_time";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * 根据用户ID和星期查询课程
     * @param userId 用户ID
     * @param dayOfWeek 星期几(1-7)
     * @return 课程列表
     */
    public List<Course> findByUserIdAndDay(int userId, int dayOfWeek) {
        String sql = "SELECT * FROM courses WHERE user_id = ? AND day_of_week = ? ORDER BY start_time";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, dayOfWeek);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
      /**
     * 更新课程信息
     * @param course 课程对象
     * @return 更新成功返回true，否则返回false
     */
    public boolean updateCourse(Course course) {
        String sql = "UPDATE courses SET course_name = ?, instructor = ?, classroom = ?, " +
                    "day_of_week = ?, start_time = ?, end_time = ?, week_start = ?, week_end = ?, " +
                    "course_type = ?, credits = ?, description = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE course_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getInstructor());
            pstmt.setString(3, course.getClassroom());
            pstmt.setInt(4, course.getDayOfWeek());
            pstmt.setTime(5, Time.valueOf(course.getStartTime()));
            pstmt.setTime(6, Time.valueOf(course.getEndTime()));
            pstmt.setInt(7, course.getWeekStart());
            pstmt.setInt(8, course.getWeekEnd());
            pstmt.setString(9, course.getCourseType());
            pstmt.setInt(10, course.getCredits());
            pstmt.setString(11, course.getDescription());
            pstmt.setInt(12, course.getCourseId());
            pstmt.setInt(13, course.getUserId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 删除课程
     * @param courseId 课程ID
     * @param userId 用户ID（确保用户只能删除自己的课程）
     * @return 删除成功返回true，否则返回false
     */
    public boolean deleteCourse(int courseId, int userId) {
        String sql = "DELETE FROM courses WHERE course_id = ? AND user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            pstmt.setInt(2, userId);
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 删除用户的所有课程
     * @param userId 用户ID
     * @return 删除成功返回true，否则返回false
     */
    public boolean deleteAllCoursesByUserId(int userId) {
        String sql = "DELETE FROM courses WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 检查时间冲突
     * @param course 要检查的课程
     * @return 如果存在冲突返回冲突的课程列表，否则返回空列表
     */
    public List<Course> checkTimeConflict(Course course) {
        String sql = "SELECT * FROM courses WHERE user_id = ? AND day_of_week = ? " +
                    "AND course_id != ? " +
                    "AND ((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";
        
        List<Course> conflictCourses = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, course.getUserId());
            pstmt.setInt(2, course.getDayOfWeek());
            pstmt.setInt(3, course.getCourseId()); // 排除自己
            pstmt.setTime(4, Time.valueOf(course.getStartTime()));
            pstmt.setTime(5, Time.valueOf(course.getStartTime()));
            pstmt.setTime(6, Time.valueOf(course.getEndTime()));
            pstmt.setTime(7, Time.valueOf(course.getEndTime()));
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                conflictCourses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return conflictCourses;
    }
      /**
     * 检查课程名称是否已存在（同一用户）
     * @param courseName 课程名称
     * @param userId 用户ID
     * @param excludeCourseId 排除的课程ID（用于更新时检查）
     * @return 如果存在返回true，否则返回false
     */
    public boolean isCourseNameExists(String courseName, int userId, int excludeCourseId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE course_name = ? AND user_id = ? AND course_id != ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseName);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, excludeCourseId);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * 获取用户课程统计信息
     * @param userId 用户ID
     * @return 课程数量
     */
    public int getCourseCount(int userId) {
        String sql = "SELECT COUNT(*) FROM courses WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * 获取用户总学分
     * @param userId 用户ID
     * @return 总学分数
     */
    public double getTotalCredits(int userId) {
        String sql = "SELECT SUM(credits) FROM courses WHERE user_id = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0.0;
    }
    
    /**
     * 按课程类型查询课程
     * @param userId 用户ID
     * @param courseType 课程类型
     * @return 课程列表
     */
    public List<Course> findByCourseType(int userId, String courseType) {
        String sql = "SELECT * FROM courses WHERE user_id = ? AND course_type = ? ORDER BY day_of_week, start_time";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setString(2, courseType);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
      /**
     * 批量添加课程
     * @param courses 课程列表
     * @return 成功添加的课程数量
     */
    public int batchAddCourses(List<Course> courses) {
        String sql = "INSERT INTO courses (user_id, course_name, instructor, classroom, " +
                    "day_of_week, start_time, end_time, week_start, week_end, course_type, credits, description) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        int successCount = 0;
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            conn.setAutoCommit(false); // 开启事务
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                
                for (Course course : courses) {
                    pstmt.setInt(1, course.getUserId());
                    pstmt.setString(2, course.getCourseName());
                    pstmt.setString(3, course.getInstructor());
                    pstmt.setString(4, course.getClassroom());
                    pstmt.setInt(5, course.getDayOfWeek());
                    pstmt.setTime(6, Time.valueOf(course.getStartTime()));
                    pstmt.setTime(7, Time.valueOf(course.getEndTime()));
                    pstmt.setInt(8, course.getWeekStart());
                    pstmt.setInt(9, course.getWeekEnd());
                    pstmt.setString(10, course.getCourseType());
                    pstmt.setInt(11, course.getCredits());
                    pstmt.setString(12, course.getDescription());
                    
                    pstmt.addBatch();
                }
                
                int[] results = pstmt.executeBatch();
                
                // 统计成功数量
                for (int result : results) {
                    if (result > 0) {
                        successCount++;
                    }
                }
                
                conn.commit(); // 提交事务
                
            } catch (SQLException e) {
                conn.rollback(); // 回滚事务
                throw e;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return successCount;
    }
    
    /**
     * 根据时间范围查询课程
     * @param userId 用户ID
     * @param dayOfWeek 星期几
     * @param startTime 开始时间
     * @param endTime 结束时间
     * @return 课程列表
     */
    public List<Course> findByTimeRange(int userId, int dayOfWeek, LocalTime startTime, LocalTime endTime) {
        String sql = "SELECT * FROM courses WHERE user_id = ? AND day_of_week = ? " +
                    "AND ((start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?) " +
                    "OR (start_time <= ? AND end_time >= ?)) ORDER BY start_time";
        
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, dayOfWeek);
            pstmt.setTime(3, Time.valueOf(startTime));
            pstmt.setTime(4, Time.valueOf(endTime));
            pstmt.setTime(5, Time.valueOf(startTime));
            pstmt.setTime(6, Time.valueOf(endTime));
            pstmt.setTime(7, Time.valueOf(startTime));
            pstmt.setTime(8, Time.valueOf(endTime));
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
      /**
     * 将ResultSet映射为Course对象
     * @param rs ResultSet对象
     * @return Course对象
     * @throws SQLException SQL异常
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        
        course.setCourseId(rs.getInt("course_id"));
        course.setUserId(rs.getInt("user_id"));
        course.setCourseName(rs.getString("course_name"));
        course.setInstructor(rs.getString("instructor"));
        course.setClassroom(rs.getString("classroom"));
        course.setDayOfWeek(rs.getInt("day_of_week"));
        
        // 处理时间字段
        Time startTime = rs.getTime("start_time");
        Time endTime = rs.getTime("end_time");
        if (startTime != null) {
            course.setStartTime(startTime.toLocalTime());
        }
        if (endTime != null) {
            course.setEndTime(endTime.toLocalTime());
        }
        
        course.setWeekStart(rs.getInt("week_start"));
        course.setWeekEnd(rs.getInt("week_end"));
        course.setCourseType(rs.getString("course_type"));
        course.setCredits(rs.getInt("credits"));
        course.setDescription(rs.getString("description"));
        
        return course;
    }
}
