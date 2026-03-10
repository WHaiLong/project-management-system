-- 测试数据
INSERT INTO pm_project (project_name, project_code, description, manager_id, start_date, end_date, budget, status, progress) VALUES
('项目管理系统开发', 'PM001', '开发项目管理系统', 1, '2026-03-01', '2026-04-10', 50000.00, 'in_progress', 80),
('客户门户网站', 'CP002', '客户官方网站', 2, '2026-03-05', '2026-03-31', 30000.00, 'in_progress', 60);

INSERT INTO pm_task (task_code, title, description, project_id, assignee_id, priority, status, estimate_hours, due_date) VALUES
('TASK-001', '登录页面开发', '开发登录页面', 1, 1, 'P1', 'in_progress', 16.00, '2026-03-10'),
('TASK-002', 'API接口设计', '设计API接口', 2, 2, 'P2', 'pending', 8.00, '2026-03-09');

INSERT INTO pm_work_hour (user_id, project_id, task_id, work_date, hours, description, status) VALUES
(1, 1, 1, '2026-03-09', 8.00, '登录页面开发', 'approved'),
(2, 2, 2, '2026-03-09', 4.00, 'API设计', 'pending');
