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
          <div class="w-8 h-6 rounded legend-navegando flex items-center justify-center text-[10px] font-black">NAVEG</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Navegando</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-puerto flex items-center justify-center text-[10px] font-black">PUERTO</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">En Puerto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-viaje flex items-center justify-center text-[10px] font-black">VIAJE</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">En Viaje</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-ez flex items-center justify-center text-[10px] font-black">EZ</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Esperando Zarpada</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-novedad flex items-center justify-center text-[10px] font-black">LICEN</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Novedad / Licencia</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-feriado flex items-center justify-center text-[10px] font-black">FERIADO</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Feriado</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded legend-conflicto flex items-center justify-center text-[10px] font-black">ERR</div>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Conflicto</span>
        </div>
        <div class="flex items-center gap-2">
          <div class="w-8 h-6 rounded border-2 legend-fc flex items-center justify-center text-[10px] font-black">FC</div>
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
      <div v-if="isLoading && !data" class="p-12 flex flex-col items-center justify-center bg-surface border border-border rounded-2xl">
        <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-sm font-bold text-text-muted">Cargando matriz de presentismo...</p>
      </div>

      <template v-else-if="data">
        <!-- Tabs -->
        <div class="flex items-center gap-4 border-b border-border mb-4 px-2">
          <button
            @click="activeTab = 'timeline'"
            :class="['px-4 py-2 font-bold text-sm border-b-2 transition-colors -mb-[1px]', activeTab === 'timeline' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text hover:border-border']"
          >
            Línea de Tiempo
          </button>
          <button
            @click="activeTab = 'grilla'"
            :class="['px-4 py-2 font-bold text-sm border-b-2 transition-colors -mb-[1px]', activeTab === 'grilla' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text hover:border-border']"
          >
            Tabla Clásica
          </button>
        </div>

        <!-- Matriz Table -->
        <div v-show="activeTab === 'grilla'" class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
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
                    <span v-else-if="row.dias[dia]?.estado === 'NAVEGANDO' && row.dias[dia]?.estadoSecundario === 'VIAJE'" class="text-[10px] font-black text-black px-1">N/V</span>
                    <span v-else-if="row.dias[dia]?.estado === 'NAVEGANDO'" class="text-[10px] font-black text-black px-1">NAVEG</span>
                    <span v-else-if="row.dias[dia]?.estado === 'PUERTO'" class="text-[10px] font-black text-black px-1">PUERTO</span>
                    <span v-else-if="row.dias[dia]?.estado === 'ESPERANDO_ZARPADA'" class="text-[10px] font-black text-black px-1">EZ</span>
                    <span v-else-if="row.dias[dia]?.estado === 'VIAJE'" class="text-[10px] font-black text-black px-1">VIAJE</span>
                    <span v-else-if="row.dias[dia]?.estado === 'NOVEDAD'" class="text-[10px] font-black text-black px-1">{{ row.dias[dia].codigoCorto === 'ENFERMEDAD' ? 'MÉDICO' : (row.dias[dia].codigoCorto || 'NOV') }}</span>
                    <span v-else-if="row.dias[dia]?.estado === 'FERIADO'" class="text-[10px] font-black text-black px-1">FERIADO</span>
                  </div>

                  <!-- Tooltip -->
                  <div v-if="row.dias[dia]?.estado !== 'LIBRE' && row.dias[dia]?.estado !== 'FIN_SEMANA'" class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 w-max max-w-[200px] bg-gray-900 dark:bg-gray-700 text-white text-xs p-2 rounded shadow-lg opacity-0 pointer-events-none group-hover/cell:opacity-100 transition-opacity z-30">
                    <div class="font-bold mb-1">{{ formatTooltipTitle(row.dias[dia]) }}</div>
                    <div class="text-[10px] text-gray-300 dark:text-gray-200 leading-tight" v-if="row.dias[dia].detalle || row.dias[dia].conflictoDetalle">
                      {{ row.dias[dia].conflictoDetalle || row.dias[dia].detalle }}
                    </div>
                    <!-- Triangulito -->
                    <div class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-gray-900 dark:border-t-gray-700"></div>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Timeline -->
      <div v-show="activeTab === 'timeline'" class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden p-4 flex flex-col gap-4">

        <div ref="timelineContainer" class="w-full h-[65vh] bg-surface text-text rounded-lg border border-border shadow-inner presentismo-timeline"></div>
      </div>

      </template>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch, nextTick } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import { ChevronDownIcon, DownloadIcon } from '@/icons';
