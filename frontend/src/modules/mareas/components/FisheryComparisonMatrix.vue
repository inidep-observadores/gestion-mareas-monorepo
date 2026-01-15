<template>
  <div class="rounded-3xl border border-border bg-surface p-6 shadow-sm h-full flex flex-col">
    <div class="mb-8">
      <h2 class="text-sm font-black text-text uppercase tracking-widest flex items-center gap-2">
        <div class="w-1.5 h-4 bg-primary rounded-full"></div>
        Matriz de Comparativa por Pesquería
      </h2>
      <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-1">Análisis de cobertura y esfuerzo por especie</p>
    </div>

    <div class="flex-1 overflow-x-auto custom-scrollbar">
      <table class="w-full text-left border-separate border-spacing-y-3">
        <thead>
          <tr class="text-[10px] font-black text-text-muted uppercase tracking-widest">
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
            class="group bg-surface-muted hover:bg-surface transition-all rounded-2xl shadow-sm border border-transparent hover:border-border"
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
                    <div class="text-xs font-black text-text uppercase">{{ item.name }}</div>
                    <div class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">{{ item.area }}</div>
                 </div>
              </div>
            </td>

            <!-- Count -->
            <td class="py-4">
               <span class="text-xs font-black text-text tabular-nums">{{ item.tides }}</span>
               <span class="text-[10px] font-bold text-text-muted ml-1">Mareas</span>
            </td>

            <!-- Coverage (Ships with tides / Total ships) -->
            <td class="py-4">
               <div class="flex items-center gap-3 w-40">
                  <div class="flex-1 h-1.5 bg-surface rounded-full overflow-hidden border border-border">
                     <div 
                       class="h-full rounded-full transition-all duration-1000"
                       :style="{ width: item.coverage + '%', backgroundColor: item.color }"
                     ></div>
                  </div>
                  <span class="text-xs font-black text-text tabular-nums min-w-[32px]">{{ item.coverage }}%</span>
               </div>
               <div class="text-[9px] font-bold text-text-muted uppercase tracking-tighter mt-1">
                 {{ item.activeShips }}/{{ item.totalShips }} Buques registrados
               </div>
            </td>

            <td class="py-4">
               <div class="flex items-center gap-2">
                  <div class="flex -space-x-1">
                     <div v-for="i in 5" :key="i" class="w-2.5 h-2.5 rounded-full border border-surface shadow-xs" :class="i <= item.efficiency ? 'bg-success' : 'bg-surface-muted'"></div>
                  </div>
                  <span class="text-[10px] font-black uppercase" :class="item.efficiency >= 4 ? 'text-success' : 'text-warning'">
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
  background: var(--color-border);
  border-radius: 10px;
}
</style>
