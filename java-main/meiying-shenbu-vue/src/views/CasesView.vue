<template>
  <PageShell
    title="我的案卷"
    desc="首页与卷宗页里点「加入案卷」的剧集都收在这里。案卷存在本机浏览器里，换台机器就带不走。"
    crumb="我的案卷"
  >
    <!-- 统计条 -->
    <div v-if="list.length" class="summary">
      <span>已归卷 <b>{{ list.length }}</b> 卷</span>
      <span class="dot">·</span>
      <span>合计 <b>{{ totalEpisodes }}</b> 集</span>
      <span class="dot">·</span>
      <span>均分 <b>{{ avgScore }}</b></span>
      <button class="clear" type="button" @click="onClear">清空案卷</button>
    </div>

    <!-- 有内容 -->
    <div v-if="list.length" class="grid">
      <div v-for="d in list" :key="d.id" class="cell">
        <DramaCard :drama="d" @open="open" />
        <button class="remove" type="button" title="从案卷移出" @click.stop="onRemove(d)">✕ 移出</button>
      </div>
    </div>

    <!-- 空态 -->
    <div v-else class="empty">
      <p class="empty-glyph">卷</p>
      <p class="empty-text">案卷还是空的。去剧集里挑几卷，点「＋ 加入案卷」就收进来了。</p>
      <div class="empty-actions">
        <button class="btn-main" type="button" @click="router.push('/series')">去挑剧集</button>
        <button class="btn-ghost" type="button" @click="router.push('/rank')">看看悬案榜</button>
      </div>
    </div>
  </PageShell>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import DramaCard from '../components/drama/DramaCard.vue'
import { caseDramas, clearCases, removeCase } from '../store/cases'
import { showToast } from '../store/shell'

const router = useRouter()

const list = computed(() => caseDramas.value)

const totalEpisodes = computed(() => list.value.reduce((s, d) => s + d.episodes, 0))

const avgScore = computed(() => {
  if (!list.value.length) return '—'
  const avg = list.value.reduce((s, d) => s + d.score, 0) / list.value.length
  return avg.toFixed(1)
})

function open(d) {
  router.push(`/drama/${d.id}`)
}

function onRemove(d) {
  removeCase(d.id)
  showToast(`已从案卷中取出《${d.title}》。`)
}

function onClear() {
  clearCases()
  showToast('案卷已清空。')
}
</script>

<style scoped>
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

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 28px 20px;
}
.cell { position: relative; }

.remove {
  margin-top: 8px;
  width: 100%;
  padding: 6px 0;
  font-family: inherit;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.55);
  border: 1px solid rgba(143, 179, 217, 0.16);
  border-radius: 5px;
  background: transparent;
  cursor: pointer;
  opacity: 0;
  transition: all 0.25s;
}
.cell:hover .remove { opacity: 1; }
.remove:hover { color: #f0a49c; border-color: rgba(194, 58, 58, 0.5); }

.empty { padding: 76px 20px; text-align: center; }
.empty-glyph { font-size: 52px; color: rgba(216, 176, 106, 0.22); margin-bottom: 16px; }
.empty-text {
  font-size: 14px;
  line-height: 2;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
  margin-bottom: 26px;
}
.empty-actions { display: flex; flex-wrap: wrap; gap: 12px; justify-content: center; }

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
.btn-ghost:hover { border-color: var(--gold); color: var(--gold); }

@media (max-width: 640px) {
  .grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 22px 14px; }
  .remove { opacity: 1; }
  .clear { margin-left: 0; }
}
</style>