import { toast } from 'vue-sonner';
import presentismoApi from '../services/presentismo.service';
import presentismoExportService from '../services/presentismo-export.service';
import type { PlanillaMensualResponse, DiaEstado } from '../interfaces/planilla-mensual.interface';
import { Timeline, type TimelineOptions } from 'vis-timeline/standalone';
import { DataSet } from 'vis-data';
import 'vis-timeline/styles/vis-timeline-graph2d.min.css';

const currentDate = new Date();
const selectedMonth = ref(currentDate.getMonth() + 1);
const selectedYear = ref(currentDate.getFullYear());
const availableYears = Array.from({length: 5}, (_, i) => currentDate.getFullYear() - 2 + i);

const months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

const data = ref<PlanillaMensualResponse | null>(null);
const prevData = ref<PlanillaMensualResponse | null>(null);
const nextData = ref<PlanillaMensualResponse | null>(null);
const isLoading = ref(false);
const searchQuery = ref('');

const activeTab = ref('timeline');

// Vis-Timeline
const timelineContainer = ref<HTMLElement | null>(null);
let timelineInstance: any = null;
let currentContainer: HTMLElement | null = null;




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
    const prevMonthDate = new Date(selectedYear.value, selectedMonth.value - 2, 1);
    const nextMonthDate = new Date(selectedYear.value, selectedMonth.value, 1);

    const [prevRes, currentRes, nextRes] = await Promise.all([
      presentismoApi.obtenerPlanillaMensual(prevMonthDate.getFullYear(), prevMonthDate.getMonth() + 1).catch(() => null),
      presentismoApi.obtenerPlanillaMensual(selectedYear.value, selectedMonth.value),
      presentismoApi.obtenerPlanillaMensual(nextMonthDate.getFullYear(), nextMonthDate.getMonth() + 1).catch(() => null)
    ]);

    // Inicializar filtros por defecto (marcar todos menos TECNICO y MONOTRIBUTISTA)
    const newActiveTO = new Set<string>();
    const newActiveTC = new Set<string>();

    currentRes.matriz.forEach((r: any) => {
      if (r.observador.tipoObservador !== 'TECNICO') newActiveTO.add(r.observador.tipoObservador);
      if (r.observador.tipoContrato !== 'MONOTRIBUTISTA') newActiveTC.add(r.observador.tipoContrato);
    });

    activeTipoObservador.value = newActiveTO;
    activeTipoContrato.value = newActiveTC;

    data.value = currentRes;
    prevData.value = prevRes;
    nextData.value = nextRes;
  } catch (error) {
    toast.error('Ocurrió un error al cargar la planilla mensual');
    data.value = null;
    prevData.value = null;
    nextData.value = null;
  } finally {
    isLoading.value = false;
  }
};

watch([activeTab, filteredMatriz, selectedMonth, selectedYear], async () => {
  if (!data.value) return;

  if (activeTab.value === 'timeline') {
    await nextTick();
    renderTimeline();
  }
}, { immediate: true });

