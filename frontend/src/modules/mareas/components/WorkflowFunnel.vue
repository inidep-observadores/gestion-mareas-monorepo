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
          Seguimiento de tiempos de proceso (SLA por etapa)
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

    <div class="relative min-h-75">
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
import { storeToRefs } from 'pinia'
import VueApexCharts from 'vue3-apexcharts'
import type { ApexOptions } from 'apexcharts'
import { CHART_DEFAULTS } from '@/config/chartColors'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'

type WorkflowData = {
  entrega: number
  informe: number
  protocolo: number
}

const businessRulesStore = useBusinessRulesStore()
const { rules } = storeToRefs(businessRulesStore)
const plazoEntregaDatos = computed(() => rules.value.PLAZO_ENTREGA_DATOS || 0)
const plazoConfeccionInforme = computed(() => rules.value.PLAZO_CONFECCION_INFORME || 0)
const plazoProtocolizacion = computed(() => rules.value.PLAZO_PROTOCOLIZACION || 0)

const props = defineProps<{ data?: WorkflowData }>()

const effectiveData = computed<WorkflowData>(() => ({
  entrega: props.data?.entrega ?? plazoEntregaDatos.value,
  informe: props.data?.informe ?? plazoConfeccionInforme.value,
  protocolo: props.data?.protocolo ?? plazoProtocolizacion.value,
}))

const slaMetrics = computed(() => [
  {
    label: 'Fin -> Entrega Material',
    value: effectiveData.value.entrega,
    exceeds: effectiveData.value.entrega > plazoEntregaDatos.value,
  },
  {
    label: 'Entrega -> Informe Final',
    value: effectiveData.value.informe,
    exceeds: effectiveData.value.informe > plazoConfeccionInforme.value,
  },
  {
    label: 'Informe -> Protocolización',
    value: effectiveData.value.protocolo,
    exceeds: effectiveData.value.protocolo > plazoProtocolizacion.value,
  },
])

const series = computed(() => [
  {
    name: 'Días promedio',
    data: [
      effectiveData.value.entrega,
      effectiveData.value.informe,
      effectiveData.value.protocolo,
    ],
  },
])

const chartOptions = computed<ApexOptions>(() => ({
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
    effectiveData.value.entrega > plazoEntregaDatos.value ? 'var(--color-error-500)' : 'var(--color-brand-500)',
    effectiveData.value.informe > plazoConfeccionInforme.value ? 'var(--color-error-500)' : 'var(--color-brand-500)',
    effectiveData.value.protocolo > plazoProtocolizacion.value ? 'var(--color-error-500)' : 'var(--color-brand-500)',
  ],
  dataLabels: {
    enabled: true,
    formatter: (val: number) => `${val} d`,
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
      formatter: (val: number) => `${val} días`,
    },
  },
  legend: { show: false },
}))
</script>
