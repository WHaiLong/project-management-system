#!/bin/bash
# 若依框架快速配置脚本

echo "快速配置若依框架..."

# 备份原配置
cp ruoyi-admin/src/main/resources/application.yml ruoyi-admin/src/main/resources/application.yml.backup
cp ruoyi-admin/src/main/resources/application-druid.yml ruoyi-admin/src/main/resources/application-druid.yml.backup

# 创建简化配置
cat > ruoyi-admin/src/main/resources/application.yml << 'CONFIGEOF'
# 应用配置
server:
  port: 8080
  servlet:
    context-path: /
  tomcat:
    uri-encoding: UTF-8
    max-threads: 1000
    min-spare-threads: 30

# Spring配置
spring:
  application:
    name: ruoyi
  profiles:
    active: druid
  servlet:
    multipart:
      max-file-size: 10MB
      max-request-size: 100MB
  mvc:
    pathmatch:
      matching-strategy: ant_path_matcher
  jackson:
    time-zone: GMT+8
    date-format: yyyy-MM-dd HH:mm:ss

# MyBatis配置
mybatis:
  mapper-locations: classpath*:mapper/**/*.xml
  type-aliases-package: com.ruoyi.**.domain
  configuration:
    map-underscore-to-camel-case: true

# 日志配置
logging:
  level:
    com.ruoyi: debug
    org.springframework: warn

# 项目信息
ruoyi:
  name: 项目管理系统
  version: 1.0.0
  copyrightYear: 2026
  demoEnabled: false
  addressEnabled: false
CONFIGEOF

# 创建数据库配置
cat > ruoyi-admin/src/main/resources/application-druid.yml << 'DBEOF'
# 数据源配置
spring:
  datasource:
    type: com.alibaba.druid.pool.DruidDataSource
    driverClassName: com.mysql.cj.jdbc.Driver
    druid:
      # 主库数据源
      master:
        url: jdbc:mysql://localhost:3306/project_management?useUnicode=true&characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&useSSL=true&serverTimezone=GMT%2B8
        username: root
        password: 123456
      # 从库数据源（暂时不用）
      slave:
        enabled: false
      # 初始连接数
      initialSize: 5
      # 最小连接池数量
      minIdle: 10
      # 最大连接池数量
      maxActive: 100
      # 配置获取连接等待超时的时间
      maxWait: 60000
      # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
      timeBetweenEvictionRunsMillis: 60000
      # 配置一个连接在池中最小生存的时间，单位是毫秒
      minEvictableIdleTimeMillis: 300000
      # 配置一个连接在池中最大生存的时间，单位是毫秒
      maxEvictableIdleTimeMillis: 900000
      # 配置检测连接是否有效
      validationQuery: SELECT 1 FROM DUAL
      testWhileIdle: true
      testOnBorrow: false
      testOnReturn: false
      webStatFilter:
        enabled: true
      statViewServlet:
        enabled: true
        # 设置白名单，不填则允许所有访问
        allow:
        url-pattern: /druid/*
        # 控制台管理用户名和密码
        login-username: admin
        login-password: 123456
      filter:
        stat:
          enabled: true
          # 慢SQL记录
          log-slow-sql: true
          slow-sql-millis: 1000
          merge-sql: true
        wall:
          config:
            multi-statement-allow: true

# Redis配置（简化）
redis:
  host: localhost
  port: 6379
  password: 
  timeout: 3000ms
  database: 0
DBEOF

echo "✅ 配置文件已生成"
echo "✅ 若依框架快速配置完成"
