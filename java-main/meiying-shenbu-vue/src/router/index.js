import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import SeriesView from '../views/SeriesView.vue'
import DramaDetailView from '../views/DramaDetailView.vue'
import CaseDetailView from '../views/CaseDetailView.vue'
import CasesView from '../views/CasesView.vue'
import RankView from '../views/RankView.vue'
import AboutView from '../views/AboutView.vue'
import AdminLoginView from '../views/AdminLoginView.vue'
import AdminView from '../views/AdminView.vue'
import { isAdminLoggedIn } from '../store/admin'

/**
 * 路由表
 *
 * 前台：
 *   /             首页（导航栏 + 搜索栏 + 内容区）
 *   /series       剧集（全量列表 + 筛选 / 排序 / 分页）
 *   /drama/:id    剧集详情（卷宗）
 *   /cases        我的案卷（首页「加入案卷」收藏的剧集）
 *   /rank         悬案榜（完整榜单）
 *   /about        关于本站
 *   /login        登录 / 注册
 *
 * 后台（导航栏右侧「后台管理系统」按钮进来）：
 *   /admin/login  管理员登录
 *   /admin        后台控制台（需要管理员会话，否则弹回登录页）
 *
 * meta.nav 用来点亮导航栏对应的菜单项（见 SiteHeader.vue）。
 */
const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
    meta: { title: '魅影神捕 · 探案录', nav: 'home' }
  },
  {
    path: '/series',
    name: 'series',
    component: SeriesView,
    meta: { title: '魅影神捕 · 剧集', nav: 'series' }
  },
  {
    path: '/drama/:id',
    name: 'drama',
    component: DramaDetailView,
    props: true,
    meta: { title: '魅影神捕 · 卷宗', nav: 'series' }
  },
  {
    path: '/case/:id',
    name: 'case-detail',
    component: CaseDetailView,
    props: true,
    meta: { title: '魅影神捕 · 案卷', nav: 'home' }
  },
  {
    path: '/cases',
    name: 'cases',
    component: CasesView,
    meta: { title: '魅影神捕 · 我的案卷', nav: 'case' }
  },
  {
    path: '/rank',
    name: 'rank',
    component: RankView,
    meta: { title: '魅影神捕 · 悬案榜', nav: 'rank' }
  },
  {
    path: '/about',
    name: 'about',
    component: AboutView,
    meta: { title: '魅影神捕 · 关于', nav: 'about' }
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { title: '魅影神捕 · 验牌入城' }
  },
  {
    path: '/admin/login',
    name: 'admin-login',
    component: AdminLoginView,
    meta: { title: '魅影神捕 · 后台管理登录' }
  },
  {
    path: '/admin',
    name: 'admin',
    component: AdminView,
    meta: { title: '魅影神捕 · 后台管理', requiresAdmin: true }
  },
  // 未归档的地址一律回首页，避免刷新出白屏
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes,
  scrollBehavior: () => ({ top: 0 })
})

/**
 * 后台守卫
 *
 * 只防"手输地址直接进控制台"，不是真的权限校验 —— 会话存在 sessionStorage 里，
 * 懂前端的人改一下就能过。真正的鉴权得等后端 /api/admin/login。
 */
router.beforeEach((to) => {
  const logged = isAdminLoggedIn()

  if (to.meta?.requiresAdmin && !logged) {
    // 记下来路，登录后原路返回
    return { name: 'admin-login', query: { redirect: to.fullPath } }
  }
  if (to.name === 'admin-login' && logged) {
    return { name: 'admin' }
  }
  return true
})

router.afterEach((to) => {
  if (to.meta?.title) document.title = to.meta.title
})

export default router
