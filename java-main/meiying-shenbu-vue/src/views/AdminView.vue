<template>
  <!-- 后台：左侧菜单 + 顶部栏 + 内容区，4 个模块全部走 /api/admin/** -->
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
          <em v-if="m.count !== undefined" class="count">{{ m.count }}</em>
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
            <i>🗝</i>{{ adminRealName || adminUser }}
          </span>
          <button class="logout" type="button" @click="onLogout">退出登录</button>
        </div>
      </header>

      <main class="content">
        <!-- ══════════ 控制台 ══════════ -->
        <template v-if="active === 'dashboard'">
          <section class="welcome">
            <h2>欢迎回来，{{ adminRealName || adminUser }}</h2>
            <p>这里是卷宗中枢。下面的数字来自数据库实时统计，改动剧集 / 案卷后立刻生效。</p>
          </section>

          <div class="cards">
            <article class="card">
              <p class="card-label">后端服务</p>
              <p class="card-value" :class="probe.cls">{{ probe.text }}</p>
              <p class="card-note">GET /api/admin/stats · 进页面探一次</p>
            </article>
            <article class="card">
              <p class="card-label">剧集总数</p>
              <p class="card-value">{{ stats.dramaCount ?? '—' }}</p>
              <p class="card-note">热播 {{ stats.hotCount ?? '—' }} · 上架 {{ stats.onlineCount ?? '—' }}</p>
            </article>
            <article class="card">
              <p class="card-label">案卷总数</p>
              <p class="card-value">{{ stats.caseCount ?? '—' }}</p>
              <p class="card-note">缉查中 {{ stats.caseOpen ?? '—' }} 卷</p>
            </article>
            <article class="card">
              <p class="card-label">在册捕快</p>
              <p class="card-value">{{ stats.userCount ?? '—' }}</p>
              <p class="card-note">管理员 {{ stats.adminCount ?? '—' }} 人</p>
            </article>
          </div>

          <section class="panel">
            <div class="panel-head">
              <h3>最近入库</h3>
              <span class="panel-line"></span>
              <a class="link" href="javascript:;" @click="select(MENUS[1])">去剧集管理 ›</a>
            </div>
            <ul class="recent">
              <li v-for="r in stats.recent || []" :key="r.id">
                <span class="mini-poster">
                  <img v-if="r.poster" :src="r.poster" alt="" @error="($event.target.style.display = 'none')">
                </span>
                <div class="recent-main">
                  <p class="recent-title">{{ r.title }}</p>
                  <p class="recent-note">评分 {{ r.score }} · {{ r.status === 1 ? '已上架' : '已下架' }}</p>
                </div>
                <button class="ghost" type="button" @click="openDramaById(r.id)">查看</button>
              </li>
              <li v-if="!(stats.recent || []).length" class="empty">暂无数据，去剧集管理新增一卷。</li>
            </ul>
          </section>

          <p class="total-views">
            全站累计热度 <b>{{ formatViews(stats.totalViews) }}</b>
            <span>· 最近刷新 {{ refreshedAt || '—' }}</span>
          </p>
        </template>

        <!-- ══════════ 剧集管理 ══════════ -->
        <template v-else-if="active === 'drama'">
          <section class="module-head">
            <div>
              <h2>剧集管理</h2>
              <p>共 {{ drama.total }} 卷 · 首页热播与剧集页都读这张表</p>
            </div>
            <button class="primary" type="button" @click="newDrama">＋ 新增剧集</button>
          </section>

          <div class="toolbar">
            <input v-model.trim="drama.keyword" class="input" placeholder="搜剧名…" @keyup.enter="loadDrama(1)">
            <select v-model="drama.genre" class="input" @change="loadDrama(1)">
              <option value="">全部题材</option>
              <option v-for="g in GENRES" :key="g" :value="g">{{ g }}</option>
            </select>
            <select v-model="drama.status" class="input" @change="loadDrama(1)">
              <option value="">全部状态</option>
              <option :value="1">已上架</option>
              <option :value="0">已下架</option>
            </select>
            <button class="ghost" type="button" @click="loadDrama(1)">查询</button>
          </div>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th style="width: 64px">海报</th>
                  <th>剧名</th>
                  <th style="width: 84px">年份</th>
                  <th style="width: 130px">题材</th>
                  <th style="width: 70px">评分</th>
                  <th style="width: 90px">热度</th>
                  <th style="width: 70px">集数</th>
                  <th style="width: 90px">热播</th>
                  <th style="width: 90px">状态</th>
                  <th style="width: 160px">操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in drama.items" :key="row.id">
                  <td>
                    <span class="mini-poster">
                      <img v-if="row.poster" :src="row.poster" alt="" @error="($event.target.style.display = 'none')">
                    </span>
                  </td>
                  <td class="cell-title">{{ row.title }}</td>
                  <td>{{ row.year }}</td>
                  <td class="dim">{{ row.genres }}</td>
                  <td>{{ row.score }}</td>
                  <td class="dim">{{ formatViews(row.views) }}</td>
                  <td>{{ row.episodes }}</td>
                  <td>
                    <span class="tag" :class="row.isHot === 1 ? 'on' : ''">{{ row.isHot === 1 ? '热播中' : '未推' }}</span>
                  </td>
                  <td>
                    <span class="tag" :class="row.status === 1 ? 'on' : 'off'">{{ row.status === 1 ? '已上架' : '已下架' }}</span>
                  </td>
                  <td class="ops">
                    <button class="link" type="button" @click="editDrama(row)">编辑</button>
                    <button class="link" type="button" @click="toggleDrama(row)">
                      {{ row.status === 1 ? '下架' : '上架' }}
                    </button>
                    <button class="link danger" type="button" @click="removeDrama(row)">删除</button>
                  </td>
                </tr>
                <tr v-if="!drama.items.length">
                  <td colspan="10" class="empty">没有符合条件的剧集。</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="pager">
            <button class="ghost" :disabled="drama.page <= 1 || drama.loading" @click="loadDrama(drama.page - 1)">上一页</button>
            <span>第 {{ drama.page }} / {{ drama.totalPages || 1 }} 页</span>
            <button class="ghost" :disabled="drama.page >= drama.totalPages || drama.loading" @click="loadDrama(drama.page + 1)">下一页</button>
          </div>
        </template>

        <!-- ══════════ 案卷管理 ══════════ -->
        <template v-else-if="active === 'case'">
          <section class="module-head">
            <div>
              <h2>案卷管理</h2>
              <p>共 {{ cases.total }} 卷 · 前台「奇案」区块与案卷详情页的图文</p>
            </div>
            <button class="primary" type="button" @click="newCase">＋ 新立一案</button>
          </section>

          <div class="toolbar">
            <input v-model.trim="cases.keyword" class="input" placeholder="搜案名…" @keyup.enter="loadCases(1)">
            <select v-model="cases.status" class="input" @change="loadCases(1)">
              <option value="">全部状态</option>
              <option v-for="s in CASE_STATUS" :key="s" :value="s">{{ s }}</option>
            </select>
            <button class="ghost" type="button" @click="loadCases(1)">查询</button>
          </div>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th style="width: 64px">插图</th>
                  <th style="width: 140px">卷号</th>
                  <th>案名</th>
                  <th style="width: 120px">题签</th>
                  <th style="width: 150px">案发地</th>
                  <th style="width: 90px">状态</th>
                  <th style="width: 120px">悬赏</th>
                  <th style="width: 130px">操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in cases.items" :key="row.id">
                  <td>
                    <span class="mini-poster">
                      <img v-if="row.image" :src="row.image" alt="" @error="($event.target.style.display = 'none')">
                    </span>
                  </td>
                  <td class="dim">{{ row.caseNo || '—' }}</td>
                  <td class="cell-title">{{ row.title }}</td>
                  <td class="dim">{{ row.tag }}</td>
                  <td class="dim">{{ row.place }}</td>
                  <td><span class="tag" :class="row.status === '已封卷' ? 'off' : 'on'">{{ row.status }}</span></td>
                  <td class="dim">{{ row.reward }}</td>
                  <td class="ops">
                    <button class="link" type="button" @click="editCase(row)">编辑</button>
                    <button class="link danger" type="button" @click="removeCase(row)">删除</button>
                  </td>
                </tr>
                <tr v-if="!cases.items.length">
                  <td colspan="8" class="empty">没有符合条件的案卷。</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="pager">
            <button class="ghost" :disabled="cases.page <= 1 || cases.loading" @click="loadCases(cases.page - 1)">上一页</button>
            <span>第 {{ cases.page }} / {{ cases.totalPages || 1 }} 页</span>
            <button class="ghost" :disabled="cases.page >= cases.totalPages || cases.loading" @click="loadCases(cases.page + 1)">下一页</button>
          </div>
        </template>

        <!-- ══════════ 捕快管理 ══════════ -->
        <template v-else-if="active === 'user'">
          <section class="module-head">
            <div>
              <h2>捕快管理</h2>
              <p>共 {{ users.total }} 位在册捕快 · 与后台管理员是两套账号</p>
            </div>
          </section>

          <div class="toolbar">
            <input v-model.trim="users.keyword" class="input" placeholder="搜名号…" @keyup.enter="loadUsers(1)">
            <button class="ghost" type="button" @click="loadUsers(1)">查询</button>
          </div>

          <div class="table-wrap">
            <table class="table">
              <thead>
                <tr>
                  <th style="width: 90px">编号</th>
                  <th>名号</th>
                  <th style="width: 220px">入籍时间</th>
                  <th style="width: 130px">操作</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in users.items" :key="row.id">
                  <td class="dim">#{{ row.id }}</td>
                  <td class="cell-title">{{ row.username }}</td>
                  <td class="dim">{{ formatTime(row.createdAt) }}</td>
                  <td class="ops">
                    <button class="link danger" type="button" @click="removeUser(row)">注销</button>
                  </td>
                </tr>
                <tr v-if="!users.items.length">
                  <td colspan="4" class="empty">还没有捕快入籍。</td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="pager">
            <button class="ghost" :disabled="users.page <= 1 || users.loading" @click="loadUsers(users.page - 1)">上一页</button>
            <span>第 {{ users.page }} / {{ users.totalPages || 1 }} 页</span>
            <button class="ghost" :disabled="users.page >= users.totalPages || users.loading" @click="loadUsers(users.page + 1)">下一页</button>
          </div>
        </template>

        <!-- ══════════ 系统设置 ══════════ -->
        <template v-else-if="active === 'setting'">
          <section class="module-head">
            <div>
              <h2>系统设置</h2>
              <p>站点文案与开关存在 site_config 表，保存后前台读取生效</p>
            </div>
          </section>

          <section class="panel">
            <div class="panel-head">
              <h3>站点配置</h3>
              <span class="panel-line"></span>
            </div>
            <form class="settings" @submit.prevent="onSaveConfig">
              <label v-for="c in configs" :key="c.configKey" class="setting-row">
                <span class="setting-label">
                  {{ c.label || c.configKey }}
                  <em>{{ c.remark }}</em>
                </span>
                <input v-model="configForm[c.configKey]" class="input" :placeholder="c.configKey">
              </label>
              <p v-if="!configs.length" class="empty">配置表为空，请先执行 admin_module_init.sql。</p>
              <div class="setting-actions">
                <button class="primary" type="submit" :disabled="savingConfig">{{ savingConfig ? '保存中…' : '保存配置' }}</button>
              </div>
            </form>
          </section>

          <section class="panel">
            <div class="panel-head">
              <h3>更换通行密钥</h3>
              <span class="panel-line"></span>
            </div>
            <form class="settings" @submit.prevent="onChangePassword">
              <label class="setting-row">
                <span class="setting-label">原密钥</span>
                <input v-model="pwdForm.oldPassword" class="input" type="password" autocomplete="current-password" placeholder="当前通行密钥">
              </label>
              <label class="setting-row">
                <span class="setting-label">新密钥<em>至少 6 位</em></span>
                <input v-model="pwdForm.newPassword" class="input" type="password" autocomplete="new-password" placeholder="新的通行密钥">
              </label>
              <label class="setting-row">
                <span class="setting-label">确认新密钥</span>
                <input v-model="pwdForm.confirm" class="input" type="password" autocomplete="new-password" placeholder="再输一次">
              </label>
              <div class="setting-actions">
                <button class="primary" type="submit" :disabled="savingPwd">{{ savingPwd ? '提交中…' : '更换密钥' }}</button>
              </div>
            </form>
          </section>
        </template>
      </main>
    </div>

    <!-- ── 编辑弹窗：剧集 / 案卷共用 ─────────────────-->
    <div v-if="editor.visible" class="mask" @click.self="closeEditor">
      <div class="modal">
        <header class="modal-head">
          <h3>{{ editor.type === 'drama' ? (editor.form.id ? '编辑剧集' : '新增剧集') : (editor.form.id ? '编辑案卷' : '新立一案') }}</h3>
          <button class="close" type="button" @click="closeEditor">✕</button>
        </header>

        <!-- 剧集表单 -->
        <div v-if="editor.type === 'drama'" class="form-grid">
          <label class="field"><span>剧名 *</span>
            <input v-model.trim="editor.form.title" class="input" placeholder="如：长安夜行录">
          </label>
          <label class="field"><span>年份</span>
            <input v-model.number="editor.form.year" class="input" type="number" min="1990" max="2100">
          </label>
          <label class="field"><span>题材<em>逗号分隔</em></span>
            <input v-model.trim="editor.form.genres" class="input" placeholder="悬疑,古装">
          </label>
          <label class="field"><span>评分<em>0-10</em></span>
            <input v-model.number="editor.form.score" class="input" type="number" step="0.1" min="0" max="10">
          </label>
          <label class="field"><span>热度（播放量）</span>
            <input v-model.number="editor.form.views" class="input" type="number" min="0">
          </label>
          <label class="field"><span>集数</span>
            <input v-model.number="editor.form.episodes" class="input" type="number" min="1">
          </label>
          <label class="field"><span>角标<em>可空</em></span>
            <input v-model.trim="editor.form.badge" class="input" placeholder="独播 / 热播 / 新案">
          </label>
          <label class="field"><span>海报地址</span>
            <input v-model.trim="editor.form.poster" class="input" placeholder="/images/poster-1.jpg">
          </label>
          <label class="field"><span>色相<em>兜底色相 0-360</em></span>
            <input v-model.number="editor.form.hue" class="input" type="number" min="0" max="360">
          </label>
          <label class="field"><span>调色偏移</span>
            <input v-model.number="editor.form.hueShift" class="input" type="number">
          </label>
          <label class="field check">
            <input v-model="editor.form.isHot" type="checkbox" :true-value="1" :false-value="0">
            <span>首页热播</span>
          </label>
          <label class="field check">
            <input v-model="editor.form.status" type="checkbox" :true-value="1" :false-value="0">
            <span>上架</span>
          </label>
          <label class="field full"><span>剧情简介</span>
            <textarea v-model.trim="editor.form.synopsis" class="input" rows="3" placeholder="详情页正文，可留空"></textarea>
          </label>
        </div>

        <!-- 案卷表单 -->
        <div v-else class="form-grid">
          <label class="field"><span>案名 *</span>
            <input v-model.trim="editor.form.title" class="input" placeholder="如：香消玉殒枯血案">
          </label>
          <label class="field"><span>卷号</span>
            <input v-model.trim="editor.form.caseNo" class="input" placeholder="甲字第〇二六卷">
          </label>
          <label class="field"><span>题签</span>
            <input v-model.trim="editor.form.tag" class="input" placeholder="疑涉妖异 / 关联三案">
          </label>
          <label class="field"><span>案发地</span>
            <input v-model.trim="editor.form.place" class="input" placeholder="云梦泽·落花坞">
          </label>
          <label class="field"><span>状态</span>
            <select v-model="editor.form.status" class="input">
              <option v-for="s in CASE_STATUS" :key="s" :value="s">{{ s }}</option>
            </select>
          </label>
          <label class="field"><span>悬赏</span>
            <input v-model.trim="editor.form.reward" class="input" placeholder="悬赏 七千两">
          </label>
          <label class="field full"><span>插图地址</span>
            <input v-model.trim="editor.form.image" class="input" placeholder="/images/case-8.jpg">
          </label>
          <label class="field full"><span>案情摘要</span>
            <textarea v-model.trim="editor.form.description" class="input" rows="3" placeholder="卡片上的一段话"></textarea>
          </label>
          <label class="field full"><span>完整卷宗</span>
            <textarea v-model.trim="editor.form.summary" class="input" rows="4" placeholder="详情页正文"></textarea>
          </label>
          <label class="field check">
            <input v-model="editor.form.isActive" type="checkbox" :true-value="1" :false-value="0">
            <span>前台展示</span>
          </label>
        </div>

        <footer class="modal-foot">
          <button class="ghost" type="button" @click="closeEditor">取消</button>
          <button class="primary" type="button" :disabled="editor.saving" @click="submitEditor">
            {{ editor.saving ? '保存中…' : '保存' }}
          </button>
        </footer>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter } from 'vue-router'
import {
  changeAdminPassword,
  deleteCase,
  deleteDrama,
  deleteUser,
  fetchCasePage,
  fetchConfig,
  fetchDramaPage,
  fetchStats,
  fetchUserPage,
  saveCase,
  saveConfig,
  saveDrama
} from '../api/admin'
import {
  clearAdminSession,
  getAdminRealName,
  getAdminUser,
  isSessionExpired
} from '../store/admin'
import { showToast } from '../store/shell'

const router = useRouter()

const adminUser = ref(getAdminUser() || '管理员')
const adminRealName = ref(getAdminRealName())
const active = ref('dashboard')

const GENRES = ['悬疑', '古装', '武侠', '奇幻', '权谋']
const CASE_STATUS = ['缉查中', '待复核', '已封卷']

const stats = ref({})
const probe = reactive({ text: '探测中 …', cls: '' })
const refreshedAt = ref('')

const MENUS = [
  { key: 'dashboard', label: '控制台', icon: '📊' },
  { key: 'drama', label: '剧集管理', icon: '🎬' },
  { key: 'case', label: '案卷管理', icon: '📜' },
  { key: 'user', label: '捕快管理', icon: '🏮' },
  { key: 'setting', label: '系统设置', icon: '⚙' }
]

const currentLabel = computed(
  () => (MENUS.find((m) => m.key === active.value) || MENUS[0]).label
)

/* ── 通用：会话失效统一处理 ─────────────────── */
async function call(promise) {
  const res = await promise
  if (!res.ok && isSessionExpired(res.msg)) {
    clearAdminSession()
    showToast('会话已失效，请重新登录。')
    router.replace({ name: 'admin-login', query: { redirect: '/admin' } })
  }
  return res
}

