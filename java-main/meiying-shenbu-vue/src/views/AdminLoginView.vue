<template>
  <BackgroundScene :show-lantern="false" />

  <!-- 后台登录：跟前台登录同一套骨架，配色偏冷（黛蓝 + 金线），一眼能看出"换了个地方" -->
  <div class="stage">
    <div class="card">
      <div class="corner tl"></div><div class="corner tr"></div>
      <div class="corner bl"></div><div class="corner br"></div>
      <div class="seal">中枢<br>密钥</div>

      <p class="kicker">MEIYING · ADMIN CONSOLE</p>
      <h1 class="title">后台管理系统</h1>
      <p class="subtitle">卷宗中枢 · 仅限持令者入</p>

      <form class="form" novalidate @submit.prevent="onSubmit">
        <div class="field" :class="{ error: errors.user }">
          <label>管理员账号</label>
          <input
            v-model.trim="user"
            type="text"
            placeholder="请输入管理员账号"
            autocomplete="username"
            @input="errors.user = false"
          >
          <span class="icon">⚙</span>
          <p class="err-msg">请填写管理员账号。</p>
        </div>

        <div class="field has-toggle" :class="{ error: errors.pwd }">
          <label>通行密钥</label>
          <input
            v-model="pwd"
            :type="showPwd ? 'text' : 'password'"
            placeholder="请输入通行密钥"
            autocomplete="current-password"
            @input="errors.pwd = false; pwdMsg = ''"
          >
          <span class="toggle-eye" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁' }}</span>
          <p class="err-msg" v-if="pwdMsg">{{ pwdMsg }}</p>
          <p class="err-msg" v-else>请填写通行密钥。</p>
        </div>

        <button class="btn" type="submit" :disabled="loading">
          {{ loading ? '正 在 核 验' : '进 入 中 枢' }}
        </button>
      </form>

      <!-- 演示账号：点一下自动填入，省得手敲 -->
      <div class="demo">
        <span class="demo-label">演示账号</span>
        <a class="demo-val" href="javascript:;" title="点一下自动填入" @click="fillDemo">
          {{ demoAdmin.username }} / {{ demoAdmin.password }}
        </a>
      </div>

      <p class="notice">当前为前端演示校验，正式环境请接后端 <code>/api/admin/login</code>。</p>

      <p class="foot">内部系统<span class="divider">·</span>各级捕头凭令登录<span class="divider">·</span>© 魅影神捕探案录</p>
    </div>

    <a class="back-home" href="javascript:;" @click="router.push('/')">‹ 返回探案录首页</a>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import BackgroundScene from '../components/BackgroundScene.vue'
import { authenticateAdmin, demoAdmin, getAdminUser, setAdminSession } from '../store/admin'
import { showToast } from '../store/shell'

const router = useRouter()
const route = useRoute()

// 上次登录过的账号回填一下，省得每次重敲
const user = ref(getAdminUser())
const pwd = ref('')
const showPwd = ref(false)
const loading = ref(false)
const pwdMsg = ref('')
const errors = reactive({ user: false, pwd: false })

/** 一键填入演示账号 */
function fillDemo() {
  user.value = demoAdmin.username
  pwd.value = demoAdmin.password
  errors.user = false
  errors.pwd = false
  pwdMsg.value = ''
}

async function onSubmit() {
  if (loading.value) return
  pwdMsg.value = ''
  errors.user = !user.value
  errors.pwd = !pwd.value
  if (errors.user || errors.pwd) return

  loading.value = true
  let result
  try {
    result = await authenticateAdmin(user.value, pwd.value)
  } finally {
    loading.value = false
  }

  if (!result.ok) {
    pwdMsg.value = result.msg || '账号或密钥有误，请再核对。'
    errors.pwd = true
    errors.user = true
    return
  }

  setAdminSession(user.value, result.token)
  showToast(`中枢已解锁，「${user.value}」大人请入。`)

  // 从 /admin 被踢回登录页的，登录后原路返回；只认 /admin 开头的站内地址
  const raw = route.query.redirect
  const back = typeof raw === 'string' && raw.startsWith('/admin') ? raw : '/admin'
  setTimeout(() => router.replace(back), 420)
}
</script>

