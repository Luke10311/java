-- ============================================================
--  springBootTest —— 登录/注册模块 数据库初始化脚本
--  对应实体：com.fenglin.springboottest.entity.User（表名 user）
--  数据库：MySQL 8.x    账号：root / 123456
--
--  执行方式（任选其一）：
--    1) 命令行：mysql -h127.0.0.1 -uroot -p123456 < init.sql
--    2) Navicat / DataGrip / IDEA 里直接打开本文件整体运行
--
--  脚本可重复执行：均使用 IF NOT EXISTS / INSERT IGNORE
-- ============================================================

-- 1. 建库
CREATE DATABASE IF NOT EXISTS `meiying_shenbu`
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE `meiying_shenbu`;

-- 2. 建表
CREATE TABLE IF NOT EXISTS `user` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username`   VARCHAR(16)  NOT NULL                COMMENT '捕快名号（2-16位）',
  `password`   VARCHAR(255) NOT NULL                COMMENT '加盐 SHA-256 散列值',
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入籍时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '用户表';

-- ============================================================
-- 3. 可选：内置一个演示账号，方便一上来就能登录
--    名号：shenbu_test      令牌：123456
--    （散列算法 = SHA-256( "myss::shenbu::2026" + 明文 )，
--      与 PasswordUtil 完全一致；不想要就删掉这一行）
-- ============================================================
INSERT IGNORE INTO `user` (`username`, `password`) VALUES
  ('shenbu_test', '017f876ef734b1cbcf859c76ff4b902bd8df74154715339b6ade2f051308f868');

-- 4. 查看结果
SELECT `id`, `username`, `created_at` FROM `user`;
