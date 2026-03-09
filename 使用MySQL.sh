#!/bin/bash
# MySQL快速使用脚本

# 设置MySQL路径
MYSQL_PATH="/usr/local/mysql-8.0.45-macos15-x86_64/bin/mysql"

if [ ! -f "$MYSQL_PATH" ]; then
    echo "❌ MySQL未找到: $MYSQL_PATH"
    echo "查找其他位置..."
    find /usr/local -name "mysql" -type f 2>/dev/null | head -5
    exit 1
fi

# 添加到当前会话PATH
export PATH="/usr/local/mysql-8.0.45-macos15-x86_64/bin:$PATH"
echo "✅ MySQL已添加到PATH"

# 测试连接
echo "测试MySQL连接..."
"$MYSQL_PATH" -u root -p'28465@Whl' -e "SELECT '✅ MySQL连接成功' AS status, VERSION() AS version;" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 MySQL连接成功！"
    echo "现在可以使用 'mysql' 命令了"
    echo ""
    echo "常用命令:"
    echo "  mysql -u root -p'28465@Whl' -e \"SHOW DATABASES;\""
    echo "  mysql -u root -p'28465@Whl' project_management -e \"SHOW TABLES;\""
    echo "  mysql -u root -p  # 交互式命令行"
else
    echo ""
    echo "❌ MySQL连接失败"
    echo "请检查密码或服务状态"
fi
