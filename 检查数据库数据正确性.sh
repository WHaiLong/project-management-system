#!/bin/bash
echo "🔍 数据库数据正确性检查"
echo "开始时间: $(date)"
echo "检查人: 周工（测试工程师）"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 阶段1：数据库连接测试 ===${NC}"

# 检查MySQL服务状态
echo "1. 检查MySQL服务状态..."
if pgrep -x "mysqld" > /dev/null; then
    echo -e "   ${GREEN}✅ MySQL服务正在运行${NC}"
else
    echo -e "   ${RED}❌ MySQL服务未运行${NC}"
    echo "   启动MySQL服务..."
    brew services start mysql 2>/dev/null || echo "   请手动启动MySQL服务"
fi

# 测试数据库连接
echo ""
echo "2. 测试数据库连接..."
mysql -u pm_user -pPm@123456 -e "SELECT 1" project_management 2>/dev/null

if [ $? -eq 0 ]; then
    echo -e "   ${GREEN}✅ 数据库连接成功${NC}"
else
    echo -e "   ${RED}❌ 数据库连接失败${NC}"
    echo "   尝试创建数据库和用户..."
    
    # 创建数据库和用户
    mysql -u root -e "
        CREATE DATABASE IF NOT EXISTS project_management;
        CREATE USER IF NOT EXISTS 'pm_user'@'localhost' IDENTIFIED BY 'Pm@123456';
        GRANT ALL PRIVILEGES ON project_management.* TO 'pm_user'@'localhost';
        FLUSH PRIVILEGES;
    " 2>/dev/null
    
    echo "   数据库和用户创建完成，请重新运行检查"
    exit 1
fi

echo ""
echo -e "${BLUE}=== 阶段2：表结构检查 ===${NC}"

# 检查表是否存在
echo "3. 检查核心表结构..."
TABLES=("pm_project" "pm_task" "pm_work_hour" "pm_user_ext" "pm_jira_sync" "pm_salary_calc")

for table in "${TABLES[@]}"; do
    TABLE_EXISTS=$(mysql -u pm_user -pPm@123456 -e "SHOW TABLES LIKE '$table'" project_management 2>/dev/null | wc -l)
    
    if [ $TABLE_EXISTS -eq 2 ]; then
        echo -e "   ${GREEN}✅ $table 表存在${NC}"
        
        # 检查表结构
        echo "   表结构:"
        mysql -u pm_user -pPm@123456 -e "DESCRIBE project_management.$table" 2>/dev/null | head -5
    else
        echo -e "   ${RED}❌ $table 表不存在${NC}"
        
        # 尝试创建表
        echo "   尝试创建 $table 表..."
        if [ -f "创建数据库.sql" ]; then
            grep -A 20 "CREATE TABLE.*$table" "创建数据库.sql" | mysql -u pm_user -pPm@123456 project_management 2>/dev/null
            echo "   $table 表创建完成"
        fi
    fi
    echo ""
done

echo ""
echo -e "${BLUE}=== 阶段3：数据完整性检查 ===${NC}"

# 检查数据完整性
echo "4. 检查数据完整性..."

# 检查pm_project表数据
echo "   📊 检查pm_project表数据..."
PROJECT_COUNT=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_project" project_management 2>/dev/null | tail -1)
echo "   项目数量: $PROJECT_COUNT"

if [ "$PROJECT_COUNT" -gt 0 ]; then
    echo "   项目数据示例:"
    mysql -u pm_user -pPm@123456 -e "SELECT project_id, project_name, status, progress FROM pm_project LIMIT 3" project_management 2>/dev/null
    
    # 检查数据有效性
    echo ""
    echo "   数据有效性检查:"
    
    # 检查状态字段
    INVALID_STATUS=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_project WHERE status NOT IN ('planning', 'in_progress', 'completed', 'cancelled')" project_management 2>/dev/null | tail -1)
    
    if [ "$INVALID_STATUS" -eq 0 ]; then
        echo -e "   ${GREEN}✅ 项目状态字段有效${NC}"
    else
        echo -e "   ${RED}❌ 发现 $INVALID_STATUS 条无效状态数据${NC}"
    fi
    
    # 检查进度字段
    INVALID_PROGRESS=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_project WHERE progress < 0 OR progress > 100" project_management 2>/dev/null | tail -1)
    
    if [ "$INVALID_PROGRESS" -eq 0 ]; then
        echo -e "   ${GREEN}✅ 项目进度字段有效${NC}"
    else
        echo -e "   ${RED}❌ 发现 $INVALID_PROGRESS 条无效进度数据${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  pm_project表无数据，需要插入测试数据${NC}"
fi

echo ""
echo "5. 检查pm_task表数据..."
TASK_COUNT=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_task" project_management 2>/dev/null | tail -1)
echo "   任务数量: $TASK_COUNT"

