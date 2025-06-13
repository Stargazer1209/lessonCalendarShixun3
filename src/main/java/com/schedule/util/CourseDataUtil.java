package com.schedule.util;

import com.schedule.model.Course;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * 课程数据序列化工具
 */
public class CourseDataUtil {
    
    private static final ObjectMapper objectMapper = new ObjectMapper();
    
    /**
     * 将课程对象转换为JSON字符串
     */
    public static String courseToJson(Course course) throws Exception {
        Map<String, Object> courseData = new HashMap<>();
        courseData.put("courseName", course.getCourseName());
        courseData.put("instructor", course.getInstructor());
        courseData.put("classroom", course.getClassroom());
        courseData.put("dayOfWeek", course.getDayOfWeek());
        courseData.put("startTime", course.getStartTime().toString());
        courseData.put("endTime", course.getEndTime().toString());
        courseData.put("weekStart", course.getWeekStart());
        courseData.put("weekEnd", course.getWeekEnd());
        courseData.put("courseType", course.getCourseType());
        courseData.put("credits", course.getCredits());
        courseData.put("description", course.getDescription());
        
        return objectMapper.writeValueAsString(courseData);
    }
    
    /**
     * 将课程列表转换为JSON字符串
     */
    public static String coursesToJson(List<Course> courses) throws Exception {
        List<Map<String, Object>> courseDataList = new java.util.ArrayList<>();
        
        for (Course course : courses) {
            Map<String, Object> courseData = new HashMap<>();
            courseData.put("courseName", course.getCourseName());
            courseData.put("instructor", course.getInstructor());
            courseData.put("classroom", course.getClassroom());
            courseData.put("dayOfWeek", course.getDayOfWeek());
            courseData.put("startTime", course.getStartTime().toString());
            courseData.put("endTime", course.getEndTime().toString());
            courseData.put("weekStart", course.getWeekStart());
            courseData.put("weekEnd", course.getWeekEnd());
            courseData.put("courseType", course.getCourseType());
            courseData.put("credits", course.getCredits());
            courseData.put("description", course.getDescription());
            courseDataList.add(courseData);
        }
        
        return objectMapper.writeValueAsString(courseDataList);
    }
    
    /**
     * 从JSON字符串解析课程数据
     */
    public static Map<String, Object> jsonToCourseData(String json) throws Exception {
        return objectMapper.readValue(json, new TypeReference<Map<String, Object>>() {});
    }
    
    /**
     * 从JSON字符串解析课程列表数据
     */
    public static List<Map<String, Object>> jsonToCoursesData(String json) throws Exception {
        return objectMapper.readValue(json, new TypeReference<List<Map<String, Object>>>() {});
    }
}