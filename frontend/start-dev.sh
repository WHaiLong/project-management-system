#!/bin/bash
# 前端开发启动脚本

echo "🚀 启动项目管理系统前端开发环境"
echo "时间: $(date)"
echo ""

# 检查Node.js环境
if ! command -v node &> /dev/null; then
    echo "❌ Node.js未安装，请先安装Node.js 16+"
    exit 1
fi
echo "✅ Node.js版本: $(node --version)"

# 检查npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm未安装"
    exit 1
fi
echo "✅ npm版本: $(npm --version)"

# 检查Vue CLI
if ! command -v vue &> /dev/null; then
    echo "⚠️ Vue CLI未安装，正在安装..."
    npm install -g @vue/cli
fi
echo "✅ Vue CLI版本: $(vue --version 2>&1 | head -1)"

echo ""
echo "📦 项目信息"
echo "- 项目名称: 项目管理系统前端"
echo "- 技术栈: Vue.js 2.x + Element UI"
echo "- 开发服务器: webpack-dev-server"
echo "- 端口: 8081"

echo ""
echo "🔧 可用命令:"
echo "1. 安装依赖: npm install"
echo "2. 开发模式: npm run serve"
echo "3. 生产构建: npm run build"
echo "4. 代码检查: npm run lint"
echo "5. 运行测试: npm run test:unit"

echo ""
echo "🎨 设计规范:"
echo "- 主色: #409EFF (若依蓝)"
echo "- 字体: 系统默认字体，14px正文"
echo "- 布局: 响应式设计，支持移动端"
echo "- 组件: 使用Element UI组件库"

echo ""
echo "📚 开发文档:"
echo "- 原型设计: 飞书链接"
echo "- 组件规范: docs/component-guide.md"
echo "- API接口: 后端Swagger文档"
echo "- 设计资源: docs/design-resources.md"

echo ""
echo "🎯 开始开发吧！"
echo "建议第一步: npm install && npm run serve"
