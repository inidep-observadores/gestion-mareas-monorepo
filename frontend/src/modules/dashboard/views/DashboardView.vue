<template>
  <AdminLayout
    title="Panel General"
    description="Resumen operativo: Gestión por excepción y prioridad inmediata."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1 pb-10">
      <!-- DASHBOARD EXTRA HEADER INFO -->
      <!-- Lo dejo comentado por ahora para ganar espacio -->
      <!-- <div class="mb-6 flex justify-end">
          <div
            class="flex items-center gap-2 rounded-2xl bg-white p-2 px-3 shadow-sm dark:bg-gray-900 border border-gray-100 dark:border-gray-800"
          >
            <span class="flex h-2 w-2 rounded-full bg-success-500 animate-pulse"></span>
            <span class="text-[10px] uppercase font-bold text-gray-500 dark:text-gray-400 tracking-wider"
              >Sistema en Tiempo Real</span
            >
          </div>
      </div> -->

      <!-- ROW 1: THE PULSE OF THE MOMENT (KPIs) -->
      <div class="mb-8">
        <ActionKpis />
      </div>

      <!-- ROW 2: CRITICAL PANELS -->
      <div class="grid grid-cols-12 gap-6 mb-8">
        <!-- SEMÁFORO DE ALERTAS (Left 7-8 cols) -->
        <div class="col-span-12 lg:col-span-7 xl:col-span-8">
          <AlertTrafficLight />
        </div>

        <!-- PRÓXIMOS MOVIMIENTOS (Right 4-5 cols) -->
        <div class="col-span-12 lg:col-span-5 xl:col-span-4">
          <UpcomingMovements />
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
import UpcomingMovements from '../components/UpcomingMovements.vue'
import WorkforceOverview from '../components/WorkforceOverview.vue'
</script>

<style scoped>
/* Reducir padding en AdminLayout si es necesario para que entre en una pantalla */
:deep(.admin-layout-content) {
  padding-top: 1.5rem !important;
}
</style>

<style scoped>
/* Estilos específicos para el dashboard de mareas */
</style>
