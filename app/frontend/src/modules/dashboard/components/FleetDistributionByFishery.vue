<template>
  <div
    class="rounded-3xl border border-border bg-surface p-6 shadow-sm flex flex-col gap-4 border-l-4 border-l-primary">
    <div class="mb-6 flex items-center justify-between">
      <div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest flex items-center gap-2">
          <div class="w-1.5 h-4 bg-success rounded-full"></div>
          Flota por Pesquería
        </h2>
        <span class="text-[10px] font-bold text-text-muted">Distribución de buques activos</span>
      </div>
      <div class="text-right">
        <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Total Activo</span>
        <p class="text-sm font-black text-text">{{ totalActive }} buques</p>
      </div>
    </div>

    <div class="grid grid-cols-1 xl:grid-cols-2 gap-8 items-start">
      <div class="flex flex-col items-center justify-center">
        <h3 class="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-4">Proporción</h3>
        <div class="w-full flex justify-center">
          <apexchart type="donut" height="300" :options="chartOptions" :series="series" />
        </div>
      </div>

      <div class="flex flex-col justify-center py-2">
        <h3 class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-4 border-b border-border pb-2">
          Distribución Nominal</h3>
        <div class="space-y-4" v-if="distribution.length">
          <div v-for="item in distribution" :key="item.label" class="group/item">
            <div @click="toggleExpand(item.label)"
              class="space-y-2 p-2 rounded-2xl transition-all cursor-pointer hover:bg-surface-muted/80"
              :class="{ 'bg-surface-muted shadow-sm ring-1 ring-border': expandedId === item.label }">
              <div class="flex items-center justify-between text-[10px] font-black uppercase tracking-widest">
                <div class="flex items-center gap-2">
                  <span class="text-text-muted transition-colors"
                    :class="{ 'text-primary': expandedId === item.label }">{{ item.label }}</span>
                  <div class="w-4 h-4 rounded-full flex items-center justify-center transition-transform duration-300"
                    :class="{ 'rotate-180 bg-primary text-white': expandedId === item.label, 'bg-surface-muted text-text-muted': expandedId !== item.label }">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round">
                      <path d="m6 9 6 6 6-6" />
                    </svg>
                  </div>
                </div>
                <span class="text-text tabular-nums">
                  {{ item.count }}
                  <span class="text-text-muted font-bold ml-1">({{ item.percentage }}%)</span>
                </span>
              </div>
              <div
                class="relative h-2 w-full bg-surface-muted rounded-full overflow-hidden border border-border/30 flex shadow-inner">
                <template v-if="item.stats && Object.keys(item.stats).length > 1">
                  <div v-for="(stat, code) in item.stats" :key="code"
                    class="h-full transition-all duration-1000 ease-out" :style="{
                      width: `${(stat.count / item.count) * 100}%`,
                      backgroundColor: getFleetColor(stat.nombre),
                      filter: 'saturate(0.8)'
                    }" v-tooltip="`${stat.nombre}: ${stat.count} buques`"></div>
                </template>
                <div v-else class="h-full transition-all duration-1000 ease-out shadow-sm" :style="{
                  width: totalActive ? `${(item.count / totalActive) * 100}%` : '0%',
                  backgroundColor: item.color
                }"></div>
              </div>

              <!-- Draggable/Scrollable Vessel Cloud -->
              <Transition enter-active-class="transition-all duration-300 ease-out"
                enter-from-class="max-h-0 opacity-0 transform -translate-y-2"
                enter-to-class="max-h-[1000px] opacity-100 transform translate-y-0"
                leave-active-class="transition-all duration-200 ease-in"
                leave-from-class="max-h-[1000px] opacity-100 transform translate-y-0"
                leave-to-class="max-h-0 opacity-0 transform -translate-y-2">
                <div v-if="expandedId === item.label" class="pt-3 overflow-hidden">
                  <!-- Conditional Grouping: Only if multiple fleet types exist -->
                  <div v-if="item.stats && Object.keys(item.stats).length > 1" class="space-y-4">
                    <div v-for="(group, typeLabel) in groupVesselsByFleet(item.vessels)" :key="typeLabel"
                      class="space-y-2">
                      <div class="flex items-center gap-2 px-1">
                        <div class="w-1 h-3 rounded-full" :style="{ backgroundColor: getFleetColor(typeLabel) }"></div>
                        <span
                          class="text-[9px] font-black uppercase tracking-tighter text-text-muted flex items-center gap-1.5">
                          {{ typeLabel }}
                          <span class="px-1.5 py-0.5 rounded-md bg-surface-muted text-[8px] border border-border">{{
                            group.length
                            }}</span>
                        </span>
                      </div>
                      <div class="flex flex-wrap gap-1.5 pr-1">
                        <div v-for="vessel in group" :key="vessel.name"
                          class="flex items-center gap-1.5 px-2 py-1 rounded-lg bg-surface border border-border shadow-sm transition-all hover:border-primary/50 group/chip"
                          v-tooltip="vessel.status === 'EN_EJECUCION' ? 'En ejecución' : 'Designada'">
                          <component :is="vessel.status === 'EN_EJECUCION' ? ShipIcon : TaskIcon" class="w-3 h-3"
                            :class="vessel.status === 'EN_EJECUCION' ? 'text-primary' : 'text-text-muted'" />
                          <span
                            class="text-[10px] font-bold text-text uppercase tracking-tighter group-hover/chip:text-primary transition-colors">
                            {{ vessel.name }}
                            <span class="text-[9px] opacity-60 ml-0.5">({{ vessel.mareaCode }})</span>
                          </span>
                        </div>
                      </div>
                    </div>
                  </div>
                  <!-- Direct list if only one fleet type -->
                  <div v-else class="flex flex-wrap gap-1.5 pr-1">
                    <div v-for="vessel in item.vessels" :key="vessel.name"
                      class="flex items-center gap-1.5 px-2 py-1 rounded-lg bg-surface border border-border shadow-sm transition-all hover:border-primary/50 group/chip"
                      v-tooltip="vessel.status === 'EN_EJECUCION' ? 'En ejecución' : 'Designada'">
                      <component :is="vessel.status === 'EN_EJECUCION' ? ShipIcon : TaskIcon" class="w-3 h-3"
                        :class="vessel.status === 'EN_EJECUCION' ? 'text-primary' : 'text-text-muted'" />
                      <span
                        class="text-[10px] font-bold text-text uppercase tracking-tighter group-hover/chip:text-primary transition-colors">
                        {{ vessel.name }}
                        <span class="text-[9px] opacity-60 ml-0.5">({{ vessel.mareaCode }})</span>
                      </span>
                    </div>
                  </div>
                </div>
              </Transition>
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
import { ShipIcon, TaskIcon } from '@/icons'
import dashboardService from '@/modules/dashboard/services/dashboard.service'

