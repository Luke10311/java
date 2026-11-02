<template>
  <PageShell
    title="案卷"
    :crumb="detail ? detail.title : '未寻得此案'"
    back
  >
    <template #head-extra>
      <p v-if="detail" class="crumb-extra">
        <span class="no">{{ detail.no }}</span>
        <span class="badge">{{ detail.tag }}</span>
        <span class="status" :class="{ closed: detail.status === '已封卷' }">{{ detail.status }}</span>
      </p>
    </template>

    <!-- 找不到这起案件 -->
    <div v-if="!detail" class="empty">
      <p class="empty-glyph">佚</p>
      <p class="empty-text">这起案子不在卷架上，许是被谁抽走了。</p>
      <button class="btn-ghost" type="button" @click="router.push('/')">回首页翻翻</button>
    </div>

    <template v-else>
      <!-- ── 卷首：案发写影 + 案情提要 ─────────────-->
      <section class="hero">
        <div class="pic-wrap">
          <img
            class="pic"
            :src="detail.image"
            :alt="detail.title + ' 案发写影'"
            @error="picFailed = true"
          >
          <span v-if="picFailed" class="glyph">{{ detail.title.slice(0, 1) }}</span>
          <span class="veil" aria-hidden="true"></span>
        </div>

        <div class="info">
          <h2 class="c-title">{{ detail.title }}</h2>
          <p class="c-sub">{{ detail.date }} · 案发于 {{ detail.place }}</p>

          <div class="tags">
            <span class="t-status" :class="{ closed: detail.status === '已封卷' }">{{ detail.status }}</span>
            <span class="t-reward">{{ detail.reward }}</span>
          </div>

          <p class="summary">{{ detail.summary }}</p>

          <div class="actions">
            <button class="btn-main" type="button" @click="follow">▶ 认领此案</button>
            <button class="btn-ghost" type="button" @click="reportClue">✎ 提供线索</button>
          </div>
        </div>
      </section>

      <!-- ── 案发经过 ─────────────────────────────-->
      <section class="block">
        <h3 class="sec-title">案发经过</h3>
        <ol class="timeline">
          <li v-for="(n, i) in detail.timeline" :key="i">
            <span class="tl-dot" aria-hidden="true"></span>
            <span class="tl-time">{{ n.t }}</span>
            <span class="tl-event">{{ n.e }}</span>
          </li>
        </ol>
      </section>

      <!-- ── 在场人物 ─────────────────────────────-->
      <section class="block">
        <h3 class="sec-title">在场人物</h3>
        <ul class="cast">
          <li v-for="p in detail.persons" :key="p.role + p.name">
            <span class="p-role">{{ p.role }}</span>
            <span class="p-name">{{ p.name }}</span>
          </li>
        </ul>
      </section>

      <!-- ── 物证线索 ─────────────────────────────-->
      <section class="block">
        <h3 class="sec-title">物证线索</h3>
        <ul class="clues">
          <li v-for="(clue, i) in detail.clues" :key="i">
            <span class="clue-no">{{ ['壹', '贰', '叁'][i] || i + 1 }}</span>
            <span class="clue-text">{{ clue }}</span>
          </li>
        </ul>
      </section>

      <!-- ── 其它未结奇案 ─────────────────────────-->
      <section class="block">
        <div class="sec-head">
          <h3 class="sec-title">其它未结奇案</h3>
          <span class="sec-line"></span>
        </div>

        <div class="more-grid">
          <article
            v-for="c in others"
            :key="c.id"
            class="more-card"
            @click="router.push(`/case/${c.id}`)"
          >
            <div class="more-pic">
              <img :src="c.image" :alt="c.title + ' 案发写影'" loading="lazy">
            </div>
            <div class="more-body">
              <span class="more-tag">{{ c.tag }}</span>
              <h4 class="more-title">{{ c.title }}</h4>
              <p class="more-desc">{{ c.desc }}</p>
            </div>
          </article>
        </div>
      </section>
    </template>
  </PageShell>
</template>

<script setup>
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import { getCaseById, getOtherCases } from '../data/cases'
import { showToast } from '../store/shell'

const props = defineProps({
  /** 路由参数 /case/:id */
  id: { type: [String, Number], required: true }
})

const router = useRouter()

const picFailed = ref(false)

const detail = computed(() => getCaseById(props.id))

watch(
  () => props.id,
  () => {
    picFailed.value = false
    const c = getCaseById(props.id)
    if (c) document.title = `魅影神捕 · ${c.title}`
  },
  { immediate: true }
)

const others = computed(() => getOtherCases(props.id, 3))

/** 认领此案：办案系统还没接上，先应一声 */
function follow() {
  showToast(`已登记认领「${detail.value.title}」，缉查文书誊抄中。`)
}

/** 提供线索：线索通道待开 */
function reportClue() {
  showToast('线索通道尚在铺设，捕头可先去茶楼探探风声。')
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
.no { color: rgba(216, 176, 106, 0.75); }
.badge {
  padding: 2px 9px;
  font-size: 11px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.85);
  border-radius: 3px;
}
.status { color: rgba(232, 116, 108, 0.95); }
.status.closed { color: rgba(143, 179, 217, 0.7); }