function toast(res, okMsg) {
  showToast(res.ok ? okMsg || res.msg : res.msg)
  return res.ok
}

/* ── 控制台 ─────────────────────────────── */
async function loadStats() {
  const started = performance.now()
  const res = await call(fetchStats())
  if (res.ok) {
    stats.value = res.data || {}
    probe.text = `在线 · ${Math.round(performance.now() - started)} ms`
    probe.cls = 'ok'
    refreshedAt.value = new Date().toLocaleTimeString('zh-CN', { hour12: false })
  } else {
    probe.text = '离线 · 接口未通'
    probe.cls = 'bad'
  }
}

/* ── 剧集 ───────────────────────────────── */
const drama = reactive({
  items: [], total: 0, totalPages: 0, page: 1, size: 8,
  keyword: '', genre: '', status: '', loading: false
})

async function loadDrama(page = drama.page) {
  drama.loading = true
  const res = await call(fetchDramaPage({
    keyword: drama.keyword,
    genre: drama.genre,
    status: drama.status,
    page,
    size: drama.size
  }))
  drama.loading = false
  if (!res.ok) {
    toast(res)
    return
  }
  drama.items = res.data.items || []
  drama.total = res.data.total || 0
  drama.totalPages = res.data.totalPages || 0
  drama.page = res.data.page || 1
}

