#!/bin/bash
# MySQL数据库初始化脚本
# 时间: 2026-03-10 00:33

echo "🚀 初始化MySQL数据库"
echo "数据库: project_management"
echo "用户: root"
echo ""

# 检查MySQL服务状态
echo "=== 检查MySQL服务状态 ==="
if ! mysqladmin -u root -p'28465@Whl' ping &> /dev/null; then
    echo "❌ MySQL服务未运行"
    echo "请启动MySQL服务:"
    echo "  sudo systemctl start mysql  # Linux"
    echo "  brew services start mysql   # macOS"
    exit 1
fi
echo "✅ MySQL服务运行正常"
echo ""

# 创建数据库
echo "=== 创建数据库 ==="
mysql -u root -p'28465@Whl' -e "CREATE DATABASE IF NOT EXISTS project_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
echo "✅ 数据库创建完成: project_management"
echo ""

# 执行SQL初始化脚本（如果存在）
echo "=== 执行SQL初始化脚本 ==="
if [ -f "sql/init.sql" ]; then
    echo "执行 init.sql..."
    mysql -u root -p'28465@Whl' project_management < sql/init.sql
    echo "✅ SQL初始化完成"
elif [ -f "创建数据库.sql" ]; then
    echo "执行 创建数据库.sql..."
    mysql -u root -p'28465@Whl' project_management < 创建数据库.sql
    echo "✅ SQL初始化完成"
else
    echo "⚠️ 未找到SQL初始化脚本，跳过"
fi
echo ""

# 显示数据库状态
echo "=== 数据库状态 ==="
echo "数据库列表:"
mysql -u root -p'28465@Whl' -e "SHOW DATABASES;"
echo ""

echo "project_management数据库表:"
mysql -u root -p'28465@Whl' project_management -e "SHOW TABLES;" 2>/dev/null || echo "数据库为空"
echo ""

echo "🎉 MySQL数据库初始化完成！"
echo ""
echo "📋 连接信息:"
echo "- 主机: localhost:3306"
echo "- 数据库: project_management"
echo "- 用户: root"
echo "- 密码: 28465@Whl"
echo ""
echo "🔗 项目配置:"
echo "在application.yml中使用以下配置:"
echo "  url: jdbc:mysql://localhost:3306/project_management"
echo "  username: root"
echo "  password: 28465@Whl"
echo "  driver-class-name: com.mysql.cj.jdbc.Driver"
