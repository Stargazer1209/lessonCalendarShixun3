-- MySQL 8.4.5兼容版本数据库初始化脚本 - 修复版本
-- 解决mysql_native_password插件兼容性问题
-- 修复：添加salt字段以匹配Java代码中的盐值加密机制

-- === 测试账户密码信息 ===
-- 盐值 (Base64): tW6FDWK+Y4pr0UhInK/+dA==

-- 管理员账户 (admin):
--   原始密码: admin123
--   哈希密码: PxtwzGw30rJI7w6VcpWh4CwFK08FpqE1j70Oru20La0=

-- 用户账户 (student1/teacher1):
--   原始密码: password123
--   哈希密码: 8c+fsXc6aTN/OYlIJDJBPQQ/ZEEZkTAw39h/m/upwHI=

-- SQL插入语句：
-- -- 管理员
-- INSERT INTO users (username, password, salt, email, full_name, role) VALUES
-- ('admin', 'PxtwzGw30rJI7w6VcpWh4CwFK08FpqE1j70Oru20La0=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'admin@schedule.com', '系统管理员', 'admin');

-- -- 学生
-- INSERT INTO users (username, password, salt, email, full_name, role) VALUES
-- ('student1', '8c+fsXc6aTN/OYlIJDJBPQQ/ZEEZkTAw39h/m/upwHI=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'student1@example.com', '张同 学', 'student');

-- -- 教师
-- INSERT INTO users (username, password, salt, email, full_name, role) VALUES
-- ('teacher1', '8c+fsXc6aTN/OYlIJDJBPQQ/ZEEZkTAw39h/m/upwHI=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'teacher1@example.com', '李老 师', 'teacher');

DROP DATABASE IF EXISTS schedule_db;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS schedule_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE schedule_db;

-- 设置SQL模式（MySQL 8.4.5兼容）
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- 删除现有表（如果存在）
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;

-- 创建用户表（修复版本 - 添加salt字段和full_name字段）
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT 'SHA-256哈希密码',
    salt VARCHAR(255) NOT NULL COMMENT '密码盐值',
    email VARCHAR(100) UNIQUE COMMENT '邮箱地址',
    full_name VARCHAR(100) COMMENT '用户全名',
    role ENUM('student', 'teacher', 'admin') DEFAULT 'student' COMMENT '用户角色',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_active BOOLEAN DEFAULT TRUE COMMENT '账户状态',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- 创建课程表（匹配Java Course模型）
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT COMMENT '课程ID',
    user_id INT NOT NULL COMMENT '用户ID',
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    instructor VARCHAR(50) COMMENT '授课教师',
    classroom VARCHAR(50) COMMENT '教室',
    day_of_week TINYINT NOT NULL COMMENT '星期几(1-7)',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    week_start INT COMMENT '开始周数',
    week_end INT COMMENT '结束周数',
    semester VARCHAR(20) COMMENT '学期',
    academic_year VARCHAR(10) COMMENT '学年',
    credits DECIMAL(3,1) COMMENT '学分',
    course_type VARCHAR(20) COMMENT '课程类型',
    description TEXT COMMENT '课程描述',
    color VARCHAR(7) DEFAULT '#3498db' COMMENT '课程颜色标识',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_day_time (day_of_week, start_time, end_time),
    INDEX idx_week_range (week_start, week_end),
    
    CONSTRAINT chk_time_order CHECK (start_time < end_time),
    CONSTRAINT chk_day_range CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_week_order CHECK (week_start <= week_end OR (week_start IS NULL OR week_end IS NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程信息表';

-- 创建用户会话表
CREATE TABLE user_sessions (
    session_id VARCHAR(128) PRIMARY KEY COMMENT '会话ID',
    user_id INT NOT NULL COMMENT '用户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL COMMENT '过期时间',
    ip_address VARCHAR(45) COMMENT '客户端IP',
    user_agent TEXT COMMENT '用户代理字符串',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- 插入初始化数据（使用新的加密方式）
-- 注意：这里的密码和盐值是通过Java SecurityUtil生成的正确格式

-- 默认管理员账户（用户名：admin，密码：admin123）
INSERT INTO users (username, password, salt, email, full_name, role) VALUES 
('admin', 'PxtwzGw30rJI7w6VcpWh4CwFK08FpqE1j70Oru20La0=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'admin@schedule.com', '系统管理员', 'admin');

-- 测试学生账户（用户名：student1，密码：password123）
INSERT INTO users (username, password, salt, email, full_name, role) VALUES 
('student1', '8c+fsXc6aTN/OYlIJDJBPQQ/ZEEZkTAw39h/m/upwHI=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'student1@example.com', '张同学', 'student');

-- 测试教师账户（用户名：teacher1，密码：password123）  
INSERT INTO users (username, password, salt, email, full_name, role) VALUES 
('teacher1', '8c+fsXc6aTN/OYlIJDJBPQQ/ZEEZkTAw39h/m/upwHI=', 'tW6FDWK+Y4pr0UhInK/+dA==', 'teacher1@example.com', '李老师', 'teacher');

-- 示例课程数据（使用student1的user_id=2）
INSERT INTO courses (user_id, course_name, instructor, classroom, day_of_week, start_time, end_time, week_start, week_end, semester, academic_year, credits, course_type, color) VALUES
(2, '高等数学', '张教授', 'A101', 1, '08:00:00', '09:40:00', 1, 16, '秋季学期', '2024-2025', 4.0, '必修课', '#e74c3c'),
(2, '大学英语', '李老师', 'B203', 2, '10:00:00', '11:40:00', 1, 16, '秋季学期', '2024-2025', 3.0, '必修课', '#2ecc71'),
(2, '计算机程序设计', '王教授', 'C301', 3, '14:00:00', '15:40:00', 1, 16, '秋季学期', '2024-2025', 3.5, '专业课', '#3498db'),
(2, '数据结构', '刘教授', 'C302', 4, '14:00:00', '15:40:00', 1, 16, '秋季学期', '2024-2025', 3.5, '专业课', '#9b59b6'),
(2, '操作系统', '陈教授', 'C303', 5, '10:00:00', '11:40:00', 1, 16, '秋季学期', '2024-2025', 3.0, '专业课', '#f39c12');

-- 显示创建结果
SELECT '数据库初始化完成 - MySQL 8.4.5兼容版本（修复版）' AS status;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS course_count FROM courses;
SELECT VERSION() AS mysql_version;

-- 显示用户信息（不显示密码和盐值）
SELECT user_id, username, email, full_name, role, created_at FROM users;