<style scoped>
.stage {
  position: relative;
  z-index: 2;
  min-height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px 16px;
}

.card {
  width: 410px;
  max-width: 100%;
  background: linear-gradient(165deg, rgba(20, 30, 48, 0.94), rgba(8, 12, 20, 0.96));
  border: 1px solid rgba(143, 179, 217, 0.32);
  border-radius: 10px;
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.7), inset 0 1px 0 rgba(143, 179, 217, 0.16);
  padding: 46px 40px 34px;
  position: relative;
  animation: cardIn 0.85s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes cardIn {
  from { opacity: 0; transform: translateY(26px) scale(0.97); }
  to { opacity: 1; transform: none; }
}

/* 卡片四角描纹 */
.corner {
  position: absolute;
  width: 24px;
  height: 24px;
  border-color: rgba(143, 179, 217, 0.75);
  border-style: solid;
}
.corner.tl { top: 10px; left: 10px; border-width: 2px 0 0 2px; }
.corner.tr { top: 10px; right: 10px; border-width: 2px 2px 0 0; }
.corner.bl { bottom: 10px; left: 10px; border-width: 0 0 2px 2px; }
.corner.br { bottom: 10px; right: 10px; border-width: 0 2px 2px 0; }

/* 印章：后台用墨蓝底，跟前台登录的朱砂区分开 */
.seal {
  position: absolute;
  top: -26px;
  right: 26px;
  width: 60px;
  height: 60px;
  background: radial-gradient(circle at 35% 30%, #4a6f9c, #2b4463 60%, #16263a);
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 19px;
  line-height: 1.05;
  color: #e9f1fa;
  text-align: center;
  box-shadow: 0 8px 22px rgba(12, 24, 40, 0.7), inset 0 0 10px rgba(0, 0, 0, 0.35);
  transform: rotate(8deg);
  letter-spacing: 2px;
  padding: 4px;
}

.kicker {
  text-align: center;
  font-size: 11px;
  letter-spacing: 4px;
  color: rgba(143, 179, 217, 0.55);
  margin-bottom: 10px;
}

.title {
  text-align: center;
  font-size: 29px;
  letter-spacing: 6px;
  text-indent: 6px;
  color: var(--paper);
  text-shadow: 0 0 18px rgba(143, 179, 217, 0.45);
  margin-bottom: 8px;
}

.subtitle {
  text-align: center;
  font-size: 12px;
  letter-spacing: 5px;
  text-indent: 5px;
  color: var(--gold);
  opacity: 0.88;
  margin-bottom: 30px;
}
.subtitle::before, .subtitle::after {
  content: "———";
  color: rgba(216, 176, 106, 0.32);
  margin: 0 8px;
  letter-spacing: 0;
}

/* 表单 */
.field {
  margin-bottom: 22px;
  position: relative;
}
.field label {
  display: block;
  font-size: 13px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.85);
  margin-bottom: 8px;
}
.field input {
  width: 100%;
  padding: 12px 42px 12px 14px;
  font-size: 15px;
  font-family: inherit;
  letter-spacing: 1px;
  color: var(--paper);
  background: rgba(6, 10, 17, 0.62);
  border: 1px solid rgba(143, 179, 217, 0.24);
  border-radius: 5px;
  outline: none;
  transition: border-color 0.3s, box-shadow 0.3s;
  caret-color: var(--gold);
}
.field input::placeholder { color: rgba(232, 226, 212, 0.26); }
.field input:focus {
  border-color: var(--gold);
  box-shadow: 0 0 0 3px rgba(216, 176, 106, 0.1), 0 0 16px rgba(216, 176, 106, 0.14) inset;
}
.field .icon {
  position: absolute;
  right: 13px;
  bottom: 11px;
  font-size: 16px;
  opacity: 0.45;
  pointer-events: none;
}
.field.has-toggle input { padding-right: 40px; }
.field.error input {
  border-color: var(--cinnabar);
  box-shadow: 0 0 12px rgba(194, 58, 58, 0.25);
}
.field .err-msg {
  display: none;
  font-size: 12px;
  color: #e8756d;
  letter-spacing: 1px;
  margin-top: 6px;
}
.field.error .err-msg { display: block; }

