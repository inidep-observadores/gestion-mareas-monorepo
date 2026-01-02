<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 flex flex-col gap-4">
    <div class="mb-6 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-gray-900 dark:text-white uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-emerald-500 rounded-full"></div>
          Flota por Pesquería
        </h2>
        <span class="text-[10px] font-bold text-gray-500 dark:text-gray-400">Distribución de buques activos</span>
      </div>
      <div class="text-right">
        <span class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total Activo</span>
        <p class="text-sm font-black text-gray-900 dark:text-white">{{ totalActive }} buques</p>
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 items-start">
      <div class="flex flex-col items-center justify-center">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">Proporción</h3>
        <div class="w-full flex justify-center">
          <apexchart type="donut" height="240" :options="chartOptions" :series="series" />
        </div>
      </div>

      <div class="flex flex-col justify-center py-2">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4 border-b border-gray-50 dark:border-gray-800/50 pb-2">Distribución Nominal</h3>
        <div class="space-y-4" v-if="distribution.length">
          <div v-for="item in distribution" :key="item.label" class="group/item">
            <div 
              @click="toggleExpand(item.label)"
              class="space-y-2 p-2 rounded-2xl transition-all cursor-pointer hover:bg-gray-50/80 dark:hover:bg-gray-800/40"
              :class="{ 'bg-gray-50 dark:bg-gray-800/60 shadow-sm ring-1 ring-gray-100 dark:ring-gray-700/50': expandedId === item.label }"
            >
              <div class="flex items-center justify-between text-[10px] font-black uppercase tracking-widest">
                <div class="flex items-center gap-2">
                  <span class="text-gray-500 dark:text-gray-400 transition-colors" :class="{ 'text-emerald-500': expandedId === item.label }">{{ item.label }}</span>
                  <div 
                    class="w-4 h-4 rounded-full flex items-center justify-center transition-transform duration-300"
                    :class="{ 'rotate-180 bg-emerald-500 text-white': expandedId === item.label, 'bg-gray-100 dark:bg-gray-700 text-gray-400': expandedId !== item.label }"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>
                  </div>
                </div>
                <span class="text-gray-900 dark:text-white tabular-nums">
                  {{ item.count }}
                  <span class="text-gray-400 font-bold ml-1">({{ item.percentage }}%)</span>
                </span>
              </div>
              <div class="relative h-1.5 w-full bg-gray-100 dark:bg-gray-800 rounded-full overflow-hidden border border-gray-100/50 dark:border-gray-700/30">
                <div
                  class="h-full transition-all duration-1000 ease-out shadow-sm"
                  :style="{
                    width: totalActive ? `${(item.count / totalActive) * 100}%` : '0%',
                    backgroundColor: item.color
                  }"
                ></div>
              </div>

              <!-- Draggable/Scrollable Vessel Cloud -->
              <Transition
                enter-active-class="transition-all duration-300 ease-out"
                enter-from-class="max-h-0 opacity-0 transform -translate-y-2"
                enter-to-class="max-h-40 opacity-100 transform translate-y-0"
                leave-active-class="transition-all duration-200 ease-in"
                leave-from-class="max-h-40 opacity-100 transform translate-y-0"
                leave-to-class="max-h-0 opacity-0 transform -translate-y-2"
              >
                <div v-if="expandedId === item.label" class="pt-3 overflow-hidden">
                  <div class="flex flex-wrap gap-1.5 max-h-32 overflow-y-auto custom-scrollbar-mini pr-1">
                    <span 
                      v-for="vessel in item.vessels" 
                      :key="vessel.name"
                      class="px-2 py-0.5 rounded-lg bg-white dark:bg-gray-700 border border-gray-100 dark:border-gray-600 shadow-sm text-[10px] font-bold text-gray-600 dark:text-gray-300 uppercase tracking-tighter hover:border-emerald-500/50 hover:text-emerald-500 transition-colors"
                    >
                      {{ vessel.name }} <span class="text-[9px] opacity-60 ml-0.5">({{ vessel.mareaCode }})</span>
                    </span>
                  </div>
                </div>
              </Transition>
            </div>
          </div>
        </div>
        <div v-else class="text-center text-xs font-bold text-gray-400">No hay datos para mostrar</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { useTheme } from '@/components/layout/ThemeProvider.vue'
import dashboardService from '@/modules/dashboard/services/dashboard.service'

type FleetDisplayItem = {
  label: string
  count: number
  color: string
  percentage: number
  vessels: Array<{ name: string; mareaCode: string }>
}

const distribution = ref<FleetDisplayItem[]>([])
const expandedId = ref<string | null>(null)
const palette = ['#6366f1', '#3b82f6', '#10b981', '#f97316', '#facc15', '#a855f7']

const { isDarkMode } = useTheme() as { isDarkMode: { value: boolean } }

const toggleExpand = (label: string) => {
  expandedId.value = expandedId.value === label ? null : label
}

const totalActive = computed(() => distribution.value.reduce((sum, item) => sum + item.count, 0))
const series = computed(() => distribution.value.map((item) => item.count))
const chartColors = computed(() =>
  distribution.value.map((item, index) => item.color || palette[index % palette.length])
)

const chartOptions = computed(() => ({
  chart: {
    fontFamily: 'inherit',
    toolbar: { show: false },
    animations: { enabled: true, easing: 'easeinout', speed: 800 },
    background: 'transparent'
  },
  theme: {
    mode: isDarkMode.value ? 'dark' : 'light'
  },
  labels: distribution.value.map((item) => item.label),
  colors: chartColors.value,
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
            formatter: () => totalActive.value
          }
        }
      }
    }
  },
  dataLabels: { enabled: false },
  legend: {
    show: distribution.value.length > 0,
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
    custom: ({ series, seriesIndex, w }: any) => {
      const val = series[seriesIndex]
      const label = w.globals.labels[seriesIndex]
      const bg = isDarkMode.value ? 'bg-gray-900 text-gray-100 border border-gray-700/80' : 'bg-white text-gray-900 border border-gray-200/80'
      const accent = chartColors.value[seriesIndex] || '#6366f1'
      return `
        <div class="px-3 py-2 ${bg} rounded-xl flex items-center gap-2 text-[11px] font-bold shadow-none">
          <span class="w-2 h-2 rounded-full" style="background:${accent}"></span>
          <span class="text-gray-500 dark:text-gray-400 uppercase tracking-widest">${label}</span>
          <span class="text-gray-900 dark:text-gray-50 font-black">${val} buques</span>
        </div>
      `
    }
  }
}))

const loadDistribution = async () => {
  try {
    const { total, distribution: data } = await dashboardService.getFleetDistribution()
    const sorted = [...data].sort((a, b) => b.count - a.count)

    distribution.value = sorted.map((item, index) => ({
      label: item.label,
      count: item.count,
      color: palette[index % palette.length],
      percentage: total > 0 ? Math.round((item.count / total) * 100) : 0,
      vessels: item.vessels || []
    }))
  } catch (error) {
    toast.error('No se pudo cargar la distribución por pesquería.')
  }
}

onMounted(() => void loadDistribution())
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #f1f5f9;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}

.custom-scrollbar-mini::-webkit-scrollbar {
  width: 2px;
}
.custom-scrollbar-mini::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar-mini::-webkit-scrollbar-thumb {
  background: #e2e8f0;
  border-radius: 10px;
}
.dark .custom-scrollbar-mini::-webkit-scrollbar-thumb {
  background: #334155;
}

:deep(.apexcharts-tooltip) {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}
:deep(.apexcharts-tooltip-series-group) {
  background: transparent !important;
}
</style>
