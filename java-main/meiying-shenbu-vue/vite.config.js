import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 前端发出的 /api/** 一律转发到后端 8080。
// 之前这里没有 proxy，前端请求会打到 5173 自己身上，结果就是 404「未找到」。
const apiProxy = {
  '/api': {
    target: 'http://localhost:8080',
    changeOrigin: true
  }
}

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173,
    open: true,
    proxy: apiProxy
  },
  // dist 是纯静态产物，它自己不会带代理；用 npm run preview 验证构建结果时也要转发，
  // 否则 /api/** 会打到 4173 自己身上又变成 404。
  preview: {
    port: 4173,
    proxy: apiProxy
  }
})

