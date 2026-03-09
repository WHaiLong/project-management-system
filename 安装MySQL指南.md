# MySQL安装指南

## 🚀 快速安装

### macOS (使用Homebrew)
```bash
# 1. 安装MySQL
brew install mysql

# 2. 启动MySQL服务
brew services start mysql

# 3. 设置root密码（首次安装后）
mysql_secure_installation

# 4. 验证安装
mysql --version
```

### Ubuntu/Debian
```bash
# 1. 安装MySQL
sudo apt update
sudo apt install mysql-server

# 2. 启动MySQL服务
sudo systemctl start mysql
sudo systemctl enable mysql

# 3. 安全配置
sudo mysql_secure_installation

# 4. 验证安装
mysql --version
```

### CentOS/RHEL
```bash
# 1. 安装MySQL
sudo yum install mysql-server

# 2. 启动MySQL服务
sudo systemctl start mysqld
sudo systemctl enable mysqld

# 3. 安全配置
sudo mysql_secure_installation

# 4. 验证安装
mysql --version
```

## 🔧 配置项目数据库

安装完成后，执行：
```bash
cd ~/.openclaw/workspace/project-management-system

# 1. 创建数据库
mysql -uroot -p < 创建数据库.sql

# 2. 测试连接
./测试数据库连接.sh

# 3. 配置若依框架
# 配置文件已自动生成：backend/ruoyi/ruoyi-admin/src/main/resources/application-db.yml
```

## 🎯 数据库信息
- **数据库名**: project_management
- **用户名**: pm_user
- **密码**: Pm@123456
- **字符集**: utf8mb4
- **排序规则**: utf8mb4_unicode_ci

## 📊 包含的表
1. `pm_project` - 项目表
2. `pm_task` - 任务表
3. `pm_work_hour` - 工时记录表
4. `pm_user_ext` - 用户扩展表
5. `pm_jira_sync` - Jira同步表
6. `pm_salary_calc` - 工资计算表

## ⚡ 临时解决方案

如果暂时无法安装MySQL，可以使用：

### 方案A：使用H2内存数据库（开发测试）
修改若依配置使用H2：
```yaml
# backend/ruoyi/ruoyi-admin/src/main/resources/application.yml
spring:
  datasource:
    url: jdbc:h2:mem:testdb
    username: sa
    password: 
    driver-class-name: org.h2.Driver
```

### 方案B：使用SQLite（轻量级）
```bash
# 安装SQLite
brew install sqlite  # macOS
sudo apt install sqlite3  # Ubuntu

# 修改配置使用SQLite
```

### 方案C：先开发，后配置数据库
1. 先完成前后端代码开发
2. 使用模拟数据测试
3. 晚上再安装配置MySQL

## 📞 帮助
- 安装问题：查看MySQL官方文档
- 配置问题：检查`创建数据库.sql`脚本
- 连接问题：运行`./测试数据库连接.sh`

**建议立即安装MySQL，以便完整测试！**
