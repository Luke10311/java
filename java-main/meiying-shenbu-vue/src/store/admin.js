/**
 * 后台管理登录态
 *
 * ⚠️ 注意：这里是「演示校验」，不是真正的权限控制。
 * 后端目前只有 /api/user/**（捕快账号），没有管理员这套接口，所以账号密码
 * 暂时写在前端常量里（admin / admin123），只为把后台的路由和页面串起来。
 *
 * 等后端补上 POST /api/admin/login，只需要改 authenticateAdmin() 一个函数，
 * 路由守卫、登录页、控制台都不用动。
 *
 * 令牌放 sessionStorage 而不是 localStorage：关掉标签页就要重新登录，
 * 后台会话不该长期留在浏览器里。
 */

const TOKEN_KEY = 'myss_admin_token'
const USER_KEY = 'myss_admin_user'

/** 演示用管理员账号 —— 后端接口就绪后删掉 */
const DEMO_ADMIN = { username: 'admin', password: 'admin123' }

/** 登录页要展示的演示提示（复制一份，别让页面改到常量本体） */
export const demoAdmin = { ...DEMO_ADMIN }

/** 演示模式的开关，控制台上要据此提示"不是真的鉴权" */
export const isDemoAuth = true

export function getAdminToken() {
  return sessionStorage.getItem(TOKEN_KEY) || ''
}

export function getAdminUser() {
  return sessionStorage.getItem(USER_KEY) || ''
}

export function isAdminLoggedIn() {
  return Boolean(getAdminToken())
}

export function setAdminSession(username, token) {
  sessionStorage.setItem(TOKEN_KEY, token)
  sessionStorage.setItem(USER_KEY, username)
}

export function clearAdminSession() {
  sessionStorage.removeItem(TOKEN_KEY)
  sessionStorage.removeItem(USER_KEY)
}

/**
 * 校验管理员账号
 * @param   {string} username
 * @param   {string} password
 * @returns {Promise<{ok: boolean, msg: string, token?: string}>}
 */
export async function authenticateAdmin(username, password) {
  /* ---------- 后端接口就绪后，把下面这段取消注释、删掉演示校验 ----------
  let res
  try {
    res = await fetch('/api/admin/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
    })
  } catch {
    return { ok: false, msg: '连不上后端服务，请确认 8080 端口已启动。' }
  }
  if (!res.ok) {
    return {
      ok: false,
      msg: res.status === 404
        ? '后端还没有 /api/admin/login 接口（404）。'
        : `请求失败（HTTP ${res.status}）。`
    }
  }
  const json = await res.json().catch(() => null)
  if (!json) return { ok: false, msg: '后端返回内容无法解析。' }
  if (json.code !== 200) return { ok: false, msg: json.msg || '账号或密钥有误。' }
  return { ok: true, msg: json.msg || '', token: (json.data && json.data.token) || '' }
  ------------------------------------------------------------------- */

  // 演示校验：稍等一下，免得按钮闪得太快像是没反应
  await new Promise((resolve) => setTimeout(resolve, 280))

  if (username === DEMO_ADMIN.username && password === DEMO_ADMIN.password) {
    return { ok: true, msg: '中枢已解锁', token: `demo-admin-${Date.now()}` }
  }
  return { ok: false, msg: '管理员账号或通行密钥有误。' }
}
