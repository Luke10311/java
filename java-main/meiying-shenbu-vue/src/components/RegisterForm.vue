<template>
  <!-- 注册表单 -->
  <form class="form active" novalidate @submit.prevent="onSubmit">
    <div class="field" :class="{ error: errors.user }">
      <label>捕快名号</label>
      <input
        v-model.trim="user"
        type="text"
        placeholder="2-16位用户名"
        autocomplete="off"
        @input="errors.user = false; userMsg = ''"
      >
      <span class="icon">🏮</span>
      <p class="err-msg" v-if="userMsg">{{ userMsg }}</p>
      <p class="err-msg" v-else>名号须为 2-16 位字符。</p>
    </div>
    <div class="field has-toggle" :class="{ error: errors.pwd }">
      <label>设定令牌</label>
      <input
        v-model="pwd"
        :type="showPwd ? 'text' : 'password'"
        placeholder="至少6位密码"
        autocomplete="new-password"
        @input="errors.pwd = false"
      >
      <span class="toggle-eye" @click="showPwd = !showPwd">{{ showPwd ? '🙈' : '👁' }}</span>
      <p class="err-msg">令牌至少需 6 位，慎防魅影窃听。</p>
    </div>
    <div class="field has-toggle" :class="{ error: errors.pwd2 }">
      <label>复核令牌</label>
      <input
        v-model="pwd2"
        :type="showPwd2 ? 'text' : 'password'"
        placeholder="再次输入密码"
        autocomplete="new-password"
        @input="errors.pwd2 = false"
      >
      <span class="toggle-eye" @click="showPwd2 = !showPwd2">{{ showPwd2 ? '🙈' : '👁' }}</span>
      <p class="err-msg">两次令牌不符，请复核。</p>
    </div>
    <button type="submit" class="btn" :disabled="loading">{{ loading ? '正 在 入 籍' : '领 牌 入 籍' }}</button>
  </form>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { registerUser } from '../store/users'

const emit = defineEmits(['toast', 'registered'])

const user = ref('')
const pwd = ref('')
const pwd2 = ref('')
const showPwd = ref(false)
const showPwd2 = ref(false)
const userMsg = ref('')
const loading = ref(false)
const errors = reactive({ user: false, pwd: false, pwd2: false })

async function onSubmit() {
  if (loading.value) return
  userMsg.value = ''
  errors.user = !(user.value.length >= 2 && user.value.length <= 16)
  errors.pwd = pwd.value.length < 6
  errors.pwd2 = !pwd2.value || pwd.value !== pwd2.value
  if (errors.user || errors.pwd || errors.pwd2) return

  // 真实注册：交给后端 /api/user/register，重名由数据库唯一约束判定
  loading.value = true
  let result
  try {
    result = await registerUser(user.value, pwd.value)
  } finally {
    loading.value = false
  }

  if (!result.ok) {
    userMsg.value = result.msg || '入籍失败，请稍后再试。'
    errors.user = true
    return
  }

  emit('toast', `入籍成功！「${user.value}」大人，请持牌登城。`)
  setTimeout(() => {
    emit('registered', user.value)
  }, 1400)
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
.btn:disabled { opacity: 0.72; cursor: not-allowed; transform: none; }
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
