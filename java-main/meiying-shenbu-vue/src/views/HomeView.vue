<template>
  <BackgroundScene :show-lantern="false" />

  <!-- 首页滚动容器：背景层是 fixed，内容在这一层里滚 -->
  <div class="home" @scroll.passive="onScroll">
    <SiteHeader :solid="scrolled" active="home" @focus-search="focusSearch" />

    <!-- ── 主视觉：长安夜巡大图 + 搜索栏 ───────────────-->
    <section class="hero">
      <div class="hero-bg" aria-hidden="true"></div>
      <div class="hero-veil" aria-hidden="true"></div>

      <div class="hero-inner">
        <p class="kicker">魅影神捕 · 探案录</p>
        <h2 class="hero-title">今夜，何处有魅影</h2>
        <p class="hero-sub">三山五岳的奇案秘录，只待你一句线索</p>

        <SearchBar ref="searchRef" @search="onSearch" />

        <div class="hots">
          <span class="hots-label">热缉</span>
          <a
            v-for="w in HOT_WORDS"
            :key="w"
            href="javascript:;"
            class="hot-word"
            @click="quickSearch(w)"
          >{{ w }}</a>
        </div>
      </div>
    </section>

    <main class="main">
      <!-- ── 精选一案 ───────────────────────────────-->
      <section class="block">
        <div class="sec-head">
          <h3 class="sec-title">精选一案</h3>
          <span class="sec-line"></span>
          <a class="sec-more" href="javascript:;" @click="soon">更多案卷 ›</a>
        </div>

        <div v-if="featured" class="featured" @click="openDrama(featured)">
          <div class="f-poster">
            <img
              class="f-pic"
              :src="featured.poster"
              :alt="featured.title + ' 海报'"
              loading="eager"
              decoding="async"
              @error="featuredPicFailed = true"
            >
            <span v-if="featuredPicFailed" class="f-glyph">{{ featured.title.slice(0, 1) }}</span>
            <span class="f-veil"></span>
          </div>
          <div class="f-body">
            <span class="f-badge">{{ featured.badge }}</span>
            <h4 class="f-title">{{ featured.title }}</h4>
            <p class="f-sub">{{ featured.sub }}</p>
            <p class="f-desc">{{ featured.desc }}</p>
            <div class="f-tags">
              <span v-for="t in featured.tags" :key="t">{{ t }}</span>
              <span class="f-score">★ {{ featured.score.toFixed(1) }}</span>
            </div>
            <div class="f-actions">
              <button class="btn-main" type="button" @click.stop="soon">▶ 开始追案</button>
              <button class="btn-ghost" type="button" @click.stop="soon">＋ 加入案卷</button>
            </div>
          </div>
        </div>
      </section>

      <!-- ── 热播 / 缉查结果 ────────────────────────-->
      <section ref="listRef" class="block">
        <div class="sec-head">
          <h3 class="sec-title">{{ listTitle }}</h3>
          <span class="sec-line"></span>
          <template v-if="results">
            <a class="sec-more" href="javascript:;" @click="clearQuery">✕ 收起结果</a>
          </template>
          <template v-else>
            <a class="sec-more" href="javascript:;" @click="soon">全部剧集 ›</a>
          </template>
        </div>

        <!-- 分类筛选（搜索时收起，避免和关键词打架） -->
        <div v-if="!results" class="chips">
          <a
            v-for="c in CATEGORIES"
            :key="c"
            href="javascript:;"
            class="chip"
            :class="{ on: c === activeCategory }"
            @click="pickCategory(c)"
          >{{ c }}</a>
        </div>

        <div v-if="list.length" class="grid">
          <DramaCard
            v-for="d in list"
            :key="d.id"
            :drama="d"
            @open="openDrama"
          />
        </div>

        <!-- 空态 -->
        <div v-else class="empty">
          <p class="empty-glyph">卷</p>
          <p class="empty-text">未寻得相关案卷，换个线索再试。</p>
          <button class="btn-ghost" type="button" @click="clearQuery">清空缉查</button>
        </div>
      </section>

      <!-- ── 悬案榜 ────────────────────────────────-->
      <section class="block">
        <div class="sec-head">
          <h3 class="sec-title">悬案榜</h3>
          <span class="sec-line"></span>
          <a class="sec-more" href="javascript:;" @click="soon">完整榜单 ›</a>
        </div>

        <ol class="rank">
          <li
            v-for="(r, i) in rankList"
            :key="r.id"
            class="rank-item"
            @click="openDrama(r)"
          >
            <span class="rank-no" :class="'no-' + (i + 1)">{{ i + 1 }}</span>
            <span class="rank-thumb" :style="rankThumbStyle(r)">
              <img v-if="r.poster" :src="r.poster" :alt="r.title + ' 缩略图'" loading="lazy">
            </span>
            <span class="rank-title">{{ r.title }}</span>
            <span class="rank-heat">{{ r.heat }}</span>
            <span class="rank-trend" :class="r.trend">
              {{ r.trend === 'up' ? '▲' : r.trend === 'down' ? '▼' : '—' }}
            </span>
          </li>
        </ol>
      </section>
    </main>

    <SiteFooter @nav="onFootNav" />
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import BackgroundScene from '../components/BackgroundScene.vue'
import SiteHeader from '../components/layout/SiteHeader.vue'
import SiteFooter from '../components/layout/SiteFooter.vue'
import SearchBar from '../components/home/SearchBar.vue'
import DramaCard from '../components/drama/DramaCard.vue'
import { HERO_IMAGE, HOT_WORDS } from '../data/dramas'
import {
  CATEGORIES,
  fetchFeatured,
  fetchHot,
  fetchRank,
  searchDramas
} from '../api/home'
import { showToast } from '../store/shell'

