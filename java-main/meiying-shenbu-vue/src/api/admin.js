/**
 * 后台管理接口层
 *
 * 对接 springBootTest 的 /api/admin/**：
 *   POST   /api/admin/login    登录 → { username, realName, token }
 *   GET    /api/admin/me       当前管理员
 *   GET    /api/admin/stats    控制台统计
 *   GET    /api/admin/drama    剧集分页（keyword / genre / status / page / size）
 *   POST   /api/admin/drama    新增或更新剧集（带 id 即更新）
 *   DELETE /api/admin/drama/:id
 *   GET    /api/admin/case     案卷分页（keyword / status / page / size）
 *   POST   /api/admin/case     新增或更新案卷
 *   DELETE /api/admin/case/:id
 *   GET    /api/admin/user     捕快分页（keyword / page / size）
 *   DELETE /api/admin/user/:id
 *   GET    /api/admin/config   站点配置
 *   POST   /api/admin/config   保存站点配置
 *   POST   /api/admin/password 修改通行密钥
 *
 * 统一返回 { code, msg, data }，code !== 200 视为失败。
 */

const TOKEN_KEY = 'myss_admin_token'

/** 会话失效时抛出的标记：页面据此清会话、弹回登录页 */
export const SESSION_EXPIRED = '管理员会话已失效'

function token() {
  return sessionStorage.getItem(TOKEN_KEY) || ''
}

/**
 * 统一请求封装
 * @param {string} path
 * @param {{method?: string, body?: any, auth?: boolean}} opt
 * @returns {Promise<{ok: boolean, msg: string, data: any}>}
 */
async function request(path, { method = 'GET', body, auth = true } = {}) {
  const headers = {}
  if (body !== undefined) headers['Content-Type'] = 'application/json'
  if (auth && token()) headers.Authorization = `Bearer ${token()}`

  let res
  try {
    res = await fetch(path, {
      method,
      headers,
      body: body === undefined ? undefined : JSON.stringify(body)
    })
  } catch {
    return { ok: false, msg: '连不上后端服务，请确认后端已启动（8080 端口）。', data: null }
  }

  if (res.status === 401 || res.status === 403) {
    return { ok: false, msg: SESSION_EXPIRED, data: null }
  }
  if (!res.ok) {
    return { ok: false, msg: `请求失败（HTTP ${res.status}）。`, data: null }
  }

  const json = await res.json().catch(() => null)
  if (!json) return { ok: false, msg: '后端返回内容无法解析。', data: null }
  return { ok: json.code === 200, msg: json.msg || '', data: json.data }
}

/** 登录（不带旧令牌） */
export function adminLogin(username, password) {
  return request('/api/admin/login', { method: 'POST', body: { username, password }, auth: false })
}

/** 当前管理员信息 */
export function fetchAdminMe() {
  return request('/api/admin/me')
}

/** 控制台统计 */
export function fetchStats() {
  return request('/api/admin/stats')
}

/* ── 剧集 ── */
export function fetchDramaPage({ keyword = '', genre = '', status = '', page = 1, size = 10 } = {}) {
  const qs = new URLSearchParams()
  if (keyword) qs.set('keyword', keyword)
  if (genre) qs.set('genre', genre)
  if (status !== '' && status !== null && status !== undefined) qs.set('status', status)
  qs.set('page', page)
  qs.set('size', size)
  return request(`/api/admin/drama?${qs}`)
}

export function saveDrama(drama) {
  return request('/api/admin/drama', { method: 'POST', body: drama })
}

export function deleteDrama(id) {
  return request(`/api/admin/drama/${id}`, { method: 'DELETE' })
}

/* ── 案卷 ── */
export function fetchCasePage({ keyword = '', status = '', page = 1, size = 10 } = {}) {
  const qs = new URLSearchParams()
  if (keyword) qs.set('keyword', keyword)
  if (status) qs.set('status', status)
  qs.set('page', page)
  qs.set('size', size)
  return request(`/api/admin/case?${qs}`)
}

export function saveCase(caseFile) {
  return request('/api/admin/case', { method: 'POST', body: caseFile })
}

export function deleteCase(id) {
  return request(`/api/admin/case/${id}`, { method: 'DELETE' })
}

/* ── 捕快（前台用户） ── */
export function fetchUserPage({ keyword = '', page = 1, size = 10 } = {}) {
  const qs = new URLSearchParams()
  if (keyword) qs.set('keyword', keyword)
  qs.set('page', page)
  qs.set('size', size)
  return request(`/api/admin/user?${qs}`)
}

export function deleteUser(id) {
  return request(`/api/admin/user/${id}`, { method: 'DELETE' })
}

/* ── 系统设置 ── */
export function fetchConfig() {
  return request('/api/admin/config')
}

export function saveConfig(values) {
  return request('/api/admin/config', { method: 'POST', body: values })
}

export function changeAdminPassword(oldPassword, newPassword) {
  return request('/api/admin/password', { method: 'POST', body: { oldPassword, newPassword } })
}
