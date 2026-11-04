<template>
  <PageShell
    title="探案会员中心"
    desc="验牌入城者即为探案会员 —— 案件结卷之前，可在此提前打探神捕司内部的调查进程。"
    crumb="探案会员中心"
  >
    <!-- 会员名牌 -->
    <section class="member-card" :class="{ guest: !isMember }">
      <template v-if="isMember">
        <div class="seal" aria-hidden="true">{{ shell.user.slice(0, 1) }}</div>
        <div class="id-info">
          <p class="hello">{{ shell.user }} 大人，久候了。</p>
          <p class="lv">
            会员职级：<strong>{{ memberLevel }}</strong>
            <span class="lv-note">（职级随名号笔画而异，纯属探案录的一番雅趣）</span>
          </p>
          <ul class="rights">
            <li>· 案件结卷前，提前打探调查进程</li>
            <li>· 查阅神捕司内部线报（带日期批注）</li>
            <li>· 线报更新优先推送，卷宗直通</li>
          </ul>
        </div>
      </template>
      <template v-else>
        <div class="seal guest-seal" aria-hidden="true">?</div>
        <div class="id-info">
          <p class="hello">客官还未验牌入城。</p>
          <p class="lv">探案会员 = 已登录的名号。验牌之后，方可提前打探以下案件的调查进程。</p>
          <button class="join-btn" type="button" @click="router.push('/login')">前往验牌入城</button>
        </div>
      </template>
    </section>

    <!-- 案件调查进程列表 -->
    <h2 class="sec-title">在办案件 · 调查进程</h2>
    <div class="intel-list">
      <article
        v-for="item in intelList"
        :key="item.id"
        class="intel-card"
        :class="{ locked: !isMember }"
      >
        <div class="pic" @click="goCase(item)">
          <img :src="item.image" :alt="item.title + ' 插图'" loading="lazy">
          <span class="veil" aria-hidden="true"></span>
        </div>

        <div class="body">
          <header class="line-1">
            <h3 class="name" @click="goCase(item)">{{ item.title }}</h3>
            <span class="lv-tag" :data-lv="item.intel.level">{{ item.intel.level }}</span>
            <span class="status">{{ item.status }}</span>
          </header>

          <div class="bar-row">
            <div class="bar"><i :style="{ width: (isMember ? item.intel.progress : 0) + '%' }"></i></div>
            <span class="pct">{{ isMember ? '缉查进度 ' + item.intel.progress + '%' : '进度待验牌' }}</span>
          </div>

          <p class="latest">最新线报：{{ isMember ? item.intel.updates[item.intel.updates.length - 1].e : '「会员专属 · 验牌后可见」' }}</p>

          <ul v-if="isMember" class="updates">
            <li v-for="(u, i) in item.intel.updates" :key="i">
              <span class="u-t">{{ u.t }}</span>
              <span class="u-e">{{ u.e }}</span>
            </li>
          </ul>

          <button class="open-btn" type="button" @click="goCase(item)">
            {{ isMember ? '翻阅完整卷宗 ›' : '先去验牌 ›' }}
          </button>
        </div>

        <!-- 未登录：整卡蒙层，点哪儿都劝你先验牌 -->
        <button v-if="!isMember" class="lock" type="button" @click="router.push('/login')">
          <span class="lock-icon">🔒</span>
          <span class="lock-text">会员专属 · 验牌可见</span>
        </button>
      </article>
    </div>
  </PageShell>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import PageShell from '../components/common/PageShell.vue'
import { CASES } from '../data/cases'
import { CASE_INTEL } from '../data/caseIntel'
import { shell, showToast } from '../store/shell'

const router = useRouter()

/** 探案会员 = 已验牌入城的登录用户 */
const isMember = computed(() => !!shell.user)

/** 有线报的案件，按数组顺序（新案在前） */
const intelList = CASES.filter((c) => CASE_INTEL[c.id]).map((c) => ({ ...c, intel: CASE_INTEL[c.id] }))

/** 会员职级：拿名号做个稳定的哈希，映射到三档雅称 */
const memberLevel = computed(() => {
  const name = shell.user || ''
  let h = 0
  for (const ch of name) h = (h * 31 + ch.codePointAt(0)) % 997
  return ['夜巡生', '缉影手', '神捕'][h % 3]
})

function goCase(item) {
  if (!isMember.value) {
    showToast('探案会员专属 —— 请先验牌入城。')
    router.push('/login')
    return
  }
  router.push(`/case/${item.id}`)
}
</script>

<style scoped>
/* ── 会员名牌 ── */
.member-card {
  display: flex;
  gap: 22px;
  align-items: flex-start;
  padding: 24px 28px;
  margin-bottom: 30px;
  border: 1px solid rgba(216, 176, 106, 0.32);
  border-radius: 10px;
  background:
    radial-gradient(120% 160% at 85% 0%, rgba(216, 176, 106, 0.12), transparent 55%),
    rgba(9, 12, 20, 0.72);
  box-shadow: 0 12px 34px rgba(0, 0, 0, 0.4);
}
.member-card.guest { border-color: rgba(143, 179, 217, 0.22); }

.seal {
  width: 62px;
  height: 62px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: #ffe6cf;
  border-radius: 8px;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 62%, #8e2222);
  box-shadow: 0 6px 18px rgba(194, 58, 58, 0.42), inset 0 0 8px rgba(0, 0, 0, 0.35);
  transform: rotate(-6deg);
}
.guest-seal { background: rgba(16, 26, 40, 0.9); border: 1px dashed rgba(143, 179, 217, 0.4); color: rgba(143, 179, 217, 0.6); }

