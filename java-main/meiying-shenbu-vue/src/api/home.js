/**
 * 首页数据接口层
 *
 * 现在优先走后端 /api/drama/**（数据来自 MySQL 的 drama / home_featured 表，
 * 后台「剧集管理」改完立刻反映到首页）；后端没起来时自动退回本地示例数据，
 * 保证页面不会白屏。
 *
 *   GET /api/drama/featured                        → 精选一案
 *   GET /api/drama/hot?category=<分类>&limit=9      → 首页热播
 *   GET /api/drama/rank?limit=5                     → 悬案榜
 *   GET /api/drama/list?genre=&year=&sort=&page=&size= → 剧集页列表
 *   GET /api/drama/:id                              → 详情（详情页仍用本地拼装演职人员/分集）
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
  buildRankList,
  filterDramas,
  paginate,
  searchDramas as searchDramasLocal,
  sortDramas
} from '../data/dramas'

/** 首页各数据源对应的后端地址 */
export const HOME_ENDPOINTS = {
  featured: '/api/drama/featured',
  hot: '/api/drama/hot',
  search: '/api/drama/list',
  rank: '/api/drama/rank',
  list: '/api/drama/list'
}

/**
 * 统一 GET 封装：后端 Result 为 { code: 200, msg, data }，code 非 200 一律按失败处理。
 */
async function getJson(path, params = {}) {
  const qs = new URLSearchParams(
    Object.entries(params).filter(([, v]) => v !== undefined && v !== null && v !== '')
  ).toString()
  const url = qs ? `${path}?${qs}` : path

  let res
  try {
    res = await fetch(url)
  } catch {
    return { ok: false, msg: '连不上后端服务，已切回本地示例数据。', data: null }
  }
  if (!res.ok) {
    return { ok: false, msg: `请求失败（HTTP ${res.status}）。`, data: null }
  }
  const json = await res.json().catch(() => null)
  if (!json) return { ok: false, msg: '后端返回内容无法解析。', data: null }
  return { ok: json.code === 200, msg: json.msg || '', data: json.data }
}

/** 精选一案 */
export async function fetchFeatured() {
  const res = await getJson(HOME_ENDPOINTS.featured)
  if (res.ok && res.data) return { ok: true, msg: '', data: res.data }
  return { ok: true, msg: '', data: FEATURED }
}

/**
 * 首页热播列表
 * @param {string} category 分类名（'全部' 表示不过滤）
 */
export async function fetchHot(category = '全部') {
  const res = await getJson(HOME_ENDPOINTS.hot, {
    category: category === '全部' ? '' : category,
    limit: 9
  })
  if (res.ok && Array.isArray(res.data) && res.data.length) {
    return { ok: true, msg: '', data: res.data }
  }

  // 后端没数据时的本地兜底
  const data = category === '全部'
    ? DRAMAS
    : DRAMAS.filter((d) => d.genres.includes(category))
  return { ok: true, msg: '', data }
}

/**
 * 缉查搜索
 * @param {string} keyword 关键词
 * @param {string} scope   搜索范围（SCOPES 里的 value）
 */
export async function searchDramas(keyword, scope = 'all') {
  const res = await getJson(HOME_ENDPOINTS.search, { keyword, page: 1, size: 20 })
  if (res.ok && res.data && Array.isArray(res.data.items)) {
    return { ok: true, msg: '', data: res.data.items, scope }
  }
  // 本地兜底：只在标题 / 类型 / 年份里做包含匹配；scope 暂不参与过滤
  const data = searchDramasLocal(keyword)
  return { ok: true, msg: '', data, scope }
}

/** 悬案榜 */
export async function fetchRank(limit = 5) {
  const res = await getJson(HOME_ENDPOINTS.rank, { limit })
  if (res.ok && Array.isArray(res.data) && res.data.length) {
    return { ok: true, msg: '', data: res.data }
  }

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
  const res = await getJson(HOME_ENDPOINTS.list, {
    genre: genre === '全部' ? '' : genre,
    year: year === 'all' ? '' : year,
    sort,
    keyword,
    page,
    size
  })
  if (res.ok && res.data && Array.isArray(res.data.items)) {
    return { ok: true, msg: '', data: res.data }
  }

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
 *
 * 演职人员与分集仍由本地代码按题材拼装（后端只存剧集本体），
 * 所以这里继续用本地实现，接口数据仅用于覆盖标题/评分/海报等基础字段。
 */
export async function fetchDramaDetail(id) {
  const res = await getJson(`/api/drama/${id}`)
  const { buildDramaDetail } = await import('../data/dramas')
  const local = buildDramaDetail(id)
  if (!local) return { ok: false, msg: '未寻得此卷，许是被谁抽走了。', data: null }
  if (res.ok && res.data) {
    return { ok: true, msg: '', data: { ...local, ...res.data, cast: local.cast, episodeList: local.episodeList, related: local.related } }
  }
  return { ok: true, msg: '', data: local }
}

/** 完整悬案榜 */
export async function fetchRankAll(limit = 10) {
  const res = await getJson(HOME_ENDPOINTS.rank, { limit })
  if (res.ok && Array.isArray(res.data) && res.data.length) {
    return { ok: true, msg: '', data: res.data.map((r, i) => ({ ...r, rank: i + 1, trend: r.trend || 'flat' })) }
  }
  return { ok: true, msg: '', data: buildRankList(limit) }
}