const extractContiguousBlocks = (row: any) => {
  const dias = row.dias;
  const diasNumeros = Object.keys(dias).map(Number).sort((a, b) => a - b);

  let currentState: string | null = null;
  let currentStart: number | null = null;
  let currentEnd: number | null = null;
  let currentData: DiaEstado | null = null;
  const blocks: any[] = [];

  for (let i = 0; i < diasNumeros.length; i++) {
    const dia = diasNumeros[i];
    const diaData = dias[dia];

    if (!diaData || diaData.estado === 'LIBRE' || diaData.estado === 'FIN_SEMANA') {
      if (currentState && currentStart !== null && currentData) {
        blocks.push(buildBlockInfo(currentState, currentStart, dia - 1, currentData));
        currentState = null;
      }
      continue;
    }

    const estadoSignature = `${diaData.estado}-${diaData.estadoSecundario || ''}-${diaData.codigoCorto || ''}`;

    if (currentState !== estadoSignature) {
      if (currentState && currentStart !== null && currentData) {
        blocks.push(buildBlockInfo(currentState, currentStart, dia - 1, currentData));
      }
      currentState = estadoSignature;
      currentStart = dia;
      currentData = diaData;
    }
    currentEnd = dia;
  }

  if (currentState && currentStart !== null && currentEnd !== null && currentData) {
    blocks.push(buildBlockInfo(currentState, currentStart, currentEnd, currentData));
  }
  return blocks;
};

const buildBlockInfo = (stateSignature: string, startDia: number, endDia: number, diaData: DiaEstado) => {
  let className = 'bg-gray-200 text-black';
  let visClassName = 'vis-item-default';
  let content: string = diaData.estado;

  if (diaData.estado === 'CONFLICTO') {
    className = 'bg-error text-white animate-pulse border-none';
    visClassName = 'vis-item-conflicto';
  } else if (diaData.estado === 'NAVEGANDO' && diaData.estadoSecundario === 'VIAJE') {
    className = 'bg-[linear-gradient(135deg,#00FF00_50%,#E6E6FA_50%)] text-black';
    visClassName = 'vis-item-naveg-viaje';
    content = 'N/V';
  } else if (diaData.estado === 'NAVEGANDO') {
    className = 'bg-[#00FF00] text-black';
    visClassName = 'vis-item-navegando';
    content = 'NAVEG';
  } else if (diaData.estado === 'PUERTO') {
    className = 'bg-[#FFE4C4] text-black';
    visClassName = 'vis-item-puerto';
  } else if (diaData.estado === 'ESPERANDO_ZARPADA') {
    className = 'bg-[#E8E8E8] text-black';
    visClassName = 'vis-item-ez';
    content = 'EZ';
  } else if (diaData.estado === 'VIAJE') {
    className = 'bg-[#E6E6FA] text-black';
    visClassName = 'vis-item-viaje';
  } else if (diaData.estado === 'NOVEDAD') {
    className = 'bg-[#ADD8E6] text-black';
    visClassName = 'vis-item-novedad';
    content = diaData.codigoCorto === 'ENFERMEDAD' ? 'MÉDICO' : (diaData.codigoCorto || 'NOV');
  } else if (diaData.estado === 'FERIADO') {
    className = 'bg-[#FFA500] text-black';
    visClassName = 'vis-item-feriado';
  }

  return { startDia, endDia, content, className, visClassName, diaData };
};

