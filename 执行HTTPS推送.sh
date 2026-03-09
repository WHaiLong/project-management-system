#!/bin/bash
echo "🔗 执行码云HTTPS推送"
echo "时间: $(date)"
echo "仓库: https://gitee.com/WHaiLong/project-management-system.git"
echo ""
echo "注意：以下命令会提示输入码云账号密码"
echo ""
echo "执行推送命令..."
git push gitee-https main --force
echo ""
echo "推送完成"
