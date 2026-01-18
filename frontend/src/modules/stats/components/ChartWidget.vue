<template>
  <div class="bg-surface rounded-2xl border border-border shadow-theme-xs p-6 flex flex-col h-full">
    <div class="flex items-center justify-between mb-6">
      <div>
        <h3 class="text-sm font-black text-text uppercase tracking-tight">{{ title }}</h3>
        <p v-if="subtitle" class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1">{{ subtitle }}</p>
      </div>
      <button 
        v-if="allowDownload" 
        class="text-text-muted hover:text-primary transition-colors p-1"
        title="Descargar Datos"
      >
        <DownloadIcon class="w-4 h-4" />
      </button>
    </div>

    <!-- Chart Container -->
    <div class="flex-1 min-h-[300px] w-full relative">
       <apexchart 
         v-if="options && series"
         :type="type" 
         height="100%"
         width="100%"
         :options="chartOptions" 
         :series="series"
       />
       <div v-else class="absolute inset-0 flex items-center justify-center text-text-muted text-xs font-medium">
         Cargando datos...
       </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { DownloadIcon } from 'lucide-vue-next'
// Note: Global ApexCharts registration assumed or we import locally if needed
// Usually <apexchart> is global component from vue3-apexcharts plugin

const props = defineProps<{
  title: string
  subtitle?: string
  type?: 'line' | 'area' | 'bar' | 'pie' | 'donut' | 'radar'
  series: any[]
  options?: any
  allowDownload?: boolean
}>()

// Merit: Default chart options for premium look
const chartOptions = computed(() => {
  const defaults = {
    chart: {
      fontFamily: 'inherit',
      toolbar: { show: false },
      zoom: { enabled: false },
      animations: { enabled: true }
    },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 2 },
    grid: {
      borderColor: 'rgba(var(--color-border), 0.3)',
      strokeDashArray: 4,
      xaxis: { lines: { show: false } }
    },
    xaxis: {
      axisBorder: { show: false },
      axisTicks: { show: false },
      labels: { style: { colors: 'rgba(var(--color-text-muted), 1)', fontSize: '10px', fontWeight: 600 } }
    },
    yaxis: {
      labels: { style: { colors: 'rgba(var(--color-text-muted), 1)', fontSize: '10px', fontWeight: 600 } }
    },
    legend: {
      position: 'bottom',
      fontFamily: 'inherit',
      fontWeight: 600,
      labels: { colors: 'rgba(var(--color-text), 1)' }
    },
    theme: {
      mode: 'light', // TODO: Make dynamic with system theme
      palette: 'palette1' 
    },
    colors: ['#0ea5e9', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444'] // Tailwind colors: sky-500, violet-500, emerald-500, amber-500, red-500
  }
  
  return { ...defaults, ...props.options }
})
</script>