const renderTimeline = () => {
  if (!timelineContainer.value) return;

  if (timelineInstance && currentContainer !== timelineContainer.value) {
    timelineInstance.destroy();
    timelineInstance = null;
  }

  const start = new Date(selectedYear.value, selectedMonth.value - 1, 1);
  const end = new Date(selectedYear.value, selectedMonth.value, 0, 23, 59, 59);

  if (!timelineInstance) {
    const options: TimelineOptions = {
      locale: 'es',
      stack: false,
      maxHeight: '65vh',
      verticalScroll: true,
      zoomKey: 'ctrlKey',
      horizontalScroll: true,
      zoomMin: 1000 * 60 * 60 * 24,
      zoomMax: 1000 * 60 * 60 * 24 * 31 * 3,
      margin: { item: 8, axis: 8 },
      orientation: 'top',
      editable: false,
      showCurrentTime: false,
      timeAxis: { scale: 'day', step: 1 },
      start: start,
      end: end
    };
    timelineInstance = new Timeline(timelineContainer.value, [], [], options);
    currentContainer = timelineContainer.value;
  }

  const groups = new DataSet(
    filteredMatriz.value.map(row => ({
      id: row.observador.id,
      content: `<div class="text-text" style="font-weight: bold; font-size: 13px; line-height: 1.2;">${row.observador.apellido}, ${row.observador.nombre}</div>`,
      value: row.observador.apellido
    }))
  );

  const itemsArray: any[] = [];

  const pushBlocksToItems = (matrizRow: any, year: number, month: number, isCurrentMonth: boolean) => {
    if (!matrizRow) return;
    const blocks = extractContiguousBlocks(matrizRow);
    blocks.forEach(block => {
      itemsArray.push({
        id: `${matrizRow.observador.id}-${year}-${month}-${block.startDia}`,
        group: matrizRow.observador.id,
        start: new Date(year, month - 1, block.startDia),
        end: new Date(year, month - 1, block.endDia + 1),
        content: block.content,
        className: block.visClassName + (isCurrentMonth ? '' : ' vis-item-attenuated'),
        title: `<div class="font-bold mb-1">${formatTooltipTitle(block.diaData)}</div>` +
               ((block.diaData.conflictoDetalle || block.diaData.detalle) ? `<div class="text-[10px] leading-tight opacity-90">${block.diaData.conflictoDetalle || block.diaData.detalle}</div>` : '')
      });
    });
  };

  const prevYear = selectedMonth.value === 1 ? selectedYear.value - 1 : selectedYear.value;
  const prevMonth = selectedMonth.value === 1 ? 12 : selectedMonth.value - 1;
  const nextYear = selectedMonth.value === 12 ? selectedYear.value + 1 : selectedYear.value;
  const nextMonth = selectedMonth.value === 12 ? 1 : selectedMonth.value + 1;

  filteredMatriz.value.forEach(row => {
    // Current month
    pushBlocksToItems(row, selectedYear.value, selectedMonth.value, true);

    // Previous month (find same observador)
    if (prevData.value) {
      const prevRow = prevData.value.matriz.find(r => r.observador.id === row.observador.id);
      if (prevRow) pushBlocksToItems(prevRow, prevYear, prevMonth, false);
    }

    // Next month
    if (nextData.value) {
      const nextRow = nextData.value.matriz.find(r => r.observador.id === row.observador.id);
      if (nextRow) pushBlocksToItems(nextRow, nextYear, nextMonth, false);
    }
  });

  timelineInstance.setGroups(groups);
  timelineInstance.setItems(new DataSet(itemsArray));

  timelineInstance.setWindow(start, end, { animation: false });
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
      return 'legend-conflicto shadow-inner animate-pulse';
    case 'NAVEGANDO':
      if (dia.estadoSecundario === 'VIAJE') return 'legend-naveg-viaje shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
      return 'legend-navegando shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'PUERTO':
      return 'legend-puerto shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'ESPERANDO_ZARPADA':
      return 'legend-ez shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'VIAJE':
      return 'legend-viaje shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'NOVEDAD':
      return 'legend-novedad shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'FERIADO':
      return 'legend-feriado shadow-[inset_0_0_0_1px_rgba(0,0,0,0.1)]';
    case 'FIN_SEMANA':
      return 'bg-transparent';
    case 'LIBRE':
    default:
      return 'bg-transparent';
  }
};

