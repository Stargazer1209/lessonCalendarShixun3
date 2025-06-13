package com.schedule.util;

import com.schedule.model.Course;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

/**
 * 课程数据序列化工具
 */
public class CourseDataUtil {
    
    /**
     * 将课程对象转换为JSON字符串
     */
    public static String courseToJson(Course course) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"courseName\":\"").append(escapeJson(course.getCourseName())).append("\",");
        json.append("\"instructor\":\"").append(escapeJson(course.getInstructor())).append("\",");
        json.append("\"classroom\":\"").append(escapeJson(course.getClassroom())).append("\",");
        json.append("\"dayOfWeek\":").append(course.getDayOfWeek()).append(",");
        json.append("\"startTime\":\"").append(course.getStartTime().toString()).append("\",");
        json.append("\"endTime\":\"").append(course.getEndTime().toString()).append("\",");
        json.append("\"weekStart\":").append(course.getWeekStart()).append(",");
        json.append("\"weekEnd\":").append(course.getWeekEnd()).append(",");
        json.append("\"courseType\":\"").append(escapeJson(course.getCourseType())).append("\",");
        json.append("\"credits\":").append(course.getCredits()).append(",");
        json.append("\"description\":\"").append(escapeJson(course.getDescription())).append("\"");
        json.append("}");
        return json.toString();
    }
    
    /**
     * 将课程列表转换为JSON字符串
     */
    public static String coursesToJson(List<Course> courses) {
        StringBuilder json = new StringBuilder();
        json.append("[");
        
        for (int i = 0; i < courses.size(); i++) {
            if (i > 0) {
                json.append(",");
            }
            json.append(courseToJson(courses.get(i)));
        }
        
        json.append("]");
        return json.toString();
    }
    
    /**
     * 从JSON字符串解析课程数据
     */
    public static Map<String, Object> jsonToCourseData(String json) throws Exception {
        return parseJsonObject(json.trim());
    }
    
    /**
     * 从JSON字符串解析课程列表数据
     */
    public static List<Map<String, Object>> jsonToCoursesData(String json) throws Exception {
        return parseJsonArray(json.trim());
    }
    
    /**
     * 转义JSON字符串中的特殊字符
     */
    private static String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t");
    }
    
    /**
     * 解析JSON对象
     */
    private static Map<String, Object> parseJsonObject(String json) throws Exception {
        Map<String, Object> result = new HashMap<>();
        
        if (!json.startsWith("{") || !json.endsWith("}")) {
            throw new Exception("无效的JSON对象格式");
        }
        
        String content = json.substring(1, json.length() - 1).trim();
        if (content.isEmpty()) {
            return result;
        }
        
        String[] pairs = splitJsonPairs(content);
        
        for (String pair : pairs) {
            String[] keyValue = splitKeyValue(pair.trim());
            if (keyValue.length == 2) {
                String key = unescapeJsonString(keyValue[0].trim());
                Object value = parseJsonValue(keyValue[1].trim());
                result.put(key, value);
            }
        }
        
        return result;
    }
    
    /**
     * 解析JSON数组
     */
    private static List<Map<String, Object>> parseJsonArray(String json) throws Exception {
        List<Map<String, Object>> result = new ArrayList<>();
        
        if (!json.startsWith("[") || !json.endsWith("]")) {
            throw new Exception("无效的JSON数组格式");
        }
        
        String content = json.substring(1, json.length() - 1).trim();
        if (content.isEmpty()) {
            return result;
        }
        
        String[] objects = splitJsonObjects(content);
        
        for (String obj : objects) {
            result.add(parseJsonObject(obj.trim()));
        }
        
        return result;
    }
    
    /**
     * 分割JSON键值对
     */
    private static String[] splitJsonPairs(String content) {
        List<String> pairs = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inString = false;
        boolean escaped = false;
        int braceCount = 0;
        
        for (int i = 0; i < content.length(); i++) {
            char c = content.charAt(i);
            
            if (escaped) {
                escaped = false;
                current.append(c);
                continue;
            }
            
            if (c == '\\') {
                escaped = true;
                current.append(c);
                continue;
            }
            
            if (c == '"') {
                inString = !inString;
                current.append(c);
                continue;
            }
            
            if (!inString) {
                if (c == '{') {
                    braceCount++;
                } else if (c == '}') {
                    braceCount--;
                } else if (c == ',' && braceCount == 0) {
                    pairs.add(current.toString());
                    current = new StringBuilder();
                    continue;
                }
            }
            
            current.append(c);
        }
        
        if (current.length() > 0) {
            pairs.add(current.toString());
        }
        
        return pairs.toArray(new String[0]);
    }
    
    /**
     * 分割JSON对象数组
     */
    private static String[] splitJsonObjects(String content) {
        List<String> objects = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inString = false;
        boolean escaped = false;
        int braceCount = 0;
        
        for (int i = 0; i < content.length(); i++) {
            char c = content.charAt(i);
            
            if (escaped) {
                escaped = false;
                current.append(c);
                continue;
            }
            
            if (c == '\\') {
                escaped = true;
                current.append(c);
                continue;
            }
            
            if (c == '"') {
                inString = !inString;
                current.append(c);
                continue;
            }
            
            if (!inString) {
                if (c == '{') {
                    braceCount++;
                } else if (c == '}') {
                    braceCount--;
                } else if (c == ',' && braceCount == 0) {
                    objects.add(current.toString());
                    current = new StringBuilder();
                    continue;
                }
            }
            
            current.append(c);
        }
        
        if (current.length() > 0) {
            objects.add(current.toString());
        }
        
        return objects.toArray(new String[0]);
    }
    
    /**
     * 分割键值对
     */
    private static String[] splitKeyValue(String pair) {
        List<String> result = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inString = false;
        boolean escaped = false;
        boolean foundColon = false;
        
        for (int i = 0; i < pair.length(); i++) {
            char c = pair.charAt(i);
            
            if (escaped) {
                escaped = false;
                current.append(c);
                continue;
            }
            
            if (c == '\\') {
                escaped = true;
                current.append(c);
                continue;
            }
            
            if (c == '"') {
                inString = !inString;
                current.append(c);
                continue;
            }
            
            if (!inString && c == ':' && !foundColon) {
                result.add(current.toString());
                current = new StringBuilder();
                foundColon = true;
                continue;
            }
            
            current.append(c);
        }
        
        if (current.length() > 0) {
            result.add(current.toString());
        }
        
        return result.toArray(new String[0]);
    }
    
    /**
     * 解析JSON值
     */
    private static Object parseJsonValue(String value) throws Exception {
        value = value.trim();
        
        if (value.equals("null")) {
            return null;
        }
        
        if (value.equals("true")) {
            return true;
        }
        
        if (value.equals("false")) {
            return false;
        }
        
        if (value.startsWith("\"") && value.endsWith("\"")) {
            return unescapeJsonString(value);
        }
        
        // 尝试解析为数字
        try {
            if (value.contains(".")) {
                return Double.parseDouble(value);
            } else {
                return Integer.parseInt(value);
            }
        } catch (NumberFormatException e) {
            throw new Exception("无法解析JSON值: " + value);
        }
    }
    
    /**
     * 反转义JSON字符串
     */
    private static String unescapeJsonString(String str) {
        if (str.startsWith("\"") && str.endsWith("\"")) {
            str = str.substring(1, str.length() - 1);
        }
        
        return str.replace("\\\"", "\"")
                 .replace("\\\\", "\\")
                 .replace("\\n", "\n")
                 .replace("\\r", "\r")
                 .replace("\\t", "\t");
    }
    
    /**
     * 将Map数据转换为Course对象
     */
    public static Course mapToCourse(Map<String, Object> courseData, int userId) {
        Course course = new Course();
        course.setUserId(userId);
        course.setCourseName((String) courseData.get("courseName"));
        course.setInstructor((String) courseData.get("instructor"));
        course.setClassroom((String) courseData.get("classroom"));
        course.setDayOfWeek((Integer) courseData.get("dayOfWeek"));
        course.setStartTime(LocalTime.parse((String) courseData.get("startTime")));
        course.setEndTime(LocalTime.parse((String) courseData.get("endTime")));
        course.setWeekStart((Integer) courseData.get("weekStart"));
        course.setWeekEnd((Integer) courseData.get("weekEnd"));
        course.setCourseType((String) courseData.get("courseType"));
        course.setCredits((Integer) courseData.get("credits"));
        course.setDescription((String) courseData.get("description"));
        return course;
    }
}