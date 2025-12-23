import { createRouter, createWebHistory } from 'vue-router'

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
    // Redirección por defecto
    {
      path: '/:pathMatch(.*)*',
      redirect: { name: 'Dashboard' },
    },
  ],
})

export default router

router.beforeEach((to, from, next) => {
  document.title = `${to.meta.title} | SIGMA - INIDEP`
  next()
})
