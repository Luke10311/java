-- ============================================================
--  魅影神捕 —— 首页内容 + 后台管理 数据库初始化脚本
--
--  内容（与前端 meiying-shenbu-vue/src/data/dramas.js 对齐）：
--    drama         剧集表（首页热播探案 / 剧集页 / 详情页的海报图与文字）
--    home_featured 首页「精选一案」（主视觉横幅图 + 文字）
--    home_banner   首页横幅图片资源（hero 大图等）
--    home_rank     首页「悬案榜」
--    admin_user    后台管理员表（后台登录 / 剧集上下架管理用）
--
--  数据库：MySQL 8.x（localhost:3306）账号：root / 123456
--  执行方式：
--    1) Navicat 里打开本文件整体运行；
--    2) 或命令行：mysql -h127.0.0.1 -uroot -p123456 < home_admin_init.sql
--  脚本可重复执行：均使用 IF NOT EXISTS / INSERT IGNORE / ON DUPLICATE KEY
-- ============================================================

USE `meiying_shenbu`;

-- ------------------------------------------------------------
-- 1. drama 剧集表：首页与剧集页的所有海报图片 + 标题/评分/简介等文字
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `drama` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title`      VARCHAR(64)  NOT NULL                COMMENT '剧名',
  `year`       SMALLINT     NOT NULL DEFAULT 2026   COMMENT '年份',
  `genres`     VARCHAR(64)  NOT NULL DEFAULT '悬疑' COMMENT '题材，多个用英文逗号分隔（悬疑,古装,武侠,奇幻,权谋）',
  `score`      DECIMAL(3,1) NOT NULL DEFAULT 0.0    COMMENT '评分（0.0-10.0）',
  `views`      INT          NOT NULL DEFAULT 0      COMMENT '播放热度',
  `episodes`   INT          NOT NULL DEFAULT 1      COMMENT '总集数',
  `badge`      VARCHAR(16)  NOT NULL DEFAULT ''     COMMENT '角标（独播/热播/新案，空为无）',
  `is_hot`     TINYINT      NOT NULL DEFAULT 0      COMMENT '是否首页热播探案（1是 0否）',
  `poster`     VARCHAR(255) NOT NULL DEFAULT ''     COMMENT '海报图片地址（/images/poster-x.jpg）',
  `hue_shift`  SMALLINT     NOT NULL DEFAULT 0      COMMENT '海报调色偏移（hue-rotate 度数）',
  `hue`        SMALLINT     NOT NULL DEFAULT 212    COMMENT '兜底渐变封面色相（0-360）',
  `synopsis`   TEXT         NULL                    COMMENT '剧情简介（详情页文字，后端就绪后启用）',
  `status`     TINYINT      NOT NULL DEFAULT 1      COMMENT '上架状态（1上架 0下架，后台管理用）',
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_hot`     (`is_hot`),
  KEY `idx_year`    (`year`),
  KEY `idx_views`   (`views`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '剧集表（首页图片与文字内容）';

-- ------------------------------------------------------------
-- 2. home_featured 首页「精选一案」
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_featured` (
  `id`          BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `drama_id`    BIGINT       NOT NULL                COMMENT '关联 drama.id',
  `title`       VARCHAR(64)  NOT NULL                COMMENT '剧名',
  `sub`         VARCHAR(64)  NOT NULL DEFAULT ''     COMMENT '副标题（如：第一案 · 灯市无头尸）',
  `description` VARCHAR(512) NOT NULL DEFAULT ''     COMMENT '推荐语/一句话案情',
  `tags`        VARCHAR(64)  NOT NULL DEFAULT ''     COMMENT '标签，逗号分隔（悬疑,古装,群像）',
  `score`       DECIMAL(3,1) NOT NULL DEFAULT 0.0    COMMENT '评分',
  `badge`       VARCHAR(16)  NOT NULL DEFAULT ''     COMMENT '角标（本周推荐）',
  `poster`      VARCHAR(255) NOT NULL DEFAULT ''     COMMENT '海报图片地址',
  `hue`         SMALLINT     NOT NULL DEFAULT 212    COMMENT '兜底渐变封面色相',
  `sort_order`  INT          NOT NULL DEFAULT 0      COMMENT '展示顺序（小在前）',
  `is_active`   TINYINT      NOT NULL DEFAULT 1      COMMENT '是否启用（1启用 0停用）',
  `updated_at`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_drama` (`drama_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '首页精选一案（主视觉图+文字）';

-- ------------------------------------------------------------
-- 3. home_banner 首页横幅图片资源
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_banner` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `image_key`  VARCHAR(32)  NOT NULL                COMMENT '图片标识（hero=首页主视觉）',
  `image_url`  VARCHAR(255) NOT NULL                COMMENT '图片地址（/images/hero.jpg）',
  `title`      VARCHAR(64)  NOT NULL DEFAULT ''     COMMENT '图片标题文字',
  `subtitle`   VARCHAR(128) NOT NULL DEFAULT ''     COMMENT '图片副标题文字',
  `link_url`   VARCHAR(255) NOT NULL DEFAULT ''     COMMENT '点击跳转地址（空为不跳转）',
  `sort_order` INT          NOT NULL DEFAULT 0      COMMENT '展示顺序（小在前）',
  `is_active`  TINYINT      NOT NULL DEFAULT 1      COMMENT '是否启用（1启用 0停用）',
  `updated_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_image_key` (`image_key`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '首页横幅图片资源';

-- ------------------------------------------------------------
-- 4. home_rank 首页「悬案榜」
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `home_rank` (
  `id`          BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键',
  `drama_id`    BIGINT      NOT NULL                COMMENT '关联 drama.id',
  `heat_label`  VARCHAR(32) NOT NULL DEFAULT ''     COMMENT '热度文字（如：9.8 万）',
  `trend`       VARCHAR(8)  NOT NULL DEFAULT 'flat' COMMENT '趋势（up/flat/down）',
  `rank_position` INT       NOT NULL DEFAULT 0      COMMENT '榜单名次（1 开始）',
  `is_active`   TINYINT     NOT NULL DEFAULT 1      COMMENT '是否启用（1启用 0停用）',
  `updated_at`  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_drama` (`drama_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '首页悬案榜';

-- ------------------------------------------------------------
-- 5. admin_user 后台管理员表（与 user 登录表分开，互不影响）
--    口令散列算法与 PasswordUtil 一致：SHA-256('myss::shenbu::2026' + 明文)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `admin_user` (
  `id`            BIGINT       NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username`      VARCHAR(16)  NOT NULL                COMMENT '管理员账号（2-16位）',
  `password`      VARCHAR(255) NOT NULL                COMMENT '加盐 SHA-256 散列值',
  `real_name`     VARCHAR(32)  NOT NULL DEFAULT ''     COMMENT '姓名/昵称',
  `last_login_at` DATETIME     NULL                    COMMENT '最近登录时间',
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_admin_username` (`username`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_general_ci COMMENT = '后台管理员表';

-- ============================================================
-- 初始数据（INSERT IGNORE：已存在则跳过，可重复执行）
-- ============================================================

-- 5.1 内置管理员（账号 admin / 密码 admin123，与前端演示一致）
INSERT IGNORE INTO `admin_user` (`username`, `password`, `real_name`) VALUES
  ('admin', SHA2(CONCAT('myss::shenbu::2026', 'admin123'), 256), '中枢主事');

-- 1.1 全量剧集（18 部，与 src/data/dramas.js 的 DRAMAS 一一对应）
INSERT IGNORE INTO `drama`
  (`id`, `title`, `year`, `genres`, `score`, `views`, `episodes`, `badge`, `is_hot`, `poster`, `hue_shift`, `hue`) VALUES
  (1,  '长安夜行录', 2026, '悬疑,古装', 9.2, 98400, 36, '独播', 1, '/images/poster-1.jpg',    0, 212),
  (2,  '雪落无声',   2025, '悬疑,权谋', 8.9, 84200, 32, '热播', 1, '/images/poster-2.jpg',    0, 199),
  (3,  '千面魅影',   2026, '奇幻,悬疑', 8.7, 76300, 24, '新案', 1, '/images/poster-3.jpg',    0, 268),
  (4,  '铜雀台疑云', 2024, '古装,悬疑', 8.5, 69100, 40, '',     1, '/images/poster-4.jpg',    0, 24),
  (5,  '锦衣夜巡',   2025, '武侠,悬疑', 8.4, 52600, 30, '',     1, '/images/poster-5.jpg',    0, 340),
  (6,  '无头案卷',   2026, '悬疑',      8.2, 61800, 12, '新案', 1, '/images/poster-6.jpg',    0, 158),
  (7,  '洛阳纸贵',   2023, '古装,权谋', 8.0, 43700, 46, '',     1, '/images/poster-7.jpg',    0, 42),
  (8,  '江湖令',     2025, '武侠',      7.9, 38500, 28, '',     1, '/images/poster-8.jpg',    0, 186),
  (9,  '十二楼谜案', 2026, '悬疑',      8.8, 72500, 20, '独播', 0, '/images/poster-6.jpg',  200, 230),
  (10, '孤城闭月',   2026, '古装,权谋', 8.6, 58300, 34, '新案', 0, '/images/poster-4.jpg',  -30, 280),
  (11, '夜半钟声',   2026, '悬疑,古装', 8.4, 55200, 28, '新案', 0, '/images/poster-2.jpg',   30, 204),
  (12, '灯下黑',     2025, '悬疑,奇幻', 8.3, 47600, 26, '',     0, '/images/poster-3.jpg',   40, 300),
  (13, '铁马冰河',   2024, '武侠,古装', 8.1, 41200, 38, '',     0, '/images/poster-8.jpg',  -20, 18),
  (14, '铜镜',       2023, '古装,悬疑', 7.9, 31800, 32, '',     0, '/images/poster-5.jpg',  160, 192),
  (15, '断刃',       2025, '武侠',      7.8, 33400, 24, '',     0, '/images/poster-8.jpg',   25, 356),
  (16, '洛阳春',     2024, '古装,权谋', 7.7, 29500, 42, '',     0, '/images/poster-7.jpg',  -15, 36),
  (17, '逆旅',       2025, '奇幻,权谋', 7.6, 26700, 22, '',     0, '/images/poster-3.jpg',  -35, 274),
  (18, '白骨谣',     2023, '悬疑,奇幻', 7.5, 24300, 16, '',     0, '/images/poster-6.jpg',  160, 150);

-- 2.1 精选一案（与 FEATURED 常量一致）
INSERT IGNORE INTO `home_featured`
  (`id`, `drama_id`, `title`, `sub`, `description`, `tags`, `score`, `badge`, `poster`, `hue`, `sort_order`, `is_active`) VALUES
  (1, 1, '长安夜行录', '第一案 · 灯市无头尸',
   '上元灯市，三十七盏花灯尽数熄灭。死者颈上无痕，掌心却攥着一枚卖灯人的铜钱。',
   '悬疑,古装,群像', 9.2, '本周推荐', '/images/poster-1.jpg', 212, 0, 1);

-- 3.1 首页主视觉横幅图
INSERT IGNORE INTO `home_banner`
  (`id`, `image_key`, `image_url`, `title`, `subtitle`, `link_url`, `sort_order`, `is_active`) VALUES
  (1, 'hero', '/images/hero.jpg', '魅影神捕', '缉影录 · 悬案未终，灯火不熄', '', 0, 1);

-- 4.1 悬案榜（与 RANKS 常量一致）
INSERT IGNORE INTO `home_rank`
  (`id`, `drama_id`, `heat_label`, `trend`, `rank_position`, `is_active`) VALUES
  (1, 1, '9.8 万', 'up',   1, 1),
  (2, 3, '8.4 万', 'up',   2, 1),
  (3, 6, '7.6 万', 'flat', 3, 1),
  (4, 2, '6.9 万', 'down', 4, 1),
  (5, 5, '5.2 万', 'flat', 5, 1);

-- ============================================================
-- 查看结果
-- ============================================================
SELECT 'drama' AS 表, COUNT(*) AS 行数 FROM `drama`
UNION ALL SELECT 'home_featured', COUNT(*) FROM `home_featured`
UNION ALL SELECT 'home_banner',   COUNT(*) FROM `home_banner`
UNION ALL SELECT 'home_rank',     COUNT(*) FROM `home_rank`
UNION ALL SELECT 'admin_user',    COUNT(*) FROM `admin_user`;
