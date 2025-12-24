<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1 pb-10">
      <!-- DASHBOARD HEADER -->
      <div class="mb-8 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <h1 class="text-3xl text-gray-800 dark:text-white tracking-tight uppercase">
            Panel general
          </h1>
          <p class="text-sm font-medium text-gray-500 dark:text-gray-400">
            Resumen operativo: Gestión por excepción y prioridad inmediata.
          </p>
        </div>
        <div class="flex items-center gap-4">
          <router-link
            :to="{ name: 'MareasMonitor' }"
            class="flex items-center gap-2 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-bold transition-colors shadow-lg shadow-blue-500/20"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm0 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zm6 5a1 1 0 011-1h6a1 1 0 110 2h-6a1 1 0 01-1-1z" clip-rule="evenodd" />
            </svg>
            Monitor VMS
          </router-link>

          <div
            class="flex items-center gap-2 rounded-2xl bg-white p-2 shadow-sm dark:bg-gray-900 border border-gray-100 dark:border-gray-800"
          >
            <span class="flex h-2 w-2 rounded-full bg-success-500 animate-pulse"></span>
            <span class="text-[10px] uppercase text-gray-500 dark:text-gray-400"
              >Sistema en Tiempo Real</span
            >
          </div>
        </div>
      </div>

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
