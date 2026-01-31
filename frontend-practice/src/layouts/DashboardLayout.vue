<template>
  <div class="flex h-screen bg-slate-50 font-sans antialiased text-slate-900">
    <!-- Sidebar -->
    <aside class="w-72 bg-white border-r border-slate-100 flex flex-col relative z-20 shadow-[4px_0_24px_-10px_rgba(0,0,0,0.03)]">
      <router-link :to="{ name: 'DashboardHome' }" class="block p-8 pb-10 hover:opacity-80 transition-opacity">
        <SigmaBranding variant="sidebar" />
      </router-link>

      <nav class="flex-1 px-4 space-y-1.5 overflow-y-auto">
        <div class="px-4 mb-4">
          <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest pl-1">Navegación</span>
        </div>

        <router-link 
          :to="{ name: 'DashboardHome' }" 
          v-slot="{ isExactActive }"
        >
          <div :class="['nav-item', { 'active': isExactActive }]">
            <Home :size="20" :stroke-width="isExactActive ? 2.5 : 2" />
            <span>Inicio</span>
            <div v-if="isExactActive" class="active-indicator"></div>
          </div>
        </router-link>
        
        <router-link 
          :to="{ name: 'Reports' }" 
          v-slot="{ isActive }"
        >
          <div :class="['nav-item', { 'active': isActive }]">
            <FileBarChart :size="20" :stroke-width="isActive ? 2.5 : 2" />
            <span>Reportes</span>
            <div v-if="isActive" class="active-indicator"></div>
          </div>
        </router-link>

        <router-link 
          v-if="canAccessAudit"
          :to="{ name: 'Audit' }" 
          v-slot="{ isActive }"
        >
          <div :class="['nav-item', { 'active': isActive }]">
            <ShieldAlert :size="20" :stroke-width="isActive ? 2.5 : 2" />
            <span>Auditoría</span>
            <div v-if="isActive" class="active-indicator"></div>
          </div>
        </router-link>

        <div class="pt-6 px-4 mb-4">
          <span class="text-[10px] font-bold text-slate-400 uppercase tracking-widest pl-1">Sistema</span>
        </div>

        <router-link 
          :to="{ name: 'Settings' }" 
          v-slot="{ isActive }"
        >
          <div :class="['nav-item', { 'active': isActive }]">
            <Settings :size="20" :stroke-width="isActive ? 2.5 : 2" />
            <span>Configuración</span>
            <div v-if="isActive" class="active-indicator"></div>
          </div>
        </router-link>
      </nav>

      <div class="p-6 mt-auto">
        <button 
          @click="logout" 
          class="flex items-center space-x-3 w-full px-4 py-3 text-slate-400 hover:text-slate-900 hover:bg-slate-50 rounded-xl transition-all group"
        >
          <LogOut :size="20" class="group-hover:translate-x-1 transition-transform" />
          <span class="font-semibold text-sm">Cerrar Sesión</span>
        </button>
      </div>
    </aside>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col overflow-hidden relative">
      <!-- Header -->
      <header class="bg-white/80 backdrop-blur-md border-b border-slate-100 h-20 flex items-center justify-between px-10 relative z-10">
        <div class="flex items-center space-x-2 text-sm font-medium">
          <span class="text-slate-400 hover:text-slate-600 cursor-pointer transition-colors" @click="router.push({ name: 'DashboardHome' })">SIGMA</span>
          <ChevronRight :size="16" class="text-slate-300" />
          <span class="text-slate-400">Dashboard</span>
          <ChevronRight :size="16" class="text-slate-300" />
          <span class="text-slate-900 font-bold uppercase tracking-wide">{{ currentPageTitle }}</span>
        </div>

        <div class="flex items-center space-x-6">
          <div class="flex flex-col items-end">
            <span class="text-sm font-bold text-slate-900 leading-none">{{ user?.fullName || 'Usuario' }}</span>
            <span class="text-[10px] font-semibold text-slate-400 uppercase tracking-wider mt-1">{{ userRoleName }}</span>
          </div>
          <div class="user-avatar border-slate-100">
            <span class="text-blue-600">{{ userInitials }}</span>
          </div>
        </div>
      </header>
      
      <!-- Page Content -->
      <main class="flex-1 overflow-x-hidden overflow-y-auto p-10">
        <router-view v-slot="{ Component }">
          <transition name="page-fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { authService } from '@/services/auth.service';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import { 
  Home, 
  FileBarChart, 
  Settings, 
  LogOut, 
  ChevronRight,
  ShieldAlert
} from 'lucide-vue-next';

const router = useRouter();
const route = useRoute();
const user = authService.getUser();

const canAccessAudit = computed(() => {
  return user?.roles.some(role => ['admin', 'coordinador'].includes(role));
});

const userRoleName = computed(() => {
  if (!user?.roles.length) return 'Usuario';
  const role = user.roles[0];
  const roleMap: Record<string, string> = {
    'admin': 'Administrador',
    'coordinador': 'Coordinador',
    'tecnico': 'Técnico de Datos',
    'asistente': 'Asistente Administrativo'
  };
  return roleMap[role] || role;
});

const userInitials = computed(() => {
  if (!user?.fullName) return 'U';
  return user.fullName
    .split(' ')
    .map(n => n[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);
});

const currentPageTitle = computed(() => {
  if (route.name === 'Audit') return 'Auditoría';
  if (route.name === 'Reports') return 'Reportes';
  if (route.name === 'Settings') return 'Configuración';
  if (route.name === 'DashboardHome') return 'Inicio';
  return 'Dashboard';
});

const logout = () => {
  authService.logout();
  router.push({ name: 'Login' });
};
</script>

<style scoped>
.nav-item {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.875rem 1.25rem;
  border-radius: 14px;
  color: #64748b; /* Slate 500 */
  font-weight: 600;
  font-size: 0.9375rem;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
}

.nav-item:hover {
  background: #f8fafc;
  color: #0f172a;
}

.nav-item.active {
  background: #eff6ff; /* Blue 50 */
  color: #2563eb; /* Blue 600 */
}

.active-indicator {
  position: absolute;
  left: 0;
  top: 25%;
  height: 50%;
  width: 4px;
  background: #2563eb;
  border-radius: 0 4px 4px 0;
  box-shadow: 0 0 10px rgba(37, 99, 235, 0.2);
}

.user-avatar {
  width: 44px;
  height: 44px;
  background: white;
  border: 1px solid #f1f5f9;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 0.875rem;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
}

/* Page Transition */
.page-fade-enter-active,
.page-fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.page-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.page-fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>
