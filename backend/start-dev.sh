#!/bin/bash
# 后端开发启动脚本

echo "🚀 启动项目管理系统后端开发环境"
echo "时间: $(date)"
echo ""

# 检查Java环境
if ! command -v java &> /dev/null; then
    echo "❌ Java未安装，请先安装JDK 11+"
    exit 1
fi
echo "✅ Java版本: $(java -version 2>&1 | head -1)"

# 检查Maven
if ! command -v mvn &> /dev/null; then
    echo "⚠️ Maven未安装，尝试使用mvnw"
    if [ ! -f "mvnw" ]; then
        echo "下载mvnw..."
        curl -s https://repo.maven.apache.org/maven2/io/takari/maven-wrapper/0.5.6/maven-wrapper-0.5.6.jar -o .mvn/wrapper/maven-wrapper.jar
    fi
    chmod +x mvnw
    MVN_CMD="./mvnw"
else
    MVN_CMD="mvn"
    echo "✅ Maven版本: $(mvn -v 2>&1 | head -1)"
fi

# 检查MySQL
if ! command -v mysql &> /dev/null; then
    echo "⚠️ MySQL客户端未安装，数据库操作可能受限"
else
    echo "✅ MySQL客户端已安装"
fi

# 检查Redis
if ! command -v redis-cli &> /dev/null; then
    echo "⚠️ Redis客户端未安装，缓存操作可能受限"
else
    echo "✅ Redis客户端已安装"
fi

echo ""
echo "📦 项目信息"
echo "- 项目名称: 项目管理系统后端"
echo "- 技术栈: Spring Boot + 若依框架"
echo "- 数据库: MySQL 8.0"
echo "- 缓存: Redis 6.0"
echo "- 端口: 8080"

echo ""
echo "🔧 可用命令:"
echo "1. 编译项目: $MVN_CMD clean compile"
echo "2. 运行测试: $MVN_CMD test"
echo "3. 打包项目: $MVN_CMD package"
echo "4. 运行项目: $MVN_CMD spring-boot:run"
echo "5. 检查依赖: $MVN_CMD dependency:tree"

echo ""
echo "📚 开发文档:"
echo "- 需求文档: 飞书链接"
echo "- 技术方案: 飞书链接"
echo "- API文档: 启动后访问 http://localhost:8080/swagger-ui.html"
echo "- 数据库设计: docs/database-design.md"

echo ""
echo "🎯 开始开发吧！"
echo "建议第一步: $MVN_CMD clean compile"
