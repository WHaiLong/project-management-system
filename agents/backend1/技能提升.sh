#!/bin/bash
echo "🚀 后端开发技能提升脚本"
echo "时间: $(date)"
echo ""

# 1. 微服务架构技能
echo "=== 微服务架构技能提升 ==="
cat > MicroserviceArchitecture.md << 'MSA'
# 微服务架构设计

## 核心概念
1. **服务拆分原则**
   - 单一职责原则
   - 领域驱动设计
   - 数据自治原则

2. **服务通信方式**
   - REST API (同步)
   - 消息队列 (异步)
   - gRPC (高性能)

3. **服务治理**
   - 服务注册与发现
   - 负载均衡
   - 熔断降级
   - 限流控制

## Spring Cloud技术栈
```java
// 服务注册与发现
@EnableEurekaClient
@SpringBootApplication
public class ProjectServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProjectServiceApplication.class, args);
    }
}

// 服务调用
@FeignClient(name = "task-service")
public interface TaskServiceClient {
    
    @GetMapping("/tasks/project/{projectId}")
    List<Task> getTasksByProject(@PathVariable("projectId") Long projectId);
}

// 配置中心
@RefreshScope
@RestController
public class ConfigController {
    
    @Value("${project.config.max-size}")
    private Integer maxSize;
}

// 网关路由
spring:
  cloud:
    gateway:
      routes:
        - id: project-service
          uri: lb://project-service
          predicates