const formatTooltipTitle = (dia: DiaEstado) => {
  const estado = dia.estado;
  const map: Record<string, string> = {
    'NAVEGANDO': 'Navegando',
    'PUERTO': 'En Puerto (No Local)',
    'ESPERANDO_ZARPADA': 'Esperando Zarpada',
    'VIAJE': 'En Viaje',
    'NOVEDAD': 'Novedad / Licencia',
    'FERIADO': 'Feriado',
    'CONFLICTO': '¡Conflicto!',
  };
  let title = map[estado] || estado;
  if (estado === 'NAVEGANDO' && dia.estadoSecundario === 'VIAJE') {
    title += ' y En Viaje';
  }
  return title;
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

import { onBeforeUnmount } from 'vue';
onBeforeUnmount(() => {
  if (timelineInstance) {
    timelineInstance.destroy();
    timelineInstance = null;
  }
});
</script>

<style scoped>
/* Optional custom scrollbar for the table if needed */
.overflow-x-auto {
  scrollbar-width: thin;
}

:deep(.vis-item) {
  border-radius: 4px;
  border-color: rgba(0,0,0,0.1);
  color: black;
  box-shadow: inset 0 0 0 1px rgba(0,0,0,0.1);
}

.dark :deep(.vis-item) {
  border-color: rgba(255,255,255,0.1);
  box-shadow: inset 0 0 0 1px rgba(255,255,255,0.1);
}

:deep(.vis-item-attenuated) {
  opacity: 0.4 !important;
  filter: grayscale(0.6) !important;
  pointer-events: none;
}

/* Modificaciones para Modo Oscuro en Paneles y Grillas */
:deep(.vis-timeline) {
  border: none !important;
}

:deep(.vis-panel.vis-background),
:deep(.vis-panel.vis-bottom),
:deep(.vis-panel.vis-center),
:deep(.vis-panel.vis-left),
:deep(.vis-panel.vis-right),
:deep(.vis-panel.vis-top) {
  border-color: var(--color-border, #e5e7eb) !important;
}

:deep(.vis-time-axis .vis-grid.vis-minor),
:deep(.vis-time-axis .vis-grid.vis-major) {
  border-color: var(--color-border, #e5e7eb) !important;
}

:deep(.vis-labelset .vis-label) {
  border-color: var(--color-border, #e5e7eb) !important;
  color: var(--color-text) !important;
}

/* ESTILOS SEMÁNTICOS (Legend + Timeline Items) - MODO CLARO */
.legend-navegando, :global(.presentismo-timeline .vis-item-navegando) { background-color: #22c55e !important; color: white !important; border-color: #16a34a !important; border-width: 2px !important; border-style: solid !important; }
.legend-naveg-viaje, :global(.presentismo-timeline .vis-item-naveg-viaje) { background: linear-gradient(135deg, #22c55e 50%, #e0e7ff 50%) !important; color: black !important; border-color: #a5b4fc !important; border-width: 2px !important; border-style: solid !important; }
.legend-puerto, :global(.presentismo-timeline .vis-item-puerto) { background-color: #ffedd5 !important; color: black !important; border-color: #fdba74 !important; border-width: 2px !important; border-style: solid !important; }
.legend-viaje, :global(.presentismo-timeline .vis-item-viaje) { background-color: #e0e7ff !important; color: black !important; border-color: #a5b4fc !important; border-width: 2px !important; border-style: solid !important; }
.legend-ez, :global(.presentismo-timeline .vis-item-ez) { background-color: #f3f4f6 !important; color: black !important; border-color: #d1d5db !important; border-width: 2px !important; border-style: solid !important; }
.legend-novedad, :global(.presentismo-timeline .vis-item-novedad) { background-color: #e0f2fe !important; color: black !important; border-color: #7dd3fc !important; border-width: 2px !important; border-style: solid !important; }
.legend-feriado, :global(.presentismo-timeline .vis-item-feriado) { background-color: #f97316 !important; color: white !important; border-color: #c2410c !important; border-width: 2px !important; border-style: solid !important; }
.legend-conflicto, :global(.presentismo-timeline .vis-item-conflicto) { background-color: #ef4444 !important; color: white !important; border-color: #b91c1c !important; border-width: 2px !important; border-style: solid !important; }
.legend-fc { background-color: transparent !important; color: #ef4444 !important; border-color: #ef4444 !important; }

/* ESTILOS SEMÁNTICOS (Legend + Timeline Items) - MODO OSCURO */
:global(.dark) .legend-navegando, :global(.dark .presentismo-timeline .vis-item-navegando) { background-color: #15803d !important; color: white !important; border-color: #166534 !important; }
:global(.dark) .legend-naveg-viaje, :global(.dark .presentismo-timeline .vis-item-naveg-viaje) { background: linear-gradient(135deg, #15803d 50%, rgba(79, 70, 229, 0.4) 50%) !important; color: white !important; border-color: rgba(79, 70, 229, 0.5) !important; }
:global(.dark) .legend-puerto, :global(.dark .presentismo-timeline .vis-item-puerto) { background-color: rgba(234, 88, 12, 0.3) !important; color: #ffedd5 !important; border-color: rgba(234, 88, 12, 0.5) !important; }
:global(.dark) .legend-viaje, :global(.dark .presentismo-timeline .vis-item-viaje) { background-color: rgba(79, 70, 229, 0.3) !important; color: #e0e7ff !important; border-color: rgba(79, 70, 229, 0.5) !important; }
:global(.dark) .legend-ez, :global(.dark .presentismo-timeline .vis-item-ez) { background-color: #374151 !important; color: #e5e7eb !important; border-color: #4b5563 !important; }
:global(.dark) .legend-novedad, :global(.dark .presentismo-timeline .vis-item-novedad) { background-color: rgba(14, 165, 233, 0.3) !important; color: #bae6fd !important; border-color: rgba(14, 165, 233, 0.5) !important; }
:global(.dark) .legend-feriado, :global(.dark .presentismo-timeline .vis-item-feriado) { background-color: #9a3412 !important; color: white !important; border-color: #7c2d12 !important; }
:global(.dark) .legend-conflicto, :global(.dark .presentismo-timeline .vis-item-conflicto) { background-color: #991b1b !important; color: white !important; border-color: #7f1d1d !important; }
:global(.dark) .legend-fc { background-color: transparent !important; color: #f87171 !important; border-color: #f87171 !important; }


:global(.presentismo-timeline .vis-item-content) {
  padding: 4px 6px !important;
  width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: 12px !important;
  font-weight: 500 !important;
  box-sizing: border-box !important;
  line-height: 1.2 !important;
  display: block !important;
}

:deep(.vis-label) {
  font-size: 13px !important;
}

:deep(.vis-label .vis-inner) {
  padding: 8px 6px !important;
}

:deep(.vis-label .vis-inner div) {
  font-size: 13px !important;
  line-height: 1.2 !important;
}

:deep(.vis-time-axis .vis-text) {
  font-weight: 500;
  color: var(--color-text-muted, #374151) !important;
}

:deep(.vis-time-axis .vis-text.vis-saturday),
:deep(.vis-time-axis .vis-text.vis-sunday) {
  color: #ef4444 !important; /* text-red-500 */
  font-weight: bold !important;
}

/* Modificaciones para el Tooltip en Vis-Timeline (Timeline Mode) */
:global(.vis-tooltip) {
  background-color: #111827 !important; /* bg-gray-900 */
  color: #ffffff !important;
  font-size: 12px !important;
  font-family: inherit !important;
  padding: 8px !important;
  border-radius: 4px !important;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05) !important;
  border: none !important;
  z-index: 1000 !important;
  pointer-events: none !important;
  white-space: normal !important;
  max-width: 250px !important;
}

:global(.dark .vis-tooltip) {
  background-color: #374151 !important; /* bg-gray-700 */
  border: 1px solid #4b5563 !important; /* border-gray-600 */
  color: #f3f4f6 !important; /* text-gray-100 */
}
</style>
