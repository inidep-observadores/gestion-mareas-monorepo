<template>
  <div
    class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-6 rounded-2xl shadow-sm"
  >
    <div class="flex items-center justify-between mb-6">
      <div>
        <h3 class="text-lg font-bold text-gray-800 dark:text-white/90">
          Flujo de Trabajo (Hitos de Marea)
        </h3>
        <p class="text-xs text-gray-500 dark:text-gray-400">
          Seguimiento de tiempos de proceso (SLA: 10 días)
        </p>
      </div>
      <div class="flex gap-2">
        <span class="flex items-center gap-1 text-[10px] font-medium text-gray-500">
          <span class="w-2 h-2 rounded-full border border-gray-300"></span> Normal
        </span>
        <span class="flex items-center gap-1 text-[10px] font-medium text-error-500">
          <span class="w-2 h-2 rounded-full bg-error-500"></span> Fuera de SLA
        </span>
      </div>
    </div>

    <div class="relative min-h-[300px]">
      <VueApexCharts type="bar" height="320" :options="chartOptions" :series="series" />
    </div>

    <div class="mt-4 grid grid-cols-1 md:grid-cols-3 gap-4">
      <div
        v-for="(metric, index) in slaMetrics"
        :key="index"
        :class="[
          'p-3 rounded-xl border transition-all duration-200',
          metric.exceeds
            ? 'bg-error-50 border-error-100 dark:bg-error-500/5 dark:border-error-500/20'
            : 'bg-gray-50 border-gray-100 dark:bg-white/5 dark:border-white/10',
        ]"
      >
        <div
          class="text-[10px] uppercase font-bold text-gray-400 dark:text-gray-500 mb-1 leading-tight"
        >
          {{ metric.label }}
        </div>
        <div class="flex items-baseline gap-2">
          <span
            :class="[
              'text-xl font-bold',
              metric.exceeds
                ? 'text-error-600 dark:text-error-400'
                : 'text-gray-800 dark:text-white',
            ]"
          >
            {{ metric.value }} <span class="text-xs font-normal">días</span>
          </span>
          <span
            v-if="metric.exceeds"
            class="text-[10px] font-medium bg-error-100 text-error-700 px-1.5 py-0.5 rounded-full dark:bg-error-500/20 dark:text-error-400"
          >
            ! RETRASO
          </span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import VueApexCharts from 'vue3-apexcharts'
import { CHART_COLORS, CHART_DEFAULTS } from '@/config/chartColors'

const props = defineProps({
  data: {
    type: Object,
    default: () => ({
      entrega: 12,
      informe: 8,
      protocolo: 15,
    }),
  },
})

const slaLimit = 10

const slaMetrics = computed(() => [
  {
    label: 'Fin -> Entrega Material',
    value: props.data.entrega,
    exceeds: props.data.entrega > slaLimit,
  },
  {
    label: 'Entrega -> Informe Final',
    value: props.data.informe,
    exceeds: props.data.informe > slaLimit,
  },
  {
    label: 'Informe -> Protocolización',
    value: props.data.protocolo,
    exceeds: props.data.protocolo > slaLimit,
  },
])

const series = [
  {
    name: 'Días promedio',
    data: [props.data.entrega, props.data.informe, props.data.protocolo],
  },
]

const chartOptions = {
  chart: {
    type: 'bar',
    toolbar: { show: false },
    fontFamily: CHART_DEFAULTS.fontFamily,
    zoom: { enabled: false },
  },
  plotOptions: {
    bar: {
      horizontal: true,
      columnWidth: '16px',
      borderRadius: 4,
      borderRadiusApplication: 'end',
      distributed: true,
      dataLabels: { position: 'top' },
    },
  },
  colors: [
    props.data.entrega > slaLimit ? 'var(--color-error-500)' : 'var(--color-brand-500)',
    props.data.informe > slaLimit ? 'var(--color-error-500)' : 'var(--color-brand-500)',
    props.data.protocolo > slaLimit ? 'var(--color-error-500)' : 'var(--color-brand-500)',
  ],
  dataLabels: {
    enabled: true,
    formatter: function (val: number) {
      return val + ' d'
    },
    offsetX: -20,
    style: {
      fontSize: '11px',
      fontWeight: 700,
      colors: ['#fff'],
    },
  },
  xaxis: {
    categories: ['Entrega Material', 'Informe Final', 'Protocolización'],
    axisBorder: { show: false },
    axisTicks: { show: false },
    labels: {
      style: {
        colors: 'var(--color-gray-500)',
        fontSize: '12px',
        fontWeight: 400,
      },
    },
  },
  yaxis: {
    labels: {
      align: 'left',
      minWidth: 0,
      style: {
        colors: 'var(--color-gray-700)',
        fontSize: '12px',
        fontWeight: 600,
      },
    },
  },
  grid: {
    borderColor: 'color-mix(in oklab, var(--color-gray-200) 40%, transparent)',
    strokeDashArray: 4,
    xaxis: { lines: { show: true } },
    padding: { top: 0, bottom: 0, right: 30 },
  },
  states: {
    hover: {
      filter: { type: 'darken', value: 0.9 },
    },
  },
  tooltip: {
    theme: 'light',
    y: {
      formatter: (val: number) => val + ' días',
    },
  },
  legend: { show: false },
}
</script>
