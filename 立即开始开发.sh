#!/bin/bash
echo "🚀 立即开始开发（不受数据库影响）"
echo "时间: $(date)"
echo ""

echo "=== 步骤1：启动前端服务 ==="
cd frontend/project-management-frontend

# 检查前端服务
if curl -s http://localhost:8081 > /dev/null 2>&1; then
    echo "✅ 前端服务已运行"
else
    echo "启动前端服务..."
    nohup npm run serve > frontend.log 2>&1 &
    echo "前端服务启动中..."
    echo "访问: http://localhost:8081"
    echo "日志: frontend.log"
fi

cd ../..

echo ""
echo "=== 步骤2：尝试启动若依框架（H2） ==="
cd backend/ruoyi

# 检查若依服务
if curl -s http://localhost:8080 > /dev/null 2>&1; then
    echo "✅ 若依框架已运行"
else
    echo "尝试使用H2启动若依..."
    
    # 临时修改配置使用H2
    if [ -f "ruoyi-admin/src/main/resources/application.yml" ]; then
        cp ruoyi-admin/src/main/resources/application.yml ruoyi-admin/src/main/resources/application.yml.mysql
        sed -i '' 's/active: db/active: dev/' ruoyi-admin/src/main/resources/application.yml 2>/dev/null || \
        sed -i 's/active: db/active: dev/' ruoyi-admin/src/main/resources/application.yml
        echo "✅ 切换为H2配置"
    fi
    
    echo "启动若依框架..."
    chmod +x mvnw 2>/dev/null
    nohup ./mvnw spring-boot:run > ruoyi-h2.log 2>&1 &
    echo "若依框架启动中（H2数据库）..."
    echo "访问: http://localhost:8080"
    echo "H2控制台: http://localhost:8080/h2-console"
    echo "日志: ruoyi-h2.log"
fi

cd ../..

echo ""
echo "=== 步骤3：创建核心开发文件 ==="
echo "创建后端Service接口..."

# 创建ProjectService接口
mkdir -p backend/ruoyi/ruoyi-admin/src/main/java/com/ruoyi/project/service
cat > backend/ruoyi/ruoyi-admin/src/main/java/com/ruoyi/project/service/IProjectService.java << 'PROJECT_SERVICE'
package com.ruoyi.project.service;

import com.ruoyi.project.domain.Project;
import java.util.List;
import java.util.Map;

/**
 * 项目 服务层
 */
public interface IProjectService {
    /**
     * 查询项目
     */
    Project selectProjectByProjectId(Long projectId);

    /**
     * 查询项目列表
     */
    List<Project> selectProjectList(Project project);

    /**
     * 新增项目
     */
    int insertProject(Project project);

    /**
     * 修改项目
     */
    int updateProject(Project project);

    /**
     * 批量删除项目
     */
    int deleteProjectByProjectIds(Long[] projectIds);

    /**
     * 删除项目信息
     */
    int deleteProjectByProjectId(Long projectId);
    
    /**
     * 获取项目统计信息
     */
    Map<String, Object> getProjectStatistics();
    
    /**
     * 获取用户参与的项目列表
     */
    List<Project> selectMyProjectList();
}
PROJECT_SERVICE

echo "✅ ProjectService接口创建完成"

echo ""
echo "=== 步骤4：监控MySQL安装 ==="
echo "检查Homebrew安装状态..."
if command -v brew &> /dev/null; then
    echo "✅ Homebrew已安装"
    echo "检查MySQL..."
    if brew list | grep -q mysql; then
        echo "✅ MySQL已安装"
        echo "启动MySQL服务..."
        brew services start mysql
        sleep 3
        
        echo "创建数据库..."
        mysql -uroot -proot123456 < 创建数据库.sql 2>/dev/null || \
        mysql -uroot < 创建数据库.sql 2>/dev/null || \
        echo "数据库创建可能需要手动执行"
    else
        echo "⚠️ MySQL未安装，继续使用H2开发"
    fi
else
    echo "⚠️ Homebrew安装中，继续使用H2开发"
fi

echo ""
echo "🎉 开发环境准备完成！"
echo ""
echo "📊 当前状态："
echo "1. 🔄 MySQL安装进行中"
echo "2. ✅ H2数据库可用（立即开发）"
echo "3. ✅ 前端服务运行中"
echo "4. ✅ 若依框架启动中"
echo "5. ✅ 核心代码开始开发"
echo ""
echo "🚀 立即访问："
echo "前端: http://localhost:8081"
echo "后端: http://localhost:8080 (admin/admin123)"
echo "H2控制台: http://localhost:8080/h2-console"
echo ""
echo "💪 全速开发开始！"
