<template>
  <!-- 背景氛围层 -->
  <div class="scene">
    <div class="moon"></div>
    <div class="lantern">
      <div class="rope"></div>
      <div class="body"><span class="word">捕</span></div>
      <div class="tassel"></div>
    </div>
    <div class="mist"></div>
    <div class="mist m2"></div>
    <svg class="mountains" viewBox="0 0 1440 300" preserveAspectRatio="none">
      <path d="M0,300 L0,190 Q120,120 240,170 T480,150 Q560,130 640,175 T900,160 Q1010,110 1120,175 T1380,150 L1440,180 L1440,300 Z" fill="#0e1626" opacity="0.9"/>
      <path d="M0,300 L0,240 Q180,180 360,230 T720,225 Q860,200 1000,240 T1360,230 L1440,250 L1440,300 Z" fill="#0a0f1b"/>
    </svg>
    <span
      v-for="(f, i) in fireflies"
      :key="i"
      class="firefly"
      :style="f"
    ></span>
  </div>
</template>

<script setup>
// 生成飘浮魅影粒子（挂载时生成一次，等价于原版的动态 append）
const fireflies = Array.from({ length: 22 }, () => {
  const style = {
    left: Math.random() * 100 + '%',
    bottom: Math.random() * 30 + '%',
    animationDuration: 12 + Math.random() * 14 + 's',
    animationDelay: Math.random() * 12 + 's'
  }
  if (Math.random() > 0.75) {
    style.background = '#d8564f'
    style.boxShadow = '0 0 8px 2px rgba(194,58,58,.5)'
  }
  return style
})
</script>

<style scoped>
.scene {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 0;
}

/* 满月 */
.moon {
  position: absolute;
  top: 9%;
  right: 14%;
  width: 150px;
  height: 150px;
  border-radius: 50%;
  background: radial-gradient(circle at 38% 34%, #f4ecd8 0%, #d9cfae 55%, #b8ad8a 100%);
  box-shadow: 0 0 70px 25px rgba(217, 207, 174, 0.25), 0 0 160px 60px rgba(143, 179, 217, 0.12);
  animation: moonBreath 9s ease-in-out infinite;
}
@keyframes moonBreath {
  0%, 100% { box-shadow: 0 0 70px 25px rgba(217,207,174,.25), 0 0 160px 60px rgba(143,179,217,.12); }
  50% { box-shadow: 0 0 90px 35px rgba(217,207,174,.32), 0 0 200px 80px rgba(143,179,217,.18); }
}

/* 远山剪影 */
.mountains {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 42%;
  opacity: 0.85;
}
.mountains svg { width: 100%; height: 100%; }

/* 飘雾 */
.mist {
  position: absolute;
  bottom: -8%;
  left: -20%;
  width: 140%;
  height: 38%;
  background: linear-gradient(90deg, transparent, rgba(143,179,217,0.10) 30%, rgba(143,179,217,0.16) 55%, rgba(143,179,217,0.08) 80%, transparent);
  filter: blur(28px);
  animation: mistDrift 26s linear infinite;
}
.mist.m2 {
  bottom: 4%;
  animation-duration: 38s;
  animation-direction: reverse;
  opacity: 0.6;
}
@keyframes mistDrift {
  0% { transform: translateX(-6%); }
  50% { transform: translateX(6%); }
  100% { transform: translateX(-6%); }
}

/* 魅影粒子 */
.firefly {
  position: absolute;
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background: var(--mist);
  box-shadow: 0 0 8px 2px var(--mist-dim);
  opacity: 0;
  animation: floatUp linear infinite;
}
@keyframes floatUp {
  0% { transform: translate(0, 0) scale(0.6); opacity: 0; }
  12% { opacity: 0.9; }
  80% { opacity: 0.5; }
  100% { transform: translate(60px, -70vh) scale(1.1); opacity: 0; }
}

/* 红灯笼（左上角） */
.lantern {
  position: absolute;
  top: -8px;
  left: 8%;
  display: flex;
  flex-direction: column;
  align-items: center;
  animation: lanternSway 7s ease-in-out infinite;
  transform-origin: top center;
}
@keyframes lanternSway {
  0%, 100% { transform: rotate(2.5deg); }
  50% { transform: rotate(-2.5deg); }
}
.lantern .rope { width: 2px; height: 52px; background: linear-gradient(#6a4a2a, #3a2a18); }
.lantern .body {
  width: 54px;
  height: 66px;
  border-radius: 46%/50%;
  background: radial-gradient(circle at 42% 34%, #e8564f 0%, var(--cinnabar) 55%, #7e2020 100%);
  box-shadow: 0 0 34px 10px var(--cinnabar-glow), inset 0 0 14px rgba(255, 200, 120, 0.45);
  position: relative;
}
.lantern .body::before, .lantern .body::after {
  content: "";
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 26px;
  height: 7px;
  background: linear-gradient(#e8c766, #8a6a2a);
  border-radius: 3px;
}
.lantern .body::before { top: -4px; }
.lantern .body::after { bottom: -4px; }
.lantern .tassel {
  width: 3px;
  height: 26px;
  background: linear-gradient(#d8b06a, #7e5a2a);
  margin-top: 4px;
}
.lantern .word {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 22px;
  color: #ffe9c9;
  text-shadow: 0 0 8px rgba(255, 200, 120, 0.8);
}

@media (max-width: 480px) {
  .moon { width: 100px; height: 100px; right: 8%; }
  .lantern { left: 4%; }
}
</style>
