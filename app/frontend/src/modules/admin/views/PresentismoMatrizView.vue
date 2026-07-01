<template>
  <AdminLayout>
    <div class="space-y-6">
      <BackButton routeName="SistemaObservadores" label="Regresar al Panel" containerClass="mb-2" />
      <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h1 class="text-2xl font-black text-text uppercase tracking-tight">Planilla Mensual de Presentismo</h1>
          <p class="text-sm font-medium text-text-muted mt-1">Cruce dinámico de Mareas, Puertos y Novedades</p>
        </div>
        
        <div class="flex flex-wrap items-center gap-3">
          <!-- Selector de Mes -->
          <div class="relative">
            <select v-model="selectedMonth" @change="fetchData" class="h-10 pl-4 pr-10 rounded-lg border bg-surface text-sm font-bold border-border outline-none focus:border-primary focus:ring-2 focus:ring-primary/20 appearance-none transition-all text-text cursor-pointer">
              <option v-for="(m, i) in months" :key="i" :value="i + 1">{{ m }}</option>
            </select>
            <ChevronDownIcon class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          </div>

          <!-- Selector de Año -->
          <div class="relative">
            <select v-model="selectedYear" @change="fetchData" class="h-10 pl-4 pr-10 rounded-lg border bg-surface text-sm font-bold border-border outline-none focus:border-primary focus:ring-2 focus:ring-primary/20 appearance-none transition-all text-text cursor-pointer">
              <option v-for="y in availableYears" :key="y" :value="y">{{ y }}</option>
            </select>
            <ChevronDownIcon class="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          </div>

          <button @click="exportToExcel" :disabled="isLoading || !data" class="h-10 px-4 inline-flex items-center justify-center gap-2 text-sm font-bold tracking-widest uppercase transition-all rounded-lg bg-surface border border-border text-primary hover:bg-primary/5 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed">
            <DownloadIcon class="w-4 h-4" />
            Exportar Excel
          </button>
        </div>
      </div>

      <!-- Leyenda -->
      <div class="flex flex-wrap gap-4 p-4 rounded-xl border border-border bg-surface shadow-sm">
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-[#00FF00] flex items-center justify-center text-[10px] font-black text-black">NAVEG</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Navegando</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-[#FFE4C4] flex items-center justify-center text-[10px] font-black text-black">PUERTO</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">En Puerto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-[#E6E6FA] flex items-center justify-center text-[10px] font-black text-black">VIAJE</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">En Viaje</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-[#ADD8E6] flex items-center justify-center text-[10px] font-black text-black">LICEN</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Novedad / Licencia</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-[#FFA500] flex items-center justify-center text-[10px] font-black text-black">FERIADO</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Feriado</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded bg-error flex items-center justify-center text-[10px] font-black text-white">ERR</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Conflicto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded border-2 border-red-500 bg-surface flex items-center justify-center text-[10px] font-black text-red-500">FC</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Computa Franco</span>
        </div>
      </div>

      <!-- Filtros Compactos -->
      <div v-if="data" class="flex flex-wrap items-center gap-6 p-4 rounded-xl border border-border bg-surface shadow-sm">
        <SearchInput v-model="searchQuery" placeholder="Buscar observador..." class="w-full md:w-64 shrink-0" />
        
        <div class="flex flex-wrap items-center gap-4 flex-1">
          <div class="flex items-center gap-2">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-1">Observador:</span>
            <button v-for="t in tiposObservador" :key="t" @click="toggleTipoObservador(t)" class="px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase transition-all" :class="activeTipoObservador.has(t) ? 'bg-primary/10 border border-primary text-primary' : 'bg-surface border border-border text-text-muted opacity-50'">
              {{ t }}
            </button>
          </div>
          
          <div class="w-px h-6 bg-border mx-2 hidden lg:block"></div>

          <div class="flex items-center gap-2">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-1">Contrato:</span>
            <button v-for="c in tiposContrato" :key="c" @click="toggleTipoContrato(c)" class="px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase transition-all" :class="activeTipoContrato.has(c) ? 'bg-info/10 border border-info text-info' : 'bg-surface border border-border text-text-muted opacity-50'">
              {{ c }}
            </button>
          </div>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading" class="p-12 flex flex-col items-center justify-center bg-surface border border-border rounded-2xl">
        <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-sm font-bold text-text-muted">Cargando matriz de presentismo...</p>
      </div>

      <!-- Matriz Table -->
      <div v-else-if="data" class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
        <div class="overflow-x-auto overflow-y-auto max-h-[70vh]">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-surface-muted border-b border-border">
                <th class="sticky top-0 left-0 z-50 bg-surface-muted px-4 py-3 text-xs font-black uppercase tracking-widest text-text min-w-[112px] w-[112px] max-w-[112px] border-r border-border shadow-[0_2px_5px_-2px_rgba(0,0,0,0.1)]">
                  Legajo
                </th>
                <th class="sticky top-0 left-[110px] z-40 bg-surface-muted px-4 py-3 text-xs font-black uppercase tracking-widest text-text min-w-[200px] border-r border-border shadow-[2px_2px_5px_-2px_rgba(0,0,0,0.1)]">
                  Observador
                </th>
                <!-- Días -->
                <th v-for="dia in data.diasMes" :key="dia" class="sticky top-0 z-30 bg-surface-muted px-1 py-1 text-center border-r border-border min-w-[36px] shadow-[0_2px_5px_-2px_rgba(0,0,0,0.1)]">
                  <div class="flex flex-col items-center justify-center">
                    <span 
                      class="text-[10px] uppercase transition-colors leading-tight"
                      :class="{
                        'text-error font-black': data.feriados[dia],
                        'font-black text-text': isFinSemana(dia) && !data.feriados[dia],
                        'font-bold text-text-muted': !isFinSemana(dia) && !data.feriados[dia]
                      }">
                      {{ getDiaSemana(dia) }}
                    </span>
                    <span 
                      class="text-xs transition-colors leading-tight mt-0.5"
                      :class="{
                        'text-error font-black': data.feriados[dia],
                        'font-black text-text': isFinSemana(dia) && !data.feriados[dia],
                        'font-bold text-text': !isFinSemana(dia) && !data.feriados[dia]
                      }">
                      {{ dia }}
                    </span>
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in filteredMatriz" :key="row.observador.id" class="border-b border-border hover:bg-surface-muted/50 transition-colors group">
                <td class="sticky left-0 z-30 bg-surface group-hover:bg-surface-muted px-4 py-2 border-r border-border transition-colors text-center min-w-[112px] w-[112px] max-w-[112px]">
                  <div class="font-mono font-bold text-xs text-text-muted">
                    {{ row.observador.codigoInterno }}
                  </div>
                </td>
                <td class="sticky left-[110px] z-20 bg-surface group-hover:bg-surface-muted px-4 py-2 border-r border-border shadow-[2px_0_5px_-2px_rgba(0,0,0,0.1)] transition-colors">
                  <div class="font-bold text-sm text-text truncate">
                    {{ row.observador.apellido }}, {{ row.observador.nombre }}
                  </div>
                </td>
                
                <!-- Días -->
                <td v-for="dia in data.diasMes" :key="dia" class="p-1 border-r border-border relative group/cell">
                  <div class="w-full min-h-8 rounded flex items-center justify-center transition-all cursor-default" :class="[getCellClass(row.dias[dia]), row.dias[dia]?.computaFranco ? 'ring-2 ring-red-500 ring-inset shadow-md font-extrabold' : '']">
                    <span v-if="row.dias[dia]?.estado === 'CONFLICTO'" class="text-[10px] font-black text-white px-1">ERR</span>
                    <span v-else-if="row.dias[dia]?.estado === 'NAVEGANDO'" class="text-[10px] font-black text-black px-1">NAVEG</span>
                    <span v-else-if="row.dias[dia]?.estado === 'PUERTO'" class="text-[10px] font-black text-black px-1">PUERTO</span>
                    <span v-else-if="row.dias[dia]?.estado === 'VIAJE'" class="text-[10px] font-black text-black px-1">VIAJE</span>
                    <span v-else-if="row.dias[dia]?.estado === 'NOVEDAD'" class="text-[10px] font-black text-black px-1">{{ row.dias[dia].codigoCorto || 'NOV' }}</span>
                    <span v-else-if="row.dias[dia]?.estado === 'FERIADO'" class="text-[10px] font-black text-black px-1">FERIADO</span>
                  </div>

                  <!-- Tooltip -->
                  <div v-if="row.dias[dia]?.estado !== 'LIBRE' && row.dias[dia]?.estado !== 'FIN_SEMANA'" class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-max max-w-[200px] bg-gray-900 text-white text-xs p-2 rounded shadow-lg opacity-0 pointer-events-none group-hover/cell:opacity-100 transition-opacity z-30">
                    <div class="font-bold mb-1">{{ formatTooltipTitle(row.dias[dia].estado) }}</div>
                    <div class="text-[10px] text-gray-300 leading-tight" v-if="row.dias[dia].detalle || row.dias[dia].conflictoDetalle">
                      {{ row.dias[dia].conflictoDetalle || row.dias[dia].detalle }}
                    </div>
                    <!-- Triangulito -->
                    <div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900"></div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import { ChevronDownIcon, DownloadIcon } from '@/icons';
