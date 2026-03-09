# 后端服务 (Backend Service)

## 技术架构
- Spring Boot 2.5+
- MyBatis Plus 3.5+
- Spring Security
- Redis缓存
- Jira REST API集成

## 模块划分
1. user-service: 用户中心服务
2. project-service: 项目管理服务
3. task-service: 任务管理服务
4. workhour-service: 工时管理服务
5. salary-service: 薪资计算服务
6. jira-integration-service: Jira集成服务
7. file-service: 文件管理服务

## 数据库
- MySQL 8.0
- 表结构见 docs/database-design.md
