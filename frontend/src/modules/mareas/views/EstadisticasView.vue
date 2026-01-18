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
          v-model:mode="mode"
          :protocolizedOnly="protocolizedOnly"
          @update:protocolizedOnly="protocolizedOnly = $event"
          :includeOutOfPeriod="includeOutOfPeriod"
          @update:includeOutOfPeriod="includeOutOfPeriod = $event"
          @refresh="fetchData"
          v-model:daysCalculationMode="daysCalculationMode"
          v-model:includeCampaigns="includeCampaigns"
        />

        <!-- Collapsible Criteria Explanation -->
        <div class="mt-4 bg-surface-muted/30 border border-border/50 rounded-xl overflow-hidden transition-all duration-300">
           <button 
             @click="isCriteriaOpen = !isCriteriaOpen"
             class="w-full flex items-center justify-between p-3 px-4 text-xs font-medium text-text-muted hover:text-text hover:bg-surface-muted/50 transition-colors"
           >
              <div class="flex items-center gap-2">
                 <InfoIcon class="w-4 h-4 text-primary/70" />
                 <span>Criterios de Análisis Aplicados</span>
              </div>
              <component :is="isCriteriaOpen ? ChevronUpIcon : ChevronDownIcon" class="w-4 h-4" />
           </button>
           
           <div v-if="isCriteriaOpen" class="p-4 pt-0 border-t border-border/50 animate-in slide-in-from-top-2 duration-200">
              <ul class="space-y-2 mt-3">
                 <li v-for="(criterion, index) in criteriaList" :key="index" class="flex items-start gap-2 text-xs text-text-muted">
                    <div class="w-1.5 h-1.5 rounded-full bg-primary/40 mt-1.5 shrink-0"></div>
                    <span v-html="criterion"></span>
                 </li>
              </ul>
           </div>
        </div>

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
              allow-download
              @download="handleDownload('Tendencia_Mensual')"
            />
          </div>
          <div class="col-span-12 lg:col-span-4 space-y-8">
             <ChartWidget 
              title="Distribución por Flota"
              type="pie"
              :series="fleetSeries"
              :options="fleetChartOptions"
              allow-download
              @dataPointClick="handleFleetClick"
              @download="handleDownload('Distribucion_Flota', 'FLEET')"
            />
          </div>
        </section>

        <!-- ROW 3: FISHERIES & OBSERVERS -->
        <section class="grid grid-cols-12 gap-8">
          <div class="col-span-12 lg:col-span-5">
             <ChartWidget 
              title="Participación por Pesquería"
              subtitle="Días navegados por especie objetivo"
              type="donut"
              :series="fisherySeries"
              :options="fisheryChartOptions"
              allow-download
              @dataPointClick="handleFisheryClick"
              @download="handleDownload('Participacion_Pesqueria', 'FISHERY')"
            />
          </div>
          <div class="col-span-12 lg:col-span-7">
             <ChartWidget 
              title="Ranking de Observadores"
              subtitle="Top 10 por días navegados"
              type="bar"
              :series="observerSeries"
              :options="observerChartOptions"
              allow-download
              @dataPointClick="handleObserverClick"
              @download="handleDownload('Ranking_Observadores', 'OBSERVER')"
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

      <!-- DRILL DOWN DIALOG -->
    <Modal
      v-if="dialogOpen"
      :is-open="dialogOpen"
      :title="dialogTitle"
      @close="closeDialog"
    >
      <template #body>
         <div class="bg-surface border border-border rounded-xl shadow-theme-xl w-full max-w-4xl mx-4 flex flex-col max-h-[90vh] animate-in zoom-in-95 duration-200">
            <!-- Header -->
            <div class="flex items-center justify-between p-4 border-b border-border">
               <div>
                  <h3 class="text-lg font-bold text-text">{{ dialogTitle }}</h3>
                  <p class="text-xs text-text-muted">Detalle de mareas asociadas al registro seleccionado.</p>
               </div>
               <button @click="closeDialog" class="p-1 rounded hover:bg-surface-muted text-text-muted hover:text-text transition-colors">
                  <span class="sr-only">Cerrar</span>
                  <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>
               </button>
            </div>

            <!-- Body -->
            <div class="p-4 overflow-hidden flex-1 flex flex-col min-h-0">
               <div v-if="dialogLoading" class="flex justify-center items-center h-40">
                  <Loader2Icon class="w-8 h-8 animate-spin text-primary" />
               </div>
               
               <div v-else class="flex-1 overflow-y-auto pr-2 custom-scrollbar">
                  <div class="space-y-3">
                     <div v-for="marea in dialogItems" :key="marea.id" class="flex items-center justify-between p-4 rounded-lg border border-border bg-surface-muted/30 hover:bg-surface-muted/60 transition-colors">
                        <div>
                           <div class="flex items-center gap-2 mb-1">
                              <span class="font-bold text-sm text-text">{{ marea.id_marea }}</span>
                              <span class="px-2 py-0.5 rounded text-[10px] bg-secondary/10 text-secondary border border-secondary/20">{{ marea.estado }}</span>
                              <span v-if="marea.tipoMarea === 'CI'" class="px-2 py-0.5 rounded text-[10px] bg-accent/10 text-accent border border-accent/20">Campaña</span>
                           </div>
                           <div class="text-xs text-text-muted grid grid-cols-2 gap-x-8 gap-y-1 mt-2">
                              <span><span class="font-semibold text-text-muted/70">Buque:</span> {{ marea.buque }}</span>
                              <span><span class="font-semibold text-text-muted/70">Pesquería:</span> {{ marea.pesqueria }}</span>
                              <span><span class="font-semibold text-text-muted/70">Observador:</span> {{ marea.observador }}</span>
                              <span><span class="font-semibold text-text-muted/70">Inicio:</span> {{ marea.fechaInicio ? new Date(marea.fechaInicio).toLocaleDateString() : '-' }}</span>
                           </div>
                        </div>
                        <div class="text-right pl-4">
                           <span class="block text-2xl font-bold text-primary tabular-nums">{{ marea.diasContabilizados }}</span>
                           <span class="text-[10px] uppercase font-bold text-text-muted tracking-wider">Días</span>
                        </div>
                     </div>
                  </div>
               </div>
            </div>

            <!-- Footer -->
            <div class="flex justify-end gap-3 p-4 border-t border-border bg-surface-muted/20">
               <button 
                  class="flex items-center gap-2 px-4 py-2 rounded-lg border border-border text-sm font-medium hover:bg-surface-muted transition-colors bg-surface"
                  @click="handleDownload(dialogTitle.replace(/\s+/g, '_'), filterType || undefined)"
               >
                  <DownloadIcon class="w-4 h-4" />
                  Exportar Detalle
               </button>
               <button 
                  class="px-4 py-2 rounded-lg bg-primary text-primary-fg text-sm font-medium hover:bg-primary-hover transition-colors shadow-sm"
                  @click="closeDialog"
               >
                  Cerrar
               </button>
            </div>
         </div>
      </template>
    </Modal>
  </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, watch, computed, onMounted } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import StatsFilterBar from '@/modules/stats/components/StatsFilterBar.vue'
