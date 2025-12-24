import { createRouter, createWebHistory } from 'vue-router'

import BandejaView from '@/modules/mareas/views/BandejaView.vue'
import PanelOperativoView from '@/modules/mareas/views/PanelOperativoView.vue'
import FlujoMareasView from '@/modules/mareas/views/FlujoMareasView.vue'
import EstadisticasView from '@/modules/mareas/views/EstadisticasView.vue'
import CalendarioView from '@/modules/mareas/views/CalendarioView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  scrollBehavior(to, from, savedPosition) {
    return savedPosition || { left: 0, top: 0 }
  },
  routes: [
    {
      path: '/',
      name: 'Dashboard',
      component: () => import('@/modules/dashboard/views/DashboardView.vue'),
      meta: {
        title: 'Panel de Control',
      },
    },
    {
      path: '/signin',
      name: 'Signin',
      component: () => import('@/modules/auth/views/LoginView.vue'),
      meta: {
        title: 'Iniciar Sesión',
      },
    },
    {
      path: '/signup',
      name: 'Signup',
      component: () => import('@/modules/auth/views/RegisterView.vue'),
      meta: {
        title: 'Crear Cuenta',
      },
    },
    // Mareas Module
    {
      path: '/mareas/inbox',
      name: 'MareasInbox',
      component: BandejaView,
      meta: {
        title: 'Bandeja de Entrada',
      },
    },
    {
      path: '/mareas/dashboard',
      name: 'MareasDashboard',
      component: PanelOperativoView,
      meta: {
        title: 'Panel Operativo',
      },
    },
    {
      path: '/mareas/workflow',
      name: 'MareasWorkflow',
      component: FlujoMareasView,
      meta: {
        title: 'Flujo de Trabajo',
      },
    },
    {
      path: '/mareas/calendar',
      name: 'MareasCalendar',
      component: CalendarioView,
      meta: {
        title: 'Calendario de Mareas',
      },
    },
    {
      path: '/mareas/stats',
      name: 'MareasStats',
      component: EstadisticasView,
      meta: {
        title: 'Estadísticas Anuales',
      },
    },
    {
      path: '/mareas/monitor',
      name: 'MareasMonitor',
      component: () => import('@/modules/monitor/views/MonitorVMSView.vue'),
      meta: {
        title: 'Centro de Operaciones Marítimas',
      },
    },
    // Redirección por defecto
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'Dashboard' },
    },
  ],
})

export default router

router.beforeEach((to, from, next) => {
  document.title = `${to.meta.title} | Gestión de Mareas - INIDEP`
  next()
})
