#!/bin/bash

# 修复RuoYi父pom的依赖管理问题

PARENT_POM="pom.xml"
BACKUP_POM="pom.xml.backup"

# 备份原始文件
cp "$PARENT_POM" "$BACKUP_POM"

# 创建修复后的pom.xml
cat > "$PARENT_POM" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.ruoyi</groupId>
    <artifactId>ruoyi</artifactId>
    <version>4.7.6</version>
    <packaging>pom</packaging>
    <description>若依快速开发平台</description>

    <modules>
        <!-- 核心模块 -->
        <module>ruoyi-admin</module>
        <module>ruoyi-common</module>
        <module>ruoyi-framework</module>
        <module>ruoyi-generator</module>
        <module>ruoyi-quartz</module>
        <module>ruoyi-system</module>
        
        <!-- 自定义模块 -->
        <module>../project</module>
        <module>../task</module>
        <module>../workhour</module>
    </modules>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.5.14</version>
        <relativePath/>
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <shiro.version>1.7.1</shiro.version>
        <mybatis-plus.version>3.5.1</mybatis-plus.version>
        <druid.version>1.2.8</druid.version>
        <velocity.version>2.3</velocity.version>
        <swagger.version>3.0.0</swagger.version>
        <pagehelper.version>1.4.1</pagehelper.version>
        <fastjson.version>1.2.83</fastjson.version>
        <commons-io.version>2.11.0</commons-io.version>
        <commons-lang3.version>3.12.0</commons-lang3.version>
        <poi.version>5.2.2</poi.version>
        <yauaa.version>7.10.0</yauaa.version>
        <oshi.version>6.1.6</oshi.version>
        <kaptcha.version>2.3.3</kaptcha.version>
        <thymeleaf-shiro.version>2.1.0</thymeleaf-shiro.version>
        <jjwt.version>0.9.1</jjwt.version>
        <c3p0.version>0.9.5.5</c3p0.version>
        <servlet-api.version>4.0.1</servlet-api.version>
        <quartz.version>2.3.2</quartz.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <!-- Spring Boot Starters -->
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-web</artifactId>
            </dependency>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-validation</artifactId>
            </dependency>
            
            <!-- Shiro安全框架 -->
            <dependency>
                <groupId>org.apache.shiro</groupId>
                <artifactId>shiro-spring-boot-web-starter</artifactId>
                <version>${shiro.version}</version>
            </dependency>
            <dependency>
                <groupId>org.apache.shiro</groupId>
                <artifactId>shiro-core</artifactId>
                <version>${shiro.version}</version>
            </dependency>
            <dependency>
                <groupId>org.apache.shiro</groupId>
                <artifactId>shiro-ehcache</artifactId>
                <version>${shiro.version}</version>
            </dependency>
            <dependency>
                <groupId>org.apache.shiro</groupId>
                <artifactId>shiro-spring</artifactId>
                <version>${shiro.version}</version>
            </dependency>
            
            <!-- MyBatis Plus -->
            <dependency>
                <groupId>com.baomidou</groupId>
                <artifactId>mybatis-plus-boot-starter</artifactId>
                <version>${mybatis-plus.version}</version>
            </dependency>
            
            <!-- PageHelper分页插件 -->
            <dependency>
                <groupId>com.github.pagehelper</groupId>
                <artifactId>pagehelper-spring-boot-starter</artifactId>
                <version>${pagehelper.version}</version>
            </dependency>
            
            <!-- Druid连接池 -->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>druid-spring-boot-starter</artifactId>
                <version>${druid.version}</version>
            </dependency>
            
            <!-- 工具类库 -->
            <dependency>
                <groupId>com.alibaba</groupId>
                <artifactId>fastjson</artifactId>
                <version>${fastjson.version}</version>
            </dependency>
            <dependency>
                <groupId>commons-io</groupId>
                <artifactId>commons-io</artifactId>
                <version>${commons-io.version}</version>
            </dependency>
            <dependency>
                <groupId>org.apache.commons</groupId>
                <artifactId>commons-lang3</artifactId>
                <version>${commons-lang3.version}</version>
            </dependency>
            
            <!-- POI Excel处理 -->
            <dependency>
                <groupId>org.apache.poi</groupId>
                <artifactId>poi-ooxml</artifactId>
                <version>${poi.version}</version>
            </dependency>
            
            <!-- 用户代理分析 -->
            <dependency>
                <groupId>nl.basjes.parse.useragent</groupId>
                <artifactId>yauaa</artifactId>
                <version>${yauaa.version}</version>
            </dependency>
            
            <!-- 系统信息获取 -->
            <dependency>
                <groupId>com.github.oshi</groupId>
                <artifactId>oshi-core</artifactId>
                <version>${oshi.version}</version>
            </dependency>
            
            <!-- 验证码 -->
            <dependency>
                <groupId>pro.fessional</groupId>
                <artifactId>kaptcha</artifactId>
                <version>${kaptcha.version}</version>
            </dependency>
            
            <!-- Thymeleaf Shiro扩展 -->
            <dependency>
                <groupId>com.github.theborakompanioni</groupId>
                <artifactId>thymeleaf-extras-shiro</artifactId>
                <version>${thymeleaf-shiro.version}</version>
            </dependency>
            
            <!-- JWT Token -->
            <dependency>
                <groupId>io.jsonwebtoken</groupId>
                <artifactId>jjwt</artifactId>
                <version>${jjwt.version}</version>
            </dependency>
            
            <!-- 数据库连接池 -->
            <dependency>
                <groupId>com.mchange</groupId>
                <artifactId>c3p0</artifactId>
                <version>${c3p0.version}</version>
            </dependency>
            
            <!-- Servlet API -->
            <dependency>
                <groupId>javax.servlet</groupId>
                <artifactId>javax.servlet-api</artifactId>
                <version>${servlet-api.version}</version>
            </dependency>
            
            <!-- Quartz调度 -->
            <dependency>
                <groupId>org.quartz-scheduler</groupId>
                <artifactId>quartz</artifactId>
                <version>${quartz.version}</version>
            </dependency>
            
            <!-- Velocity模板引擎 -->
            <dependency>
                <groupId>org.apache.velocity</groupId>
                <artifactId>velocity-engine-core</artifactId>
                <version>${velocity.version}</version>
            </dependency>
            
            <!-- Swagger API文档 -->
            <dependency>
                <groupId>io.springfox</groupId>
                <artifactId>springfox-boot-starter</artifactId>
                <version>${swagger.version}</version>
            </dependency>
            
            <!-- Jackson JSON处理 -->
            <dependency>
                <groupId>com.fasterxml.jackson.core</groupId>
                <artifactId>jackson-databind</artifactId>
            </dependency>
            
            <!-- RuoYi内部模块 -->
            <dependency>
                <groupId>com.ruoyi</groupId>
                <artifactId>ruoyi-common</artifactId>
                <version>${project.version}</version>
            </dependency>
            <dependency>
                <groupId>com.ruoyi</groupId>
                <artifactId>ruoyi-framework</artifactId>
                <version>${project.version}</version>
            </dependency>
            <dependency>
                <groupId>com.ruoyi</groupId>
                <artifactId>ruoyi-system</artifactId>
                <version>${project.version}</version>
            </dependency>
            <dependency>
                <groupId>com.ruoyi</groupId>
                <artifactId>ruoyi-generator</artifactId>
                <version>${project.version}</version>
            </dependency>
            <dependency>
                <groupId>com.ruoyi</groupId>
                <artifactId>ruoyi-quartz</artifactId>
                <version>${project.version}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <configuration>
                    <source>${java.version}</source>
                    <target>${java.version}</target>
                    <encoding>${project.build.sourceEncoding}</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
EOF

echo "✅ 父pom依赖管理已修复"
echo "📋 添加了以下依赖版本管理："
echo "  - Shiro相关: ${shiro.version}"
echo "  - MyBatis Plus: ${mybatis-plus.version}"
echo "  - PageHelper: ${pagehelper.version}"
echo "  - Fastjson: ${fastjson.version}"
echo "  - Commons IO: ${commons-io.version}"
echo "  - Commons Lang3: ${commons-lang3.version}"
echo "  - POI: ${poi.version}"
echo "  - 以及其他23个依赖"

echo ""
echo "🚀 现在可以尝试重新编译项目："