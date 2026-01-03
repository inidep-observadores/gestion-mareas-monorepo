import { createRouter, createWebHistory } from 'vue-router'

import BandejaView from '@/modules/mareas/views/BandejaView.vue'
import PanelOperativoView from '@/modules/mareas/views/PanelOperativoView.vue'
import FlujoMareasView from '@/modules/mareas/views/FlujoMareasView.vue'
import EstadisticasView from '@/modules/mareas/views/EstadisticasView.vue'
import CalendarioView from '@/modules/mareas/views/CalendarioView.vue'
import MareaDetalleView from '@/modules/mareas/views/MareaDetalleView.vue'
import NuevaMareaView from '@/modules/mareas/views/NuevaMareaView.vue'

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
      path: '/terms',
      name: 'Terms',
      component: () => import('@/modules/auth/views/TermsView.vue'),
      meta: {
        title: 'Términos y Condiciones',
        requiresAuth: false,
      },
    },
    {
      path: '/privacy',
      name: 'Privacy',
      component: () => import('@/modules/auth/views/PrivacyView.vue'),
      meta: {
        title: 'Política de Privacidad',
        requiresAuth: false,
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
      path: '/mareas/nueva',
      name: 'NuevaMarea',
      component: NuevaMareaView,
      meta: {
        title: 'Registrar Nueva Marea',
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
      path: '/mareas/editar/:id',
      name: 'EditarMarea',
      component: () => import('@/modules/mareas/views/EditarMareaView.vue'),
      meta: {
        title: 'Editar Marea',
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
        roles: ['admin', 'coordinador'],
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
    {
      path: '/admin/error-logs',
      name: 'AdminErrorLogs',
      component: () => import('@/modules/admin/views/ErrorLogsView.vue'),
      meta: {
        title: 'Auditoría de Errores',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    {
      path: '/admin/backup',
      name: 'AdminBackup',
      component: () => import('@/modules/admin/views/BackupView.vue'),
      meta: {
        title: 'Copia de Seguridad',
        requiresAuth: true,
        roles: ['admin'],
      },
    },
    {
      path: '/admin/data-export',
      name: 'AdminDataExport',
      component: () => import('@/modules/admin/views/DataExportView.vue'),
      meta: {
        title: 'Portabilidad de Datos',
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
    {
      path: '/unauthorized',
      name: 'Unauthorized',
      component: () => import('@/modules/auth/views/UnauthorizedView.vue'),
      meta: {
        title: 'Acceso Restringido',
        requiresAuth: true
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

  // 3. User with 'invitado' role must be trapped in '/unauthorized'
  const isGuest = authStore.user?.roles?.includes('invitado')
  if (isAuthenticated && isGuest && to.name !== 'Unauthorized') {
    return next({ name: 'Unauthorized' })
  }

  // 4. Check for Roles (Regular role authorization)
  if (to.meta.roles) {
    const roles = to.meta.roles as string[]
    const userRoles = authStore.user?.roles || []
    const hasRole = roles.some(role => userRoles.includes(role))

    if (!hasRole) {
      // Redirect to home or not found if not authorized
      return next({ name: 'Dashboard' })
    }
  }

  // 5. Default
  next()
})

export default router
