<template>
  <!-- 搜索栏：范围 + 关键词 + 缉查 -->
  <form class="search" :class="{ pulse }" novalidate @submit.prevent="submit">
    <!-- 搜索范围 -->
    <div class="scope">
      <select v-model="scope" aria-label="搜索范围">
        <option v-for="s in SCOPES" :key="s.value" :value="s.value">{{ s.label }}</option>
      </select>
      <span class="caret">▾</span>
    </div>

    <!-- 关键词 -->
    <div class="field">
      <span class="icon">🔍</span>
      <input
        ref="inputEl"
        v-model.trim="keyword"
        type="search"
        :placeholder="placeholder"
        autocomplete="off"
        @focus="pulse = false"
      >
      <button v-if="keyword" class="clear" type="button" title="清空" @click="clear">✕</button>
    </div>

    <button class="submit" type="submit">缉 查</button>
  </form>
</template>

<script setup>
import { computed, ref } from 'vue'
import { SCOPES } from '../../data/dramas'

const emit = defineEmits(['search'])

const scope = ref('all')
const keyword = ref('')
const pulse = ref(false)
const inputEl = ref(null)

// 占位文案跟着范围走，让人一眼知道搜的是什么
const placeholder = computed(() => {
  const map = {
    all: '搜索剧名、捕快、案卷…',
    series: '搜索剧集名，如「长安夜行录」',
    movie: '搜索影录名',
    role: '搜索捕快名号',
    case: '搜索案卷关键词'
  }
  return map[scope.value] || map.all
})

function submit() {
  emit('search', { keyword: keyword.value, scope: scope.value })
}

function clear() {
  keyword.value = ''
  inputEl.value?.focus()
}

/** 供导航栏的搜索按钮调用：滚回搜索栏并聚焦 */
function focus() {
  inputEl.value?.focus()
  pulse.value = true
  setTimeout(() => { pulse.value = false }, 1200)
}

defineExpose({ focus })
</script>

<style scoped>
.search {
  display: flex;
  align-items: stretch;
  width: 100%;
  max-width: 680px;
  margin: 0 auto;
  padding: 6px;
  background: linear-gradient(165deg, rgba(18, 26, 43, 0.92), rgba(10, 14, 24, 0.94));
  border: 1px solid rgba(216, 176, 106, 0.3);
  border-radius: 9px;
  box-shadow: 0 18px 46px rgba(0, 0, 0, 0.5), inset 0 1px 0 rgba(216, 176, 106, 0.12);
  transition: border-color 0.3s, box-shadow 0.3s;
}
.search:focus-within {
  border-color: rgba(216, 176, 106, 0.7);
  box-shadow: 0 18px 46px rgba(0, 0, 0, 0.5), 0 0 24px rgba(216, 176, 106, 0.22);
}
.search.pulse { animation: searchPulse 1.2s ease; }
@keyframes searchPulse {
  0%, 100% { box-shadow: 0 18px 46px rgba(0, 0, 0, 0.5); }
  30% { box-shadow: 0 18px 46px rgba(0, 0, 0, 0.5), 0 0 0 6px rgba(216, 176, 106, 0.16); }
}

/* 范围下拉 */
.scope {
  position: relative;
  display: flex;
  align-items: center;
  padding-left: 6px;
  border-right: 1px solid rgba(216, 176, 106, 0.18);
}
.scope select {
  appearance: none;
  -webkit-appearance: none;
  border: 0;
  background: transparent;
  color: var(--gold);
  font-family: inherit;
  font-size: 14px;
  letter-spacing: 2px;
  padding: 10px 26px 10px 12px;
  cursor: pointer;
  outline: none;
}
.scope select option { background: #0c111c; color: var(--paper); }
.scope .caret {
  position: absolute;
  right: 10px;
  font-size: 11px;
  color: rgba(216, 176, 106, 0.7);
  pointer-events: none;
}

/* 关键词 */
.field {
  position: relative;
  flex: 1;
  min-width: 0;
  display: flex;
  align-items: center;
}
.field .icon {
  position: absolute;
  left: 12px;
  font-size: 14px;
  opacity: 0.5;
  pointer-events: none;
}
.field input {
  width: 100%;
  border: 0;
  outline: none;
  background: transparent;
  color: var(--paper);
  font-family: inherit;
  font-size: 15px;
  letter-spacing: 1px;
  padding: 11px 38px 11px 36px;
  caret-color: var(--gold);
}
.field input::placeholder { color: rgba(232, 226, 212, 0.3); }
/* 去掉 Chrome 自带的 search 清除按钮，用自己的 */
.field input::-webkit-search-cancel-button { display: none; }

.field .clear {
  position: absolute;
  right: 10px;
  width: 20px;
  height: 20px;
  border: 0;
  border-radius: 50%;
  background: rgba(232, 226, 212, 0.12);
  color: rgba(232, 226, 212, 0.7);
  font-size: 11px;
  line-height: 1;
  cursor: pointer;
  transition: background 0.2s, color 0.2s;
}
.field .clear:hover { background: rgba(194, 58, 58, 0.5); color: #ffe6cf; }

/* 缉查按钮 */
.submit {
  flex-shrink: 0;
  padding: 0 30px;
  font-family: inherit;
  font-size: 16px;
  letter-spacing: 6px;
  text-indent: 6px;
  color: #ffe9cf;
  border: 1px solid rgba(216, 176, 106, 0.45);
  border-radius: 6px;
  background: linear-gradient(160deg, #b03535 0%, var(--cinnabar) 45%, #8e2424 100%);
  box-shadow: 0 8px 22px rgba(194, 58, 58, 0.35);
  cursor: pointer;
  transition: transform 0.15s, box-shadow 0.3s;
}
.submit:hover { transform: translateY(-1px); box-shadow: 0 12px 30px rgba(194, 58, 58, 0.5); }
.submit:active { transform: translateY(0); }

@media (max-width: 560px) {
  .search { flex-wrap: wrap; }
  .scope { border-right: 0; }
  .field { flex-basis: 100%; order: 3; margin-top: 4px; }
  .submit { margin-left: auto; padding: 0 22px; letter-spacing: 4px; }
}
</style>
