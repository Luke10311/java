<template>
  <PageShell
    title="我的喜欢"
    desc="案件卷宗里点「♡ 喜欢此案」的案件都收在这里。喜欢的案件存在本机浏览器里，换台机器就带不走。"
    crumb="我的喜欢"
  >
    <!-- 已喜欢的案件 -->
    <template v-if="list.length">
      <!-- 统计条 -->
      <div class="summary">
        <span>已收 <b>{{ list.length }}</b> 案</span>
        <span class="dot">·</span>
        <span>缉查中 <b>{{ activeCount }}</b> 案</span>
        <span class="dot">·</span>
        <span>已封卷 <b>{{ closedCount }}</b> 案</span>
        <button class="clear" type="button" @click="onClear">清空喜欢</button>
      </div>

      <div class="grid">
        <div v-for="c in list" :key="c.id" class="cell">
          <article class="case-card" @click="open(c)">
            <div class="case-pic">
              <img :src="c.image" :alt="c.title + ' 案发写影'" loading="lazy">
              <span class="case-veil" aria-hidden="true"></span>
              <span class="case-tag">{{ c.tag }}</span>
            </div>
            <div class="case-body">
              <h4 class="case-title">{{ c.title }}</h4>
              <p class="case-desc">{{ c.desc }}</p>
              <div class="case-meta">
                <span class="m-place">案发于 {{ c.place }}</span>
                <span class="m-status" :class="{ closed: c.status === '已封卷' }">{{ c.status }}</span>
                <span class="m-reward">{{ c.reward }}</span>
              </div>
            </div>
          </article>
          <button class="remove" type="button" title="移出喜欢" @click.stop="onRemove(c)">♥ 移出喜欢</button>
        </div>
      </div>
    </template>

    <!-- 空态 -->
    <div v-else class="empty">
      <p class="empty-glyph">心</p>
      <p class="empty-text">还没有喜欢的案件。下面这些未结奇案里挑几桩，点「＋ 收进喜欢」就收进来了。</p>
    </div>

    <!-- 全部案件：在这里也能直接加入喜欢 -->
    <section class="block">
      <div class="sec-head">
        <h3 class="sec-title">{{ list.length ? '再添几桩' : '未结奇案' }}</h3>
        <span class="sec-line"></span>
      </div>

      <div class="pick-grid">
        <div
          v-for="c in CASES"
          :key="c.id"
          class="pick-card"
          :class="{ picked: isLiked(c.id) }"
          @click="open(c)"
        >
          <img class="pick-pic" :src="c.image" :alt="c.title" loading="lazy">
          <div class="pick-body">
            <h4 class="pick-title">{{ c.title }}</h4>
            <p class="pick-sub">{{ c.place }} · {{ c.status }}</p>
          </div>
          <button class="pick-btn" type="button" @click.stop="onToggle(c)">
            {{ isLiked(c.id) ? '♥ 已喜欢' : '＋ 收进喜欢' }}
          </button>
        </div>
      </div>
    </section>
  </PageShell>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import { CASES } from '../data/cases'
import { clearLikes, isLiked, likedCases, removeLike, toggleLike } from '../store/likes'
import { showToast } from '../store/shell'

const router = useRouter()

const list = computed(() => likedCases.value)

const activeCount = computed(() => list.value.filter((c) => c.status === '缉查中').length)
const closedCount = computed(() => list.value.filter((c) => c.status === '已封卷').length)

function open(c) {
  router.push(`/case/${c.id}`)
}

function onToggle(c) {
  const added = toggleLike(c.id)
  showToast(added ? `「${c.title}」已收进喜欢。` : `已移出对「${c.title}」的喜欢。`)
}

function onRemove(c) {
  removeLike(c.id)
  showToast(`已移出对「${c.title}」的喜欢。`)
}

function onClear() {
  clearLikes()
  showToast('喜欢的案件已清空。')
}
</script>

<style scoped>
/* ── 统计条 ─────────────────────────────────── */
.summary {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  margin-bottom: 22px;
  padding: 12px 18px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.65);
  border: 1px solid rgba(216, 176, 106, 0.18);
  border-radius: 8px;
  background: rgba(9, 12, 20, 0.5);
}
.summary b { color: var(--gold); font-weight: 400; }
.summary .dot { color: rgba(216, 176, 106, 0.35); }
.clear {
  margin-left: auto;
  padding: 5px 14px;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.6);
  border: 1px solid rgba(143, 179, 217, 0.25);
  border-radius: 5px;
  background: transparent;
  cursor: pointer;
  transition: all 0.25s;
}
.clear:hover { color: #f0a49c; border-color: var(--cinnabar); }

/* ── 已喜欢案件卡片 ─────────────────────────── */
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 28px 20px;
}
.cell { position: relative; }

