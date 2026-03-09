#!/bin/bash
echo "🚀 快速启动测试环境"
echo "时间: $(date)"
echo ""

# 启动后端服务（简化版）
echo "1. 启动后端服务..."
cd backend/ruoyi/ruoyi-admin

# 检查是否已编译
if [ ! -f "target/ruoyi-admin.jar" ]; then
    echo "编译后端项目..."
    mvn clean package -DskipTests
fi

# 启动服务
echo "启动Spring Boot应用..."
nohup java -jar target/ruoyi-admin.jar > backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../../backend.pid

echo "等待后端启动..."
sleep 30

# 检查启动状态
if curl -s http://localhost:8080 > /dev/null; then
    echo "✅ 后端服务启动成功！"
    echo "🔗 访问地址: http://localhost:8080"
else
    echo "❌ 后端服务启动较慢，请查看日志: backend/ruoyi/ruoyi-admin/backend.log"
fi

cd ../../..

echo ""
echo "2. 启动前端服务..."
cd frontend/project-management-frontend

# 检查依赖
if [ ! -d "node_modules" ]; then
    echo "安装前端依赖..."
    npm install --silent
fi

# 启动服务
echo "启动Vue开发服务器..."
nohup npm run serve > frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../frontend.pid

echo "等待前端启动..."
sleep 20

# 检查启动状态
if curl -s http://localhost:8081 > /dev/null; then
    echo "✅ 前端服务启动成功！"
    echo "🔗 访问地址: http://localhost:8081"
else
    echo "❌ 前端服务启动较慢，请查看日志: frontend/project-management-frontend/frontend.log"
fi

cd ../..

echo ""
echo "🎉 测试环境启动完成！"
echo "📊 服务状态："
echo "- 后端: http://localhost:8080 (PID: $BACKEND_PID)"
echo "- 前端: http://localhost:8081 (PID: $FRONTEND_PID)"
echo ""
echo "👤 测试账号："
echo "- 管理员: admin / admin123"
echo "- 项目经理: manager1 / password123"
echo "- 开发人员: dev1 / password123"
echo ""
echo "🧪 立即开始测试："
echo "1. 访问: http://localhost:8081"
echo "2. 使用测试账号登录"
echo "3. 执行功能测试"
