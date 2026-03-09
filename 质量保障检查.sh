#!/bin/bash
# 质量保障检查脚本

echo "🧪 质量保障检查"
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. 代码质量检查
echo "=== 代码质量检查 ==="
echo "1. 检查Java代码规范..."
if [ -d "backend" ]; then
    JAVA_FILES=$(find backend -name "*.java" | wc -l)
    echo "Java文件数量: $JAVA_FILES"
    
    # 检查是否有编译错误
    echo "检查编译..."
    cd backend/ruoyi && mvn compile -q 2>&1 | tail -5
    cd ../..
else
    echo "⚠️ 后端目录不存在"
fi
echo ""

# 2. 数据库检查
echo "=== 数据库检查 ==="
echo "检查数据库连接和表结构..."
mysql -u root -p'28465@whl' project_management -e "
SELECT '数据库状态' AS check_item, '正常' AS status
UNION ALL
SELECT '表数量' AS check_item, COUNT(*) AS status FROM information_schema.tables WHERE table_schema = 'project_management'
UNION ALL
SELECT '核心表检查' AS check_item, 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'project_management' AND table_name = 'pm_project') THEN '✅ 项目表存在'
        ELSE '❌ 项目表缺失'
    END AS status
UNION ALL
SELECT '数据完整性' AS check_item,
    CASE
        WHEN (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'project_management') > 0 THEN '✅ 有表结构'
        ELSE '❌ 无表结构'
    END AS status;
" 2>/dev/null || echo "❌ 数据库连接失败"
echo ""

# 3. 测试检查
echo "=== 测试检查 ==="
echo "检查测试用例..."
if [ -d "tests" ]; then
    TEST_FILES=$(find tests -name "*.java" -o -name "*.js" -o -name "*.py" | wc -l)
    echo "测试文件数量: $TEST_FILES"
    
    if [ -f "测试用例-详细版.xlsx.md" ]; then
        echo "✅ 测试用例文档存在"
    else
        echo "⚠️ 测试用例文档缺失"
    fi
else
    echo "⚠️ 测试目录不存在"
fi
echo ""

# 4. 文档检查
echo "=== 文档检查 ==="
echo "检查项目文档..."
DOC_FILES=$(find . -name "*.md" -o -name "*.txt" -o -name "*.docx" | grep -v node_modules | wc -l)
echo "文档文件数量: $DOC_FILES"

REQUIRED_DOCS=("README.md" "继续开发计划.md" "项目研发计划表.md" "团队分工.md")
for doc in "${REQUIRED_DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo "✅ $doc 存在"
    else
        echo "❌ $doc 缺失"
    fi
done
echo ""

# 5. 构建检查
echo "=== 构建检查 ==="
echo "检查项目构建..."
if [ -f "backend/ruoyi/pom.xml" ]; then
    echo "✅ Maven项目配置存在"
    echo "检查依赖..."
    grep -c "<dependency>" backend/ruoyi/pom.xml | xargs echo "依赖数量: "
else
    echo "❌ Maven配置缺失"
fi
echo ""

echo "📊 质量检查完成"
echo "建议: 根据检查结果立即修复问题"
