/**
 * 后台管理登录态
 *
 * 现在走真实后端：POST /api/admin/login 校验 admin_user 表里的账号，
 * 返回 JWT，前端存进 sessionStorage（关掉标签页即失效）。
 *
 * 路由守卫只负责"手输地址别直接进控制台"；真正的权限校验在后端，
 * 每个 /api/admin/** 请求都会带上 Bearer 令牌，失效时后端返回 400。
 */

import { adminLogin, SESSION_EXPIRED } from '../api/admin'

const TOKEN_KEY = 'myss_admin_token'
const USER_KEY = 'myss_admin_user'
const NAME_KEY = 'myss_admin_name'

/** 内置管理员账号，登录页只作为提示（真实校验在后端） */
export const demoAdmin = { username: 'admin', password: 'admin123' }

/** 已接入后端鉴权，保留这个开关是为了兼容旧页面的提示语 */
export const isDemoAuth = false

export function getAdminToken() {
  return sessionStorage.getItem(TOKEN_KEY) || ''
}

export function getAdminUser() {
  return sessionStorage.getItem(USER_KEY) || ''
}

export function getAdminRealName() {
  return sessionStorage.getItem(NAME_KEY) || ''
}

export function isAdminLoggedIn() {
  return Boolean(getAdminToken())
}

export function setAdminSession(username, token, realName = '') {
  sessionStorage.setItem(TOKEN_KEY, token)
  sessionStorage.setItem(USER_KEY, username)
  if (realName) sessionStorage.setItem(NAME_KEY, realName)
}

export function clearAdminSession() {
  sessionStorage.removeItem(TOKEN_KEY)
  sessionStorage.removeItem(USER_KEY)
  sessionStorage.removeItem(NAME_KEY)
}

/** 判断后端返回的失败是否属于"令牌失效" */
export function isSessionExpired(msg) {
  return typeof msg === 'string' && msg.includes(SESSION_EXPIRED)
}

/**
 * 校验管理员账号
 * @param   {string} username
 * @param   {string} password
 * @returns {Promise<{ok: boolean, msg: string, token?: string, username?: string, realName?: string}>}
 */
export async function authenticateAdmin(username, password) {
  const res = await adminLogin(username, password)
  if (!res.ok) {
    return { ok: false, msg: res.msg || '管理员账号或通行密钥有误。' }
  }
  const data = res.data || {}
  return {
    ok: true,
    msg: res.msg || '',
    token: data.token || '',
    username: data.username || username,
    realName: data.realName || ''
  }
}
