#!/bin/bash
echo "📊 插入测试数据到数据库"
echo "开始时间: $(date)"
echo "执行人: 周工（测试工程师）"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 阶段1：检查数据库连接 ===${NC}"

# 检查数据库连接
mysql -u pm_user -pPm@123456 -e "SELECT 1" project_management 2>/dev/null

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 数据库连接失败，请先启动MySQL服务${NC}"
    echo "执行: brew services start mysql"
    exit 1
fi

echo -e "${GREEN}✅ 数据库连接成功${NC}"

echo ""
echo -e "${BLUE}=== 阶段2：清空现有测试数据 ===${NC}"

echo "清空现有测试数据（保留表结构）..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 禁用外键检查
SET FOREIGN_KEY_CHECKS = 0;

-- 清空表数据（按依赖顺序）
TRUNCATE TABLE pm_salary_calc;
TRUNCATE TABLE pm_jira_sync;
TRUNCATE TABLE pm_work_hour;
TRUNCATE TABLE pm_task;
TRUNCATE TABLE pm_project;
TRUNCATE TABLE pm_user_ext;

-- 启用外键检查
SET FOREIGN_KEY_CHECKS = 1;
SQL

echo -e "${GREEN}✅ 现有测试数据已清空${NC}"

echo ""
echo -e "${BLUE}=== 阶段3：插入基础测试数据 ===${NC}"

echo "插入基础测试数据..."

# 插入用户扩展数据
echo "1. 插入用户扩展数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入用户扩展信息
INSERT INTO pm_user_ext (user_id, hourly_rate, department, position, join_date) VALUES
(1, 100.00, '研发部', '高级工程师', '2025-01-15'),
(2, 80.00, '研发部', '工程师', '2025-03-20'),
(3, 120.00, '产品部', '产品经理', '2025-02-10'),
(4, 90.00, '测试部', '测试工程师', '2025-04-05'),
(5, 150.00, '管理部', '项目经理', '2025-01-01');
SQL

echo -e "${GREEN}✅ 用户扩展数据插入完成${NC}"

# 插入项目数据
echo ""
echo "2. 插入项目数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入项目数据
INSERT INTO pm_project (project_name, project_code, description, manager_id, start_date, end_date, budget, status, progress, create_by, remark) VALUES
('项目管理系统开发', 'PMS-2026-001', '基于若依框架的项目管理系统开发项目', 5, '2026-03-01', '2026-06-30', 500000.00, 'in_progress', 65, 'admin', '核心项目，高优先级'),
('客户门户网站重构', 'CPW-2026-002', '客户门户网站前端重构和功能增强', 3, '2026-02-15', '2026-05-15', 300000.00, 'in_progress', 40, 'admin', '提升用户体验'),
('数据中台建设', 'DMP-2026-003', '企业数据中台平台建设', 5, '2026-04-01', '2026-12-31', 1000000.00, 'planning', 10, 'admin', '长期战略项目'),
('移动办公APP', 'MOA-2026-004', '企业内部移动办公应用开发', 3, '2026-01-10', '2026-03-31', 200000.00, 'completed', 100, 'admin', '已上线运行'),
('运维监控系统', 'OMS-2026-005', 'IT运维监控和告警系统', 5, '2026-03-15', '2026-08-31', 400000.00, 'in_progress', 25, 'admin', '提升运维效率');
SQL

echo -e "${GREEN}✅ 项目数据插入完成${NC}"

# 插入任务数据
echo ""
echo "3. 插入任务数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入任务数据
INSERT INTO pm_task (task_name, description, project_id, assignee_id, priority, status, estimated_hours, actual_hours, start_date, due_date, create_by) VALUES
('后端架构设计', '设计项目管理系统后端架构', 1, 1, 'high', 'completed', 40, 38, '2026-03-01', '2026-03-05', 'admin'),
('数据库设计', '设计项目管理系统数据库', 1, 1, 'high', 'completed', 24, 26, '2026-03-02', '2026-03-04', 'admin'),
('用户管理模块开发', '开发用户管理功能模块', 1, 2, 'medium', 'in_progress', 80, 45, '2026-03-05', '2026-03-20', 'admin'),
('项目管理模块开发', '开发项目管理功能模块', 1, 1, 'high', 'in_progress', 120, 65, '2026-03-06', '2026-03-25', 'admin'),
('前端页面设计', '设计项目管理系统前端界面', 1, 3, 'medium', 'in_progress', 60, 30, '2026-03-03', '2026-03-15', 'admin'),
('测试用例编写', '编写项目管理系统测试用例', 1, 4, 'low', 'todo', 40, 0, '2026-03-10', '2026-03-18', 'admin'),
('门户首页重构', '重构客户门户网站首页', 2, 2, 'high', 'in_progress', 40, 25, '2026-02-20', '2026-03-10', 'admin'),
('用户登录优化', '优化用户登录体验和安全性', 2, 1, 'medium', 'todo', 24, 0, '2026-03-11', '2026-03-18', 'admin'),
('数据模型设计', '设计数据中台数据模型', 3, 1, 'high', 'in_progress', 80, 20, '2026-03-01', '2026-03-31', 'admin'),
('API接口开发', '开发数据中台API接口', 3, 2, 'medium', 'todo', 120, 0, '2026-03-15', '2026-04-15', 'admin');
SQL

