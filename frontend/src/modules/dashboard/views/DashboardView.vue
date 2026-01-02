<template>
  <AdminLayout
    title="Centro de Comando"
    description="Panel General Operativo: Gestión por excepción y monitoreo de flota en tiempo real."
  >
    <template #extra-header>
       <SystemHealthPulse />
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
          <AlertTrafficLight class="h-full" />
        </div>

        <!-- NEW SECTIONS (Right) -->
        <div class="col-span-12 lg:col-span-6 xl:col-span-7 flex flex-col gap-8">
          <ExpiringMareas />
          <FleetDistributionByFishery />
        </div>
      </div>

      <!-- ROW 3: WORKFORCE STATE -->
      <div class="col-span-12">
        <WorkforceOverview />
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import ActionKpis from '../components/ActionKpis.vue'
import AlertTrafficLight from '../components/AlertTrafficLight.vue'
import ExpiringMareas from '../components/ExpiringMareas.vue'
import FleetDistributionByFishery from '../components/FleetDistributionByFishery.vue'
import WorkforceOverview from '../components/WorkforceOverview.vue'
import SystemHealthPulse from '../components/SystemHealthPulse.vue'
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
