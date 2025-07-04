课灵通-支持二维码离线交互的可视化排课引擎
=====================================

# 系统设计文档（更新版）

## 1. 项目概述

### 1.1 项目目标
开发一个基于Java Web的课程表管理系统，支持用户注册登录、课程信息管理、个人课程表查看等功能，使用现代化的开发工具链和安全的技术实现。

### 1.2 技术栈
- **后端**: Java 11 (OpenJDK 11.0.26) + Servlet + JSP
- **数据库**: MySQL 8.4.5
- **服务器**: Apache Tomcat 9
- **前端**: HTML5 + CSS3 + JavaScript (ES6)
- **开发工具**: VS Code + Java扩展包
- **版本控制**: Git

### 1.3 系统特性
- 响应式Web界面，支持桌面和移动设备
- 安全的用户认证和会话管理
- 智能的课程时间冲突检测
- 直观的课程表可视化展示
- 完善的输入验证和XSS防护

## 2. 系统架构设计

### 2.1 总体架构
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   浏览器客户端   │◄──►│   Tomcat服务器   │◄──►│   MySQL数据库   │
│   (HTML/CSS/JS) │    │  (Servlet/JSP)  │    │   (数据存储)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### 2.2 分层架构
```
┌───────────────────────────────────────────────────────────┐
│                    表现层 (Presentation Layer)              │
│              JSP页面 + HTML + CSS + JavaScript             │
├───────────────────────────────────────────────────────────┤
│                     控制层 (Control Layer)                 │
│                    Servlet + Filter                       │
├───────────────────────────────────────────────────────────┤
│                     业务层 (Business Layer)                │
│                    Service + Model                        │
├───────────────────────────────────────────────────────────┤
│                    数据访问层 (Data Access Layer)           │
│                         DAO                               │
├───────────────────────────────────────────────────────────┤
│                     数据层 (Data Layer)                    │
│                       MySQL 8                        │
└───────────────────────────────────────────────────────────┘
```

### 2.3 包结构设计
```
com.schedule/
├── servlet/           # 控制层Servlet类
│   ├── LoginServlet.java
│   ├── RegisterServlet.java
│   ├── AddCourseServlet.java
│   ├── UpdateCourseServlet.java
│   ├── DeleteCourseServlet.java
│   └── ViewScheduleServlet.java
├── model/             # 数据模型类
│   ├── User.java
│   └── Course.java
├── dao/               # 数据访问对象
│   ├── UserDAO.java
│   └── CourseDAO.java
├── util/              # 工具类
│   ├── DatabaseUtil.java
│   ├── SecurityUtil.java
│   └── ValidationUtil.java
└── filter/            # 过滤器
    ├── AuthenticationFilter.java
    └── EncodingFilter.java
```

## 3. 数据库设计

### 3.1 数据库配置（MySQL 8）


### 3.2 表结构设计

#### 3.2.1 用户表 (users)


#### 3.2.2 课程表 (courses)


#### 3.2.3 用户会话表 (user_sessions)


### 3.3 初始化数据


## 4. 核心功能设计

### 4.1 用户认证系统

#### 4.1.1 密码安全策略


#### 4.1.2 会话管理策略


### 4.2 课程管理功能

#### 4.2.1 时间冲突检测算法


#### 4.2.2 课程表视图生成


## 5. 安全性设计

### 5.1 输入验证和XSS防护


### 5.2 SQL注入防护


## 6. 用户界面设计

### 6.1 响应式布局
```css
/* 移动优先的响应式设计 */


/* 课程表网格布局 */


/* 移动端适配 */


/* 平板适配 */

```

### 6.2 课程卡片设计


## 7. 数据库连接池配置

### 7.1 HikariCP连接池


## 8. 性能优化策略

### 8.1 数据库优化
- 合理使用索引加速查询
- 实现数据库连接池减少连接开销
- 使用批处理操作提高插入性能
- 定期清理过期会话数据

### 8.2 前端优化
- CSS和JavaScript文件压缩
- 图片懒加载和压缩
- 使用浏览器缓存
- 减少HTTP请求数量

### 8.3 服务器优化
- Tomcat JVM参数调优
- 启用Gzip压缩
- 配置适当的会话超时时间
- 实现日志轮转避免磁盘空间问题

## 9. 部署和监控

### 9.1 生产环境配置
```xml
<!-- Tomcat server.xml 优化配置 -->
```

### 9.2 日志配置
```java
// 使用java.util.logging
```

## 10. 扩展功能设计

### 10.1 移动端支持
- PWA（Progressive Web App）实现
- 响应式设计优化
- 触摸友好的交互设计
- 离线缓存支持

### 10.2 高级功能
- 课程提醒和通知
- 批量导入课程（Excel/CSV）
- 课程表分享功能
- 多学期管理
- 统计报表生成

### 10.3 API接口
```java
// RESTful API设计示例
```