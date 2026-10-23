<template>
  <!-- 内页通用外壳：背景层 + 吸顶导航 + 页头 + 内容 + 页脚 -->
  <BackgroundScene :show-lantern="false" />

  <div class="scroller" @scroll.passive="onScroll">
    <SiteHeader :solid="scrolled" @focus-search="onFocusSearch" />

    <main class="page">
      <header class="head">
        <button v-if="back" class="back" type="button" @click="goBack">‹ 返回</button>

        <p class="crumb">
          <router-link to="/">探案录</router-link>
          <span class="sep">›</span>
          <span class="now">{{ crumb || title }}</span>
        </p>

        <h1 class="title">{{ title }}</h1>
        <p v-if="desc" class="desc">{{ desc }}</p>

        <!-- 页头右侧 / 下方的额外内容（筛选条、统计之类） -->
        <slot name="head-extra" />
      </header>

      <slot />
    </main>

    <SiteFooter />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import BackgroundScene from '../BackgroundScene.vue'
import SiteHeader from '../layout/SiteHeader.vue'
import SiteFooter from '../layout/SiteFooter.vue'

const props = defineProps({
  title: { type: String, default: '' },
  desc: { type: String, default: '' },
  /** 面包屑最后一段，不传就用 title */
  crumb: { type: String, default: '' },
  /** 是否显示返回按钮（详情页用） */
  back: { type: Boolean, default: false }
})
props // 仅为消掉「未使用变量」的告警，模板里直接按名取用

const router = useRouter()
const scrolled = ref(false)

function onScroll(e) {
  scrolled.value = e.target.scrollTop > 12
}

// 有来路就回上一页，直接输地址进来的就回首页
function goBack() {
  if (window.history.length > 1) router.back()
  else router.push('/')
}

// 内页点搜索图标：回首页并把焦点交给搜索框
function onFocusSearch() {
  router.push({ path: '/', query: { focus: 'search' } })
}
</script>

<style scoped>
.scroller {
  position: relative;
  z-index: 1;
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  scroll-behavior: smooth;
}

.page {
  max-width: 1200px;
  margin: 0 auto;
  padding: 34px 24px 48px;
  min-height: 60vh;
}

/* ── 页头 ─────────────────────────────────── */
.head {
  position: relative;
  margin-bottom: 30px;
  padding-bottom: 22px;
  border-bottom: 1px solid rgba(216, 176, 106, 0.14);
}

.back {
  position: absolute;
  top: 2px;
  right: 0;
  padding: 6px 14px;
  font-family: inherit;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.7);
  border: 1px solid rgba(143, 179, 217, 0.28);
  border-radius: 5px;
  background: transparent;
  cursor: pointer;
  transition: color 0.25s, border-color 0.25s, box-shadow 0.3s;
}
.back:hover {
  color: var(--gold);
  border-color: var(--gold);
  box-shadow: 0 0 14px rgba(216, 176, 106, 0.22);
}

.crumb {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.55);
  margin-bottom: 12px;
}
.crumb a {
  color: rgba(143, 179, 217, 0.7);
  text-decoration: none;
  transition: color 0.25s;
}
.crumb a:hover { color: var(--gold); }
.crumb .sep { color: rgba(216, 176, 106, 0.4); }
.crumb .now { color: rgba(232, 226, 212, 0.8); }

.title {
  font-size: 28px;
  font-weight: 400;
  letter-spacing: 6px;
  color: var(--paper);
  text-shadow: 0 2px 18px rgba(0, 0, 0, 0.7);
}
.title::before {
  content: "";
  display: inline-block;
  width: 3px;
  height: 22px;
  margin-right: 14px;
  vertical-align: -3px;
  background: linear-gradient(180deg, var(--gold), var(--cinnabar));
  border-radius: 2px;
}

.desc {
  margin-top: 12px;
  font-size: 13px;
  line-height: 1.9;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.6);
  max-width: 760px;
}

@media (max-width: 640px) {
  .page { padding: 24px 14px 34px; }
  .title { font-size: 22px; letter-spacing: 4px; }
  .back { position: static; margin-bottom: 12px; }
}
</style>
