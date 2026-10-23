/**
 * 我的案卷：首页「＋ 加入案卷」收藏的剧集
 *
 * 只存 id 数组，落到 localStorage。后端还没有收藏接口，
 * 将来接上以后把 persist() 换成 POST /api/case/toggle 即可，视图层不用动。
 */
import { computed, reactive } from 'vue'
import { DRAMAS } from '../data/dramas'

const KEY = 'myss_cases'

function read() {
  try {
    const arr = JSON.parse(localStorage.getItem(KEY) || '[]')
    // 兼容脏数据：只留数字
    return Array.isArray(arr) ? arr.map(Number).filter((n) => Number.isFinite(n)) : []
  } catch {
    return []
  }
}

export const caseStore = reactive({
  /** 已收藏的剧集 id */
  ids: read()
})

function persist() {
  try {
    localStorage.setItem(KEY, JSON.stringify(caseStore.ids))
  } catch {
    /* 隐私模式下写不进去，忽略即可，不影响当前会话 */
  }
}

/** 是否已在案卷里 */
export function isInCases(id) {
  return caseStore.ids.includes(Number(id))
}

/**
 * 加入 / 移出案卷
 * @returns {boolean} true = 本次是加入，false = 本次是移出
 */
export function toggleCase(id) {
  const n = Number(id)
  const i = caseStore.ids.indexOf(n)
  if (i >= 0) caseStore.ids.splice(i, 1)
  else caseStore.ids.push(n)
  persist()
  return i < 0
}

/** 移出案卷（幂等） */
export function removeCase(id) {
  const i = caseStore.ids.indexOf(Number(id))
  if (i >= 0) {
    caseStore.ids.splice(i, 1)
    persist()
  }
}

/** 清空案卷 */
export function clearCases() {
  caseStore.ids.splice(0, caseStore.ids.length)
  persist()
}

/** 案卷里的剧集对象（按加入顺序，找不到的 id 自动跳过） */
export const caseDramas = computed(() => {
  const byId = new Map(DRAMAS.map((d) => [d.id, d]))
  return caseStore.ids.map((id) => byId.get(id)).filter(Boolean)
})
