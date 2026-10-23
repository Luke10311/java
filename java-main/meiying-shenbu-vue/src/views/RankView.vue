<template>
  <PageShell
    title="悬案榜"
    desc="按全城缉查热度排定。榜上每一卷都在被人翻，热度越高压得越紧。"
    crumb="悬案榜"
  >
    <div class="legend">
      <span class="lg up">▲ 上升</span>
      <span class="lg flat">— 持平</span>
      <span class="lg down">▼ 下滑</span>
      <span class="lg-note">数据为演示样例，后端榜单接口就绪后替换</span>
    </div>

    <ol class="board">
      <li
        v-for="item in list"
        :key="item.id"
        class="row"
        :class="'top-' + item.rank"
        @click="open(item)"
      >
        <span class="no">{{ item.rank }}</span>

        <span class="thumb" :style="thumbStyle(item)">
          <img v-if="item.poster" :src="item.poster" :alt="item.title + ' 缩略图'" loading="lazy">
        </span>

        <span class="body">
          <span class="name">{{ item.title }}</span>
          <span class="meta">{{ item.year }} · {{ item.genres.join(' / ') }} · {{ item.episodes }} 集</span>
        </span>

        <span class="score">★ {{ item.score.toFixed(1) }}</span>
        <span class="heat">{{ item.heat }}</span>
        <span class="trend" :class="item.trend">
          {{ item.trend === 'up' ? '▲' : item.trend === 'down' ? '▼' : '—' }}
        </span>
      </li>
    </ol>

    <p class="tip">点任意一卷可直接翻到卷宗详情。</p>
  </PageShell>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import { fetchRankAll } from '../api/home'

const router = useRouter()
const list = ref([])

onMounted(async () => {
  const res = await fetchRankAll(10)
  list.value = res.data || []
})

/** 没海报的用色相渐变兜底，跟首页榜单一致 */
function thumbStyle(item) {
  if (item.poster) return null
  return {
    background: `radial-gradient(120% 120% at 30% 20%, hsl(${item.hue} 46% 32% / 0.95), #0a0e18 100%)`
  }
}

function open(item) {
  router.push(`/drama/${item.id}`)
}
</script>

<style scoped>
.legend {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 16px;
  margin-bottom: 18px;
  font-size: 12px;
  letter-spacing: 1px;
}
.lg.up { color: var(--cinnabar); }
.lg.down { color: #6fb98f; }
.lg.flat { color: rgba(143, 179, 217, 0.55); }
.lg-note { margin-left: auto; color: rgba(143, 179, 217, 0.4); }

.board {
  list-style: none;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 10px;
  overflow: hidden;
  background: rgba(9, 12, 20, 0.55);
}

.row {
  display: flex;
  align-items: center;
  gap: 18px;
  padding: 14px 22px;
  cursor: pointer;
  border-bottom: 1px solid rgba(143, 179, 217, 0.08);
  transition: background 0.25s, padding-left 0.25s;
}
.row:last-child { border-bottom: 0; }
.row:hover { background: rgba(216, 176, 106, 0.07); padding-left: 28px; }

.no {
  width: 30px;
  flex-shrink: 0;
  text-align: center;
  font-size: 18px;
  color: rgba(143, 179, 217, 0.6);
}
.row.top-1 .no { color: var(--cinnabar); text-shadow: 0 0 12px rgba(194, 58, 58, 0.65); }
.row.top-2 .no { color: var(--gold); }
.row.top-3 .no { color: #c8a06a; }

.thumb {
  width: 40px;
  height: 54px;
  flex-shrink: 0;
  border: 1px solid rgba(216, 176, 106, 0.22);
  border-radius: 4px;
  overflow: hidden;
  background: #0a0e18;
}
.thumb img { width: 100%; height: 100%; object-fit: cover; display: block; }

.body { flex: 1; min-width: 0; display: flex; flex-direction: column; gap: 4px; }
.name {
  font-size: 16px;
  letter-spacing: 2px;
  color: var(--paper);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: color 0.25s;
}
.row:hover .name { color: var(--gold); }
.meta {
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.55);
}

.score { flex-shrink: 0; font-size: 14px; color: var(--gold); }
.heat {
  flex-shrink: 0;
  width: 74px;
  text-align: right;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.5);
}
.trend { flex-shrink: 0; width: 18px; text-align: center; font-size: 12px; }
.trend.up { color: var(--cinnabar); }
.trend.down { color: #6fb98f; }
.trend.flat { color: rgba(143, 179, 217, 0.5); }

.tip {
  margin-top: 16px;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.45);
  text-align: center;
}

@media (max-width: 700px) {
  .row { gap: 12px; padding: 12px 14px; }
  .row:hover { padding-left: 14px; }
  .thumb { width: 34px; height: 46px; }
  .heat, .score { display: none; }
  .lg-note { display: none; }
}
</style>
