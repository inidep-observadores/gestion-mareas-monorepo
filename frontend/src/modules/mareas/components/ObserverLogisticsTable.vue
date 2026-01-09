<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-blue-500 rounded-full"></div>
          Logística y Talento (Observadores)
        </h2>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter mt-1">Monitoreo de disponibilidad y esfuerzo</p>
      </div>
      <div class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Últimos 12 meses</div>
    </div>

    <div class="flex-1 overflow-x-auto custom-scrollbar">
      <table class="w-full text-left border-separate border-spacing-y-2">
        <thead>
          <tr class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
            <th class="pb-2 pl-4">Observador</th>
            <th class="pb-2">Días Mar Año</th>
            <th class="pb-2">Estado</th>
            <th class="pb-2 pr-4 text-right">En Tierra</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="obs in observers" 
            :key="obs.id"
            class="group bg-gray-50/50 dark:bg-gray-800/30 hover:bg-white dark:hover:bg-gray-800 transition-all rounded-2xl shadow-sm border border-transparent hover:border-gray-100 dark:hover:border-gray-700"
          >
            <!-- Observer Info -->
            <td class="py-4 pl-4 rounded-l-2xl">
              <div class="flex items-center gap-3">
                 <div
                   class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-black text-xs shadow-sm border border-indigo-100 dark:border-indigo-800/50"
                 >
                   {{ obs.nombre.split(' ').map((n) => n[0]).join('') }}
                 </div>
                 <div class="text-xs font-black text-gray-900 dark:text-white uppercase tracking-wide">
                   {{ obs.nombre }}
                 </div>
              </div>
            </td>

            <!-- Sea Days Progress (Target 180) -->
            <td class="py-4">
               <div class="w-full max-w-[140px]">
                 <div class="flex justify-between text-[10px] font-black uppercase mb-1.5">
                    <span class="text-gray-900 dark:text-white">{{ obs.diasMar }}d</span>
                    <span class="text-gray-400">/ {{ DIAS_NAVEGADOS_ANUALES }} IDEAL</span>
                 </div>
                 <div class="h-2 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden border border-gray-100/50 dark:border-gray-700/30 relative">
                    <div
                      class="h-full transition-all duration-1000 ease-out rounded-full shadow-sm"
                      :class="[obs.diasMar >= DIAS_NAVEGADOS_ANUALES ? 'bg-orange-500' : 'bg-indigo-500']"
                      :style="{ width: Math.min((obs.diasMar / DIAS_NAVEGADOS_ANUALES) * 100, 100) + '%' }"
                    ></div>
                    <!-- Target Marker -->
                    <div class="absolute top-0 right-0 h-full w-px bg-white/30"></div>
                 </div>
               </div>
            </td>

            <!-- Status Tag -->
            <td class="py-4">
              <span
                class="inline-flex items-center px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-widest border"
                :class="statusStyles[obs.estado]"
              >
                <span class="w-1.5 h-1.5 rounded-full mr-2" :class="statusDotStyles[obs.estado]"></span>
                {{ obs.estado }}
              </span>
            </td>

            <!-- Land Days -->
            <td class="py-4 pr-4 text-right rounded-r-2xl">
               <div class="flex flex-col items-end">
                  <span 
                    class="text-xs font-black tabular-nums"
                    :class="obs.diasTierra > 30 ? 'text-orange-500' : 'text-gray-900 dark:text-white'"
                  >
                    {{ obs.diasTierra }} <span class="text-[9px] text-gray-400 uppercase font-black">Días</span>
                  </span>
                  <span v-if="obs.diasTierra > 30" class="text-[8px] font-black text-orange-400 uppercase tracking-tighter">Exceso detectado</span>
               </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- View All Action -->
    <div class="mt-6 pt-4 border-t border-gray-50 dark:border-gray-800/50 flex justify-center">
       <button class="flex items-center gap-2 text-[10px] font-black text-indigo-500 hover:text-indigo-600 dark:text-indigo-400 uppercase tracking-widest transition-colors group">
          Ver plantilla completa
          <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3 transition-transform group-hover:translate-x-1" viewBox="0 0 20 20" fill="currentColor">
            <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
          </svg>
       </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { BUSINESS_RULES } from '@/modules/shared/config/business-rules'

const { DIAS_NAVEGADOS_ANUALES } = BUSINESS_RULES

interface Observer {
  id: number
  nombre: string
  diasMar: number
  estado: 'Navegando' | 'Disponible' | 'Licencia'
  diasTierra: number
}

const observers: Observer[] = [
  { id: 1, nombre: 'Juan Pérez', diasMar: 185, estado: 'Navegando', diasTierra: 0 },
  { id: 2, nombre: 'María García', diasMar: 142, estado: 'Disponible', diasTierra: 15 },
  { id: 3, nombre: 'Carlos Rodríguez', diasMar: 175, estado: 'Disponible', diasTierra: 42 },
  { id: 4, nombre: 'Ana López', diasMar: 88, estado: 'Navegando', diasTierra: 0 },
  { id: 5, nombre: 'Roberto Gómez', diasMar: 120, estado: 'Licencia', diasTierra: 10 },
]

const statusStyles = {
  Navegando: 'bg-indigo-50 text-indigo-700 border-indigo-100 dark:bg-indigo-500/10 dark:text-indigo-400 dark:border-indigo-800/50',
  Disponible: 'bg-emerald-50 text-emerald-700 border-emerald-100 dark:bg-emerald-500/10 dark:text-emerald-400 dark:border-emerald-800/50',
  Licencia: 'bg-gray-100 text-gray-600 border-gray-200 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-700',
}

const statusDotStyles = {
  Navegando: 'bg-indigo-500 animate-pulse',
  Disponible: 'bg-emerald-500',
  Licencia: 'bg-gray-400',
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e5e7eb;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #374151;
}
</style>
