<template>
  <div class="relative w-24 h-24 mb-2 flex items-center justify-center transition-all overflow-visible z-20 pointer-events-none" @click.stop>
    <apexchart
      type="pie"
      height="96"
      width="96"
      class="pointer-events-none"
      :options="chartOptions"
      :series="composition.series"
    />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
const props = defineProps<{
  observers: any[]
}>()

const emit = defineEmits(['select-category'])

// Lógica de composición reutilizable
const composition = computed(() => {
  const stats = {
    titulares: 0,
    femTitular: 0,
    femEventual: 0,
    otrosEventuales: 0,
    designados: 0
  }

  props.observers.forEach((obs: any) => {
    if (obs.tieneDesignacionActiva) {
      stats.designados++
      return
    }
    
    const isFem = obs.sexo === 'Femenino'
    const isEventual = obs.eventual === true

    if (!isEventual && !isFem) stats.titulares++
    else if (!isEventual && isFem) stats.femTitular++
    else if (isEventual && isFem) stats.femEventual++
    else if (isEventual && !isFem) stats.otrosEventuales++
  })

  return {
    series: [stats.titulares, stats.femTitular, stats.femEventual, stats.otrosEventuales, stats.designados],
    labels: ['Titulares', 'Fem. Titular', 'Fem. Eventual', 'Otros Eventuales', 'Designados']
  }
})

const chartOptions = computed(() => ({
  chart: {
    type: 'pie',
    width: 96,
    height: 96,
    background: 'transparent',
    sparkline: { enabled: true },
    animations: { enabled: true, easing: 'easeinout', speed: 800 },
    events: {
      dataPointSelection: (event: any, chartContext: any, config: any) => {
        const category = composition.value.labels[config.dataPointIndex]
        if (category) {
          emit('select-category', category)
        }
      }
    }
  },
  colors: ['#22c55e', '#ec4899', '#fb7185', '#94a3b8', '#38bdf8'],
  labels: composition.value.labels,
  stroke: { 
    show: true, 
    width: 1, 
    colors: ['#ffffff'] // Borde blanco muy fino para delimitación nítida
  },
  plotOptions: {
    pie: {
      expandOnClick: true,
      dataLabels: {
        offset: -5, // Move labels slightly inside
        minAngleToShowLabel: 10
      }
    }
  },
  dataLabels: { 
    enabled: true,
    style: {
      fontSize: '11px',
      fontFamily: 'Inter, sans-serif',
      fontWeight: '800',
      colors: ['#0f172a'] // Un azul muy oscuro casi negro, fijo
    },
    dropShadow: {
      enabled: false // Quitar la sombra pesada que ensucia el diseño
    },
    formatter: function (val: any, opts: any) {
      // Solo mostrar si el valor es mayor a 0 para no ensuciar el gráfico
      const value = opts.w.globals.series[opts.seriesIndex]
      return value > 0 ? value : ''
    }
  },
  tooltip: {
    enabled: false
  },
  theme: {
    monochrome: {
      enabled: false
    }
  },
  legend: { show: false }
}))
</script>

<style scoped>
.chart-container-overflow {
  overflow: visible !important;
}

:deep(.apexcharts-canvas) {
  overflow: visible !important;
  pointer-events: none !important;
}

:deep(.apexcharts-canvas svg) {
  overflow: visible !important;
  pointer-events: none !important;
}

:deep(.apexcharts-series),
:deep(.apexcharts-datalabels),
:deep(.apexcharts-pie-series) {
  pointer-events: auto !important;
}

:deep(.apexcharts-series path) {
  pointer-events: auto !important;
  cursor: pointer;
}

/* Forzar color oscuro en las etiquetas ignorando el tema de ApexCharts */
:deep(.apexcharts-datalabels text),
:deep(.apexcharts-datalabels-group text),
:deep(.apexcharts-data-labels text) {
  fill: #0f172a !important;
  color: #0f172a !important;
  filter: none !important;
}
</style>
