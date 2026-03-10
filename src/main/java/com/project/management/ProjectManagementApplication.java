package com.project.management;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 项目管理系统启动类
 */
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class ProjectManagementApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProjectManagementApplication.class, args);
        System.out.println("==========================================");
        System.out.println("🚀 项目管理系统启动成功！");
        System.out.println("🔗 访问地址: http://localhost:8080");
        System.out.println("👤 管理员账号: admin / admin123");
        System.out.println("📊 代码生成器: http://localhost:8080/tool/gen");
        System.out.println("==========================================");
    }
}