function newDrama() {
  editor.type = 'drama'
  editor.form = {
    id: null, title: '', year: new Date().getFullYear(), genres: '悬疑',
    score: 8.0, views: 0, episodes: 12, badge: '', poster: '',
    hue: 212, hueShift: 0, isHot: 0, status: 1, synopsis: ''
  }
  editor.visible = true
}

function editDrama(row) {
  editor.type = 'drama'
  editor.form = { ...row }
  editor.visible = true
}

async function toggleDrama(row) {
  const res = await call(saveDrama({ ...row, status: row.status === 1 ? 0 : 1 }))
  if (toast(res, row.status === 1 ? '已下架。' : '已上架。')) {
    loadDrama(drama.page)
    loadStats()
  }
}

async function removeDrama(row) {
  if (!window.confirm(`确定删除《${row.title}》？删除后前台不再展示。`)) return
  const res = await call(deleteDrama(row.id))
  if (toast(res, '剧集已删除。')) {
    loadDrama(drama.items.length === 1 && drama.page > 1 ? drama.page - 1 : drama.page)
    loadStats()
  }
}

/** 控制台「最近入库」点进去：切到剧集管理并定位到该卷的编辑弹窗 */
async function openDramaById(id) {
  active.value = 'drama'
  await loadDrama(1)
  const row = drama.items.find((d) => d.id === id)
  if (row) {
    editDrama(row)
  } else {
    showToast('该剧集不在当前页，可在剧集管理里搜索。')
  }
}

