<template>
  <PageShell
    title="剧集"
    desc="十八卷案宗按题材、年份归档。挑一卷翻开，看捕快如何循着灯火把碎片拼回原处。"
    crumb="剧集"
  >
    <template #head-extra>
      <!-- 筛选条 -->
      <div class="filters">
        <div class="chips">
          <a
            v-for="c in CATEGORIES"
            :key="c"
            href="javascript:;"
            class="chip"
            :class="{ on: c === filters.genre }"
            @click="setQuery({ genre: c })"
          >{{ c }}</a>
        </div>

        <div class="tools">
          <label class="tool">
            <span class="tool-label">年份</span>
            <select :value="filters.year" @change="setQuery({ year: $event.target.value })">
              <option v-for="y in YEARS" :key="y.value" :value="y.value">{{ y.label }}</option>
            </select>
          </label>

          <label class="tool">
            <span class="tool-label">次序</span>
            <select :value="filters.sort" @change="setQuery({ sort: $event.target.value })">
              <option v-for="s in SORTS" :key="s.value" :value="s.value">{{ s.label }}</option>
            </select>
          </label>

          <form class="tool search" @submit.prevent="applyKeyword">
            <input
              v-model.trim="keywordInput"
              type="search"
              placeholder="搜剧名 / 题材 / 年份"
              autocomplete="off"
            >
            <button type="submit" title="缉查">🔍</button>
          </form>
        </div>
      </div>

      <!-- 当前条件回显 -->
      <div v-if="hasQuery" class="active-line">
        <span>当前条件：</span>
        <button
          v-for="t in activeTags"
          :key="t.key"
          class="tag"
          type="button"
          :title="`去掉「${t.label}」`"
          @click="setQuery({ [t.key]: null })"
        >{{ t.label }} ✕</button>
        <button class="reset" type="button" @click="router.replace('/series')">全部清空</button>
      </div>
    </template>

    <!-- 列表 -->
    <p class="count">共 <b>{{ data.total }}</b> 卷 · 第 {{ data.page }} / {{ data.totalPages }} 页</p>

    <div v-if="data.items.length" class="grid">
      <DramaCard v-for="d in data.items" :key="d.id" :drama="d" @open="openDrama" />
    </div>

    <div v-else class="empty">
      <p class="empty-glyph">卷</p>
      <p class="empty-text">这一格档案架是空的，换个条件再翻。</p>
      <button class="btn-ghost" type="button" @click="router.replace('/series')">清空条件</button>
    </div>

    <!-- 分页 -->
    <nav v-if="data.totalPages > 1" class="pager">
      <button
        class="pg"
        type="button"
        :disabled="data.page <= 1"
        @click="gotoPage(data.page - 1)"
      >‹ 上一页</button>

      <button
        v-for="p in pageNumbers"
        :key="p"
        class="pg num"
        :class="{ on: p === data.page }"
        type="button"
        @click="gotoPage(p)"
      >{{ p }}</button>

      <button
        class="pg"
        type="button"
        :disabled="data.page >= data.totalPages"
        @click="gotoPage(data.page + 1)"
      >下一页 ›</button>
    </nav>
  </PageShell>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import DramaCard from '../components/drama/DramaCard.vue'
import { CATEGORIES, SORTS, YEARS, fetchSeriesList } from '../api/home'

const route = useRoute()
const router = useRouter()

/** 筛选条件全部以 URL query 为准：刷新 / 分享 / 后退都能还原 */
const filters = computed(() => ({
  genre: route.query.genre || '全部',
  year: route.query.year || 'all',
  sort: route.query.sort || 'default',
  keyword: route.query.keyword || '',
  page: Number(route.query.page) || 1
}))

const data = ref({ items: [], total: 0, page: 1, totalPages: 1 })
const keywordInput = ref(filters.value.keyword)

watch(
  () => route.query,
  async () => {
    keywordInput.value = filters.value.keyword
    const res = await fetchSeriesList(filters.value)
    data.value = res.data
  },
  { immediate: true }
)

/** 改条件：默认回到第 1 页；传 null / 空值表示删掉这个条件 */
function setQuery(patch, resetPage = true) {
  const q = { ...route.query, ...patch }
  if (resetPage) delete q.page
  Object.keys(q).forEach((k) => {
    const v = q[k]
    if (v === null || v === undefined || v === '' || v === 'all' || v === '全部' || v === 'default') {
      delete q[k]
    }
  })
  router.replace({ path: '/series', query: q })
}

function applyKeyword() {
  setQuery({ keyword: keywordInput.value })
}

function gotoPage(p) {
  if (p < 1 || p > data.value.totalPages || p === data.value.page) return
  const q = { ...route.query }
  if (p === 1) delete q.page
  else q.page = String(p)
  router.replace({ path: '/series', query: q })
}

