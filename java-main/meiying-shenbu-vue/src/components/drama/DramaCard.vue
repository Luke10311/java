<template>
  <!-- 剧集卡片：真实海报图；图挂了回退到色相渐变 + 首字的写意封面 -->
  <article class="drama" @click="emit('open', drama)">
    <div class="poster" :style="posterFallback">
      <!-- 写意封面（图片未加载 / 加载失败时的兜底层） -->
      <span class="glyph">{{ drama.title.slice(0, 1) }}</span>

      <!-- 真实海报：hueShift 做轻度调色，让复用图看起来是不同卷宗 -->
      <img
        v-if="drama.poster"
        class="pic"
        :class="{ on: loaded && !failed, broken: failed }"
        :src="drama.poster"
        :alt="drama.title + ' 海报'"
        :style="picStyle"
        loading="lazy"
        decoding="async"
        @load="loaded = true"
        @error="failed = true"
      >

      <span v-if="drama.badge" class="badge">{{ drama.badge }}</span>
      <span class="score">{{ drama.score.toFixed(1) }}</span>
      <span class="veil"></span>

      <!-- 灯笼微光：悬停时一盏小红灯从右上角亮起，暖光晕染整张卷宗 -->
      <span class="lantern-glow" aria-hidden="true"></span>
      <span class="mini-lantern" aria-hidden="true">
        <i class="ml-rope"></i>
        <i class="ml-body">捕</i>
        <i class="ml-tassel"></i>
      </span>

      <span class="hover-hint">▸ 展开卷宗</span>
    </div>

    <div class="meta">
      <h4 class="name">{{ drama.title }}</h4>
      <p class="sub">{{ drama.year }} · {{ drama.genres.join(' / ') }}</p>
    </div>
  </article>
</template>

<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  drama: { type: Object, required: true }
})
const emit = defineEmits(['open'])

/** 图片是否已加载成功（决定兜底渐变要不要淡出） */
const loaded = ref(false)
const failed = ref(false)

/** 图片加载失败 / 没有图时的写意封面（沿用色相渐变方案） */
const posterFallback = computed(() => {
  if (loaded.value && !failed.value) return null
  const h = props.drama.hue
  return {
    background: `radial-gradient(120% 90% at 26% 14%, hsl(${h} 46% 30% / 0.95) 0%, hsl(${h} 44% 16% / 0.92) 46%, #080b13 100%)`,
    borderColor: `hsl(${h} 60% 55% / 0.25)`
  }
})

/** 轻度调色：hot 的 8 部用原图（hueShift=0），复用图的那几部各转一点色相 */
const picStyle = computed(() => {
  const s = props.drama.hueShift || 0
  if (!s) return null
  return { filter: `hue-rotate(${s}deg) saturate(0.92)` }
})
</script>

<style scoped>
.drama {
  cursor: pointer;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.38s cubic-bezier(0.22, 1, 0.36, 1);
}
/* 微微上浮：起手快、落定缓，像一页卷宗被轻轻拈起 */
.drama:hover {
  transform: translateY(-9px) scale(1.015);
}

.poster {
  position: relative;
  aspect-ratio: 3 / 4;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 8px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: border-color 0.32s, box-shadow 0.32s;
}
.drama:hover .poster {
  border-color: rgba(216, 176, 106, 0.6);
  box-shadow: 0 18px 42px rgba(0, 0, 0, 0.62), 0 0 26px rgba(216, 176, 106, 0.22);
}

/* ---------- 灯笼微光 ---------- */

/* 暖光晕：右上角一盏看不见的灯笼打下来的光，缓缓铺满卷宗 */
.lantern-glow {
  position: absolute;
  inset: 0;
  z-index: 1;
  pointer-events: none;
  background:
    radial-gradient(58% 46% at 82% 10%,
      rgba(255, 176, 88, 0.34) 0%,
      rgba(224, 122, 60, 0.16) 38%,
      transparent 72%);
  opacity: 0;
  transition: opacity 0.55s ease;
}
.drama:hover .lantern-glow {
  opacity: 1;
  animation: lanternBreath 3.2s ease-in-out infinite;
}
/* 灯笼光会随夜风轻轻呼吸 */
@keyframes lanternBreath {
  0%, 100% { opacity: 0.75; }
  50%      { opacity: 1; }
}

