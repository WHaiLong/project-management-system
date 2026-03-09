# 🔑 配置码云SSH密钥指南

## 📅 配置时间：2026年3月9日 22:02

## 🎯 配置目的
解决SSH推送时的权限被拒绝问题，建立安全的代码推送通道。

## 🔍 问题现象
```
Permission denied (publickey).
fatal: Could not read from remote repository.
```

## 🚀 配置步骤

### 步骤1：检查现有SSH密钥
```bash
# 检查是否已有SSH密钥
ls -al ~/.ssh/

# 常见密钥文件：
# id_rsa      - 私钥
# id_rsa.pub  - 公钥
# id_ed25519  - Ed25519私钥
# id_ed25519.pub - Ed25519公钥
```

### 步骤2：生成新的SSH密钥（如果没有）
```bash
# 生成RSA密钥（推荐）
ssh-keygen -t rsa -b 4096 -C "hailong.wang@cihon.cn"

# 或生成Ed25519密钥（更安全）
ssh-keygen -t ed25519 -C "hailong.wang@cihon.cn"

# 生成过程中：
# 1. 输入保存路径（默认：~/.ssh/id_rsa）
# 2. 输入密码（可选，增加安全性）
# 3. 确认密码
```

### 步骤3：查看公钥内容
```bash
# 查看公钥（复制全部内容）
cat ~/.ssh/id_rsa.pub

# 公钥格式示例：
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8... hailong.wang@cihon.cn
```

### 步骤4：添加公钥到码云
1. **登录码云**: https://gitee.com
2. **进入设置**: 右上角头像 → 设置
3. **SSH公钥**: 左侧菜单 → SSH公钥
4. **添加公钥**:
   - 标题: `project-management-system`（自定义）
   - 公钥: 粘贴步骤3复制的公钥内容
5. **确定添加**: 点击"确定"按钮

### 步骤5：测试SSH连接
```bash
# 测试连接
ssh -T git@gitee.com

# 成功响应：
# Hi WHaiLong! You've successfully authenticated, but