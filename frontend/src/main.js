import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'

// 引入Element Plus
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// 引入全局样式
import './styles/index.css'

const app = createApp(App)

app.use(store)
app.use(router)
app.use(ElementPlus)

app.mount('#app')