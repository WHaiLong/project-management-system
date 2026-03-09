#!/bin/bash
# 开发进度检查脚本

echo "📊 项目管理系统开发进度检查"
echo "检查时间: $(date)"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "=== 服务状态检查 ==="

# 检查后端服务
if curl -s http://localhost:8080 > /dev/null; then
    echo -e "后端服务: ${GREEN}✅ 运行中${NC}"
else
    echo -e "后端服务: ${RED}❌ 未运行${NC}"
fi

# 检查前端服务
if curl -s http://localhost:8081 > /dev/null; then
    echo -e "前端服务: ${GREEN}✅ 运行中${NC}"
else
    echo -e "前端服务: ${RED}❌ 未运行${NC}"
fi

# 检查数据库
if command -v mysql &> /dev/null; then
    if mysql -uroot -p123456 -e "USE project_management; SELECT 1;" 2>/dev/null | grep -q "1"; then
        echo -e "数据库: ${GREEN}✅ 连接正常${NC}"
    else
        echo -e "数据库: ${RED}❌ 连接失败${NC}"
    fi
fi

echo ""
echo "=== 代码提交检查 ==="

# 检查Git提交
LAST_COMMIT=$(git log --oneline -1 --since="12:00" 2>/dev/null)
if [ ! -z "$LAST_COMMIT" ]; then
    echo -e "最新提交: ${GREEN}$LAST_COMMIT${NC}"
else
    echo -e "代码提交: ${YELLOW}⚠️ 今天暂无提交${NC}"
fi

COMMIT_COUNT=$(git log --oneline --since="12:00" 2>/dev/null | wc -l)
echo "今天提交次数: $COMMIT_COUNT"

echo ""
echo "=== 任务完成情况 ==="

# 读取小时级计划，检查任务
TASK_FILE="小时级开发计划.md"
if [ -f "$TASK_FILE" ]; then
    echo "根据小时级计划检查："
    
    CURRENT_HOUR=$(date +%H)
    if [ $CURRENT_HOUR -ge 12 ] && [ $CURRENT_HOUR -lt 13 ]; then
        echo "当前阶段: 环境搭建 (12:00-13:00)"
        echo "应完成: 若依框架部署、Vue项目初始化"
    elif [ $CURRENT_HOUR -ge 13 ] && [ $CURRENT_HOUR -lt 18 ]; then
        echo "当前阶段: 核心功能开发 (13:00-18:00)"
        echo "应完成: 用户权限、项目管理、任务管理、工时管理"
    elif [ $CURRENT_HOUR -ge 18 ] && [ $CURRENT_HOUR -lt 20 ]; then
        echo "当前阶段: 集成测试 (18:00-20:00)"
        echo "应完成: 前后端联调、系统测试"
    elif [ $CURRENT_HOUR -ge 20 ] && [ $CURRENT_HOUR -lt 22 ]; then
        echo "当前阶段: Bug修复 (20:00-22:00)"
        echo "应完成: 紧急Bug修复"
    elif [ $CURRENT_HOUR -ge 22 ]; then
        echo "当前阶段: 部署验证 (22:00-24:00)"
        echo "应完成: 生产环境部署、上线验证"
    fi
fi

echo ""
echo "=== 文件生成检查 ==="

# 检查关键文件
declare -A FILES=(
    ["后端框架"]="backend/ruoyi/pom.xml"
    ["前端项目"]="frontend/project-management-frontend/package.json"
    ["数据库脚本"]="backend/ruoyi/init-database.sql"
    ["登录页面"]="frontend/project-management-frontend/src/views/Login.vue"
    ["项目管理页面"]="frontend/project-management-frontend/src/views/project/ProjectList.vue"
)

for desc in "${!FILES[@]}"; do
    file="${FILES[$desc]}"
    if [ -f "$file" ]; then
        echo -e "$desc: ${GREEN}✅ 已创建${NC}"
    else
        echo -e "$desc: ${YELLOW}⚠️ 未创建${NC}"
    fi
done

echo ""
echo "=== 建议下一步 ==="

case $CURRENT_HOUR in
    12|13)
        echo "1. 运行 ./一键启动.sh 启动所有服务"
        echo "2. 按照小时级计划开始核心功能开发"
        echo "3. 每30分钟在飞书群汇报进度"
        ;;
    14|15|16|17)
        echo "1. 检查前后端接口是否联通"
        echo "2. 测试核心业务流程"
        echo "3. 准备集成测试数据"
        ;;
    18|19)
        echo "1. 开始集成测试"
        echo "2. 记录发现的Bug"
        echo "3. 准备Bug修复"
        ;;
    20|21)
        echo "1. 修复紧急Bug"
        echo "2. 优化系统性能"
        echo "3. 准备部署环境"
        ;;
    22|23)
        echo "1. 开始生产环境部署"
        echo "2. 进行上线验证"
        echo "3. 配置监控告警"
        ;;
    *)
        echo "1. 查看小时级开发计划.md"
        echo "2. 按照计划执行当前阶段任务"
        ;;
esac

echo ""
echo "📞 紧急问题请在飞书群@相关人员"
echo "⏰ 下一进度检查: 30分钟后"
