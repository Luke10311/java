import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// 前端发出的 /api/** 一律转发到后端 8080。
// 代理目标用 127.0.0.1：Vite 代理请求是从本机发出的，localhost 永远指向本机后端，
// 不受局域网 IP 变化影响（本机局域网 IP 192.168.68.58，DHCP 曾变到 .27 踩过坑）。
// 手机等局域网设备访问 http://192.168.68.58:5173 即可，代理会替它们转发到本机 8080。
const apiProxy = {
  '/api': {
    target: 'http://127.0.0.1:8080',
    changeOrigin: true
  }
}

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // 监听所有网卡：本机 http://localhost:5173，局域网内 http://192.168.68.58:5173
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

