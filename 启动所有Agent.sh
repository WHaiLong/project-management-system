#!/bin/bash
# 启动所有开发Agent

echo "🤖 启动项目管理系统多Agent开发团队"
echo "启动时间: $(date)"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "=== 启动后端Agent ==="

# Agent 1: 若依框架部署
echo -e "${BLUE}[后端Agent1]${NC} 张工 - 若依框架部署"
cat > agents/backend1/task.md << 'TASK1'
# Agent任务：若依框架部署
## 负责人：张工（后端技术负责人）
## 时间：12:20-13:00

### 任务目标
1. 完成若依框架部署和启动
2. 配置数据库连接
3. 扩展用户表结构
4. 验证框架正常运行

### 执行步骤
1. 进入 backend/ruoyi 目录
2. 执行 mvn clean install
3. 启动项目：mvn spring-boot:run
4. 验证访问：http://localhost:8080
5. 扩展用户表字段

### 检查点
- ✅ 项目编译成功
- ✅ 服务启动成功
- ✅ 数据库连接正常
- ✅ 用户表扩展完成

### 输出物
1. 可运行的若依框架
2. 扩展的用户表SQL
3. 部署文档
TASK1
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

# Agent 2: 项目管理模块
echo -e "${BLUE}[后端Agent2]${NC} 李工 - 项目管理模块"
cat > agents/backend2/task.md << 'TASK2'
# Agent任务：项目管理模块开发
## 负责人：李工（后端核心开发）
## 时间：12:30-15:00

### 任务目标
1. 开发项目CRUD API
2. 实现项目成员管理
3. 开发项目状态流转
4. 集成权限控制

### 技术要点
- 使用MyBatis Plus
- RESTful API设计
- 数据权限控制
- 事务管理

### API列表
1. POST /api/projects - 创建项目
2. GET /api/projects - 项目列表
3. GET /api/projects/{id} - 项目详情
4. PUT /api/projects/{id} - 更新项目
5. DELETE /api/projects/{id} - 删除项目
6. POST /api/projects/{id}/members - 添加成员
7. GET /api/projects/{id}/members - 成员列表

### 检查点
- ✅ 项目创建API完成
- ✅ 项目查询API完成
- ✅ 项目更新API完成
- ✅ 成员管理API完成

### 输出物
1. ProjectController.java
2. ProjectService.java
3. ProjectMapper.xml
4. API测试用例
TASK2
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

# Agent 3: 任务管理模块
echo -e "${BLUE}[后端Agent3]${NC} 王工 - 任务管理模块"
cat > agents/backend3/task.md << 'TASK3'
# Agent任务：任务管理模块开发
## 负责人：王工（后端核心开发）
## 时间：12:30-15:00

### 任务目标
1. 开发任务CRUD API
2. 实现任务状态机
3. 开发任务分配逻辑
4. 实现任务搜索和筛选

### 技术要点
- 状态模式设计
- 任务分配算法
- 分页查询优化
- 缓存策略

### API列表
1. POST /api/tasks - 创建任务
2. GET /api/tasks - 任务列表（支持筛选）
3. GET /api/tasks/{id} - 任务详情
4. PUT /api/tasks/{id} - 更新任务
5. PUT /api/tasks/{id}/status - 更新状态
6. POST /api/tasks/{id}/assign - 分配任务
7. GET /api/tasks/kanban - 看板数据

### 状态流转
待处理 → 进行中 → 待测试 → 已完成
           ↓
         已暂停

### 检查点
- ✅ 任务创建API完成
- ✅ 任务状态机完成
- ✅ 任务分配逻辑完成
- ✅ 看板API完成

### 输出物
1. TaskController.java
2. TaskService.java
3. TaskStatusMachine.java
4. TaskMapper.xml
TASK3
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

# Agent 4: 工时管理模块
echo -e "${BLUE}[后端Agent4]${NC} 赵工 - 工时管理模块"
cat > agents/backend4/task.md << 'TASK4'
# Agent任务：工时管理模块开发
## 负责人：赵工（后端集成开发）
## 时间：13:00-16:00

### 任务目标
1. 开发工时记录API
2. 实现工时审核流程
3. 开发工时统计功能
4. 集成Jira工时同步（基础）

### 技术要点
- 工时冲突检测
- 审核工作流
- 统计聚合查询
- 外部API集成

### API列表
1. POST /api/workhours - 记录工时
2. GET /api/workhours - 工时列表
3. GET /api/workhours/{id} - 工时详情
4. PUT /api/workhours/{id}/approve - 审核工时
5. GET /api/workhours/statistics - 工时统计
6. GET /api/workhours/user/{userId} - 用户工时

### 业务规则
1. 工时不能重叠
2. 需要上级审核
3. 支持批量操作
4. 统计按日/周/月

### 检查点
- ✅ 工时记录API完成
- ✅ 审核流程完成
- ✅ 统计功能完成
- ✅ 冲突检测完成

### 输出物
1. WorkHourController.java
2. WorkHourService.java
3. WorkHourApprovalService.java
4. WorkHourStatisticsService.java
TASK4
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

echo ""
echo "=== 启动前端Agent ==="

# Agent 5: Vue项目架构
echo -e "${YELLOW}[前端Agent1]${NC} 陈工 - Vue项目架构"
cat > agents/frontend1/task.md << 'TASK5'
# Agent任务：Vue项目架构
## 负责人：陈工（前端技术负责人）
## 时间：12:20-14:00

### 任务目标
1. 完成Vue项目基础架构
2. 开发登录页面
3. 实现主布局框架
4. 配置路由和状态管理

