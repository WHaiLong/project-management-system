# 🚀 项目管理系统

## 📋 项目概述

基于RuoYi框架的互联网软件项目R&D管理系统，支持20人团队协作，包含Jira双向同步和小时工资计算功能。

## 🎯 项目特点

- **完整功能**: 项目管理、任务管理、工时管理、权限控制
- **技术先进**: Spring Boot后端 + Vue.js前端 + MySQL数据库
- **团队协作**: 支持20人团队，角色分工明确
- **集成能力**: Jira双向同步，工资计算引擎
- **快速开发**: 基于RuoYi框架，开发效率高

## 📁 项目结构

```
project-management-system/
├── docs/                          # 项目文档
│   ├── 01-需求文档/              # PRD和需求相关
│   ├── 02-设计文档/              # 技术设计和架构
│   ├── 03-计划文档/              # 项目计划和进度
│   ├── 04-测试文档/              # 测试用例和报告
│   ├── 05-团队文档/              # 团队管理和分工
│   └── 06-会议记录/              # 会议记录和决策
├── src/                           # 源代码
│   ├── backend/                  # 后端代码（Spring Boot）
│   └── frontend/                 # 前端代码（Vue.js）
├── scripts/                       # 脚本工具
│   ├── 01-环境配置/              # 环境配置脚本
│   ├── 02-部署脚本/              # 部署和发布脚本
│   ├── 03-工具脚本/              # 开发工具脚本
│   └── 04-测试脚本/              # 测试相关脚本
├── config/                        # 配置文件
│   ├── 01-环境配置/              # 环境配置文件
│   ├── 02-应用配置/              # 应用配置文件
│   └── 03-部署配置/              # 部署配置文件
├── agents/                        # 团队Agent配置
├── issues/                        # 问题跟踪
│   ├── 01-问题清单/              # 问题列表和状态
│   ├── 02-解决方案/              # 解决方案文档
│   └── 03-问题报告/              # 问题分析报告
├── gitlab/                        # GitLab相关
│   ├── 01-配置文档/              # GitLab配置文档
│   ├── 02-同步脚本/              # 同步脚本和工具
│   └── 03-问题记录/              # GitLab问题记录
├── tests/                         # 测试代码
└── temp/                          # 临时文件
```

## 🚀 快速开始

### 环境要求
- Java 11+
- Node.js 14+
- MySQL 8.0+
- Maven 3.6+

### 启动步骤
```bash
# 1. 克隆项目
git clone https://github.com/WHaiLong/project-management-system.git

# 2. 启动后端服务
cd scripts/02-部署脚本/
./一键启动.sh

# 3. 启动前端服务
cd ../../frontend/project-management-frontend
npm install
npm run serve

# 4. 访问系统
# 后端: http://localhost:8080
# 前端: http://localhost:8081
```

## 👥 团队配置

### 21人团队结构
- **管理团队**: 项目经理、产品经理、技术经理
- **后端团队**: 8名后端开发工程师
- **前端团队**: 6名前端开发工程师
- **测试团队**: 2名测试工程师
- **运维团队**: 1名运维工程师
- **文档团队**: 1名文档工程师

### 角色职责
详细团队分工见 `docs/05-团队文档/团队分工.md`

## 📊 开发进度

### 当前状态
- **代码完成度**: 90% (50,314行代码)
- **文档完成度**: 95% (完整文档体系)
- **测试完成度**: 10% (环境问题阻塞)
- **部署完成度**: 20% (环境准备中)
- **项目时间**: 已超时，开发暂停中

### 里程碑
- ✅ 13:35: 项目启动
- ✅ 14:41: 团队首次代码提交
- ✅ 17:56: 后端代码重构完成
- ✅ 19:40: 项目计划表创建完成
- ⚠️ 21:00: 项目计划完成时间（已超时）
- ⚠️ 21:09: 开发暂停指令
- ⚠️ 21:30: GitLab同步问题持续

