<template>
  <div
    class="bg-surface border border-border p-5 rounded-2xl shadow-sm h-full flex flex-col items-center justify-center text-center"
  >
    <div class="mb-2">
      <h3 class="text-sm font-bold text-text-muted uppercase tracking-wider">
        {{ title }}
      </h3>
    </div>

    <div class="relative w-full max-w-[240px]">
      <VueApexCharts type="radialBar" height="280" :options="chartOptions" :series="[value]" />

      <!-- Over-target badge -->
      <div
        v-if="value >= 100"
        class="absolute top-[65%] left-1/2 -translate-x-1/2 bg-success text-success-fg text-[10px] font-bold px-2 py-0.5 rounded-full shadow-lg"
      >
        META ALCANZADA
      </div>
    </div>

    <div class="mt-[-20px] pb-4">
      <div class="flex items-center justify-center gap-1 text-2xl" :class="colorClass">
        {{ value }}%
      </div>
      <p class="text-xs text-text-muted mt-1">{{ subtitle }}</p>
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
  brand: 'var(--color-primary)',
  success: 'var(--color-success)',
  warning: 'var(--color-warning)',
  error: 'var(--color-error)',
}

const colorClass = computed(() => {
  if (props.colorType === 'success') return 'text-success'
  if (props.colorType === 'warning') return 'text-warning'
  if (props.colorType === 'error') return 'text-error'
  return 'text-primary'
})

const chartOptions = computed(() => ({
  chart: {
    type: 'radialBar' as const,
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
        background: 'var(--color-surface-muted)',
        strokeWidth: '100%',
        margin: 5,
      },
      dataLabels: {
        name: { show: false },
        value: {
          offsetY: 70,
          fontSize: '18px',
          fontWeight: '900',
          color: 'var(--color-text)',
          show: false,
        },
      },
    },
  },
  colors: [colorMap[props.colorType as keyof typeof colorMap]],
  fill: {
    type: 'solid' as const,
  },
  stroke: {
    lineCap: 'round' as const,
  },
  grid: {
    borderColor: 'var(--color-border)',
    padding: { top: 0, bottom: 0 },
  },
  tooltip: {
    theme: 'light',
  },
  labels: [props.title || ''],
}))
</script>
