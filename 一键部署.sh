#!/bin/bash
echo "🚀 项目管理系统 - 一键部署脚本"
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
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker已安装: $(docker --version)${NC}"
else
    echo -e "${RED}❌ Docker未安装${NC}"
    echo "请安装Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查Docker Compose
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✅ Docker Compose已安装: $(docker-compose --version)${NC}"
else
    echo -e "${YELLOW}⚠️ Docker Compose未安装，使用docker compose命令${NC}"
fi

# 检查端口占用
echo "检查端口占用..."
for port in 80 8080 8081 3306 6379; do
    if lsof -i :$port > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ 端口 $port 已被占用${NC}"
    else
        echo -e "${GREEN}✅ 端口 $port 可用${NC}"
    fi
done

echo ""
echo -e "${BLUE}=== 步骤2：构建Docker镜像 ===${NC}"

# 构建后端镜像
echo "构建后端镜像..."
cd backend/ruoyi
if docker build -t project-management-backend:latest . 2>&1 | tail -10; then
    echo -e "${GREEN}✅ 后端镜像构建成功${NC}"
else
    echo -e "${RED}❌ 后端镜像构建失败${NC}"
    exit 1
fi
cd ../..

# 构建前端镜像
echo "构建前端镜像..."
cd frontend/project-management-frontend
if docker build -t project-management-frontend:latest . 2>&1 | tail -10; then
    echo -e "${GREEN}✅ 前端镜像构建成功${NC}"
else
    echo -e "${RED}❌ 前端镜像构建失败${NC}"
    exit 1
fi
cd ../..

echo ""
echo -e "${BLUE}=== 步骤3：启动服务 ===${NC}"

# 创建docker-compose配置文件
cat > docker-compose.prod.yml << 'COMPOSE_PROD'
version: '3.8'

services:
  # MySQL数据库
  mysql:
    image: mysql:8.0
    container_name: pm-mysql
    environment:
      MYSQL_ROOT_PASSWORD: root123456
      MYSQL_DATABASE: project_management
      MYSQL_USER: pm_user
      MYSQL_PASSWORD: Pm@123456
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
      - ./创建数据库.sql:/docker-entrypoint-initdb.d/init.sql
    command: --default-authentication-plugin=mysql_native_password
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Redis缓存
  redis:
    image: redis:6-alpine
    container_name: pm-redis
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    restart: unless-stopped

  # 后端服务
  backend:
    image: project-management-backend:latest
    container_name: pm-backend
    depends_on:
      mysql:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/project_management?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=false&serverTimezone=GMT%2B8
      SPRING_DATASOURCE_USERNAME: pm_user
      SPRING_DATASOURCE_PASSWORD: Pm@123456
      SPRING_REDIS_HOST: redis
      SPRING_REDIS_PORT: 6379
    ports:
      - "8080:8080"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080"]
      interval: 30s
      timeout: 10s
      retries: 3

  # 前端服务
  frontend:
    image: project-management-frontend:latest
    container_name: pm-frontend
    depends_on:
      - backend
    ports:
      - "80:80"
    restart: unless-stopped

  # Nginx反向代理（可选）
  nginx:
    image: nginx:alpine
    container_name: pm-nginx
    depends_on:
      - frontend
      - backend
    ports:
      - "8081:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    restart: unless-stopped

  # 监控服务（可选）
  prometheus:
    image: prom/prometheus:latest
    container_name: pm-prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=200h'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: pm-grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    restart: unless-stopped

volumes:
  mysql_data:
  redis_data:
  prometheus_data:
  grafana_data:
COMPOSE_PROD

echo "✅ Docker Compose配置文件创建完成"

# 启动服务
echo "启动所有服务..."
if command -v docker-compose &> /dev/null; then
    docker-compose -f docker-compose.prod.yml up -d
else
    docker compose -f docker-compose.prod.yml up -d
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ 服务启动成功${NC}"
else
    echo -e "${RED}❌ 服务启动失败${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}=== 步骤4：验证服务 ===${NC}"

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
echo "访问地址:"
echo "1. 前端界面: http://localhost:80"
echo "2. 后端管理: http://localhost:8080 (admin/admin123)"
echo "3. 监控面板: http://localhost:3000 (admin/admin)"
echo "4. Prometheus: http://localhost:9090"
echo ""
echo "数据库信息:"
echo "主机: localhost:3306"
echo "数据库: project_management"
echo "用户: pm_user"
echo "密码: Pm@123456"
echo ""
echo "管理命令:"
echo "查看日志: docker-compose -f docker-compose.prod.yml logs"
echo "停止服务: docker-compose -f docker-compose.prod.yml down"
echo "重启服务: docker-compose -f docker-compose.prod.yml restart"
echo ""
echo -e "${YELLOW}⚠️ 注意：首次启动需要等待数据库初始化完成${NC}"