/* ── 案卷 ───────────────────────────────── */
const cases = reactive({
  items: [], total: 0, totalPages: 0, page: 1, size: 8,
  keyword: '', status: '', loading: false
})

async function loadCases(page = cases.page) {
  cases.loading = true
  const res = await call(fetchCasePage({
    keyword: cases.keyword,
    status: cases.status,
    page,
    size: cases.size
  }))
  cases.loading = false
  if (!res.ok) {
    toast(res)
    return
  }
  cases.items = res.data.items || []
  cases.total = res.data.total || 0
  cases.totalPages = res.data.totalPages || 0
  cases.page = res.data.page || 1
}

function newCase() {
  editor.type = 'case'
  editor.form = {
    id: null, caseNo: '', title: '', tag: '', description: '', place: '',
    status: '缉查中', reward: '', image: '', summary: '', isActive: 1
  }
  editor.visible = true
}

function editCase(row) {
  editor.type = 'case'
  editor.form = { ...row }
  editor.visible = true
}

async function removeCase(row) {
  if (!window.confirm(`确定撤下案卷「${row.title}」？`)) return
  const res = await call(deleteCase(row.id))
  if (toast(res, '案卷已撤下。')) {
    loadCases(cases.items.length === 1 && cases.page > 1 ? cases.page - 1 : cases.page)
    loadStats()
  }
}

