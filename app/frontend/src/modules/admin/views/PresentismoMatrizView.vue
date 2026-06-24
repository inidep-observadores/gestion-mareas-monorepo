<template>
  <AdminLayout>
    <div class="space-y-6">
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
          <div class="w-4 h-4 rounded bg-primary/20 border border-primary/50"></div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Navegando</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 rounded bg-warning/20 border border-warning/50"></div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Puerto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 rounded bg-info/20 border border-info/50"></div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Novedad / Licencia</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 rounded bg-error text-white flex items-center justify-center text-[10px] font-black">!</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Conflicto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-4 h-4 rounded bg-gray-100 dark:bg-gray-800 border border-border"></div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Feriado / Fin de Semana</span>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading" class="p-12 flex flex-col items-center justify-center bg-surface border border-border rounded-2xl">
        <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-sm font-bold text-text-muted">Cargando matriz de presentismo...</p>
      </div>

      <!-- Matriz Table -->
      <div v-else-if="data" class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
        <div class="overflow-x-auto">
          <table class="w-full text-left border-collapse">
            <thead>
              <tr class="bg-surface-muted border-b border-border">
                <th class="sticky left-0 z-20 bg-surface-muted px-4 py-3 text-xs font-black uppercase tracking-widest text-text min-w-[200px] border-r border-border shadow-[2px_0_5px_-2px_rgba(0,0,0,0.1)]">
                  Observador
                </th>
                <!-- Totales -->
                <th class="px-2 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center border-r border-border" title="Navegando">NAV</th>
                <th class="px-2 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center border-r border-border" title="Puerto">PTO</th>
                <th class="px-2 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center border-r border-border" title="Novedades">NOV</th>
                <th class="px-2 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center border-r border-border" title="Conflictos">ERR</th>
                <!-- Días -->
                <th v-for="dia in data.diasMes" :key="dia" class="px-1 py-3 text-center border-r border-border min-w-[36px]">
                  <div class="flex flex-col items-center justify-center">
                    <span class="text-xs font-black text-text">{{ dia }}</span>
                    <span class="text-[9px] font-bold text-text-muted uppercase" v-if="data.feriados[dia]" title="Feriado">F</span>
                  </div>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in data.matriz" :key="row.observador.id" class="border-b border-border hover:bg-surface-muted/50 transition-colors group">
                <td class="sticky left-0 z-10 bg-surface group-hover:bg-surface-muted/50 px-4 py-2 border-r border-border shadow-[2px_0_5px_-2px_rgba(0,0,0,0.1)] transition-colors">
                  <div class="font-bold text-sm text-text truncate">
                    {{ row.observador.apellido }}, {{ row.observador.nombre }}
                  </div>
                </td>
                
                <!-- Totales -->
                <td class="px-2 py-2 text-center text-xs font-bold text-text border-r border-border">{{ row.totales.navegando }}</td>
                <td class="px-2 py-2 text-center text-xs font-bold text-text border-r border-border">{{ row.totales.puerto }}</td>
                <td class="px-2 py-2 text-center text-xs font-bold text-text border-r border-border">{{ row.totales.novedades }}</td>
                <td class="px-2 py-2 text-center text-xs font-black border-r border-border" :class="row.totales.conflictos > 0 ? 'text-error' : 'text-text-muted'">
                  {{ row.totales.conflictos }}
                </td>

                <!-- Días -->
                <td v-for="dia in data.diasMes" :key="dia" class="p-1 border-r border-border relative group/cell">
                  <div class="w-full h-8 rounded flex items-center justify-center transition-all cursor-default" :class="getCellClass(row.dias[dia])">
                    <span v-if="row.dias[dia]?.estado === 'CONFLICTO'" class="text-white text-[10px] font-black">!</span>
                    <span v-else-if="row.dias[dia]?.estado === 'NAVEGANDO'" class="text-primary text-[10px] font-black">N</span>
                    <span v-else-if="row.dias[dia]?.estado === 'PUERTO'" class="text-warning text-[10px] font-black">P</span>
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
import { ref, onMounted } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
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

const fetchData = async () => {
  isLoading.value = true;
  try {
    data.value = await presentismoApi.obtenerPlanillaMensual(selectedYear.value, selectedMonth.value);
  } catch (error) {
    toast.error('Ocurrió un error al cargar la planilla mensual');
    data.value = null;
  } finally {
    isLoading.value = false;
  }
};

const getCellClass = (dia: DiaEstado) => {
  if (!dia) return 'bg-transparent';
  
  switch (dia.estado) {
    case 'CONFLICTO':
      return 'bg-error shadow-inner animate-pulse';
    case 'NAVEGANDO':
      return 'bg-primary/20 border border-primary/50';
    case 'PUERTO':
      return 'bg-warning/20 border border-warning/50';
    case 'NOVEDAD':
      return 'bg-info/20 border border-info/50';
    case 'FERIADO':
    case 'FIN_SEMANA':
      return 'bg-gray-100 dark:bg-gray-800 border border-border';
    case 'LIBRE':
    default:
      return 'bg-transparent';
  }
};

const formatTooltipTitle = (estado: string) => {
  const map: Record<string, string> = {
    'NAVEGANDO': 'Navegando',
    'PUERTO': 'En Puerto (No Local)',
    'NOVEDAD': 'Novedad / Licencia',
    'FERIADO': 'Feriado',
    'CONFLICTO': '¡Conflicto!',
  };
  return map[estado] || estado;
};

const exportToExcel = () => {
  if (data.value) {
    presentismoExportService.exportarAExcel(data.value);
    toast.success('Planilla exportada a Excel correctamente');
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
