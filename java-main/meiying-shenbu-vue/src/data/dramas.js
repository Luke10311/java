/**
 * 剧集演示数据 + 纯前端筛选排序（无后端）
 *
 * 首页「热播探案」只取 hot 标记的那 8 部；剧集页（/series）用全量 18 部。
 * poster 指向 public/images/ 下的本地海报图；后 10 部暂无专属海报，
 * 复用相近题材的图并用 hueShift 做轻度调色区分（DramaCard 里用 hue-rotate 实现）。
 * hue 保留：图片加载失败时用来生成写意渐变封面兜底。
 *
 * ── 接口预留（本轮不实现）────────────────────────────────
 * 接入后端后，把下面的常量/函数换成对应请求即可，字段名保持不变：
 *   GET  /api/drama/featured                        精选一案
 *   GET  /api/drama/hot?category=<分类>             首页热播
 *   GET  /api/drama/search?keyword=<词>&scope=<域>  搜索
 *   GET  /api/drama/rank?limit=5                    悬案榜
 *   GET  /api/drama/list?genre=&year=&sort=&page=   剧集页列表（带分页）
 * ────────────────────────────────────────────────────
 */

/** 搜索范围：全卷 / 剧集 / 影录 / 人物 / 案卷 */
export const SCOPES = [
  { value: 'all', label: '全卷' },
  { value: 'series', label: '剧集' },
  { value: 'movie', label: '影录' },
  { value: 'role', label: '人物' },
  { value: 'case', label: '案卷' }
]

/** 类型筛选项 */
export const CATEGORIES = ['全部', '悬疑', '古装', '武侠', '奇幻', '权谋']

/** 热搜词 */
export const HOT_WORDS = ['长安夜行录', '无头案卷', '千面魅影', '锦衣', '密室']

/** 剧集页的年份筛选项（'all' 表示不限） */
export const YEARS = [
  { value: 'all', label: '不限' },
  { value: 2026, label: '2026' },
  { value: 2025, label: '2025' },
  { value: 2024, label: '2024' },
  { value: 2023, label: '2023' }
]

/** 剧集页排序方式 */
export const SORTS = [
  { value: 'default', label: '综合' },
  { value: 'score', label: '评分' },
  { value: 'views', label: '热度' },
  { value: 'year', label: '最新' }
]

/** 剧集页每页条数 */
export const PAGE_SIZE = 12

/** 首页主视觉横幅（public/images/hero.jpg） */
export const HERO_IMAGE = '/images/hero.jpg'

/** 精选一案 */
export const FEATURED = {
  id: 1,
  title: '长安夜行录',
  sub: '第一案 · 灯市无头尸',
  desc: '上元灯市，三十七盏花灯尽数熄灭。死者颈上无痕，掌心却攥着一枚卖灯人的铜钱。',
  tags: ['悬疑', '古装', '群像'],
  score: 9.2,
  badge: '本周推荐',
  poster: '/images/poster-1.jpg',
  hue: 212
}

/**
 * 全量剧集
 * hot: true 的 8 部用于首页「热播探案」；views 用于热度排序。
 */
