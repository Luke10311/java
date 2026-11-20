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

 Date: 20/11/2026 16:36:54
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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '后台管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', 'bce9a1436b93252c385cfc1906f1ef656f6ceb9e95a17d1e39f001bb662d92d9', '中枢主事', '2026-11-16 11:39:23', '2026-11-11 09:10:48');

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
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '案卷表' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '剧集表（首页图片与文字内容）' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页横幅图片资源' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页精选一案（主视觉图+文字）' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '首页悬案榜' ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '站点配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of site_config
-- ----------------------------
INSERT INTO `site_config` VALUES ('home_hero', '/images/hero.jpg', '首页主视觉', '首页横幅大图地址', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('maintenance', '0', '维护模式', '1 开启后前台提示维护中，0 正常开放', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_name', '魅影神捕', '站点名称', '显示在浏览器标题与页头', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_notice', '本季新案已上卷，灯市无头尸一案敬请追查。', '全站公告', '前台顶部公告文字，留空则不显示', '2026-11-11 09:10:58');
INSERT INTO `site_config` VALUES ('site_subtitle', '探案录 · 悬疑剧集', '站点副标题', '页头站名下方的小字', '2026-11-11 09:10:58');

-- ----------------------------
-- Table structure for team_answer
-- ----------------------------
DROP TABLE IF EXISTS `team_answer`;
CREATE TABLE `team_answer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '捕快名号',
  `q_index` int NOT NULL COMMENT '题号(0起)',
  `option_idx` int NOT NULL DEFAULT -1 COMMENT '所选选项下标',
  `is_correct` tinyint NOT NULL DEFAULT 0 COMMENT '是否正确',
  `scored` tinyint NOT NULL DEFAULT 0 COMMENT '是否已计分(防重复刷分)',
  `points` int NOT NULL DEFAULT 0 COMMENT '得分',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近作答时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_user_q`(`room_code` ASC, `username` ASC, `q_index` ASC) USING BTREE,
  INDEX `fk_answer_room`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-推理作答表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_answer
-- ----------------------------

-- ----------------------------
-- Table structure for team_clue_found
-- ----------------------------
DROP TABLE IF EXISTS `team_clue_found`;
CREATE TABLE `team_clue_found`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌',
  `clue_key` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '线索点标识(c1~c9)',
  `found_by` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '首个找到的捕快',
  `points` int NOT NULL DEFAULT 0 COMMENT '得分',
  `found_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '找到时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_clue`(`room_code` ASC, `clue_key` ASC) USING BTREE,
  INDEX `fk_found_room`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-线索发现表(全队共享,首得者得分)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_clue_found
-- ----------------------------

-- ----------------------------
-- Table structure for team_game_log
-- ----------------------------
DROP TABLE IF EXISTS `team_game_log`;
CREATE TABLE `team_game_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '行为人名号',
  `log_text` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '日志内容',
  `ts` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发生时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_log_room`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-探案日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_game_log
-- ----------------------------

-- ----------------------------
-- Table structure for team_member
-- ----------------------------
DROP TABLE IF EXISTS `team_member`;
CREATE TABLE `team_member`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '捕快名号',
  `score` int NOT NULL DEFAULT 0 COMMENT '本局积分',
  `joined_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_user`(`room_code` ASC, `username` ASC) USING BTREE,
  INDEX `fk_member_room`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-成员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_member
-- ----------------------------

-- ----------------------------
-- Table structure for team_quest
-- ----------------------------
DROP TABLE IF EXISTS `team_quest`;
CREATE TABLE `team_quest`  (
  `id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本ID，与前端 quest.id 一致',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '展示顺序',
  `case_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '卷号（甲字第〇二六卷）',
  `title` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '案名',
  `subtitle` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '副标题',
  `place` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '案发地',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '案卷图标(emoji)',
  `accent` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '主题色(#d94a42)',
  `difficulty` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '难度星级',
  `duration` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '预计时长',
  `brief` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '案情简介',
  `culprit` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '真凶(suspect id)',
  `reveal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '真相揭晓文案',
  `scene_count` int NOT NULL DEFAULT 0 COMMENT '勘查场景数',
  `question_count` int NOT NULL DEFAULT 0 COMMENT '推理题数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-剧本主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_quest
-- ----------------------------
INSERT INTO `team_quest` VALUES ('q101', 3, '甲字第〇二九卷', '孩童失踪案', '青石镇 · 长街', '青石镇 · 长街', '🧸', '#2b7a6b', '★☆☆', '约 4 分钟', '三日之内，镇上七名孩童接连消失。长街尽头只余一只布老虎、半截断线纸鸢，和一张被夜雨泡烂的寻人告示。有小孩说，夜里看见「糖摊的老婆婆」笑着招手。请与同行神捕循着麦芽糖的甜香，找出掳走孩童的人。', 'p1', '糖摊婆婆以掺了蒙汗药的麦芽糖诱晕孩童，再由被她胁迫的绣坊哑女缝制布老虎、提供藏匿地窖，把孩子\"送\"出去换取银钱。哑女身不由己，罪不至重；主谋糖摊婆婆被当场拿下，七名孩童平安归家。青石镇长街，重新响起孩童的笑闹声。', 3, 3);
INSERT INTO `team_quest` VALUES ('q107', 2, '甲字第〇二五卷', '魔匣凶杀案', '幽州 · 明德街', '幽州 · 明德街', '📦', '#8e6bd0', '★★★', '约 6 分钟', '一只无人认领的黑漆木匣在明德街辗转三户，谁收匣谁毙命。匣上锁孔完好，匣内却总比昨日多出一物——当票、铜哨、半块玉佩。更诡异的是，三名死者毙命当夜，更夫都没有打过三更。神捕司提匣回衙途中，匣身忽重三斤，随行捕快发誓听见匣内有指甲刮木之声。', 'p1', '「魔匣」是更夫周泰设的局。匣中机关藏毒针，他利用三更不报时的空档潜入，以匣诱人收下、暗中触发机关杀人，取走死者身上财物，再留下一件遗物故弄玄虚。「取一还三」即取一命、留三物以乱视听。所谓匣中鬼声，不过是机关鼠作祟。周泰落网，明德街夜半重闻三更声。', 3, 3);
INSERT INTO `team_quest` VALUES ('q108', 1, '甲字第〇二六卷', '香消玉殒枯血案', '落花坞 · 妖莲纳血', '云梦泽 · 落花坞', '🌺', '#d94a42', '★★☆', '约 5 分钟', '半月之内，落花坞接连抬出五具女尸。死者衣衫齐整、周身无伤，血却被抽得一干二净，尸身旁齐齐开着一丛紫花。坊间传言坞中有一株「枯血妖莲」，专引迷路女子近前。神捕司封泽查案，请你与同行神捕查清：所谓妖莲，究竟是真是假？谁是真凶？', 'p1', '所谓「枯血妖莲」是洛夫人编出的鬼话。她用醉仙草迷晕过路女子，以乌盆紫花吸血制一种驻颜邪药，金线来自她那件官造织金袍——她原是获罪官员的遗孀。所谓妖莲从不存在，只有人心贪妄。洛夫人认罪伏法，落花坞封锁查抄。', 3, 3);

-- ----------------------------
-- Table structure for team_quest_clue
-- ----------------------------
DROP TABLE IF EXISTS `team_quest_clue`;
CREATE TABLE `team_quest_clue`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `quest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本ID',
  `scene_key` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所属场景(s1等)',
  `clue_key` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '线索点标识(c1~c9)',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '场景内顺序',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '可疑点名称',
  `icon` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '图标(emoji)',
  `found_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '查得的线索内容',
  `points` int NOT NULL DEFAULT 0 COMMENT '积分',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quest_clue`(`quest_id` ASC, `clue_key` ASC) USING BTREE,
  INDEX `fk_clue_quest`(`quest_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-线索点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_quest_clue
-- ----------------------------
INSERT INTO `team_quest_clue` VALUES (1, 'q108', 's1', 'c1', 1, '尸身', '🧍', '死者周身无伤，唯十指指尖泛青，像是中毒而非被杀。', 10);
INSERT INTO `team_quest_clue` VALUES (2, 'q108', 's1', 'c2', 2, '紫花丛', '🌸', '花瓣凝血、根须却白得发亮——花是被人移种到这里，吸了血才开。', 10);
INSERT INTO `team_quest_clue` VALUES (3, 'q108', 's1', 'c3', 3, '泥中脚印', '👣', '尸体周围只有一行男人的大脚印，来路方向通向坞主宅院。', 15);
INSERT INTO `team_quest_clue` VALUES (4, 'q108', 's2', 'c4', 1, '血样', '🩸', '五名死者血中都有同一种迷香成分，闻之令人神志恍惚。', 15);
INSERT INTO `team_quest_clue` VALUES (5, 'q108', 's2', 'c5', 2, '指缝金线', '🧵', '第五名死者指缝里攥着一缕织金线，是官造贡品的料子。', 15);
INSERT INTO `team_quest_clue` VALUES (6, 'q108', 's2', 'c6', 3, '香灰', '🕯️', '棚角香炉灰里混着「醉仙草」——落花坞坞主上月刚采买过一批。', 20);
INSERT INTO `team_quest_clue` VALUES (7, 'q108', 's3', 'c7', 1, '账册', '📖', '账册记着每月采买醉仙草与大批乌盆，用途栏写着「养花」。', 15);
INSERT INTO `team_quest_clue` VALUES (8, 'q108', 's3', 'c8', 2, '贡品匣', '📦', '匣中是一件官造织金袍，袖口恰好缺了一缕——与死者指缝金线同源。', 20);
INSERT INTO `team_quest_clue` VALUES (9, 'q108', 's3', 'c9', 3, '后门小船', '🛶', '后门泊着一条小船，船底沾着与现场一致的湿泥。', 10);
INSERT INTO `team_quest_clue` VALUES (10, 'q107', 's1', 'c1', 1, '黑漆木匣', '📦', '匣身锁孔完好无损，匣盖边缘却有从内向外顶开的抓痕。', 15);
INSERT INTO `team_quest_clue` VALUES (11, 'q107', 's1', 'c2', 2, '匣底刻字', '🔤', '匣底一行几乎磨平的小字：「明德高悬，取一还三」。', 20);
INSERT INTO `team_quest_clue` VALUES (12, 'q107', 's1', 'c3', 3, '当票', '🎫', '匣中第一件遗物是当票，底下压着当铺最后一笔账：当的是一面铜镜。', 10);
INSERT INTO `team_quest_clue` VALUES (13, 'q107', 's2', 'c4', 1, '铜哨', '🎵', '货郎的铜哨出现在匣中，哨口有细微的齿痕。', 10);
INSERT INTO `team_quest_clue` VALUES (14, 'q107', 's2', 'c5', 2, '半块玉佩', '💠', '古董商的半块玉佩，断口新鲜——像是被人强行掰开。', 10);
INSERT INTO `team_quest_clue` VALUES (15, 'q107', 's2', 'c6', 3, '更鼓', '🥁', '两名死者都住在更夫值房附近，三夜更夫都没打三更。', 20);
INSERT INTO `team_quest_clue` VALUES (16, 'q107', 's3', 'c7', 1, '匣内夹层', '🔎', '撬开夹层，里面藏着一张明德街的巡更路线图，三更那段被人划掉。', 20);
INSERT INTO `team_quest_clue` VALUES (17, 'q107', 's3', 'c8', 2, '机关', '⚙️', '匣盖内侧有弹簧机关，从内一顶便弹开，可夹带毒针。', 15);
INSERT INTO `team_quest_clue` VALUES (18, 'q107', 's3', 'c9', 3, '刮木声', '🔊', '所谓「指甲刮木」是机关里一只被困的机关鼠，定时触发。', 15);
INSERT INTO `team_quest_clue` VALUES (19, 'q101', 's1', 'c1', 1, '布老虎', '🧸', '布老虎的填充物是自家缝的粗布，针脚与城西绣坊手法一致。', 15);
INSERT INTO `team_quest_clue` VALUES (20, 'q101', 's1', 'c2', 2, '断线纸鸢', '🪁', '纸鸢线断口沾着麦芽糖浆，甜香在夜里能飘出很远。', 15);
INSERT INTO `team_quest_clue` VALUES (21, 'q101', 's1', 'c3', 3, '寻人告示', '📜', '告示被雨泡烂，但落款处盖着糖摊的朱记。', 10);
INSERT INTO `team_quest_clue` VALUES (22, 'q101', 's2', 'c4', 1, '糖锅', '🍯', '糖锅里除了麦芽糖，还掺着少量蒙汗药，闻久了会犯困。', 20);
INSERT INTO `team_quest_clue` VALUES (23, 'q101', 's2', 'c5', 2, '货筐', '🧺', '筐底藏着几缕孩童的青丝，与失踪孩童发色一致。', 15);
INSERT INTO `team_quest_clue` VALUES (24, 'q101', 's2', 'c6', 3, '供货单', '🧾', '供货单上写着「绣坊·哑女」，麦芽糖与粗布都从那里来。', 20);
INSERT INTO `team_quest_clue` VALUES (25, 'q101', 's3', 'c7', 1, '地窖', '🕳️', '地窖里锁着七名孩童，都昏睡着，安然无恙。', 15);
INSERT INTO `team_quest_clue` VALUES (26, 'q101', 's3', 'c8', 2, '绣坊哑女', '👩‍🦯', '哑女比比划划：她被人胁迫，糖摊老婆婆才是主谋。', 10);
INSERT INTO `team_quest_clue` VALUES (27, 'q101', 's3', 'c9', 3, '账本', '📒', '账本记着每\"送\"一个孩子，就从外头领一笔银子。', 20);

-- ----------------------------
-- Table structure for team_quest_question
-- ----------------------------
DROP TABLE IF EXISTS `team_quest_question`;
CREATE TABLE `team_quest_question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `quest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本ID',
  `q_index` int NOT NULL COMMENT '题号(0起)',
  `question` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '题干',
  `options_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '选项JSON数组',
  `answer` int NOT NULL DEFAULT 0 COMMENT '正确选项下标',
  `explain` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '答案解析',
  `points` int NOT NULL DEFAULT 0 COMMENT '答对得分',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quest_question`(`quest_id` ASC, `q_index` ASC) USING BTREE,
  INDEX `fk_question_quest`(`quest_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-推理题表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_quest_question
-- ----------------------------
INSERT INTO `team_quest_question` VALUES (1, 'q108', 0, '死者的真正死因是什么？', '[\"妖莲吸血而亡\",\"迷香致幻后被抽血\",\"利刃割喉\",\"溺水窒息\"]', 1, '仵作在血中验出迷香，指尖泛青是中毒之象——先被迷倒，再被抽血。', 20);
INSERT INTO `team_quest_question` VALUES (2, 'q108', 1, '哪条线索最能指向凶手的身份？', '[\"紫花成丛\",\"泽边脚印\",\"指缝里的官造金线\",\"渔夫的证词\"]', 2, '官造织金线非寻常人家所有，坞主书房那件缺袖金袍正好对上。', 25);
INSERT INTO `team_quest_question` VALUES (3, 'q108', 2, '「妖莲」传说的真相是？', '[\"确有妖物作祟\",\"有人编造鬼话掩盖罪行\",\"花沾了血成了精\",\"道士作法所困\"]', 1, '花是人为移种、以血浇灌的普通紫花，传说只是掩护采买迷香与抽血的烟幕。', 25);
INSERT INTO `team_quest_question` VALUES (4, 'q107', 0, '匣盖为何「无锁自开」？', '[\"有钥匙\",\"内有弹簧机关\",\"鬼神作祟\",\"死者力气大\"]', 1, '匣盖内侧有弹簧机关，从内一顶便弹开，还可夹带毒针。', 20);
INSERT INTO `team_quest_question` VALUES (5, 'q107', 1, '哪条线索锁定了凶手的作案时间？', '[\"匣底刻字\",\"当票\",\"三夜更夫未打三更\",\"玉佩断口\"]', 2, '三夜都没打三更，说明更夫那段时间的行踪是空白，正好作案。', 25);
INSERT INTO `team_quest_question` VALUES (6, 'q107', 2, '匣里的「指甲刮木声」是什么？', '[\"冤魂哭号\",\"机关鼠\",\"风声\",\"邻居挠墙\"]', 1, '夹层里被困的机关鼠定时触发，制造闹鬼假象。', 25);
INSERT INTO `team_quest_question` VALUES (7, 'q101', 0, '孩子们是被什么手段带走？', '[\"暴力掳走\",\"掺蒙汗药的麦芽糖诱晕\",\"妖法迷惑\",\"自己走失\"]', 1, '糖锅里掺了蒙汗药，纸鸢线断口也沾着糖浆，孩子是闻甜香被诱晕的。', 20);
INSERT INTO `team_quest_question` VALUES (8, 'q101', 1, '绣坊哑女在其中扮演什么角色？', '[\"主谋\",\"被胁迫的帮手\",\"无关路人\",\"报信人\"]', 1, '布老虎出自绣坊，地窖也由她提供，但她是被胁迫的，并非主谋。', 25);
INSERT INTO `team_quest_question` VALUES (9, 'q101', 2, '谁才是真正的幕后人？', '[\"糖摊婆婆\",\"绣坊哑女\",\"更夫\",\"卖货郎\"]', 0, '糖摊供货、朱记告示、账本收银，线索都指向糖摊婆婆。', 25);

-- ----------------------------
-- Table structure for team_quest_scene
-- ----------------------------
DROP TABLE IF EXISTS `team_quest_scene`;
CREATE TABLE `team_quest_scene`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `quest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本ID',
  `scene_key` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '场景标识(s1/s2/s3)',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '场景顺序',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '场景名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '场景描述',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quest_scene`(`quest_id` ASC, `scene_key` ASC) USING BTREE,
  INDEX `fk_scene_quest`(`quest_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-勘查场景表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_quest_scene
-- ----------------------------
INSERT INTO `team_quest_scene` VALUES (1, 'q108', 's1', 1, '泽边第一现场', '晨雾未散，第五具女尸刚被抬走，紫色花丛在湿泥里开得妖异。');
INSERT INTO `team_quest_scene` VALUES (2, 'q108', 's2', 2, '仵作验尸棚', '严三火支起棚子，一具具尸体排开，空气中浮着奇异的甜香。');
INSERT INTO `team_quest_scene` VALUES (3, 'q108', 's3', 3, '坞主宅院', '依水而建的小楼，回廊挂满风干的药草，书房还亮着灯。');
INSERT INTO `team_quest_scene` VALUES (4, 'q107', 's1', 1, '明德街当铺', '当铺门缝里塞进木匣之处，朝奉钱有禄的尸身刚被移走。');
INSERT INTO `team_quest_scene` VALUES (5, 'q107', 's2', 2, '货郎与古董商家', '两处毙命现场，死状一模一样，七窍无血、双目圆睁。');
INSERT INTO `team_quest_scene` VALUES (6, 'q107', 's3', 3, '神捕司验匣', '木匣锁进铁柜，夜里仍有守卒听见匣中刮木之声。');
INSERT INTO `team_quest_scene` VALUES (7, 'q101', 's1', 1, '长街失踪地', '七名孩童最后出现的地方，散落着他们的玩物。');
INSERT INTO `team_quest_scene` VALUES (8, 'q101', 's2', 2, '城西糖摊', '长街角一个不起眼的糖摊，老婆婆正慢悠悠地熬着糖。');
INSERT INTO `team_quest_scene` VALUES (9, 'q101', 's3', 3, '绣坊后院', '绣坊后院传来细小的响动，门虚掩着。');

-- ----------------------------
-- Table structure for team_quest_suspect
-- ----------------------------
DROP TABLE IF EXISTS `team_quest_suspect`;
CREATE TABLE `team_quest_suspect`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `quest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '剧本ID',
  `suspect_key` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '嫌疑人标识(p1~p4)',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '展示顺序',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '嫌疑人姓名',
  `role` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '身份',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '人物描述',
  `avatar` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '头像(emoji)',
  `is_culprit` tinyint NOT NULL DEFAULT 0 COMMENT '是否真凶(1是)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_quest_suspect`(`quest_id` ASC, `suspect_key` ASC) USING BTREE,
  INDEX `fk_suspect_quest`(`quest_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-嫌疑人表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_quest_suspect
-- ----------------------------
INSERT INTO `team_quest_suspect` VALUES (1, 'q108', 'p1', 1, '洛夫人', '落花坞坞主', '年过四旬，经营花坞多年，热衷以奇花待客。', '👩', 1);
INSERT INTO `team_quest_suspect` VALUES (2, 'q108', 'p2', 2, '严三火', '随行仵作', '神捕司仵作，验尸时不慎沾了迷香，此刻仍有些昏沉。', '🧑‍⚕️', 0);
INSERT INTO `team_quest_suspect` VALUES (3, 'q108', 'p3', 3, '渔夫老莫', '泽上渔夫', '常在泽边打鱼，称常看见有女子自行走入花丛。', '🧔', 0);
INSERT INTO `team_quest_suspect` VALUES (4, 'q108', 'p4', 4, '云游道士', '借宿术士', '近日借宿坞中，四处兜售「辟邪符」，言行蹊跷。', '🧙', 0);
INSERT INTO `team_quest_suspect` VALUES (5, 'q107', 'p1', 1, '更夫周泰', '明德街更夫', '掌管夜间报时，三夜未打三更，行踪成谜。', '🏮', 1);
INSERT INTO `team_quest_suspect` VALUES (6, 'q107', 'p2', 2, '当铺朝奉', '钱有禄（殁）', '木匣第一位收主，已毙命，似为受害人。', '💀', 0);
INSERT INTO `team_quest_suspect` VALUES (7, 'q107', 'p3', 3, '货郎', '街边货郎（殁）', '拾匣的第二人，同样一夜毙命。', '🧍', 0);
INSERT INTO `team_quest_suspect` VALUES (8, 'q107', 'p4', 4, '古董商', '古董商（殁）', '买匣的第三人，死状与前两人一致。', '🎩', 0);
INSERT INTO `team_quest_suspect` VALUES (9, 'q101', 'p1', 1, '糖摊婆婆', '长街糖摊主', '熬得一手好麦芽糖，夜里常对孩童笑脸相迎。', '👵', 1);
INSERT INTO `team_quest_suspect` VALUES (10, 'q101', 'p2', 2, '绣坊哑女', '城西绣坊绣娘', '不能言语，针线活做得极好，似有隐情。', '👩‍🦯', 0);
INSERT INTO `team_quest_suspect` VALUES (11, 'q101', 'p3', 3, '更夫', '青石镇更夫', '夜里巡街，称什么都没看见。', '🏮', 0);
INSERT INTO `team_quest_suspect` VALUES (12, 'q101', 'p4', 4, '卖货郎', '流动货郎', '常年在长街叫卖，与糖摊有生意往来。', '🧔', 0);

-- ----------------------------
-- Table structure for team_room
-- ----------------------------
DROP TABLE IF EXISTS `team_room`;
CREATE TABLE `team_room`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌(6位大写字母数字,唯一)',
  `quest_id` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '所选剧本ID',
  `phase` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'investigate' COMMENT '阶段:investigate/quiz/accuse/result',
  `owner` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT '房主名号',
  `status` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'playing' COMMENT '状态:playing进行/closed已结案/dissolved已解散',
  `started_at` datetime NULL DEFAULT NULL COMMENT '开局时间',
  `result_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '结案结果JSON(真凶/排行榜等)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_code`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-房间表(五阶段版)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_room
-- ----------------------------

-- ----------------------------
-- Table structure for team_vote
-- ----------------------------
DROP TABLE IF EXISTS `team_vote`;
CREATE TABLE `team_vote`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `room_code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '房牌',
  `username` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '捕快名号',
  `suspect_id` varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '指认的嫌疑人(p1~p4)',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '改票时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_room_user_vote`(`room_code` ASC, `username` ASC) USING BTREE,
  INDEX `fk_vote_room`(`room_code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组队探案-指认投票表(可改票)' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_vote
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '魅影神捕用户表' ROW_FORMAT = DYNAMIC;

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
INSERT INTO `user` VALUES (13, '7777', '04421506adb1a627fd1a06adb67acc53323dbe73376a03ae8a585b84e8d5e8c7', '2026-11-16 10:54:55');
INSERT INTO `user` VALUES (14, '黎斯', '77e0d706018d102a57fcbc840647a182ab685e5bd368d586edacb8b0e6fd7b7b', '2026-11-16 10:56:20');
INSERT INTO `user` VALUES (15, 'zk_verify_01', '9502e2520fb3f8c6780026fc7071875b9b2f4c1b8d232cacb1e2a56588ec1058', '2026-11-16 10:56:23');
INSERT INTO `user` VALUES (16, '9999', 'bd4a5d3f1236d9dabc31584d9c1662a1f4c06ddf29fa29cfc5db5b5a7f9d3949', '2026-11-18 08:46:01');
INSERT INTO `user` VALUES (17, '34567', '9f94a764ecd91d0f9b5a56e3725d2044de09acdd4a1a53106e0ab591e89c0618', '2026-11-20 15:54:13');
INSERT INTO `user` VALUES (18, '6789', '758152a0f60fc6cb2fb75c675d04482d52cdbda041aae9f96b6afcebd2976de6', '2026-11-20 16:11:43');

SET FOREIGN_KEY_CHECKS = 1;
