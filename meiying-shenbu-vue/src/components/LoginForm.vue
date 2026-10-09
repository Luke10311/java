<template>
  <!-- 登录表单 -->
  <form class="form active" novalidate @submit.prevent="onSubmit">
    <div class="field" :class="{ error: errors.user }">
      <label>捕快名号</label>
      <input
        v-model.trim="user"
        type="text"
        placeholder="请输入用户名"
        autocomplete="username"
        @input="errors.user = false; badCred = false"
      >
      <span class="icon">🏮</span>
      <p class="err-msg">名号不可为空，捕头如何点将？</p>
    </div>
    <div class="field has-toggle" :class="{ error: errors.pwd }">
      <label>通行令牌</label>
      <input
        v-model="pwd"
        :type="showPwd ? 'text' : 'password'"
        placeholder="请输入密码"
        autocomplete="current-password"
        @input="errors.pwd = false; errors.user = false; badCred = false"
      >
      <span class="toggle-eye" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁' }}</span>
      <p class="err-msg" v-if="badCred">名号或令牌有误，魅影惑人，请再核对。</p>
      <p class="err-msg" v-else>令牌不可为空，无凭不得入内。</p>
    </div>
    <div class="aux-row">
      <label><input v-model="remember" type="checkbox">记住名号</label>
      <a href="javascript:;" @click="emit('toast', '线索已飞鸽传书，静候佳音')">忘记令牌？</a>
    </div>
    <button type="submit" class="btn">入 城 缉 案</button>
  </form>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { verifyLogin } from '../store/users'

const props = defineProps({
  prefillUser: { type: String, default: '' }
})
const emit = defineEmits(['toast'])

const user = ref('')
const pwd = ref('')
const showPwd = ref(false)
const remember = ref(false)
const badCred = ref(false)
const errors = reactive({ user: false, pwd: false })

// 挂载时回填：注册后带入的名号优先，其次读取 localStorage 记住的名号
onMounted(() => {
  const saved = props.prefillUser || localStorage.getItem('myss_user')
  if (saved) {
    user.value = saved
    remember.value = true
  }
})

function onSubmit() {
  badCred.value = false
  errors.user = !user.value
  errors.pwd = !pwd.value
  if (errors.user || errors.pwd) return

  // 真实校验：比对本地用户库
  const result = verifyLogin(user.value, pwd.value)
  if (!result.ok) {
    badCred.value = true
    errors.pwd = true
    errors.user = true
    return
  }

  if (remember.value) {
    localStorage.setItem('myss_user', user.value)
  } else {
    localStorage.removeItem('myss_user')
  }
  emit('toast', `令牌验讫，「${user.value}」大人，开城门！`)
}
</script>

<style scoped>
.form.active { display: block; animation: formIn 0.45s ease both; }
@keyframes formIn {
  from { opacity: 0; transform: translateX(14px); }
  to { opacity: 1; transform: none; }
}

.field {
  margin-bottom: 22px;
  position: relative;
}
.field label {
  display: block;
  font-size: 13px;
  letter-spacing: 3px;
  color: rgba(143, 179, 217, 0.85);
  margin-bottom: 8px;
}
.field input {
  width: 100%;
  padding: 12px 42px 12px 14px;
  font-size: 15px;
  font-family: inherit;
  letter-spacing: 1px;
  color: var(--paper);
  background: rgba(7, 9, 15, 0.55);
  border: 1px solid rgba(143, 179, 217, 0.22);
  border-radius: 5px;
  outline: none;
  transition: border-color 0.3s, box-shadow 0.3s;
  caret-color: var(--gold);
}
.field input::placeholder { color: rgba(232, 226, 212, 0.28); }
.field input:focus {
  border-color: var(--gold);
  box-shadow: 0 0 0 3px rgba(216, 176, 106, 0.12), 0 0 16px rgba(216, 176, 106, 0.15) inset;
}
.field .icon {
  position: absolute;
  right: 13px;
  bottom: 11px;
  font-size: 17px;
  opacity: 0.55;
  pointer-events: none;
}
.field.error input {
  border-color: var(--cinnabar);
  box-shadow: 0 0 12px rgba(194, 58, 58, 0.25);
}
.field .err-msg {
  display: none;
  font-size: 12px;
  color: #e8756d;
  letter-spacing: 1px;
  margin-top: 6px;
}
.field.error .err-msg { display: block; }

.toggle-eye {
  position: absolute;
  right: 12px;
  bottom: 8px;
  cursor: pointer;
  font-size: 16px;
  opacity: 0.55;
  user-select: none;
  transition: opacity 0.2s;
}
.toggle-eye:hover { opacity: 1; }
.field.has-toggle input { padding-right: 40px; }

.aux-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 13px;
  margin-bottom: 26px;
  color: rgba(232, 226, 212, 0.55);
}
.aux-row label {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  letter-spacing: 1px;
}
.aux-row input[type="checkbox"] {
  appearance: none;
  width: 15px;
  height: 15px;
  border: 1px solid var(--gold);
  border-radius: 3px;
  cursor: pointer;
  position: relative;
}
.aux-row input[type="checkbox"]:checked::after {
  content: "✓";
  position: absolute;
  inset: 0;
  text-align: center;
  line-height: 14px;
  font-size: 11px;
  color: var(--gold);
}
.aux-row a {
  color: var(--mist);
  text-decoration: none;
  letter-spacing: 1px;
  transition: color 0.2s, text-shadow 0.2s;
}
.aux-row a:hover { color: var(--gold); text-shadow: 0 0 8px rgba(216, 176, 106, 0.6); }

.btn {
  width: 100%;
  padding: 14px 0;
  font-family: inherit;
  font-size: 17px;
  letter-spacing: 8px;
  text-indent: 8px;
  color: #ffe9cf;
  background: linear-gradient(160deg, #b03535 0%, var(--cinnabar) 45%, #8e2424 100%);
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: transform 0.15s, box-shadow 0.3s;
  box-shadow: 0 8px 24px rgba(194, 58, 58, 0.35);
}
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 12px 32px rgba(194, 58, 58, 0.5);
}
.btn:active { transform: translateY(0); }
.btn::before {
  content: "";
  position: absolute;
  top: 0;
  left: -80%;
  width: 50%;
  height: 100%;
  background: linear-gradient(105deg, transparent, rgba(255, 235, 205, 0.25), transparent);
  transform: skewX(-20deg);
  animation: bladeShine 3.6s ease-in-out infinite;
}
@keyframes bladeShine {
  0%, 60% { left: -80%; }
  100% { left: 160%; }
}
</style>
