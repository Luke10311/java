<template>
  <PageShell
    title="卷宗"
    :crumb="detail ? detail.title : '未寻得此卷'"
    back
  >
    <template #head-extra>
      <p v-if="detail" class="crumb-extra">
        <span class="score">★ {{ detail.score.toFixed(1) }}</span>
        <span v-if="detail.badge" class="badge">{{ detail.badge }}</span>
        <span class="heat">热度 {{ (detail.views / 10000).toFixed(1) }} 万</span>
      </p>
    </template>

    <!-- 找不到这部剧 -->
    <div v-if="!detail" class="empty">
      <p class="empty-glyph">佚</p>
      <p class="empty-text">{{ errMsg || '这一卷不在架上，许是被谁抽走了。' }}</p>
      <button class="btn-ghost" type="button" @click="router.push('/series')">去剧集页翻翻</button>
    </div>

    <template v-else>
      <!-- ── 卷首：海报 + 提要 ───────────────────-->
      <section class="hero">
        <div class="poster" :style="posterFallback">
          <span class="glyph">{{ detail.title.slice(0, 1) }}</span>
          <img
            v-if="detail.poster"
            class="pic"
            :class="{ on: picOk && !picFailed, broken: picFailed }"
            :src="detail.poster"
            :alt="detail.title + ' 海报'"
            :style="detail.hueShift ? { filter: `hue-rotate(${detail.hueShift}deg) saturate(0.92)` } : null"
            @load="picOk = true"
            @error="picFailed = true"
          >
        </div>

        <div class="info">
          <h2 class="d-title">{{ detail.title }}</h2>
          <p class="d-sub">{{ detail.year }} · {{ detail.genres.join(' / ') }} · 共 {{ detail.episodes }} 集</p>

          <div class="tags">
            <span v-for="t in detail.genres" :key="t">{{ t }}</span>
          </div>

          <p class="synopsis">{{ detail.synopsis }}</p>

          <div class="actions">
            <button class="btn-main" type="button" @click="startWatch">
              ▶ {{ watched ? '继续追案' : '开始追案' }}
            </button>
            <button
              class="btn-ghost"
              type="button"
              :class="{ added: inCases }"
              @click="toggle"
            >
              {{ inCases ? '✓ 已在案卷' : '＋ 加入案卷' }}
            </button>
          </div>
        </div>
      </section>

      <!-- ── 演职人员 ───────────────────────────-->
      <section class="block">
        <h3 class="sec-title">演职人员</h3>
        <ul class="cast">
          <li v-for="c in detail.cast" :key="c.role + c.name">
            <span class="c-role">{{ c.role }}</span>
            <span class="c-name">{{ c.name }}</span>
          </li>
        </ul>
      </section>

      <!-- ── 分集 ───────────────────────────────-->
      <section ref="epRef" class="block">
        <div class="sec-head">
          <h3 class="sec-title">分集</h3>
          <span class="sec-line"></span>
          <span class="sec-note">共 {{ detail.episodeList.length }} 集</span>
        </div>

        <div class="eps">
          <button
            v-for="(ep, i) in visibleEps"
            :key="ep.no"
            class="ep"
            :class="{ on: ep.no === activeEp }"
            type="button"
            @click="playEpisode(ep)"
          >
            <span class="ep-no">{{ ep.no }}</span>
            <span class="ep-body">
              <span class="ep-title">{{ ep.title }}</span>
              <span class="ep-dur">{{ ep.duration }}</span>
            </span>
          </button>
        </div>

        <button
          v-if="detail.episodeList.length > EP_PREVIEW"
          class="more-eps"
          type="button"
          @click="showAllEps = !showAllEps"
        >
          {{ showAllEps ? '收起初见的分集' : `展开全部 ${detail.episodeList.length} 集` }}
        </button>
      </section>

      <!-- ── 相关推荐 ───────────────────────────-->
      <section class="block">
        <div class="sec-head">
          <h3 class="sec-title">同案相关</h3>
          <span class="sec-line"></span>
          <a class="sec-more" href="javascript:;" @click="router.push('/series')">全部剧集 ›</a>
        </div>

        <div class="grid">
          <DramaCard
            v-for="d in detail.related"
            :key="d.id"
            :drama="d"
            @open="goDrama"
          />
        </div>
      </section>
    </template>
  </PageShell>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import DramaCard from '../components/drama/DramaCard.vue'
