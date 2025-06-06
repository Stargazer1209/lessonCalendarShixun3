课灵通 - 编程开发实施计划

项目名称: 课灵通
副标题: 支持文本导入导出离线交互的可视化排课引擎
技术栈: JSP, Servlet, Filter, JDBC, MySQL
===========================
# 课程表管理系统实施计划（更新版）

## 1. 技术环境配置

### 1.1 开发环境要求
- **Java**: OpenJDK 11
- **MySQL**: 8
- **Tomcat**: 9
- **IDE**: VS Code
- **操作系统**: Windows

### 1.2 VS Code扩展安装
必需扩展：
- Extension Pack for Java
- Tomcat for Java

### 1.3 JAR包依赖（JDK 11兼容版本）
```
mysql-connector-j-8.4.0.jar
javax.servlet-api-4.0.1.jar
jstl-1.2.jar
```
放置位置：`WEB-INF/lib/`

## 1.4 项目结构配置
```
lessonCalendarShixun3/
├── .vscode/
│   ├── settings.json
│   ├── launch.json
│   └── tasks.json
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── schedule/
│       │           ├── servlet/
│       │           ├── model/
│       │           ├── dao/
│       │           └── util/
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   └── lib/
│           ├── css/
│           ├── js/
│           └── *.jsp
├── database/
│   └── init.sql
└── docs/
    ├── setup-guide.md
    └── troubleshooting.md
    scripts/
        init-database.bat
        init-backend.ps1
        deploy-all.bat
        ......

```
## 2. 开发阶段实施

### 阶段1: 环境搭建（第1天）
**目标**: 完成开发环境配置和项目初始化

**具体步骤**:
1. **安装软件**
   - 验证OpenJDK 11.0.26安装：`java -version`
   - 安装MySQL 8.4.5并配置root密码
   - 下载Tomcat 9.0.95并解压到指定目录

2. **VS Code配置**
   - 安装必需扩展
   - 创建项目文件夹结构
   - 配置.vscode文件夹下的配置文件

3. **数据库初始化**
   - 执行database/init.sql脚本
   - 测试数据库连接
   - 插入测试数据

4. **验证环境**
   - 启动Tomcat服务器
   - 部署Hello World测试页面
   - 确认Java编译和热部署工作正常

**交付物**: 
- 完整的项目结构
- 可运行的Hello World页面
- 数据库连接测试成功

### 阶段2: 核心功能开发（第2-3天）
**目标**: 实现用户管理和课程管理核心功能

1. **创建基础类**
   ```java
   com.schedule.model.User
   com.schedule.dao.UserDAO
   com.schedule.util.DatabaseUtil
   com.schedule.util.SecurityUtil
   ```

2. **实现用户认证**
   ```java
   com.schedule.servlet.LoginServlet
   com.schedule.servlet.RegisterServlet
   com.schedule.servlet.LogoutServlet
   ```

3. **创建JSP页面**
   - login.jsp
   - register.jsp
   - index.jsp（首页）

4. **创建课程类**
   ```java
   com.schedule.model.Course
   com.schedule.dao.CourseDAO
   ```

5. **实现课程操作**
   ```java
   com.schedule.servlet.AddCourseServlet
   com.schedule.servlet.UpdateCourseServlet
   com.schedule.servlet.DeleteCourseServlet
   com.schedule.servlet.ViewScheduleServlet
   ```

6. **创建课程管理页面**
   - add-course.jsp
   - edit-course.jsp
   - view-schedule.jsp

**验收标准**:
- 用户可以注册、登录、退出
- 用户可以添加、修改、删除课程
- 课程时间冲突检测正常工作
- 所有表单验证正常

### 阶段3: 前端优化和安全加固（第4天）
**目标**: 完善用户界面和安全性


1. **CSS样式设计**
   - 创建responsive.css
   - 实现移动端适配
   - 添加表单验证提示样式

2. **JavaScript交互**
   - 表单验证脚本
   - 时间冲突检查
   - 用户体验优化

3. **输入验证增强**
   - XSS防护实现
   - SQL注入防护验证
   - CSRF防护添加

4. **会话管理优化**
   - 会话超时设置
   - 安全登录状态检查
   - 敏感操作二次确认

**验收标准**:
- 界面美观且响应式
- 表单验证完整
- 安全测试通过

### 阶段4: 测试和部署（第5天）
**目标**: 全面测试和生产环境准备

1. **单元测试**
   - 数据库操作测试
   - 用户认证流程测试
   - 课程管理操作测试

2. **集成测试**
   - 完整用户流程测试
   - 边界条件测试
   - 错误处理测试

3. **生产环境配置**
   - 数据库优化配置
   - Tomcat性能调优
   - 日志配置

4. **部署验证**
   - 生产环境部署测试
   - 性能测试
   - 安全扫描

**最终交付物**:
- 完整功能的课程表管理系统
- 用户操作手册
- 部署和维护文档


## 6. 故障排除指南

### 6.1 常见开发问题
1. **JAR包冲突**: 检查WEB-INF/lib目录中的重复JAR包
2. **编码问题**: 确保所有文件使用UTF-8编码
3. **热部署失败**: 重启Tomcat服务器
4. **数据库连接失败**: 检查MySQL服务状态和防火墙设置

### 6.2 VS Code特定问题
1. **Java项目识别失败**: 刷新Java项目（Ctrl+Shift+P -> Java: Reload Projects）
2. **类路径问题**: 检查.vscode/settings.json中的配置
3. **调试连接失败**: 确认Tomcat启动时包含调试参数

## 7. 验收标准

### 7.1 功能验收
- [ ] 用户注册登录功能正常
- [ ] 课程增删改查功能完整
- [ ] 时间冲突检测准确
- [ ] 课程表显示正确
- [ ] 用户会话管理安全

### 7.2 技术验收
- [ ] 代码符合Java编码规范
- [ ] 数据库设计合理且优化
- [ ] 安全防护措施有效
- [ ] 界面响应式且美观
- [ ] 系统性能满足要求

### 7.3 部署验收
- [ ] 生产环境部署成功
- [ ] 系统稳定运行24小时
- [ ] 备份恢复流程验证
- [ ] 监控和日志配置完整

## 8. 后续维护

### 8.1 日常维护
- 定期数据库备份
- 日志文件清理
- 系统性能监控
- 安全更新检查

### 8.2 功能扩展
- 课程提醒功能
- 批量导入课程
- 移动端APP
- 多用户权限管理