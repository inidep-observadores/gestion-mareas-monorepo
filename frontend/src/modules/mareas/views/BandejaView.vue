<template>
  <AdminLayout 
    title="Bandeja de Entrada Centralizada" 
    description="Punto único para gestionar eventos, movimientos y novedades de mareas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-end">
        <div class="flex gap-3">
          <button
            class="flex items-center gap-2 px-4 py-2 bg-brand-500 text-white rounded-lg hover:bg-brand-600 transition-colors shadow-sm"
          >
            <PlusIcon class="w-5 h-5" />
            <span class="font-bold">Registrar Evento</span>
          </button>
          <button
            class="flex items-center gap-2 px-4 py-2 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors shadow-sm"
          >
            <DocsIcon class="w-5 h-5" />
            <span class="font-bold">Buscar Marea</span>
          </button>
        </div>
      </div>

      <div class="grid grid-cols-12 gap-8 items-start">
        <!-- LEFT COLUMN: Alerts & Monitoring -->
        <div class="col-span-12 lg:col-span-5 xl:col-span-4">
           <AlertTrafficLight :show-fatigue="false" />
        </div>

        <!-- RIGHT COLUMN: Actionables Placeholder -->
        <div class="col-span-12 lg:col-span-7 xl:col-span-8">
          <div class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-10 flex flex-col items-center justify-center min-h-[600px] border-dashed">
            <div class="w-20 h-20 bg-gray-50 dark:bg-gray-800 rounded-full flex items-center justify-center mb-6 text-gray-300 dark:text-gray-600">
               <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"/></svg>
            </div>
            <h2 class="text-2xl font-black text-gray-900 dark:text-white uppercase tracking-tight mb-4">Centro de Gestión</h2>
            <p class="text-gray-500 dark:text-gray-400 text-center max-w-md leading-relaxed">
              Aquí aparecerán las **tareas pendientes, revisiones de datos y flujos de aprobación** que requieren tu atención. 
              <br><br>
              Esta sección está en desarrollo para ofrecerte una experiencia de gestión por excepción fluida y centralizada.
            </p>
            
            <div class="mt-10 grid grid-cols-2 gap-4 w-full max-w-sm">
                <div class="p-4 border border-gray-100 dark:border-gray-800 rounded-2xl bg-gray-50/50 dark:bg-gray-800/20 text-center">
                    <span class="block text-xl font-black text-gray-300 dark:text-gray-700">0</span>
                    <span class="text-[10px] uppercase font-bold text-gray-400">Tareas</span>
                </div>
                <div class="p-4 border border-gray-100 dark:border-gray-800 rounded-2xl bg-gray-50/50 dark:bg-gray-800/20 text-center">
                    <span class="block text-xl font-black text-gray-300 dark:text-gray-700">0</span>
                    <span class="text-[10px] uppercase font-bold text-gray-400">Pendientes</span>
                </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { PlusIcon, DocsIcon } from '@/icons'
import AlertTrafficLight from '@/modules/dashboard/components/AlertTrafficLight.vue'
</script>

<style scoped>
/* Animación de entrada suave */
.grid > div {
  animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
