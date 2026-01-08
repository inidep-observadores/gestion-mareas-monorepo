<template>
  <AdminLayout
    title="Centro de Comando"
    description="Panel General Operativo: Gestión por excepción y monitoreo de flota en tiempo real."
  >
    <template #extra-header>
      <div class="flex items-center gap-4">
        <router-link
          to="/mareas/calendar"
          class="flex items-center gap-2 px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-all shadow-sm ring-1 ring-black/5"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-gray-500 dark:text-gray-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          <span class="text-xs font-bold text-gray-700 dark:text-gray-200">Calendario Logístico</span>
        </router-link>
      </div>
    </template>

    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10 mt-6 md:mt-0">
      
      <!-- ROW 1: THE PULSE OF THE MOMENT (KPIs) -->
      <div class="mb-8">
        <ActionKpis />
      </div>

      <!-- ROW 2: CRITICAL PANELS -->
      <div class="grid grid-cols-12 gap-8 mb-8 items-stretch">
        <!-- ALERT CENTER (Left) -->
        <div class="col-span-12 lg:col-span-6 xl:col-span-5 h-full">
          <AlertTrafficLight :show-actions="false" class="h-full" />
        </div>

        <!-- PANELS DERECHA (Right) -->
        <div class="col-span-12 lg:col-span-6 xl:col-span-7 flex flex-col gap-8">
          <FleetDistributionByFishery />
          <WorkforceOverview :data="workforceData" />
          <ExpiringMareas />
          <TopDryTime :topDry="workforceData?.topDry || []" />
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import ActionKpis from '../components/ActionKpis.vue'
import AlertTrafficLight from '../components/AlertTrafficLight.vue'
import ExpiringMareas from '../components/ExpiringMareas.vue'
import FleetDistributionByFishery from '../components/FleetDistributionByFishery.vue'
import WorkforceOverview from '../components/WorkforceOverview.vue'
import TopDryTime from '../components/TopDryTime.vue'
import dashboardService, { type WorkforceStatus } from '../services/dashboard.service'

const workforceData = ref<WorkforceStatus | null>(null)

const loadWorkforce = async () => {
  try {
    workforceData.value = await dashboardService.getWorkforceStatus()
  } catch (error) {
    toast.error('Error al cargar datos del personal')
  }
}

onMounted(() => {
  loadWorkforce()
})
</script>

<style scoped>
/* Reducir padding en AdminLayout si es necesario para que entre en una pantalla */
:deep(.admin-layout-content) {
  padding-top: 1.5rem !important;
}

/* Efecto de entrada suave para los componentes */
.col-span-12 {
  animation: fadeIn 0.5s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
