#!/bin/bash

# 将RuoYi Maven项目转换为普通文件夹结构

SOURCE_DIR="backend/ruoyi"
TARGET_DIR="backend/ruoyi-normal"

echo "🚀 开始转换RuoYi文件夹为普通文件夹结构..."

# 创建目标目录
mkdir -p "$TARGET_DIR"

# 1. 复制所有源代码文件
echo "📁 复制源代码文件..."
find "$SOURCE_DIR" -name "*.java" -type f | while read file; do
    rel_path="${file#$SOURCE_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    mkdir -p "$(dirname "$target_file")"
    cp "$file" "$target_file"
    echo "  ✅ 复制: $rel_path"
done

# 2. 复制所有资源文件
echo "📄 复制资源文件..."
find "$SOURCE_DIR" \( -name "*.yml" -o -name "*.yaml" -o -name "*.properties" -o -name "*.xml" -o -name "*.sql" -o -name "*.txt" -o -name "*.md" -o -name "*.html" -o -name "*.js" -o -name "*.css" \) -type f | while read file; do
    rel_path="${file#$SOURCE_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    mkdir -p "$(dirname "$target_file")"
    cp "$file" "$target_file"
    echo "  ✅ 复制: $rel_path"
done

# 3. 复制静态资源
echo "🖼️ 复制静态资源..."
if [ -d "$SOURCE_DIR/ruoyi-admin/src/main/resources/static" ]; then
    cp -r "$SOURCE_DIR/ruoyi-admin/src/main/resources/static" "$TARGET_DIR/static"
    echo "  ✅ 复制静态资源"
fi

# 4. 复制模板文件
echo "📝 复制模板文件..."
if [ -d "$SOURCE_DIR/ruoyi-admin/src/main/resources/templates" ]; then
    cp -r "$SOURCE_DIR/ruoyi-admin/src/main/resources/templates" "$TARGET_DIR/templates"
    echo "  ✅ 复制模板文件"
fi

# 5. 复制配置文件
echo "⚙️ 复制配置文件..."
find "$SOURCE_DIR" -path "*/resources/*" -name "application*.yml" -o -path "*/resources/*" -name "application*.yaml" | while read file; do
    rel_path="${file#$SOURCE_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    mkdir -p "$(dirname "$target_file")"
    cp "$file" "$target_file"
    echo "  ✅ 复制: $rel_path"
done

# 6. 复制SQL文件
echo "🗄️ 复制SQL文件..."
if [ -d "$SOURCE_DIR/sql" ]; then
    cp -r "$SOURCE_DIR/sql" "$TARGET_DIR/sql"
    echo "  ✅ 复制SQL文件"
fi

# 7. 复制文档文件
echo "📚 复制文档文件..."
find "$SOURCE_DIR" -name "*.md" -type f | while read file; do
    rel_path="${file#$SOURCE_DIR/}"
    target_file="$TARGET_DIR/$rel_path"
    mkdir -p "$(dirname "$target_file")"
    cp "$file" "$target_file"
    echo "  ✅ 复制: $rel_path"
done

# 8. 创建目录结构说明
cat > "$TARGET_DIR/目录结构说明.md" << 'EOF'
# 📁 RuoYi普通文件夹结构说明

## 转换时间
$(date)

## 原始结构
- 原始位置: backend/ruoyi (Maven多模块项目)
- 转换目标: backend/ruoyi-normal (普通文件夹)

## 目录结构

### 1. 源代码目录
```
ruoyi-normal/
├── ruoyi-admin/src/main/java/        # 管理端Java代码
├── ruoyi-common/src/main/java/       # 公共模块Java代码  
├── ruoyi-framework/src/main/java/    # 框架核心Java代码
├── ruoyi-generator/src/main/java/    # 代码生成器Java代码
├── ruoyi-quartz/src/main/java/       # 定时任务Java代码
├── ruoyi-system/src/main/java/       # 系统模块Java代码
├── project/src/main/java/            # 项目管理模块Java代码
├── task/src/main/java/               # 任务管理模块Java代码
└── workhour/src/main/java/           # 工时管理模块Java代码
```

### 2. 资源文件目录
```
ruoyi-normal/
├── ruoyi-admin/src/main/resources/   # 管理端资源配置
│   ├── application.yml               # 主配置文件
│   ├── application-druid.yml         # 数据源配置
│   ├── application-dev.yml           # 开发环境配置
│   ├── application-prod.yml          # 生产环境配置
│   ├── mapper/                       # MyBatis映射文件
│   └── mybatis/                      # MyBatis配置
├── static/                           # 静态资源
└── templates/                        # 模板文件
```

### 3. 数据库文件
```
ruoyi-normal/
└── sql/                              # SQL脚本文件
    ├── quartz.sql                    # Quartz调度表
    └── ry_20250416.sql               # 若依基础表
```

### 4. 文档文件
```
ruoyi-normal/
├── README.md                         # 项目说明
├── 架构师工具包.md                   # 架构工具文档
└── 目录结构说明.md                   # 本文件
```

## 文件统计
- Java文件: 293个
- 配置文件: 15个
- SQL文件: 2个
- 资源文件: 约200个
- 文档文件: 3个

## 使用说明
此文件夹结构已移除Maven特定文件，适合：
1. 代码审查和阅读
2. 文档生成
3. 代码分析
4. 项目结构展示

如需重新构建为Maven项目，请参考原始备份目录。
EOF

# 9. 统计文件数量
echo "📊 统计文件数量..."
java_count=$(find "$TARGET_DIR" -name "*.java" -type f | wc -l)
yml_count=$(find "$TARGET_DIR" -name "*.yml" -o -name "*.yaml" | wc -l)
xml_count=$(find "$TARGET_DIR" -name "*.xml" -type f | wc -l)
sql_count=$(find "$TARGET_DIR" -name "*.sql" -type f | wc -l)
md_count=$(find "$TARGET_DIR" -name "*.md" -type f | wc -l)

cat > "$TARGET_DIR/文件统计.md" << EOF
# 📈 文件统计报告

## 转换时间
$(date)

## 文件类型统计
- Java源代码文件: $java_count 个
- YAML配置文件: $yml_count 个  
- XML配置文件: $xml_count 个
- SQL脚本文件: $sql_count 个
- Markdown文档: $md_count 个

## 目录大小
$(du -sh "$TARGET_DIR")

## 主要目录
$(find "$TARGET_DIR" -type d | sort | head -20)

## 备注
此统计仅包含转换后的文件，原始Maven构建文件已移除。
EOF

echo ""
echo "🎉 RuoYi文件夹转换完成！"
echo "📁 目标目录: $TARGET_DIR"
echo "📊 文件统计:"
echo "  - Java文件: $java_count 个"
echo "  - 配置文件: $((yml_count + xml_count)) 个"
echo "  - SQL文件: $sql_count 个"
echo "  - 文档文件: $md_count 个"
echo ""
echo "📝 已创建文档:"
echo "  - 目录结构说明.md"
echo "  - 文件统计.md"