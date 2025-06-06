package com.schedule.util;

import java.security.MessageDigest;
import java.util.logging.Logger;
import java.util.logging.Level;

/**
 * 安全工具类
 * 提供密码加密、XSS防护、输入验证等安全功能
 */
public class SecurityUtil {
    private static final Logger logger = Logger.getLogger(SecurityUtil.class.getName());
    
    /**
     * 使用SHA-256算法加密密码
     * @param password 原始密码
     * @return String 加密后的密码哈希值
     */
    public static String hashPassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("密码不能为空");
        }
        
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes("UTF-8"));
            
            // 将字节数组转换为十六进制字符串
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            
            return sb.toString();
        } catch (Exception e) {
            logger.log(Level.SEVERE, "密码加密失败", e);
            throw new RuntimeException("密码加密失败", e);
        }
    }
    
    /**
     * 验证密码是否匹配
     * @param inputPassword 用户输入的密码
     * @param storedHash 存储的密码哈希值
     * @return boolean 密码是否匹配
     */
    public static boolean verifyPassword(String inputPassword, String storedHash) {
        if (inputPassword == null || storedHash == null) {
            return false;
        }
        
        try {
            String inputHash = hashPassword(inputPassword);
            return inputHash.equals(storedHash);
        } catch (Exception e) {
            logger.log(Level.WARNING, "密码验证失败", e);
            return false;
        }
    }
    
    /**
     * XSS防护 - 转义HTML特殊字符
     * @param input 用户输入的字符串
     * @return String 转义后的安全字符串
     */
    public static String escapeHtml(String input) {
        if (input == null) {
            return null;
        }
        
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;")
                   .replace("/", "&#x2F;");
    }
    
    /**
     * 验证用户名格式
     * @param username 用户名
     * @return boolean 格式是否正确
     */
    public static boolean isValidUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        
        // 用户名长度3-20位，只允许字母、数字、下划线
        String pattern = "^[a-zA-Z0-9_]{3,20}$";
        return username.matches(pattern);
    }
    
    /**
     * 验证密码强度
     * @param password 密码
     * @return boolean 密码是否符合要求
     */
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        // 密码至少6位，包含字母和数字
        boolean hasLetter = false;
        boolean hasDigit = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) {
                hasLetter = true;
            } else if (Character.isDigit(c)) {
                hasDigit = true;
            }
        }
        
        return hasLetter && hasDigit;
    }
    
    /**
     * 验证邮箱格式
     * @param email 邮箱地址
     * @return boolean 格式是否正确
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String pattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(pattern);
    }
    
    /**
     * 清理SQL注入风险字符
     * @param input 用户输入
     * @return String 清理后的字符串
     */
    public static String sanitizeSqlInput(String input) {
        if (input == null) {
            return null;
        }
        
        // 移除常见的SQL注入攻击字符
        return input.replaceAll("[';\"\\-\\-]", "");
    }
    
    /**
     * 验证课程名称格式
     * @param courseName 课程名称
     * @return boolean 格式是否正确
     */
    public static boolean isValidCourseName(String courseName) {
        if (courseName == null || courseName.trim().isEmpty()) {
            return false;
        }
        
        // 课程名称长度1-100字符，不包含特殊字符
        return courseName.length() <= 100 && 
               !courseName.matches(".*[<>\"'&].*");
    }
    
    /**
     * 验证教师名称格式
     * @param teacherName 教师名称
     * @return boolean 格式是否正确
     */
    public static boolean isValidTeacherName(String teacherName) {
        if (teacherName == null) {
            return true; // 教师名称可以为空
        }
        
        // 教师名称长度1-50字符
        return teacherName.length() <= 50 && 
               !teacherName.matches(".*[<>\"'&].*");
    }
    
    /**
     * 验证教室名称格式
     * @param classroom 教室名称
     * @return boolean 格式是否正确
     */
    public static boolean isValidClassroom(String classroom) {
        if (classroom == null) {
            return true; // 教室名称可以为空
        }
        
        // 教室名称长度1-50字符
        return classroom.length() <= 50 && 
               !classroom.matches(".*[<>\"'&].*");
    }
    
    /**
     * 生成安全的会话ID
     * @return String 会话ID
     */
    public static String generateSessionId() {
        try {
            String timestamp = String.valueOf(System.currentTimeMillis());
            String random = String.valueOf(Math.random());
            return hashPassword(timestamp + random);
        } catch (Exception e) {
            logger.log(Level.WARNING, "生成会话ID失败", e);
            return String.valueOf(System.currentTimeMillis());
        }
    }
}
