#!/bin/bash
# 项目管理系统一键停止脚本

echo "🛑 停止项目管理系统所有服务"
echo "停止时间: $(date)"
echo ""

# 停止前端服务
echo "1. 停止前端服务..."
FRONTEND_PID=$(ps aux | grep "npm run serve" | grep -v grep | awk '{print $2}')
if [ ! -z "$FRONTEND_PID" ]; then
    kill $FRONTEND_PID 2>/dev/null
    echo "  前端服务已停止 (PID: $FRONTEND_PID)"
else
    echo "  前端服务未运行"
fi

# 停止后端服务
echo "2. 停止后端服务..."
BACKEND_PID=$(ps aux | grep "spring-boot:run" | grep -v grep | awk '{print $2}')
if [ ! -z "$BACKEND_PID" ]; then
    kill $BACKEND_PID 2>/dev/null
    echo "  后端服务已停止 (PID: $BACKEND_PID)"
else
    echo "  后端服务未运行"
fi

# 停止Docker服务
echo "3. 停止Docker服务..."
if command -v docker-compose &> /dev/null && [ -f "docker-compose.yml" ]; then
    docker-compose down
    echo "  Docker服务已停止"
fi

echo ""
echo "✅ 所有服务已停止"
