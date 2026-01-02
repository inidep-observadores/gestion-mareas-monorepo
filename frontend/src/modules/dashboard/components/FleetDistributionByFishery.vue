<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
    <div class="mb-8 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-indigo-500 rounded-full"></div>
          Flota por Pesquería
        </h2>
        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-tighter mt-1">Análisis comparativo de la flota</p>
      </div>
      <div class="text-right">
         <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest block">Total Activa</span>
         <span class="text-sm font-black text-gray-900 dark:text-white">34 Buques</span>
      </div>
    </div>

    <div class="flex-1 grid grid-cols-1 lg:grid-cols-2 gap-10 items-center">
      <!-- Donut View -->
      <div class="flex flex-col items-center justify-center min-h-[260px]">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">Proporción</h3>
        <div class="w-full flex justify-center">
          <apexchart
            type="donut"
            height="280"
            :options="chartOptions"
            :series="series"
          />
        </div>
      </div>

      <!-- Bar View -->
      <div class="flex flex-col h-full justify-center py-4">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-50 dark:border-gray-800/50 pb-2">Distribución Nominal</h3>
        <div class="space-y-6">
          <div v-for="item in distribution" :key="item.label" class="space-y-2 group">
            <div class="flex items-center justify-between text-[10px] font-black uppercase tracking-widest">
               <span class="text-gray-500 dark:text-gray-400 group-hover:text-indigo-500 transition-colors">{{ item.label }}</span>
               <span class="text-gray-900 dark:text-white tabular-nums">{{ item.count }} <span class="text-gray-400 font-bold ml-1">({{ Math.round((item.count/34)*100) }}%)</span></span>
            </div>
            <div class="relative h-2 w-full bg-gray-50 dark:bg-gray-800/50 rounded-full overflow-hidden border border-gray-100/50 dark:border-gray-700/30">
               <div 
                 class="h-full transition-all duration-1000 ease-out shadow-sm"
                 :style="{ width: (item.count/34*100) + '%', backgroundColor: item.color }"
               ></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useTheme } from '@/components/layout/ThemeProvider.vue'

const { isDarkMode } = useTheme() as { isDarkMode: { value: boolean } }

const distribution = [
  { label: 'Langostino', count: 18, color: '#6366f1' },
  { label: 'Merluza', count: 10, color: '#3b82f6' },
  { label: 'Calamar', count: 4, color: '#10b981' },
  { label: 'Otras', count: 2, color: '#94a3b8' },
]

const series = computed(() => distribution.map(d => d.count))

const chartOptions = computed(() => ({
  chart: {
    fontFamily: 'inherit',
    toolbar: { show: false },
    animations: {
      enabled: true,
      easing: 'easeinout',
      speed: 800,
    },
    background: 'transparent'
  },
  theme: {
    mode: isDarkMode.value ? 'dark' : 'light'
  },
  labels: distribution.map(d => d.label),
  colors: distribution.map(d => d.color),
  stroke: {
    show: true,
    width: 3,
    colors: [isDarkMode.value ? '#111827' : '#ffffff']
  },
  plotOptions: {
    pie: {
      donut: {
        size: '72%',
        labels: {
          show: true,
          name: {
            show: true,
            fontSize: '11px',
            fontWeight: 900,
            color: isDarkMode.value ? '#94a3b8' : '#64748b',
            offsetY: -8
          },
          value: {
            show: true,
            fontSize: '22px',
            fontWeight: 900,
            color: isDarkMode.value ? '#f3f4f6' : '#1e293b',
            offsetY: 10,
            formatter: (val: string) => val
          },
          total: {
            show: true,
            label: 'BUQUES',
            fontSize: '9px',
            fontWeight: 900,
            color: '#94a3b8',
            formatter: (w: any) => w.globals.seriesTotals.reduce((a: number, b: number) => a + b, 0)
          }
        }
      }
    }
  },
  dataLabels: { enabled: false },
  legend: {
    show: true,
    position: 'bottom',
    fontSize: '10px',
    fontWeight: 700,
    itemMargin: { horizontal: 5, vertical: 8 },
    markers: { radius: 12, size: 5, offsetX: -2 },
    labels: {
      colors: isDarkMode.value ? '#94a3b8' : '#64748b'
    }
  },
  tooltip: {
    enabled: true,
    theme: isDarkMode.value ? 'dark' : 'light',
    style: {
      fontSize: '11px',
    },
    y: {
      formatter: (val: number) => `${val} Buques`
    },
    marker: {
      show: true,
    },
    custom: function({ series, seriesIndex, dataPointIndex, w }: any) {
      const color = w.globals.colors[seriesIndex];
      const label = w.globals.labels[seriesIndex];
      const val = series[seriesIndex];
      return `
        <div class="px-3 py-2 bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-700 shadow-xl rounded-xl flex items-center gap-3">
          <div class="w-2 h-2 rounded-full" style="background-color: ${color}"></div>
          <span class="text-[10px] font-black uppercase tracking-widest text-gray-500 dark:text-gray-400">${label}:</span>
          <span class="text-xs font-black text-gray-900 dark:text-white">${val} Buques</span>
        </div>
      `;
    }
  }
}))
</script>

<style scoped>
/* Eliminar sombras y bordes feos por defecto de ApexCharts */
:deep(.apexcharts-tooltip) {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}
</style>
