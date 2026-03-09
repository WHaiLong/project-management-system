#!/bin/bash
echo "🔍 验证GitLab HTTPS上传结果"
echo "时间: $(date)"
echo "方案: HTTPS+密码"
echo "账号: hailong.wang@cihon.cn"
echo ""

echo "=== 步骤1：检查GitLab连接 ==="
echo "测试GitLab访问..."
git ls-remote gitlab --heads 2>&1 | head -5
echo ""

echo "=== 步骤2：比较提交哈希 ==="
github_hash=$(git log -1 --format="%H")
gitlab_hash=$(git ls-remote gitlab main 2>/dev/null | awk '{print $1}')

echo "GitHub最新提交: $github_hash"
echo "GitLab最新提交: $gitlab_hash"
echo ""

if [ -n "$gitlab_hash" ]; then
    if [ "$github_hash" = "$gitlab_hash" ]; then
        echo "✅ 提交一致：代码同步成功"
    else
        echo "⚠️ 提交不一致：需要进一步验证"
    fi
else
    echo "❌ 无法获取GitLab提交信息"
fi
echo ""

echo "=== 步骤3：验证建议 ==="
echo "1. 登录GitLab Web界面: https://gitlab.cihon.cn"
echo "2. 使用账号: hailong.wang@cihon.cn"
echo "3. 密码: 28465@Chwx"
echo "4. 检查项目: whl_openclaw/project-management-system"
echo "5. 验证文件列表和提交历史"
echo ""

echo "=== 步骤4：安全建议 ==="
echo "⚠️ 安全提醒："
echo "1. Git URL中包含密码，建议后续更改"
echo "2. 考虑改用SSH公钥认证"
echo "3. 或使用GitLab访问令牌"
echo "4. 监控GitLab访问日志"
echo ""

echo "🎯 验证完成"
