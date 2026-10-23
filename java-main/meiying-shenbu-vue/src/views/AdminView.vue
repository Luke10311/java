<template>
  <!-- 后台骨架：左侧菜单 + 顶部栏 + 内容区。
       目前只有「控制台」是真的，其余菜单点了给提示，别假装有功能。 -->
  <div class="admin">
    <!-- ── 侧边栏 ───────────────────────────────-->
    <aside class="aside">
      <div class="brand">
        <span class="brand-seal">捕</span>
        <span class="brand-text">
          <strong>魅影神捕</strong>
          <em>后台管理</em>
        </span>
      </div>

      <nav class="menu">
        <a
          v-for="m in MENUS"
          :key="m.key"
          class="menu-item"
          :class="{ active: m.key === active }"
          href="javascript:;"
          @click="select(m)"
        >
          <i class="glyph">{{ m.icon }}</i>
          <span>{{ m.label }}</span>
          <em v-if="!m.ready" class="soon">未接入</em>
        </a>
      </nav>

      <div class="aside-foot">
        <a href="javascript:;" @click="router.push('/')">‹ 回到前台探案录</a>
      </div>
    </aside>

    <!-- ── 右侧主体 ─────────────────────────────-->
    <div class="body">
      <header class="topbar">
        <div class="crumb">
          <span>后台管理</span><i>/</i><span class="cur">{{ currentLabel }}</span>
        </div>
        <div class="top-right">
          <span class="who" :title="`当前管理员：${adminUser}`">
            <i>🗝</i>{{ adminUser }}
          </span>
          <button class="logout" type="button" @click="onLogout">退出登录</button>
        </div>
      </header>

      <main class="content">
        <section class="welcome">
          <h2>欢迎回来，{{ adminUser }}</h2>
          <p>这里是卷宗中枢。下面几张卡片的数据是<b>实时探测</b>的，不是写死的。</p>
        </section>

        <div class="cards">
          <article class="card">
            <p class="card-label">后端服务</p>
            <p class="card-value" :class="probe.cls">{{ probe.text }}</p>
            <p class="card-note">GET /api/user/me · 打开页面时探一次</p>
          </article>

          <article class="card">
            <p class="card-label">当前管理员</p>
            <p class="card-value">{{ adminUser }}</p>
            <p class="card-note">
              {{ isDemoAuth ? '演示校验 · 未走真实鉴权' : '已接入后端鉴权' }}
            </p>
          </article>

          <article class="card">
            <p class="card-label">前端环境</p>
            <p class="card-value">Vue {{ vueVersion }}</p>
            <p class="card-note">{{ buildMode }} · Vite 5</p>
          </article>
        </div>

        <!-- 演示模式的醒目标记，别让人以为这就安全了 -->
        <p v-if="isDemoAuth" class="demo-warn">
          ⚠ 当前管理员登录是<b>前端演示校验</b>（账号密码写死在 <code>store/admin.js</code>），
          不具备真实权限控制。后端补上 <code>POST /api/admin/login</code> 后替换掉即可。
        </p>

        <section class="panel">
          <div class="panel-head">
            <h3>待接入模块</h3>
            <span class="panel-line"></span>
          </div>
          <ul class="todos">
            <li v-for="t in TODOS" :key="t.title">
              <span class="dot"></span>
              <div>
                <p class="todo-title">{{ t.title }}</p>
                <p class="todo-desc">{{ t.desc }}</p>
              </div>
            </li>
          </ul>
        </section>
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref, version as vueVersion } from 'vue'
import { useRouter } from 'vue-router'
import { clearAdminSession, getAdminUser, isDemoAuth } from '../store/admin'
import { showToast } from '../store/shell'

const router = useRouter()

const adminUser = ref(getAdminUser() || '管理员')
const active = ref('dashboard')
const buildMode = import.meta.env.MODE === 'production' ? '生产构建' : '开发模式'

const MENUS = [
  { key: 'dashboard', label: '控制台', icon: '📊', ready: true },
  { key: 'drama', label: '剧集管理', icon: '🎬', ready: false },
  { key: 'case', label: '案卷管理', icon: '📜', ready: false },
  { key: 'user', label: '捕快管理', icon: '🏮', ready: false },
  { key: 'setting', label: '系统设置', icon: '⚙', ready: false }
]

