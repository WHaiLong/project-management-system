#!/bin/bash
# 多Agent开发进度同步脚本

echo "📊 项目管理系统多Agent开发进度同步"
echo "同步时间: $(date)"
echo "目标: 今天完成所有开发"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "=== Agent任务完成情况 ==="

# 检查各Agent任务
check_agent() {
    local agent=$1
    local role=$2
    local task_file="agents/$agent/task.md"
    
    if [ -f "$task_file" ]; then
        echo -e "${BLUE}[$role]${NC} $agent - 任务已分配"
        # 提取任务状态
        grep -q "✅" "$task_file" && echo -e "  状态: ${GREEN}进行中${NC}" || echo -e "  状态: ${YELLOW}待开始${NC}"
        
        # 显示任务摘要
        echo        head -10 "$task_file" | grep -E "^(#|##|###|####)" | head -3 | sed 's/^/   /'
    else
        echo -e "${RED}[$role]${NC} $agent - 任务文件不存在"
    fi
}

# 检查所有Agent
check_agent "backend1" "后端Agent1"
check_agent "backend2" "后端Agent2"
check_agent "backend3" "后端Agent3"
check_agent "backend4" "后端Agent4"
check_agent "frontend1" "前端Agent1"
check_agent "frontend2" "前端Agent2"
check_agent "test" "测试Agent"
check_agent "ops" "运维Agent"

echo ""
echo "=== 代码生成情况 ==="

# 检查后端代码
echo "后端代码:"
if [ -f "backend/ruoyi/pom.xml" ]; then
    echo -e "  ${GREEN}✅ 若依框架项目文件${NC}"
else
    echo -e "  ${RED}❌ 若依框架项目文件缺失${NC}"
fi

if [ -f "backend/ruoyi/src/main/java/com/ruoyi/project/domain/Project.java" ]; then
    echo -e "  ${GREEN}✅ Project实体类${NC}"
else
    echo -e "  ${YELLOW}⚠️ Project实体类未创建${NC}"
fi

# 检查前端代码
echo "前端代码:"
if [ -f "frontend/project-management-frontend/package.json" ]; then
    echo -e "  ${GREEN}✅ Vue项目配置${NC}"
else
    echo -e "  ${RED}❌ Vue项目配置缺失${NC}"
fi

if [ -f "frontend/project-management-frontend/src/views/Login.vue" ]; then
    echo -e "  ${GREEN}✅ 登录页面${NC}"
else
    echo -e "  ${RED}❌ 登录页面缺失${NC}"
fi

if [ -f "frontend/project-management-frontend/src/views/Dashboard.vue" ]; then
    echo -e "  ${GREEN}✅ 仪表盘页面${NC}"
else
    echo -e "  ${RED}❌ 仪表盘页面缺失${NC}"
fi

if [ -f "frontend/project-management-frontend/src/views/project/ProjectList.vue" ]; then
    echo -e "  ${GREEN}✅ 项目管理页面${NC}"
else
    echo -e "  ${RED}❌ 项目管理页面缺失${NC}"
fi

echo ""
echo "=== 服务运行状态 ==="

# 检查后端服务
echo "后端服务:"
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ 若依框架运行中${NC}"
else
    echo -e "  ${YELLOW}⚠️ 若依框架未运行${NC}"
    echo "  启动命令: cd backend/ruoyi && mvn spring-boot:run"
fi

# 检查前端服务
echo "前端服务:"
if curl -s http://localhost:8081 > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Vue开发服务器运行中${NC}"
else
    echo -e "  ${YELLOW}⚠️ Vue开发服务器未运行${NC}"
    echo "  启动命令: cd frontend/project-management-frontend && npm run serve"
fi

echo ""
echo "=== 数据库状态 ==="

# 检查数据库
echo "数据库:"
if command -v mysql &> /dev/null; then
    if mysql -uroot -p123456 -e "USE project_management; SHOW TABLES;" 2>/dev/null | grep -q "project"; then
        echo -e "  ${GREEN}✅ 数据库表已创建${NC}"
    else
        echo -e "  ${YELLOW}⚠️ 数据库表未创建${NC}"
        echo "  执行: mysql -uroot -p123456 < backend/ruoyi/init-database.sql"
    fi
else
    echo -e "  ${YELLOW}⚠️ MySQL客户端未安装${NC}"
fi

echo ""
echo "=== 部署配置 ==="