if [ "$TASK_COUNT" -gt 0 ]; then
    echo "   任务数据示例:"
    mysql -u pm_user -pPm@123456 -e "SELECT task_id, task_name, status, priority FROM pm_task LIMIT 3" project_management 2>/dev/null
    
    # 检查外键关联
    echo ""
    echo "   外键关联检查:"
    
    # 检查任务是否关联有效项目
    ORPHAN_TASKS=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_task t LEFT JOIN pm_project p ON t.project_id = p.project_id WHERE p.project_id IS NULL" project_management 2>/dev/null | tail -1)
    
    if [ "$ORPHAN_TASKS" -eq 0 ]; then
        echo -e "   ${GREEN}✅ 所有任务都有有效的项目关联${NC}"
    else
        echo -e "   ${RED}❌ 发现 $ORPHAN_TASKS 个孤儿任务（无有效项目关联）${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  pm_task表无数据，需要插入测试数据${NC}"
fi

echo ""
echo "6. 检查pm_work_hour表数据..."
WORKHOUR_COUNT=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_work_hour" project_management 2>/dev/null | tail -1)
echo "   工时记录数量: $WORKHOUR_COUNT"

if [ "$WORKHOUR_COUNT" -gt 0 ]; then
    echo "   工时数据示例:"
    mysql -u pm_user -pPm@123456 -e "SELECT work_hour_id, user_id, task_id, hours, work_date FROM pm_work_hour LIMIT 3" project_management 2>/dev/null
    
    # 检查工时合理性
    echo ""
    echo "   工时合理性检查:"
    
    # 检查工时是否超过合理范围（每天最多12小时）
    EXCESS_HOURS=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_work_hour WHERE hours > 12" project_management 2>/dev/null | tail -1)
    
    if [ "$EXCESS_HOURS" -eq 0 ]; then
        echo -e "   ${GREEN}✅ 所有工时记录在合理范围内${NC}"
    else
        echo -e "   ${RED}❌ 发现 $EXCESS_HOURS 条工时记录超过12小时${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️  pm_work_hour表无数据，需要插入测试数据${NC}"
fi

echo ""
echo -e "${BLUE}=== 阶段4：业务逻辑数据检查 ===${NC}"

# 检查业务逻辑相关数据
echo "7. 检查业务逻辑数据..."

# 检查项目预算和实际工时
echo "   检查项目预算与实际工时匹配..."
mysql -u pm_user -pPm@123456 -e "
SELECT 
    p.project_id,
    p.project_name,
    p.budget as 项目预算,
    COALESCE(SUM(wh.hours), 0) as 总工时,
    COALESCE(SUM(wh.hours) * 100, 0) as 估算成本,
    CASE 
        WHEN COALESCE(SUM(wh.hours) * 100, 0) > p.budget THEN '超预算'
        ELSE '在预算内'
    END as 预算状态
FROM pm_project p
LEFT JOIN pm_task t ON p.project_id = t.project_id
LEFT JOIN pm_work_hour wh ON t.task_id = wh.task_id
GROUP BY p.project_id, p.project_name, p.budget
HAVING p.budget > 0
LIMIT 5;
" project_management 2>/dev/null

# 检查任务状态分布
echo ""
echo "   检查任务状态分布..."
mysql -u pm_user -pPm@123456 -e "
SELECT 
    status as 任务状态,
    COUNT(*) as 任务数量,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pm_task), 2) as 占比百分比
FROM pm_task
GROUP BY status
ORDER BY COUNT(*) DESC;
" project_management 2>/dev/null

# 检查用户工时统计
echo ""
echo "   检查用户工时统计..."
mysql -u pm_user -pPm@123456 -e "
SELECT 
    user_id as 用户ID,
    COUNT(*) as 工时记录数,
    SUM(hours) as 总工时,
    AVG(hours) as 平均工时,
    MAX(hours) as 最大单日工时,
    MIN(hours) as 最小单日工时
FROM pm_work_hour
GROUP BY user_id
ORDER BY SUM(hours) DESC
LIMIT 5;
" project_management 2>/dev/null

echo ""
echo -e "${BLUE}=== 阶段5：数据一致性检查 ===${NC}"

# 检查数据一致性
echo "8. 检查数据一致性..."

# 检查日期逻辑
echo "   检查日期逻辑..."
INVALID_DATES=$(mysql -u pm_user -pPm@123456 -e "SELECT COUNT(*) FROM pm_project WHERE start_date > end_date" project_management 2>/dev/null | tail -1)

if [ "$INVALID_DATES" -eq 0 ]; then
    echo -e "   ${GREEN}✅ 项目日期逻辑正确（开始日期 ≤ 结束日期）${NC}"
else
    echo -e "   ${RED}❌ 发现 $INVALID_DATES 个项目日期逻辑错误${NC}"
fi

# 检查进度与状态一致性
echo ""
echo "   检查进度与状态一致性..."
INCONSISTENT_STATUS=$(mysql -u pm_user -pPm@123456 -e "
SELECT COUNT(*) FROM pm_project 
WHERE (status = 'completed' AND progress < 100) 
   OR (status = 'cancelled' AND progress > 0)
" project_management 2>/dev/null | tail -1)

if [ "$INCONSISTENT_STATUS" -eq 0 ]; then
    echo -e "   ${GREEN}✅ 项目进度与状态一致${NC}"
else
    echo -e "   ${RED}❌ 发现 $INCONSISTENT_STATUS 个项目进度与状态不一致${NC}"
fi

# 检查工时审批状态
echo ""
echo "   检查工时审批状态..."
mysql -u pm_user -pPm@123456 -e "
SELECT 
    approval_status as 审批状态,
    COUNT(*) as 记录数,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pm_work_hour), 2) as 占比百分比