/* 小红灯笼本体：悬停时从卡片檐下探出来 */
.mini-lantern {
  position: absolute;
  top: 6px;
  right: 12px;
  z-index: 3;
  width: 18px;
  pointer-events: none;
  opacity: 0;
  transform: translateY(-10px);
  transition: opacity 0.45s ease 0.08s, transform 0.45s cubic-bezier(0.22, 1, 0.36, 1) 0.08s;
  transform-origin: top center;
}
.drama:hover .mini-lantern {
  opacity: 1;
  transform: translateY(0);
  animation: miniSway 3.4s ease-in-out infinite;
}
/* 灯笼随风轻摆（悬挂点在上，摆幅下大上小） */
@keyframes miniSway {
  0%, 100% { transform: translateY(0) rotate(4deg); }
  50%      { transform: translateY(0) rotate(-4deg); }
}
.ml-rope {
  display: block;
  width: 1px;
  height: 7px;
  margin: 0 auto;
  background: linear-gradient(#caa25a, #8a6a3a);
}
.ml-body {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 16px;
  height: 13px;
  font-size: 8px;
  font-style: normal;
  line-height: 1;
  color: #ffe9c4;
  background: radial-gradient(circle at 40% 32%, #ff8c5a 0%, #e34d3a 58%, #a82c22 100%);
  border-radius: 45%;
  animation: lanternLight 2.6s ease-in-out infinite;
}
/* 灯身微微发光，像烛火在里头晃 */
@keyframes lanternLight {
  0%, 100% { box-shadow: 0 0 6px 2px rgba(255, 150, 70, 0.45); }
  50%      { box-shadow: 0 0 13px 5px rgba(255, 160, 80, 0.75); }
}
.ml-tassel {
  display: block;
  width: 1px;
  height: 6px;
  margin: 0 auto;
  background: linear-gradient(#e34d3a, rgba(227, 77, 58, 0.15));
}

/* 兜底渐变上的首字 */
.glyph {
  font-size: 58px;
  color: rgba(232, 226, 212, 0.16);
  transition: color 0.32s, transform 0.32s;
  user-select: none;
}

/* 真实海报 */
.pic {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 0;
  transform: scale(1.06);
  transition: opacity 0.6s ease, transform 6s ease-out;
}
.pic.on { opacity: 1; transform: scale(1); }
.drama:hover .pic { transform: scale(1.07); }

/* 图挂了就把 img 藏掉，露出底下的渐变兜底 */
.pic.broken { display: none; }

.badge {
  position: absolute;
  top: 8px;
  left: 8px;
  z-index: 2;
  padding: 2px 8px;
  font-size: 11px;
  letter-spacing: 1px;
  color: #ffe6cf;
  background: rgba(194, 58, 58, 0.9);
  border-radius: 3px;
  box-shadow: 0 4px 12px rgba(194, 58, 58, 0.4);
}

.score {
  position: absolute;
  right: 8px;
  bottom: 8px;
  z-index: 2;
  padding: 2px 8px;
  font-size: 13px;
  color: var(--gold);
  background: rgba(7, 9, 15, 0.78);
  border: 1px solid rgba(216, 176, 106, 0.35);
  border-radius: 3px;
}

/* 底部压暗，保证片名可读 */
.veil {
  position: absolute;
  inset: 0;
  z-index: 1;
  background: linear-gradient(180deg, rgba(7, 9, 15, 0.06) 55%, rgba(7, 9, 15, 0.62) 100%);
  transition: opacity 0.32s;
}

/* 悬停提示 */
.hover-hint {
  position: absolute;
  left: 10px;
  bottom: 10px;
  z-index: 2;
  font-size: 12px;
  letter-spacing: 2px;
  color: var(--paper);
  opacity: 0;
  transform: translateY(6px);
  transition: opacity 0.3s, transform 0.3s;
}
.drama:hover .hover-hint { opacity: 0.95; transform: none; }

.meta { padding: 10px 2px 2px; }
.name {
  font-size: 16px;
  font-weight: 400;
  letter-spacing: 2px;
  color: var(--paper);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  transition: color 0.28s;
}
.drama:hover .name { color: var(--gold); }
.sub {
  margin-top: 4px;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(143, 179, 217, 0.6);
}
</style>
