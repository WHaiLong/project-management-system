#!/bin/bash
echo "🚀 快速安装Vue开发环境"
echo ""

# 安装vue-cli-service（开发依赖）
echo "1. 安装@vue/cli-service..."
npm install @vue/cli-service@5.0.8 --save-dev --no-fund --no-audit --loglevel error

# 安装vue和vue-template-compiler
echo "2. 安装vue和vue-template-compiler..."
npm install vue@2.6.14 vue-template-compiler@2.6.14 --no-fund --no-audit --loglevel error

# 安装核心运行时依赖
echo "3. 安装核心运行时依赖..."
npm install vue-router@3.5.3 vuex@3.6.2 element-ui@2.15.14 axios@0.27.2 --no-fund --no-audit --loglevel error

echo ""
echo "✅ 核心依赖安装完成"
echo "检查安装结果..."
ls node_modules/.bin/vue-cli-service 2>/dev/null && echo "✅ vue-cli-service已安装" || echo "❌ vue-cli-service安装失败"
