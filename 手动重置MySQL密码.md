# 🔐 手动重置MySQL root密码指南

## 目标密码：28465@Whl

## 步骤1：停止MySQL服务
```bash
sudo /usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server stop
```

## 步骤2：启动安全模式
```bash
sudo /usr/local/mysql-8.0.45-macos15-x86_64/bin/mysqld_safe --skip-grant-tables --skip-networking &
```

等待5秒让MySQL启动。

## 步骤3：连接MySQL（无需密码）
```bash
/usr/local/mysql-8.0.45-macos15-x86_64/bin/mysql -u root
```

## 步骤4：在MySQL命令行执行
```sql
-- 刷新权限
FLUSH PRIVILEGES;

-- 重置root密码
ALTER USER 'root'@'localhost' IDENTIFIED BY '28465@Whl';

-- 再次刷新权限
FLUSH PRIVILEGES;

-- 退出
exit;
```

## 步骤5：停止安全模式
```bash
sudo pkill -9 mysqld_safe
sudo pkill -9 mysqld
```

## 步骤6：正常启动MySQL
```bash
sudo /usr/local/mysql-8.0.45-macos15-x86_64/support-files/mysql.server start
```

## 步骤7：测试新密码
```bash
/usr/local/mysql-8.0.45-macos15-x86_64/bin/mysql -u root -p'28465@Whl' -e "SELECT VERSION();"
```

## 步骤8：创建项目数据库
```bash
/usr/local/mysql-8.0.45-macos15-x86_64/bin/mysql -u root -p'28465@Whl' -e "CREATE DATABASE project_management; SHOW DATABASES;"
```

## 注意事项
1. **需要sudo权限**执行所有命令
2. **确保MySQL完全停止**后再启动安全模式
3. **安全模式启动后**需要等待几秒
4. **重置后**记得正常重启MySQL

## 验证成功
如果看到以下输出，表示成功：
```
+-----------------+
| version()       |
+-----------------+
| 8.0.45          |
+-----------------+
```

## 备用方案
如果上述方法失败，可以：
1. 使用MySQL安装时的临时密码
2. 查看错误日志：`sudo cat /usr/local/mysql-8.0.45-macos15-x86_64/data/mysqld.local.err`
3. 重新安装MySQL

