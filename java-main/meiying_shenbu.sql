/*
 Navicat MySQL Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : meiying_shenbu

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 14/10/2026 09:45:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '捕快名号（2-16位）',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '加盐 SHA-256 散列值',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '入籍时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '魅影神捕用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'shenbu_test', '017f876ef734b1cbcf859c76ff4b902bd8df74154715339b6ade2f051308f868', '2026-10-14 08:47:04');
INSERT INTO `user` VALUES (2, 'test_user1', '017f876ef734b1cbcf859c76ff4b902bd8df74154715339b6ade2f051308f868', '2026-10-12 10:57:15');
INSERT INTO `user` VALUES (3, '青阳神捕', '6ba05b0ccd4fd6ca2a75b57e9e9f8cdd03155743eb73bb8cfb26a26ce695b61e', '2026-10-12 11:10:07');
INSERT INTO `user` VALUES (4, '铁捕', '6ba05b0ccd4fd6ca2a75b57e9e9f8cdd03155743eb73bb8cfb26a26ce695b61e', '2026-10-12 11:10:25');
INSERT INTO `user` VALUES (5, '222', '6ba05b0ccd4fd6ca2a75b57e9e9f8cdd03155743eb73bb8cfb26a26ce695b61e', '2026-10-12 11:10:34');
INSERT INTO `user` VALUES (6, 'verify_113999', '6de6de1f8a9e68de00a7a0aeea406c77adda842e6a8b9dad118735950a2f4c0f', '2026-10-12 11:18:34');
INSERT INTO `user` VALUES (7, 'itest_145190', '6de6de1f8a9e68de00a7a0aeea406c77adda842e6a8b9dad118735950a2f4c0f', '2026-10-12 11:19:05');

SET FOREIGN_KEY_CHECKS = 1;