const TODOS = [
  { title: 'POST /api/admin/login', desc: '管理员登录接口。现在前端是演示校验，等它上线再替换 store/admin.js 里的 authenticateAdmin。' },
  { title: 'GET /api/drama/**', desc: '剧集数据接口。首页目前仍用本地示例数据（src/data/dramas.js）兜底。' },
  { title: '剧集 / 案卷 增删改查', desc: '后台最核心的一块，需要后端先给出分页查询与写入接口。' },
  { title: '捕快账号管理', desc: '需要后端提供用户分页列表，现在只有登录 / 注册 / 取当前用户三个接口。' }
]

const currentLabel = computed(
  () => (MENUS.find((m) => m.key === active.value) || MENUS[0]).label
)

// 后端探活：只要有 HTTP 响应就算在线，连不上才算离线
const probe = reactive({ text: '探测中 …', cls: '' })

async function probeBackend() {
  const started = performance.now()
  try {
    await fetch('/api/user/me')
    probe.text = `在线 · ${Math.round(performance.now() - started)} ms`
    probe.cls = 'ok'
  } catch {
    probe.text = '离线 · 连不上 8080'
    probe.cls = 'bad'
  }
}

onMounted(probeBackend)

function select(item) {
  if (!item.ready) {
    showToast(`「${item.label}」尚未接入，先把接口补齐。`)
    return
  }
  active.value = item.key
}

function onLogout() {
  clearAdminSession()
  showToast('已退出中枢，密钥作废。')
  router.replace('/admin/login')
}
</script>

<style scoped>
.admin {
  display: flex;
  height: 100vh;
  background:
    radial-gradient(ellipse at 76% -12%, rgba(43, 68, 99, 0.5) 0%, transparent 58%),
    var(--ink-0);
  color: var(--paper);
}

/* ── 侧边栏 ─────────────────────────────────── */
.aside {
  width: 224px;
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  background: linear-gradient(180deg, rgba(14, 21, 34, 0.96), rgba(7, 9, 15, 0.98));
  border-right: 1px solid rgba(216, 176, 106, 0.14);
}

.brand {
  display: flex;
  align-items: center;
  gap: 11px;
  height: 68px;
  padding: 0 20px;
  border-bottom: 1px solid rgba(216, 176, 106, 0.1);
}
.brand-seal {
  width: 34px;
  height: 34px;
  flex-shrink: 0;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  color: #ffe6cf;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 62%, #8e2222);
  box-shadow: 0 6px 16px rgba(194, 58, 58, 0.38), inset 0 0 8px rgba(0, 0, 0, 0.35);
  transform: rotate(-6deg);
}
.brand-text { display: flex; flex-direction: column; line-height: 1.25; min-width: 0; }
.brand-text strong {
  font-size: 17px;
  letter-spacing: 3px;
  font-weight: 400;
  color: var(--paper);
}
.brand-text em {
  font-style: normal;
  font-size: 11px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.62);
}

.menu {
  flex: 1;
  padding: 16px 12px;
  display: flex;
  flex-direction: column;
  gap: 4px;
  overflow-y: auto;
}
.menu-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 11px 12px;
  border-radius: 6px;
  border: 1px solid transparent;
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.62);
  text-decoration: none;
  transition: color 0.22s, background 0.22s, border-color 0.22s;
}
.menu-item:hover {
  color: var(--paper);
  background: rgba(143, 179, 217, 0.07);
}
.menu-item.active {
  color: var(--gold);
  background: rgba(216, 176, 106, 0.09);
  border-color: rgba(216, 176, 106, 0.26);
}
.menu-item .glyph { font-style: normal; font-size: 15px; opacity: 0.85; }
.menu-item > span { flex: 1; }
.soon {
  font-style: normal;
  font-size: 10px;
  letter-spacing: 0;
  padding: 2px 5px;
  border-radius: 3px;
  color: rgba(143, 179, 217, 0.62);
  background: rgba(143, 179, 217, 0.1);
  border: 1px solid rgba(143, 179, 217, 0.16);
}

.aside-foot {
  padding: 16px 20px;
  border-top: 1px solid rgba(216, 176, 106, 0.1);
}
.aside-foot a {
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.6);
  text-decoration: none;
  transition: color 0.22s;
}
.aside-foot a:hover { color: var(--gold); }

/* ── 主体 ───────────────────────────────────── */
.body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
}

.topbar {
  height: 68px;
  flex-shrink: 0;
  padding: 0 28px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(216, 176, 106, 0.12);
  background: rgba(7, 9, 15, 0.55);
  backdrop-filter: blur(8px);
}
.crumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.48);
}
.crumb i { font-style: normal; color: rgba(216, 176, 106, 0.4); }
.crumb .cur { color: var(--gold); }

