package com.fenglin.springboottest.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * 跨域配置。
 *
 * <p>开发时 Vue 走 Vite 代理（vite.config.js 把 /api 转发到 8080），本不会触发跨域；
 * 这里放开是为了让浏览器直连 {@code http://localhost:8080/api/...} 调试时也能用，
 * 以及方便用 Postman 之外的在线工具联调。</p>
 */
@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                // allowCredentials(true) 时不能用 "*"，用 OriginPattern 放宽
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
