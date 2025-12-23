import type {
  NavigationGuardNext,
  RouteLocationNormalized,
  RouteRecordRaw,
} from 'vue-router';
import { createRouter, createWebHistory } from 'vue-router';

// Layouts
import LandingLayout from '../layouts/LandingLayout.vue';
import AuthLayout from '../layouts/AuthLayout.vue';
import DashboardLayout from '../layouts/DashboardLayout.vue';

// Views
import SigmaLanding from '../modules/auth/views/SigmaLanding.vue';
import LoginView from '../modules/auth/views/LoginView.vue';
import RegisterView from '../modules/auth/views/RegisterView.vue';
import ForgotPasswordView from '../modules/auth/views/ForgotPasswordView.vue';
import ResetPasswordView from '../modules/auth/views/ResetPasswordView.vue';
import DashboardHome from '../modules/dashboard/views/DashboardHome.vue';
import AuditView from '../modules/dashboard/views/AuditView.vue';
import ReportsView from '../modules/dashboard/views/ReportsView.vue';
import SettingsView from '../modules/dashboard/views/SettingsView.vue';
import NotFoundView from '../modules/shared/views/NotFoundView.vue';
import { authService } from '@/services/auth.service';

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    component: LandingLayout,
    children: [
      {
        path: '',
        name: 'Landing',
        component: SigmaLanding,
        meta: { theme: 'dark' },
      },
    ],
  },
  {
    path: '/auth',
    component: AuthLayout,
    meta: { requiresUnauth: true, theme: 'dark' },
    children: [
      {
        path: 'login',
        name: 'Login',
        component: LoginView,
      },
      {
        path: 'register',
        name: 'Register',
        component: RegisterView,
      },
      {
        path: 'forgot-password',
        name: 'ForgotPassword',
        component: ForgotPasswordView,
      },
      {
        path: 'reset-password',
        name: 'ResetPassword',
        component: ResetPasswordView,
      },
    ],
  },

  {
    path: '/dashboard',
    component: DashboardLayout,
    meta: { requiresAuth: true, theme: 'light' },
    children: [
      {
        path: '',
        name: 'DashboardHome',
        component: DashboardHome,
      },
      {
        path: 'audit',
        name: 'Audit',
        component: AuditView,
        meta: { allowedRoles: ['admin', 'coordinador'] },
      },
      {
        path: 'reports',
        name: 'Reports',
        component: ReportsView,
      },
      {
        path: 'settings',
        name: 'Settings',
        component: SettingsView,
      },
    ],
  },
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: NotFoundView,
    meta: { theme: 'dark' },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((
  to: RouteLocationNormalized,
  _from: RouteLocationNormalized,
  next: NavigationGuardNext,
) => {
  const isAuthenticated = !!authService.getToken();
  const user = authService.getUser();

  const requiresAuth = to.matched.some(record => record.meta.requiresAuth);
  const requiresUnauth = to.matched.some(record => record.meta.requiresUnauth);
  const allowedRoles = to.meta.allowedRoles as string[] | undefined;

  // 1. Si requiere auth y no está autenticado -> Login
  if (requiresAuth && !isAuthenticated) {
    return next({ name: 'Login' });
  }

  // 2. Si es ruta de auth y ya está autenticado -> Dashboard
  if (requiresUnauth && isAuthenticated) {
    return next({ name: 'DashboardHome' });
  }

  // 3. Caso crítico: Autenticado pero sin datos de usuario persistidos
  // Esto puede pasar por bugs previos en persistSession. Forzamos re-login.
  if (requiresAuth && isAuthenticated && !user) {
    authService.logout();
    return next({ name: 'Login' });
  }

  // 4. Verificación de roles
  if (requiresAuth && allowedRoles && user) {
    const hasRole = user.roles.some(role => allowedRoles.includes(role));
    if (!hasRole) {
      return next({ name: 'DashboardHome' });
    }
  }

  next();
});

export default router;
