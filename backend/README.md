# 项目管理系统后端

## 📁 项目结构（完全按照后端代码说明.md）
```
backend/
├── ruoyi/                    # 若依框架核心
│   ├── ruoyi-admin/         # 后台管理模块
│   ├── ruoyi-common/        # 公共模块
│   ├── ruoyi-framework/     # 框架核心
│   ├── ruoyi-generator/     # 代码生成器
│   ├── ruoyi-quartz/        # 定时任务
│   ├── ruoyi-system/        # 系统模块
│   ├── pom.xml             # Maven配置
│   └── README.md           # 说明文档
├── project/                 # 项目管理模块（自定义）
├── task/                    # 任务管理模块（自定义）
├── workhour/                # 工时管理模块（自定义）
└── README.md               # 本文件
```

## 🚀 技术栈
- **核心框架**: Spring Boot 2.5.14
- **安全框架**: Apache Shiro 1.7.1
- **持久层**: MyBatis Plus 3.5.1
- **连接池**: Druid 1.2.8
- **模板引擎**: Velocity 2.3
- **API文档**: Swagger 3.0.0
- **数据库**: MySQL 8.0 / H2 Database

## 🔧 模块说明

### 1. ruoyi-admin (后台管理模块)
- 系统启动入口
- 权限管理
- 菜单管理
- 用户管理
- 角色管理

### 2. ruoyi-system (系统模块)
- 系统配置
- 字典管理
- 参数配置
- 操作日志
- 登录日志

### 3. ruoyi-generator (代码生成器)
- 自动生成CRUD代码
- 支持自定义模板
- 数据库表反向工程

### 4. ruoyi-quartz (定时任务)
- 任务调度
- 任务监控
- 执行日志

### 5. 自定义模块
- **project**: 项目管理模块
- **task**: 任务管理模块  
- **workhour**: 工时管理模块

## 📊 数据库设计

### 核心业务表
1. **pm_project** - 项目管理表
2. **pm_task** - 任务管理表
3. **pm_work_hour** - 工时记录表
4. **pm_user_ext** - 用户扩展信息表
5. **pm_jira_sync** - Jira同步记录表
6. **pm_salary_calc** - 工资计算表

## 🚀 快速开始

### 1. 环境要求
- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+ (或H2 Database)

### 2. 启动步骤
```bash
# 进入ruoyi目录
cd backend/ruoyi

# 编译项目
mvn clean install

# 启动项目
cd ruoyi-admin
mvn spring-boot:run
```

### 3. 访问地址
- **应用首页**: http://localhost:8080
- **管理员账号**: admin / admin123
- **H2控制台**: http://localhost:8080/h2-console
- **Swagger文档**: http://localhost:8080/swagger-ui.html

## 📈 开发规范

### 1. 代码结构规范
```
com.ruoyi.project
├── controller     # 控制器层
├── service        # 服务层
├── mapper         # 数据访问层
├── domain         # 实体类
└── vo             # 视图对象
```

### 2. 命名规范
- 实体类: Xxx.java
- 控制器: XxxController.java
- 服务接口: IXxxService.java
- 服务实现: XxxServiceImpl.java
- 数据访问: XxxMapper.java

### 3. RESTful API规范
```
GET    /api/xxx      # 查询列表
GET    /api/xxx/{id} # 查询详情
POST   /api/xxx      # 新增
PUT    /api/xxx/{id} # 修改
DELETE /api/xxx/{id} # 删除
```

## 🔗 与前端集成

### 1. 跨域配置
已配置允许前端访问的跨域策略。

### 2. 统一响应格式
```json
{
  "code": 200,
  "msg": "success",
  "data": {}
}
```

### 3. 统一异常处理
- 业务异常: 400
- 权限异常: 401
- 系统异常: 500

## 🎯 核心功能

### 1. 项目管理
- 项目CRUD操作
- 项目进度跟踪
- 项目预算管理
- 项目统计分析

### 2. 任务管理
- 任务创建和分配
- 任务状态跟踪
- 任务工时估算
- 任务优先级管理

### 3. 工时管理
- 工时记录和提交
- 工时审批流程
- 工时统计分析
-工资计算基础

### 4. Jira集成
- Jira数据同步
- 双向状态更新
- 工时数据同步

## 🚀 部署

### 1. 开发环境
```bash
mvn spring-boot:run -Dspring.profiles.active=dev
```

### 2. 生产环境
```bash
mvn clean package -DskipTests
java -jar ruoyi-admin/target/ruoyi-admin.jar --spring.profiles.active=prod
```

### 3. Docker部署
```bash
# 构建镜像
docker build -t project-management-backend .

# 运行容器
docker run -p 8080:8080 project-management-backend
```

## 📈 监控和运维

### 健康检查
- `/actuator/health` - 应用健康状态
- `/actuator/info` - 应用信息
- `/actuator/metrics` - 性能指标

### 日志管理
- 日志文件: `logs/ruoyi-admin.log`
- 日志级别: 开发环境DEBUG，生产环境INFO
- 日志分割: 按大小和时间分割

---

**项目管理系统后端 - 基于若依框架的企业级应用**
