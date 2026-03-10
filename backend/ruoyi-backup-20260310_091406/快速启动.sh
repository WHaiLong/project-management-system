#!/bin/bash
echo "开始若依框架快速部署..."

# 检查Maven
if command -v mvn &> /dev/null; then
    echo "使用Maven编译..."
    mvn clean compile -DskipTests
else
    echo "使用mvnw..."
    chmod +x mvnw
    ./mvnw clean compile -DskipTests
fi

echo "启动若依框架..."
nohup mvn spring-boot:run > ruoyi.log 2>&1 &
echo "若依框架启动中，日志：ruoyi.log"
echo "访问：http://localhost:8080"
echo "默认账号：admin/admin123"