echo -e "${GREEN}✅ 任务数据插入完成${NC}"

# 插入工时数据
echo ""
echo "4. 插入工时数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入工时数据
INSERT INTO pm_work_hour (user_id, task_id, hours, work_date, description, approval_status, approved_by, approved_time) VALUES
-- 用户1的工时记录
(1, 1, 8, '2026-03-01', '后端架构设计会议和方案制定', 'approved', 5, '2026-03-01 18:00:00'),
(1, 1, 7, '2026-03-02', '架构设计文档编写', 'approved', 5, '2026-03-02 17:30:00'),
(1, 1, 6, '2026-03-03', '技术方案评审和修改', 'approved', 5, '2026-03-03 16:45:00'),
(1, 2, 8, '2026-03-02', '数据库设计初稿', 'approved', 5, '2026-03-02 18:15:00'),
(1, 2, 7, '2026-03-03', '数据库设计优化', 'approved', 5, '2026-03-03 17:20:00'),
(1, 4, 8, '2026-03-06', '项目管理模块需求分析', 'approved', 5, '2026-03-06 18:00:00'),
(1, 4, 7, '2026-03-07', '项目管理模块设计', 'pending', NULL, NULL),
(1, 4, 6, '2026-03-08', '项目管理模块开发', 'pending', NULL, NULL),

-- 用户2的工时记录
(2, 3, 8, '2026-03-05', '用户管理模块需求分析', 'approved', 5, '2026-03-05 17:45:00'),
(2, 3, 7, '2026-03-06', '用户管理模块设计', 'approved', 5, '2026-03-06 16:30:00'),
(2, 3, 6, '2026-03-07', '用户管理模块开发', 'approved', 5, '2026-03-07 17:15:00'),
(2, 7, 8, '2026-02-20', '门户首页需求分析', 'approved', 3, '2026-02-20 18:00:00'),
(2, 7, 7, '2026-02-21', '门户首页设计', 'approved', 3, '2026-02-21 17:30:00'),
(2, 7, 6, '2026-02-22', '门户首页开发', 'pending', NULL, NULL),

-- 用户3的工时记录
(3, 5, 8, '2026-03-03', '前端页面需求分析', 'approved', 5, '2026-03-03 18:00:00'),
(3, 5, 7, '2026-03-04', '前端页面设计', 'approved', 5, '2026-03-04 17:45:00'),
(3, 5, 6, '2026-03-05', '前端页面实现', 'pending', NULL, NULL),

-- 用户4的工时记录
(4, 6, 8, '2026-03-10', '测试计划制定', 'pending', NULL, NULL),
(4, 6, 4, '2026-03-11', '测试用例设计', 'pending', NULL, NULL),

-- 用户1的其他工时
(1, 9, 8, '2026-03-01', '数据模型需求分析', 'approved', 5, '2026-03-01 18:30:00'),
(1, 9, 7, '2026-03-02', '数据模型设计', 'approved', 5, '2026-03-02 17:45:00'),
(1, 9, 5, '2026-03-03', '数据模型评审', 'pending', NULL, NULL);
SQL

echo -e "${GREEN}✅ 工时数据插入完成${NC}"

# 插入Jira同步数据
echo ""
echo "5. 插入Jira同步数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入Jira同步数据
INSERT INTO pm_jira_sync (jira_issue_id, jira_issue_key, task_id, sync_type, sync_status, sync_time, error_message) VALUES
('PMS-1001', 'PMS-1001', 1, 'bidirectional', 'success', '2026-03-01 10:30:00', NULL),
('PMS-1002', 'PMS-1002', 2, 'bidirectional', 'success', '2026-03-02 11:15:00', NULL),
('PMS-1003', 'PMS-1003', 3, 'bidirectional', 'success', '2026-03-05 09:45:00', NULL),
('PMS-1004', 'PMS-1004', 4, 'bidirectional', 'success', '2026-03-06 14:20:00', NULL),
('PMS-1005', 'PMS-1005', 5, 'bidirectional', 'pending', NULL, '网络连接超时'),
('PMS-1006', 'PMS-1006', 6, 'unidirectional', 'success', '2026-03-10 10:00:00', NULL);
SQL

