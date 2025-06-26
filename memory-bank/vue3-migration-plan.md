# Vue3 迁移实施计划

## 技术选型
- **前端框架**：Vue3 (Composition API)
- **构建工具**：Vite 4.x
- **UI组件库**：Element Plus
- **状态管理**：Pinia
- **HTTP客户端**：Axios
- **CSS处理**：直接复用现有CSS + Scoped CSS

## 阶段1：环境搭建 (预计2天)
1. 初始化项目：
```bash
npm create vite@latest lesson-calendar-vue -- --template vue
cd lesson-calendar-vue
npm install element-plus pinia axios
```

2. 目录结构：
```
src/
├── assets/          # 静态资源
├── components/      # 通用组件
├── services/        # API服务
├── stores/          # Pinia状态管理
├── styles/          # 样式文件
├── views/           # 页面视图
└── main.js          # 入口文件
```

3. 配置别名（vite.config.js）：
```javascript
export default defineConfig({
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src')
    }
  }
})
```

## 阶段2：组件迁移 (预计5天)
| JSP页面 | Vue组件 | 关键任务 |
|---------|---------|---------|
| login.jsp | Login.vue | 重构表单验证，集成Axios |
| admin-courses.jsp | AdminCourses.vue | 转换数据表格为el-table |
| view-schedule.jsp | Schedule.vue | 实现课表可视化组件 |
| ... | ... | ... |

**样式处理**：
1. 复制所有`webapp/css/*.css`到`src/styles/`
2. 在`main.js`全局导入：
```javascript
import '@/styles/form.css'
import '@/styles/index.css'
```

## 阶段3：状态管理 (预计2天)
1. 创建认证store：
```javascript
// stores/auth.js
export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  
  const login = async (credentials) => {
    const response = await axios.post('/api/login', credentials)
    user.value = response.data
  }
  
  return { user, login }
})
```

2. 课程store示例：
```javascript
// stores/course.js
export const useCourseStore = defineStore('course', () => {
  const courses = ref([])
  
  const fetchCourses = async () => {
    const response = await axios.get('/api/courses')
    courses.value = response.data
  }
  
  return { courses, fetchCourses }
})
```

## 阶段4：API集成 (预计3天)
1. 创建API服务模块：
```javascript
// services/api.js
import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:8080/lessonCalendarShixun3',
  timeout: 10000
})

// 请求拦截器（添加JWT）
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

export default api
```

2. 课程服务示例：
```javascript
// services/courseService.js
import api from './api'

export default {
  getCourses: () => api.get('/courses'),
  createCourse: data => api.post('/courses', data),
  updateCourse: (id, data) => api.put(`/courses/${id}`, data)
}
```

## 阶段5：构建部署 (预计1天)
1. 生产环境构建：
```bash
npm run build
```

2. Docker容器化配置：
```Dockerfile
FROM nginx:alpine
COPY dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

## 后续维护
1. 添加Jest单元测试
2. 实现CI/CD流水线
3. 性能优化（代码分割/懒加载）