import { fetchDramaDetail } from '../api/home'
import { isInCases, toggleCase } from '../store/cases'
import { showToast } from '../store/shell'

const props = defineProps({
  /** 路由参数 /drama/:id */
  id: { type: [String, Number], required: true }
})

const router = useRouter()

const detail = ref(null)
const errMsg = ref('')
const picOk = ref(false)
const picFailed = ref(false)

const EP_PREVIEW = 12
const showAllEps = ref(false)
const activeEp = ref(0)
const watched = ref(false)
const epRef = ref(null)

/** 收藏状态直接读 store，toggle 后自动重算 */
const inCases = computed(() => (detail.value ? isInCases(detail.value.id) : false))

watch(
  () => props.id,
  async (id) => {
    const res = await fetchDramaDetail(id)
    detail.value = res.data
    errMsg.value = res.ok ? '' : res.msg
    // 换剧要重置所有局部状态，否则会串到上一部
    picOk.value = false
    picFailed.value = false
    showAllEps.value = false
    activeEp.value = 0
    watched.value = false
    if (res.data) document.title = `魅影神捕 · ${res.data.title}`
  },
  { immediate: true }
)

const visibleEps = computed(() => {
  if (!detail.value) return []
  const all = detail.value.episodeList
  return showAllEps.value ? all : all.slice(0, EP_PREVIEW)
})

/** 海报兜底：图挂了就用题材色相画个写意封面 */
const posterFallback = computed(() => {
  if (picOk.value && !picFailed.value) return null
  const h = detail.value?.hue ?? 212
  return {
    background: `radial-gradient(120% 90% at 26% 14%, hsl(${h} 46% 30% / 0.95) 0%, hsl(${h} 44% 16% / 0.92) 46%, #080b13 100%)`
  }
})

function toggle() {
  if (!detail.value) return
  const added = toggleCase(detail.value.id)
  showToast(added ? `《${detail.value.title}》已收入案卷。` : `已从案卷中取出《${detail.value.title}》。`)
}

/** 开始追案：把视线带到分集并点亮第一集（播放器还没有，先做真交互） */
function startWatch() {
  if (!detail.value) return
  watched.value = true
  activeEp.value = activeEp.value || 1
  epRef.value?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  showToast(`《${detail.value.title}》第 ${activeEp.value} 集已备好，放映厅尚在修建。`)
}

function playEpisode(ep) {
  activeEp.value = ep.no
  showToast(`第 ${ep.no} 集「${ep.title}」已挑出，放映厅尚在修建。`)
}

function goDrama(d) {
  router.push(`/drama/${d.id}`)
}
</script>

<style scoped>
/* ── 页头附加信息 ───────────────────────────── */
.crumb-extra {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 10px;
  font-size: 13px;
  letter-spacing: 2px;
}
.score { color: var(--gold); }
.badge {
  padding: 2px 9px;
  font-size: 11px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.85);
  border-radius: 3px;
}
.heat { color: rgba(232, 226, 212, 0.5); }

/* ── 卷首 ───────────────────────────────────── */
.hero {
  display: grid;
  grid-template-columns: 260px 1fr;
  gap: 34px;
  padding: 26px;
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 10px;
  background: linear-gradient(150deg, rgba(18, 26, 43, 0.72), rgba(9, 12, 20, 0.86));
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45);
}

.poster {
  position: relative;
  aspect-ratio: 3 / 4;
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.glyph { font-size: 76px; color: rgba(232, 226, 212, 0.14); user-select: none; }
.pic {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  transition: opacity 0.6s ease;
}
.pic.on { opacity: 1; }
.pic.broken { display: none; }

.info { display: flex; flex-direction: column; justify-content: center; }
.d-title {
  font-size: 32px;
  font-weight: 400;
  letter-spacing: 7px;
  color: var(--paper);
}
.d-sub {
  margin-top: 10px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.75);
}

.tags { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 14px; }
.tags span {
  padding: 3px 10px;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.85);
  border: 1px solid rgba(143, 179, 217, 0.25);
  border-radius: 3px;
}

