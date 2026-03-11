# 📚 Swagger配置与使用指南

## 📅 更新时间：2026年3月10日 13:45

## 🎯 概述
本文档介绍项目管理系统中Swagger API文档的配置、使用和最佳实践。

## 🔧 Swagger配置状态

### 当前配置状态
✅ **Swagger已集成** - 项目已包含Swagger 3.0.0依赖
✅ **配置类已存在** - `SwaggerConfig.java` 配置类已实现
✅ **资源映射已配置** - 静态资源映射已设置

### 访问地址
- **Swagger UI界面**: `http://localhost:8080/swagger-ui/index.html`
- **API文档JSON**: `http://localhost:8080/v3/api-docs`

### 配置详情

#### 1. 依赖配置 (`pom.xml`)
```xml
<!-- Swagger API文档 -->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
</dependency>
```

#### 2. 配置类 (`SwaggerConfig.java`)
```java
@Configuration
public class SwaggerConfig {
    @Value("${swagger.enabled}")
    private boolean enabled;
    
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.OAS_30)
                .enable(enabled)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
                .paths(PathSelectors.any())
                .build();
    }
    
    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("项目管理系统 API文档")
                .description("项目管理、任务管理、工时管理接口文档")
                .contact(new Contact("技术团队", null, null))
                .version("1.0.0")
                .build();
    }
}
```

#### 3. 资源映射配置 (`ResourcesConfig.java`)
```java
@Configuration
public class ResourcesConfig implements WebMvcConfigurer {
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        /** swagger配置 */
        registry.addResourceHandler("/swagger-ui/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/springfox-swagger-ui/");
    }
}
```

## 🚀 快速开始

### 1. 启用Swagger
在 `application.yml` 或 `application-dev.yml` 中添加配置：
```yaml
# Swagger配置
swagger:
  enabled: true
```

### 2. 为接口添加Swagger注解
```java
@RestController
@RequestMapping("/api/projects")
@Api(tags = "项目管理接口")
public class ProjectController {
    
    @GetMapping
    @ApiOperation("获取项目列表")
    @ApiImplicitParams({
        @ApiImplicitParam(name = "page", value = "页码", defaultValue = "1"),
        @ApiImplicitParam(name = "size", value = "每页数量", defaultValue = "10"),
        @ApiImplicitParam(name = "status", value = "项目状态"),
        @ApiImplicitParam(name = "keyword", value = "搜索关键词")
    })
    public Result getProjects(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String keyword) {
        // 业务逻辑
    }
    
    @PostMapping
    @ApiOperation("创建项目")
    public Result createProject(@RequestBody @Valid ProjectCreateDTO dto) {
        // 业务逻辑
    }
}
```

### 3. 为实体类添加Swagger注解
```java
@Data
@ApiModel("项目信息")
public class ProjectVO {
    
    @ApiModelProperty("项目ID")
    private Long id;
    
    @ApiModelProperty(value = "项目名称", required = true)
    private String name;
    
    @ApiModelProperty("项目描述")
    private String description;
    
    @ApiModelProperty("项目状态")
    private String status;
    
    @ApiModelProperty("开始时间")
    private Date startDate;
    
    @ApiModelProperty("结束时间")
    private Date endDate;
}
```

## 📖 Swagger注解详解

### 控制器层注解
| 注解 | 说明 | 示例 |
|------|------|------|
| `@Api` | 控制器标签 | `@Api(tags = "项目管理接口")` |
| `@ApiOperation` | 接口操作说明 | `@ApiOperation("获取项目列表")` |
| `@ApiImplicitParams` | 接口参数说明 | 见上例 |
| `@ApiImplicitParam` | 单个参数说明 | `@ApiImplicitParam(name = "page", value = "页码")` |
| `@ApiResponses` | 接口响应说明 | `@ApiResponses({@ApiResponse(...)})` |
| `@ApiResponse` | 单个响应说明 | `@ApiResponse(code = 200, message = "成功")` |