type FleetDisplayItem = {
  label: string
  count: number
  color: string
  percentage: number
  stats?: Record<string, { count: number, nombre: string }>
  vessels: Array<{
    name: string;
    mareaCode: string;
    status: string;
    tipoFlota?: { codigo: string; nombre: string }
  }>
}

const distribution = ref<FleetDisplayItem[]>([])
const expandedId = ref<string | null>(null)
const palette = ['var(--color-primary)', 'var(--color-info)', 'var(--color-success)', 'var(--color-warning)', 'var(--color-error)', 'var(--color-secondary)']

const { isDarkMode } = useTheme() as any

const toggleExpand = (label: string) => {
  expandedId.value = expandedId.value === label ? null : label
}

const onDataPointSelection = (_event: any, _chartContext: any, config: any) => {
  const label = distribution.value[config.dataPointIndex]?.label
  if (label) toggleExpand(label)
}

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
    background: 'transparent',
    events: {
      dataPointSelection: onDataPointSelection
    }
  },
  grid: {
    padding: { top: 0, bottom: 0, left: 0, right: 0 }
  },
  theme: {
    mode: isDarkMode.value ? 'dark' : 'light'
  },
  labels: distribution.value.map((item) => item.label),
  colors: chartColors.value,
  stroke: {
    show: true,
    width: 3,
    colors: ['var(--color-surface)']
  },
  plotOptions: {
    pie: {
      donut: {
        size: '55%',
        labels: {
          show: true,
          name: {
            show: true,
            fontSize: '11px',
            fontWeight: 900,
            color: 'var(--color-text-muted)',
            offsetY: -8
          },
          value: {
            show: true,
            fontSize: '22px',
            fontWeight: 900,
            color: 'var(--color-text)',
            offsetY: 10,
            formatter: (val: string) => val
          },
          total: {
            show: true,
            label: 'BUQUES',
            fontSize: '9px',
            fontWeight: 900,
            color: 'var(--color-text-muted)',
            formatter: () => totalActive.value
          }
        }
      }
    }
  },
  responsive: [
    {
      breakpoint: 1366,
      options: {
        plotOptions: {
          pie: {
            donut: {
              size: '55%',
              labels: {
                value: { fontSize: '18px' },
                total: { fontSize: '8px' }
              }
            }
          }
        }
      }
    }
  ],
  dataLabels: { enabled: false },
  legend: {
    show: distribution.value.length > 0,
    position: 'bottom',
    fontSize: '10px',
    fontWeight: 700,
    itemMargin: { horizontal: 5, vertical: 8 },
    markers: { radius: 12, size: 5, offsetX: -2 },
    labels: {
      colors: 'var(--color-text-muted)'
    }
  },
  tooltip: {
    enabled: true,
    custom: ({ series, seriesIndex, w }: any) => {
      const val = series[seriesIndex]
      const label = w.globals.labels[seriesIndex]
      const accent = chartColors.value[seriesIndex] || 'var(--color-primary)'
      const item = distribution.value[seriesIndex]

      return `
        <div class="px-4 py-3 bg-surface/95 backdrop-blur-md text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/5 min-w-[180px]">
          <div class="flex items-center gap-2 border-b border-border/30 pb-2">
            <span class="w-1.5 h-3 rounded-full" style="background:${accent}"></span>
            <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
          </div>
          
          ${item.stats && Object.keys(item.stats).length > 1 ? `
            <div class="flex flex-col gap-2">
              ${Object.entries(item.stats).map(([_, stat]: any) => `
                <div class="flex items-center justify-between gap-4">
                  <div class="flex items-center gap-1.5">
                    <div class="w-1.5 h-1.5 rounded-full" style="background:${getFleetColor(stat.nombre)}"></div>
                    <span class="text-[9px] font-bold text-text-muted uppercase">${stat.nombre}</span>
                  </div>
                  <span class="text-[10px] font-black text-text">${stat.count}</span>
                </div>
              `).join('')}
            </div>
          ` : ''}

          <div class="flex items-center justify-between pt-1 ${item.stats && Object.keys(item.stats).length > 1 ? 'border-t border-border/30' : ''}">
            <span class="text-[9px] font-black text-primary uppercase">Total Pesquería</span>
            <div class="flex items-baseline gap-1">
              <span class="text-xs font-black text-text">${val}</span>
              <span class="text-[9px] font-bold text-text-muted">(${Math.round((val / totalActive.value) * 100)}%)</span>
            </div>
          </div>
        </div>
      `
    }
  }
}))

