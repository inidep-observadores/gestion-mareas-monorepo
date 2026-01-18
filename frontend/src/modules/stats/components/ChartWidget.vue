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
import { useThemeStore } from '@/modules/shared/stores/theme.store'

const props = defineProps<{
  title: string
  subtitle?: string
  type?: 'line' | 'area' | 'bar' | 'pie' | 'donut' | 'radar'
  series: any[]
  options?: any
  allowDownload?: boolean
}>()

const themeStore = useThemeStore()

// Merit: Default chart options for premium look
const chartOptions = computed(() => {
  const isDark = themeStore.darkMode
  
  const defaults = {
    chart: {
      fontFamily: 'Inter, system-ui, sans-serif',
      background: 'transparent',
      toolbar: { show: false },
      zoom: { enabled: false },
      animations: { enabled: true }
    },
    dataLabels: { enabled: false },
    stroke: { 
      show: true,
      curve: 'smooth', 
      width: props.type === 'pie' || props.type === 'donut' ? 2 : 2,
      colors: props.type === 'pie' || props.type === 'donut' ? ['var(--color-surface)'] : undefined
    },
    grid: {
      borderColor: 'var(--color-border)',
      opacity: 0.1,
      strokeDashArray: 4,
      xaxis: { lines: { show: false } }
    },
    xaxis: {
      axisBorder: { show: false },
      axisTicks: { show: false },
      labels: { 
        style: { 
          colors: 'var(--color-text-muted)', 
          fontSize: '10px', 
          fontWeight: 600 
        } 
      }
    },
    yaxis: {
      labels: { 
        style: { 
          colors: 'var(--color-text-muted)', 
          fontSize: '10px', 
          fontWeight: 600 
        } 
      }
    },
    legend: {
      position: 'bottom',
      fontFamily: 'inherit',
      fontWeight: 700,
      labels: { colors: 'var(--color-text-muted)' },
      markers: { radius: 12, size: 5 }
    },
    theme: {
      mode: isDark ? 'dark' : 'light'
    },
    colors: ['#0ea5e9', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444', '#ec4899', '#6366f1'],
    tooltip: {
      enabled: true,
      theme: isDark ? 'dark' : 'light',
      custom: ({ series, seriesIndex, dataPointIndex, w }: any) => {
        const isSingleArray = series.length > 0 && !Array.isArray(series[0]);
        let val, label, color;

        if (props.type === 'pie' || props.type === 'donut') {
          val = series[seriesIndex];
          label = w.globals.labels[seriesIndex];
          color = w.globals.colors[seriesIndex];
        } else {
          val = series[seriesIndex][dataPointIndex];
          label = w.globals.labels[dataPointIndex];
          color = w.globals.colors[seriesIndex];
        }

        const unit = props.type === 'bar' && w.config.series[seriesIndex]?.name === 'Mareas Iniciadas' ? 'mareas' : 'días';

        return `
          <div class="px-3 py-2 bg-surface text-text border border-border rounded-xl flex items-center gap-2 text-[11px] font-bold shadow-xl">
            <span class="w-2.5 h-2.5 rounded-full" style="background:${color}"></span>
            <span class="text-text-muted uppercase tracking-widest">${label}</span>
            <span class="text-text font-black">${val?.toLocaleString()} ${unit}</span>
          </div>
        `;
      }
    },
    plotOptions: {
      pie: {
        expandOnClick: true,
        donut: {
          size: '55%',
          labels: {
            show: props.type === 'donut',
            name: { 
              show: true, 
              color: 'var(--color-text-muted)',
              fontSize: '11px',
              fontWeight: 900,
              offsetY: -8
            },
            value: { 
              show: true, 
              color: 'var(--color-text)', 
              fontSize: '22px',
              fontWeight: 900,
              offsetY: 10,
              formatter: (val: string) => parseInt(val).toLocaleString()
            },
            total: {
              show: true,
              label: 'TOTAL',
              color: 'var(--color-text-muted)',
              fontSize: '9px',
              fontWeight: 900,
              formatter: (w: any) => {
                return w.globals.seriesTotals.reduce((a: number, b: number) => a + b, 0).toLocaleString()
              }
            }
          }
        }
      }
    }
  }
  
  return { ...defaults, ...props.options }
})
</script>

<style scoped>
:deep(.apexcharts-tooltip) {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
}
:deep(.apexcharts-tooltip-series-group) {
  background: transparent !important;
}
</style>
