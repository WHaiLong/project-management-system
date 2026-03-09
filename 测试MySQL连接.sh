#!/bin/bash
# MySQL连接测试脚本

echo "🔐 MySQL连接测试"
echo "密码: 28465@Whl"
echo ""

# 设置PATH
export PATH="/usr/local/mysql-8.0.45-macos15-x86_64/bin:$PATH"

# 测试连接
echo "测试连接..."
mysql -u root -p'28465@Whl' -e "SELECT '✅ MySQL连接成功' AS status, VERSION() AS version;" 2>&1

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 MySQL连接成功！"
    echo ""
    
    # 创建数据库
    echo "创建项目数据库..."
    mysql -u root -p'28465@Whl' -e "CREATE DATABASE IF NOT EXISTS project_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    
    echo "数据库列表:"
    mysql -u root -p'28465@Whl' -e "SHOW DATABASES;" | grep -v "information_schema\|mysql\|performance_schema\|sys"
    
    echo ""
    echo "项目数据库连接测试:"
    mysql -u root -p'28465@Whl' project_management -e "SELECT '✅ 项目数据库连接成功' AS status; SHOW TABLES;" 2>&1
    
    echo ""
    echo "🚀 MySQL配置完成！"
    echo "项目现在可以使用MySQL数据库了"
    
else
    echo ""
    echo "❌ MySQL连接失败"
    echo ""
    echo "可能原因:"
    echo "1. 密码不正确"
    echo "2. MySQL服务未运行"
    echo "3. root用户权限问题"
    echo ""
    echo "🔧 解决方案:"
    echo "1. 检查MySQL服务: ps aux | grep mysql"
    echo "2. 尝试其他密码"
    echo "3. 重置MySQL root密码"
fi
