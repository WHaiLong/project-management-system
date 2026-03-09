#!/bin/bash
echo "🚀 快速启动H2后端服务"
echo "时间: $(date)"
echo ""

echo "=== 步骤1：检查后端目录 ==="
if [ -d "backend/ruoyi/ruoyi-admin" ]; then
    echo "✅ 后端目录存在"
    cd backend/ruoyi/ruoyi-admin
else
    echo "❌ 后端目录不存在"
    echo "当前目录: $(pwd)"
    exit 1
fi
echo ""

echo "=== 步骤2：检查Maven ==="
if command -v mvn &> /dev/null; then
    echo "✅ Maven可用"
else
    echo "❌ Maven不可用，尝试其他方式"
    exit 1
fi
echo ""

echo "=== 步骤3：启动H2后端服务 ==="
echo "使用开发配置启动（包含H2数据库）..."
echo "启动命令: mvn spring-boot:run -Dspring.profiles.active=dev"
echo ""
echo "服务将在以下地址可用:"
echo "- 后端API: http://localhost:8080"
echo "- H2控制台: http://localhost:8080/h2-console"
echo "- Swagger文档: http://localhost:8080/swagger-ui.html"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

# 启动服务
mvn spring-boot:run -Dspring.profiles.active=dev
