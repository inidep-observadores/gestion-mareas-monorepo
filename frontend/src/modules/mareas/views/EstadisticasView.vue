<template>
  <AdminLayout
    title="Centro de Análisis"
    description="Inteligencia institucional y monitoreo de desempeño estratégico."
  >
    <div class="relative min-h-screen pb-20 animate-in fade-in duration-700">

      <!-- TOP ANALYTICS FILTERS -->
      <section class="mb-8">
        <StatsFilterBar 
          title="Análisis de Gestión"
          subtitle="Filtros dinámicos de periodo"
          :icon="BarChartIcon"
          :loading="loading"
          v-model:year="year"
          v-model:mode="mode"
          :protocolizedOnly="protocolizedOnly"
          @update:protocolizedOnly="protocolizedOnly = $event"
          :includeOutOfPeriod="includeOutOfPeriod"
          @update:includeOutOfPeriod="includeOutOfPeriod = $event"
          @refresh="fetchData"
        />
      </section>

      <div v-if="stats" class="space-y-8">
        <!-- ROW 1: CORE ANALYTICAL KPIs -->
        <section class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <StatKpiCard 
             label="Total Mareas" 
             :value="stats.totalMareas" 
             :icon="ShipIcon"
             color="primary"
             subtext="Mareas registradas en el periodo"
          />
          <StatKpiCard 
             label="Días Navegados" 
             :value="stats.totalDaysNavigated" 
             :icon="CalendarClockIcon"
             color="secondary"
             subtext="Total acumulado de días de operación"
          />
          <StatKpiCard 
             label="Promedio Días / Marea" 
             :value="stats.avgDaysPerMarea" 
             :icon="TimerIcon"
             color="accent"
             subtext="Eficiencia operativa promedio"
          />
        </section>

        <!-- ROW 2: TEMPORAL TRENDS -->
        <section class="grid grid-cols-12 gap-8">
          <div class="col-span-12 lg:col-span-8">
            <ChartWidget 
              title="Tendencia Mensual" 
              subtitle="Mareas iniciadas y Días Navegados por mes"
              type="bar"
              :series="monthlySeries"
              :options="monthlyChartOptions"
            />
          </div>
          <div class="col-span-12 lg:col-span-4 space-y-8">
             <ChartWidget 
              title="Distribución por Flota"
              type="donut"
              :series="fleetSeries"
              :options="fleetChartOptions"
            />
          </div>
        </section>

        <!-- ROW 3: FISHERIES & OBSERVERS -->
        <section class="grid grid-cols-12 gap-8">
          <div class="col-span-12 lg:col-span-5">
             <ChartWidget 
              title="Participación por Pesquería"
              subtitle="Días navegados por especie objetivo"
              type="pie"
              :series="fisherySeries"
              :options="fisheryChartOptions"
            />
          </div>
          <div class="col-span-12 lg:col-span-7">
             <ChartWidget 
              title="Ranking de Observadores"
              subtitle="Top 10 por días navegados"
              type="bar"
              :series="observerSeries"
              :options="observerChartOptions"
            />
          </div>
        </section>

      </div>
      
      <!-- Loading State -->
      <div v-else-if="loading" class="flex items-center justify-center py-20">
         <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
      
      <!-- Empty State -->
      <div v-else class="text-center py-20 text-text-muted">
         No hay datos disponibles para la configuración seleccionada.
      </div>

    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import StatsFilterBar from '../../stats/components/StatsFilterBar.vue'
import StatKpiCard from '../../stats/components/StatKpiCard.vue'
import ChartWidget from '../../stats/components/ChartWidget.vue'
import { BarChartIcon, ShipIcon, CalendarClockIcon, TimerIcon } from 'lucide-vue-next'
import { statsService, type DashboardStats } from '../../stats/services/stats.service'

const loading = ref(false)
const stats = ref<DashboardStats | null>(null)

// Filters State
const year = ref(new Date().getFullYear())
const mode = ref<'CALENDAR' | 'TOTAL'>('CALENDAR')
const protocolizedOnly = ref(false)
const includeOutOfPeriod = ref(false)

// Fetch Data
const fetchData = async () => {
  loading.value = true
  try {
    // Note: protocolizedOnly = true -> includeNonProtocolized = false
    stats.value = await statsService.getDashboardStats(
      year.value, 
      mode.value, 
      !protocolizedOnly.value, 
      includeOutOfPeriod.value
    )
  } catch (error) {
    console.error('Failed to load stats', error)
  } finally {
    loading.value = false
  }
}

// Watch filters
watch([year, mode, protocolizedOnly, includeOutOfPeriod], () => {
  fetchData()
}, { deep: true })

onMounted(() => {
  fetchData()
})

// --- CHART COMPUTED PROPS ---

// 1. Monthly Trends (Mixed Chart)
const monthlySeries = computed(() => {
  if (!stats.value) return []
  return [
    { name: 'Mareas Iniciadas', type: 'column', data: stats.value.monthly.mareas },
    { name: 'Días Navegados', type: 'line', data: stats.value.monthly.days }
  ]
})
const monthlyChartOptions = computed(() => ({
  labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
  colors: ['#0ea5e9', '#f59e0b'],
  stroke: { width: [0, 3] },
  plotOptions: { bar: { borderRadius: 4, columnWidth: '50%' } },
  yaxis: [
    { title: { text: 'Mareas' } }, 
    { opposite: true, title: { text: 'Días' } }
  ]
}))

// 2. Fleet Distribution (Donut)
const fleetSort = computed(() => stats.value?.fleets.slice(0, 5) || []) // Top 5
const fleetSeries = computed(() => fleetSort.value.map(f => f.days))
const fleetChartOptions = computed(() => ({
  labels: fleetSort.value.map(f => f.name),
  dataLabels: { enabled: true },
  plotOptions: { pie: { donut: { size: '65%' } } }
}))

// 3. Fishery Distribution (Pie)
const fisherySort = computed(() => stats.value?.fisheries.slice(0, 7) || []) // Top 7
const fisherySeries = computed(() => fisherySort.value.map(f => f.days))
const fisheryChartOptions = computed(() => ({
  labels: fisherySort.value.map(f => f.name),
}))

// 4. Observer Ranking (Bar Horizontal)
const observerSort = computed(() => stats.value?.observers.slice(0, 10) || []) // Top 10
const observerSeries = computed(() => ([{
  name: 'Días Navegados',
  data: observerSort.value.map(o => o.days)
}]))
const observerChartOptions = computed(() => ({
  plotOptions: {
    bar: { horizontal: true, borderRadius: 4, barHeight: '60%' }
  },
  xaxis: { categories: observerSort.value.map(o => o.name) },
  colors: ['#8b5cf6']
}))

</script>

<style scoped>
.animate-in {
  animation-duration: 0.7s;
  animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}
.fade-in {
  animation-name: fade-in;
}

@keyframes fade-in {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
