#!/bin/bash
echo "🚀 项目管理系统 - 一键部署外网版本"
echo "时间: $(date)"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 步骤1：检查环境 ===${NC}"

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker未安装${NC}"
    echo "请安装Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

echo -e "${GREEN}✅ Docker已安装: $(docker --version)${NC}"

# 检查Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}⚠️ Docker Compose未安装，使用docker compose命令${NC}"
    DOCKER_COMPOSE_CMD="docker compose"
else
    DOCKER_COMPOSE_CMD="docker-compose"
    echo -e "${GREEN}✅ Docker Compose已安装: $(docker-compose --version)${NC}"
fi

echo ""
echo -e "${BLUE}=== 步骤2：构建镜像 ===${NC}"

# 构建后端镜像
echo "构建后端镜像..."
cd backend
docker build -t project-management-backend:latest .
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 后端镜像构建成功${NC}"
else
    echo -e "${RED}❌ 后端镜像构建失败${NC}"
    exit 1
fi
cd ..

# 构建前端镜像
echo "构建前端镜像..."
cd frontend/project-management-frontend
docker build -t project-management-frontend:latest .
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 前端镜像构建成功${NC}"
else
    echo -e "${RED}❌ 前端镜像构建失败${NC}"
    exit 1
fi
cd ../..

echo ""
echo -e "${BLUE}=== 步骤3：启动服务 ===${NC}"

# 启动所有服务
echo "启动所有服务..."
$DOCKER_COMPOSE_CMD -f docker-compose.prod.yml up -d

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 服务启动成功${NC}"
else
    echo -e "${RED}❌ 服务启动失败${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== 步骤4：等待服务就绪 ===${NC}"

echo "等待服务启动..."
sleep 10

# 检查服务状态
echo "检查服务状态..."
services=("mysql" "redis" "backend" "frontend")
for service in "${services[@]}"; do
    if docker ps | grep -q $service; then
        echo -e "${GREEN}✅ $service 运行中${NC}"
    else
        echo -e "${RED}❌ $service 未运行${NC}"
    fi
done

echo ""
echo -e "${BLUE}=== 步骤5：访问信息 ===${NC}"
echo -e "${GREEN}🎉 部署完成！${NC}"
echo ""
echo "📱 访问地址:"
echo "1. 前端界面: http://localhost:80"
echo "2. 后端管理: http://localhost:8080"
echo "3. MySQL数据库: localhost:3306"
echo "4. Redis缓存: localhost:6379"
echo ""
echo "👤 默认账号:"
echo "- 管理员: admin / admin123"
echo "- 数据库: pm_user / Pm@123456"
echo ""
echo "🔧 管理命令:"
echo "查看日志: $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml logs"
echo "停止服务: $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml down"
echo "重启服务: $DOCKER_COMPOSE_CMD -f docker-compose.prod.yml restart"
echo ""
echo -e "${YELLOW}⚠️ 注意：首次启动需要等待数据库初始化完成（约30秒）${NC}"
echo -e "${YELLOW}⚠️ 外网访问需要配置域名和SSL证书${NC}"