# 检查Docker配置
echo "Docker配置:"
if [ -f "docker-compose.yml" ]; then
    echo -e "  ${GREEN}✅ Docker Compose配置${NC}"
else
    echo -e "  ${RED}❌ Docker Compose配置缺失${NC}"
fi

if [ -f "backend/ruoyi/Dockerfile" ]; then
    echo -e "  ${GREEN}✅ 后端Dockerfile${NC}"
else
    echo -e "  ${RED}❌ 后端Dockerfile缺失${NC}"
fi

if [ -f "frontend/project-management-frontend/Dockerfile" ]; then
    echo -e "  ${GREEN}✅ 前端Dockerfile${NC}"
else
    echo -e "  ${RED}❌ 前端Dockerfile缺失${NC}"
fi

echo ""
echo "=== 测试准备 ==="

# 检查测试
echo "测试准备:"
if [ -f "tests/api-test.py" ]; then
    echo -e "  ${GREEN}✅ API测试脚本${NC}"
else
    echo -e "  ${RED}❌ API测试脚本缺失${NC}"
fi

if [ -f "tests/测试用例-项目管理模块.csv" ]; then
    echo -e "  ${GREEN}✅ 测试用例文件${NC}"
else
    echo -e "  ${RED}❌ 测试用例文件缺失${NC}"
fi

echo ""
echo "=== 总体进度评估 ==="

# 计算总体进度
TOTAL_ITEMS=20
COMPLETED_ITEMS=0

# 检查各项完成情况
[ -f "backend/ruoyi/pom.xml" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "backend/ruoyi/src/main/java/com/ruoyi/project/domain/Project.java" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "frontend/project-management-frontend/package.json" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "frontend/project-management-frontend/src/views/Login.vue" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "frontend/project-management-frontend/src/views/Dashboard.vue" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "frontend/project-management-frontend/src/views/project/ProjectList.vue" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "docker-compose.yml" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "backend/ruoyi/Dockerfile" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "frontend/project-management-frontend/Dockerfile" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "tests/api-test.py" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))
[ -f "tests/测试用例-项目管理模块.csv" ] && COMPLETED_ITEMS=$((COMPLETED_ITEMS + 1))

PROGRESS_PERCENT=$((COMPLETED_ITEMS * 100 / TOTAL_ITEMS))

echo "总体完成度: ${PROGRESS_PERCENT}% (${COMPLETED_ITEMS}/${TOTAL_ITEMS})"

if [ $PROGRESS_PERCENT -ge 80 ]; then
    echo -e "状态: ${GREEN}优秀${NC} - 按计划进行"
elif [ $PROGRESS_PERCENT -ge 60 ]; then
    echo -e "状态: ${YELLOW}良好${NC} - 需要加快进度"
elif [ $PROGRESS_PERCENT -ge 40 ]; then
    echo -e "状态: ${YELLOW}一般${NC} - 进度滞后"
else
    echo -e "状态: ${RED}滞后${NC} - 需要紧急加速"
fi

echo ""
echo "=== 下一步建议 ==="

if [ $PROGRESS_PERCENT -lt 50 ]; then
    echo "1. 立即启动后端服务: cd backend/ruoyi && mvn spring-boot:run"
    echo "2. 立即启动前端服务: cd frontend/project-management-frontend && npm run serve"
    echo "3. 创建数据库表: mysql -uroot -p123456 < backend/ruoyi/init-database.sql"
    echo "4. 继续开发其他页面和API"
elif [ $PROGRESS_PERCENT -lt 80 ]; then
    echo "1. 完善后端API开发"
    echo "2. 开发任务管理和工时管理页面"
    echo "3. 开始集成测试"
    echo "4. 准备部署环境"
else
    echo "1. 进行系统集成测试"
    echo "2. 修复发现的Bug"
    echo "3. 准备生产环境部署"
    echo "4. 编写用户文档"
fi

echo ""
echo "📅 时间提醒:"
echo "当前时间: $(date +%H:%M)"
echo "距离今天结束还有: $((24 - $(date +%H)))小时"
echo "目标完成时间: 今天24:00"

echo ""
echo "🚀 立即执行命令:"
echo "1. 启动所有服务: ./一键启动.sh"
echo "2. 检查详细进度: ./进度检查.sh"
echo "3. 查看Agent任务: cat agents/*/task.md"
echo "4. 访问系统: http://localhost:8081"

echo ""
echo "💪 全力以赴，今天完成！"
