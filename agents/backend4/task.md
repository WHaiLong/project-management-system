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
