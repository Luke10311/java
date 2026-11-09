import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 前端发出的 /api/** 一律转发到后端 8080。
// IP 用本机局域网地址 192.168.68.27，手机 / 局域网内其他设备也能连到后端。
const apiProxy = {
  '/api': {
    target: 'http://192.168.68.27:8080',
    changeOrigin: true
  }
}

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // 监听所有网卡：本机和局域网内可用 http://192.168.68.27:5173 访问
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