export const DRAMAS = [
  { id: 1, title: '长安夜行录', year: 2026, genres: ['悬疑', '古装'], score: 9.2, views: 98400, episodes: 36, badge: '独播', hot: true,  poster: '/images/poster-1.jpg', hueShift: 0,   hue: 212 },
  { id: 2, title: '雪落无声',   year: 2025, genres: ['悬疑', '权谋'], score: 8.9, views: 84200, episodes: 32, badge: '热播', hot: true,  poster: '/images/poster-2.jpg', hueShift: 0,   hue: 199 },
  { id: 3, title: '千面魅影',   year: 2026, genres: ['奇幻', '悬疑'], score: 8.7, views: 76300, episodes: 24, badge: '新案', hot: true,  poster: '/images/poster-3.jpg', hueShift: 0,   hue: 268 },
  { id: 4, title: '铜雀台疑云', year: 2024, genres: ['古装', '悬疑'], score: 8.5, views: 69100, episodes: 40, badge: '',     hot: true,  poster: '/images/poster-4.jpg', hueShift: 0,   hue: 24 },
  { id: 5, title: '锦衣夜巡',   year: 2025, genres: ['武侠', '悬疑'], score: 8.4, views: 52600, episodes: 30, badge: '',     hot: true,  poster: '/images/poster-5.jpg', hueShift: 0,   hue: 340 },
  { id: 6, title: '无头案卷',   year: 2026, genres: ['悬疑'],         score: 8.2, views: 61800, episodes: 12, badge: '新案', hot: true,  poster: '/images/poster-6.jpg', hueShift: 0,   hue: 158 },
  { id: 7, title: '洛阳纸贵',   year: 2023, genres: ['古装', '权谋'], score: 8.0, views: 43700, episodes: 46, badge: '',     hot: true,  poster: '/images/poster-7.jpg', hueShift: 0,   hue: 42 },
  { id: 8, title: '江湖令',     year: 2025, genres: ['武侠'],         score: 7.9, views: 38500, episodes: 28, badge: '',     hot: true,  poster: '/images/poster-8.jpg', hueShift: 0,   hue: 186 },

  // ── 以下暂无专属海报，复用相近题材的图 + hueShift 轻度调色区分 ──
  { id: 9,  title: '十二楼谜案', year: 2026, genres: ['悬疑'],         score: 8.8, views: 72500, episodes: 20, badge: '独播', hot: false, poster: '/images/poster-6.jpg', hueShift: 200, hue: 230 },
  { id: 10, title: '孤城闭月',   year: 2026, genres: ['古装', '权谋'], score: 8.6, views: 58300, episodes: 34, badge: '新案', hot: false, poster: '/images/poster-4.jpg', hueShift: -30, hue: 280 },
  { id: 11, title: '夜半钟声',   year: 2026, genres: ['悬疑', '古装'], score: 8.4, views: 55200, episodes: 28, badge: '新案', hot: false, poster: '/images/poster-2.jpg', hueShift: 30,  hue: 204 },
  { id: 12, title: '灯下黑',     year: 2025, genres: ['悬疑', '奇幻'], score: 8.3, views: 47600, episodes: 26, badge: '',     hot: false, poster: '/images/poster-3.jpg', hueShift: 40,  hue: 300 },
  { id: 13, title: '铁马冰河',   year: 2024, genres: ['武侠', '古装'], score: 8.1, views: 41200, episodes: 38, badge: '',     hot: false, poster: '/images/poster-8.jpg', hueShift: -20, hue: 18 },
  { id: 14, title: '铜镜',       year: 2023, genres: ['古装', '悬疑'], score: 7.9, views: 31800, episodes: 32, badge: '',     hot: false, poster: '/images/poster-5.jpg', hueShift: 160, hue: 192 },
  { id: 15, title: '断刃',       year: 2025, genres: ['武侠'],         score: 7.8, views: 33400, episodes: 24, badge: '',     hot: false, poster: '/images/poster-8.jpg', hueShift: 25,  hue: 356 },
  { id: 16, title: '洛阳春',     year: 2024, genres: ['古装', '权谋'], score: 7.7, views: 29500, episodes: 42, badge: '',     hot: false, poster: '/images/poster-7.jpg', hueShift: -15, hue: 36 },
  { id: 17, title: '逆旅',       year: 2025, genres: ['奇幻', '权谋'], score: 7.6, views: 26700, episodes: 22, badge: '',     hot: false, poster: '/images/poster-3.jpg', hueShift: -35, hue: 274 },
  { id: 18, title: '白骨谣',     year: 2023, genres: ['悬疑', '奇幻'], score: 7.5, views: 24300, episodes: 16, badge: '',     hot: false, poster: '/images/poster-6.jpg', hueShift: 160, hue: 150 }
]

/** 首页「热播探案」用的 8 部 */
export const HOT_DRAMAS = DRAMAS.filter((d) => d.hot)

/** 悬案榜 */
export const RANKS = [
  { id: 1, title: '长安夜行录', heat: '9.8 万', trend: 'up' },
  { id: 3, title: '千面魅影', heat: '8.4 万', trend: 'up' },
  { id: 6, title: '无头案卷', heat: '7.6 万', trend: 'flat' },
  { id: 2, title: '雪落无声', heat: '6.9 万', trend: 'down' },
  { id: 5, title: '锦衣夜巡', heat: '5.2 万', trend: 'flat' }
]

/* ── 纯函数：筛选 / 排序 / 分页 ─────────────────────────
   放在这里而不是组件里，是为了能脱离浏览器单独跑单测，
   将来换成后端接口时这几个函数直接删掉即可。
   ─────────────────────────────────────────────────── */

/**
 * 过滤
 * @param {Array} list
 * @param {{ categories?: string[], year?: string|number, keyword?: string }} opt
 *        categories 为空数组表示不限类型；year 为 'all' 表示不限年份
 */
export function filterDramas(list, { categories = [], year = 'all', keyword = '' } = {}) {
  const kw = String(keyword).trim().toLowerCase()
  return list.filter((d) => {
    if (categories.length && !categories.some((c) => d.genres.includes(c))) return false
    if (year !== 'all' && String(d.year) !== String(year)) return false
    if (kw) {
      const hay = [d.title, ...d.genres, String(d.year)].join(' ').toLowerCase()
      if (!hay.includes(kw)) return false
    }
    return true
  })
}

/** 排序；default = 首页热播优先，再看评分 */
export function sortDramas(list, sort = 'default') {
  const arr = [...list]
  switch (sort) {
    case 'score':
      return arr.sort((a, b) => b.score - a.score)
    case 'views':
      return arr.sort((a, b) => b.views - a.views)
    case 'year':
      return arr.sort((a, b) => b.year - a.year || b.score - a.score)
    default:
      return arr.sort(
        (a, b) => Number(Boolean(b.hot)) - Number(Boolean(a.hot)) || b.score - a.score
      )
  }
}

/**
 * 分页；页码越界会自动夹到合法范围
 * @returns {{ page:number, totalPages:number, total:number, items:Array }}
 */
export function paginate(list, page = 1, size = PAGE_SIZE) {
  const total = list.length
  const totalPages = Math.max(1, Math.ceil(total / size))
  const current = Math.min(Math.max(1, Number(page) || 1), totalPages)
  const start = (current - 1) * size
  return { page: current, totalPages, total, items: list.slice(start, start + size) }
}

/** 按关键词在标题 / 类型 / 年份里找（首页搜索栏用） */
export function searchDramas(keyword) {
  const kw = String(keyword).trim().toLowerCase()
  if (!kw) return []
  return DRAMAS.filter((d) => {
    const hay = [d.title, ...d.genres, String(d.year)].join(' ').toLowerCase()
    return hay.includes(kw)
  })
}
