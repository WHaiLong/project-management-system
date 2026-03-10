-- H2内存数据库初始化脚本
-- 项目管理系统表结构

-- 项目表
CREATE TABLE IF NOT EXISTS pm_project (
    project_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    project_code VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    manager_id BIGINT NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(15,2) DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'planning',
    progress INT DEFAULT 0,
    created_by VARCHAR(50),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 任务表
CREATE TABLE IF NOT EXISTS pm_task (
    task_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    task_code VARCHAR(50) NOT NULL UNIQUE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    project_id BIGINT NOT NULL,
    assignee_id BIGINT NOT NULL,
    priority VARCHAR(10) DEFAULT 'P2',
    status VARCHAR(20) DEFAULT 'pending',
    estimate_hours DECIMAL(5,2) DEFAULT 0.00,
    actual_hours DECIMAL(5,2) DEFAULT 0.00,
    due_date DATE,
    completed_date DATE,
    created_by VARCHAR(50),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES pm_project(project_id) ON DELETE CASCADE
);

-- 工时记录表
CREATE TABLE IF NOT EXISTS pm_work_hour (
    work_hour_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    project_id BIGINT NOT NULL,
    task_id BIGINT,
    work_date DATE NOT NULL,
    hours DECIMAL(5,2) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    approver_id BIGINT,
    approved_time TIMESTAMP,
    reject_reason TEXT,
    created_by VARCHAR(50),
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50),
    updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES pm_project(project_id) ON DELETE CASCADE,
    FOREIGN KEY (task_id) REFERENCES pm_task(task_id) ON DELETE SET NULL
);

-- 创建索引
CREATE INDEX idx_project_status ON pm_project(status);
CREATE INDEX idx_task_project ON pm_task(project_id);
CREATE INDEX idx_task_status ON pm_task(status);
CREATE INDEX idx_workhour_user_date ON pm_work_hour(user_id, work_date);
