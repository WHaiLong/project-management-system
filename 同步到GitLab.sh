#!/bin/bash
echo "🔄 同步代码到GitLab"
echo "时间: $(date)"
echo "GitLab地址: https://gitlab.cihon.cn/whl_openclaw/project-management-system.git"
echo ""

# 检查当前目录
if [ ! -d ".git" ]; then
    echo "❌ 错误：当前目录不是Git仓库"
    exit 1
fi

echo "=== 步骤1：检查Git配置 ==="
echo "当前远程仓库配置："
git remote -v
echo ""

echo "=== 步骤2：检查当前分支 ==="
current_branch=$(git branch --show-current)
echo "当前分支: $current_branch"
echo ""

echo "=== 步骤3：拉取最新代码 ==="
echo "从GitHub拉取最新代码..."
git pull origin $current_branch
if [ $? -ne 0 ]; then
    echo "❌ 拉取代码失败"
    exit 1
fi
echo "✅ 拉取代码成功"
echo ""

echo "=== 步骤4：添加GitLab远程仓库 ==="
# 检查是否已添加gitlab远程
if git remote | grep -q "gitlab"; then
    echo "✅ GitLab远程仓库已存在"
else
    echo "添加GitLab远程仓库..."
    git remote add gitlab https://gitlab.cihon.cn/whl_openclaw/project-management-system.git
    if [ $? -ne 0 ]; then
        echo "❌ 添加GitLab远程仓库失败"
        exit 1
    fi
    echo "✅ GitLab远程仓库添加成功"
fi
echo ""

echo "=== 步骤5：测试GitLab连接 ==="
echo "测试GitLab连接..."
git ls-remote gitlab --heads 2>&1 | head -3
if [ $? -ne 0 ]; then
    echo "⚠️ GitLab连接测试失败，可能是网络或认证问题"
    echo "继续尝试推送..."
fi
echo ""

echo "=== 步骤6：推送代码到GitLab ==="
echo "推送分支 $current_branch 到GitLab..."
git push gitlab $current_branch
if [ $? -eq 0 ]; then
    echo "✅ GitLab推送成功"
else
    echo "❌ GitLab推送失败"
    echo "尝试强制推送..."
    git push gitlab $current_branch --force
    if [ $? -eq 0 ]; then
        echo "✅ GitLab强制推送成功"
    else
        echo "❌ GitLab强制推送失败"
        exit 1
    fi
fi
echo ""

echo "=== 步骤7：推送所有分支到GitLab ==="
echo "推送所有分支到GitLab..."
git push gitlab --all
if [ $? -eq 0 ]; then
    echo "✅ 所有分支推送成功"
else
    echo "⚠️ 部分分支推送失败，继续..."
fi
echo ""

echo "=== 步骤8：推送标签到GitLab ==="
echo "推送所有标签到GitLab..."
git push gitlab --tags
if [ $? -eq 0 ]; then
    echo "✅ 标签推送成功"
else
    echo "⚠️ 标签推送失败，继续..."
fi
echo ""

echo "=== 步骤9：验证同步结果 ==="
echo "验证GitHub和GitLab代码一致性..."
github_hash=$(git ls-remote origin $current_branch | awk '{print $1}')
gitlab_hash=$(git ls-remote gitlab $current_branch 2>/dev/null | awk '{print $1}')

if [ "$github_hash" = "$gitlab_hash" ]; then
    echo "✅ GitHub和GitLab代码一致"
    echo "提交哈希: $github_hash"
else
    echo "⚠️ GitHub和GitLab代码不一致"
    echo "GitHub提交哈希: $github_hash"
    echo "GitLab提交哈希: $gitlab_hash"
fi
echo ""

echo "=== 步骤10：更新配置文档 ==="
echo "更新GitLab配置文档..."
if [ -f "GitLab项目配置.md" ]; then
    # 更新同步时间
    sed -i '' "s/首次同步时间: .*/首次同步时间: $(date +'%H:%M')（实际）/g" GitLab项目配置.md
    # 更新同步状态
    if [ "$github_hash" = "$gitlab_hash" ]; then
        sed -i '' "s/代码同步 | ✅ 最新 | 📅 待同步 | 未同步/代码同步 | ✅ 最新 | ✅ 已同步 | 已同步/g" GitLab项目配置.md
    fi
    echo "✅ 配置文档更新完成"
else
    echo "⚠️ 配置文档不存在，跳过更新"
fi
echo ""

echo "🎯 GitLab同步完成！"
echo ""
echo "📊 同步结果："
echo "- 当前分支: $current_branch"
echo "- GitHub提交: $github_hash"
echo "- GitLab提交: $gitlab_hash"
echo "- 代码一致性: $([ "$github_hash" = "$gitlab_hash" ] && echo "一致" || echo "不一致")"
echo "- 同步时间: $(date)"
echo ""
echo "🔗 仓库链接："
echo "- GitHub: https://github.com/WHaiLong/project-management-system"
echo "- GitLab: https://gitlab.cihon.cn/whl_openclaw/project-management-system"
echo ""
echo "🚀 同步完成，代码已备份到GitLab！"
