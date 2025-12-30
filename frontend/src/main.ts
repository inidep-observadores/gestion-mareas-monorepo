import './assets/main.css'
// Import Swiper styles
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/pagination'
import 'jsvectormap/dist/jsvectormap.css'
import 'flatpickr/dist/flatpickr.css'
import './assets/sonner.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import router from './router'
import VueApexCharts from 'vue3-apexcharts'
import { useAuthStore } from '@/modules/auth/stores/auth.store'

const app = createApp(App)

app.use(createPinia())
app.use(router)
app.use(VueApexCharts as any)

const initApp = () => {
    const authStore = useAuthStore()
    authStore.bootstrap()
    app.mount('#app')
}

initApp()