const scrolled = ref(false)
const searchRef = ref(null)
const listRef = ref(null)

const activeCategory = ref('全部')
/** 当前缉查条件，null 表示没在搜索 */
const query = ref(null)

/* ── 数据（走 api/home.js 预留层，后端就绪只改那一层） ── */

const featured = ref(null)
const featuredPicFailed = ref(false)
const baseList = ref([])
const rankList = ref([])
const listLoading = ref(false)

onMounted(async () => {
  // 精选 / 榜单不阻塞列表，先到先渲染
  fetchFeatured().then((r) => { featured.value = r.data })
  fetchRank(5).then((r) => { rankList.value = r.data })
  await loadHot(activeCategory.value)
})

async function loadHot(category) {
  listLoading.value = true
  const res = await fetchHot(category)
  baseList.value = res.data || []
  listLoading.value = false
}

/* ── 列表计算 ───────────────────────────────── */

// 关键词搜索结果；null 表示未搜索
const results = computed(() => (query.value ? query.value.results : null))

const list = computed(() => results.value ?? baseList.value)

const listTitle = computed(() => {
  if (results.value) {
    const q = query.value
    return `缉查结果 · ${q.scopeLabel}「${q.keyword}」（${q.results.length} 卷）`
  }
  return activeCategory.value === '全部' ? '热播探案' : `${activeCategory.value} · 热播`
})

/** 榜单缩略图：没图的用色相渐变兜底 */
function rankThumbStyle(r) {
  if (r.poster) return null
  return {
    background: `radial-gradient(120% 120% at 30% 20%, hsl(${r.hue} 46% 32% / 0.95), #0a0e18 100%)`
  }
}

/* ── 交互 ───────────────────────────────────── */

function onScroll(e) {
  scrolled.value = e.target.scrollTop > 12
}

function focusSearch() {
  searchRef.value?.focus()
}

/**
 * 缉查搜索
 *
 * 搜索逻辑已抽到 api/home.js 的 searchDramas()。
 * 后端就绪后它会变成：
 *   GET /api/drama/search?keyword=<词>&scope=<域>
 * 视图层这里不用动。
 */
function onSearch({ keyword, scope }) {
  if (!keyword) {
    showToast('先写下一条线索，捕头。')
    searchRef.value?.focus()
    return
  }
  const scopeLabel = { all: '全卷', series: '剧集', movie: '影录', role: '人物', case: '案卷' }[scope] || '全卷'
  searchDramas(keyword, scope).then((res) => {
    query.value = { keyword, scope, scopeLabel, results: res.data || [] }
    setTimeout(() => {
      listRef.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }, 60)
  })
}

