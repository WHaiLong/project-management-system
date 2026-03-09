#!/bin/bash
# 项目管理系统一键启动脚本

echo "🚀 项目管理系统一键启动"
echo "启动时间: $(date)"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查环境
echo "🔍 检查开发环境..."
./check-dev-env.sh

echo ""
echo "📦 启动各服务..."

# 启动后端服务
echo "1. 启动后端服务（若依框架）..."
cd backend/ruoyi
if command -v mvn &> /dev/null; then
    echo "  使用Maven启动..."
    # 后台启动
    nohup mvn spring-boot:run > backend.log 2>&1 &
    BACKEND_PID=$!
    echo "  后端服务启动中... PID: $BACKEND_PID"
    echo "  日志文件: backend/backend.log"
else
    echo "  ${YELLOW}警告: Maven未安装，使用mvnw${NC}"
    chmod +x mvnw
    nohup ./mvnw spring-boot:run > backend.log 2>&1 &
    BACKEND_PID=$!
    echo "  后端服务启动中... PID: $BACKEND_PID"
fi
cd ../..

# 等待后端启动
echo "  等待后端服务启动（10秒）..."
sleep 10

# 检查后端是否启动
if curl -s http://localhost:8080 > /dev/null; then
    echo "  ${GREEN}✅ 后端服务启动成功${NC}"
else
    echo "  ${RED}❌ 后端服务启动失败，请检查日志${NC}"
    echo "  查看日志: tail -f backend/backend.log"
fi

echo ""
echo "2. 启动前端服务..."
cd frontend/project-management-frontend

# 检查node_modules
if [ ! -d "node_modules" ]; then
    echo "  安装依赖..."
    npm install --silent
fi

# 启动前端
echo "  启动前端开发服务器..."
nohup npm run serve > frontend.log 2>&1 &
FRONTEND_PID=$!
echo "  前端服务启动中... PID: $FRONTEND_PID"
echo "  日志文件: frontend/frontend.log"

cd ../..

# 等待前端启动
echo "  等待前端服务启动（5秒）..."
sleep 5

# 检查前端是否启动
if curl -s http://localhost:8081 > /dev/null; then
    echo "  ${GREEN}✅ 前端服务启动成功${NC}"
else
    echo "  ${YELLOW}⚠️ 前端服务可能还在启动中，请稍后检查${NC}"
    echo "  查看日志: tail -f frontend/frontend.log"
fi

echo ""
echo "3. 启动数据库服务（如果使用Docker）..."
if command -v docker &> /dev/null && command -v docker-compose &> /dev/null; then
    if [ -f "docker-compose.yml" ]; then
        echo "  使用Docker Compose启动数据库..."
        docker-compose up -d mysql redis
        echo "  ${GREEN}✅ 数据库服务已启动${NC}"
    else
        echo "  ${YELLOW}⚠️ docker-compose.yml不存在，跳过数据库启动${NC}"
    fi
else
    echo "  ${YELLOW}⚠️ Docker未安装，请手动启动MySQL和Redis${NC}"
fi

echo ""
echo "🎉 服务启动完成！"
echo ""
echo "📱 访问地址："
echo "  前端界面: ${GREEN}http://localhost:8081${NC}"
echo "  后端API: ${GREEN}http://localhost:8080${NC}"
echo "  若依后台: ${GREEN}http://localhost:8080${NC} (用户名: admin, 密码: admin123)"
echo ""
echo "🔧 管理命令："
echo "  查看后端日志: tail -f backend/backend.log"
echo "  查看前端日志: tail -f frontend/frontend.log"
echo "  停止所有服务: ./一键停止.sh"
echo ""
echo "🚀 开始开发吧！"
echo "  按照小时级开发计划.md执行任务"
