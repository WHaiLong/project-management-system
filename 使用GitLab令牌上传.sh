#!/bin/bash
echo "🔑 使用GitLab访问令牌上传代码"
echo "时间: $(date)"
echo ""

echo "=== 步骤1：设置GitLab令牌 ==="
echo "请将您的GitLab访问令牌设置为环境变量："
echo "export GITLAB_TOKEN=\"glpat-xxxxxxxxxxxxxxxxxxxx\""
echo ""
echo "或直接替换下面的TOKEN变量"
echo ""

TOKEN="${GITLAB_TOKEN:-glpat-xxxxxxxxxxxxxxxxxxxx}"
if [ "$TOKEN" = "glpat-xxxxxxxxxxxxxxxxxxxx" ]; then
    echo "⚠️ 警告：使用默认令牌占位符，请替换为实际令牌"
    echo "请编辑本脚本，将TOKEN变量替换为您的实际令牌"
    exit 1
fi

echo "=== 步骤2：更新GitLab远程URL ==="
GITLAB_URL="https://oauth2:${TOKEN}@gitlab.cihon.cn/whl_openclaw/project-management-system.git"
echo "GitLab URL: $GITLAB_URL"

git remote set-url gitlab "$GITLAB_URL"
if [ $? -eq 0 ]; then
    echo "✅ GitLab远程URL更新成功"
else
    echo "❌ GitLab远程URL更新失败"
    exit 1
fi
echo ""

echo "=== 步骤3：测试GitLab连接 ==="
echo "测试连接..."
git ls-remote gitlab --heads 2>&1 | head -5
if [ $? -eq 0 ]; then
    echo "✅ GitLab连接测试成功"
else
    echo "❌ GitLab连接测试失败"
    exit 1
fi
echo ""

echo "=== 步骤4：推送代码到GitLab ==="
echo "推送main分支..."
git push gitlab main --force
if [ $? -eq 0 ]; then
    echo "✅ main分支推送成功"
else
    echo "❌ main分支推送失败"
    exit 1
fi
echo ""

echo "=== 步骤5：验证上传结果 ==="
github_hash=$(git log -1 --format="%H")
gitlab_hash=$(git ls-remote gitlab main 2>/dev/null | awk '{print $1}')

echo "GitHub最新提交: $github_hash"
echo "GitLab最新提交: $gitlab_hash"
echo ""

if [ -n "$gitlab_hash" ]; then
    if [ "$github_hash" = "$gitlab_hash" ]; then
        echo "🎉 代码同步成功！GitHub和GitLab代码一致"
    else
        echo "⚠️ 代码不一致，需要进一步同步"
    fi
else
    echo "❌ 无法获取GitLab提交信息"
fi
echo ""

echo "=== 步骤6：安全建议 ==="
echo "上传完成后，建议："
echo "1. 清除环境变量: unset GITLAB_TOKEN"
echo "2. 或更新GitLab远程URL为不含令牌的版本"
echo "3. 监控GitLab访问日志"
echo "4. 定期更换访问令牌"
echo ""

echo "🎯 上传完成！"