function quickSearch(word) {
  onSearch({ keyword: word, scope: 'all' })
}

function pickCategory(c) {
  activeCategory.value = c
  loadHot(c)
}

function clearQuery() {
  query.value = null
}

// 剧集详情页还没做，先给个反馈
function openDrama(drama) {
  showToast(`《${drama.title}》卷宗尚未展开，敬请候令。`)
}

function soon() {
  showToast('此卷正在缉捕中，敬请候令。')
}

// 页脚链接：只有首页是真实页面，其余先弹提示
function onFootNav(link) {
  if (link.path === '/') return
  showToast(`「${link.label}」这一卷尚未展开，敬请候令。`)
}
</script>

<style scoped>
.home {
  position: relative;
  z-index: 1;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  scroll-behavior: smooth;
}

.main {
  max-width: 1200px;
  margin: 0 auto;
  padding: 46px 24px 40px;
}

/* ── 主视觉 ─────────────────────────────────── */
.hero {
  position: relative;
  min-height: 560px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 120px 24px 88px;
  overflow: hidden;
}

/* 长安夜巡大图：缓慢推移的 kenburns，配合雾效背景层 */
.hero-bg {
  position: absolute;
  inset: -24px 0;
  background: url('/images/hero.jpg') center 32% / cover no-repeat;
  animation: heroDrift 30s ease-in-out infinite alternate;
  will-change: transform;
}
@keyframes heroDrift {
  from { transform: scale(1.02) translateX(-1.2%); }
  to   { transform: scale(1.08) translateX(1.2%); }
}

/* 压暗渐变：保证文字可读 + 底部融进夜色 */
.hero-veil {
  position: absolute;
  inset: 0;
  background:
    linear-gradient(180deg,
      rgba(7, 9, 15, 0.86) 0%,
      rgba(7, 9, 15, 0.30) 34%,
      rgba(7, 9, 15, 0.34) 62%,
      rgba(7, 9, 15, 0.96) 100%),
    radial-gradient(90% 70% at 50% 46%, transparent 40%, rgba(7, 9, 15, 0.42) 100%);
}

.hero-inner {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 760px;
  text-align: center;
}

.kicker {
  font-size: 12px;
  letter-spacing: 8px;
  text-indent: 8px;
  color: rgba(216, 176, 106, 0.85);
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.8);
  margin-bottom: 18px;
}
.hero-title {
  font-size: 46px;
  font-weight: 400;
  letter-spacing: 10px;
  text-indent: 10px;
  color: var(--paper);
  text-shadow: 0 2px 18px rgba(0, 0, 0, 0.85), 0 0 40px rgba(143, 179, 217, 0.4);
  animation: heroIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) both;
}
.hero-sub {
  margin: 14px 0 34px;
  font-size: 14px;
  letter-spacing: 5px;
  text-indent: 5px;
  color: rgba(232, 226, 212, 0.82);
  text-shadow: 0 2px 12px rgba(0, 0, 0, 0.85);
  animation: heroIn 0.9s 0.1s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes heroIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: none; }
}

/* 热搜词 */
.hots {
  margin-top: 20px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 10px;
  font-size: 13px;
}
.hots-label {
  letter-spacing: 3px;
  color: rgba(232, 116, 108, 0.95);
  text-shadow: 0 2px 8px rgba(0, 0, 0, 0.8);
}
.hot-word {
  padding: 3px 12px;
  border: 1px solid rgba(143, 179, 217, 0.28);
  border-radius: 20px;
  background: rgba(7, 9, 15, 0.42);
  color: rgba(232, 226, 212, 0.78);
  text-decoration: none;
  letter-spacing: 1px;
  transition: all 0.25s;
}
.hot-word:hover {
  border-color: var(--gold);
  color: var(--gold);
  box-shadow: 0 0 14px rgba(216, 176, 106, 0.3);
}

