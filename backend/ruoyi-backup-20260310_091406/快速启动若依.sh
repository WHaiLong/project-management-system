#!/bin/bash
echo "🚀 快速启动若依框架"
echo "时间: $(date)"
echo ""

# 检查Java
echo "1. 检查Java环境..."
if command -v java &> /dev/null; then
    java -version
else
    echo "❌ Java未安装"
    exit 1
fi

# 检查Maven
echo "2. 检查Maven环境..."
if command -v mvn &> /dev/null; then
    echo "Maven版本:"
    mvn --version | head -1
else
    echo "⚠️ Maven未安装，尝试使用mvnw"
    if [ -f "mvnw" ]; then
        chmod +x mvnw
    else
        echo "❌ mvnw也不存在"
        exit 1
    fi
fi

# 编译
echo "3. 编译项目..."
if command -v mvn &> /dev/null; then
    mvn clean compile -DskipTests
else
    ./mvnw clean compile -DskipTests
fi

# 启动
echo "4. 启动若依框架..."
echo "访问地址: http://localhost:8080"
echo "默认账号: admin/admin123"
echo ""
echo "启动日志: ruoyi-start.log"

if command -v mvn &> /dev/null; then
    nohup mvn spring-boot:run > ruoyi-start.log 2>&1 &
else
    nohup ./mvnw spring-boot:run > ruoyi-start.log 2>&1 &
fi

echo "✅ 若依框架启动中..."
echo "查看日志: tail -f ruoyi-start.log"
echo "停止服务: pkill -f spring-boot"
