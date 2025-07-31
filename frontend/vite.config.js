import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// 获取项目根目录
const projectRoot = path.resolve(__dirname)

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(projectRoot, './src')
    }
  },
  server: {
    port: process.env.PORT || 3000,
    proxy: {
      '/api': {
        target: process.env.API_TARGET || 'http://localhost:5000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  }
})