/* ── 区块通用 ───────────────────────────────── */
.block {
  margin-bottom: 54px;
  scroll-margin-top: 84px;
}
.sec-head {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 22px;
}
.sec-title {
  font-size: 21px;
  font-weight: 400;
  letter-spacing: 5px;
  color: var(--paper);
  white-space: nowrap;
}
.sec-title::before {
  content: "";
  display: inline-block;
  width: 3px;
  height: 17px;
  margin-right: 12px;
  vertical-align: -2px;
  background: linear-gradient(180deg, var(--gold), var(--cinnabar));
  border-radius: 2px;
}
.sec-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.35), transparent);
}
.sec-more {
  flex-shrink: 0;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
  text-decoration: none;
  transition: color 0.25s;
}
.sec-more:hover { color: var(--gold); }

/* ── 精选一案 ───────────────────────────────── */
.featured {
  display: grid;
  grid-template-columns: 250px 1fr;
  gap: 30px;
  padding: 24px;
  border: 1px solid rgba(216, 176, 106, 0.22);
  border-radius: 10px;
  background: linear-gradient(150deg, rgba(18, 26, 43, 0.72), rgba(9, 12, 20, 0.85));
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45);
  cursor: pointer;
  transition: border-color 0.3s, box-shadow 0.3s, transform 0.3s;
}
.featured:hover {
  border-color: rgba(216, 176, 106, 0.5);
  box-shadow: 0 24px 60px rgba(0, 0, 0, 0.55), 0 0 30px rgba(216, 176, 106, 0.14);
  transform: translateY(-3px);
}

.f-poster {
  position: relative;
  aspect-ratio: 3 / 4;
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  background: radial-gradient(130% 110% at 30% 20%, rgba(60, 84, 128, 0.5), rgba(7, 10, 18, 0.95));
}
.f-pic {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}
.featured:hover .f-pic { transform: scale(1.05); }
.f-glyph {
  font-size: 82px;
  color: rgba(232, 226, 212, 0.14);
  user-select: none;
}
.f-veil {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 60%, rgba(7, 9, 15, 0.45) 100%);
}

.f-body { display: flex; flex-direction: column; justify-content: center; }
.f-badge {
  align-self: flex-start;
  padding: 3px 10px;
  margin-bottom: 12px;
  font-size: 12px;
  letter-spacing: 2px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.85);
  border-radius: 3px;
}
.f-title {
  font-size: 30px;
  font-weight: 400;
  letter-spacing: 6px;
  color: var(--paper);
}
.f-sub {
  margin-top: 8px;
  font-size: 14px;
  letter-spacing: 3px;
  color: var(--gold);
  opacity: 0.9;
}
.f-desc {
  margin-top: 16px;
  font-size: 14px;
  line-height: 2;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.66);
  max-width: 620px;
}
.f-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 18px;
  font-size: 12px;
}
.f-tags span {
  padding: 3px 10px;
  border: 1px solid rgba(143, 179, 217, 0.25);
  border-radius: 3px;
  color: rgba(143, 179, 217, 0.85);
  letter-spacing: 1px;
}
.f-tags .f-score {
  color: var(--gold);
  border-color: rgba(216, 176, 106, 0.45);
}
.f-actions { display: flex; gap: 12px; margin-top: 24px; }