/** 条件回显标签 */
const activeTags = computed(() => {
  const f = filters.value
  const out = []
  if (f.genre !== '全部') out.push({ key: 'genre', label: f.genre })
  if (f.year !== 'all') out.push({ key: 'year', label: `${f.year} 年` })
  if (f.sort !== 'default') {
    const s = SORTS.find((x) => x.value === f.sort)
    out.push({ key: 'sort', label: `按${s?.label || f.sort}` })
  }
  if (f.keyword) out.push({ key: 'keyword', label: `「${f.keyword}」` })
  return out
})

const hasQuery = computed(() => activeTags.value.length > 0)

/** 页码按钮：最多 7 个，当前页居中 */
const pageNumbers = computed(() => {
  const { page, totalPages } = data.value
  const span = 7
  if (totalPages <= span) return Array.from({ length: totalPages }, (_, i) => i + 1)
  let start = Math.max(1, page - 3)
  const end = Math.min(totalPages, start + span - 1)
  start = Math.max(1, end - span + 1)
  return Array.from({ length: end - start + 1 }, (_, i) => start + i)
})

function openDrama(drama) {
  router.push(`/drama/${drama.id}`)
}
</script>

<style scoped>
/* ── 筛选条 ─────────────────────────────────── */
.filters {
  margin-top: 22px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
  gap: 14px;
}

.chips { display: flex; flex-wrap: wrap; gap: 9px; }
.chip {
  padding: 5px 17px;
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

.tools { display: flex; flex-wrap: wrap; align-items: center; gap: 10px; }
.tool {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 4px 10px;
  border: 1px solid rgba(143, 179, 217, 0.22);
  border-radius: 6px;
  background: rgba(7, 9, 15, 0.4);
}
.tool-label {
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(216, 176, 106, 0.75);
}
.tool select {
  appearance: none;
  -webkit-appearance: none;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--paper);
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 1px;
  cursor: pointer;
}
.tool select option { background: #0c111c; color: var(--paper); }

.tool.search { padding: 0 4px 0 10px; }
.tool.search input {
  width: 168px;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--paper);
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 1px;
  padding: 7px 0;
  caret-color: var(--gold);
}
.tool.search input::placeholder { color: rgba(232, 226, 212, 0.3); }
.tool.search input::-webkit-search-cancel-button { display: none; }
.tool.search button {
  border: 0;
  background: transparent;
  font-size: 13px;
  cursor: pointer;
  opacity: 0.65;
  padding: 4px 6px;
  transition: opacity 0.2s;
}
.tool.search button:hover { opacity: 1; }

/* 条件回显 */
.active-line {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  margin-top: 14px;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.55);
}
.tag {
  padding: 3px 10px;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 1px;
  color: var(--gold);
  border: 1px solid rgba(216, 176, 106, 0.35);
  border-radius: 20px;
  background: rgba(216, 176, 106, 0.07);
  cursor: pointer;
  transition: all 0.22s;
}
.tag:hover { border-color: var(--cinnabar); color: #f0a49c; }
.reset {
  border: 0;
  background: transparent;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.6);
  cursor: pointer;
  text-decoration: underline;
  text-underline-offset: 3px;
}
.reset:hover { color: var(--gold); }

/* ── 列表 ───────────────────────────────────── */
.count {
  margin-bottom: 18px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.6);
}
.count b { color: var(--gold); font-weight: 400; }

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 26px 20px;
}

.empty {
  padding: 60px 20px;
  text-align: center;
  border: 1px dashed rgba(143, 179, 217, 0.22);
  border-radius: 10px;
}
.empty-glyph { font-size: 44px; color: rgba(216, 176, 106, 0.22); margin-bottom: 14px; }
.empty-text {
  font-size: 14px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.7);
  margin-bottom: 20px;
}

.btn-ghost {
  padding: 9px 22px;
  font-family: inherit;
  font-size: 14px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.8);
  border: 1px solid rgba(143, 179, 217, 0.3);
  border-radius: 6px;
  background: transparent;
  cursor: pointer;
  transition: all 0.25s;
}
.btn-ghost:hover { border-color: var(--gold); color: var(--gold); }

/* ── 分页 ───────────────────────────────────── */
.pager {
  margin-top: 38px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.pg {
  min-width: 38px;
  padding: 8px 14px;
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.7);
  border: 1px solid rgba(143, 179, 217, 0.22);
  border-radius: 5px;
  background: rgba(7, 9, 15, 0.4);
  cursor: pointer;
  transition: all 0.22s;
}
.pg:hover:not(:disabled) { border-color: var(--gold); color: var(--gold); }
.pg:disabled { opacity: 0.35; cursor: not-allowed; }
.pg.num { padding: 8px 0; }
.pg.on {
  color: #ffe9cf;
  border-color: rgba(194, 58, 58, 0.7);
  background: rgba(194, 58, 58, 0.22);
  box-shadow: 0 0 14px rgba(194, 58, 58, 0.25);
}

@media (max-width: 640px) {
  .filters { flex-direction: column; align-items: stretch; }
  .tools { justify-content: space-between; }
  .tool.search input { width: 100%; }
  .tool.search { flex: 1; }
  .grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 20px 14px; }
}
</style>
