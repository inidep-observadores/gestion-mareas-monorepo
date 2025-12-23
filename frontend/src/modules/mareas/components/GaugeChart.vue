<template>
  <div
    class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 p-5 rounded-2xl shadow-sm h-full flex flex-col items-center justify-center text-center"
  >
    <div class="mb-2">
      <h3 class="text-sm font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
        {{ title }}
      </h3>
    </div>

    <div class="relative w-full max-w-[240px]">
      <VueApexCharts type="radialBar" height="280" :options="chartOptions" :series="[value]" />

      <!-- Over-target badge -->
      <div
        v-if="value >= 100"
        class="absolute top-[65%] left-1/2 -translate-x-1/2 bg-success-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full shadow-lg"
      >
        META ALCANZADA
      </div>
    </div>

    <div class="mt-[-20px] pb-4">
      <div class="flex items-center justify-center gap-1 text-2xl font-black" :class="colorClass">
        {{ value }}%
      </div>
      <p class="text-xs text-gray-400 mt-1">{{ subtitle }}</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import VueApexCharts from 'vue3-apexcharts'
import { CHART_COLORS, CHART_DEFAULTS } from '@/config/chartColors'

const props = defineProps({
  title: String,
  subtitle: String,
  value: {
    type: Number,
    default: 0,
  },
  colorType: {
    type: String,
    default: 'brand', // 'brand', 'success', 'warning', 'error'
  },
})

const colorMap = {
  brand: 'var(--color-brand-500)',
  success: 'var(--color-success-500)',
  warning: 'var(--color-warning-500)',
  error: 'var(--color-error-500)',
}

const colorClass = computed(() => {
  if (props.colorType === 'success') return 'text-success-600 dark:text-success-400'
  if (props.colorType === 'warning') return 'text-warning-600 dark:text-warning-400'
  if (props.colorType === 'error') return 'text-error-600 dark:text-error-400'
  return 'text-brand-600 dark:text-brand-400'
})

const chartOptions = computed(() => ({
  chart: {
    type: 'radialBar',
    offsetY: -10,
    fontFamily: CHART_DEFAULTS.fontFamily,
  },
  plotOptions: {
    radialBar: {
      startAngle: -135,
      endAngle: 135,
      hollow: {
        margin: 0,
        size: '70%',
        background: 'transparent',
      },
      track: {
        background: 'var(--color-gray-100)',
        strokeWidth: '100%',
        margin: 5,
      },
      dataLabels: {
        name: { show: false },
        value: {
          offsetY: 70,
          fontSize: '18px',
          fontWeight: '900',
          color: 'var(--color-gray-800)',
          show: false,
        },
      },
    },
  },
  colors: [colorMap[props.colorType as keyof typeof colorMap]],
  fill: {
    type: 'solid',
  },
  stroke: {
    lineCap: 'round',
  },
  grid: {
    borderColor: 'color-mix(in oklab, var(--color-gray-200) 40%, transparent)',
    padding: { top: 0, bottom: 0 },
  },
  tooltip: {
    theme: 'light',
  },
  labels: [props.title],
}))
</script>