import StatKpiCard from '@/modules/stats/components/StatKpiCard.vue'
import ChartWidget from '@/modules/stats/components/ChartWidget.vue'
import Modal from '@/components/ui/Modal.vue'
import { 
  BarChartIcon, 
  ShipIcon, 
  CalendarClockIcon, 
  TimerIcon,
  Loader2Icon,
  DownloadIcon,
  InfoIcon,
  ChevronDownIcon,
  ChevronUpIcon,
  TerminalIcon,
  CopyIcon,
  CheckIcon
} from 'lucide-vue-next'
import { statsService, type DashboardStats, type StatsDetailItem } from '@/modules/stats/services/stats.service'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import { toast } from 'vue-sonner'

const configStore = useConfigStore();
const year = computed(() => configStore.selectedYear);

const mode = ref<'CALENDAR' | 'TOTAL'>('CALENDAR');
const protocolizedOnly = ref(false);
const includeOutOfPeriod = ref(false);
const daysCalculationMode = ref<'SHIP' | 'OBSERVER'>('SHIP');
const includeCampaigns = ref(true);

const filterType = ref<'FISHERY' | 'FLEET' | 'OBSERVER' | null>(null);
const filterValue = ref<string | null>(null);

const stats = ref<DashboardStats | null>(null);
const loading = ref(false);
const dialogOpen = ref(false);
const dialogLoading = ref(false);
const dialogItems = ref<StatsDetailItem[]>([]);
const dialogTitle = ref('');

