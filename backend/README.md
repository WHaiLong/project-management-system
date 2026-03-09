# 项目管理系统后端

## 📁 项目结构（实际结构）
```
backend/
├── src/main/java/com/project/management/
│   ├── ProjectManagementApplication.java      # 主启动类
│   ├── controller/                           # 控制器层
│   │   └── ProjectController.java           # 项目管理控制器
│   ├── service/                             # 服务层
│   │   ├── ProjectService.java              # 项目管理服务接口
│   │   └── TaskService.java                 # 任务管理服务接口
│   ├── repository/                          # 数据访问层
│   │   ├── ProjectRepository.java           # 项目管理数据访问
│   │   └── (其他Repository)
│   ├── domain/                              # 领域层
│   │   ├── entity/                          # 实体类
│   │   │   ├── Project.java                 # 项目实体
│   │   │   ├── Task.java                    # 任务实体
│   │   │   └── WorkHour.java                # 工时实体
│   │   ├── vo/                              # 视图对象
│   │   └── dto/                             # 数据传输对象
│   └── config/                              # 配置类
├── src/main/resources/
│   ├── application.yml                      # 主配置文件
│   ├── application-dev.yml                  # 开发环境配置(H2)
│   ├── application-prod.yml                 # 生产环境配置(MySQL)
│   ├── application-druid.yml                # Druid连接池配置
│   └── mapper/                              # MyBatis SQL映射文件
├── pom.xml                                  # Maven配置文件
└── README.md                                # 本文件
```

## 🚀 技术栈
- **框架**: Spring Boot 2.5.14
- **ORM**: MyBatis Plus 3.5.1
- **安全**: Apache Shiro 1.7.1
- **数据库**: MySQL 8.0 (生产) / H2 (开发)
- **连接池**: Druid 1.2.8
- **缓存**: Redis
- **构建工具**: Maven

## 🔧 快速开始

### 1. 开发环境运行
```bash
cd backend
mvn spring-boot:run
```

### 2. 访问地址
- **应用首页**: http://localhost:8080
- **H2控制台**: http://localhost:8080/h2-console
- **Druid监控**: http://localhost:8080/druid
- **API文档**: http://localhost:8080/swagger-ui.html

### 3. 默认账号
- **管理员**: admin / admin123

## 📊 核心功能模块

### 1. 项目管理模块
- 项目CRUD操作
- 项目进度跟踪
- 项目预算管理
- 项目统计分析

### 2. 任务管理模块
- 任务创建和分配
- 任务状态跟踪
- 任务工时估算
- 任务优先级管理

### 3. 工时管理模块
- 工时记录和提交
- 工时审批流程
- 工时统计分析
- 工资计算基础

### 4. 权限管理模块
- 基于角色的权限控制
- 菜单权限管理
- 数据权限控制
- 操作日志记录

## 🗄️ 数据库设计

### 核心表结构
1. **pm_project** - 项目管理表
2. **pm_task** - 任务管理表
3. **pm_work_hour** - 工时记录表
4. **pm_user_ext** - 用户扩展信息表
5. **pm_jira_sync** - Jira同步记录表
6. **pm_salary_calc** - 工资计算表

## 🔗 与前端集成

### API接口规范
- 统一响应格式: `{code: 200, message: "success", data: {...}}`
- 统一异常处理
- 统一分页参数
- 统一权限验证

### 跨域配置
已配置允许前端访问的跨域设置。

## 🚀 部署

### 1. 开发环境
```bash
mvn spring-boot:run -Dspring.profiles.active=dev
```

### 2. 生产环境
```bash
mvn clean package -DskipTests
java -jar target/project-management-backend-1.0.0.jar --spring.profiles.active=prod
```

### 3. Docker部署
```bash
docker build -t project-management-backend .
docker run -p 8080:8080 project-management-backend
```

## 📈 监控和运维

### 健康检查
- `/actuator/health` - 应用健康状态
- `/actuator/info` - 应用信息
- `/actuator/metrics` - 性能指标

### 日志管理
- 日志文件: `logs/project-management-backend.log`
- 日志级别: 开发环境DEBUG，生产环境INFO
- 日志分割: 按大小和时间分割

## 🎯 开发规范

### 代码规范
1. 遵循阿里巴巴Java开发规范
2. 使用Lombok减少样板代码
3. 统一异常处理
4. 统一日志记录

### 接口规范
1. RESTful API设计
2. 统一响应格式
3. 统一错误码
4. 接口文档注释

---

**项目管理系统后端 - 基于Spring Boot的企业级应用**