/* ── 捕快 ───────────────────────────────── */
const users = reactive({
  items: [], total: 0, totalPages: 0, page: 1, size: 10,
  keyword: '', loading: false
})

async function loadUsers(page = users.page) {
  users.loading = true
  const res = await call(fetchUserPage({ keyword: users.keyword, page, size: users.size }))
  users.loading = false
  if (!res.ok) {
    toast(res)
    return
  }
  users.items = res.data.items || []
  users.total = res.data.total || 0
  users.totalPages = res.data.totalPages || 0
  users.page = res.data.page || 1
}

async function removeUser(row) {
  if (!window.confirm(`确定注销捕快「${row.username}」？该账号将无法再登录。`)) return
  const res = await call(deleteUser(row.id))
  if (toast(res, '该捕快已注销。')) {
    loadUsers(users.items.length === 1 && users.page > 1 ? users.page - 1 : users.page)
    loadStats()
  }
}

/* ── 系统设置 ───────────────────────────── */
const configs = ref([])
const configForm = reactive({})
const savingConfig = ref(false)
const pwdForm = reactive({ oldPassword: '', newPassword: '', confirm: '' })
const savingPwd = ref(false)

async function loadConfigs() {
  const res = await call(fetchConfig())
  if (!res.ok) {
    toast(res)
    return
  }
  configs.value = res.data || []
  configs.value.forEach((c) => {
    configForm[c.configKey] = c.configValue ?? ''
  })
}

