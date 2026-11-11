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

 Date: 11/11/2026 09:51:14
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
INSERT INTO `admin_user` VALUES (1, 'admin', 'bce9a1436b93252c385cfc1906f1ef656f6ceb9e95a17d1e39f001bb662d92d9', '中枢主事', '2026-11-11 09:15:01', '2026-11-11 09:10:48');

-- ----------------------------
-- Table structure for case_file
-- ----------------------------
DROP TABLE IF EXISTS `case_file`;
CREATE TABLE `case_file`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `case_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卷号（甲字第〇二六卷）',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '案名',
  `tag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '题签（疑涉妖异/关联三案…）',
  `description` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '案情摘要（卡片上的一段话）',
  `place` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '案发地',
  `status` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '缉查中' COMMENT '状态（缉查中/待复核/已封卷）',
  `reward` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '悬赏文案',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '案卷插图地址',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '完整卷宗（详情页正文）',
  `is_active` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用（1启用 0停用）',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '案卷表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of case_file
-- ----------------------------
INSERT INTO `case_file` VALUES (101, '甲字第〇一七卷', '孩童失踪案', '紧急缉查', '三日之内，镇上七名孩童接连消失。长街尽头只余一只布老虎、半截断线纸鸢，和一张被夜雨泡烂的寻人告示。', '斗鼔县', '缉查中', '悬赏 六千两', '/images/case-1.jpg', '九月初九起，青石镇连失七名孩童，皆在戌时前后不见踪影。失踪地点分布在长街两端，间距相近，却无人听见呼喊。现场不留脚印，只有孩童随身之物：布老虎、纸鸢、糖人、木陀螺……被齐整地摆在青石板正中，像是谁一件件放回去的。仵作验过街面，未见拖拽痕迹；更夫发誓那三夜「灯灭之后，街上无人」。', 1, '2026-11-11 09:10:58', '2026-11-11 09:29:23');
INSERT INTO `case_file` VALUES (102, '甲字第〇一八卷', '皮影戏杀人案', '血案三起', '戏班每到一地，必出一桩命案。幕布上分明映出握刀的影子，台下灯影里，却只摆着一把空了三日的太师椅。', '金龙阁', '缉查中', '悬赏 九千两', '/images/case-2.jpg', '「影双班」沿运河卖艺，一处码头一出戏，一处戏文一桩命。三起命案的死者身份各异，死状却出奇一致：心口中刀，尸身边端正摆着一枚皮影人偶。目击者众口一词——出事那刻，幕布上的皮影「提刀人」多出一道影子。班主喊冤：班里十二副皮影，没有一副叫提刀人。', 1, '2026-11-11 09:10:58', '2026-11-11 09:27:48');
INSERT INTO `case_file` VALUES (103, '甲字第〇〇九卷', '灯市无头案', '关联第一案', '上元夜三十七盏花灯齐灭，死者颈上无痕，掌心却攥着一枚卖灯人的铜钱。城楼那盏长明灯，那夜多亮了半个时辰。', '长安上元灯市', '待复核', '悬赏 五千两', '/images/case-3.jpg', '上元灯会，人潮如织。子时三刻，御街三十七盏花灯同时熄灭，一片惊呼里，卖灯人倒在自己的灯车旁——颈上无痕、无伤、无毒，掌心却攥着半枚铜钱，断口新茬，另一半不知去向。当夜唯有城楼长明灯多亮了半个时辰，守楼老兵说，那半个时辰里「灯影里站着两个人」。', 1, '2026-11-11 09:10:58', '2026-11-11 09:10:58');
INSERT INTO `case_file` VALUES (104, '甲字第〇二一卷', '画皮新娘案', '疑涉妖异', '新娘拜堂前夜凭空消失，大红嫁衣犹在架上。铜镜里映得出嫁衣的轮廓，映不出穿嫁衣的人。', '临安柳府', '缉查中', '悬赏 两千两', '/images/case-4.jpg', '柳家小姐柳眉儿定于八月初一出阁。七月三十夜里，陪嫁丫鬟听见闺房有梳头声，推门却空无一人——嫁衣挂在架上，晨起再验，衣领内衬多了一行绣字：「镜中人不是我」。柳府上下封口，柳员外却坚持照期迎亲：花轿进门，掀开轿帘，端坐其中的「新娘」蒙着盖头，谁也没敢掀。', 1, '2026-11-11 09:10:58', '2026-11-11 09:10:58');
INSERT INTO `case_file` VALUES (105, '甲字第〇一三卷', '镜中魅影案', '司天监密档', '书吏夜夜对镜自语，晨起时镜中人比他年轻十岁。第七夜之后，镜里再没有人，镜外也再没有人来点过卯。', '翰林书院', '已封卷', '悬赏 一千两', '/images/case-5.jpg', '翰林书院抄书吏陆文安，连着七夜被同斋书生听见「对镜低语」。同僚打趣，他只答一句：「我在同旧年的自己算账。」第七夜之后，陆文安没有再来点卯——斋房整洁如常，案上铜镜蒙尘，镜面里那道白色人影，却在每天寅时准时出现一炷香。司天监介入后此案被封卷，卷宗首页只批了四个字：「勿拭此镜」。', 1, '2026-11-11 09:10:58', '2026-11-11 09:10:58');
INSERT INTO `case_file` VALUES (106, '甲字第〇二四卷', '漕船沉银案', '钦命督办', '三十万两官银沉入河湾。打捞上来的漕船舱底不见官银，只堆着湿透的稻壳——以及一副多出来的骸骨。', '淮安河湾渡口', '缉查中', '悬赏 八千两', '/images/case-6.jpg', '押运三十万两税银的漕船在淮安河湾夜遇风浪倾覆。船工十四人获救十三人，打捞三日后捞起船体：银舱完好，舱里却没有银子，只有齐舱深的湿稻壳，和一副不属于任何船工的骸骨——骸骨双手戴枷，枷上封条写着一个「漕」字。户部连夜封河，钦差次日抵达，第一句话是：「先别捞第二艘。」', 1, '2026-11-11 09:10:58', '2026-11-11 09:10:58');
INSERT INTO `case_file` VALUES (107, '甲字第〇二五卷', '魔匣凶杀案', '预告案', '一只无人认领的黑漆木匣在幽州明德街辗转三户，谁收匣谁毙命。匣上锁孔完好，匣内却总比昨日多出一物。', '皇宫', '缉查中', '悬赏 六千两', '/images/case-7.jpg', '冬月初二清晨，幽州明德街当铺「明德号」门缝里被人塞进一只黑漆木匣，无署名、无封条，锁孔完好如新。当铺朝奉收匣当夜暴毙，七窍无血，双目圆睁，右手死死攥着匣盖。此后木匣接连辗转两户：拾匣的货郎、买匣的古董商，皆在一夜之间毙命，死状如出一辙。诡异的是，仵作每验一次尸，匣中便多出一样死者生前之物——朝奉的当票、货郎的铜哨、古董商的半块玉佩。神捕司提匣回衙途中，匣身忽重三斤，随行捕快发誓听见匣内有指甲刮木之声。', 1, '2026-11-11 09:10:58', '2026-11-11 09:26:05');
INSERT INTO `case_file` VALUES (108, '甲字第〇二六卷', '香消玉殒枯血案', '疑涉妖异', '死者周身无伤，全身血却被人抽干，尸身边齐齐开着一丛紫花。仵作说那花吸饱了人血，开得比生前任何时候都艳。', '聚星楼等各地', '缉查中', '悬赏 七千两', '/images/case-8.jpg', '半月之内，云梦泽落花坞接连抬出五具女尸。死者个个衣衫齐整、周身无伤，可全身血竟被抽得一干二净，皮肉白得像浸过雪水的纸。最奇的是每具尸身旁都齐齐开着一丛紫花，花大如盆，花瓣上凝着未干的血珠——严三火验明，那花吸饱了人血，离了尸体便三日枯死。坊间传言，落花坞深处有一株「枯血妖莲」，专引迷路女子近前；黎青阳却在第五具尸体的指缝里，找到了一缕不属于任何死者的金线。', 1, '2026-11-11 09:10:58', '2026-11-11 09:25:38');
INSERT INTO `case_file` VALUES (109, '甲字第〇二七卷', '识骨寻母连环浮尸案', '关联三案', '运河上接连浮起三具白骨，骨龄相差二十年。每一具的腕骨上，都系着同一枚褪色的长命锁——锁底刻的名字，各不相同。', '明岭县', '待复核', '悬赏 一万两', '/images/case-9.jpg', '芦花渡的渔人三日捞起一具浮尸，捞起三具才发现不对：尸身早已白骨，骨龄却相差二十年——最老的一具沉河至少廿载，最新的不过三年。严三火验骨时发现，三具白骨的腕骨上都系着一枚长命锁，银色、形制、磨损一模一样，锁底刻的名字却各不相同。白珍珠查出，那长命锁是二十年前江南「沈记银楼」的样式，当年只打制过三枚，买主是同一个女人。神捕司循银楼账册追查，账册最后一页被人撕去，而那个女人，正是二十年前抱着孩子投河、尸身始终未寻获的「沈家弃妇」。', 1, '2026-11-11 09:10:58', '2026-11-11 09:24:32');

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
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧集表（首页图片与文字内容）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of drama
-- ----------------------------
INSERT INTO `drama` VALUES (1, '长安夜行录', 2026, '悬疑,古装', 9.2, 98432, 36, '独播', 1, '/images/poster-1.jpg', 0, 212, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:22:43');
INSERT INTO `drama` VALUES (2, '雪落无声', 2025, '悬疑,权谋', 8.9, 84200, 32, '热播', 1, '/images/poster-2.jpg', 0, 199, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (3, '千面魅影', 2026, '奇幻,悬疑', 8.7, 76300, 24, '新案', 1, '/images/poster-3.jpg', 0, 268, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (4, '铜雀台疑云', 2024, '古装,悬疑', 8.5, 69100, 40, '', 1, '/images/poster-4.jpg', 0, 24, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (5, '锦衣夜巡', 2025, '武侠,悬疑', 8.4, 52600, 30, '', 1, '/images/poster-5.jpg', 0, 340, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (6, '无头案卷', 2026, '悬疑', 8.2, 61800, 12, '新案', 1, '/images/poster-6.jpg', 0, 158, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (7, '洛阳纸贵', 2023, '古装,权谋', 8.0, 43700, 46, '', 1, '/images/poster-7.jpg', 0, 42, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (8, '江湖令', 2025, '武侠', 7.9, 38500, 28, '', 1, '/images/poster-8.jpg', 0, 186, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (9, '十二楼谜案', 2026, '悬疑', 8.8, 72500, 20, '独播', 0, '/images/poster-6.jpg', 200, 230, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (10, '孤城闭月', 2026, '古装,权谋', 8.6, 58300, 34, '新案', 0, '/images/poster-4.jpg', -30, 280, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (11, '夜半钟声', 2026, '悬疑,古装', 8.4, 55200, 28, '新案', 0, '/images/poster-2.jpg', 30, 204, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (12, '灯下黑', 2025, '悬疑,奇幻', 8.3, 47600, 26, '', 0, '/images/poster-3.jpg', 40, 300, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (13, '铁马冰河', 2024, '武侠,古装', 8.1, 41200, 38, '', 0, '/images/poster-8.jpg', -20, 18, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (14, '铜镜', 2023, '古装,悬疑', 7.9, 31800, 32, '', 0, '/images/poster-5.jpg', 160, 192, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (15, '断刃', 2025, '武侠', 7.8, 33400, 24, '', 0, '/images/poster-8.jpg', 25, 356, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (16, '洛阳春', 2024, '古装,权谋', 7.7, 29500, 42, '', 0, '/images/poster-7.jpg', -15, 36, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (17, '逆旅', 2025, '奇幻,权谋', 7.6, 26700, 22, '', 0, '/images/poster-3.jpg', -35, 274, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (18, '白骨谣', 2023, '悬疑,奇幻', 7.5, 24300, 16, '', 0, '/images/poster-6.jpg', 160, 150, NULL, 1, '2026-11-11 09:10:48', '2026-11-11 09:10:48');
INSERT INTO `drama` VALUES (19, '飞升得道·伪仙案', 2026, '悬疑,奇幻', 8.6, 66800, 24, '新案', 1, '/images/poster-19.webp', 0, 268, '青云山观主白日飞升，万人朝贺。仵作验尸却发现「仙蜕」指甲缝里嵌着人间香灰——飞升是假，借雷火毁尸灭迹是真。捕快循着一场大雨追入道观，香客口中的仙迹，桩桩都指向了三十年前的一桩皮影旧案。', 1, '2026-11-11 09:39:29', '2026-11-11 09:39:29');

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
INSERT INTO `home_banner` VALUES (1, 'hero', '/images/hero.jpg', '魅影神捕', '缉影录 · 悬案未终，灯火不熄', '', 0, 1, '2026-11-11 09:10:48');

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
INSERT INTO `home_featured` VALUES (1, 1, '长安夜行录', '第一案 · 灯市无头尸', '上元灯市，三十七盏花灯尽数熄灭。死者颈上无痕，掌心却攥着一枚卖灯人的铜钱。', '悬疑,古装,群像', 9.2, '本周推荐', '/images/poster-1.jpg', 212, 0, 1, '2026-11-11 09:10:48');

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
INSERT INTO `home_rank` VALUES (1, 1, '9.8 万', 'up', 1, 1, '2026-11-11 09:10:48');
INSERT INTO `home_rank` VALUES (2, 3, '8.4 万', 'up', 2, 1, '2026-11-11 09:10:48');
INSERT INTO `home_rank` VALUES (3, 6, '7.6 万', 'flat', 3, 1, '2026-11-11 09:10:48');
INSERT INTO `home_rank` VALUES (4, 2, '6.9 万', 'down', 4, 1, '2026-11-11 09:10:48');
INSERT INTO `home_rank` VALUES (5, 5, '5.2 万', 'flat', 5, 1, '2026-11-11 09:10:48');

-- ----------------------------
-- Table structure for site_config
-- ----------------------------
DROP TABLE IF EXISTS `site_config`;
CREATE TABLE `site_config`  (
  `config_key` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '配置值',
  `label` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '中文名（后台展示用）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '说明',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_key`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '站点配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of site_config
-- ----------------------------
INSERT INTO `site_config` VALUES ('home_hero', '/images/hero.jpg', '首页主视觉', '首页横幅大图地址', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('maintenance', '0', '维护模式', '1 开启后前台提示维护中，0 正常开放', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_name', '魅影神捕', '站点名称', '显示在浏览器标题与页头', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_notice', '本季新案已上卷，灯市无头尸一案敬请追查。', '全站公告', '前台顶部公告文字，留空则不显示', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_subtitle', '探案录 · 悬疑剧集', '站点副标题', '页头站名下方的小字', '2026-11-11 09:10:58');

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
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '魅影神捕用户表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `user` VALUES (12, '6666', '82b4ef68acb946aee9bce2193095e83c47b29046101a7629069d1f1907e23ad5', '2026-11-11 09:06:47');

SET FOREIGN_KEY_CHECKS = 1;
