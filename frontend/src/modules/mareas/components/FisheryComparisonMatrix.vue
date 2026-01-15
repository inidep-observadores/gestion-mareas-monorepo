<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-8">
      <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
        <div class="w-1.5 h-4 bg-orange-500 rounded-full"></div>
        Matriz de Comparativa por Pesquería
      </h2>
      <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter mt-1">Análisis de cobertura y esfuerzo por especie</p>
    </div>

    <div class="flex-1 overflow-x-auto custom-scrollbar">
      <table class="w-full text-left border-separate border-spacing-y-3">
        <thead>
          <tr class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
            <th class="pb-2 pl-4">Pesquería</th>
            <th class="pb-2">Mareas Registradas</th>
            <th class="pb-2">Cobertura de Flota</th>
            <th class="pb-2">Eficiencia de Datos</th>
            <th class="pb-2 pr-4 text-right">Evolución</th>
          </tr>
        </thead>
        <tbody>
          <tr 
            v-for="item in fisheries" 
            :key="item.name"
            class="group bg-gray-50/50 dark:bg-gray-800/30 hover:bg-white dark:hover:bg-gray-800 transition-all rounded-2xl shadow-sm border border-transparent hover:border-gray-100 dark:hover:border-gray-700"
          >
            <!-- Name -->
            <td class="py-4 pl-4 rounded-l-2xl">
              <div class="flex items-center gap-3">
                 <div 
                   class="w-8 h-8 rounded-lg flex items-center justify-center text-lg shadow-sm"
                   :style="{ backgroundColor: item.color + '20', color: item.color }"
                 >
                   <component :is="item.icon" class="w-4 h-4" />
                 </div>
                 <div>
                    <div class="text-xs font-black text-gray-900 dark:text-white uppercase">{{ item.name }}</div>
                    <div class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter">{{ item.area }}</div>
                 </div>
              </div>
            </td>

            <!-- Count -->
            <td class="py-4">
               <span class="text-xs font-black text-gray-900 dark:text-white tabular-nums">{{ item.tides }}</span>
               <span class="text-[10px] font-bold text-gray-400 ml-1">Mareas</span>
            </td>

            <!-- Coverage (Ships with tides / Total ships) -->
            <td class="py-4">
               <div class="flex items-center gap-3 w-40">
                  <div class="flex-1 h-1.5 bg-gray-100 dark:bg-gray-700 rounded-full overflow-hidden">
                     <div 
                       class="h-full rounded-full transition-all duration-1000"
                       :style="{ width: item.coverage + '%', backgroundColor: item.color }"
                     ></div>
                  </div>
                  <span class="text-xs font-black text-gray-900 dark:text-white tabular-nums min-w-[32px]">{{ item.coverage }}%</span>
               </div>
               <div class="text-[9px] font-bold text-gray-400 uppercase tracking-tighter mt-1">
                 {{ item.activeShips }}/{{ item.totalShips }} Buques registrados
               </div>
            </td>

            <!-- Data Efficiency -->
            <td class="py-4">
               <div class="flex items-center gap-2">
                  <div class="flex -space-x-1">
                     <div v-for="i in 5" :key="i" class="w-2.5 h-2.5 rounded-full border border-white dark:border-gray-800 shadow-xs" :class="i <= item.efficiency ? 'bg-emerald-500' : 'bg-gray-200 dark:bg-gray-700'"></div>
                  </div>
                  <span class="text-[10px] font-black uppercase" :class="item.efficiency >= 4 ? 'text-emerald-500' : 'text-orange-500'">
                    {{ item.efficiency >= 4 ? 'Alta' : 'Media' }}
                  </span>
               </div>
            </td>

            <!-- Trend Sparkline -->
            <td class="py-4 pr-4 text-right rounded-r-2xl">
               <div class="inline-block w-20 h-8">
                  <apexchart
                    type="line"
                    height="32"
                    width="80"
                    :options="sparkOptions(item.color)"
                    :series="[{ data: item.trend }]"
                  />
               </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ShipIcon, WaveIcon, BoxIcon } from '@/icons'

const fisheries = [
  { 
    name: 'Langostino', 
    area: 'Aguas Nacionales', 
    tides: 45, 
    activeShips: 28, 
    totalShips: 34, 
    coverage: 82, 
    efficiency: 5,
    color: '#f97316',
    icon: ShipIcon,
    trend: [10, 15, 8, 20, 18, 25, 30]
  },
  { 
    name: 'Merluza', 
    area: 'ZCP', 
    tides: 67, 
    activeShips: 52, 
    totalShips: 60, 
    coverage: 87, 
    efficiency: 4,
    color: '#3b82f6',
    icon: WaveIcon,
    trend: [30, 25, 35, 32, 40, 38, 45]
  },
  { 
    name: 'Calamar', 
    area: 'Plataforma', 
    tides: 38, 
    activeShips: 15, 
    totalShips: 30, 
    coverage: 50, 
    efficiency: 3,
    color: '#a855f7',
    icon: BoxIcon,
    trend: [5, 8, 12, 10, 15, 12, 20]
  }
]

const sparkOptions = (color: string) => ({
  chart: {
    sparkline: { enabled: true },
    animations: { enabled: true }
  },
  stroke: { curve: 'smooth', width: 2 },
  colors: [color],
  tooltip: { enabled: false }
})
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
