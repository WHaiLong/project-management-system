#!/bin/bash
# 开发环境检查脚本

echo "🔍 项目管理系统开发环境检查"
echo "检查时间: $(date)"
echo ""

echo "=== 通用环境检查 ==="
echo "1. Git版本: $(git --version 2>/dev/null || echo '未安装')"
echo "2. Docker版本: $(docker --version 2>/dev/null | head -1 || echo '未安装')"
echo "3. Docker Compose版本: $(docker-compose --version 2>/dev/null || echo '未安装')"

echo ""
echo "=== 后端环境检查 ==="
echo "4. Java版本: $(java -version 2>&1 | head -1 | cut -d'"' -f2 2>/dev/null || echo '未安装')"
echo "5. Maven版本: $(mvn -v 2>&1 | head -1 | cut -d' ' -f3 2>/dev/null || echo '未安装')"
echo "6. MySQL客户端: $(mysql --version 2>&1 | head -1 | cut -d' ' -f4 2>/dev/null || echo '未安装')"
echo "7. Redis客户端: $(redis-cli --version 2>&1 | cut -d' ' -f2 2>/dev/null || echo '未安装')"

echo ""
echo "=== 前端环境检查 ==="
echo "8. Node.js版本: $(node --version 2>/dev/null || echo '未安装')"
echo "9. npm版本: $(npm --version 2>/dev/null || echo '未安装')"
echo "10. Vue CLI版本: $(vue --version 2>&1 | head -1 | cut -d' ' -f2 2>/dev/null || echo '未安装')"

echo ""
echo "=== 项目检查 ==="
echo "11. 项目目录: $(pwd)"
echo "12. 代码仓库: $(git config --get remote.origin.url 2>/dev/null || echo '未配置')"
echo "13. 分支: $(git branch --show-current 2>/dev/null || echo '未知')"

echo ""
echo "=== 建议安装 ==="
echo "✅ 已安装环境:"
if command -v java &> /dev/null; then echo "  - Java"; fi
if command -v node &> /dev/null; then echo "  - Node.js"; fi
if command -v git &> /dev/null; then echo "  - Git"; fi
if command -v docker &> /dev/null; then echo "  - Docker"; fi

echo ""
echo "⚠️ 需要安装:"
if ! command -v java &> /dev/null; then echo "  - JDK 11+ (https://adoptium.net)"; fi
if ! command -v mvn &> /dev/null; then echo "  - Maven 3.6+ (https://maven.apache.org)"; fi
if ! command -v node &> /dev/null; then echo "  - Node.js 16+ (https://nodejs.org)"; fi
if ! command -v docker &> /dev/null; then echo "  - Docker (https://docker.com)"; fi

echo ""
echo "🎯 开发准备完成度:"
TOTAL=13
INSTALLED=0
for cmd in git java mvn mysql redis-cli node npm vue docker docker-compose; do
    if command -v $cmd &> /dev/null; then
        INSTALLED=$((INSTALLED + 1))
    fi
done
PERCENTAGE=$((INSTALLED * 100 / TOTAL))
echo "  完成度: ${PERCENTAGE}% (${INSTALLED}/${TOTAL})"

echo ""
echo "📚 快速开始:"
echo "1. 后端开发: cd backend && ./start-dev.sh"
echo "2. 前端开发: cd frontend && ./start-dev.sh"
echo "3. 查看文档: 打开 docs/ 目录"
echo "4. 运行测试: cd tests && ./执行测试.sh"

echo ""
echo "🚀 环境检查完成，开始开发吧！"
