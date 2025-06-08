package com.schedule.util;

/**
 * 密码生成工具 - 用于生成测试账户的密码哈希值
 */
public class PasswordGenerator {
    public static void main(String[] args) {
        // 生成测试用的盐值和密码哈希
        String testSalt = SecurityUtil.generateSalt();
        
        // 测试密码
        String adminPassword = "admin123";
        String userPassword = "password123";
        
        // 生成哈希
        String adminHash = SecurityUtil.hashPassword(adminPassword, testSalt);
        String userHash = SecurityUtil.hashPassword(userPassword, testSalt);
        
        System.out.println("=== 测试账户密码信息 ===");
        System.out.println("盐值 (Base64): " + testSalt);
        System.out.println();
        System.out.println("管理员账户 (admin):");
        System.out.println("  原始密码: " + adminPassword);
        System.out.println("  哈希密码: " + adminHash);
        System.out.println();
        System.out.println("用户账户 (student1/teacher1):");
        System.out.println("  原始密码: " + userPassword);
        System.out.println("  哈希密码: " + userHash);
        System.out.println();
        System.out.println("SQL插入语句：");
        System.out.println("-- 管理员");
        System.out.println("INSERT INTO users (username, password, salt, email, full_name, role) VALUES");
        System.out.println("('admin', '" + adminHash + "', '" + testSalt + "', 'admin@schedule.com', '系统管理员', 'admin');");
        System.out.println();
        System.out.println("-- 学生");
        System.out.println("INSERT INTO users (username, password, salt, email, full_name, role) VALUES");
        System.out.println("('student1', '" + userHash + "', '" + testSalt + "', 'student1@example.com', '张同学', 'student');");
        System.out.println();
        System.out.println("-- 教师");
        System.out.println("INSERT INTO users (username, password, salt, email, full_name, role) VALUES");
        System.out.println("('teacher1', '" + userHash + "', '" + testSalt + "', 'teacher1@example.com', '李老师', 'teacher');");
    }
}
