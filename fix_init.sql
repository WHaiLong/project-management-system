-- 创建数据库
CREATE DATABASE IF NOT EXISTS project_management DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE project_management;

-- 先检查sys_user表是否存在（从ry_20250416.sql导入后）
-- 这里假设sys_user表已存在

-- 创建项目表
CREATE TABLE IF NOT EXISTS project (
    project_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '项目ID',
    project_name VARCHAR(100) NOT NULL COMMENT '项目名称',
    project_code VARCHAR(50) UNIQUE NOT NULL COMMENT '项目编码',
    description TEXT COMMENT '项目描述',
    manager_id BIGINT NOT NULL COMMENT '项目经理ID',
    start_date DATE COMMENT '开始日期',
    end_date DATE COMMENT '结束日期',
    budget DECIMAL(15,2) DEFAULT 0 COMMENT '项目预算',
    status VARCHAR(20) DEFAULT '进行中' COMMENT '项目状态',
    progress INT DEFAULT 0 COMMENT '进度百分比',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_manager (manager_id),
    INDEX idx_status (status)
) COMMENT='项目表';

-- 创建任务表
CREATE TABLE IF NOT EXISTS task (
    task_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '任务ID',
    task_title VARCHAR(200) NOT NULL COMMENT '任务标题',
    description TEXT COMMENT '任务描述',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    assignee_id BIGINT COMMENT '负责人ID',
    priority VARCHAR(10) DEFAULT 'P2' COMMENT '优先级',
    status VARCHAR(20) DEFAULT '待处理' COMMENT '任务状态',
    estimate_hours DECIMAL(5,2) DEFAULT 0 COMMENT '预估工时',
    actual_hours DECIMAL(5,2) DEFAULT 0 COMMENT '实际工时',
    due_date DATE COMMENT '截止日期',
    jira_issue_key VARCHAR(50) COMMENT 'Jira关联键',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_project (project_id),
    INDEX idx_assignee (assignee_id),
    INDEX idx_status (status)
) COMMENT='任务表';

-- 创建工时记录表
CREATE TABLE IF NOT EXISTS work_hour (
    work_hour_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '工时ID',
    task_id BIGINT NOT NULL COMMENT '任务ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    work_date DATE NOT NULL COMMENT '工作日期',
    hours DECIMAL(4,2) NOT NULL COMMENT '工时数',
    description TEXT COMMENT '工作描述',
    status VARCHAR(20) DEFAULT '待审批' COMMENT '状态',
    approver_id BIGINT COMMENT '审批人ID',
    approved_time DATETIME COMMENT '审批时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_task (task_id),
    INDEX idx_user (user_id),
    INDEX idx_date (work_date),
    INDEX idx_status (status)
) COMMENT='工时记录表';

-- 创建Jira同步记录表
CREATE TABLE IF NOT EXISTS jira_sync (
    sync_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '同步ID',
    jira_issue_key VARCHAR(50) NOT NULL COMMENT 'Jira问题键',
    local_task_id BIGINT COMMENT '本地任务ID',
    sync_type VARCHAR(20) COMMENT '同步类型',
    sync_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '同步时间',
    sync_status VARCHAR(20) DEFAULT '成功' COMMENT '同步状态',
    error_message TEXT COMMENT '错误信息',
    INDEX idx_jira_key (jira_issue_key),
    INDEX idx_task (local_task_id)
) COMMENT='Jira同步记录表';

-- 创建工资计算记录表
CREATE TABLE IF NOT EXISTS salary_calculation (
    calculation_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '计算ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    calculation_month DATE NOT NULL COMMENT '计算月份',
    total_hours DECIMAL(10,2) DEFAULT 0 COMMENT '总工时',
    hourly_rate DECIMAL(10,2) DEFAULT 0 COMMENT '小时费率',
    total_amount DECIMAL(15,2) DEFAULT 0 COMMENT '总金额',
    calculation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '计算时间',
    status VARCHAR(20) DEFAULT '待支付' COMMENT '状态',
    payment_date DATE COMMENT '支付日期',
    INDEX idx_user_month (user_id, calculation_month)
) COMMENT='工资计算记录表';

-- 插入测试数据
INSERT INTO project (project_name, project_code, description, manager_id, start_date, end_date, budget, status, progress) VALUES
('项目管理系统开发', 'PROJ-001', '基于RuoYi框架的项目管理系统开发项目', 1, '2026-03-01', '2026-06-30', 500000.00, '进行中', 65),
('客户关系管理系统', 'PROJ-002', 'CRM系统升级和功能扩展', 2, '2026-02-15', '2026-05-31', 300000.00, '进行中', 40),
('移动应用开发', 'PROJ-003', 'iOS和Android双平台应用开发', 3, '2026-03-10', '2026-08-31', 800000.00, '规划中', 10);

INSERT INTO task (task_title, description, project_id, assignee_id, priority, status, estimate_hours, actual_hours, due_date) VALUES
('后端架构设计', '设计项目管理系统后端架构', 1, 4, 'P1', '进行中', 40.0, 25.5, '2026-03-15'),
('前端页面开发', '开发项目管理前端页面', 1, 5, 'P2', '待处理', 60.0, 0.0, '2026-03-25'),
('数据库设计', '设计项目相关数据库表结构', 1, 6, 'P1', '已完成', 30.0, 30.0, '2026-03-10'),
('用户权限模块', '实现用户角色和权限管理', 1, 7, 'P2', '进行中', 50.0, 20.0, '2026-03-20');

INSERT INTO work_hour (task_id, user_id, work_date, hours, description, status) VALUES
(1, 4, '2026-03-09', 8.0, '后端架构设计会议和方案制定', '已审批'),
(1, 4, '2026-03-10', 7.5, '架构代码实现和测试', '待审批'),
(3, 6, '2026-03-08', 6.0, '数据库表结构设计', '已审批'),
(3, 6, '2026-03-09', 8.0, 'SQL脚本编写和测试', '已审批');

-- 显示创建的表
SHOW TABLES;

-- 显示各表数据量
SELECT 'project' as table_name, COUNT(*) as record_count FROM project
UNION ALL
SELECT 'task', COUNT(*) FROM task
UNION ALL
SELECT 'work_hour', COUNT(*) FROM work_hour
UNION ALL
SELECT 'jira_sync', COUNT(*) FROM jira_sync
UNION ALL
SELECT 'salary_calculation', COUNT(*) FROM salary_calculation;
