#!/bin/bash
echo "🚨 紧急令牌上传脚本"
echo "时间: $(date)"
echo "项目: project-management-system"
echo "GitLab: gitlab.cihon.cn"
echo ""

# 检查参数
if [ $# -eq 0 ]; then
    echo "❌ 错误：需要提供GitLab访问令牌"
    echo ""
    echo "使用方法: $0 <GitLab访问令牌>"
    echo ""
    echo "示例: $0 glpat-xxxxxxxxxxxxxxxxxxxx"
    echo ""
    echo "获取令牌步骤:"
    echo "1. 登录 https://gitlab.cihon.cn"
    echo "2. 头像 → Edit profile → Access Tokens"
    echo "3. 创建新令牌，勾选 api, read_repository, write_repository"
    echo "4. 复制令牌（只显示一次）"
    echo ""
    exit 1
fi

TOKEN="$1"
echo "使用的令牌: ${TOKEN:0:10}..."  # 只显示前10位
echo ""

# 验证令牌格式
if [[ ! "$TOKEN" =~ ^glpat-[a-zA-Z0-9]{20,}$ ]]; then
    echo "⚠️ 警告：令牌格式可能不正确"
    echo "预期格式: glpat-xxxxxxxxxxxxxxxxxxxx"
    read -p "是否继续？(y/n): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "=== 步骤1：设置GitLab远程URL ==="
GITLAB_URL="https://oauth2:${TOKEN}@gitlab.cihon.cn/whl_openclaw/project-management-system.git"
echo "设置URL: https://oauth2:${TOKEN:0:10}...@gitlab.cihon.cn/whl_openclaw/project-management-system.git"

git remote set-url gitlab "$GITLAB_URL"
if [ $? -eq 0 ]; then
    echo "✅ GitLab远程URL设置成功"
else
    echo "❌ GitLab远程URL设置失败"
    exit 1
fi
echo ""

echo "=== 步骤2：测试GitLab连接 ==="
echo "测试连接..."
CONNECT_TEST=$(git ls-remote gitlab --heads 2>&1)
echo "$CONNECT_TEST" | head -5

if echo "$CONNECT_TEST" | grep -q "refs/heads/"; then
    echo "✅ GitLab连接测试成功"
elif echo "$CONNECT_TEST" | grep -q "Authentication failed"; then
    echo "❌ GitLab认证失败"
    echo "可能原因：令牌无效、权限不足、项目不存在"
    exit 1
elif echo "$CONNECT_TEST" | grep -q "unable to access"; then
    echo "❌ GitLab访问失败"
    echo "可能原因：网络问题、服务器问题"
    exit 1
else
    echo "⚠️ 未知响应，继续尝试"
fi
echo ""

echo "=== 步骤3：推送代码到GitLab ==="
echo "推送main分支..."
PUSH_OUTPUT=$(git push gitlab main --force 2>&1)
echo "$PUSH_OUTPUT" | tail -10

if echo "$PUSH_OUTPUT" | grep -q "To https://gitlab.cihon.cn"; then
    echo "✅ main分支推送完成"
else
    echo "❌ main分支推送可能失败"
    echo "尝试强制推送所有分支..."
    git push gitlab --all --force 2>&1 | tail -5
fi
echo ""

echo "=== 步骤4：验证上传结果 ==="
GITHUB_HASH=$(git log -1 --format="%H")
GITLAB_HASH=$(git ls-remote gitlab main 2>/dev/null | awk '{print $1}')

echo "GitHub最新提交: $GITHUB_HASH"
if [ -n "$GITLAB_HASH" ]; then
    echo "GitLab最新提交: $GITLAB_HASH"
    
    if [ "$GITHUB_HASH" = "$GITLAB_HASH" ]; then
        echo "🎉 代码同步成功！GitHub和GitLab代码一致"
    else
        echo "⚠️ 代码不一致"
        echo "GitHub: $GITHUB_HASH"
        echo "GitLab: $GITLAB_HASH"
    fi
else
    echo "❌ 无法获取GitLab提交信息"
fi
echo ""

echo "=== 步骤5：安全建议 ==="
echo "⚠️ 紧急情况安全提醒："
echo "1. 此令牌应在7天内更换或撤销"
echo "2. 不要将令牌保存在脚本或配置文件中"
echo "3. 上传完成后考虑撤销此令牌"
echo "4. 后续应建立更安全的认证方式"
echo ""

echo "🎯 紧急上传执行完成！"
echo "请登录GitLab Web界面验证文件完整性。"
