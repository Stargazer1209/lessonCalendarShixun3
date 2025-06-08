# 阶段二：核心功能开发 - 进度清单

## 📋 总体进度概览
- **阶段**: 阶段2 - 核心功能开发（第2-3天）
- **开始时间**: 2024年当前
- **预计完成**: 第3天结束
- **当前状态**: 🟡 进行中 (50% 完成)

---

## ✅ 已完成任务

### 1. 创建基础类 ✅ (100% 完成)
- [x] **com.schedule.model.User** - 用户实体类
  - ✅ 用户基本属性 (userId, username, password, email, fullName)
  - ✅ 时间戳字段 (createdAt, updatedAt)
  - ✅ 构造方法和Getter/Setter
  - ✅ toString()方法

- [x] **com.schedule.model.Course** - 课程实体类
  - ✅ 课程完整属性 (courseId, courseName, instructor, classroom等)
  - ✅ 时间相关字段 (dayOfWeek, startTime, endTime, weekStart, weekEnd)
  - ✅ 时间冲突检测方法 isTimeConflict()
  - ✅ 星期显示名称转换 getDayOfWeekName()

- [x] **com.schedule.util.DatabaseUtil** - 数据库工具类
  - ✅ 数据库连接获取和关闭
  - ✅ 连接测试方法
  - ✅ 数据库版本获取 getDatabaseVersion()
  - ✅ 用户数量统计 getUserCount()
  - ✅ MySQL 8 兼容配置

- [x] **com.schedule.util.SecurityUtil** - 安全工具类
  - ✅ 密码哈希和验证 (SHA-256 + 盐值)
  - ✅ XSS防护 (HTML标签清理)
  - ✅ 输入验证 (用户名、密码、邮箱格式)
  - ✅ 会话令牌生成

- [x] **com.schedule.dao.UserDAO** - 用户数据访问对象
  - ✅ 用户注册 addUser()
  - ✅ 用户查找 findByUsername(), findById()
  - ✅ 用户认证 authenticate()
  - ✅ 唯一性检查 isUsernameExists(), isEmailExists()
  - ✅ 用户更新和删除功能

---

## ✅ 已完成任务

### 1. 创建基础类 ✅ (100% 完成)
- [x] **com.schedule.model.User** - 用户实体类
  - ✅ 用户基本属性 (userId, username, password, email, fullName)
  - ✅ 时间戳字段 (createdAt, updatedAt)
  - ✅ 构造方法和Getter/Setter
  - ✅ toString()方法

- [x] **com.schedule.model.Course** - 课程实体类
  - ✅ 课程完整属性 (courseId, courseName, instructor, classroom等)
  - ✅ 时间相关字段 (dayOfWeek, startTime, endTime, weekStart, weekEnd)
  - ✅ 时间冲突检测方法 isTimeConflict()
  - ✅ 星期显示名称转换 getDayOfWeekName()

- [x] **com.schedule.util.DatabaseUtil** - 数据库工具类
  - ✅ 数据库连接获取和关闭
  - ✅ 连接测试方法
  - ✅ 数据库版本获取 getDatabaseVersion()
  - ✅ 用户数量统计 getUserCount()
  - ✅ MySQL 8 兼容配置

- [x] **com.schedule.util.SecurityUtil** - 安全工具类
  - ✅ 密码哈希和验证 (SHA-256 + 盐值)
  - ✅ XSS防护 (HTML标签清理)
  - ✅ 输入验证 (用户名、密码、邮箱格式)
  - ✅ 会话令牌生成

- [x] **com.schedule.dao.UserDAO** - 用户数据访问对象
  - ✅ 用户注册 addUser()
  - ✅ 用户查找 findByUsername(), findById()
  - ✅ 用户认证 authenticate()
  - ✅ 唯一性检查 isUsernameExists(), isEmailExists()
  - ✅ 用户更新和删除功能

### 2. 实现用户认证 ✅ (100% 完成)
- [x] **com.schedule.servlet.LoginServlet**
  - ✅ 处理用户登录请求
  - ✅ 验证用户凭据
  - ✅ 会话管理
  - ✅ 登录失败处理

- [x] **com.schedule.servlet.RegisterServlet**
  - ✅ 处理用户注册请求
  - ✅ 输入验证和清理
  - ✅ 用户名/邮箱唯一性检查
  - ✅ 注册成功/失败响应

- [x] **com.schedule.servlet.LogoutServlet**
  - ✅ 会话销毁
  - ✅ 安全退出处理
  - ✅ 重定向到登录页面

### 3. 创建JSP页面 (100% 完成)
- [ ] **login.jsp** - 登录页面
  - [ ] 用户名/密码表单
  - [ ] 客户端验证
  - [ ] 错误消息显示
  - [ ] 响应式设计

- [ ] **register.jsp** - 注册页面
  - [ ] 完整注册表单
  - [ ] 实时验证反馈
  - [ ] 密码强度检查
  - [ ] 注册协议

- [ ] **index.jsp** - 首页
  - [ ] 用户欢迎界面
  - [ ] 导航菜单
  - [ ] 快速操作入口

---

## 🔄 进行中任务

- 修复Java代码中(UserDAO)使用了盐值(salt)加密方法, 但是已经创建的数据库结构(schedule_db)中没有使用盐值, 仅使用了哈希(password)的问题
---

## 📅 待完成任务



### 4. 创建课程管理类 🔴 (0% 完成)
- [ ] **com.schedule.dao.CourseDAO**
  - [ ] 课程增删改查操作
  - [ ] 按用户查询课程
  - [ ] 时间冲突检测
  - [ ] 批量操作支持

### 5. 实现课程操作Servlet 🔴 (0% 完成)
- [ ] **com.schedule.servlet.AddCourseServlet**
  - [ ] 新增课程处理
  - [ ] 时间冲突验证
  - [ ] 输入数据验证

- [ ] **com.schedule.servlet.UpdateCourseServlet**
  - [ ] 课程信息更新
  - [ ] 权限检查
  - [ ] 数据完整性验证

- [ ] **com.schedule.servlet.DeleteCourseServlet**
  - [ ] 课程删除处理
  - [ ] 确认机制
  - [ ] 级联删除考虑

- [ ] **com.schedule.servlet.ViewScheduleServlet**
  - [ ] 课程表数据查询
  - [ ] 数据格式化
  - [ ] 周视图/日视图支持

### 6. 创建课程管理页面 🔴 (0% 完成)
- [ ] **add-course.jsp** - 添加课程页面
- [ ] **edit-course.jsp** - 编辑课程页面
- [ ] **view-schedule.jsp** - 课程表查看页面

---

## 🎯 验收标准检查

### 功能验收
- [ ] 用户注册登录功能正常
- [ ] 课程增删改查功能完整
- [ ] 时间冲突检测准确
- [ ] 课程表显示正确
- [ ] 用户会话管理安全

### 技术验收
- [ ] 代码符合Java编码规范
- [ ] 数据库设计合理且优化
- [ ] 安全防护措施有效
- [ ] 界面响应式且美观
- [ ] 系统性能满足要求

---


---

## ⚠️ 风险和注意事项

### 技术风险
- **数据库连接稳定性**: 需要添加连接池配置
- **时间冲突算法**: 复杂度较高，需要充分测试
- **会话安全**: 需要防止会话劫持和固定

### 时间风险
- **JSP页面开发**: 前端工作量可能超出预期
- **测试调试**: 集成测试可能发现较多问题

### 解决方案
- 优先完成核心功能，UI可以后续优化
- 准备详细的测试用例
- 及时记录和解决遇到的问题



---

*最后更新时间: 2024年当前*
*更新人: 开发团队*