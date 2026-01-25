<template>
  <div
    class="bg-surface border border-border p-6 rounded-2xl shadow-sm"
  >
    <div class="flex items-center justify-between mb-6">
      <div>
        <h3 class="text-lg font-bold text-text uppercase tracking-tight">
          Flujo de Trabajo (Hitos de Marea)
        </h3>
        <p class="text-xs text-text-muted font-medium">
          Seguimiento de tiempos de proceso (SLA por etapa)
        </p>
      </div>
      <div class="flex gap-2">
        <span class="flex items-center gap-1 text-[10px] font-bold text-text-muted uppercase tracking-wider">
          <span class="w-2 h-2 rounded-full border border-border"></span> Normal
        </span>
        <span class="flex items-center gap-1 text-[10px] font-bold text-error uppercase tracking-wider">
          <span class="w-2 h-2 rounded-full bg-error"></span> Fuera de SLA
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
            ? 'bg-error/10 border-error/20 shadow-sm shadow-error/5'
            : 'bg-surface-muted border-border',
        ]"
      >
        <div
          class="text-[10px] uppercase font-black text-text-muted/60 mb-1 leading-tight tracking-widest"
        >
          {{ metric.label }}
        </div>
        <div class="flex items-baseline gap-2">
          <span
            :class="[
              'text-xl font-bold tracking-tight',
              metric.exceeds
                ? 'text-error'
                : 'text-text',
            ]"
          >
            {{ metric.value }} <span class="text-xs font-normal opacity-60">días</span>
          </span>
          <span
            v-if="metric.exceeds"
            class="text-[10px] font-black bg-error/10 text-error px-1.5 py-0.5 rounded-md uppercase tracking-tighter"
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
    effectiveData.value.entrega > plazoEntregaDatos.value ? 'var(--color-error)' : 'var(--color-primary)',
    effectiveData.value.informe > plazoConfeccionInforme.value ? 'var(--color-error)' : 'var(--color-primary)',
    effectiveData.value.protocolo > plazoProtocolizacion.value ? 'var(--color-error)' : 'var(--color-primary)',
  ],
  dataLabels: {
    enabled: true,
    formatter: (val: number) => `${val} d`,
    offsetX: -20,
    style: {
      fontSize: '11px',
      fontWeight: 900,
      colors: ['var(--color-primary-fg)'],
    },
  },
  xaxis: {
    categories: ['Entrega Material', 'Informe Final', 'Protocolización'],
    axisBorder: { show: false },
    axisTicks: { show: false },
    labels: {
      style: {
        colors: 'var(--color-text-muted)',
        fontSize: '11px',
        fontWeight: 700,
      },
    },
  },
  yaxis: {
    labels: {
      align: 'left',
      minWidth: 0,
      style: {
        colors: 'var(--color-text)',
        fontSize: '11px',
        fontWeight: 800,
      },
    },
  },
  grid: {
    borderColor: 'var(--color-border)',
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
