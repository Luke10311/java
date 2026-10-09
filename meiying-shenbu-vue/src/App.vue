<template>
  <BackgroundScene />

  <!-- 登录卡片 -->
  <div class="stage">
    <div class="card">
      <div class="corner tl"></div><div class="corner tr"></div>
      <div class="corner bl"></div><div class="corner br"></div>
      <div class="seal">神捕<br>之印</div>

      <h1 class="title">魅影神捕</h1>
      <p class="subtitle">夜巡百案 · 缉魅归真</p>

      <div class="tabs">
        <div
          class="tab"
          :class="{ active: activeTab === 'login' }"
          @click="activeTab = 'login'"
        >登 录</div>
        <div
          class="tab"
          :class="{ active: activeTab === 'register' }"
          @click="activeTab = 'register'"
        >注 册</div>
      </div>

      <LoginForm
        v-if="activeTab === 'login'"
        :key="loginKey"
        :prefill-user="prefillUser"
        @toast="showToast"
      />
      <RegisterForm
        v-else
        @toast="showToast"
        @registered="onRegistered"
      />

      <p class="foot">本府重地<span class="divider">·</span>魅影勿近<span class="divider">·</span>© 魅影神捕探案录</p>
    </div>
  </div>

  <div class="toast" :class="{ show: toastShow }">{{ toastMsg }}</div>
</template>

<script setup>
import { ref } from 'vue'
import BackgroundScene from './components/BackgroundScene.vue'
import LoginForm from './components/LoginForm.vue'
import RegisterForm from './components/RegisterForm.vue'

const activeTab = ref('login')
const prefillUser = ref('')
const loginKey = ref(0)

// toast 提示
const toastMsg = ref('')
const toastShow = ref(false)
let toastTimer = null

function showToast(msg) {
  toastMsg.value = msg
  toastShow.value = true
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastShow.value = false }, 2600)
}

// 注册成功后切回登录，并带入用户名
function onRegistered(user) {
  prefillUser.value = user
  loginKey.value++          // 强制登录表单重新挂载，以回填名号
  activeTab.value = 'login'
}
</script>

<style scoped>
.stage {
  position: relative;
  z-index: 2;
  min-height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px 16px;
}

.card {
  width: 400px;
  max-width: 100%;
  background: linear-gradient(165deg, rgba(18, 26, 43, 0.92), rgba(10, 14, 24, 0.95));
  border: 1px solid rgba(216, 176, 106, 0.28);
  border-radius: 10px;
  box-shadow: 0 24px 70px rgba(0, 0, 0, 0.65), inset 0 1px 0 rgba(216, 176, 106, 0.14);
  padding: 44px 40px 40px;
  position: relative;
  animation: cardIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes cardIn {
  from { opacity: 0; transform: translateY(28px) scale(0.97); }
  to { opacity: 1; transform: none; }
}

/* 卡片四角描纹 */
.corner {
  position: absolute;
  width: 26px;
  height: 26px;
  border-color: var(--gold);
  border-style: solid;
  opacity: 0.75;
}
.corner.tl { top: 10px; left: 10px; border-width: 2px 0 0 2px; }
.corner.tr { top: 10px; right: 10px; border-width: 2px 2px 0 0; }
.corner.bl { bottom: 10px; left: 10px; border-width: 0 0 2px 2px; }
.corner.br { bottom: 10px; right: 10px; border-width: 0 2px 2px 0; }

/* 朱砂印章 */
.seal {
  position: absolute;
  top: -26px;
  right: 26px;
  width: 58px;
  height: 58px;
  background: radial-gradient(circle at 35% 30%, #d94a42, var(--cinnabar) 60%, #8e2222);
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  line-height: 1.05;
  color: #ffe6cf;
  text-align: center;
  box-shadow: 0 8px 22px rgba(194, 58, 58, 0.45), inset 0 0 10px rgba(0,0,0,0.35);
  transform: rotate(8deg);
  letter-spacing: 2px;
  padding: 4px;
}

.title {
  text-align: center;
  font-size: 34px;
  letter-spacing: 10px;
  text-indent: 10px;
  color: var(--paper);
  text-shadow: 0 0 18px rgba(143, 179, 217, 0.45);
  margin-bottom: 6px;
}

.subtitle {
  text-align: center;
  font-size: 13px;
  letter-spacing: 6px;
  text-indent: 6px;
  color: var(--gold);
  opacity: 0.9;
  margin-bottom: 30px;
}
.subtitle::before, .subtitle::after {
  content: "———";
  color: rgba(216, 176, 106, 0.4);
  margin: 0 10px;
  letter-spacing: 0;
}

/* 表单切换 */
.tabs {
  display: flex;
  border-bottom: 1px solid rgba(216, 176, 106, 0.25);
  margin-bottom: 28px;
}
.tab {
  flex: 1;
  text-align: center;
  padding: 10px 0;
  font-size: 17px;
  letter-spacing: 4px;
  color: rgba(232, 226, 212, 0.55);
  cursor: pointer;
  position: relative;
  transition: color 0.3s;
  user-select: none;
}
.tab.active { color: var(--gold); text-shadow: 0 0 10px rgba(216, 176, 106, 0.5); }
.tab.active::after {
  content: "";
  position: absolute;
  left: 25%;
  right: 25%;
  bottom: -1px;
  height: 2px;
  background: linear-gradient(90deg, transparent, var(--gold), transparent);
}

/* 底部签 */
.foot {
  margin-top: 26px;
  text-align: center;
  font-size: 12px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.45);
}
.foot .divider { margin: 0 8px; color: rgba(216, 176, 106, 0.35); }

/* toast */
.toast {
  position: fixed;
  top: 34px;
  left: 50%;
  transform: translate(-50%, -140%);
  z-index: 50;
  padding: 12px 30px;
  background: rgba(12, 17, 28, 0.95);
  border: 1px solid var(--gold);
  border-radius: 6px;
  color: var(--paper);
  font-size: 14px;
  letter-spacing: 2px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.45s;
  opacity: 0;
  pointer-events: none;
}
.toast.show { transform: translate(-50%, 0); opacity: 1; }

@media (max-width: 480px) {
  .card { padding: 34px 22px 30px; }
  .title { font-size: 27px; letter-spacing: 7px; }
}
</style>
