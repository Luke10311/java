package com.meiying.shenbu;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.meiying.shenbu.mapper")
public class ShenbuApplication {
    public static void main(String[] args) {
        SpringApplication.run(ShenbuApplication.class, args);
    }
}
