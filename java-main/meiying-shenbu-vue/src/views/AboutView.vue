<template>
  <PageShell
    title="关于"
    desc="魅影神捕是一处线上的探案录：把散落的案卷归拢，按题材、年份、热度摆上架子，谁都能翻。"
    crumb="关于"
  >
    <div class="quote">
      <p class="q-text">「夜巡百案 · 缉魅归真」</p>
      <p class="q-sub">上元灯市三十七盏花灯尽灭的那夜起，这座城就没有真正安静过。</p>
    </div>

    <!-- 站点结构 -->
    <section class="block">
      <h3 class="sec-title">这里有什么</h3>
      <div class="cards">
        <article v-for="c in FEATURES" :key="c.title" class="card" @click="go(c.path)">
          <span class="c-glyph">{{ c.glyph }}</span>
          <h4 class="c-title">{{ c.title }}</h4>
          <p class="c-desc">{{ c.desc }}</p>
          <span class="c-go">{{ c.action }} ›</span>
        </article>
      </div>
    </section>

    <!-- 技术底子 -->
    <section class="block">
      <h3 class="sec-title">底下是什么</h3>
      <ul class="stack">
        <li v-for="s in STACK" :key="s.name">
          <span class="s-name">{{ s.name }}</span>
          <span class="s-desc">{{ s.desc }}</span>
        </li>
      </ul>
    </section>

    <!-- 说明 -->
    <section class="block">
      <h3 class="sec-title">几句实话</h3>
      <ul class="notes">
        <li>页面上的剧集、评分、热度、演职人员都是演示数据，不是真实影视作品。</li>
        <li>登录 / 注册走真实后端：Spring Boot + MyBatis-Plus + JWT，账号存在 MySQL 里。</li>
        <li>「加入案卷」的收藏只存在本机浏览器（localStorage），换设备带不走。</li>
        <li>剧集、榜单接口（<code>/api/drama/**</code>）后端还没开，接了以后前端只改 <code>src/api/home.js</code> 一层。</li>
      </ul>
    </section>

    <div class="actions">
      <button class="btn-main" type="button" @click="router.push('/series')">去翻剧集</button>
      <button class="btn-ghost" type="button" @click="router.push('/rank')">看悬案榜</button>
      <button class="btn-ghost" type="button" @click="router.push('/login')">验牌入城</button>
    </div>
  </PageShell>
</template>

<script setup>
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'

const router = useRouter()

const FEATURES = [
  {
    glyph: '卷',
    title: '剧集',
    desc: '十八卷案宗，按题材、年份、评分、热度筛选，翻页查档。',
    action: '去剧集页',
    path: '/series'
  },
  {
    glyph: '案',
    title: '我的案卷',
    desc: '看得上眼的先收着。加入案卷的剧集在这里统一管理，随时取出。',
    action: '打开案卷',
    path: '/cases'
  },
  {
    glyph: '榜',
    title: '悬案榜',
    desc: '按全城缉查热度排定前十，带趋势，点进去就是卷宗详情。',
    action: '看榜单',
    path: '/rank'
  }
]

const STACK = [
  { name: '前端', desc: 'Vue 3 + Vite + vue-router，路由分前台（首页 / 剧集 / 卷宗 / 案卷 / 悬案榜）与后台。' },
  { name: '后端', desc: 'Spring Boot 3.4.5 + MyBatis-Plus，JWT 令牌鉴权，/api/user/** 已通。' },
  { name: '数据库', desc: 'MySQL 8，库名 meiying_shenbu，启动脚本会自动建库并导入示例数据。' },
  { name: '启动', desc: '双击项目根目录的 start.bat，前后端一起起；stop.bat 收工。' }
]

function go(path) {
  if (path) router.push(path)
}
</script>

<style scoped>
.quote {
  padding: 26px 28px;
  border-left: 3px solid rgba(216, 176, 106, 0.5);
  background: linear-gradient(90deg, rgba(216, 176, 106, 0.07), transparent 70%);
}
.q-text {
  font-size: 21px;
  letter-spacing: 5px;
  color: var(--gold);
  text-shadow: 0 0 18px rgba(216, 176, 106, 0.25);
}
.q-sub {
  margin-top: 10px;
  font-size: 13px;
  line-height: 2;
  letter-spacing: 2px;
  color: rgba(232, 226, 212, 0.55);
}

.block { margin-top: 46px; }
.sec-title {
  font-size: 19px;
  font-weight: 400;
  letter-spacing: 5px;
  color: var(--paper);
  margin-bottom: 20px;
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

/* 三块入口 */
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 18px;
}
.card {
  padding: 22px;
  border: 1px solid rgba(216, 176, 106, 0.18);
  border-radius: 9px;
  background: linear-gradient(160deg, rgba(18, 26, 43, 0.6), rgba(9, 12, 20, 0.8));
  cursor: pointer;
  transition: transform 0.3s, border-color 0.3s, box-shadow 0.3s;
}
.card:hover {
  transform: translateY(-3px);
  border-color: rgba(216, 176, 106, 0.5);
  box-shadow: 0 16px 38px rgba(0, 0, 0, 0.5), 0 0 22px rgba(216, 176, 106, 0.12);
}
.c-glyph {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 34px;
  height: 34px;
  margin-bottom: 14px;
  font-size: 17px;
  color: #ffe6cf;
  border-radius: 5px;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 62%, #8e2222);
  transform: rotate(-5deg);
}
.c-title { font-size: 17px; font-weight: 400; letter-spacing: 3px; color: var(--paper); }
.c-desc {
  margin-top: 10px;
  font-size: 13px;
  line-height: 1.95;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.6);
}
.c-go {
  display: inline-block;
  margin-top: 14px;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(143, 179, 217, 0.7);
  transition: color 0.25s;
}
.card:hover .c-go { color: var(--gold); }

/* 技术栈 */
.stack { list-style: none; display: grid; gap: 10px; }
.stack li {
  display: flex;
  gap: 16px;
  padding: 13px 18px;
  border: 1px solid rgba(143, 179, 217, 0.14);
  border-radius: 7px;
  background: rgba(9, 12, 20, 0.5);
}
.s-name {
  flex-shrink: 0;
  width: 52px;
  font-size: 13px;
  letter-spacing: 2px;
  color: var(--gold);
}
.s-desc {
  font-size: 13px;
  line-height: 1.9;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.62);
}

/* 说明 */
.notes { list-style: none; display: grid; gap: 10px; }
.notes li {
  position: relative;
  padding-left: 18px;
  font-size: 13px;
  line-height: 2;
  letter-spacing: 1px;
  color: rgba(232, 226, 212, 0.6);
}
.notes li::before {
  content: "·";
  position: absolute;
  left: 4px;
  color: var(--cinnabar);
}
.notes code {
  padding: 1px 6px;
  font-family: Consolas, Monaco, monospace;
  font-size: 12px;
  color: var(--gold);
  background: rgba(216, 176, 106, 0.1);
  border-radius: 3px;
}

/* 底部按钮 */
.actions { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 46px; }
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
</style>
