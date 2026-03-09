#!/bin/bash
# MySQL连接测试脚本

echo "🔍 测试MySQL数据库连接"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 测试root连接
echo "=== 测试root用户连接 ==="
ROOT_TEST=$(mysql -u root -p'28465@Whl' -e "SELECT '✅ Root连接成功' AS status, VERSION() AS mysql_version;" 2>&1)
if [ $? -eq 0 ]; then
    echo "$ROOT_TEST"
    echo "✅ Root用户连接测试通过"
else
    echo "❌ Root用户连接失败"
    echo "错误信息: $ROOT_TEST"
fi
echo ""

# 测试数据库存在
echo "=== 测试数据库存在 ==="
DB_TEST=$(mysql -u root -p'28465@Whl' -e "SHOW DATABASES LIKE 'project_management';" 2>&1)
if echo "$DB_TEST" | grep -q "project_management"; then
    echo "✅ 数据库 project_management 存在"
    
    # 测试数据库连接
    echo "测试连接 project_management 数据库..."
    mysql -u root -p'28465@Whl' project_management -e "SELECT '✅ 数据库连接成功' AS status;" 2>&1
    if [ $? -eq 0 ]; then
        echo "✅ 数据库连接测试通过"
    fi
else
    echo "❌ 数据库 project_management 不存在"
    echo "请先运行: ./scripts/init-mysql-database.sh"
fi
echo ""

# 测试pm_user连接（如果存在）
echo "=== 测试pm_user连接 ==="
PM_USER_TEST=$(mysql -u pm_user -p'Pm@2026whl' -e "SELECT '✅ pm_user连接成功' AS status;" 2>&1)
if [ $? -eq 0 ]; then
    echo "$PM_USER_TEST"
    echo "✅ pm_user连接测试通过"
else
    echo "⚠️ pm_user连接测试失败或用户不存在"
fi
echo ""

echo "📊 测试完成"
echo "建议: 如果所有测试通过，项目可以正常使用MySQL数据库"