async function onSaveConfig() {
  savingConfig.value = true
  const res = await call(saveConfig({ ...configForm }))
  savingConfig.value = false
  toast(res, '配置已保存。')
}

async function onChangePassword() {
  if (!pwdForm.oldPassword || !pwdForm.newPassword) {
    showToast('请填写原密钥与新密钥。')
    return
  }
  if (pwdForm.newPassword.length < 6) {
    showToast('新密钥至少 6 位。')
    return
  }
  if (pwdForm.newPassword !== pwdForm.confirm) {
    showToast('两次输入的新密钥不一致。')
    return
  }
  savingPwd.value = true
  const res = await call(changeAdminPassword(pwdForm.oldPassword, pwdForm.newPassword))
  savingPwd.value = false
  if (res.ok) {
    showToast('密钥已更换，请重新登录。')
    clearAdminSession()
    router.replace('/admin/login')
  } else {
    toast(res)
  }
}

/* ── 弹窗 ───────────────────────────────── */
const editor = reactive({ visible: false, type: 'drama', saving: false, form: {} })

function closeEditor() {
  editor.visible = false
  editor.saving = false
}

async function submitEditor() {
  if (!String(editor.form.title || '').trim()) {
    showToast(editor.type === 'drama' ? '剧名不可为空。' : '案名不可为空。')
    return
  }
  editor.saving = true
  const res = editor.type === 'drama'
    ? await call(saveDrama(editor.form))
    : await call(saveCase(editor.form))
  editor.saving = false

  if (!toast(res)) return
  closeEditor()
  if (editor.type === 'drama') loadDrama(drama.page)
  else loadCases(cases.page)
  loadStats()
}

/* ── 菜单切换 ───────────────────────────── */
function select(item) {
  active.value = item.key
  if (item.key === 'dashboard') loadStats()
  if (item.key === 'drama') loadDrama(1)
  if (item.key === 'case') loadCases(1)
  if (item.key === 'user') loadUsers(1)
  if (item.key === 'setting') loadConfigs()
}

function onLogout() {
  clearAdminSession()
  showToast('已退出中枢，密钥作废。')
  router.replace('/admin/login')
}

/* ── 小工具 ─────────────────────────────── */
function formatViews(n) {
  const v = Number(n) || 0
  if (v >= 10000) return `${(v / 10000).toFixed(1)} 万`
  return String(v)
}

function formatTime(v) {
  if (!v) return '—'
  const s = String(v).replace('T', ' ')
  return s.length > 16 ? s.slice(0, 16) : s
}

