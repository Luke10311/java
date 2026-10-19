/**
 * 用户认证模块 —— 真实走后端接口
 *
 * 后端（meiying-shenbu-backend，端口 8080）提供：
 *   POST /api/user/register   { username, password }
 *   POST /api/user/login      { username, password }  → data.token
 *   GET  /api/user/me         Header: Authorization: Bearer <token>
 *
 * 请求走相对路径 /api/...，由 vite.config.js 的 proxy 转发到 8080，
 * 所以不存在跨域，也不需要在前端写死后端地址。
 */

const TOKEN_KEY = 'myss_token'
const USER_KEY = 'myss_user'

/** 统一 POST 封装：把网络错误、404、非 JSON 响应都翻译成人话 */
async function postJson(path, body) {
  let res
  try {
    res = await fetch(path, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    })
  } catch {
    return { ok: false, msg: '连不上后端服务，请确认 8080 端口已启动。' }
  }

  if (!res.ok) {
    return {
      ok: false,
      msg: res.status === 404
        ? '后端未找到该接口（404），请确认启动的是魅影神捕后端。'
        : `请求失败（HTTP ${res.status}）。`
    }
  }

  const json = await res.json().catch(() => null)
  if (!json) return { ok: false, msg: '后端返回内容无法解析。' }

  return { ok: json.code === 200, msg: json.msg || '', data: json.data }
}

/**
 * 注册新用户
 * @returns {Promise<{ ok: boolean, msg: string }>}
 */
export async function registerUser(username, password) {
  return postJson('/api/user/register', { username, password })
}

/**
 * 校验登录；成功后把 JWT 与用户名落到 localStorage
 * @returns {Promise<{ ok: boolean, msg: string }>}
 */
export async function verifyLogin(username, password) {
  const result = await postJson('/api/user/login', { username, password })
  if (result.ok) {
    const token = result.data && result.data.token
    if (token) localStorage.setItem(TOKEN_KEY, token)
    localStorage.setItem(USER_KEY, username)
  }
  return result
}

/**
 * 用已存的 token 换取当前登录用户名；令牌失效返回 null
 * @returns {Promise<string|null>}
 */
export async function fetchCurrentUser() {
  const token = localStorage.getItem(TOKEN_KEY)
  if (!token) return null

  try {
    const res = await fetch('/api/user/me', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (!res.ok) return null
    const json = await res.json()
    if (json.code !== 200 || !json.data) return null
    return json.data.username
  } catch {
    return null
  }
}

/** 退出登录：清掉令牌 */
export function clearToken() {
  localStorage.removeItem(TOKEN_KEY)
}

/** 读取本地记着的登录态（用户名） */
export function getRememberedUser() {
  return localStorage.getItem(USER_KEY) || ''
}