const groupVesselsByFleet = (vessels: FleetDisplayItem['vessels']) => {
  const groups: Record<string, any[]> = {}
  vessels.forEach(v => {
    const fleetName = v.tipoFlota?.nombre || 'Indeterminado'
    if (!groups[fleetName]) groups[fleetName] = []
    groups[fleetName].push(v)
  })
  return groups
}

const getFleetColor = (name: string) => {
  if (name.toUpperCase().includes('FRESQUERO')) return 'var(--color-info)'
  if (name.toUpperCase().includes('CONGELADOR')) return 'var(--color-warning)'
  return 'var(--color-primary)'
}

const loadDistribution = async () => {
  try {
    const { total, distribution: data } = await dashboardService.getFleetDistribution()
    const sorted = [...data].sort((a, b) => b.count - a.count)

    distribution.value = sorted.map((item, index) => ({
      label: item.label,
      count: item.count,
      color: palette[index % palette.length],
      percentage: total > 0 ? Math.round((item.count / total) * 100) : 0,
      stats: item.stats,
      vessels: item.vessels || []
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
  background: var(--color-surface-muted);
  border-radius: 10px;
}

.custom-scrollbar-mini::-webkit-scrollbar {
  width: 2px;
}

.custom-scrollbar-mini::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar-mini::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
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