onMounted(() => {
  loadStats()
  loadDrama(1)
  loadCases(1)
})
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
.menu-item:hover { color: var(--paper); background: rgba(143, 179, 217, 0.07); }
.menu-item.active {
  color: var(--gold);
  background: rgba(216, 176, 106, 0.09);
  border-color: rgba(216, 176, 106, 0.26);
}
.menu-item .glyph { font-style: normal; font-size: 15px; opacity: 0.85; }
.menu-item > span { flex: 1; }
.count {
  font-style: normal;
  font-size: 11px;
  padding: 1px 6px;
  border-radius: 9px;
  color: rgba(216, 176, 106, 0.9);
  background: rgba(216, 176, 106, 0.12);
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
.body { flex: 1; min-width: 0; display: flex; flex-direction: column; }

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

.content { flex: 1; overflow-y: auto; padding: 30px 28px 40px; }

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

/* 卡片 */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
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
.card-note { font-size: 11px; letter-spacing: 1px; color: rgba(232, 226, 212, 0.34); }

/* 面板 */
.panel {
  margin-bottom: 20px;
  padding: 22px 22px 18px;
  border-radius: 8px;
  border: 1px solid rgba(143, 179, 217, 0.16);
  background: rgba(12, 17, 28, 0.55);
}
.panel-head {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 12px;
}
.panel-head h3 {
  font-size: 16px;
  font-weight: 400;
  letter-spacing: 4px;
  color: var(--gold);
  white-space: nowrap;
}
.panel-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.3), transparent);
}

/* 最近入库 */
.recent { list-style: none; }
.recent li {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 10px 0;
  border-bottom: 1px dashed rgba(143, 179, 217, 0.12);
}
.recent li:last-child { border-bottom: none; }
.recent-main { flex: 1; min-width: 0; }
.recent-title { font-size: 14px; letter-spacing: 1px; color: var(--paper); }
.recent-note { font-size: 12px; color: rgba(232, 226, 212, 0.4); margin-top: 3px; }

.mini-poster {
  width: 38px;
  height: 52px;
  flex-shrink: 0;
  border-radius: 4px;
  overflow: hidden;
  display: inline-flex;
  background: linear-gradient(150deg, #24354d, #10161f);
  border: 1px solid rgba(216, 176, 106, 0.16);
}
.mini-poster img { width: 100%; height: 100%; object-fit: cover; }

.total-views {
  font-size: 12.5px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.42);
}
.total-views b { color: var(--gold); font-weight: 400; }

/* 模块头 */
.module-head {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}
.module-head h2 {
  font-size: 23px;
  font-weight: 400;
  letter-spacing: 3px;
  color: var(--paper);
  margin-bottom: 6px;
}
.module-head p { font-size: 12.5px; letter-spacing: 1px; color: rgba(232, 226, 212, 0.45); }

/* 工具栏 */
.toolbar {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 14px;
}
.input {
  padding: 9px 12px;
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 1px;
  color: var(--paper);
  background: rgba(8, 12, 20, 0.8);
  border: 1px solid rgba(143, 179, 217, 0.22);
  border-radius: 5px;
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.input:focus {
  border-color: rgba(216, 176, 106, 0.55);
  box-shadow: 0 0 0 2px rgba(216, 176, 106, 0.12);
}
.toolbar .input { min-width: 150px; }
textarea.input { resize: vertical; line-height: 1.7; }

button.primary, button.ghost, button.link, button.close {
  font-family: inherit;
  cursor: pointer;
}
.primary {
  padding: 9px 18px;
  font-size: 13px;
  letter-spacing: 2px;
  color: #1b1206;
  background: linear-gradient(160deg, #e6c88a, var(--gold));
  border: 1px solid rgba(216, 176, 106, 0.6);
  border-radius: 5px;
  transition: filter 0.2s, box-shadow 0.2s;
}
.primary:hover { filter: brightness(1.08); box-shadow: 0 0 16px rgba(216, 176, 106, 0.3); }
.primary:disabled { opacity: 0.55; cursor: not-allowed; }

.ghost {
  padding: 9px 16px;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.75);
  background: transparent;
  border: 1px solid rgba(143, 179, 217, 0.28);
  border-radius: 5px;
  transition: color 0.2s, border-color 0.2s;
}
.ghost:hover { color: var(--paper); border-color: rgba(216, 176, 106, 0.5); }
.ghost:disabled { opacity: 0.4; cursor: not-allowed; }

.link {
  padding: 0;
  margin-right: 10px;
  font-size: 12.5px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.85);
  background: none;
  border: none;
  transition: color 0.2s;
}
.link:hover { color: var(--gold); }
.link.danger { color: rgba(232, 117, 109, 0.8); }
.link.danger:hover { color: #ff9a90; }

/* 表格 */
.table-wrap {
  border: 1px solid rgba(143, 179, 217, 0.16);
  border-radius: 8px;
  overflow: hidden;
  background: rgba(10, 15, 24, 0.6);
}
.table { width: 100%; border-collapse: collapse; font-size: 13px; }
.table th {
  padding: 12px 10px;
  text-align: left;
  font-weight: 400;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.75);
  background: rgba(20, 29, 45, 0.85);
  border-bottom: 1px solid rgba(216, 176, 106, 0.14);
  white-space: nowrap;
}
.table td {
  padding: 10px;
  color: rgba(232, 226, 212, 0.82);
  border-bottom: 1px solid rgba(143, 179, 217, 0.08);
  vertical-align: middle;
}
.table tbody tr:hover { background: rgba(143, 179, 217, 0.05); }
.table tbody tr:last-child td { border-bottom: none; }
.cell-title { color: var(--paper); letter-spacing: 1px; }
.dim { color: rgba(232, 226, 212, 0.46); }
.ops { white-space: nowrap; }
.empty {
  padding: 22px 12px;
  text-align: center;
  font-size: 12.5px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.38);
}

.tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 3px;
  font-size: 11.5px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.8);
  background: rgba(143, 179, 217, 0.1);
  border: 1px solid rgba(143, 179, 217, 0.2);
}
.tag.on {
  color: #8fe0b4;
  background: rgba(64, 150, 105, 0.14);
  border-color: rgba(64, 150, 105, 0.3);
}
.tag.off {
  color: rgba(232, 226, 212, 0.5);
  background: rgba(255, 255, 255, 0.03);
  border-color: rgba(255, 255, 255, 0.08);
}

.pager {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-top: 14px;
  font-size: 12.5px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.5);
}

/* 设置表单 */
.settings { display: flex; flex-direction: column; gap: 14px; }
.setting-row {
  display: flex;
  align-items: center;
  gap: 16px;
}
.setting-label {
  width: 190px;
  flex-shrink: 0;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.8);
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.setting-label em {
  font-style: normal;
  font-size: 11px;
  color: rgba(232, 226, 212, 0.35);
}
.setting-row .input { flex: 1; min-width: 0; }
.setting-actions { padding-left: 206px; }

/* 弹窗 */
.mask {
  position: fixed;
  inset: 0;
  z-index: 60;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background: rgba(4, 6, 11, 0.72);
  backdrop-filter: blur(3px);
}
.modal {
  width: min(760px, 100%);
  max-height: 88vh;
  overflow-y: auto;
  border-radius: 8px;
  border: 1px solid rgba(216, 176, 106, 0.28);
  background: linear-gradient(165deg, rgba(18, 26, 42, 0.98), rgba(9, 13, 21, 0.99));
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.55);
}
.modal-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 22px;
  border-bottom: 1px solid rgba(216, 176, 106, 0.16);
}
.modal-head h3 {
  font-size: 16px;
  font-weight: 400;
  letter-spacing: 3px;
  color: var(--gold);
}
.close {
  font-size: 15px;
  color: rgba(232, 226, 212, 0.5);
  background: none;
  border: none;
}
.close:hover { color: #f0a49c; }

.form-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  padding: 20px 22px;
}
.field { display: flex; flex-direction: column; gap: 6px; }
.field.full { grid-column: 1 / -1; }
.field > span {
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.8);
}
.field span em {
  font-style: normal;
  margin-left: 6px;
  font-size: 10.5px;
  color: rgba(232, 226, 212, 0.3);
}
.field.check {
  flex-direction: row;
  align-items: center;
  gap: 8px;
  padding-top: 18px;
}
.field.check span { color: rgba(232, 226, 212, 0.75); }

.modal-foot {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding: 16px 22px 20px;
  border-top: 1px solid rgba(216, 176, 106, 0.12);
}

@media (max-width: 900px) {
  .form-grid { grid-template-columns: 1fr; }
}
@media (max-width: 760px) {
  .aside { width: 62px; }
  .brand { justify-content: center; padding: 0; }
  .brand-text, .menu-item > span, .count, .aside-foot a { display: none; }
  .menu-item { justify-content: center; padding: 12px 0; }
  .content { padding: 22px 16px 32px; }
  .topbar { padding: 0 16px; }
  .who { display: none; }
  .setting-row { flex-direction: column; align-items: stretch; gap: 8px; }
  .setting-label { width: auto; }
  .setting-actions { padding-left: 0; }
}
</style>
