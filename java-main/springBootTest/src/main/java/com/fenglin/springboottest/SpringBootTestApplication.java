package com.fenglin.springboottest;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 启动类。
 *
 * <p>{@code @MapperScan} 让 MyBatis-Plus 扫描并生成 Mapper 代理，
 * 有了它 Mapper 接口上就不必再逐个写 {@code @Mapper}。</p>
 */
@SpringBootApplication
@MapperScan("com.fenglin.springboottest.mapper")
public class SpringBootTestApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootTestApplication.class, args);
	}

}
