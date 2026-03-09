#!/bin/bash
echo "🧪 快速API功能测试"
echo "时间: $(date)"
echo "假设后端服务运行在 http://localhost:8080"
echo ""

echo "=== 测试1：服务健康检查 ==="
echo "测试端点: /actuator/health"
curl -s http://localhost:8080/actuator/health | jq . 2>/dev/null || curl -s http://localhost:8080/actuator/health
echo ""

echo "=== 测试2：用户登录（模拟）==="
echo "注意：需要实际登录端点，这里模拟响应"
echo "预期：返回用户信息或登录成功"
echo ""

echo "=== 测试3：项目管理API ==="
echo "测试端点: /api/projects"
echo "GET请求测试..."
curl -s http://localhost:8080/api/projects 2>/dev/null | head -5
echo ""

echo "=== 测试4：任务管理API ==="
echo "测试端点: /api/tasks"
echo "GET请求测试..."
curl -s http://localhost:8080/api/tasks 2>/dev/null | head -5
echo ""

echo "=== 测试5：工时管理API ==="
echo "测试端点: /api/workhours"
echo "GET请求测试..."
curl -s http://localhost:8080/api/workhours 2>/dev/null | head -5
echo ""

echo "=== 测试结果 ==="
echo "如果以上测试有响应（即使是错误），说明服务已启动"
echo "如果全部超时或无响应，说明服务未启动"
echo ""

echo "🎯 测试完成"
echo "下一步：根据实际API端点调整测试脚本"