.btn-main {
  padding: 11px 28px;
  font-family: inherit;
  font-size: 15px;
  letter-spacing: 3px;
  color: #ffe9cf;
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 6px;
  background: linear-gradient(160deg, #b03535 0%, var(--cinnabar) 45%, #8e2424 100%);
  box-shadow: 0 8px 22px rgba(194, 58, 58, 0.35);
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.3s;
}
.btn-main:hover { transform: translateY(-2px); box-shadow: 0 12px 30px rgba(194, 58, 58, 0.5); }

.btn-ghost {
  padding: 11px 24px;
  font-family: inherit;
  font-size: 15px;
  letter-spacing: 3px;
  color: rgba(232, 226, 212, 0.8);
  border: 1px solid rgba(143, 179, 217, 0.3);
  border-radius: 6px;
  background: transparent;
  cursor: pointer;
  transition: all 0.25s;
}
.btn-ghost:hover {
  border-color: var(--gold);
  color: var(--gold);
  box-shadow: 0 0 18px rgba(216, 176, 106, 0.22);
}

/* ── 分类 chips ─────────────────────────────── */
.chips {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 22px;
}
.chip {
  padding: 5px 18px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.62);
  border: 1px solid rgba(143, 179, 217, 0.2);
  border-radius: 20px;
  text-decoration: none;
  transition: all 0.25s;
}
.chip:hover { color: var(--paper); border-color: rgba(216, 176, 106, 0.5); }
.chip.on {
  color: #ffe9cf;
  border-color: rgba(194, 58, 58, 0.7);
  background: rgba(194, 58, 58, 0.2);
  box-shadow: 0 0 16px rgba(194, 58, 58, 0.22);
}

/* ── 卡片网格 ───────────────────────────────── */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 24px 20px;
}

/* ── 空态 ───────────────────────────────────── */
.empty {
  padding: 54px 20px;
  text-align: center;
  border: 1px dashed rgba(143, 179, 217, 0.22);
  border-radius: 10px;
}
.empty-glyph {
  font-size: 44px;
  color: rgba(216, 176, 106, 0.22);
  margin-bottom: 14px;
}
.empty-text {
  font-size: 14px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.7);
  margin-bottom: 20px;
}

/* ── 悬案榜 ─────────────────────────────────── */
.rank {
  list-style: none;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 10px;
  overflow: hidden;
  background: rgba(9, 12, 20, 0.55);
}
.rank-item {
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 13px 22px;
  cursor: pointer;
  border-bottom: 1px solid rgba(143, 179, 217, 0.08);
  transition: background 0.25s, padding-left 0.25s;
}
.rank-item:last-child { border-bottom: 0; }
.rank-item:hover {
  background: rgba(216, 176, 106, 0.07);
  padding-left: 28px;
}

.rank-no {
  width: 26px;
  text-align: center;
  font-size: 17px;
  color: rgba(143, 179, 217, 0.6);
}
.rank-no.no-1 { color: var(--cinnabar); text-shadow: 0 0 10px rgba(194, 58, 58, 0.6); }
.rank-no.no-2 { color: var(--gold); }
.rank-no.no-3 { color: #c8a06a; }

/* 榜单缩略图 */
.rank-thumb {
  width: 34px;
  height: 46px;
  flex-shrink: 0;
  border: 1px solid rgba(216, 176, 106, 0.22);
  border-radius: 4px;
  overflow: hidden;
  background: #0a0e18;
}
.rank-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.rank-title {
  flex: 1;
  font-size: 16px;
  letter-spacing: 2px;
  color: var(--paper);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.rank-item:hover .rank-title { color: var(--gold); }
.rank-heat {
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.5);
}
.rank-trend { font-size: 12px; width: 18px; text-align: center; }
.rank-trend.up { color: var(--cinnabar); }
.rank-trend.down { color: #6fb98f; }
.rank-trend.flat { color: rgba(143, 179, 217, 0.5); }

/* ── 响应式 ─────────────────────────────────── */
@media (max-width: 820px) {
  .hero { min-height: 460px; padding: 96px 16px 64px; }
  .hero-title { font-size: 32px; letter-spacing: 7px; }
  .featured { grid-template-columns: 1fr; gap: 20px; }
  .f-poster { max-width: 200px; margin: 0 auto; aspect-ratio: 3 / 4; }
  .f-body { text-align: center; align-items: center; }
  .f-badge { align-self: center; }
  .f-desc { text-align: left; }
  .grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 18px 14px; }
}

@media (max-width: 560px) {
  .main { padding: 34px 14px 30px; }
  .hero-title { font-size: 26px; letter-spacing: 5px; }
  .hero-sub { letter-spacing: 3px; font-size: 13px; }
  .sec-title { font-size: 18px; letter-spacing: 3px; }
  .f-title { font-size: 24px; }
  .f-actions { flex-wrap: wrap; justify-content: center; }
}
</style>