.top-right { display: flex; align-items: center; gap: 12px; }
.who {
  display: flex;
  align-items: center;
  gap: 6px;
  max-width: 160px;
  padding: 6px 12px;
  font-size: 13px;
  letter-spacing: 1px;
  color: var(--paper);
  border: 1px solid rgba(216, 176, 106, 0.24);
  border-radius: 5px;
  background: rgba(216, 176, 106, 0.06);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.who i { font-style: normal; font-size: 12px; }

.logout {
  padding: 7px 16px;
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.72);
  background: transparent;
  border: 1px solid rgba(143, 179, 217, 0.28);
  border-radius: 5px;
  cursor: pointer;
  transition: color 0.22s, border-color 0.22s, box-shadow 0.22s;
}
.logout:hover {
  color: #f0a49c;
  border-color: var(--cinnabar);
  box-shadow: 0 0 14px rgba(194, 58, 58, 0.3);
}

.content {
  flex: 1;
  overflow-y: auto;
  padding: 30px 28px 40px;
}

.welcome h2 {
  font-size: 25px;
  font-weight: 400;
  letter-spacing: 3px;
  color: var(--paper);
  text-shadow: 0 0 16px rgba(143, 179, 217, 0.32);
  margin-bottom: 8px;
}
.welcome p {
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.5);
  margin-bottom: 26px;
}
.welcome b { color: rgba(216, 176, 106, 0.9); font-weight: 400; }

/* 卡片 */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
  gap: 16px;
  margin-bottom: 20px;
}
.card {
  padding: 20px 20px 18px;
  border-radius: 8px;
  border: 1px solid rgba(216, 176, 106, 0.16);
  background: linear-gradient(160deg, rgba(18, 26, 43, 0.8), rgba(10, 14, 24, 0.86));
  box-shadow: inset 0 1px 0 rgba(216, 176, 106, 0.08);
  transition: border-color 0.25s, transform 0.25s;
}
.card:hover { border-color: rgba(216, 176, 106, 0.34); transform: translateY(-2px); }
.card-label {
  font-size: 12px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.7);
  margin-bottom: 10px;
}
.card-value {
  font-size: 21px;
  letter-spacing: 1px;
  color: var(--paper);
  margin-bottom: 8px;
}
.card-value.ok { color: #7fd6a5; }
.card-value.bad { color: #e8756d; }
.card-note {
  font-size: 11px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.34);
}

/* 演示提示 */
.demo-warn {
  margin-bottom: 24px;
  padding: 12px 16px;
  font-size: 12.5px;
  line-height: 1.85;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.66);
  border: 1px solid rgba(194, 58, 58, 0.34);
  border-left: 3px solid var(--cinnabar);
  border-radius: 5px;
  background: rgba(194, 58, 58, 0.07);
}
.demo-warn b { color: #f0a49c; font-weight: 400; }
.demo-warn code {
  font-family: ui-monospace, Consolas, monospace;
  font-size: 11.5px;
  color: rgba(216, 176, 106, 0.85);
}

/* 待接入清单 */
.panel {
  padding: 22px 22px 8px;
  border-radius: 8px;
  border: 1px solid rgba(143, 179, 217, 0.16);
  background: rgba(12, 17, 28, 0.55);
}
.panel-head {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 8px;
}
.panel-head h3 {
  font-size: 16px;
  font-weight: 400;
  letter-spacing: 4px;
  color: var(--gold);
}
.panel-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.3), transparent);
}

.todos { list-style: none; }
.todos li {
  display: flex;
  gap: 12px;
  padding: 14px 0;
  border-bottom: 1px dashed rgba(143, 179, 217, 0.12);
}
.todos li:last-child { border-bottom: none; }
.todos .dot {
  width: 6px;
  height: 6px;
  margin-top: 8px;
  flex-shrink: 0;
  border-radius: 50%;
  background: rgba(216, 176, 106, 0.75);
  box-shadow: 0 0 8px rgba(216, 176, 106, 0.5);
}
.todo-title {
  font-size: 14px;
  letter-spacing: 1px;
  color: var(--paper);
  margin-bottom: 4px;
  font-family: ui-monospace, Consolas, monospace;
}
.todo-desc {
  font-size: 12.5px;
  line-height: 1.75;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.45);
}

@media (max-width: 760px) {
  .aside { width: 62px; }
  .brand { justify-content: center; padding: 0; }
  .brand-text, .menu-item > span, .soon, .aside-foot a { display: none; }
  .menu-item { justify-content: center; padding: 12px 0; }
  .content { padding: 22px 16px 32px; }
  .topbar { padding: 0 16px; }
  .who { display: none; }
}
</style>
