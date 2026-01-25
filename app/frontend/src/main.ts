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
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'

const app = createApp(App)

const pinia = createPinia()
app.use(pinia)
app.use(router)
app.use(VueApexCharts as any)

const initApp = async () => {
    const authStore = useAuthStore()
    const businessRulesStore = useBusinessRulesStore()
    authStore.bootstrap()
    try {
        await businessRulesStore.load()
        if (router.currentRoute.value.name === 'ServerError') {
            await router.replace({ name: 'Dashboard' })
        }
    } catch (error) {
        console.error('No se pudieron cargar las reglas de negocio:', error)
        businessRulesStore.failed = true
        await router.replace({ name: 'ServerError' })
    }
    app.mount('#app')
}

initApp()
