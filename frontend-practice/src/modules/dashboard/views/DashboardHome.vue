<script setup lang="ts">
import { computed } from 'vue';
import { authService } from '@/services/auth.service';
import DashboardCard from '../components/DashboardCard.vue';
import { 
  BarChart3, 
  CalendarCheck, 
  Users, 
  ArrowUpRight,
  TrendingUp,
  Ship
} from 'lucide-vue-next';

const user = authService.getUser();
const welcomeName = computed(() => {
  if (!user?.fullName) return 'Usuario';
  return user.fullName.split(' ')[0]; // Solo el primer nombre para un saludo más amigable
});
</script>

<template>
  <div class="dashboard-home">
    <!-- Welcome Header -->
    <div class="flex items-center justify-between mb-10">
      <div>
        <h2 class="text-3xl font-black text-slate-900 tracking-tight">Bienvenido, {{ welcomeName }}</h2>
        <p class="text-slate-500 mt-1 font-medium">Esto es lo que está pasando en SIGMA hoy.</p>
      </div>
      <button class="btn-action">
        <Ship :size="18" />
        <span>Nueva Marea</span>
      </button>
    </div>
    
    <!-- Stats Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <!-- Card 1: Resumen de Mareas -->
      <DashboardCard 
        title="Resumen de Mareas" 
        description="Vista general de las mareas activas y recientes en el sistema."
        :icon="BarChart3"
        iconColor="blue"
      >
        <template #extra>
          <div class="badge badge-blue">
            <TrendingUp :size="14" />
            <span>+12%</span>
          </div>
        </template>
        
        <div class="mt-4 flex items-end justify-between">
          <div class="text-3xl font-black text-slate-900">24</div>
          <div class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Activas hoy</div>
        </div>

        <template #footer>
          <button class="card-action">
            <span>Ver detalles</span>
            <ArrowUpRight :size="14" />
          </button>
        </template>
      </DashboardCard>

      <!-- Card 2: Tareas Pendientes -->
      <DashboardCard 
        title="Tareas Pendientes" 
        description="Usted tiene 3 tareas que requieren su atención el día de hoy."
        :icon="CalendarCheck"
        iconColor="green"
      >
        <div class="mt-4 space-y-3">
          <div class="task-item">
            <div class="task-dot bg-orange-400"></div>
            <span class="text-sm font-medium text-slate-700">Validar captura Marea #452</span>
          </div>
          <div class="task-item">
            <div class="task-dot bg-blue-400"></div>
            <span class="text-sm font-medium text-slate-700">Firmar reporte semanal</span>
          </div>
        </div>

        <template #footer>
          <button class="card-action text-emerald-600">
            <span>Ir a tareas</span>
            <ArrowUpRight :size="14" />
          </button>
        </template>
      </DashboardCard>

      <!-- Card 3: Gestión de Usuarios -->
      <DashboardCard 
        title="Usuarios" 
        description="Administre el acceso, roles y permisos de los observadores."
        :icon="Users"
        iconColor="purple"
      >
        <div class="mt-4 flex -space-x-2">
          <div v-for="i in 4" :key="i" class="w-8 h-8 rounded-full border-2 border-white bg-slate-100 flex items-center justify-center text-[10px] font-bold text-slate-600">
            {{ ['AM', 'LG', 'RS', 'HT'][i-1] }}
          </div>
          <div class="w-8 h-8 rounded-full border-2 border-white bg-slate-50 flex items-center justify-center text-[10px] font-bold text-slate-400">
            +12
          </div>
        </div>

        <template #footer>
          <button class="card-action text-purple-600">
            <span>Gestionar</span>
            <ArrowUpRight :size="14" />
          </button>
        </template>
      </DashboardCard>
    </div>
  </div>
</template>

<style scoped>
.btn-action {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  background: #0f172a;
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 14px;
  font-weight: 700;
  font-size: 0.875rem;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.2);
}

.btn-action:hover {
  background: #1e293b;
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(15, 23, 42, 0.3);
}

.badge {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.25rem 0.625rem;
  border-radius: 99px;
  font-size: 0.75rem;
  font-weight: 700;
}

.badge-blue {
  background: #eff6ff;
  color: #2563eb;
}

.task-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem;
  background: #f8fafc;
  border-radius: 10px;
}

.task-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.card-action {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.8125rem;
  font-weight: 700;
  color: #3b82f6;
  background: none;
  border: none;
  cursor: pointer;
  padding: 0;
  transition: opacity 0.2s;
}

.card-action:hover {
  opacity: 0.7;
}

.dashboard-home {
  animation: slideUp 0.6s ease-out;
}

@keyframes slideUp {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
