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
    {
      path: '/forgot-password',
      name: 'ForgotPassword',
      component: () => import('@/modules/auth/views/ForgotPasswordView.vue'),
      meta: {
        title: 'Recuperar Contraseña',
        guestOnly: true,
      },
    },
    {
      path: '/reset-password',
      name: 'ResetPassword',
      component: () => import('@/modules/auth/views/ResetPasswordView.vue'),
      meta: {
        title: 'Restablecer Contraseña',
        guestOnly: true,
      },
    },
    {
      path: '/profile',
      name: 'Profile',
      component: () => import('@/modules/auth/views/ProfileView.vue'),
      meta: {
        title: 'Mi Perfil',
        requiresAuth: true,
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
    // Admin Module
    {
      path: '/admin',
      redirect: '/admin/users',
    },
    {
      path: '/admin/users',
      name: 'AdminUsers',
      component: () => import('@/modules/admin/views/UsersView.vue'),
      meta: {
        title: 'Gestión de Usuarios',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    {
      path: '/admin/observadores',
      name: 'AdminObservadores',
      component: () => import('@/modules/admin/views/ObservadoresView.vue'),
      meta: {
        title: 'Gestión de Observadores',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    {
      path: '/admin/buques',
      name: 'AdminBuques',
      component: () => import('@/modules/admin/views/BuquesView.vue'),
      meta: {
        title: 'Gestión de Buques',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    // 404 No encontrado
    {
      path: '/:pathMatch(.*)*',
      name: 'NotFound',
      component: () => import('@/modules/common/views/NotFoundView.vue'),
      meta: {
        title: 'Página no encontrada',
        guestOnly: false, // Accessible by everyone
        requiresAuth: false
      }
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

  // 3. Check for Roles
  if (to.meta.roles) {
    const roles = to.meta.roles as string[]
    const userRoles = authStore.user?.roles || []
    const hasRole = roles.some(role => userRoles.includes(role))

    if (!hasRole) {
      // Redirect to home or not found if not authorized
      return next({ name: 'Dashboard' })
    }
  }

  // 4. Default
  next()
})

export default router