.synopsis {
  margin-top: 18px;
  font-size: 14px;
  line-height: 2.1;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.68);
  max-width: 720px;
}

.actions { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 24px; }
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
.btn-ghost:hover { border-color: var(--gold); color: var(--gold); box-shadow: 0 0 18px rgba(216, 176, 106, 0.22); }
.btn-ghost.added { color: var(--gold); border-color: rgba(216, 176, 106, 0.55); }

/* ── 区块 ───────────────────────────────────── */
.block { margin-top: 44px; }
.sec-head { display: flex; align-items: center; gap: 16px; margin-bottom: 20px; }
.sec-title {
  font-size: 19px;
  font-weight: 400;
  letter-spacing: 5px;
  color: var(--paper);
  white-space: nowrap;
}
.sec-title::before {
  content: "";
  display: inline-block;
  width: 3px;
  height: 16px;
  margin-right: 12px;
  vertical-align: -2px;
  background: linear-gradient(180deg, var(--gold), var(--cinnabar));
  border-radius: 2px;
}
.block > .sec-title { margin-bottom: 20px; }
.sec-line { flex: 1; height: 1px; background: linear-gradient(90deg, rgba(216, 176, 106, 0.35), transparent); }
.sec-note { font-size: 12px; letter-spacing: 2px; color: rgba(143, 179, 217, 0.55); }
.sec-more {
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
  text-decoration: none;
  transition: color 0.25s;
}
.sec-more:hover { color: var(--gold); }

/* 演职人员 */
.cast {
  list-style: none;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(190px, 1fr));
  gap: 12px;
}
.cast li {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  border: 1px solid rgba(216, 176, 106, 0.14);
  border-radius: 7px;
  background: rgba(9, 12, 20, 0.5);
}
.c-role { font-size: 12px; letter-spacing: 1px; color: rgba(143, 179, 217, 0.6); }
.c-name { font-size: 15px; letter-spacing: 2px; color: var(--paper); }

/* 分集 */
.eps {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
  gap: 10px;
}
.ep {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 10px 14px;
  text-align: left;
  font-family: inherit;
  border: 1px solid rgba(143, 179, 217, 0.16);
  border-radius: 7px;
  background: rgba(9, 12, 20, 0.5);
  cursor: pointer;
  transition: all 0.22s;
}
.ep:hover { border-color: rgba(216, 176, 106, 0.55); background: rgba(216, 176, 106, 0.06); }
.ep.on {
  border-color: rgba(194, 58, 58, 0.65);
  background: rgba(194, 58, 58, 0.14);
  box-shadow: 0 0 16px rgba(194, 58, 58, 0.2);
}
.ep-no {
  width: 24px;
  flex-shrink: 0;
  text-align: center;
  font-size: 15px;
  color: rgba(143, 179, 217, 0.7);
}
.ep.on .ep-no { color: var(--cinnabar); }
.ep-body { display: flex; flex-direction: column; gap: 3px; min-width: 0; }
.ep-title {
  font-size: 14px;
  letter-spacing: 2px;
  color: var(--paper);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.ep-dur { font-size: 11px; letter-spacing: 1px; color: rgba(143, 179, 217, 0.5); }

.more-eps {
  margin-top: 16px;
  width: 100%;
  padding: 11px;
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.75);
  border: 1px dashed rgba(143, 179, 217, 0.25);
  border-radius: 7px;
  background: transparent;
  cursor: pointer;
  transition: all 0.25s;
}
.more-eps:hover { color: var(--gold); border-color: rgba(216, 176, 106, 0.5); }

/* 相关推荐 */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 26px 20px;
}

/* 空态 */
.empty { padding: 70px 20px; text-align: center; }
.empty-glyph { font-size: 52px; color: rgba(216, 176, 106, 0.24); margin-bottom: 16px; }
.empty-text {
  font-size: 14px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.7);
  margin-bottom: 22px;
}

@media (max-width: 820px) {
  .hero { grid-template-columns: 1fr; gap: 22px; padding: 20px; }
  .poster { max-width: 210px; margin: 0 auto; }
  .info { text-align: center; align-items: center; }
  .synopsis { text-align: left; }
  .d-title { font-size: 25px; letter-spacing: 5px; }
  .grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 20px 14px; }
}
</style>
