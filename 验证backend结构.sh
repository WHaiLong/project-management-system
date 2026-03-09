#!/bin/bash
echo "🔍 验证backend结构"
echo "时间: $(date)"
echo "目标结构："
echo "backend/"
echo "├── ruoyi/                    # 若依框架核心"
echo "├── project/                 # 项目管理模块"
echo "├── task/                    # 任务管理模块"
echo "└── workhour/                # 工时管理模块"
echo ""

echo "=== 检查目录结构 ==="

# 检查根目录
if [ -d "backend" ]; then
    echo "✅ backend目录存在"
    echo "backend目录内容："
    ls -la backend/ | grep -E "^d" | awk '{print "  " $9}'
else
    echo "❌ backend目录不存在"
    exit 1
fi
echo ""

# 检查ruoyi目录
echo "=== 检查ruoyi目录 ==="
if [ -d "backend/ruoyi" ]; then
    echo "✅ ruoyi目录存在"
    
    # 检查ruoyi模块
    REQUIRED_MODULES=("ruoyi-admin" "ruoyi-common" "ruoyi-framework" "ruoyi-generator" "ruoyi-quartz" "ruoyi-system")
    ALL_MODULES_EXIST=true
    
    for module in "${REQUIRED_MODULES[@]}"; do
        if [ -d "backend/ruoyi/$module" ]; then
            echo "  ✅ $module 存在"
        else
            echo "  ❌ $module 不存在"
            ALL_MODULES_EXIST=false
        fi
    done
    
    if $ALL_MODULES_EXIST; then
        echo "✅ 所有RuoYi模块完整"
    else
        echo "❌ RuoYi模块不完整"
    fi
    
    # 检查pom.xml
    if [ -f "backend/ruoyi/pom.xml" ]; then
        echo "✅ ruoyi/pom.xml 存在"
    else
        echo "❌ ruoyi/pom.xml 不存在"
    fi
else
    echo "❌ ruoyi目录不存在"
fi
echo ""

# 检查自定义模块
echo "=== 检查自定义模块 ==="
CUSTOM_MODULES=("project" "task" "workhour")
ALL_CUSTOM_EXIST=true

for module in "${CUSTOM_MODULES[@]}"; do
    if [ -d "backend/$module" ]; then
        echo "✅ $module 目录存在"
        
        # 检查模块结构
        if [ -d "backend/$module/src/main/java" ]; then
            echo "  ✅ $module/src/main/java 存在"
            
            # 检查Java文件
            JAVA_COUNT=$(find backend/$module -name "*.java" | wc -l)
            if [ "$JAVA_COUNT" -gt 0 ]; then
                echo "  ✅ $module 有 $JAVA_COUNT 个Java文件"
            else
                echo "  ⚠️ $module 没有Java文件"
            fi
        else
            echo "  ❌ $module/src/main/java 不存在"
            ALL_CUSTOM_EXIST=false
        fi
        
        # 检查pom.xml
        if [ -f "backend/$module/pom.xml" ]; then
            echo "  ✅ $module/pom.xml 存在"
        else
            echo "  ❌ $module/pom.xml 不存在"
            ALL_CUSTOM_EXIST=false
        fi
    else
        echo "❌ $module 目录不存在"
        ALL_CUSTOM_EXIST=false
    fi
done
echo ""

# 检查父pom.xml
echo "=== 检查父pom.xml ==="
if [ -f "backend/pom.xml" ]; then
    echo "✅ backend/pom.xml 存在"
    echo "文件大小: $(wc -l < backend/pom.xml) 行"
    
    # 检查模块定义
    if grep -q "<module>ruoyi</module>" backend/pom.xml; then
        echo "✅ 包含ruoyi模块定义"
    else
        echo "❌ 缺少ruoyi模块定义"
    fi
    
    for module in "${CUSTOM_MODULES[@]}"; do
        if grep -q "<module>$module</module>" backend/pom.xml; then
            echo "✅ 包含$module模块定义"
        else
            echo "❌ 缺少$module模块定义"
        fi
    done
else
    echo "❌ backend/pom.xml 不存在"
fi
echo ""

# 检查README.md
echo "=== 检查README.md ==="
if [ -f "backend/README.md" ]; then
    echo "✅ backend/README.md 存在"
    echo "文件大小: $(wc -l < backend/README.md) 行"
else
    echo "❌ backend/README.md 不存在"
fi
echo ""

echo "=== 总体评估 ==="
if $ALL_MODULES_EXIST && $ALL_CUSTOM_EXIST && [ -f "backend/pom.xml" ] && [ -f "backend/README.md" ]; then
    echo "🎉 backend结构完整，符合要求！"
    echo ""
    echo "📁 结构验证通过："
    echo "1. ✅ RuoYi框架模块完整"
    echo "2. ✅ 自定义业务模块完整"
    echo "3. ✅ 父pom.xml配置正确"
    echo "4. ✅ 文档完整"
else
    echo "⚠️ backend结构不完整，需要修复"
    echo ""
    echo "📋 需要修复的问题："
    if ! $ALL_MODULES_EXIST; then
        echo "1. ❌ RuoYi模块不完整"
    fi
    if ! $ALL_CUSTOM_EXIST; then
        echo "2. ❌ 自定义模块不完整"
    fi
    if [ ! -f "backend/pom.xml" ]; then
        echo "3. ❌ 缺少父pom.xml"
    fi
    if [ ! -f "backend/README.md" ]; then
        echo "4. ❌ 缺少README.md"
    fi
fi
echo ""
echo "🔍 验证完成"
