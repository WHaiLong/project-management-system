#!/bin/bash
echo "🚀 基于若依框架的快速开发脚本"
echo "时间: $(date)"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 步骤1：启动若依框架 ===${NC}"

# 检查若依后端
if [ -d "backend/ruoyi" ]; then
    echo -e "${GREEN}✅ 若依后端目录存在${NC}"
    
    # 检查是否已启动
    if lsof -i :8080 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 若依后端已运行在端口 8080${NC}"
    else
        echo -e "${YELLOW}⚠️ 若依后端未运行，正在启动...${NC}"
        
        # 启动若依后端
        cd backend/ruoyi
        nohup mvn spring-boot:run > ruoyi.log 2>&1 &
        RUOYI_PID=$!
        echo $RUOYI_PID > ruoyi.pid
        
        echo -e "${YELLOW}等待若依启动...${NC}"
        sleep 30
        
        # 检查启动状态
        if curl -s http://localhost:8080 > /dev/null; then
            echo -e "${GREEN}✅ 若依后端启动成功${NC}"
            echo -e "${YELLOW}访问地址: http://localhost:8080${NC}"
            echo -e "${YELLOW}管理员账号: admin / admin123${NC}"
        else
            echo -e "${RED}❌ 若依后端启动失败，查看日志: backend/ruoyi/ruoyi.log${NC}"
            exit 1
        fi
        
        cd ../..
    fi
else
    echo -e "${RED}❌ 若依后端目录不存在${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== 步骤2：生成项目模块代码 ===${NC}"

# 创建数据库表SQL
cat > 生成项目表.sql << 'SQL_TABLES'
-- 项目管理表
CREATE TABLE IF NOT EXISTS `pm_project` (
  `project_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `project_name` varchar(100) NOT NULL COMMENT '项目名称',
  `project_code` varchar(50) NOT NULL COMMENT '项目编号',
  `description` text COMMENT '项目描述',
  `manager_id` bigint(20) DEFAULT NULL COMMENT '项目经理ID',
  `start_date` date DEFAULT NULL COMMENT '开始日期',
  `end_date` date DEFAULT NULL COMMENT '结束日期',
  `budget` decimal(15,2) DEFAULT '0.00' COMMENT '项目预算',
  `status` varchar(20) DEFAULT 'planning' COMMENT '项目状态',
  `progress` int(11) DEFAULT '0' COMMENT '项目进度',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`project_id`),
  UNIQUE KEY `idx_project_code` (`project_code`),
  KEY `idx_status` (`status`),
  KEY `idx_manager` (`manager_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='项目管理表';

-- 任务管理表
CREATE TABLE IF NOT EXISTS `pm_task` (
  `task_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `task_code` varchar(50) NOT NULL COMMENT '任务编号',
  `title` varchar(200) NOT NULL COMMENT '任务标题',
  `description` text COMMENT '任务描述',
  `project_id` bigint(20) NOT NULL COMMENT '项目ID',
  `assignee_id` bigint(20) DEFAULT NULL COMMENT '负责人ID',
  `priority` varchar(10) DEFAULT 'P2' COMMENT '优先级',
  `status` varchar(20) DEFAULT 'pending' COMMENT '任务状态',
  `estimate_hours` decimal(5,1) DEFAULT '0.0' COMMENT '预估工时',
  `actual_hours` decimal(5,1) DEFAULT '0.0' COMMENT '实际工时',
  `due_date` date DEFAULT NULL COMMENT '截止日期',
  `completed_date` datetime DEFAULT NULL COMMENT '完成日期',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`task_id`),
  UNIQUE KEY `idx_task_code` (`task_code`),
  KEY `idx_project` (`project_id`),
  KEY `idx_assignee` (`assignee_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务管理表';

-- 工时记录表
CREATE TABLE IF NOT EXISTS `pm_work_hour` (
  `work_hour_id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '工时ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `project_id` bigint(20) NOT NULL COMMENT '项目ID',
  `task_id` bigint(20) DEFAULT NULL COMMENT '任务ID',
  `work_date` date NOT NULL COMMENT '工作日期',
  `hours` decimal(4,1) NOT NULL COMMENT '工时数',
  `description` varchar(500) DEFAULT NULL COMMENT '工作描述',
  `status` varchar(20) DEFAULT 'pending' COMMENT '状态',
  `approver_id` bigint(20) DEFAULT NULL COMMENT '审批人ID',
  `approved_time` datetime DEFAULT NULL COMMENT '审批时间',
  `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`work_hour_id`),
  KEY `idx_user_date` (`user_id`, `work_date`),
  KEY `idx_project` (`project_id`),
  KEY `idx_task` (`task_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工时记录表';

-- 用户扩展表
CREATE TABLE IF NOT EXISTS `pm_user_ext` (
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `hourly_rate` decimal(10,2) DEFAULT '0.00' COMMENT '时薪',
  `department` varchar(50) DEFAULT NULL COMMENT '部门',
  `position` varchar(50) DEFAULT NULL COMMENT '职位',
  `join_date` date DEFAULT NULL COMMENT '入职日期',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`user_id`),
  KEY `idx_department` (`department`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户扩展信息表';

-- Jira同步表
CREATE TABLE IF NOT EXISTS `pm_jira_sync`