<template>
  <!-- 站点页脚：首页与剧集页共用 -->
  <footer class="site-foot">
    <div class="foot-inner">
      <div class="foot-brand">
        <span class="foot-seal">捕</span>
        <div>
          <strong>魅影神捕</strong>
          <em>夜巡百案 · 缉魅归真</em>
        </div>
      </div>

      <nav class="foot-links">
        <a v-for="l in LINKS" :key="l.label" href="javascript:;" @click="emit('nav', l)">{{ l.label }}</a>
      </nav>

      <p class="foot-note">
        本府重地<span class="divider">·</span>魅影勿近<span class="divider">·</span>© 2026 魅影神捕探案录
      </p>
      <p class="foot-demo">演示页面 · 内容为示例数据，接口待接入</p>
    </div>
  </footer>
</template>

<script setup>
const emit = defineEmits(['nav'])

// 页脚链接目前只有首页是真实页面，其余交给父级弹提示
const LINKS = [
  { label: '首页', path: '/' },
  { label: '剧集', path: '/series' },
  { label: '案卷' },
  { label: '悬案榜' },
  { label: '关于' }
]
</script>

<style scoped>
.site-foot {
  border-top: 1px solid rgba(216, 176, 106, 0.14);
  background: linear-gradient(180deg, rgba(7, 9, 15, 0.3), rgba(7, 9, 15, 0.75));
}
.foot-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 30px 24px 34px;
  text-align: center;
}
.foot-brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  text-align: left;
}
.foot-seal {
  width: 32px;
  height: 32px;
  border-radius: 5px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 17px;
  color: #ffe6cf;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 62%, #8e2222);
  transform: rotate(-6deg);
}
.foot-brand strong {
  display: block;
  font-weight: 400;
  font-size: 17px;
  letter-spacing: 4px;
  color: var(--paper);
}
.foot-brand em {
  font-style: normal;
  font-size: 11px;
  letter-spacing: 3px;
  color: rgba(216, 176, 106, 0.7);
}

.foot-links {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 22px;
  margin-bottom: 18px;
}
.foot-links a {
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.6);
  text-decoration: none;
  transition: color 0.25s;
}
.foot-links a:hover { color: var(--gold); }

.foot-note {
  font-size: 12px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.5);
}
.foot-note .divider { margin: 0 8px; color: rgba(216, 176, 106, 0.35); }
.foot-demo {
  margin-top: 10px;
  font-size: 11px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.32);
}
</style>