.toggle-eye {
  position: absolute;
  right: 12px;
  bottom: 8px;
  cursor: pointer;
  font-size: 16px;
  opacity: 0.5;
  user-select: none;
  transition: opacity 0.2s;
}
.toggle-eye:hover { opacity: 1; }

.btn {
  width: 100%;
  margin-top: 4px;
  padding: 14px 0;
  font-family: inherit;
  font-size: 17px;
  letter-spacing: 7px;
  text-indent: 7px;
  color: #eaf2fb;
  background: linear-gradient(160deg, #33506f 0%, #2b4463 45%, #1b2c40 100%);
  border: 1px solid rgba(216, 176, 106, 0.5);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: transform 0.15s, box-shadow 0.3s;
  box-shadow: 0 8px 24px rgba(12, 24, 40, 0.55);
}
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 32px rgba(43, 68, 99, 0.75), 0 0 18px rgba(216, 176, 106, 0.18);
}
.btn:active { transform: translateY(0); }
.btn:disabled { opacity: 0.7; cursor: not-allowed; transform: none; }
.btn::before {
  content: "";
  position: absolute;
  top: 0;
  left: -80%;
  width: 50%;
  height: 100%;
  background: linear-gradient(105deg, transparent, rgba(216, 232, 250, 0.28), transparent);
  transform: skewX(-20deg);
  animation: bladeShine 3.8s ease-in-out infinite;
}
@keyframes bladeShine {
  0%, 62% { left: -80%; }
  100% { left: 160%; }
}

/* 演示账号 */
.demo {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-top: 22px;
  padding: 9px 12px;
  border: 1px dashed rgba(216, 176, 106, 0.28);
  border-radius: 5px;
  background: rgba(216, 176, 106, 0.05);
}
.demo-label {
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(216, 176, 106, 0.75);
}
.demo-val {
  font-family: ui-monospace, Consolas, monospace;
  font-size: 13px;
  letter-spacing: 1px;
  color: var(--paper);
  text-decoration: none;
  border-bottom: 1px dashed rgba(143, 179, 217, 0.45);
  transition: color 0.2s, border-color 0.2s;
}
.demo-val:hover { color: var(--gold); border-color: var(--gold); }

.notice {
  margin-top: 12px;
  text-align: center;
  font-size: 11px;
  letter-spacing: 1px;
  line-height: 1.7;
  color: rgba(143, 179, 217, 0.42);
}
.notice code {
  font-family: ui-monospace, Consolas, monospace;
  color: rgba(216, 176, 106, 0.6);
}

.foot {
  margin-top: 22px;
  padding-top: 18px;
  border-top: 1px solid rgba(143, 179, 217, 0.14);
  text-align: center;
  font-size: 11px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.4);
}
.foot .divider { margin: 0 7px; color: rgba(216, 176, 106, 0.3); }

.back-home {
  margin-top: 22px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.6);
  text-decoration: none;
  transition: color 0.25s, text-shadow 0.25s;
}
.back-home:hover { color: var(--gold); text-shadow: 0 0 10px rgba(216, 176, 106, 0.55); }

@media (max-width: 480px) {
  .card { padding: 38px 22px 26px; }
  .title { font-size: 23px; letter-spacing: 4px; }
}
</style>
