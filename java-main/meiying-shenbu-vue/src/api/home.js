/**
 * 首页数据接口层
 *
 * 首页现在需要的四类数据：精选一案 / 热播探案 / 缉查搜索 / 悬案榜。
 * 后端（meiying-shenbu-backend）目前只开了 /api/user/**，
 * 剧情数据相关的接口还没写，所以这一层先用本地示例数据（src/data/dramas.js）兜底。
 *
 * ── 后端就绪后的接法 ─────────────────────────────────────
 * 1. 把 getJson() 的注释解开（返回结构与 Result 约定一致：{ code, msg, data }）；
 * 2. 每个导出函数里删掉「return 本地数据」那一行，换成 return getJson(...)；
 * 3. 视图层（HomeView.vue）不用动 —— 它只认这层函数，字段名保持不变即可。
 * ─────────────────────────────────────────────────────
 *
 * 接口约定（待实现）：
 *   GET /api/drama/featured                        → 精选一案
 *   GET /api/drama/hot?category=<分类>             → 首页热播
 *   GET /api/drama/search?keyword=<词>&scope=<域>  → 缉查搜索
 *   GET /api/drama/rank?limit=5                    → 悬案榜
 *   GET /api/drama/list?genre=&page=&size=         → 剧集页列表（以后做剧集页用）
 */

import {
  CATEGORIES,
  DRAMAS,
  FEATURED,
  PAGE_SIZE,
  RANKS,
  SCOPES,
  SORTS,
  YEARS,
  buildDramaDetail,
  buildRankList,
  filterDramas,
  paginate,
  searchDramas as searchDramasLocal,
  sortDramas
} from '../data/dramas'

/** 首页各数据源对应的后端地址（后端没开也不影响前端编译运行） */
export const HOME_ENDPOINTS = {
  featured: '/api/drama/featured',
  hot: '/api/drama/hot',
  search: '/api/drama/search',
  rank: '/api/drama/rank'
}

/**
 * 统一 GET 封装，跟 store/users.js 的 postJson 对齐：
 * 后端 Result 格式为 { code: 200, msg, data }，code 非 200 一律按失败处理。
 * 现在先不调用 —— 等后端把上面的接口补上再启用。
 */
// async function getJson(path, params = {}) {
//   const qs = new URLSearchParams(
//     Object.entries(params).filter(([, v]) => v !== undefined && v !== '')
//   ).toString()
//   const url = qs ? `${path}?${qs}` : path
//
//   let res
//   try {
//     res = await fetch(url)
//   } catch {
//     return { ok: false, msg: '连不上后端服务，请确认 8080 端口已启动。', data: null }
//   }
//   if (!res.ok) {
//     return { ok: false, msg: `请求失败（HTTP ${res.status}）。`, data: null }
//   }
//   const json = await res.json().catch(() => null)
//   if (!json) return { ok: false, msg: '后端返回内容无法解析。', data: null }
//   return { ok: json.code === 200, msg: json.msg || '', data: json.data }
// }

/** 精选一案：后端就绪后换成 getJson(HOME_ENDPOINTS.featured) */
export async function fetchFeatured() {
  return { ok: true, msg: '', data: FEATURED }
}

/**
 * 首页热播列表
 * @param {string} category 分类名（'全部' 表示不过滤）
 */
export async function fetchHot(category = '全部') {
  const data = category === '全部'
    ? DRAMAS
    : DRAMAS.filter((d) => d.genres.includes(category))
  return { ok: true, msg: '', data }
}

/**
 * 缉查搜索
 * @param {string} keyword 关键词
 * @param {string} scope   搜索范围（SCOPES 里的 value），接入后端时原样传给接口
 */
export async function searchDramas(keyword, scope = 'all') {
  // 本地兜底：只在标题 / 类型 / 年份里做包含匹配；scope 暂不参与过滤
  const data = searchDramasLocal(keyword)
  return { ok: true, msg: '', data, scope }
}

/** 悬案榜：后端就绪后换成 getJson(HOME_ENDPOINTS.rank, { limit: 5 }) */
export async function fetchRank(limit = 5) {
  // 本地兜底：把 RANKS 里的 id 关联上剧集的海报 / 色相，供榜单缩略图使用
  const byId = new Map(DRAMAS.map((d) => [d.id, d]))
  const data = RANKS.slice(0, limit).map((r) => {
    const d = byId.get(r.id)
    return { ...r, poster: d?.poster || '', hue: d?.hue || 212 }
  })
  return { ok: true, msg: '', data }
}

/** 给筛选条 / 搜索范围下拉用，也顺带从这里出，视图层只 import 这一层 */
export { CATEGORIES, SCOPES, YEARS, SORTS, PAGE_SIZE }

/**
 * 剧集页列表：筛选 + 排序 + 分页
 *
 * 后端就绪后换成：
 *   GET /api/drama/list?genre=&year=&sort=&keyword=&page=&size=
 * 返回值结构与现在一致（{ ok, msg, data: { page, totalPages, total, items } }），
 * 所以 SeriesView 不用改。
 *
 * @param {{ genre?: string, year?: string|number, sort?: string,
 *           keyword?: string, page?: number, size?: number }} opt
 */
export async function fetchSeriesList({
  genre = '全部',
  year = 'all',
  sort = 'default',
  keyword = '',
  page = 1,
  size = PAGE_SIZE
} = {}) {
  const filtered = filterDramas(DRAMAS, {
    categories: genre && genre !== '全部' ? [genre] : [],
    year,
    keyword
  })
  const sorted = sortDramas(filtered, sort)
  const data = paginate(sorted, page, size)
  return { ok: true, msg: '', data }
}

/**
 * 剧集详情：海报 / 简介 / 演职人员 / 分集 / 相关推荐
 * 后端就绪后换成 GET /api/drama/:id
 */
export async function fetchDramaDetail(id) {
  const data = buildDramaDetail(id)
  if (!data) return { ok: false, msg: '未寻得此卷，许是被谁抽走了。', data: null }
  return { ok: true, msg: '', data }
}

/** 完整悬案榜；后端就绪后换成 GET /api/drama/rank?limit=10 */
export async function fetchRankAll(limit = 10) {
  return { ok: true, msg: '', data: buildRankList(limit) }
}
