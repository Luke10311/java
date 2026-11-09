/*
 Navicat Premium Dump SQL

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80039 (8.0.39)
 Source Host           : localhost:3306
 Source Schema         : meiying_shenbu

 Target Server Type    : MySQL
 Target Server Version : 80039 (8.0.39)
 File Encoding         : 65001

 Date: 09/11/2026 10:58:06
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '管理员账号（2-16位）',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '加盐 SHA-256 散列值',
  `real_name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '姓名/昵称',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最近登录时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_admin_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', 'bce9a1436b93252c385cfc1906f1ef656f6ceb9e95a17d1e39f001bb662d92d9', '中枢主事', NULL, '2026-11-09 10:53:51');

-- ----------------------------
-- Table structure for drama
-- ----------------------------
DROP TABLE IF EXISTS `drama`;
CREATE TABLE `drama`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧名',
  `year` smallint NOT NULL DEFAULT 2026 COMMENT '年份',
  `genres` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '悬疑' COMMENT '题材，多个用英文逗号分隔（悬疑,古装,武侠,奇幻,权谋）',
  `score` decimal(3, 1) NOT NULL DEFAULT 0.0 COMMENT '评分（0.0-10.0）',
  `views` int NOT NULL DEFAULT 0 COMMENT '播放热度',
  `episodes` int NOT NULL DEFAULT 1 COMMENT '总集数',
  `badge` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角标（独播/热播/新案，空为无）',
  `is_hot` tinyint NOT NULL DEFAULT 0 COMMENT '是否首页热播探案（1是 0否）',
  `poster` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '海报图片地址（/images/poster-x.jpg）',
  `hue_shift` smallint NOT NULL DEFAULT 0 COMMENT '海报调色偏移（hue-rotate 度数）',
  `hue` smallint NOT NULL DEFAULT 212 COMMENT '兜底渐变封面色相（0-360）',
  `synopsis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '剧情简介（详情页文字，后端就绪后启用）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '上架状态（1上架 0下架，后台管理用）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_hot`(`is_hot` ASC) USING BTREE,
  INDEX `idx_year`(`year` ASC) USING BTREE,
  INDEX `idx_views`(`views` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧集表（首页图片与文字内容）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of drama
-- ----------------------------
INSERT INTO `drama` VALUES (1, '长安夜行录', 2026, '悬疑,古装', 9.2, 98400, 36, '独播', 1, '/images/poster-1.jpg', 0, 212, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (2, '雪落无声', 2025, '悬疑,权谋', 8.9, 84200, 32, '热播', 1, '/images/poster-2.jpg', 0, 199, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (3, '千面魅影', 2026, '奇幻,悬疑', 8.7, 76300, 24, '新案', 1, '/images/poster-3.jpg', 0, 268, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (4, '铜雀台疑云', 2024, '古装,悬疑', 8.5, 69100, 40, '', 1, '/images/poster-4.jpg', 0, 24, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (5, '锦衣夜巡', 2025, '武侠,悬疑', 8.4, 52600, 30, '', 1, '/images/poster-5.jpg', 0, 340, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (6, '无头案卷', 2026, '悬疑', 8.2, 61800, 12, '新案', 1, '/images/poster-6.jpg', 0, 158, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (7, '洛阳纸贵', 2023, '古装,权谋', 8.0, 43700, 46, '', 1, '/images/poster-7.jpg', 0, 42, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (8, '江湖令', 2025, '武侠', 7.9, 38500, 28, '', 1, '/images/poster-8.jpg', 0, 186, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (9, '十二楼谜案', 2026, '悬疑', 8.8, 72500, 20, '独播', 0, '/images/poster-6.jpg', 200, 230, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (10, '孤城闭月', 2026, '古装,权谋', 8.6, 58300, 34, '新案', 0, '/images/poster-4.jpg', -30, 280, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (11, '夜半钟声', 2026, '悬疑,古装', 8.4, 55200, 28, '新案', 0, '/images/poster-2.jpg', 30, 204, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (12, '灯下黑', 2025, '悬疑,奇幻', 8.3, 47600, 26, '', 0, '/images/poster-3.jpg', 40, 300, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (13, '铁马冰河', 2024, '武侠,古装', 8.1, 41200, 38, '', 0, '/images/poster-8.jpg', -20, 18, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (14, '铜镜', 2023, '古装,悬疑', 7.9, 31800, 32, '', 0, '/images/poster-5.jpg', 160, 192, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (15, '断刃', 2025, '武侠', 7.8, 33400, 24, '', 0, '/images/poster-8.jpg', 25, 356, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (16, '洛阳春', 2024, '古装,权谋', 7.7, 29500, 42, '', 0, '/images/poster-7.jpg', -15, 36, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (17, '逆旅', 2025, '奇幻,权谋', 7.6, 26700, 22, '', 0, '/images/poster-3.jpg', -35, 274, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');
INSERT INTO `drama` VALUES (18, '白骨谣', 2023, '悬疑,奇幻', 7.5, 24300, 16, '', 0, '/images/poster-6.jpg', 160, 150, NULL, 1, '2026-11-09 10:53:51', '2026-11-09 10:53:51');

-- ----------------------------
-- Table structure for home_banner
-- ----------------------------
DROP TABLE IF EXISTS `home_banner`;
CREATE TABLE `home_banner`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `image_key` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片标识（hero=首页主视觉）',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片地址（/images/hero.jpg）',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片标题文字',
  `subtitle` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图片副标题文字',
  `link_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '点击跳转地址（空为不跳转）',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '展示顺序（小在前）',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用（1启用 0停用）',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_image_key`(`image_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页横幅图片资源' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_banner
-- ----------------------------
INSERT INTO `home_banner` VALUES (1, 'hero', '/images/hero.jpg', '魅影神捕', '缉影录 · 悬案未终，灯火不熄', '', 0, 1, '2026-11-09 10:53:51');

-- ----------------------------
-- Table structure for home_featured
-- ----------------------------
DROP TABLE IF EXISTS `home_featured`;
CREATE TABLE `home_featured`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `drama_id` bigint NOT NULL COMMENT '关联 drama.id',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧名',
  `sub` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '副标题（如：第一案 · 灯市无头尸）',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '推荐语/一句话案情',
  `tags` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '标签，逗号分隔（悬疑,古装,群像）',
  `score` decimal(3, 1) NOT NULL DEFAULT 0.0 COMMENT '评分',
  `badge` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '角标（本周推荐）',
  `poster` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '海报图片地址',
  `hue` smallint NOT NULL DEFAULT 212 COMMENT '兜底渐变封面色相',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '展示顺序（小在前）',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用（1启用 0停用）',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_drama`(`drama_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页精选一案（主视觉图+文字）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_featured
-- ----------------------------
INSERT INTO `home_featured` VALUES (1, 1, '长安夜行录', '第一案 · 灯市无头尸', '上元灯市，三十七盏花灯尽数熄灭。死者颈上无痕，掌心却攥着一枚卖灯人的铜钱。', '悬疑,古装,群像', 9.2, '本周推荐', '/images/poster-1.jpg', 212, 0, 1, '2026-11-09 10:53:51');

-- ----------------------------
-- Table structure for home_rank
-- ----------------------------
DROP TABLE IF EXISTS `home_rank`;
CREATE TABLE `home_rank`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `drama_id` bigint NOT NULL COMMENT '关联 drama.id',
  `heat_label` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '热度文字（如：9.8 万）',
  `trend` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'flat' COMMENT '趋势（up/flat/down）',
  `rank_position` int NOT NULL DEFAULT 0 COMMENT '榜单名次（1 开始）',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用（1启用 0停用）',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_drama`(`drama_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页悬案榜' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of home_rank
-- ----------------------------
INSERT INTO `home_rank` VALUES (1, 1, '9.8 万', 'up', 1, 1, '2026-11-09 10:53:51');
INSERT INTO `home_rank` VALUES (2, 3, '8.4 万', 'up', 2, 1, '2026-11-09 10:53:51');
INSERT INTO `home_rank` VALUES (3, 6, '7.6 万', 'flat', 3, 1, '2026-11-09 10:53:51');
INSERT INTO `home_rank` VALUES (4, 2, '6.9 万', 'down', 4, 1, '2026-11-09 10:53:51');
INSERT INTO `home_rank` VALUES (5, 5, '5.2 万', 'flat', 5, 1, '2026-11-09 10:53:51');

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
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '魅影神捕用户表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `user` VALUES (10, '5555', 'a6e8402bcc56c45f77ebe88d72691a5fd7d1d1e5e767c8162c567b101d4193f7', '2026-11-09 10:40:38');

SET FOREIGN_KEY_CHECKS = 1;
