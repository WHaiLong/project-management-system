#!/bin/bash
# 项目开发启动脚本

echo "🚀 启动项目开发"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. 启动MySQL
echo "=== 启动MySQL ==="
if ! mysqladmin -u root -p'28465@whl' ping &> /dev/null; then
    echo "启动MySQL服务..."
    # macOS
    if [ -f "/usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server" ]; then
        sudo /usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server start
    fi
    sleep 3
fi

mysql -u root -p'28465@whl' -e "SELECT '✅ MySQL运行正常' AS status, VERSION() AS version;" 2>/dev/null || {
    echo "❌ MySQL启动失败"
    exit 1
}
echo ""

# 2. 初始化数据库
echo "=== 初始化数据库 ==="
if [ -f "scripts/init-mysql-database.sh" ]; then
    ./scripts/init-mysql-database.sh
else
    echo "⚠️ 初始化脚本不存在，跳过"
fi
echo ""

# 3. 启动后端服务
echo "=== 启动后端服务 ==="
echo "RuoYi后端启动..."
echo "请在新终端执行:"
echo ""
echo "cd backend/ruoyi/ruoyi-admin"
echo "mvn spring-boot:run"
echo ""
echo "或者使用Docker启动:"
echo "docker-compose up -d"
echo ""

# 4. 启动前端服务
echo "=== 启动前端服务 ==="
if [ -d "frontend/project-management-frontend" ]; then
    echo "Vue前端项目存在"
    echo "请在新终端执行:"
    echo ""
    echo "cd frontend/project-management-frontend"
    echo "npm install"
    echo "npm run serve"
else
    echo "⚠️ 前端项目目录不存在"
fi
echo ""

# 5. 启动监控
echo "=== 启动开发监控 ==="
echo "1. 后端监控: http://localhost:8080 (admin/admin123)"
echo "2. 前端监控: http://localhost:8081 (如果启动)"
echo "3. 数据库监控: mysql -u root -p'28465@whl'"
echo "4. 日志监控: tail -f backend/ruoyi/ruoyi-admin/logs/*.log"
echo ""

echo "🎯 开发环境准备完成！"
echo "按照 继续开发计划.md 开始开发工作"
