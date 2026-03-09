# 🔑 GitLab个人访问令牌获取指南

## 📅 创建时间：2026年3月9日 21:11

## 🎯 目的
由于HTTPS+密码认证失败，改用个人访问令牌进行GitLab代码上传。

## 🚀 获取步骤

### 步骤1：登录GitLab
1. 打开浏览器访问：https://gitlab.cihon.cn
2. 使用账号登录：
   - **用户名/邮箱**: `hailong.wang@cihon.cn`
   - **密码**: `28465@Chwx`

### 步骤2：进入访问令牌设置
1. 登录后点击右上角头像
2. 选择 **Edit profile**
3. 左侧菜单选择 **Access Tokens**

### 步骤3：创建新令牌
1. 点击 **Add new token** 按钮
2. 填写令牌信息：
   - **Token name**: `project_management_upload`
   - **Expiration date**: 设置合适的过期日期（建议30天）
   - **Select scopes**: 勾选以下权限：
     - ✅ `api` - 完整API访问权限
     - ✅ `read_repository` - 仓库读取权限
     - ✅ `write_repository` - 仓库写入权限
     - ✅ `read_user` - 用户信息读取权限
3. 点击 **Create personal access token**

### 步骤4：复制令牌
1. **重要**: 令牌只显示一次，请立即复制
2. 令牌格式：`glpat-xxxxxxxxxxxxxxxxxxxx`
3. 保存到安全的地方

## 🔧 使用令牌上传代码

### 方法1：Git远程URL中使用令牌
```bash
# 替换 YOUR_TOKEN 为实际获取的令牌
TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"
git remote set-url gitlab "https://oauth2:${TOKEN}@gitlab.cihon.cn/whl_openclaw/project-management-system.git"

# 推送代码
git push gitlab main --force
```

### 方法2：Git配置中使用令牌
```bash
# 配置Git使用令牌
git config --global credential.helper store
# 第一次推送时会要求输入用户名和密码，密码处输入令牌

# 或直接配置
git config --global credential.https://gitlab.cihon.cn.username oauth2
git config --global credential.https://gitlab.cihon.cn.password "你的令牌"
```

### 方法3：环境变量中使用令牌
```bash
# 设置环境变量
export GITLAB_TOKEN="glpat-xxxxxxxxxxxxxxxxxxxx"

# 使用环境变量
git remote set-url gitlab "https://oauth2:${GITLAB_TOKEN}@gitlab.cihon.cn/whl_openclaw/project-management-system.git"
```

## 📊 令牌权限说明

### 必要权限
| 权限 | 用途 | 必要性 |
|------|------|--------|
| `api` | 完整API访问 | 必须，用于各种操作 |
| `read_repository` | 读取仓库 | 必须，用于拉取代码 |
| `write_repository` | 写入仓库 | 必须，用于推送代码 |
| `read_user` | 读取用户信息 | 推荐，用于身份验证 |

### 可选权限
| 权限 | 用途 | 建议 |
|------|------|------|
| `read_api` | 只读API访问 | 如果只需要读取 |
| `sudo` | 管理员权限 | 不建议，权限过大 |
| `admin_mode` | 管理员模式 | 不建议，权限过大 |

## 🚨 安全注意事项

### 令牌安全
1. **一次性显示**: 令牌创建后只显示一次
2. **妥善保存**: 保存到密码管理器或安全文件
3. **权限最小化**: 只授予必要权限
4. **定期更换**: 建议每30-90天更换一次

### 使用安全
1. **不要硬编码**: 不要在脚本中硬编码令牌
2. **环境变量**: 使用环境变量存储令牌
3. **Git配置**: 考虑使用Git凭据助手
4. **访问控制**: 限制令牌的使用范围

### 泄露处理
1. **立即撤销**: 如果怀疑泄露，立即撤销令牌
2. **监控日志**: 监控GitLab访问日志
3. **重新创建**: 创建新的令牌替换
4. **安全检查**: 检查是否有异常访问

## 📈 验证步骤

### 令牌验证
1. **登录验证**: 使用令牌可以访问API
2. **权限验证**: 验证令牌有项目访问权限
3. **操作验证**: 测试推送和拉取操作
4. **过期验证**: 检查令牌未过期

### 上传验证
1. **连接测试**: `git ls-remote gitlab --heads`
2. **推送测试**: `git push gitlab main --dry-run`
3. **完整性验证**: 比较GitHub和GitLab提交
4. **Web验证**: 登录GitLab Web界面查看

## 🔄 故障排除

### 常见问题
1. **令牌无效**: 检查令牌格式和权限
2. **权限不足**: 确保有项目写入权限
3. **项目不存在**: 验证项目路径正确
4. **网络问题**: 检查GitLab服务器可访问

### 解决方案
1. **重新创建令牌**: 使用正确的权限重新创建
2. **检查项目权限**: 确保账号有项目访问权
3. **验证URL格式**: 确保URL格式正确
4. **联系管理员**: 如果问题持续，联系GitLab管理员

## 📞 技术支持

### GitLab帮助
- **官方文档**: https://docs.gitlab.com/ee/user/profile/personal_access_tokens.html
- **社区支持**: https://forum.gitlab.com/
- **问题反馈**: 通过GitLab界面反馈问题

### 项目支持
- **技术负责人**: 孙工
- **运维支持**: 吴工
- **紧急联系**: 郑工（项目经理）

---

**指南创建时间**: 21:11
**预计获取时间**: 5-10分钟
**紧急程度**: 高

**🎯 立即获取GitLab访问令牌，完成代码上传！**
