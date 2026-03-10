-- 创建数据库
CREATE DATABASE IF NOT EXISTS project_management DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE project_management;

-- 扩展用户表（增加项目管理相关字段）
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS hourly_rate DECIMAL(10,2) DEFAULT 0 COMMENT '小时费率';
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS employee_id VARCHAR(50) COMMENT '员工编号';
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS join_date DATE COMMENT '入职日期';
ALTER TABLE sys_user ADD COLUMN IF NOT EXISTS bank_account VARCHAR(100) COMMENT '银行账户';

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
    INDEX idx_status (status),
    FOREIGN KEY (project_id) REFERENCES project(project_id)
) COMMENT='任务表';

-- 创建工时记录表
CREATE TABLE IF NOT EXISTS work_hour (
    hour_id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '工时ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    task_id BIGINT NOT NULL COMMENT '任务ID',
    work_date DATE NOT NULL COMMENT '工作日期',
    start_time TIME COMMENT '开始时间',
    end_time TIME COMMENT '结束时间',
    hours DECIMAL(5,2) NOT NULL COMMENT '工时数',
    overtime_type VARCHAR(20) DEFAULT 'normal' COMMENT '加班类型',
    description VARCHAR(500) COMMENT '工作内容',
    status VARCHAR(20) DEFAULT '待审核' COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_date (user_id, work_date),
    INDEX idx_task (task_id),
    INDEX idx_status (status),
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id),
    FOREIGN KEY (task_id) REFERENCES task(task_id)
) COMMENT='工时记录表';

-- 创建项目成员表
CREATE TABLE IF NOT EXISTS project_member (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'ID',
    project_id BIGINT NOT NULL COMMENT '项目ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role VARCHAR(50) DEFAULT '成员' COMMENT '角色',
    join_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    UNIQUE KEY uk_project_user (project_id, user_id),
    INDEX idx_project (project_id),
    INDEX idx_user (user_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(user_id)
) COMMENT='项目成员表';

echo "✅ 数据库脚本已生成"
echo "请执行：mysql -u root -p < init-database.sql"
