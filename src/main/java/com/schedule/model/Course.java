package com.schedule.model;

import java.time.LocalTime;

/**
 * 课程实体类
 */
public class Course {
    private int courseId;
    private int userId;
    private String courseName;
    private String courseCode;
    private String instructor;
    private String classroom;
    private int dayOfWeek; // 1-7 表示周一到周日
    private LocalTime startTime;
    private LocalTime endTime;
    private int weekStart; // 开始周次
    private int weekEnd;   // 结束周次
    private String courseType; // 课程类型：必修、选修等
    private int credits;   // 学分
    private String description; // 课程描述
    
    // 默认构造方法
    public Course() {}
    
    // 带参构造方法
    public Course(int userId, String courseName, String courseCode, String instructor, 
                  String classroom, int dayOfWeek, LocalTime startTime, LocalTime endTime) {
        this.userId = userId;
        this.courseName = courseName;
        this.courseCode = courseCode;
        this.instructor = instructor;
        this.classroom = classroom;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }
    
    // Getters and Setters
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getCourseCode() {
        return courseCode;
    }
    
    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
    
    public String getInstructor() {
        return instructor;
    }
    
    public void setInstructor(String instructor) {
        this.instructor = instructor;
    }
    
    public String getClassroom() {
        return classroom;
    }
    
    public void setClassroom(String classroom) {
        this.classroom = classroom;
    }
    
    public int getDayOfWeek() {
        return dayOfWeek;
    }
    
    public void setDayOfWeek(int dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }
    
    public LocalTime getStartTime() {
        return startTime;
    }
    
    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }
    
    public LocalTime getEndTime() {
        return endTime;
    }
    
    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }
    
    public int getWeekStart() {
        return weekStart;
    }
    
    public void setWeekStart(int weekStart) {
        this.weekStart = weekStart;
    }
    
    public int getWeekEnd() {
        return weekEnd;
    }
    
    public void setWeekEnd(int weekEnd) {
        this.weekEnd = weekEnd;
    }
    
    public String getCourseType() {
        return courseType;
    }
    
    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }
    
    public int getCredits() {
        return credits;
    }
    
    public void setCredits(int credits) {
        this.credits = credits;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    /**
     * 检查时间是否冲突
     */
    public boolean isTimeConflict(Course other) {
        if (this.dayOfWeek != other.dayOfWeek) {
            return false;
        }
        
        // 检查时间段是否重叠
        return !(this.endTime.isBefore(other.startTime) || 
                 this.startTime.isAfter(other.endTime));
    }
    
    /**
     * 获取星期显示名称
     */
    public String getDayOfWeekName() {
        String[] days = {"", "周一", "周二", "周三", "周四", "周五", "周六", "周日"};
        return days[dayOfWeek];
    }
    
    @Override
    public String toString() {
        return "Course{" +
                "courseId=" + courseId +
                ", courseName='" + courseName + '\'' +
                ", courseCode='" + courseCode + '\'' +
                ", instructor='" + instructor + '\'' +
                ", classroom='" + classroom + '\'' +
                ", dayOfWeek=" + dayOfWeek +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                '}';
    }
}