/**
 * 用户本地存储模块（演示级）
 * 注册数据保存在 localStorage 的 myss_users 中，
 * 密码不存明文，存简单散列值（演示用途，非真实安全方案）。
 */

const USERS_KEY = 'myss_users'

/** 简单散列（djb2 变体 + 盐），仅用于避免明文落盘 */
function hashPwd(pwd) {
  let h = 5381
  const salted = 'myss::' + pwd
  for (let i = 0; i < salted.length; i++) {
    h = ((h << 5) + h + salted.charCodeAt(i)) >>> 0
  }
  return 'h' + h.toString(16)
}

/** 读取全部已注册用户 */
export function getUsers() {
  try {
    return JSON.parse(localStorage.getItem(USERS_KEY)) || []
  } catch {
    return []
  }
}

function saveUsers(users) {
  localStorage.setItem(USERS_KEY, JSON.stringify(users))
}

/**
 * 注册新用户
 * @returns {{ ok: boolean, msg: string }}
 */
export function registerUser(username, password) {
  const users = getUsers()
  if (users.some(u => u.username === username)) {
    return { ok: false, msg: '此名号已入籍，请另择他名。' }
  }
  users.push({
    username,
    pwdHash: hashPwd(password),
    createdAt: Date.now()
  })
  saveUsers(users)
  return { ok: true, msg: '' }
}

/**
 * 校验登录
 * @returns {{ ok: boolean, msg: string }}
 */
export function verifyLogin(username, password) {
  const users = getUsers()
  const user = users.find(u => u.username === username)
  if (!user || user.pwdHash !== hashPwd(password)) {
    return { ok: false, msg: '名号或令牌有误，魅影惑人，请再核对。' }
  }
  return { ok: true, msg: '' }
}