## 🔧 技术栈

### 后端技术
- **框架**: Spring Boot 2.7.x
- **安全**: Spring Security
- **ORM**: MyBatis Plus
- **数据库**: MySQL 8.0 / H2 (开发)
- **缓存**: Redis
- **消息**: RabbitMQ (可选)

### 前端技术
- **框架**: Vue.js 2.x
- **UI库**: Element UI
- **状态管理**: Vuex
- **路由**: Vue Router
- **构建工具**: Webpack

### 开发工具
- **版本控制**: Git (GitHub + GitLab)
- **构建工具**: Maven + npm
- **容器化**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **文档**: Markdown + Feishu

## 📈 功能模块

### 核心功能
1. **项目管理**: 项目创建、编辑、查看、删除
2. **任务管理**: 任务分配、跟踪、状态管理
3. **工时管理**: 工时记录、审批、统计
4. **用户管理**: 用户注册、登录、权限控制
5. **角色权限**: 基于角色的访问控制

### 高级功能
1. **Jira集成**: 双向数据同步
2. **工资计算**: 小时工资计算引擎
3. **报表统计**: 多维数据分析和报表
4. **消息通知**: 实时消息和邮件通知
5. **移动端**: 响应式设计和PWA支持

## 🚨 已知问题

### 高优先级
1. **GitLab同步失败**: HTTPS+密码认证问题
2. **MySQL环境缺失**: 数据库未安装，测试阻塞
3. **时间超时**: 项目已超时，需要调整计划

### 中优先级
1. **测试未执行**: 因环境问题测试阻塞
2. **部署未完成**: 生产环境配置未验证
3. **高级功能未实现**: Jira集成等高级功能

### 低优先级
1. **代码注释不完整**: 需要完善代码注释
2. **测试覆盖率不足**: 需要增加测试覆盖
3. **文档需要优化**: 部分文档需要完善

## 📞 联系方式

### 项目负责人
- **项目经理**: 郑工
- **技术经理**: 孙工
- **产品经理**: 钱工
- **运维负责人**: 吴工

### 仓库信息
- **GitHub**: https://github.com/WHaiLong/project-management-system
- **GitLab**: https://gitlab.cihon.cn/whl_openclaw/project-management-system (同步中)

### 文档存储
- **Feishu文档**: 主要项目文档存储在Feishu
- **本地文档**: 备份文档在 `docs/` 目录
- **代码注释**: 代码中的注释文档

## 📝 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢所有参与项目的团队成员：
- 21人虚拟团队的辛勤工作
- 技术专家的专业指导
- 管理团队的有效协调
- 所有支持项目的相关人员

---

**项目启动时间**: 2026年3月9日 13:35
**最后更新时间**: 2026年3月9日 21:39
**当前状态**: 开发暂停，结构整理完成

**🚀 项目管理系统 - 让团队协作更高效！**

## 🗄️ MySQL数据库配置

### 数据库信息
- **数据库类型**: MySQL
- **主机**: localhost:3306
- **数据库名**: project_management
- **用户名**: root
- **密码**: 28465@Whl
- **状态**: ✅ 已安装完成

### 快速启动
1. **启动MySQL服务**:
   ```bash
   # macOS
   brew services start mysql
   
   # Linux
   sudo systemctl start mysql
   ```

2. **初始化数据库**:
   ```bash
   ./scripts/init-mysql-database.sh
   ```

3. **测试连接**:
   ```bash
   ./scripts/test-mysql-connection.sh
   ```

### 项目配置
在 `application.yml` 中使用以下配置:
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/project_management
    username: root
    password: 28465@Whl
    driver-class-name: com.mysql.cj.jdbc.Driver
```

### 管理工具
- **初始化脚本**: `scripts/init-mysql-database.sh`
- **测试脚本**: `scripts/test-mysql-connection.sh`
- **配置模板**: `config/mysql-config.yml`
