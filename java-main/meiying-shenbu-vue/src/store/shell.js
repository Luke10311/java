/**
 * 应用外壳状态：登录态 + 全局 toast
 *
 * 首页与登录页是两个独立视图，都需要「当前是谁」「弹提示」这两件事，
 * 所以抽成一个模块级单例，谁 import 谁都能拿到同一份状态。
 *
 * 说明：这里只做前端状态。令牌校验仍然走 store/users.js 里的后端接口。
 */
import { reactive } from 'vue'
import { clearToken, fetchCurrentUser } from './users'

export const shell = reactive({
  /**
   * 当前登录的用户名，空串表示未登录。
   * 刻意不从 localStorage 初始化：localStorage 里的 myss_user 可能只是
   * 登录表单「记住名号」留下的回填值，并不代表持有有效令牌。
   * 真实登录态由 restoreSession() 拿 token 问后端得来。
   */
  user: '',
  /** 全局提示条 */
  toastMsg: '',
  toastShow: false
})

let toastTimer = null

/** 弹一条提示，2.6 秒后自动收起 */
export function showToast(msg) {
  shell.toastMsg = msg
  shell.toastShow = true
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { shell.toastShow = false }, 2600)
}

/** 写入/清除本地登录态 */
export function setUser(name) {
  shell.user = name || ''
  if (name) localStorage.setItem('myss_user', name)
  else localStorage.removeItem('myss_user')
}

/** 缴牌走人 */
export function logout() {
  clearToken()
  setUser('')
  showToast('令牌已缴回，就此别过。')
}

/**
 * 打开页面时拿本地 token 向后端换回登录态
 * @returns {Promise<string|null>} 换成功返回用户名，否则 null
 */
export async function restoreSession() {
  const name = await fetchCurrentUser()
  if (name) {
    setUser(name)
    return name
  }
  // 令牌缺失或已失效：清掉令牌（没有 token 时是空操作）。
  // 不要动 myss_user —— 那可能只是表单「记住名号」的回填值，清掉会害人重输。
  clearToken()
  shell.user = ''
  return null
}
