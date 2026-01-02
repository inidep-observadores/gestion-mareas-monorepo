<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-blue-500 rounded-full"></div>
          Tendencias Históricas
        </h2>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter mt-1">Evolución temporal del esfuerzo de observación</p>
      </div>
      <div class="flex gap-2">
         <select class="text-[10px] font-black uppercase tracking-widest bg-gray-50 dark:bg-gray-800 border-none rounded-lg px-3 py-1 text-gray-500 dark:text-gray-400 focus:ring-1 ring-indigo-500/50">
           <option>Mareas vs Informes</option>
           <option>Volumen de Datos</option>
         </select>
      </div>
    </div>

    <div class="flex-1 min-h-[300px]">
      <apexchart
        type="area"
        height="100%"
        :options="chartOptions"
        :series="series"
      />
    </div>

    <div class="mt-6 flex items-center gap-6">
       <div class="flex items-center gap-2">
          <div class="w-3 h-3 rounded bg-blue-500"></div>
          <span class="text-[10px] font-black text-gray-500 uppercase tracking-widest">Mareas Iniciadas</span>
       </div>
       <div class="flex items-center gap-2">
          <div class="w-3 h-3 rounded bg-indigo-500"></div>
          <span class="text-[10px] font-black text-gray-500 uppercase tracking-widest">Informes Protocolizados</span>
       </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useTheme } from '@/components/layout/ThemeProvider.vue'

const { isDarkMode } = useTheme() as { isDarkMode: { value: boolean } }

const series = [
  {
    name: 'Mareas Iniciadas',
    data: [31, 40, 28, 51, 42, 109, 100, 120, 80, 95, 110, 130]
  },
  {
    name: 'Informes Protocolizados',
    data: [11, 32, 45, 32, 34, 52, 41, 80, 60, 70, 85, 105]
  }
]

const chartOptions = computed(() => ({
  chart: {
    fontFamily: 'inherit',
    toolbar: { show: false },
    animations: { enabled: true }
  },
  colors: ['#3b82f6', '#6366f1'],
  stroke: { curve: 'smooth', width: 3 },
  fill: {
    type: 'gradient',
    gradient: {
      shadeIntensity: 1,
      opacityFrom: 0.3,
      opacityTo: 0.1,
      stops: [0, 90, 100]
    }
  },
  xaxis: {
    categories: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
    axisBorder: { show: false },
    axisTicks: { show: false },
    labels: {
      style: {
        colors: isDarkMode.value ? '#94a3b8' : '#64748b',
        fontSize: '10px',
        fontWeight: 700
      }
    }
  },
  yaxis: {
    labels: {
      style: {
        colors: isDarkMode.value ? '#94a3b8' : '#64748b',
        fontSize: '10px',
        fontWeight: 700
      }
    }
  },
  grid: {
    borderColor: isDarkMode.value ? '#1f2937' : '#f3f4f6',
    strokeDashArray: 4
  },
  tooltip: {
    theme: isDarkMode.value ? 'dark' : 'light',
    style: { fontSize: '12px' }
  },
  legend: { show: false },
  dataLabels: { enabled: false }
}))
</script>
