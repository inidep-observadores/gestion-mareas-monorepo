<template>
  <div class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm dark:border-gray-800 dark:bg-gray-900 h-full flex flex-col">
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

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-10 items-start">
      <div class="flex flex-col items-center justify-center min-h-[260px]">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">Proporción</h3>
        <div class="w-full flex justify-center">
          <apexchart type="donut" height="280" :options="chartOptions" :series="series" />
        </div>
      </div>

      <div class="flex flex-col h-full justify-center py-4">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-6 border-b border-gray-50 dark:border-gray-800/50 pb-2">Distribución Nominal</h3>
        <div class="space-y-6" v-if="distribution.length">
          <div v-for="item in distribution" :key="item.label" class="space-y-2 group">
            <div class="flex items-center justify-between text-[10px] font-black uppercase tracking-widest">
              <span class="text-gray-500 dark:text-gray-400 group-hover:text-emerald-500 transition-colors">{{ item.label }}</span>
              <span class="text-gray-900 dark:text-white tabular-nums">
                {{ item.count }}
                <span class="text-gray-400 font-bold ml-1">({{ item.percentage }}%)</span>
              </span>
            </div>
            <div class="relative h-2 w-full bg-gray-50 dark:bg-gray-800/50 rounded-full overflow-hidden border border-gray-100/50 dark:border-gray-700/30">
              <div
                class="h-full transition-all duration-1000 ease-out shadow-sm"
                :style="{
                  width: totalActive ? `${(item.count / totalActive) * 100}%` : '0%',
                  backgroundColor: item.color
                }"
              ></div>
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
}

const distribution = ref<FleetDisplayItem[]>([])
const palette = ['#6366f1', '#3b82f6', '#10b981', '#f97316', '#facc15', '#a855f7']

const { isDarkMode } = useTheme() as { isDarkMode: { value: boolean } }

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
      percentage: total > 0 ? Math.round((item.count / total) * 100) : 0
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

:deep(.apexcharts-tooltip) {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}
:deep(.apexcharts-tooltip-series-group) {
  background: transparent !important;
}
</style>