.case-card {
  border: 1px solid rgba(216, 176, 106, 0.2);
  border-radius: 10px;
  overflow: hidden;
  background: rgba(9, 12, 20, 0.6);
  cursor: pointer;
  transition: border-color 0.3s, transform 0.3s, box-shadow 0.3s;
}
.case-card:hover {
  border-color: rgba(216, 176, 106, 0.5);
  box-shadow: 0 16px 40px rgba(0, 0, 0, 0.45);
  transform: translateY(-3px);
}
.case-pic {
  position: relative;
  aspect-ratio: 16 / 9;
  overflow: hidden;
  background: #0a0e18;
}
.case-pic img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}
.case-card:hover .case-pic img { transform: scale(1.06); }
.case-veil {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 55%, rgba(9, 12, 20, 0.65) 100%);
}
.case-tag {
  position: absolute;
  top: 10px;
  left: 10px;
  padding: 3px 9px;
  font-size: 11px;
  letter-spacing: 2px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.85);
  border-radius: 3px;
}
.case-body { padding: 14px 16px 16px; }
.case-title {
  font-size: 17px;
  font-weight: 400;
  letter-spacing: 3px;
  color: var(--paper);
}
.case-card:hover .case-title { color: var(--gold); }
.case-desc {
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
.case-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 12px;
  font-size: 12px;
  letter-spacing: 1px;
}
.m-place { color: rgba(143, 179, 217, 0.75); }
.m-status { color: rgba(232, 116, 108, 0.95); }
.m-status.closed { color: rgba(143, 179, 217, 0.7); }
.m-reward { color: var(--gold); }

.remove {
  margin-top: 8px;
  width: 100%;
  padding: 6px 0;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(232, 116, 108, 0.7);
  border: 1px solid rgba(232, 116, 108, 0.2);
  border-radius: 5px;
  background: transparent;
  cursor: pointer;
  opacity: 0;
  transition: all 0.25s;
}
.cell:hover .remove { opacity: 1; }
.remove:hover { color: #f0a49c; border-color: rgba(194, 58, 58, 0.5); }

/* ── 空态 ───────────────────────────────────── */
.empty { padding: 76px 20px 40px; text-align: center; }
.empty-glyph { font-size: 52px; color: rgba(216, 176, 106, 0.22); margin-bottom: 16px; }
.empty-text {
  font-size: 14px;
  line-height: 2;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
}

/* ── 全部案件挑选区 ─────────────────────────── */
.block { margin-top: 46px; }
.sec-head { display: flex; align-items: center; gap: 16px; margin-bottom: 18px; }
.sec-title {
  font-size: 19px;
  font-weight: 400;
  letter-spacing: 4px;
  color: var(--paper);
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
.sec-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.35), transparent);
}

.pick-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 14px;
}
.pick-card {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 12px 14px;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 8px;
  background: rgba(9, 12, 20, 0.55);
  cursor: pointer;
  transition: border-color 0.25s, box-shadow 0.25s, transform 0.2s;
}
.pick-card:hover {
  border-color: rgba(216, 176, 106, 0.45);
  box-shadow: 0 10px 26px rgba(0, 0, 0, 0.4);
  transform: translateY(-2px);
}
.pick-card.picked { border-color: rgba(232, 116, 108, 0.45); }
.pick-pic {
  flex-shrink: 0;
  width: 84px;
  height: 56px;
  object-fit: cover;
  border-radius: 5px;
  border: 1px solid rgba(216, 176, 106, 0.2);
}
.pick-body { flex: 1; min-width: 0; }
.pick-title {
  font-size: 15px;
  font-weight: 400;
  letter-spacing: 2px;
  color: var(--paper);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.pick-card:hover .pick-title { color: var(--gold); }
.pick-sub {
  margin-top: 5px;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.65);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.pick-btn {
  flex-shrink: 0;
  padding: 7px 13px;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 2px;
  color: var(--gold);
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 5px;
  background: transparent;
  cursor: pointer;
  white-space: nowrap;
  transition: all 0.25s;
}
.pick-btn:hover {
  color: #ffe9cf;
  background: rgba(194, 58, 58, 0.35);
  border-color: var(--cinnabar);
}
.pick-card.picked .pick-btn {
  color: rgba(232, 116, 108, 0.95);
  border-color: rgba(232, 116, 108, 0.4);
}

/* ── 响应式 ─────────────────────────────────── */
@media (max-width: 640px) {
  .grid { grid-template-columns: 1fr; gap: 22px 14px; }
  .remove { opacity: 1; }
  .clear { margin-left: 0; }
  .pick-grid { grid-template-columns: 1fr; }
}
</style>
