# 🔐 JWT认证配置与使用指南

## 📅 更新时间：2026年3月10日 13:45

## 🎯 概述
本文档介绍如何在项目管理系统中集成JWT（JSON Web Token）认证，与现有Shiro安全框架共存，提供现代化的API认证方案。

## 🔧 JWT集成方案

### 方案选择：JWT + Shiro共存
考虑到项目已使用Shiro作为安全框架，我们采用**JWT与Shiro共存**的方案：
- **Web界面**：继续使用Shiro Session-based认证
- **API接口**：使用JWT Token-based认证
- **平滑过渡**：逐步迁移，不影响现有功能

### 技术栈
- **JWT库**: jjwt 0.9.1 (已存在于pom.xml)
- **加密算法**: HS256 (HMAC + SHA256)
- **Token结构**: Header.Payload.Signature
- **存储方式**: 客户端存储（LocalStorage/Cookie）

## 🚀 快速集成步骤

### 1. 检查现有依赖
项目已包含jjwt依赖：
```xml
<!-- JWT依赖 -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

### 2. 创建JWT配置类
创建 `JwtConfig.java`：

```java
package com.ruoyi.framework.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * JWT配置属性
 */
@Data
@Component
@ConfigurationProperties(prefix = "jwt")
public class JwtConfig {
    
    /**
     * 密钥（至少32位）
     */
    private String secret = "project-management-system-secret-key-2026-03-10";
    
    /**
     * Token有效期（分钟）
     */
    private Long expiration = 120L;
    
    /**
     * Token前缀
     */
    private String tokenPrefix = "Bearer ";
    
    /**
     * Token头标识
     */
    private String tokenHeader = "Authorization";
    
    /**
     * 刷新Token有效期（天）
     */
    private Long refreshExpiration = 7L;
}
```

### 3. 创建JWT工具类
创建 `JwtUtils.java`：

```java
package com.ruoyi.common.utils;

import com.ruoyi.framework.config.JwtConfig;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT工具类
 */
@Slf4j
@Component
public class JwtUtils {
    
    @Autowired
    private JwtConfig jwtConfig;
    
    /**
     * 生成Token
     */
    public String generateToken(Long userId, String username) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("username", username);
        claims.put("created", new Date());
        
        return generateToken(claims);
    }
    
    /**
     * 从数据声明生成Token
     */
    private String generateToken(Map<String, Object> claims) {
        Date expirationDate = new Date(System.currentTimeMillis() + jwtConfig.getExpiration() * 60 * 1000);
        
        return Jwts.builder()
                .setClaims(claims)
                .setExpiration(expirationDate)
                .signWith(SignatureAlgorithm.HS256, jwtConfig.getSecret())
                .compact();
    }
    
    /**
     * 从Token中获取声明
     */
    public Claims getClaimsFromToken(String token) {
        try {
            return Jwts.parser()
                    .setSigningKey(jwtConfig.getSecret())
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            log.error("JWT解析失败: {}", e.getMessage());
            return null;
        }
    }
    
    /**
     * 从Token中获取用户ID
     */
    public Long getUserIdFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims != null ? claims.get("userId", Long.class) : null;
    }
    
    /**
     * 从Token中获取用户名
     */
    public String getUsernameFromToken(String token) {
        Claims claims = getClaimsFromToken(token);
        return claims != null ? claims.get("username", String.class) : null;
    }
    
    /**
     * 验证Token是否有效
     */
    public boolean validateToken(String token) {
        try {
            Claims claims = getClaimsFromToken(token);
            if (claims == null) {
                return false;
            }
            
            Date expiration = claims.getExpiration();
            return !expiration.before(new Date());
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * 刷新Token
     */
    public String refreshToken(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims == null) {
            return null;
        }
        
        claims.put("created", new Date());
        return generateToken(claims);
    }
    
    /**
     * 获取Token剩余有效期（分钟）
     */
    public Long getRemainingExpiration(String token) {
        Claims claims = getClaimsFromToken(token);
        if (claims == null) {
            return 0L;
        }
        
        Date expiration = claims.getExpiration();
        long remaining = expiration.getTime() - System.currentTimeMillis();
        return remaining > 0 ? remaining / (60 * 1000) : 0;
    }
}
```

### 4. 创建JWT过滤器
创建 `JwtAuthenticationFilter.java`：

```java
package com.ruoyi.framework.filter;