echo -e "${GREEN}✅ Jira同步数据插入完成${NC}"

# 插入工资计算数据
echo ""
echo "6. 插入工资计算数据..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 插入工资计算数据
INSERT INTO pm_salary_calc (user_id, calc_month, total_hours, hourly_rate, total_amount, approval_status, approved_by, approved_time) VALUES
(1, '2026-03', 65, 100.00, 6500.00, 'approved', 5, '2026-03-10 16:30:00'),
(2, '2026-03', 45, 80.00, 3600.00, 'approved', 5, '2026-03-10 16:45:00'),
(3, '2026-03', 21, 120.00, 2520.00, 'pending', NULL, NULL),
(4, '2026-03', 12, 90.00, 1080.00, 'pending', NULL, NULL),
(5, '2026-03', 0, 150.00, 0.00, 'pending', NULL, NULL);
SQL

echo -e "${GREEN}✅ 工资计算数据插入完成${NC}"

echo ""
echo -e "${BLUE}=== 阶段4：验证插入的数据 ===${NC}"

echo "验证插入的数据..."

# 统计各表数据量
echo "各表数据统计:"
mysql -u pm_user -pPm@123456 project_management << 'SQL'
SELECT 
    'pm_user_ext' as 表名, COUNT(*) as 记录数 FROM pm_user_ext
UNION ALL
SELECT 'pm_project', COUNT(*) FROM pm_project
UNION ALL
SELECT 'pm_task', COUNT(*) FROM pm_task
UNION ALL
SELECT 'pm_work_hour', COUNT(*) FROM pm_work_hour
UNION ALL
SELECT 'pm_jira_sync', COUNT(*) FROM pm_jira_sync
UNION ALL
SELECT 'pm_salary_calc', COUNT(*) FROM pm_salary_calc;
SQL

echo ""
echo "数据质量检查:"

# 检查数据完整性
echo "1. 检查数据完整性..."
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 检查是否有空数据
SELECT 
    '项目空名称' as 检查项, COUNT(*) as 问题数 FROM pm_project WHERE project_name IS NULL OR project_name = ''
UNION ALL
SELECT '任务空名称', COUNT(*) FROM pm_task WHERE task_name IS NULL OR task_name = ''
UNION ALL
SELECT '工时负数', COUNT(*) FROM pm_work_hour WHERE hours <= 0
UNION ALL
SELECT '进度超范围', COUNT(*) FROM pm_project WHERE progress < 0 OR progress > 100;
SQL

echo ""
echo "2. 检查业务逻辑:"

# 检查业务逻辑
mysql -u pm_user -pPm@123456 project_management << 'SQL'
-- 检查工时与任务关联
SELECT 
    '有效工时记录' as 检查项, 
    COUNT(*) as 数量
FROM pm_work_hour wh
INNER JOIN pm_task t ON wh.task_id = t.task_id
UNION ALL
SELECT 
    '无效工时记录（任务不存在）',
    COUNT(*)
FROM pm_work_hour wh
LEFT JOIN pm_task t ON wh.task_id = t.task_id
WHERE t.task_id IS NULL;
SQL

echo ""
echo -e "${GREEN}✅ 测试数据插入完成${NC}"

echo ""
echo "📊 数据统计摘要:"
echo "- 用户扩展: 5条记录"
echo "- 项目数据: 5条记录"
echo "- 任务数据: 10条记录"
echo "- 工时记录: 23条记录"
echo "- Jira同步: 6条记录"
echo "- 工资计算: 5条记录"
echo "- 总计: 54条测试数据"

echo ""
echo "🎯 数据特点:"
echo "1. 覆盖所有业务场景"
echo "2. 包含各种状态的数据"
echo "3. 有完整的外键关联"
echo "4. 包含待审批和已审批数据"
echo "5. 有成功和失败的同步记录"

echo ""
echo "📋 下一步:"
echo "1. 运行数据库检查脚本: ./检查数据库数据正确性.sh"
echo "2. 进行功能测试验证数据正确性"
echo "3. 检查业务逻辑是否正确"
echo "4. 验证前后端数据一致性"