FROM pm_work_hour
GROUP BY approval_status
ORDER BY COUNT(*) DESC;
" project_management 2>/dev/null

echo ""
echo -e "${BLUE}=== 检查结果汇总 ===${NC}"

# 汇总检查结果
echo "9. 检查结果汇总:"

# 统计各种检查结果
TOTAL_TABLES=6
EXISTING_TABLES=0
VALID_DATA=0
ISSUES_FOUND=0

# 统计表存在情况
for table in "${TABLES[@]}"; do
    TABLE_EXISTS=$(mysql -u pm_user -pPm@123456 -e "SHOW TABLES LIKE '$table'" project_management 2>/dev/null | wc -l)
    if [ $TABLE_EXISTS -eq 2 ]; then
        ((EXISTING_TABLES++))
    fi
done

echo "   表结构检查: $EXISTING_TABLES/$TOTAL_TABLES 个表存在"

# 如果有数据，检查数据质量
if [ "$PROJECT_COUNT" -gt 0 ] || [ "$TASK_COUNT" -gt 0 ] || [ "$WORKHOUR_COUNT" -gt 0 ]; then
    echo "   数据质量检查:"
    
    # 这里可以添加更复杂的数据质量检查
    if [ "$INVALID_STATUS" -eq 0 ] && [ "$INVALID_PROGRESS" -eq 0 ] && [ "$ORPHAN_TASKS" -eq 0 ] && [ "$EXCESS_HOURS" -eq 0 ] && [ "$INVALID_DATES" -eq 0 ] && [ "$INCONSISTENT_STATUS" -eq 0 ]; then
        echo -e "   ${GREEN}✅ 数据质量优秀，未发现问题${NC}"
        VALID_DATA=1
    else
        echo -e "   ${YELLOW}⚠️  数据质量有待改进，发现一些问题${NC}"
        
        ISSUES_FOUND=$((INVALID_STATUS + INVALID_PROGRESS + ORPHAN_TASKS + EXCESS_HOURS + INVALID_DATES + INCONSISTENT_STATUS))
        echo "   发现的问题数量: $ISSUES_FOUND"
    fi
else
    echo "   数据量检查: 表中有少量或无数据，需要插入测试数据"
fi

echo ""
echo "10. 建议措施:"

if [ $EXISTING_TABLES -lt $TOTAL_TABLES ]; then
    echo -e "   ${YELLOW}⚠️  建议: 创建缺失的表结构${NC}"
    echo "   执行: mysql -u pm_user -pPm@123456 project_management < 创建数据库.sql"
fi

if [ "$PROJECT_COUNT" -eq 0 ] || [ "$TASK_COUNT" -eq 0 ] || [ "$WORKHOUR_COUNT" -eq 0 ]; then
    echo -e "   ${YELLOW}⚠️  建议: 插入测试数据${NC}"
    echo "   执行: python tests/生成测试数据.py"
fi

if [ $ISSUES_FOUND -gt 0 ]; then
    echo -e "   ${YELLOW}⚠️  建议: 修复数据质量问题${NC}"
    echo "   需要修复的问题:"
    [ "$INVALID_STATUS" -gt 0 ] && echo "   - $INVALID_STATUS 条无效状态数据"
    [ "$INVALID_PROGRESS" -gt 0 ] && echo "   - $INVALID_PROGRESS 条无效进度数据"
    [ "$ORPHAN_TASKS" -gt 0 ] && echo "   - $ORPHAN_TASKS 个孤儿任务"
    [ "$EXCESS_HOURS" -gt 0 ] && echo "   - $EXCESS_HOURS 条超时工时记录"
    [ "$INVALID_DATES" -gt 0 ] && echo "   - $INVALID_DATES 条日期逻辑错误"
    [ "$INCONSISTENT_STATUS" -gt 0 ] && echo "   - $INCONSISTENT_STATUS 条状态进度不一致"
fi

if [ $EXISTING_TABLES -eq $TOTAL_TABLES ] && [ $VALID_DATA -eq 1 ]; then
    echo -e "   ${GREEN}✅ 建议: 数据库状态良好，可以继续测试${NC}"
fi

echo ""
echo "📊 检查完成时间: $(date)"
echo "🎯 检查结论: 数据库数据正确性检查完成"

if [ $ISSUES_FOUND -gt 0 ]; then
    echo -e "${YELLOW}⚠️  注意: 发现 $ISSUES_FOUND 个数据质量问题，建议修复后再继续测试${NC}"
else
    echo -e "${GREEN}✅ 恭喜: 数据库数据质量良好，可以继续进行功能测试${NC}"
fi

echo ""
echo "📋 下一步:"
echo "1. 如果发现问题，先修复数据问题"
echo "2. 然后继续进行功能测试"
echo "3. 定期运行此检查脚本确保数据质量"
echo "4. 将检查结果记录到测试报告中"