import com.ruoyi.common.utils.JwtUtils;
import com.ruoyi.common.utils.StringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * JWT认证过滤器
 */
@Slf4j
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    
    @Autowired
    private JwtUtils jwtUtils;
    
    @Autowired
    private UserDetailsService userDetailsService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                   HttpServletResponse response, 
                                   FilterChain filterChain) 
            throws ServletException, IOException {
        
        // 获取Token
        String token = getTokenFromRequest(request);
        
        if (StringUtils.isNotEmpty(token)) {
            // 验证Token
            if (jwtUtils.validateToken(token)) {
                // 从Token中获取用户名
                String username = jwtUtils.getUsernameFromToken(token);
                
                if (StringUtils.isNotEmpty(username) && 
                    SecurityContextHolder.getContext().getAuthentication() == null) {
                    
                    // 加载用户信息
                    UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                    
                    // 创建认证Token
                    UsernamePasswordAuthenticationToken authentication = 
                            new UsernamePasswordAuthenticationToken(
                                    userDetails, 
                                    null, 
                                    userDetails.getAuthorities());
                    
                    authentication.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request));
                    
                    // 设置认证信息
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    
                    log.debug("JWT认证成功: {}", username);
                }
            } else {
                log.warn("JWT认证失败: Token无效或已过期");
            }
        }
        
        filterChain.doFilter(request, response);
    }
    
    /**
     * 从请求中获取Token
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        
        if (StringUtils.isNotEmpty(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        
        return null;
    }
    
    /**
     * 配置不需要JWT认证的路径
     */
    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String path = request.getServletPath();
        
        // 公开路径不需要JWT认证
        return path.startsWith("/api/auth/") || 
               path.startsWith("/swagger-ui/") || 
               path.startsWith("/v3/api-docs") ||
               path.startsWith("/h2-console") ||
               path.startsWith("/druid");
    }
}
```

### 5. 创建JWT认证控制器
创建 `JwtAuthController.java`：

```java
package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.JwtUtils;
import com.ruoyi.framework.shiro.service.SysLoginService;
import com.ruoyi.system.domain.SysUser;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * JWT认证控制器
 */
@Slf4j
@RestController
@RequestMapping("/api/auth")
@Api(tags = "JWT认证接口")
public class JwtAuthController {
    
    @Autowired
    private SysLoginService loginService;
    
    @Autowired
    private JwtUtils jwtUtils;
    
    /**
     * JWT登录接口
     */
    @PostMapping("/login")
    @ApiOperation("JWT登录")
    public AjaxResult login(@RequestParam String username, 
                           @RequestParam String password,
                           @RequestParam(required = false) Boolean rememberMe) {
        
        try {
            // 使用现有登录服务验证用户
            SysUser user = loginService.login(username, password);
            
            if (user == null) {
                return AjaxResult.error("用户名或密码错误");
            }
            
            // 生成JWT Token
            String token = jwtUtils.generateToken(user.getUserId(), user.getUserName());
            
            // 返回Token信息
            Map<String, Object> result = new HashMap<>();
            result.put("token", token);
            result.put("tokenType", "Bearer");
            result.put("expiresIn", jwtUtils.getRemainingExpiration(token));
            result.put("user", user);
            
            return AjaxResult.success("登录成功", result);
            
        } catch (Exception e) {
            log.error("JWT登录失败: {}", e.getMessage());
            return AjaxResult.error(e.getMessage());
        }
    }
    
    /**
     * 刷新Token接口
     */
    @PostMapping("/refresh")
    @ApiOperation("刷新Token")
    public AjaxResult refreshToken(HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        
        if (token == null) {
            return AjaxResult.error("Token不能为空");
        }
        
        String newToken = jwtUtils.refreshToken(token);
        
        if (newToken == null) {
            return AjaxResult.error("Token刷新失败");
        }
        
        Map<String, Object> result = new HashMap<>();
        result.put("token", newToken);
        result.put("tokenType", "Bearer");
        result.put("expiresIn", jwtUtils.getRemainingExpiration(newToken));
        
        return AjaxResult.success("Token刷新成功", result);
    }
    
