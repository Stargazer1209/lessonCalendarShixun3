-- MySQL 8.4.5兼容版本数据库初始化脚本
-- 解决mysql_native_password插件兼容性问题

-- 创建数据库
CREATE DATABASE IF NOT EXISTS schedule_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE schedule_db;

-- 设置SQL模式（MySQL 8.4.5兼容）
SET sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- 创建用户表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT 'SHA-256哈希密码',
    email VARCHAR(100) UNIQUE COMMENT '邮箱地址',
    role ENUM('student', 'teacher', 'admin') DEFAULT 'student' COMMENT '用户角色',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_active BOOLEAN DEFAULT TRUE COMMENT '账户状态',
    
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户信息表';

-- 创建课程表
CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL COMMENT '用户ID',
    course_name VARCHAR(100) NOT NULL COMMENT '课程名称',
    teacher VARCHAR(50) COMMENT '授课教师',
    classroom VARCHAR(50) COMMENT '教室',
    day_of_week TINYINT NOT NULL COMMENT '星期几(1-7)',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    start_date DATE COMMENT '开课日期',
    end_date DATE COMMENT '结课日期',
    description TEXT COMMENT '课程描述',
    color VARCHAR(7) DEFAULT '#3498db' COMMENT '课程颜色标识',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_day_time (day_of_week, start_time, end_time),
    INDEX idx_date_range (start_date, end_date),
    
    CONSTRAINT chk_time_order CHECK (start_time < end_time),
    CONSTRAINT chk_day_range CHECK (day_of_week BETWEEN 1 AND 7),
    CONSTRAINT chk_date_order CHECK (start_date <= end_date OR (start_date IS NULL OR end_date IS NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='课程信息表';

-- 创建用户会话表
CREATE TABLE user_sessions (
    id VARCHAR(128) PRIMARY KEY COMMENT '会话ID',
    user_id INT NOT NULL COMMENT '用户ID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL COMMENT '过期时间',
    ip_address VARCHAR(45) COMMENT '客户端IP',
    user_agent TEXT COMMENT '用户代理字符串',
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户会话表';

-- 插入初始化数据
-- 默认管理员账户（密码：admin123）
INSERT INTO users (username, password, email, role) VALUES 
('admin', SHA2('admin123', 256), 'admin@schedule.com', 'admin');

-- 测试学生账户（密码：password123）
INSERT INTO users (username, password, email, role) VALUES 
('student1', SHA2('password123', 256), 'student1@example.com', 'student'),
('teacher1', SHA2('password123', 256), 'teacher1@example.com', 'teacher');

-- 示例课程数据
INSERT INTO courses (user_id, course_name, teacher, classroom, day_of_week, start_time, end_time, color) VALUES
(2, '高等数学', '张教授', 'A101', 1, '08:00:00', '09:40:00', '#e74c3c'),
(2, '大学英语', '李老师', 'B203', 2, '10:00:00', '11:40:00', '#2ecc71'),
(2, '计算机程序设计', '王教授', 'C301', 3, '14:00:00', '15:40:00', '#3498db'),
(2, '数据结构', '刘教授', 'C302', 4, '14:00:00', '15:40:00', '#9b59b6'),
(2, '操作系统', '陈教授', 'C303', 5, '10:00:00', '11:40:00', '#f39c12');

-- 显示创建结果
SELECT '数据库初始化完成 - MySQL 8.4.5兼容版本' AS status;
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS course_count FROM courses;
SELECT VERSION() AS mysql_version;