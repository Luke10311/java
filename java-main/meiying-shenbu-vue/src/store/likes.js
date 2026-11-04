/**
 * 我的喜欢：收藏的案件
 *
 * 案件详情页点「♡ 喜欢此案」、或「我的喜欢」页里点「＋ 收进喜欢」都会存进来。
 * 只存案件 id 数组，落到 localStorage。后端还没有收藏接口，
 * 将来接上以后把 persist() 换成 POST /api/like/toggle 即可，视图层不用动。
 */
import { computed, reactive } from 'vue'
import { CASES } from '../data/cases'

const KEY = 'myss_likes'

function read() {
  try {
    const arr = JSON.parse(localStorage.getItem(KEY) || '[]')
    // 兼容脏数据：只留数字
    return Array.isArray(arr) ? arr.map(Number).filter((n) => Number.isFinite(n)) : []
  } catch {
    return []
  }
}

export const likeStore = reactive({
  /** 已喜欢的案件 id */
  ids: read()
})

function persist() {
  try {
    localStorage.setItem(KEY, JSON.stringify(likeStore.ids))
  } catch {
    /* 隐私模式下写不进去，忽略即可，不影响当前会话 */
  }
}

/** 是否已喜欢此案 */
export function isLiked(id) {
  return likeStore.ids.includes(Number(id))
}

/**
 * 加入 / 移出喜欢
 * @returns {boolean} true = 本次是加入，false = 本次是移出
 */
export function toggleLike(id) {
  const n = Number(id)
  const i = likeStore.ids.indexOf(n)
  if (i >= 0) likeStore.ids.splice(i, 1)
  else likeStore.ids.push(n)
  persist()
  return i < 0
}

/** 移出喜欢（幂等） */
export function removeLike(id) {
  const i = likeStore.ids.indexOf(Number(id))
  if (i >= 0) {
    likeStore.ids.splice(i, 1)
    persist()
  }
}

/** 清空喜欢 */
export function clearLikes() {
  likeStore.ids.splice(0, likeStore.ids.length)
  persist()
}

/** 喜欢的案件对象（按加入顺序，找不到的 id 自动跳过） */
export const likedCases = computed(() => {
  const byId = new Map(CASES.map((c) => [c.id, c]))
  return likeStore.ids.map((id) => byId.get(id)).filter(Boolean)
})
