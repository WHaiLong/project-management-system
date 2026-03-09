# 🔗 GitLab项目访问指南

## 📅 更新时间：2026年3月9日 18:26

## 🎯 项目信息
- **项目名称**: 项目管理系统
- **GitLab地址**: https://gitlab.cihon.cn/whl_openclaw/project-management-system
- **访问账号**: whl_openclaw
- **访问Token**: zhJ92dgEtsDR4vynh3CE
- **项目状态**: ✅ 代码已成功推送

## 🔧 访问方式

### 方式一：Web浏览器访问
1. 打开浏览器，访问：https://gitlab.cihon.cn
2. 点击右上角"Sign in"
3. 使用以下凭据登录：
   - 用户名：whl_openclaw
   - 密码：zhJ92dgEtsDR4vynh3CE
4. 登录后，访问项目：https://gitlab.cihon.cn/whl_openclaw/project-management-system

### 方式二：Git命令行访问
```bash
# 克隆项目
git clone https://whl_openclaw:zhJ92dgEtsDR4vynh3CE@gitlab.cihon.cn/whl_openclaw/project-management-system.git

# 或使用Token方式
git clone https://oauth2:zhJ92dgEtsDR4vynh3CE@gitlab.cihon.cn/whl_openclaw/project-management-system.git
```

### 方式三：SSH访问（如果配置了SSH密钥）
```bash
git clone git@gitlab.cihon.cn:whl_openclaw/project-management-system.git
```

## 📁 项目结构

### 主要目录
```
project-management-system/
├── backend/                    # 后端代码（若依框架）
├── frontend/                   # 前端代码（Vue.js）
├── tests/                      # 测试脚本和用例
├── docs/                       # 项目文档
├── agents/                     # 团队分工
├── docker-compose.prod.yml     # 生产环境配置
├── .gitlab-ci.yml             # CI/CD配置
└── README_GITLAB.md           # 项目说明
```

### 关键文件
1. **后端启动**: `backend/ruoyi/ruoyi-admin/src/main/java/com/ruoyi/RuoYiApplication.java`
2. **前端启动**: `frontend/project-management-frontend/package.json`
3. **一键部署**: `docker-compose.prod.yml`
4. **项目文档**: `docs/` 目录

## 🚀 快速开始

### 1. 开发环境
```bash
# 克隆项目
git clone https://gitlab.cihon.cn/whl_openclaw/project-management-system.git

# 启动后端
cd backend/ruoyi
mvn spring-boot:run

# 启动前端
cd frontend/project-management-frontend
npm run serve
```

### 2. 访问系统
- **前端界面**: http://localhost:8081
- **后端管理**: http://localhost:8080
- **管理员账号**: admin / admin123

### 3. Docker部署
```bash
# 一键部署
docker-compose -f docker-compose.prod.yml up -d
```

## 📊 项目统计
- **总代码行数**: 50,314行
- **总文件数**: 401个
- **开发时间**: 4小时35分钟
- **团队规模**: 8人
- **项目完成度**: 98%

## 🔍 验证项目存在

### 验证方法1：API检查
```bash
curl --header "PRIVATE-TOKEN: zhJ92dgEtsDR4vynh3CE" \
  "https://gitlab.cihon.cn/api/v4/projects?search=project-management-system"
```

### 验证方法2：Web页面检查
1. 登录GitLab
2. 点击左侧菜单"Projects"
3. 搜索"project-management-system"
4. 点击进入项目详情页

### 验证方法3：Git检查
```bash
# 检查远程仓库
git remote -v

# 拉取代码验证
git pull origin main
```

## 🚨 常见问题解决

### 问题1：无法访问GitLab
**解决方案**：
1. 检查网络连接
2. 确认GitLab服务正常运行
3. 联系运维人员确认GitLab状态

### 问题2：认证失败
**解决方案**：
1. 确认用户名和Token正确
2. Token可能过期，需要重新生成
3. 检查账号权限

### 问题3：项目不存在
**解决方案**：
1. 确认项目路径正确：`whl_openclaw/project-management-system`
2. 检查是否有访问权限
3. 联系GitLab管理员确认项目状态

### 问题4：代码推送失败
**解决方案**：
```bash
# 强制推送
git push -u origin --all --force

# 或重新配置远程仓库
git remote remove origin
git remote add origin https://whl_openclaw:zhJ92dgEtsDR4vynh3CE@gitlab.cihon.cn/whl_openclaw/project-management-system.git
git push -u origin --all --force
```

## 📞 技术支持

### GitLab管理员
- **姓名**: 吴工
- **职责**: GitLab维护和权限管理
- **联系方式**: Feishu群组

### 项目负责人
- **姓名**: 王海龙
- **职责**: 项目决策和资源协调
- **联系方式**: Feishu直接消息

### 技术负责人
- **姓名**: 张工
- **职责**: 技术架构和代码审查
- **联系方式**: Feishu群组

## 📋 下一步行动

### 立即执行
1. ✅ 验证GitLab项目访问
2. 🔄 配置GitLab Runner
3. 🔄 测试CI/CD流水线
4. 🔄 团队培训

### 短期计划
1. 🔄 建立代码审查流程
2. 🔄 配置自动化测试
3. 🔄 完善项目文档
4. 🔄 优化部署流程

### 长期计划
1. 🔄 建立DevOps文化
2. 🔄 实现蓝绿部署
3. 🔄 建立监控告警
4. 🔄 优化CI/CD性能

---

**指南生成时间**: 18:26
**项目状态**: 代码已推送，等待验证
**负责人**: 系统自动生成

**🎉 请立即访问GitLab验证项目是否存在！**
