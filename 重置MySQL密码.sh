#!/bin/bash
# MySQL root密码重置脚本
# 目标密码：28465@Whl

echo "🔐 MySQL root密码重置"
echo "目标密码：28465@Whl"
echo ""

# 设置PATH
export PATH="/usr/local/mysql-8.0.45-macos15-x86_64/bin:$PATH"

# 1. 停止MySQL服务
echo "1. 停止MySQL服务..."
sudo /usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server stop 2>/dev/null
sleep 2

# 检查是否停止
if ps aux | grep -i mysqld | grep -v grep > /dev/null; then
    echo "❌ MySQL服务停止失败，强制停止..."
    sudo pkill -9 mysqld
    sleep 2
fi

# 2. 启动安全模式
echo "2. 启动安全模式（跳过权限检查）..."
sudo /usr/local/mysql-8.0.45-macos15-x86_64/bin/mysqld_safe --skip-grant-tables --skip-networking &
echo "等待MySQL启动..."
sleep 5

# 3. 重置密码
echo "3. 重置root密码..."
cat > /tmp/reset_password.sql << 'SQL_SCRIPT'
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '28465@Whl';
FLUSH PRIVILEGES;
SQL_SCRIPT

/usr/local/mysql-8.0.45-macos15-x86_64/bin/mysql -u root < /tmp/reset_password.sql 2>/dev/null

# 4. 停止安全模式
echo "4. 停止安全模式..."
sudo pkill -9 mysqld_safe
sudo pkill -9 mysqld
sleep 2

# 5. 正常启动MySQL
echo "5. 正常启动MySQL..."
sudo /usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server start
sleep 3

# 6. 测试新密码
echo "6. 测试新密码..."
mysql -u root -p'28465@Whl' -e "SELECT '✅ 密码重置成功' AS status, VERSION() AS version;" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 MySQL root密码重置成功！"
    echo "新密码：28465@Whl"
    echo ""
    echo "现在可以创建项目数据库："
    mysql -u root -p'28465@Whl' -e "CREATE DATABASE IF NOT EXISTS project_management; SHOW DATABASES LIKE 'project_management';"
else
    echo ""
    echo "❌ 密码重置失败"
    echo "可能需要手动重置"
fi

# 清理
rm -f /tmp/reset_password.sql