.id-info { min-width: 0; }
.hello { margin: 2px 0 6px; font-size: 18px; letter-spacing: 2px; color: var(--paper); }
.lv { margin: 0 0 8px; font-size: 13.5px; letter-spacing: 1px; color: rgba(216, 176, 106, 0.85); }
.lv strong { font-size: 15px; color: var(--gold); }
.lv-note { margin-left: 8px; color: rgba(143, 179, 217, 0.45); font-size: 12px; }
.rights {
  margin: 0;
  padding: 0;
  list-style: none;
  font-size: 13px;
  letter-spacing: 1px;
  line-height: 1.9;
  color: rgba(232, 226, 212, 0.62);
}

.join-btn {
  margin-top: 6px;
  padding: 8px 22px;
  font-family: inherit;
  font-size: 14px;
  letter-spacing: 3px;
  color: #ffe9cf;
  border: 1px solid rgba(216, 176, 106, 0.5);
  border-radius: 5px;
  background: linear-gradient(160deg, #b03535 0%, var(--cinnabar) 48%, #8e2424 100%);
  box-shadow: 0 6px 18px rgba(194, 58, 58, 0.32);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.3s;
}
.join-btn:hover { transform: translateY(-1px); box-shadow: 0 10px 26px rgba(194, 58, 58, 0.48); }

/* ── 进程列表 ── */
.sec-title {
  margin: 0 0 16px;
  font-size: 17px;
  font-weight: 400;
  letter-spacing: 4px;
  color: rgba(216, 176, 106, 0.9);
}

.intel-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.intel-card {
  position: relative;
  display: flex;
  gap: 20px;
  padding: 18px 22px;
  border: 1px solid rgba(216, 176, 106, 0.16);
  border-radius: 10px;
  background: rgba(9, 12, 20, 0.55);
  transition: border-color 0.25s, background 0.25s;
}
.intel-card:hover { border-color: rgba(216, 176, 106, 0.4); background: rgba(12, 16, 26, 0.75); }

.pic {
  width: 120px;
  height: 152px;
  flex-shrink: 0;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  border: 1px solid rgba(216, 176, 106, 0.18);
}
.pic img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
.intel-card:hover .pic img { transform: scale(1.06); }
.veil { position: absolute; inset: 0; background: linear-gradient(180deg, transparent 55%, rgba(7, 9, 15, 0.55)); pointer-events: none; }

.body { flex: 1; min-width: 0; position: relative; }
.line-1 { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
.name {
  margin: 0;
  font-size: 17px;
  font-weight: 400;
  letter-spacing: 2px;
  color: var(--paper);
  cursor: pointer;
  transition: color 0.25s;
}
.name:hover { color: var(--gold); }

.lv-tag {
  padding: 2px 10px;
  font-size: 11.5px;
  letter-spacing: 2px;
  border-radius: 3px;
  border: 1px solid rgba(194, 58, 58, 0.5);
  color: #f0a49c;
}
.lv-tag[data-lv='封卷'] { border-color: rgba(143, 179, 217, 0.4); color: rgba(200, 220, 242, 0.8); }
.lv-tag[data-lv='内档'], .lv-tag[data-lv='钦档'] { border-color: rgba(216, 176, 106, 0.5); color: var(--gold); }

.status { margin-left: auto; font-size: 12.5px; letter-spacing: 2px; color: rgba(143, 179, 217, 0.7); }

.bar-row { display: flex; align-items: center; gap: 14px; margin-bottom: 10px; }
.bar {
  flex: 1;
  height: 6px;
  border-radius: 3px;
  background: rgba(143, 179, 217, 0.14);
  overflow: hidden;
}
.bar i {
  display: block;
  height: 100%;
  border-radius: 3px;
  background: linear-gradient(90deg, #8e2424, var(--cinnabar), var(--gold));
  box-shadow: 0 0 10px rgba(194, 58, 58, 0.5);
  transition: width 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}
.pct { flex-shrink: 0; font-size: 12.5px; letter-spacing: 1px; color: rgba(216, 176, 106, 0.85); }

.latest { margin: 0 0 10px; font-size: 13.5px; letter-spacing: 1px; color: rgba(232, 226, 212, 0.78); }

.updates {
  margin: 0 0 12px;
  padding: 10px 14px;
  list-style: none;
  border-left: 2px solid rgba(216, 176, 106, 0.35);
  background: rgba(216, 176, 106, 0.05);
  font-size: 12.5px;
  letter-spacing: 1px;
  line-height: 2;
  color: rgba(232, 226, 212, 0.66);
}
.u-t { display: inline-block; min-width: 72px; color: rgba(216, 176, 106, 0.8); }

.open-btn {
  padding: 6px 16px;
  font-family: inherit;
  font-size: 12.5px;
  letter-spacing: 2px;
  color: rgba(216, 176, 106, 0.9);
  background: transparent;
  border: 1px solid rgba(216, 176, 106, 0.35);
  border-radius: 4px;
  cursor: pointer;
  transition: color 0.25s, border-color 0.25s, background 0.25s;
}
.open-btn:hover { color: var(--gold); border-color: var(--gold); background: rgba(216, 176, 106, 0.08); }

/* ── 未登录锁定蒙层 ── */
.intel-card.locked .body { filter: blur(4px); user-select: none; pointer-events: none; }
.lock {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  border: 0;
  border-radius: 10px;
  background: rgba(7, 9, 15, 0.35);
  color: rgba(232, 226, 212, 0.85);
  font-family: inherit;
  letter-spacing: 2px;
  cursor: pointer;
  transition: background 0.25s;
}
.lock:hover { background: rgba(7, 9, 15, 0.15); }
.lock-icon { font-size: 22px; }
.lock-text { font-size: 13px; }

@media (max-width: 640px) {
  .intel-card { flex-direction: column; }
  .pic { width: 100%; height: 150px; }
  .intel-card.locked .body { filter: none; }
}
</style>
