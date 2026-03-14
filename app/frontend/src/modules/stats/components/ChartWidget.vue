<template>
  <div class="bg-surface rounded-2xl border border-border shadow-theme-xs p-6 flex flex-col h-full">
    <div class="flex items-center justify-between mb-6">
      <div>
        <h3 class="text-sm font-black text-text uppercase tracking-tight">{{ title }}</h3>
        <p v-if="subtitle" class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1">{{ subtitle }}
        </p>
      </div>
      <div class="flex items-center gap-1">
        <slot name="header-action"></slot>
        <ExportExcelButton 
          v-if="allowDownload"
          title="Descargar Datos"
          @click="$emit('download')"
        />
      </div>
    </div>

    <!-- Chart Container -->
    <div :class="['flex-1 min-h-[300px] w-full relative', chartContainerClass]">
      <apexchart v-if="options && series" :type="type" :height="chartHeight" width="100%" :options="chartOptions"
        :series="series" />
      <div v-else class="absolute inset-0 flex items-center justify-center text-text-muted text-xs font-medium">
        Cargando datos...
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { DownloadIcon } from 'lucide-vue-next'
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';
import { useThemeStore } from '@/modules/shared/stores/theme.store'

const props = withDefaults(defineProps<{
  title: string
  subtitle?: string
  type?: 'line' | 'area' | 'bar' | 'pie' | 'donut' | 'radar' | 'scatter' | 'rangeBar'
  series: any[]
  options?: any
  allowDownload?: boolean
  chartHeight?: string | number
  chartContainerClass?: string
  exportFilename?: string
}>(), {
  type: 'line',
  chartHeight: '100%',
  chartContainerClass: ''
})

const themeStore = useThemeStore()

const emit = defineEmits(['dataPointClick', 'download'])

// Merit: Default chart options for premium look
const chartOptions = computed(() => {
  const isDark = themeStore.darkMode

  const defaults = {
    chart: {
      fontFamily: 'Inter, system-ui, sans-serif',
      background: 'transparent',
      toolbar: {
        show: false,
        export: {
          csv: { filename: props.exportFilename },
          svg: { filename: props.exportFilename },
          png: { filename: props.exportFilename },
        }
      },
      zoom: { enabled: false },
      animations: { enabled: true },
      // Localization: Spanish by default
      defaultLocale: 'es',
      locales: [{
        name: 'es',
        options: {
          months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
          shortMonths: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
          days: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
          shortDays: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
          toolbar: {
            download: 'Descargar SVG',
            selection: 'Selección',
            selectionZoom: 'Zoom de Selección',
            zoomIn: 'Acercar',
            zoomOut: 'Alejar',
            pan: 'Desplazamiento',
            reset: 'Restablecer Zoom',
            menu: 'Menú',
            exportToSVG: 'Descargar SVG',
            exportToPNG: 'Descargar PNG',
            exportToCSV: 'Descargar CSV',
          }
        }
      }],
      events: {
        dataPointSelection: (event: any, chartContext: any, config: any) => {
          // Check if the click came from a legend item (labels or markers)
          const target = event?.target;
          const isLegend = target && (
            target.closest('.apexcharts-legend') ||
            target.classList.contains('apexcharts-legend-text') ||
            target.classList.contains('apexcharts-legend-marker')
          );

          if (isLegend) return;

          const { seriesIndex, dataPointIndex, w } = config
          // Safeguard: Only emit click if a real data point was selected
          if (dataPointIndex !== undefined && dataPointIndex !== -1) {
            const label = w.globals.labels[dataPointIndex]
            const value = w.globals.series[seriesIndex][dataPointIndex] || w.globals.series[seriesIndex]
            emit('dataPointClick', { label, value, seriesIndex, dataPointIndex, w })
          }
        }
      }
    },
    dataLabels: { enabled: false },
    stroke: {
      show: true,
      curve: 'smooth',
      width: props.type === 'pie' || props.type === 'donut' ? 2 : 2,
      colors: props.type === 'pie' || props.type === 'donut' ? ['#ffffff'] : undefined // color-surface
    },
    grid: {
      borderColor: '#e2e8f0', // color-border
      opacity: 0.1,
      strokeDashArray: 4,
      xaxis: { lines: { show: false } }
    },
    xaxis: {
      axisBorder: { show: false },
      axisTicks: { show: false },
      labels: {
        style: {
          colors: '#64748b', // color-text-muted
          fontSize: '10px',
          fontWeight: 600
        }
      }
    },
    yaxis: {
      labels: {
        style: {
          colors: '#64748b', // color-text-muted
          fontSize: '10px',
          fontWeight: 600
        }
      }
    },
    legend: {
      position: 'bottom',
      fontFamily: 'inherit',
      fontWeight: 700,
      labels: { colors: '#64748b' }, // color-text-muted
      markers: { radius: 12, size: 5 }
    },
    theme: {
      mode: isDark ? 'dark' : 'light'
    },
    colors: ['#0ea5e9', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444', '#ec4899', '#6366f1'],
    tooltip: {
      enabled: true,
      theme: isDark ? 'dark' : 'light',
      custom: props.options?.tooltip?.custom || (({ series, seriesIndex, dataPointIndex, w }: any) => {
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
      })
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

  // Manual Deep Merge for 'chart' object to preserve locales
  const mergedOptions = { ...defaults, ...props.options };

  // Forzar la configuración de exportación y locales
  mergedOptions.chart = {
    ...defaults.chart,
    ...(props.options?.chart || {}),
    toolbar: {
      ...(defaults.chart.toolbar || {}),
      ...(props.options?.chart?.toolbar || {}),
      export: {
        csv: { filename: props.exportFilename },
        svg: { filename: props.exportFilename },
        png: { filename: props.exportFilename },
      }
    },
    locales: props.options?.chart?.locales || defaults.chart.locales,
    defaultLocale: props.options?.chart?.defaultLocale || defaults.chart.defaultLocale,
    events: {
      ...defaults.chart.events,
      ...(props.options?.chart?.events || {})
    }
  };

  return mergedOptions;
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