import { toast } from 'vue-sonner';
import presentismoApi from '../services/presentismo.service';
import presentismoExportService from '../services/presentismo-export.service';
import type { PlanillaMensualResponse, DiaEstado } from '../interfaces/planilla-mensual.interface';

const currentDate = new Date();
const selectedMonth = ref(currentDate.getMonth() + 1);
const selectedYear = ref(currentDate.getFullYear());
const availableYears = Array.from({length: 5}, (_, i) => currentDate.getFullYear() - 2 + i);

const months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

const data = ref<PlanillaMensualResponse | null>(null);
const isLoading = ref(false);
const searchQuery = ref('');

// Filtros Set
const activeTipoObservador = ref(new Set<string>());
const activeTipoContrato = ref(new Set<string>());

const tiposObservador = computed(() => {
  if (!data.value) return [];
  return Array.from(new Set(data.value.matriz.map(r => r.observador.tipoObservador))).sort();
});

const tiposContrato = computed(() => {
  if (!data.value) return [];
  return Array.from(new Set(data.value.matriz.map(r => r.observador.tipoContrato))).sort();
});

const toggleTipoObservador = (t: string) => {
  if (activeTipoObservador.value.has(t)) {
    activeTipoObservador.value.delete(t);
  } else {
    activeTipoObservador.value.add(t);
  }
};