// --- Criteria Logic ---
// ... (previous criteria logic) ...
const isCriteriaOpen = ref(false);
const criteriaList = computed(() => {
    // ... (existing computed body) ...
    const list: string[] = [];
    const yearText = `<span class="font-bold text-text">${year.value}</span>`;
    if (mode.value === 'CALENDAR') {
        list.push(`Periodo Analizado: <strong>Calendario ${yearText}</strong> (01/Ene - 31/Dic). Solo se contabilizan los días de navegación ocurridos estrictamente dentro de este rango.`);
    } else {
        list.push(`Periodo Analizado: <strong>Total Marea ${yearText}</strong>. Se incluyen mareas completas que hayan tenido actividad durante el año, sumando la totalidad de sus días.`);
    }
    if (daysCalculationMode.value === 'SHIP') {
        list.push(`Métrica: <strong>Días de Buque</strong>. Días únicos que la embarcación estuvo operando, sin multiplicar por observadores embarcados.`);
    } else {
        list.push(`Métrica: <strong>Días de Observador</strong>. Suma del esfuerzo individual de todos los observadores a bordo (ej: 10 días x 2 obs = 20 días).`);
    }
    if (protocolizedOnly.value) {
        let text = `Estado: <strong>Solo Protocolizadas</strong>.`;
        if (includeOutOfPeriod.value) {
            text += ` Se incluyen además mareas protocolizadas en ${yearText} aunque hayan finalizado antes (Fuera de Periodo).`;
        }
        list.push(text);
    } else {
        list.push(`Estado: <strong>Todas las mareas</strong> (Protocolizadas y En Proceso).`);
    }
    if (includeCampaigns.value) {
        list.push(`Tipo: Incluye mareas comerciales y <strong>Campañas Institucionales</strong>.`);
    } else {
        list.push(`Tipo: <strong>Excluye</strong> Campañas Institucionales.`);
    }
    if (filterType.value && filterValue.value) {
        let typeLabel = '';
        if (filterType.value === 'FISHERY') typeLabel = 'Pesquería';
        if (filterType.value === 'FLEET') typeLabel = 'Flota';
        if (filterType.value === 'OBSERVER') typeLabel = 'Observador';
        list.push(`Filtro Activo: <strong>${typeLabel}</strong> ${dialogTitle.value ? `(${dialogTitle.value.replace('Detalle: ', '')})` : ''}.`);
    }
    return list;
});

// --- Fetch Data ---
const fetchData = async () => {
    loading.value = true;
    try {
        stats.value = await statsService.getDashboardStats(
            year.value, 
            mode.value, 
            !protocolizedOnly.value, 
            includeOutOfPeriod.value,
            daysCalculationMode.value,
            includeCampaigns.value
        );
    } catch (error) {
        console.error('Error fetching stats:', error);
        toast.error('Error al cargar estadísticas');
    } finally {
        loading.value = false;
    }
};

// --- Watchers ---
watch([year, mode, protocolizedOnly, includeOutOfPeriod, daysCalculationMode, includeCampaigns], () => {
    fetchData();
});

// --- Dialog Logic ---
const openDialog = async (type: 'FISHERY' | 'FLEET' | 'OBSERVER', value: string, titleName: string) => {
    filterType.value = type;
    filterValue.value = value; // NOW value is correct: Name for Fishery/Fleet, UUID for Observer
    
    dialogTitle.value = `Detalle: ${titleName}`; // Use pretty name for title
    dialogOpen.value = true;
    dialogLoading.value = true;

    try {
        dialogItems.value = await statsService.getDashboardStatsDetail(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            type,
            value,
            daysCalculationMode.value,
            includeCampaigns.value
        );
    } catch (error) {
        console.error('Error fetching details:', error);
        toast.error('Error al cargar detalle');
        dialogOpen.value = false;
    } finally {
        dialogLoading.value = false;
    }
};
const closeDialog = () => {
    dialogOpen.value = false;
    filterType.value = null;
    filterValue.value = null;
};

// --- Click Handlers ---
const handleFisheryClick = (event: any, chartContext: any, config: any) => {
    const idx = config.dataPointIndex;
    const item = stats.value?.fisheries[idx];
    if (item) openDialog('FISHERY', item.name, item.name);
};

const handleFleetClick = (event: any, chartContext: any, config: any) => {
    const idx = config.dataPointIndex;
    const item = stats.value?.fleets[idx];
    if (item) openDialog('FLEET', item.name, item.name);
};

const handleObserverClick = (event: any, chartContext: any, config: any) => {
    const idx = config.dataPointIndex;
    const item = stats.value?.observers[idx];
    // Now we pass the ID to the API filter logic, but Name to the Dialog Title
    if (item) openDialog('OBSERVER', item.id, item.name); 
}

// --- Download Handler ---
const handleDownload = async (titlePrefix: string, fType?: 'FISHERY' | 'FLEET' | 'OBSERVER') => {
    const fValue = filterValue.value || undefined;
    const fTypeParam = fType || filterType.value || undefined; 
   
    let finalTitle = titlePrefix;
    if (fValue) {
        // If searching by observer ID, we typically want the name in the filename if possible. 
        // But getting the name here is tricky without passing it. 
        // For FilterBar downloads (general), fValue is null.
        // For Dialog downloads (filtered), fValue is set.
        // Let's use dialog title if available for cleaner filenames? 
        // Or just let it use the ID if that's what we have. 
        // Better yet: remove ID from filename if ugliness is concern, or accept it.
        // Ideally, we'd sanitize.
        finalTitle += `_${fValue.substring(0, 15)}`; 
    }

    try {
        await statsService.downloadExport(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            daysCalculationMode.value,
            includeCampaigns.value,
            fTypeParam, 
            fValue, // PASSING UNDEFINED IF NULL
            `${finalTitle}_${mode.value === 'CALENDAR' ? year.value : 'TOTAL'}`
        );
        toast.success(`Exportación iniciada: ${finalTitle}`);
    } catch (error) {
        console.error('Download error:', error);
        toast.error('Error al exportar archivo');
    }
}

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
  dataLabels: { enabled: false },
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