### 技术要点
- Vue 2.x + Composition API
- Element UI组件库
- Vue Router路由配置
- Vuex状态管理
- Axios HTTP封装

### 页面列表
1. Login.vue - 登录页面
2. MainLayout.vue - 主布局
3. Dashboard.vue - 仪表盘
4. 路由配置
5. 状态管理配置

### 组件设计
1. 导航菜单组件
2. 头部用户信息组件
3. 页面布局组件
4. 表单验证组件

### 检查点
- ✅ 项目可运行
- ✅ 登录功能完成
- ✅ 路由配置完成
- ✅ 状态管理完成

### 输出物
1. 完整的Vue项目结构
2. 登录页面
3. 主布局组件
4. 路由配置文件
TASK5
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

# Agent 6: 业务页面开发
echo -e "${YELLOW}[前端Agent2]${NC} 刘工 - 业务页面开发"
cat > agents/frontend2/task.md << 'TASK6'
# Agent任务：业务页面开发
## 负责人：刘工（前端开发）
## 时间：13:00-18:00

### 任务目标
1. 开发项目管理页面
2. 开发任务管理页面
3. 开发工时填报页面
4. 开发基础报表页面

### 页面详情
1. ProjectList.vue - 项目列表
2. ProjectForm.vue - 项目表单
3. ProjectDetail.vue - 项目详情
4. TaskList.vue - 任务列表
5. TaskKanban.vue - 任务看板
6. WorkHourRecord.vue - 工时填报
7. WorkHourApprove.vue - 工时审核
8. BasicReport.vue - 基础报表

### 功能要点
- 表格展示和分页
- 表单验证和提交
- 数据筛选和搜索
- 图表展示（基础）

### 组件设计
1. 数据表格组件
2. 表单对话框组件
3. 筛选器组件
4. 图表组件（简化）

### 检查点
- ✅ 项目管理页面完成
- ✅ 任务管理页面完成
- ✅ 工时填报页面完成
- ✅ 基础报表页面完成

### 输出物
1. 8个业务页面组件
2. 通用业务组件
3. 页面样式文件
TASK6
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

echo ""
echo "=== 启动测试Agent ==="

# Agent 7: 测试执行
echo -e "${RED}[测试Agent]${NC} 周工 - 测试执行"
cat > agents/test/task.md << 'TASK7'
# Agent任务：测试执行
## 负责人：周工（测试工程师）
## 时间：全程

### 任务目标
1. 准备测试环境
2. 执行测试用例
3. 记录缺陷
4. 验证修复

### 测试范围
1. 功能测试：核心业务流程
2. 接口测试：API接口验证
3. 界面测试：页面交互验证
4. 性能测试：基础性能验证

### 测试计划
1. 12:20-13:00：测试环境准备
2. 13:00-16:00：功能测试执行
3. 16:00-18:00：接口测试执行
4. 18:00-20:00：集成测试
5. 20:00-22:00：回归测试

### 测试用例
- 用户登录测试
- 项目管理测试
- 任务管理测试
- 工时管理测试
- 权限控制测试

### 检查点
- ✅ 测试环境就绪
- ✅ 测试用例执行完成
- ✅ 缺陷记录完整
- ✅ 回归测试通过

### 输出物
1. 测试报告
2. 缺陷列表
3. 测试数据
4. 自动化测试脚本
TASK7
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

echo ""
echo "=== 启动运维Agent ==="

# Agent 8: 部署配置
echo -e "${GREEN}[运维Agent]${NC} 吴工 - 部署配置"
cat > agents/ops/task.md << 'TASK8'
# Agent任务：部署配置
## 负责人：吴工（运维工程师）
## 时间：全程

### 任务目标
1. 准备部署环境
2. 配置Docker容器
3. 设置监控告警
4. 部署生产环境

### 环境配置
1. 开发环境：本地Docker
2. 测试环境：独立服务器
3. 生产环境：阿里云

### 部署步骤
1. 12:20-13:00：Docker环境准备
2. 13:00-16:00：容器镜像构建
3. 16:00-20:00：环境配置优化
4. 20:00-24:00：生产环境部署

### 技术栈
- Docker + Docker Compose
- Nginx反向代理
- MySQL 8.0 + Redis 6.0
- 监控：Prometheus + Grafana
- 日志：ELK Stack

### 检查点
- ✅ Docker环境就绪
- ✅ 容器镜像构建完成
- ✅ 生产环境部署完成
- ✅ 监控配置完成

### 输出物
1. Docker镜像
2. 部署脚本
3. 监控配置
4. 运维文档
TASK8
echo -e "  ${GREEN}✅ 任务分配完成${NC}"

echo ""
echo "🎉 所有Agent任务分配完成！"
echo "8个Agent已就绪，开始并行开发..."
echo ""
echo "📊 Agent状态："
echo "1. 后端Agent1（张工）：若依框架部署"
echo "2. 后端Agent2（李工）：项目管理模块"
echo "3. 后端Agent3（王工）：任务管理模块"
echo "4. 后端Agent4（赵工）：工时管理模块"
echo "5. 前端Agent1（陈工）：Vue项目架构"
echo "6. 前端Agent2（刘工）：业务页面开发"
echo "7. 测试Agent（周工）：测试执行"
echo "8. 运维Agent（吴工）：部署配置"
echo ""
echo "🚀 立即开始执行任务..."
echo "查看任务详情：cat agents/*/task.md"
echo "进度检查：./进度检查.sh"