### 实体层注解
| 注解 | 说明 | 示例 |
|------|------|------|
| `@ApiModel` | 模型说明 | `@ApiModel("项目信息")` |
| `@ApiModelProperty` | 属性说明 | `@ApiModelProperty("项目ID")` |

### 参数注解
| 注解 | 说明 | 示例 |
|------|------|------|
| `@RequestParam` + Swagger | 查询参数 | 见上例 |
| `@RequestBody` + Swagger | 请求体参数 | 见上例 |
| `@PathVariable` + Swagger | 路径参数 | `@ApiParam("项目ID") @PathVariable Long id` |

## 🔐 Swagger安全配置

### 1. 添加Bearer Token认证
在 `SwaggerConfig.java` 中添加：
```java
@Bean
public Docket createRestApi() {
    return new Docket(DocumentationType.OAS_30)
            .enable(enabled)
            .apiInfo(apiInfo())
            .securitySchemes(securitySchemes())  // 添加安全方案
            .securityContexts(securityContexts()) // 添加上下文
            .select()
            .apis(RequestHandlerSelectors.withMethodAnnotation(ApiOperation.class))
            .paths(PathSelectors.any())
            .build();
}

private List<SecurityScheme> securitySchemes() {
    return Collections.singletonList(
        new ApiKey("Authorization", "Authorization", "header")
    );
}

private List<SecurityContext> securityContexts() {
    return Collections.singletonList(
        SecurityContext.builder()
            .securityReferences(defaultAuth())
            .forPaths(PathSelectors.regex("^(?!auth).*$"))
            .build()
    );
}

private List<SecurityReference> defaultAuth() {
    AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
    AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
    authorizationScopes[0] = authorizationScope;
    return Collections.singletonList(
        new SecurityReference("Authorization", authorizationScopes)
    );
}
```

### 2. 在接口中使用安全注解
```java
@GetMapping("/{id}")
@ApiOperation("获取项目详情")
@ApiImplicitParams({
    @ApiImplicitParam(name = "Authorization", value = "访问令牌", required = true, 
                     dataType = "string", paramType = "header")
})
public Result getProject(@PathVariable Long id) {
    // 业务逻辑
}
```

## 🎨 Swagger界面定制

### 1. 修改界面主题
在 `application.yml` 中添加：
```yaml
springfox:
  documentation:
    swagger-ui:
      enabled: true
      # 自定义配置
      config-url: /v3/api-docs/swagger-config
      url: /v3/api-docs
      # 主题设置
      display-request-duration: true
      default-model-expand-depth: 2
      default-model-rendering: example
      doc-expansion: none
      filter: true
      max-displayed-tags: 20
      operations-sorter: alpha
      tags-sorter: alpha
      validator-url: ""
```

### 2. 分组配置
如果需要多个API分组：
```java
@Bean
public Docket publicApi() {
    return new Docket(DocumentationType.OAS_30)
            .groupName("公开接口")
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.ruoyi.web.controller.public"))
            .paths(PathSelectors.any())
            .build();
}

@Bean
public Docket adminApi() {
    return new Docket(DocumentationType.OAS_30)
            .groupName("管理接口")
            .select()
            .apis(RequestHandlerSelectors.basePackage("com.ruoyi.web.controller.admin"))
            .paths(PathSelectors.any())
            .build();
}
```

## 🔧 常见问题解决

### 1. Swagger页面无法访问
**问题**: 访问 `http://localhost:8080/swagger-ui/index.html` 显示404
**解决**:
1. 检查依赖是否引入
2. 检查 `swagger.enabled` 配置是否为 `true`
3. 检查资源映射配置是否正确
4. 检查是否有安全拦截器拦截了Swagger路径

### 2. 接口文档不显示
**问题**: Swagger页面能打开，但接口不显示
**解决**:
1. 检查控制器是否有 `@Api` 或 `@ApiOperation` 注解
2. 检查包扫描路径是否正确
3. 检查接口路径是否被安全框架拦截

