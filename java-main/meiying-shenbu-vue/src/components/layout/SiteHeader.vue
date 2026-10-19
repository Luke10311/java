<template>
  <!-- 站点导航栏：吸顶，滚动后加深底色 -->
  <header class="nav" :class="{ solid }">
    <div class="nav-inner">
      <!-- 品牌 -->
      <a class="brand" href="javascript:;" @click="go(MENUS[0])">
        <span class="brand-seal">捕</span>
        <span class="brand-text">
          <strong>魅影神捕</strong>
          <em>夜巡百案 · 缉魅归真</em>
        </span>
      </a>

      <!-- 主导航 -->
      <nav class="menu">
        <a
          v-for="item in MENUS"
          :key="item.key"
          href="javascript:;"
          class="menu-item"
          :class="{ active: item.key === active }"
          @click="go(item)"
        >
          {{ item.label }}
          <i class="bar"></i>
        </a>
      </nav>

      <!-- 右侧：搜索入口 + 登录态 -->
      <div class="side">
        <button class="icon-btn" type="button" title="展开搜索" @click="emit('focus-search')">🔍</button>

        <template v-if="shell.user">
          <span class="who" :title="`当前登录：${shell.user}`">
            <i class="dot">🏮</i>{{ shell.user }}
          </span>
          <button class="ghost-btn" type="button" @click="logout">缴牌</button>
        </template>
        <button v-else class="enter-btn" type="button" @click="router.push('/login')">
          验牌入城
        </button>
      </div>
    </div>
  </header>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { logout, shell, showToast } from '../../store/shell'

defineProps({
  /** 当前高亮的菜单 key */
  active: { type: String, default: 'home' },
  /** 页面已滚动，导航栏加深底色 */
  solid: { type: Boolean, default: false }
})

const emit = defineEmits(['focus-search'])

const router = useRouter()

// 目前只有首页是真实页面，其余菜单等对应页面做好后再补 path
const MENUS = [
  { key: 'home', label: '首页', path: '/' },
  { key: 'series', label: '剧集' },
  { key: 'case', label: '案卷' },
  { key: 'rank', label: '悬案榜' },
  { key: 'about', label: '关于' }
]

function go(item) {
  if (item.path) {
    router.push(item.path)
    return
  }
  showToast(`「${item.label}」这一卷尚未展开，敬请候令。`)
}
</script>

<style scoped>
.nav {
  position: sticky;
  top: 0;
  z-index: 20;
  background: linear-gradient(180deg, rgba(7, 9, 15, 0.72), rgba(7, 9, 15, 0.35));
  border-bottom: 1px solid rgba(216, 176, 106, 0.12);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  transition: background 0.35s, border-color 0.35s, box-shadow 0.35s;
}
.nav.solid {
  background: linear-gradient(180deg, rgba(7, 9, 15, 0.94), rgba(7, 9, 15, 0.82));
  border-bottom-color: rgba(216, 176, 106, 0.26);
  box-shadow: 0 10px 34px rgba(0, 0, 0, 0.55);
}

.nav-inner {
  max-width: 1200px;
  margin: 0 auto;
  height: 68px;
  padding: 0 24px;
  display: flex;
  align-items: center;
  gap: 26px;
}

/* 品牌 */
.brand {
  display: flex;
  align-items: center;
  gap: 12px;
  text-decoration: none;
  flex-shrink: 0;
}
.brand-seal {
  width: 38px;
  height: 38px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  color: #ffe6cf;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 62%, #8e2222);
  box-shadow: 0 6px 16px rgba(194, 58, 58, 0.42), inset 0 0 8px rgba(0, 0, 0, 0.35);
  transform: rotate(-6deg);
  transition: transform 0.4s;
}
.brand:hover .brand-seal { transform: rotate(6deg) scale(1.06); }
.brand-text { display: flex; flex-direction: column; line-height: 1.25; }
.brand-text strong {
  font-size: 21px;
  letter-spacing: 4px;
  color: var(--paper);
  text-shadow: 0 0 14px rgba(143, 179, 217, 0.4);
  font-weight: 400;
}
.brand-text em {
  font-style: normal;
  font-size: 11px;
  letter-spacing: 3px;
  color: rgba(216, 176, 106, 0.75);
}

/* 主导航 */
.menu {
  display: flex;
  align-items: center;
  gap: 4px;
  flex: 1;
  min-width: 0;
  overflow-x: auto;
  scrollbar-width: none;
}
.menu::-webkit-scrollbar { display: none; }

.menu-item {
  position: relative;
  padding: 8px 16px;
  font-size: 15px;
  letter-spacing: 3px;
  color: rgba(232, 226, 212, 0.62);
  text-decoration: none;
  white-space: nowrap;
  transition: color 0.28s;
}
.menu-item:hover { color: var(--paper); }
.menu-item.active { color: var(--gold); text-shadow: 0 0 12px rgba(216, 176, 106, 0.5); }
.menu-item .bar {
  position: absolute;
  left: 50%;
  bottom: 0;
  width: 0;
  height: 2px;
  transform: translateX(-50%);
  background: linear-gradient(90deg, transparent, var(--gold), transparent);
  transition: width 0.32s cubic-bezier(0.22, 1, 0.36, 1);
}
.menu-item.active .bar { width: 78%; }

/* 右侧 */
.side {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;
}

.icon-btn {
  width: 34px;
  height: 34px;
  border-radius: 6px;
  border: 1px solid rgba(216, 176, 106, 0.22);
  background: rgba(7, 9, 15, 0.4);
  color: var(--paper);
  font-size: 15px;
  cursor: pointer;
  transition: border-color 0.25s, box-shadow 0.25s, transform 0.2s;
}
.icon-btn:hover {
  border-color: var(--gold);
  box-shadow: 0 0 14px rgba(216, 176, 106, 0.3);
  transform: translateY(-1px);
}

.who {
  display: flex;
  align-items: center;
  gap: 6px;
  max-width: 150px;
  padding: 6px 12px;
  font-size: 14px;
  letter-spacing: 1px;
  color: var(--paper);
  border: 1px solid rgba(216, 176, 106, 0.25);
  border-radius: 5px;
  background: rgba(216, 176, 106, 0.06);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.who .dot { font-style: normal; font-size: 13px; }

.ghost-btn,
.enter-btn {
  padding: 7px 18px;
  border-radius: 5px;
  font-family: inherit;
  font-size: 14px;
  letter-spacing: 3px;
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.3s, border-color 0.25s, color 0.25s;
}

.ghost-btn {
  border: 1px solid rgba(143, 179, 217, 0.3);
  background: transparent;
  color: rgba(232, 226, 212, 0.75);
}
.ghost-btn:hover {
  border-color: var(--cinnabar);
  color: #f0a49c;
  box-shadow: 0 0 14px rgba(194, 58, 58, 0.32);
}

.enter-btn {
  border: 1px solid rgba(216, 176, 106, 0.5);
  background: linear-gradient(160deg, #b03535 0%, var(--cinnabar) 48%, #8e2424 100%);
  color: #ffe9cf;
  box-shadow: 0 6px 18px rgba(194, 58, 58, 0.32);
}
.enter-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 26px rgba(194, 58, 58, 0.48);
}

@media (max-width: 860px) {
  .nav-inner { gap: 14px; padding: 0 14px; }
  .brand-text em { display: none; }
  .menu-item { padding: 8px 10px; letter-spacing: 2px; }
  .who { display: none; }
}

@media (max-width: 560px) {
  .brand-text { display: none; }
  .ghost-btn, .enter-btn { padding: 7px 12px; letter-spacing: 1px; }
}
</style>
