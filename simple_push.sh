#!/bin/bash
echo "开始推送到码云..."
echo "仓库：https://gitee.com/WHaiLong/project-management-system.git"
echo "分支：main"
echo "方式：强制推送"
echo ""
echo "请确保已准备好以下凭据："
echo "用户名：18419360859@163.com"
echo "密码：28465@Whl"
echo ""
read -p "按回车开始推送..." -n 1 -r
echo ""
echo "执行推送命令..."
git push https://gitee.com/WHaiLong/project-management-system.git main --force
