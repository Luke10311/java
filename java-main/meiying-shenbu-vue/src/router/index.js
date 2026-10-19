import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'

/**
 * 路由表
 *
 * 目前只有两个真实页面：
 *   /       首页（导航栏 + 搜索栏 + 内容区）
 *   /login  登录 / 注册
 *
 * 剧集、案卷详情、悬案榜等页面尚未开工，等做到时在这里追加即可，
 * 导航栏里对应的菜单项目前只弹提示，不做跳转。
 */
const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
    meta: { title: '魅影神捕 · 探案录' }
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { title: '魅影神捕 · 验牌入城' }
  },
  // 未开工的地址一律回首页，避免刷新出白屏
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})

router.afterEach((to) => {
  if (to.meta?.title) document.title = to.meta.title
})

export default router