/* ── 卷首 ───────────────────────────────────── */
.hero {
  display: grid;
  grid-template-columns: 1.35fr 1fr;
  gap: 34px;
  padding: 26px;
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 10px;
  background: linear-gradient(150deg, rgba(18, 26, 43, 0.72), rgba(9, 12, 20, 0.86));
  box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45);
}

.pic-wrap {
  position: relative;
  aspect-ratio: 16 / 10;
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background: radial-gradient(120% 100% at 30% 20%, rgba(60, 84, 128, 0.5), rgba(7, 10, 18, 0.95));
}
.pic {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.glyph {
  font-size: 82px;
  color: rgba(232, 226, 212, 0.14);
  user-select: none;
}
.veil {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 58%, rgba(9, 12, 20, 0.5) 100%);
}

.info { display: flex; flex-direction: column; justify-content: center; }
.c-title {
  font-size: 32px;
  font-weight: 400;
  letter-spacing: 6px;
  color: var(--paper);
}
.c-sub {
  margin-top: 10px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.55);
}
.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-top: 16px;
  font-size: 12px;
  letter-spacing: 1px;
}
.t-status {
  padding: 3px 10px;
  border: 1px solid rgba(232, 116, 108, 0.5);
  border-radius: 3px;
  color: rgba(232, 116, 108, 0.95);
}
.t-status.closed {
  border-color: rgba(143, 179, 217, 0.35);
  color: rgba(143, 179, 217, 0.7);
}
.t-reward {
  padding: 3px 10px;
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 3px;
  color: var(--gold);
}
.summary {
  margin-top: 18px;
  font-size: 14px;
  line-height: 2.1;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.68);
}
.actions { display: flex; gap: 12px; margin-top: 22px; }

.btn-main {
  padding: 10px 26px;
  font-family: inherit;
  font-size: 14px;
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
  padding: 10px 22px;
  font-family: inherit;
  font-size: 14px;
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

/* ── 区块通用标题（对齐首页 / 剧集详情页） ──── */
.block { margin-top: 46px; }
.sec-title {
  font-size: 19px;
  font-weight: 400;
  letter-spacing: 4px;
  color: var(--paper);
  margin-bottom: 18px;
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
.sec-head { display: flex; align-items: center; gap: 16px; margin-bottom: 18px; }
.sec-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.35), transparent);
}

/* ── 案发经过 ───────────────────────────────── */
.timeline {
  list-style: none;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 10px;
  background: rgba(9, 12, 20, 0.55);
  padding: 6px 0;
}
.timeline li {
  position: relative;
  display: flex;
  gap: 16px;
  padding: 14px 22px 14px 40px;
  border-bottom: 1px solid rgba(143, 179, 217, 0.08);
}
.timeline li:last-child { border-bottom: 0; }
.tl-dot {
  position: absolute;
  left: 22px;
  top: 21px;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: var(--cinnabar);
  box-shadow: 0 0 10px rgba(194, 58, 58, 0.6);
}
.tl-time {
  flex-shrink: 0;
  width: 150px;
  font-size: 13px;
  letter-spacing: 1px;
  color: var(--gold);
  opacity: 0.85;
}
.tl-event {
  font-size: 14px;
  line-height: 1.8;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.7);
}

/* ── 在场人物 ───────────────────────────────── */
.cast {
  list-style: none;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 12px;
}
.cast li {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 13px 18px;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 8px;
  background: rgba(9, 12, 20, 0.55);
}
.p-role {
  flex-shrink: 0;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
}
.p-name {
  font-size: 15px;
  letter-spacing: 2px;
  color: var(--paper);
}

/* ── 物证线索 ───────────────────────────────── */
.clues {
  list-style: none;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 12px;
}
.clues li {
  display: flex;
  gap: 14px;
  padding: 15px 18px;
  border: 1px dashed rgba(216, 176, 106, 0.28);
  border-radius: 8px;
  background: rgba(9, 12, 20, 0.45);
}
.clue-no {
  flex-shrink: 0;
  width: 26px;
  height: 26px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.7);
  border-radius: 50%;
}
.clue-text {
  font-size: 13px;
  line-height: 1.9;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.68);
}

/* ── 其它未结奇案 ───────────────────────────── */
.more-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px;
}
.more-card {
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 10px;
  overflow: hidden;
  background: rgba(9, 12, 20, 0.6);
  cursor: pointer;
  transition: border-color 0.3s, transform 0.3s, box-shadow 0.3s;
}
.more-card:hover {
  border-color: rgba(216, 176, 106, 0.5);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.45);
  transform: translateY(-3px);
}
.more-pic {
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: #0a0e18;
}
.more-pic img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}
.more-card:hover .more-pic img { transform: scale(1.06); }
.more-body { padding: 14px 16px 16px; }
.more-tag {
  font-size: 11px;
  letter-spacing: 2px;
  color: rgba(232, 116, 108, 0.95);
}
.more-title {
  margin-top: 6px;
  font-size: 17px;
  font-weight: 400;
  letter-spacing: 3px;
  color: var(--paper);
}
.more-card:hover .more-title { color: var(--gold); }
.more-desc {
  margin-top: 8px;
  font-size: 13px;
  line-height: 1.8;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.55);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
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

/* ── 响应式 ─────────────────────────────────── */
@media (max-width: 820px) {
  .hero { grid-template-columns: 1fr; gap: 20px; }
  .timeline li { flex-direction: column; gap: 6px; }
  .tl-time { width: auto; }
}
</style>
