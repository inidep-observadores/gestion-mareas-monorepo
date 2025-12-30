import { createRouter, createWebHistory } from 'vue-router'

import BandejaView from '@/modules/mareas/views/BandejaView.vue'
import PanelOperativoView from '@/modules/mareas/views/PanelOperativoView.vue'
import FlujoMareasView from '@/modules/mareas/views/FlujoMareasView.vue'
import EstadisticasView from '@/modules/mareas/views/EstadisticasView.vue'
import CalendarioView from '@/modules/mareas/views/CalendarioView.vue'
import MareaDetalleView from '@/modules/mareas/views/MareaDetalleView.vue'

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
        requiresAuth: true,
      },
    },
    {
      path: '/signin',
      name: 'Signin',
      component: () => import('@/modules/auth/views/LoginView.vue'),
      meta: {
        title: 'Iniciar Sesión',
        guestOnly: true,
      },
    },
    {
      path: '/signup',
      name: 'Signup',
      component: () => import('@/modules/auth/views/RegisterView.vue'),
      meta: {
        title: 'Crear Cuenta',
        guestOnly: true,
      },
    },
    // Mareas Module
    {
      path: '/mareas/inbox',
      name: 'MareasInbox',
      component: BandejaView,
      meta: {
        title: 'Bandeja de Entrada',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/dashboard',
      name: 'MareasDashboard',
      component: PanelOperativoView,
      meta: {
        title: 'Panel Operativo',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/workflow',
      name: 'MareasWorkflow',
      component: FlujoMareasView,
      meta: {
        title: 'Flujo de Trabajo',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/detalle/:id',
      name: 'MareaDetalle',
      component: MareaDetalleView,
      meta: {
        title: 'Detalle de Marea',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/calendar',
      name: 'MareasCalendar',
      component: CalendarioView,
      meta: {
        title: 'Calendario de Mareas',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/stats',
      name: 'MareasStats',
      component: EstadisticasView,
      meta: {
        title: 'Estadísticas Anuales',
        requiresAuth: true,
      },
    },
    {
      path: '/mareas/monitor',
      name: 'MareasMonitor',
      component: () => import('@/modules/monitor/views/MonitorVMSView.vue'),
      meta: {
        title: 'Centro de Operaciones Marítimas',
        requiresAuth: true,
      },
    },
    // Redirección por defecto
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'Dashboard' },
    },
  ],
})

import { useAuthStore } from '@/modules/auth/stores/auth.store'

router.beforeEach(async (to, from, next) => {
  document.title = `${to.meta.title} | Gestión de Mareas - INIDEP`

  const authStore = useAuthStore()
  await authStore.whenReady() // Wait for bootstrap

  const isAuthenticated = authStore.isAuthenticated

  // 1. Check for Requires Auth
  if (to.meta.requiresAuth && !isAuthenticated) {
    return next({ name: 'Signin', query: { redirect: to.fullPath } })
  }

  // 2. Check for Guest Only (e.g. Login page)
  if (to.meta.guestOnly && isAuthenticated) {
    return next({ name: 'Dashboard' })
  }

  // 3. Default
  next()
})

export default router
