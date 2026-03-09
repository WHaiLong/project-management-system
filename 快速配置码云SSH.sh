#!/bin/bash
echo "🔧 快速配置码云SSH"
echo "时间: $(date)"
echo ""

echo "=== 步骤1：检查SSH密钥 ==="
if [ -f ~/.ssh/id_rsa_gitee.pub ]; then
    echo "✅ 找到码云专用公钥"
    echo "公钥内容："
    cat ~/.ssh/id_rsa_gitee.pub
    echo ""
    echo "请复制上面的公钥内容"
else
    echo "❌ 未找到码云专用公钥"
    echo "生成新的SSH密钥..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_gitee -C "hailong.wang@cihon.cn" -N ""
    if [ $? -eq 0 ]; then
        echo "✅ 新密钥生成成功"
        cat ~/.ssh/id_rsa_gitee.pub
    fi
fi
echo ""

echo "=== 步骤2：添加到码云 ==="
echo "请执行以下操作："
echo "1. 登录 https://gitee.com"
echo "2. 头像 → 设置 → SSH公钥"
echo "3. 点击 添加公钥"
echo "4. 标题: project-management-system"
echo "5. 公钥: 粘贴上面的公钥内容"
echo "6. 点击 确定"
echo ""

echo "=== 步骤3：测试SSH连接 ==="
read -p "公钥添加完成后按回车测试连接..." -n 1 -r
echo ""
echo "测试SSH连接..."
ssh -T git@gitee.com 2>&1 | head -3
echo ""

echo "=== 步骤4：推送代码 ==="
if ssh -T git@gitee.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH连接成功，立即推送代码..."
    echo ""
    
    echo "配置Git远程..."
    git remote set-url gitee-ssh git@gitee.com:WHaiLong/project-management-system.git
    echo "推送代码..."
    git push gitee-ssh main --force 2>&1 | tail -5
    echo ""
    
    echo "验证推送..."
    LOCAL_HASH=$(git log -1 --format="%H")
    GITEE_HASH=$(git ls-remote gitee-ssh main 2>/dev/null | awk '{print $1}')
    echo "本地: $LOCAL_HASH"
    echo "码云: $GITEE_HASH"
    
    if [ "$LOCAL_HASH" = "$GITEE_HASH" ]; then
        echo "🎉 码云SSH推送成功！"
    else
        echo "⚠️ 代码可能未完全同步"
    fi
else
    echo "❌ SSH连接失败，请检查公钥配置"
    echo "备用方案：使用HTTPS推送"
    echo "执行：./执行HTTPS推送.sh"
fi
echo ""

echo "🔧 脚本执行完成"
