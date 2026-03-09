#!/bin/bash
echo "🔍 验证GitLab代码上传"
echo "时间: $(date)"
echo ""

echo "=== 步骤1：检查GitLab连接 ==="
echo "测试SSH连接..."
ssh -T git@gitlab.cihon.cn 2>&1 | head -3
echo ""

echo "=== 步骤2：检查GitLab分支 ==="
echo "GitLab分支列表:"
git ls-remote gitlab --heads 2>&1 | head -10
echo ""

echo "=== 步骤3：比较最新提交 ==="
github_hash=$(git log -1 --format="%H")
gitlab_hash=$(git ls-remote gitlab main 2>/dev/null | awk '{print $1}')

echo "GitHub最新提交: $github_hash"
echo "GitLab最新提交: $gitlab_hash"
echo ""

if [ "$github_hash" = "$gitlab_hash" ]; then
    echo "✅ 提交一致：代码同步成功"
else
    echo "⚠️ 提交不一致：需要进一步验证"
fi
echo ""

echo "=== 步骤4：检查文件数量 ==="
echo "本地文件统计:"
local_files=$(find . -type f \( -name "*.java" -o -name "*.vue" -o -name "*.js" -o -name "*.md" -o -name "*.sh" -o -name "*.yml" -o -name "*.yaml" -o -name "*.xml" \) 2>/dev/null | wc -l)
echo "本地文件数: $local_files"
echo ""

echo "=== 步骤5：验证建议 ==="
echo "1. 登录GitLab Web界面查看项目"
echo "2. 检查文件列表是否完整"
echo "3. 查看提交历史是否正确"
echo "4. 尝试克隆项目测试"
echo ""

echo "🎯 验证完成"
echo "如果所有检查通过，代码上传成功！"
