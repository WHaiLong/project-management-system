#!/bin/bash
echo "🔑 提取新的SSH公钥（hailong.wang@cihon.cn）"
echo "时间: $(date)"
echo "GitLab账号: hailong.wang@cihon.cn"
echo ""

echo "=== SSH公钥信息 ==="
echo ""
echo "🔐 公钥指纹:"
ssh-keygen -lf ~/.ssh/id_rsa_gitlab_cihon.pub
echo ""

echo "📋 公钥内容（请复制到GitLab SSH Keys）:"
echo "================================================"
cat ~/.ssh/id_rsa_gitlab_cihon.pub
echo "================================================"
echo ""

echo "🎨 密钥随机艺术:"
ssh-keygen -lvf ~/.ssh/id_rsa_gitlab_cihon.pub 2>/dev/null | tail -10
echo ""

echo "📁 文件位置:"
echo "- 公钥文件: ~/.ssh/id_rsa_gitlab_cihon.pub"
echo "- 私钥文件: ~/.ssh/id_rsa_gitlab_cihon"
echo ""

echo "🚀 添加公钥到GitLab的步骤:"
echo "1. 登录 GitLab: https://gitlab.cihon.cn"
echo "2. 使用账号: hailong.wang@cihon.cn"
echo "3. 点击右上角头像 → Settings"
echo "4. 左侧菜单选择 SSH Keys"
echo "5. 点击 'Add new key'"
echo "6. 粘贴上面的公钥内容"
echo "7. 设置标题: hailong_wang_project_management"
echo "8. 点击 'Add key'"
echo ""

echo "🔧 测试连接命令:"
echo "ssh -T git@gitlab.cihon.cn"
echo ""

echo "✅ 新公钥提取完成，请使用新账号添加到GitLab。"
