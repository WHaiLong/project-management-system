#!/bin/bash
echo "简单启动若依框架..."
echo "使用mvnw编译..."
./mvnw clean compile -DskipTests
echo "启动服务..."
./mvnw spring-boot:run