### 3. 参数说明不显示
**问题**: 接口参数没有说明信息
**解决**:
1. 确保使用了 `@ApiImplicitParam` 或 `@ApiParam` 注解
2. 对于 `@RequestBody` 参数，确保DTO类有 `@ApiModelProperty` 注解

### 4. 安全认证问题
**问题**: 需要认证的接口在Swagger中无法测试
**解决**:
1. 配置Swagger安全方案（见上文）
2. 在Swagger界面右上角点击 "Authorize" 按钮
3. 输入Bearer Token格式：`Bearer your-jwt-token`

## 📊 最佳实践

### 1. 接口文档规范
- 所有公开接口必须有Swagger注解
- 接口说明要简洁明了
- 参数说明要完整准确
- 响应示例要真实可用

### 2. 版本管理
- API版本变化时更新Swagger文档
- 废弃的接口标记为 `@Deprecated`
- 新接口要完整文档化

### 3. 安全考虑
- 生产环境关闭Swagger
- 敏感接口要有安全注解
- 测试数据要使用模拟数据

### 4. 团队协作
- 统一Swagger注解风格
- 定期检查文档完整性
- 新成员培训Swagger使用

## 🚀 高级功能

### 1. 自定义插件
可以创建自定义插件扩展Swagger功能：
```java
@Component
public class CustomOperationBuilderPlugin implements OperationBuilderPlugin {
    @Override
    public void apply(OperationContext context) {
        // 自定义操作
    }
    
    @Override
    public boolean supports(DocumentationType delimiter) {
        return true;
    }
}
```

### 2. 响应示例
使用 `@ApiResponse` 提供响应示例：
```java
@ApiResponses({
    @ApiResponse(code = 200, message = "成功", 
                 response = ProjectVO.class,
                 examples = @Example(@ExampleProperty(
                     mediaType = "application/json",
                     value = "{\"code\":200,\"message\":\"success\",\"data\":{\"id\":1,\"name\":\"项目A\"}}"
                 ))),
    @ApiResponse(code = 400, message = "参数错误"),
    @ApiResponse(code = 401, message = "未授权"),
    @ApiResponse(code = 500, message = "服务器错误")
})
```

### 3. 枚举类型支持
为枚举类型添加说明：
```java
@ApiModel("项目状态")
public enum ProjectStatus {
    @ApiEnum("进行中")
    IN_PROGRESS,
    
    @ApiEnum("已完成")
    COMPLETED,
    
    @ApiEnum("已取消")
    CANCELLED
}
```

## 📝 维护指南

### 1. 文档更新流程
1. 开发新接口时同步添加Swagger注解
2. 修改接口时更新对应注解
3. 定期检查文档准确性
4. 版本发布前验证文档完整性

### 2. 质量检查清单
- [ ] 所有接口都有 `@ApiOperation` 注解
- [ ] 所有参数都有说明
- [ ] 所有响应都有示例
- [ ] 安全接口有认证配置
- [ ] 生产环境已关闭Swagger

### 3. 性能优化
- 生产环境禁用Swagger以减少资源消耗
- 使用分组减少单页面加载内容
- 定期清理无用注解

## 🔗 相关资源

### 官方文档
- [SpringFox官方文档](https://springfox.github.io/springfox/)
- [Swagger官方文档](https://swagger.io/docs/)
- [OpenAPI规范](https://spec.openapis.org/oas/v3.0.3)

### 工具推荐
- [Swagger Editor](https://editor.swagger.io/) - 在线编辑OpenAPI文档
- [Swagger UI](https://swagger.io/tools/swagger-ui/) - API文档界面
- [Postman](https://www.postman.com/) - API测试工具

### 学习资源
- [Spring Boot集成Swagger教程](https://www.baeldung.com/swagger-2-documentation-for-spring-rest-api)
- [Swagger注解详解](https://www.cnblogs.com/xiaoyuxixi/p/13388894.html)
- [API设计最佳实践](https://restfulapi.net/)

---

**文档维护**: 技术团队
**更新频率**: 随接口变更更新
**适用范围**: 所有开发人员

**🎯 良好的API文档是项目成功的关键！**