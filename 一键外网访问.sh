#!/bin/bash
echo "🚀 项目管理系统 - 一键外网访问配置"
echo "时间: $(date)"
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== 步骤1：检查本地服务 ===${NC}"

# 检查后端服务
if curl -s http://localhost:8080 > /dev/null; then
    echo -e "${GREEN}✅ 后端服务运行正常 (http://localhost:8080)${NC}"
else
    echo -e "${RED}❌ 后端服务未运行${NC}"
    echo "启动后端服务: cd backend && mvn spring-boot:run"
fi

# 检查前端服务
if curl -s http://localhost:8081 > /dev/null; then
    echo -e "${GREEN}✅ 前端服务运行正常 (http://localhost:8081)${NC}"
else
    echo -e "${RED}❌ 前端服务未运行${NC}"
    echo "启动前端服务: cd frontend/project-management-frontend && npm run serve"
fi

echo ""
echo -e "${BLUE}=== 步骤2：配置外网访问 ===${NC}"

echo "请选择外网访问方案："
echo "1. 使用ngrok（最简单，需要安装ngrok）"
echo "2. 使用云服务器（最稳定，需要购买服务器）"
echo "3. 使用frp内网穿透（免费，需要公网服务器）"
echo "4. 使用ZeroTier虚拟局域网（免费，适合团队内部）"
echo ""
read -p "请选择方案 (1-4): " choice

case $choice in
    1)
        echo "执行ngrok方案..."
        if command -v ngrok &> /dev/null; then
            echo "启动ngrok隧道..."
            ngrok http 8081  # 前端
            ngrok http 8080  # 后端
        else
            echo "ngrok未安装，请先安装：https://ngrok.com/download"
        fi
        ;;
    2)
        echo "执行云服务器方案..."
        echo "1. 购买云服务器（推荐阿里云/腾讯云）"
        echo "2. 上传项目到服务器"
        echo "3. 运行部署脚本: ./一键部署外网.sh"
        echo "4. 配置域名和SSL证书"
        ;;
    3)
        echo "执行frp方案..."
        echo "1. 准备一台有公网IP的服务器"
        echo "2. 在服务器安装frp服务端"
        echo "3. 在本地安装frp客户端"
        echo "4. 配置端口映射"
        ;;
    4)
        echo "执行ZeroTier方案..."
        echo "1. 注册ZeroTier账号：https://www.zerotier.com"
        echo "2. 创建虚拟网络"
        echo "3. 在每台设备安装ZeroTier客户端"
        echo "4. 加入虚拟网络"
        ;;
    *)
        echo "无效选择"
        ;;
esac

echo ""
echo -e "${BLUE}=== 步骤3：访问信息 ===${NC}"
echo -e "${GREEN}🎉 配置完成！${NC}"
echo ""
echo "📱 本地访问地址："
echo "1. 前端界面: http://localhost:8081"
echo "2. 后端管理: http://localhost:8080"
echo "3. 访问页面: http://localhost:8083/外网访问页面.html"
echo ""
echo "👤 管理员账号："
echo "- 用户名: admin"
echo "- 密码: admin123"
echo ""
echo "🔧 管理命令："
echo "查看服务状态: ps aux | grep -E '(java|node|python)'"
echo "停止所有服务: pkill -f 'spring-boot:run' && pkill -f 'npm run serve' && pkill -f 'http.server'"
echo ""
echo -e "${YELLOW}⚠️ 注意：外网访问需要配置端口转发或使用内网穿透工具${NC}"