    /**
     * 登出接口
     */
    @PostMapping("/logout")
    @ApiOperation("JWT登出")
    public AjaxResult logout(HttpServletRequest request) {
        // JWT是无状态的，客户端只需删除Token即可
        // 这里可以记录登出日志或加入Token黑名单（如果需要）
        log.info("用户登出");
        return AjaxResult.success("登出成功");
    }
    
    /**
     * 获取当前用户信息
     */
    @GetMapping("/me")
    @ApiOperation("获取当前用户信息")
    public AjaxResult getCurrentUser(HttpServletRequest request) {
        String token = getTokenFromRequest(request);
        
        if (token == null) {
            return AjaxResult.error("未认证");
        }
        
        Long userId = jwtUtils.getUserIdFromToken(token);
        String username = jwtUtils.getUsernameFromToken(token);
        
        if (userId == null || username == null) {
            return AjaxResult.error("Token无效");
        }
        
        // 获取用户详细信息
        SysUser user = loginService.getUserById(userId);
        
        if (user == null) {
            return AjaxResult.error("用户不存在");
        }
        
        // 隐藏敏感信息
        user.setPassword(null);
        user.setSalt(null);
        
        return AjaxResult.success(user);
    }
    
    /**
     * 验证Token接口
     */
    @PostMapping("/validate")
    @ApiOperation("验证Token")
    public AjaxResult validateToken(@RequestParam String token) {
        boolean isValid = jwtUtils.validateToken(token);
        
        if (isValid) {
            Long remaining = jwtUtils.getRemainingExpiration(token);
            Map<String, Object> result = new HashMap<>();
            result.put("valid", true);
            result.put("remainingMinutes", remaining);
            return AjaxResult.success("Token有效", result);
        } else {
            return AjaxResult.error("Token无效或已过期");
        }
    }
    
    /**
     * 从请求中获取Token
     */
    private String getTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        
        return null;
    }
}
```

### 6. 配置Spring Security（可选）
如果需要与Spring Security集成，创建 `SecurityConfig.java`：

```java
package com.ruoyi.framework.config;

import com.ruoyi.framework.filter.JwtAuthenticationFilter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

/**
 * Spring Security配置
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    
    @Autowired
    private UserDetailsService userDetailsService;
    
    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter;
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
    
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService)
            .passwordEncoder(passwordEncoder());
    }
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            // 禁用CSRF（JWT不需要）
            .csrf().disable()
            
            // 禁用Session（JWT是无状态的）
            .sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            
            .and()
            // 授权配置
            .authorizeRequests()
            // 公开路径
            .antMatchers(
                "/api/auth/**",
                "/swagger-ui/**",
                "/v3/api-docs/**",
                "/h2-console/**",
                "/druid/**"
            ).permitAll()
            
            // 其他请求需要认证
            .anyRequest().authenticated()
            
            .and()
            // 添加JWT过滤器
            .addFilterBefore(jwtAuthenticationFilter, 
                           UsernamePasswordAuthenticationFilter.class);
            
        // 允许iframe（H2控制台需要）
        http.headers().frameOptions().sameOrigin();
    }
}
```

### 7. 配置文件
在 `application.yml` 中添加JWT配置：

```yaml
# JWT配置
jwt:
  secret: project-management-system-secret-key-2026-03-10-change-in-production
  expiration: 120  # Token有效期（分钟）
  token-prefix: Bearer
  token-header: Authorization
  refresh-expiration: 7  # 刷新Token有效期（天）
```

## 🔐 JWT使用指南

### 1. 登录获取Token
```bash
# 请求
POST /api/auth/login
Content-Type: application/x-www-form-urlencoded

username=admin&password=admin123

# 响应
{
  "code": 200,
  "message": "登录成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "tokenType": "Bearer",
    "expiresIn": 119,
    "user": {
      "userId": 1,
      "userName": "admin",
      "nickName": "管理员"
    }
  }
}
```

### 2. 调用需要认证的接口
```bash
# 请求
GET /api/projects
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# 或使用Swagger测试
# 在Swagger界面点击 "Authorize" 按钮
# 输入: Bearer your-token-here
```

### 3. 刷新Token
```bash
# 请求
POST /api/auth/refresh
Authorization: Bearer old-token-here

# 响应
