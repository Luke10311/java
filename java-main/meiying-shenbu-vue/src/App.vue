<template>
  <!-- 应用外壳：只负责路由出口和全局提示条 -->
  <router-view />

  <div class="toast" :class="{ show: shell.toastShow }">{{ shell.toastMsg }}</div>
</template>

<script setup>
import { onMounted } from 'vue'
import { restoreSession, shell, showToast } from './store/shell'

// 打开/刷新页面时，用已存的 token 向后端换回登录态
onMounted(async () => {
  const name = await restoreSession()
  if (name) showToast(`「${name}」大人，令牌仍有效。`)
})
</script>

<style scoped>
.toast {
  position: fixed;
  top: 34px;
  left: 50%;
  transform: translate(-50%, -140%);
  z-index: 90;
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
</style>