const toggleTipoContrato = (c: string) => {
  if (activeTipoContrato.value.has(c)) {
    activeTipoContrato.value.delete(c);
  } else {
    activeTipoContrato.value.add(c);
  }
};

const filteredMatriz = computed(() => {
  if (!data.value) return [];
  return data.value.matriz.filter(r => {
    const o = r.observador;
    const s = searchQuery.value.toLowerCase();
    const matchSearch = !s || `${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s);
    const matchTO = activeTipoObservador.value.has(o.tipoObservador);
    const matchTC = activeTipoContrato.value.has(o.tipoContrato);
    return matchSearch && matchTO && matchTC;
  });
});

const fetchData = async () => {
  isLoading.value = true;
  try {
    const response = await presentismoApi.obtenerPlanillaMensual(selectedYear.value, selectedMonth.value);
    
    // Inicializar filtros por defecto (marcar todos menos TECNICO, MONOTRIBUTISTA y PLANTA PERMANENTE)
    const newActiveTO = new Set<string>();
    const newActiveTC = new Set<string>();
    
    response.matriz.forEach(r => {
      if (r.observador.tipoObservador !== 'TECNICO') newActiveTO.add(r.observador.tipoObservador);
      if (r.observador.tipoContrato !== 'MONOTRIBUTISTA' && r.observador.tipoContrato !== 'PLANTA PERMANENTE') newActiveTC.add(r.observador.tipoContrato);
    });
    
    activeTipoObservador.value = newActiveTO;
    activeTipoContrato.value = newActiveTC;
    
    data.value = response;
  } catch (error) {
    toast.error('Ocurrió un error al cargar la planilla mensual');
    data.value = null;
  } finally {
    isLoading.value = false;
  }
};

const getDiaSemana = (dia: number) => {
  const date = new Date(selectedYear.value, selectedMonth.value - 1, dia);
  const days = ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sa'];
  return days[date.getDay()];
};

const isFinSemana = (dia: number) => {
  const date = new Date(selectedYear.value, selectedMonth.value - 1, dia);
  return date.getDay() === 0 || date.getDay() === 6;
};

const getCellClass = (dia: DiaEstado) => {
  if (!dia) return 'bg-transparent';
  
  switch (dia.estado) {
    case 'CONFLICTO':
      return 'bg-error shadow-inner animate-pulse';
    case 'NAVEGANDO':
      return 'bg-[#00FF00] shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'PUERTO':
      return 'bg-[#FFE4C4] shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'VIAJE':
      return 'bg-[#E6E6FA] shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'NOVEDAD':
      return 'bg-[#ADD8E6] shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'FERIADO':
      return 'bg-[#FFA500] shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'FIN_SEMANA':
      return 'bg-transparent';
    case 'LIBRE':
    default:
      return 'bg-transparent';
  }
};

const formatTooltipTitle = (estado: string) => {
  const map: Record<string, string> = {
    'NAVEGANDO': 'Navegando',
    'PUERTO': 'En Puerto (No Local)',
    'VIAJE': 'En Viaje',
    'NOVEDAD': 'Novedad / Licencia',
    'FERIADO': 'Feriado',
    'CONFLICTO': '¡Conflicto!',
  };
  return map[estado] || estado;
};

const isExporting = ref(false);

const exportToExcel = async () => {
  if (!data.value) return;
  
  isExporting.value = true;
  try {
    const params = {
      year: selectedYear.value,
      month: selectedMonth.value,
      ids: filteredMatriz.value.map(r => r.observador.id)
    };
    
    const blob = await presentismoExportService.exportarAExcel(params);
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    
    const filename = `PRESENTISMO_OBSERVADORES_${selectedYear.value}_${selectedMonth.value.toString().padStart(2, '0')}.xlsx`;
    
    link.setAttribute('download', filename);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
    
    toast.success('Planilla exportada a Excel correctamente');
  } catch (error) {
    toast.error('Error al exportar el Excel');
  } finally {
    isExporting.value = false;
  }
};

onMounted(() => {
  fetchData();
});
</script>

<style scoped>
/* Optional custom scrollbar for the table if needed */
.overflow-x-auto {
  scrollbar-width: thin;
}
</style>
