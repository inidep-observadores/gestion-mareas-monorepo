<template>
  <AdminLayout>
    <div class="sticky top-[56px] lg:top-[72px] z-30 bg-surface pt-2 pb-3 -mx-4 px-4 sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8 border-b border-border mb-6 flex flex-col gap-4">
      <BackButton routeName="SistemaObservadores" label="Regresar al Panel" />

      <!-- Encabezado Principal & Acciones -->
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div>
          <h1 class="text-2xl font-black text-text uppercase tracking-tight">Disponibilidad de Observadores</h1>
          <p class="text-sm font-medium text-text-muted mt-1">Línea de tiempo con proyección dinámica e identificación de flexibilidad</p>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <!-- Búsqueda por texto fija y visible -->
          <SearchInput v-model="searchQuery" placeholder="Buscar observador..." class="w-full sm:w-64" />

          <!-- Selector de Horizonte -->
          <div class="flex items-center rounded-lg border border-border bg-surface p-1 shadow-sm">
            <button
              v-for="h in horizontes"
              :key="h.valor"
              @click="cambiarHorizonte(h.valor)"
              class="px-3 py-1.5 text-xs font-bold rounded-md transition-all uppercase tracking-wider"
              :class="horizonteSeleccionado === h.valor ? 'bg-primary text-white shadow-sm' : 'text-text-muted hover:text-text hover:bg-surface-muted'"
            >
              {{ h.etiqueta }}
            </button>
          </div>

          <!-- Botón Hoy -->
          <button
            @click="centrarEnHoy"
            class="h-9 px-3.5 inline-flex items-center justify-center gap-1.5 text-xs font-bold tracking-widest uppercase transition-all rounded-lg bg-surface border border-border text-primary hover:bg-primary/5 active:scale-95 shadow-sm"
            title="Centrar línea de tiempo en el día actual"
          >
            Hoy
          </button>
        </div>
      </div>

      <!-- Filtros Compactos Expandibles -->
      <div v-if="data" class="rounded-xl border border-border bg-surface shadow-sm overflow-hidden">
        <button
          @click="isFiltersExpanded = !isFiltersExpanded"
          class="w-full flex items-center justify-between px-4 py-3 text-left transition-colors hover:bg-surface-muted/50 cursor-pointer"
        >
          <span class="text-xs font-black uppercase tracking-widest text-text">
            Filtros
          </span>
          <ChevronDownIcon
            class="w-4 h-4 text-text-muted transition-transform duration-300"
            :class="{ 'rotate-180': isFiltersExpanded }"
          />
        </button>

        <Transition
          enter-active-class="transition-all duration-300 ease-out"
          enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[500px] opacity-100"
          leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[500px] opacity-100"
          leave-to-class="max-h-0 opacity-0"
        >
          <div v-if="isFiltersExpanded" class="p-4 pt-3 border-t border-border/50 flex flex-wrap items-center gap-6">
            <div class="flex flex-wrap items-center gap-4 flex-1">
              <div class="flex items-center gap-2">
                <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-1">Observador:</span>
                <button
                  v-for="t in tiposObservador"
                  :key="t"
                  @click="toggleTipoObservador(t)"
                  class="px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase transition-all"
                  :class="activeTipoObservador.has(t) ? 'bg-primary/10 border border-primary text-primary' : 'bg-surface border border-border text-text-muted opacity-50'"
                >
                  {{ t }}
                </button>
              </div>

              <div class="w-px h-6 bg-border mx-2 hidden lg:block"></div>

              <div class="flex items-center gap-2">
                <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-1">Contrato:</span>
                <button
                  v-for="c in tiposContrato"
                  :key="c"
                  @click="toggleTipoContrato(c)"
                  class="px-3 py-1 rounded-full text-[10px] font-black tracking-widest uppercase transition-all"
                  :class="activeTipoContrato.has(c) ? 'bg-info/10 border border-info text-info' : 'bg-surface border border-border text-text-muted opacity-50'"
                >
                  {{ c }}
                </button>
              </div>
            </div>

            <!-- Divisor y Sección de Filtrado por Rango de Disponibilidad -->
            <div class="w-full border-t border-border/50 pt-3 flex flex-col gap-3">
              <div class="flex flex-wrap items-center justify-between gap-3">
                <label class="inline-flex items-center gap-2 cursor-pointer select-none">
                  <input
                    type="checkbox"
                    v-model="ocultarNoDisponibles"
                    class="checkbox checkbox-primary checkbox-sm rounded"
                  />
                  <span class="text-xs font-black uppercase tracking-wider text-text">
                    Ocultar no disponibles entre fechas
                  </span>
                </label>

                <span v-if="ocultarNoDisponibles" class="text-[11px] font-medium text-text-muted">
                  Mostrando observadores con disponibilidad continua o novedades flexibles entre el {{ formatDateLabel(filtroFechaInicio) }} y el {{ formatDateLabel(filtroFechaFin) }} ({{ diasRangoSeleccionado }} días)
                </span>
              </div>

              <!-- Controles de Rango: DatePickers y Slider Doble -->
              <div
                v-if="ocultarNoDisponibles"
                class="flex flex-col lg:flex-row items-stretch lg:items-center gap-4 bg-surface-muted/30 p-3 rounded-xl border border-border/60"
              >
                <!-- Selectores de Fecha -->
                <div class="flex items-center gap-2 sm:gap-3 shrink-0">
                  <div class="w-36 sm:w-40">
                    <span class="text-[9px] font-black uppercase tracking-widest text-text-muted block mb-1">Desde</span>
                    <DatePicker
                      v-model="filtroFechaInicio"
                      :show-time="false"
                      placeholder="Fecha inicio"
                    />
                  </div>
                  <div class="w-36 sm:w-40">
                    <span class="text-[9px] font-black uppercase tracking-widest text-text-muted block mb-1">Hasta</span>
                    <DatePicker
                      v-model="filtroFechaFin"
                      :show-time="false"
                      placeholder="Fecha fin"
                    />
                  </div>
                </div>

                <!-- Slider Doble -->
                <div class="flex-1 flex flex-col justify-center px-2 sm:px-4 min-w-[200px]">
                  <div class="flex justify-between items-center text-[10px] font-bold text-text-muted mb-1 uppercase tracking-wider">
                    <span>Hoy</span>
                    <span class="text-primary font-black">{{ diasRangoSeleccionado }} días seleccionados</span>
                    <span>Máx 6m (+180d)</span>
                  </div>
                  <DoubleRangeSlider
                    v-model="sliderRangeDays"
                    :min="0"
                    :max="180"
                    :step="1"
                    :min-distance="0"
                  />
                </div>
              </div>
            </div>
          </div>
        </Transition>
      </div>
    </div>

    <!-- Timeline Container -->
    <div class="space-y-6">
      <div v-if="isLoading && !data" class="p-12 flex flex-col items-center justify-center bg-surface border border-border rounded-2xl">
        <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
        <p class="text-sm font-bold text-text-muted">Cargando disponibilidad de observadores...</p>
      </div>

      <div v-else-if="data" class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden p-4 flex flex-col gap-4">
        <div ref="timelineContainer" class="w-full h-[74vh] bg-surface text-text rounded-lg border border-border shadow-inner disponibilidad-timeline"></div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount, computed, watch, nextTick } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import DatePicker from '@/components/common/DatePicker.vue';
import DoubleRangeSlider from '@/components/common/DoubleRangeSlider.vue';
import { ChevronDownIcon } from '@/icons';
import { toast } from 'vue-sonner';
import disponibilidadApi from '../services/disponibilidad.service';
import type { DisponibilidadResponse, ObservadorDisponibilidadItem, ObservadorDisponibilidadRow } from '../interfaces/disponibilidad.interface';
import { Timeline, type TimelineOptions } from 'vis-timeline/standalone';
import { DataSet } from 'vis-data';
import 'vis-timeline/styles/vis-timeline-graph2d.min.css';

const horizontes = [
  { etiqueta: '15 Días', valor: '15d' },
  { etiqueta: '1 Mes', valor: '1m' },
  { etiqueta: '3 Meses', valor: '3m' },
  { etiqueta: '6 Meses', valor: '6m' },
];

const horizonteSeleccionado = ref('15d');
const data = ref<DisponibilidadResponse | null>(null);
const isLoading = ref(false);
const searchQuery = ref('');
const isFiltersExpanded = ref(false);

// Filtro de Disponibilidad en Rango de Fechas
const ocultarNoDisponibles = ref(false);
const filtroFechaInicio = ref<string | null>(null);
const filtroFechaFin = ref<string | null>(null);
const sliderRangeDays = ref<[number, number]>([0, 15]);

// Vis-Timeline
const timelineContainer = ref<HTMLElement | null>(null);
let timelineInstance: any = null;
let currentContainer: HTMLElement | null = null;

// Filtros Set
const activeTipoObservador = ref(new Set<string>());
const activeTipoContrato = ref(new Set<string>());

const tiposObservador = computed(() => {
  if (!data.value) return [];
  return Array.from(new Set(data.value.observadores.map(r => r.observador.tipoObservador))).sort();
});

const tiposContrato = computed(() => {
  if (!data.value) return [];
  return Array.from(new Set(data.value.observadores.map(r => r.observador.tipoContrato))).sort();
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

const diasRangoSeleccionado = computed(() => {
  return Math.max(0, sliderRangeDays.value[1] - sliderRangeDays.value[0]);
});

const formatDateLabel = (dateStr: string | null): string => {
  if (!dateStr) return '-';
  const clean = dateStr.includes('T') ? dateStr.split('T')[0] : dateStr;
  const parts = clean.split('-');
  if (parts.length === 3) {
    return `${parts[2]}/${parts[1]}/${parts[0]}`;
  }
  return dateStr;
};

const formatIsoLocal = (d: Date): string => {
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const parseIsoDate = (str: string): Date => {
  const clean = str.includes('T') ? str.split('T')[0] : str;
  const [y, m, d] = clean.split('-').map(Number);
  return new Date(y, m - 1, d, 0, 0, 0, 0);
};

const diffDaysFromHoy = (d: Date, hoy: Date): number => {
  const timeDiff = d.getTime() - hoy.getTime();
  return Math.round(timeDiff / (1000 * 60 * 60 * 24));
};

// Sincronización bidireccional Slider <-> DatePickers
let isSyncingDates = false;

watch(sliderRangeDays, (newRange) => {
  if (isSyncingDates || !data.value) return;
  isSyncingDates = true;
  const hoy = parseIsoDate(data.value.fechaHoy);
  const dInicio = new Date(hoy);
  dInicio.setDate(dInicio.getDate() + newRange[0]);

  const dFin = new Date(hoy);
  dFin.setDate(dFin.getDate() + newRange[1]);

  filtroFechaInicio.value = formatIsoLocal(dInicio);
  filtroFechaFin.value = formatIsoLocal(dFin);
  nextTick(() => {
    isSyncingDates = false;
  });
});

watch([filtroFechaInicio, filtroFechaFin], ([newIni, newFin]) => {
  if (isSyncingDates || !data.value || !newIni || !newFin) return;
  isSyncingDates = true;
  const hoy = parseIsoDate(data.value.fechaHoy);
  const dIni = parseIsoDate(newIni);
  const dFin = parseIsoDate(newFin);

  const offsetIni = Math.max(0, Math.min(180, diffDaysFromHoy(dIni, hoy)));
  const offsetFin = Math.max(offsetIni, Math.min(180, diffDaysFromHoy(dFin, hoy)));

  sliderRangeDays.value = [offsetIni, offsetFin];
  nextTick(() => {
    isSyncingDates = false;
  });
});

/**
 * Evalúa si un observador cumple con disponibilidad completa o flexibilidad en todo el rango seleccionado.
 * Si tiene cualquier "no disponibilidad" (navegación, designación, licencia, impedimento, novedad no flexible),
 * queda excluido.
 */
const cumpleDisponibilidadEnRango = (row: ObservadorDisponibilidadRow, rIniStr: string, rFinStr: string): boolean => {
  const rangeStart = parseIsoDate(rIniStr).getTime();
  const rangeEnd = parseIsoDate(rFinStr).getTime();

  // Si tiene impedimento global activo, queda excluido
  if (row.observador.conImpedimento || !row.observador.disponible) {
    return false;
  }

  for (const item of row.eventos) {
    const itemStart = parseIsoDate(item.startDate).getTime();
    const itemEnd = parseIsoDate(item.endDate).getTime();

    // Comprobar si el evento intersecta el período evaluado [rangeStart, rangeEnd + 1 día exclusivo]
    // Nota: item.endDate en los eventos del timeline es exclusivo (+1 día del último día del bloque)
    const intersecta = itemStart <= rangeEnd && itemEnd > rangeStart;
    if (!intersecta) continue;

    // Verificar si el evento representa una no disponibilidad
    if (item.estado === 'DISPONIBLE' || item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
      // Es disponibilidad válida
      continue;
    }

    if (item.estado === 'NOVEDAD' && item.flexible === true) {
      // Admite cancelación por urgencia (ej: Franco Compensatorio)
      continue;
    }

    // Cualquier otro estado (NAVEGANDO, DESIGNADA, PUERTO, VIAJE, IMPEDIMENTO, CONFLICTO, NOVEDAD no flexible)
    // constituye una "no disponibilidad" que descalifica al observador
    return false;
  }

  return true;
};

const filteredObservadores = computed(() => {
  if (!data.value) return [];
  return data.value.observadores.filter(r => {
    const o = r.observador;
    const s = searchQuery.value.toLowerCase();
    const matchSearch = !s || `${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s);
    const matchTO = activeTipoObservador.value.has(o.tipoObservador);
    const matchTC = activeTipoContrato.value.has(o.tipoContrato);

    if (!matchSearch || !matchTO || !matchTC) {
      return false;
    }

    // Filtro estricto de ocultar no disponibles en rango de fechas
    if (ocultarNoDisponibles.value && filtroFechaInicio.value && filtroFechaFin.value) {
      return cumpleDisponibilidadEnRango(r, filtroFechaInicio.value, filtroFechaFin.value);
    }

    return true;
  });
});

const calcularFinVentana = (hoy: Date, horizonte: string): Date => {
  const fin = new Date(hoy);
  if (horizonte === '15d') {
    fin.setDate(fin.getDate() + 15);
  } else if (horizonte === '1m') {
    fin.setMonth(fin.getMonth() + 1);
  } else if (horizonte === '3m') {
    fin.setMonth(fin.getMonth() + 3);
  } else if (horizonte === '6m') {
    fin.setMonth(fin.getMonth() + 6);
  } else {
    fin.setDate(fin.getDate() + 15);
  }
  return fin;
};

const fetchData = async () => {
  isLoading.value = true;
  try {
    // Calculamos siempre al horizonte máximo de 6 meses para navegación fluida
    const res = await disponibilidadApi.obtenerDisponibilidad(6);

    // Inicializar filtros activos si están vacíos (todas las opciones habilitadas por default)
    if (activeTipoObservador.value.size === 0 && activeTipoContrato.value.size === 0) {
      const newActiveTO = new Set<string>();
      const newActiveTC = new Set<string>();
      res.observadores.forEach(r => {
        if (r.observador.tipoObservador) newActiveTO.add(r.observador.tipoObservador);
        if (r.observador.tipoContrato) newActiveTC.add(r.observador.tipoContrato);
      });
      activeTipoObservador.value = newActiveTO;
      activeTipoContrato.value = newActiveTC;
    }

    data.value = res;

    // Inicializar rango de fechas por default (hoy - horizonte)
    const hoy = parseIsoDate(res.fechaHoy);
    const finHorizonte = calcularFinVentana(hoy, horizonteSeleccionado.value);
    const diasHorizonte = diffDaysFromHoy(finHorizonte, hoy);

    filtroFechaInicio.value = formatIsoLocal(hoy);
    filtroFechaFin.value = formatIsoLocal(finHorizonte);
    sliderRangeDays.value = [0, diasHorizonte];
  } catch (error) {
    toast.error('Ocurrió un error al cargar la disponibilidad');
    data.value = null;
  } finally {
    isLoading.value = false;
  }
};

const cambiarHorizonte = (hValor: string) => {
  horizonteSeleccionado.value = hValor;
  if (!data.value) return;

  const hoy = parseIsoDate(data.value.fechaHoy);
  const fin = calcularFinVentana(hoy, hValor);

  // Actualizar automáticamente la fecha de fin y el slider del filtro de disponibilidad
  filtroFechaFin.value = formatIsoLocal(fin);
  const offsetFin = Math.max(sliderRangeDays.value[0], Math.min(180, diffDaysFromHoy(fin, hoy)));
  sliderRangeDays.value = [sliderRangeDays.value[0], offsetFin];

  if (timelineInstance) {
    timelineInstance.setWindow(hoy, fin, { animation: true });
  }
};

const centrarEnHoy = () => {
  if (!timelineInstance || !data.value) return;
  const hoy = parseIsoDate(data.value.fechaHoy);
  const fin = calcularFinVentana(hoy, horizonteSeleccionado.value);
  timelineInstance.setWindow(hoy, fin, { animation: true });
};

const formatFechasRango = (startIso: string, endIso: string): string => {
  const start = new Date(startIso.includes('T') ? startIso : startIso + 'T00:00:00');
  const end = new Date(endIso.includes('T') ? endIso : endIso + 'T00:00:00');

  const fStart = start.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: 'numeric' });
  const fEnd = end.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit', year: 'numeric' });

  const diffTime = Math.abs(end.getTime() - start.getTime());
  const diffDays = Math.round(diffTime / (1000 * 60 * 60 * 24)) + 1;

  if (fStart === fEnd) {
    return `${fStart} (1 día)`;
  }
  return `${fStart} – ${fEnd} (${diffDays} días)`;
};

const formatItemTooltip = (item: ObservadorDisponibilidadItem, nombreObs: string): string => {
  let titulo = '';
  let tituloColor = 'text-white';

  if (item.estado === 'DISPONIBLE') {
    titulo = 'Disponible para embarque';
    tituloColor = 'text-amber-400';
  } else if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    titulo = 'Disponibilidad no confirmada';
    tituloColor = 'text-amber-300';
  } else if (item.estado === 'DESIGNADA') {
    titulo = 'Marea Designada (Previsto)';
    tituloColor = 'text-emerald-400';
  } else if (item.estado === 'IMPEDIMENTO') {
    titulo = 'Con Impedimento';
    tituloColor = 'text-red-400';
  } else if (item.estado === 'NAVEGANDO') {
    titulo = 'Navegación';
    tituloColor = 'text-emerald-400';
  } else if (item.estado === 'PUERTO') {
    titulo = 'En Puerto (No local)';
    tituloColor = 'text-orange-400';
  } else if (item.estado === 'ESPERANDO_ZARPADA') {
    titulo = 'Esperando zarpada';
    tituloColor = 'text-gray-300';
  } else if (item.estado === 'VIAJE') {
    titulo = 'En Viaje / Tránsito';
    tituloColor = 'text-indigo-400';
  } else if (item.estado === 'NOVEDAD') {
    const cod = (item.codigoCorto || '').toUpperCase();
    if (cod === 'NO_DISP' || cod === 'NO DISPONIBLE' || cod === 'NO_DISPONIBLE') {
      titulo = 'No Disponible';
      tituloColor = 'text-red-400';
    } else if (cod === 'FC') {
      titulo = 'Franco Compensatorio';
      tituloColor = 'text-amber-400';
    } else if (cod === 'LICEN' || cod === 'LICENCIA') {
      titulo = 'Licencia / Vacaciones';
      tituloColor = 'text-sky-400';
    } else if (cod === 'DONACION_SANGRE') {
      titulo = 'Donación de Sangre';
      tituloColor = 'text-sky-400';
    } else if (cod === 'RP') {
      titulo = 'Razones Particulares';
      tituloColor = 'text-sky-400';
    } else {
      titulo = item.codigoCorto ? item.codigoCorto.replace(/_/g, ' ') : 'Novedad';
      tituloColor = 'text-sky-400';
    }
  } else if (item.estado === 'CONFLICTO') {
    titulo = 'Conflicto de eventos';
    tituloColor = 'text-red-400';
  } else {
    titulo = String(item.estado || '').replace(/_/g, ' ');
  }

  const rangoStr = formatFechasRango(item.startDate, item.endDate);

  let html = `<div class="font-bold text-xs ${tituloColor} mb-0.5">${titulo}</div>`;
  html += `<div class="text-[11px] text-gray-300 font-mono mb-1">📅 ${rangoStr}</div>`;

  // Detalle adicional limpio (solo si aporta información y no repite el título)
  if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    html += `<div class="text-xs text-amber-200/95 mt-1 font-medium">El observador no confirmó la disponibilidad</div>`;
  } else if (item.estado === 'DESIGNADA') {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 font-medium mt-1">${item.detalle}</div>`;
    }
    html += `<div class="text-[10px] text-emerald-300/80 mt-0.5 italic">Asignación prevista aún no confirmada</div>`;
  } else if (item.estado === 'NOVEDAD' && (item.codigoCorto === 'NO_DISP' || item.codigoCorto === 'NO DISPONIBLE' || item.codigoCorto === 'NO_DISPONIBLE')) {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 mt-0.5">${item.detalle}</div>`;
    }
  } else if (item.estado === 'IMPEDIMENTO') {
    if (item.detalle && item.detalle !== 'IMPEDIMENTO') {
      html += `<div class="text-xs text-red-200 mt-0.5">${item.detalle}</div>`;
    }
  } else if (item.estado !== 'DISPONIBLE' && item.detalle && item.detalle !== titulo) {
    html += `<div class="text-xs text-gray-200 mt-0.5">${item.detalle}</div>`;
  }

  if (item.flexible) {
    html += `<div class="mt-2 inline-block px-2 py-0.5 rounded bg-amber-500/20 text-amber-200 border border-amber-400/40 text-[10px] font-bold">` +
            `⚡ Permite cancelación anticipada por urgencia</div>`;
  }

  return html;
};

const getNovedadLabel = (codigoCorto?: string): string => {
  if (!codigoCorto) return 'NOVEDAD';
  const clean = codigoCorto.trim().toUpperCase();

  switch (clean) {
    case 'NO_DISP':
    case 'NO DISP':
    case 'NO_DISPONIBLE':
    case 'NO DISPONIBLE':
      return 'NO DISPONIBLE';
    case 'FC':
      return 'FRANCO';
    case 'LICEN':
    case 'LICENCIA':
      return 'LICENCIA';
    case 'ENFERMEDAD':
      return 'ENFERMEDAD';
    case 'RP':
      return 'RAZONES PART.';
    case 'MATERNIDAD':
      return 'MATERNIDAD';
    case 'NACIMIENTO':
      return 'NACIMIENTO';
    case 'FALLECIMIENTO':
      return 'DUELO';
    case 'EXAMEN':
      return 'EXAMEN';
    case 'DONACION_SANGRE':
      return 'DONACIÓN SANGRE';
    case 'VIAJE_INICIO':
    case 'VIAJE_FIN':
    case 'TRANSITO_INICIO':
    case 'TRANSITO_FIN':
      return 'EN VIAJE';
    default:
      return clean.replace(/_/g, ' ');
  }
};

const getBloqueLabel = (item: ObservadorDisponibilidadItem): string => {
  switch (item.estado) {
    case 'DISPONIBLE':
      return 'DISPONIBLE';
    case 'DISPONIBLE_NO_CONFIRMADA':
      return '¿DISPONIBLE?';
    case 'DESIGNADA':
      return 'DESIGNADA';
    case 'NAVEGANDO':
      return 'NAVEGANDO';
    case 'IMPEDIMENTO':
      return 'IMPEDIMENTO';
    case 'PUERTO':
      return 'EN PUERTO';
    case 'VIAJE':
      return 'EN VIAJE';
    case 'ESPERANDO_ZARPADA':
      return 'DISPONIBLE';
    case 'CONFLICTO':
      return 'CONFLICTO';
    case 'NOVEDAD':
      return getNovedadLabel(item.codigoCorto);
    default:
      return (item.codigoCorto || String(item.estado || '')).replace(/_/g, ' ');
  }
};

const getItemVisClass = (item: ObservadorDisponibilidadItem): string => {
  let baseClass = 'vis-item-default';

  if (item.estado === 'DISPONIBLE') {
    baseClass = 'vis-item-disponible';
  } else if (item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
    baseClass = 'vis-item-disponible-no-confirmada';
  } else if (item.estado === 'IMPEDIMENTO') {
    baseClass = 'vis-item-impedido';
  } else if (item.estado === 'NAVEGANDO') {
    baseClass = item.estadoSecundario === 'VIAJE' ? 'vis-item-naveg-viaje' : 'vis-item-navegando';
  } else if (item.estado === 'DESIGNADA') {
    baseClass = 'vis-item-designada';
  } else if (item.estado === 'PUERTO') {
    baseClass = 'vis-item-puerto';
  } else if (item.estado === 'ESPERANDO_ZARPADA') {
    baseClass = 'vis-item-ez';
  } else if (item.estado === 'VIAJE') {
    baseClass = 'vis-item-viaje';
  } else if (item.estado === 'NOVEDAD') {
    const cod = (item.codigoCorto || '').toUpperCase();
    if (cod === 'NO DISPONIBLE' || cod === 'NO_DISP' || cod === 'NO_DISPONIBLE') {
      baseClass = 'vis-item-no-disponible';
    } else {
      baseClass = 'vis-item-novedad';
    }
  } else if (item.estado === 'CONFLICTO') {
    baseClass = 'vis-item-conflicto';
  }

  if (item.flexible) {
    baseClass += ' vis-item-flexible';
  }

  if (item.isPast) {
    baseClass += ' vis-item-attenuated';
  }

  return baseClass;
};

const renderTimeline = () => {
  if (!timelineContainer.value || !data.value) return;

  if (timelineInstance && currentContainer !== timelineContainer.value) {
    timelineInstance.destroy();
    timelineInstance = null;
  }

  const startVentana = new Date(data.value.fechaHoy + 'T00:00:00');
  const endVentana = calcularFinVentana(startVentana, horizonteSeleccionado.value);

  if (!timelineInstance) {
    const options: TimelineOptions = {
      locale: 'es',
      stack: false,
      maxHeight: '74vh',
      verticalScroll: true,
      zoomKey: 'ctrlKey',
      horizontalScroll: true,
      zoomMin: 1000 * 60 * 60 * 24 * 2, // 2 días min
      zoomMax: 1000 * 60 * 60 * 24 * 30 * 12, // 1 año max
      margin: { item: 6, axis: 6 },
      orientation: 'top',
      editable: false,
      showCurrentTime: true,
      timeAxis: { scale: 'day', step: 1 },
      start: startVentana,
      end: endVentana,
    };
    timelineInstance = new Timeline(timelineContainer.value, [], [], options);
    currentContainer = timelineContainer.value;
  }

  // Grupos (Observadores)
  const groups = new DataSet(
    filteredObservadores.value.map(r => ({
      id: r.observador.id,
      content: `<div class="text-text flex items-center justify-between gap-2" style="font-weight: bold; font-size: 13px; line-height: 1.2;">
        <span>${r.observador.apellido}, ${r.observador.nombre}</span>
        ${r.observador.conImpedimento ? '<span class="text-[10px] px-1.5 py-0.5 rounded bg-red-500/20 text-red-500 font-bold">IMPEDIDO</span>' : ''}
      </div>`,
      value: r.observador.apellido,
    }))
  );

  // Items
  const itemsArray: any[] = [];

  filteredObservadores.value.forEach(row => {
    const nombreObs = `${row.observador.apellido}, ${row.observador.nombre}`;
    row.eventos.forEach(item => {
      const label = getBloqueLabel(item);

      itemsArray.push({
        id: `${row.observador.id}-${item.id}`,
        group: row.observador.id,
        start: new Date(item.startDate + 'T00:00:00'),
        end: new Date(item.endDate + 'T00:00:00'),
        content: label,
        className: getItemVisClass(item),
        title: formatItemTooltip(item, nombreObs),
      });
    });
  });

  timelineInstance.setGroups(groups);
  timelineInstance.setItems(new DataSet(itemsArray));
  timelineInstance.setWindow(startVentana, endVentana, { animation: false });
};

watch([filteredObservadores, data], async () => {
  if (!data.value) return;
  await nextTick();
  renderTimeline();
});

onMounted(() => {
  fetchData();
});

onBeforeUnmount(() => {
  if (timelineInstance) {
    timelineInstance.destroy();
    timelineInstance = null;
  }
});
</script>

<style scoped>
.disponibilidad-timeline {
  overflow: hidden;
}

:deep(.vis-timeline) {
  border: none !important;
  font-family: inherit;
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
  font-size: 13px !important;
}

:deep(.vis-label .vis-inner) {
  padding: 8px 6px !important;
}

:deep(.vis-time-axis .vis-text) {
  font-weight: 500;
  color: var(--color-text-muted, #374151) !important;
}

:deep(.vis-time-axis .vis-text.vis-saturday),
:deep(.vis-time-axis .vis-text.vis-sunday) {
  color: #ef4444 !important;
  font-weight: bold !important;
}

/* Eventos pasados atenuados */
:deep(.vis-item-attenuated) {
  opacity: 0.35 !important;
  filter: grayscale(0.7) !important;
}

/* ESTILOS DE BLOQUES EN VIS-TIMELINE - MODO CLARO */
.legend-disponible, :global(.disponibilidad-timeline .vis-item-disponible) {
  background-color: #facc15 !important; /* Amarillo vibrante */
  color: #713f12 !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.disponibilidad-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(250, 204, 21, 0.22) !important; /* Mismo color pero atenuado */
  color: #854d0e !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

.legend-navegando, :global(.disponibilidad-timeline .vis-item-navegando) {
  background-color: #22c55e !important;
  color: white !important;
  border-color: #16a34a !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-naveg-viaje, :global(.disponibilidad-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #16a34a 50%, #4338ca 50%) !important;
  color: white !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-designada, :global(.disponibilidad-timeline .vis-item-designada) {
  background-color: #dcfce7 !important;
  color: #15803d !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

.legend-novedad, :global(.disponibilidad-timeline .vis-item-novedad) {
  background-color: #e0f2fe !important;
  color: #0369a1 !important;
  border-color: #7dd3fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

:global(.disponibilidad-timeline .vis-item-no-disponible) {
  background-color: #fee2e2 !important; /* Rojo suave */
  color: #991b1b !important;            /* Texto contrastado */
  border-color: #fca5a5 !important;     /* Borde rojo suave */
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

.legend-puerto, :global(.disponibilidad-timeline .vis-item-puerto) {
  background-color: #ffedd5 !important;
  color: #c2410c !important;
  border-color: #fdba74 !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-viaje, :global(.disponibilidad-timeline .vis-item-viaje) {
  background-color: #e0e7ff !important;
  color: #4338ca !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-ez, :global(.disponibilidad-timeline .vis-item-ez) {
  background-color: #f3f4f6 !important;
  color: #374151 !important;
  border-color: #d1d5db !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-impedido, :global(.disponibilidad-timeline .vis-item-impedido) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-conflicto, :global(.disponibilidad-timeline .vis-item-conflicto) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

/* Eventos flexibles (borde punteado y efecto) */
.legend-flexible, :global(.disponibilidad-timeline .vis-item-flexible) {
  border-style: dashed !important;
  border-width: 2px !important;
  border-color: #f59e0b !important;
  background-color: #fef3c7 !important;
  color: #92400e !important;
}

/* ESTILOS EN MODO OSCURO */
:global(.dark) .legend-disponible, :global(.dark .disponibilidad-timeline .vis-item-disponible) {
  background-color: #ca8a04 !important;
  color: #fef08a !important;
  border-color: #a16207 !important;
}

:global(.dark .disponibilidad-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(202, 138, 4, 0.22) !important; /* Atenuado */
  color: #fef08a !important;
  border-color: #ca8a04 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

:global(.dark) .legend-navegando, :global(.dark .disponibilidad-timeline .vis-item-navegando) {
  background-color: #15803d !important;
  color: white !important;
  border-color: #166534 !important;
}

:global(.dark) .legend-designada, :global(.dark .disponibilidad-timeline .vis-item-designada) {
  background-color: rgba(34, 197, 94, 0.2) !important;
  color: #86efac !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

:global(.dark) .legend-naveg-viaje, :global(.dark .disponibilidad-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #15803d 50%, rgba(79, 70, 229, 0.4) 50%) !important;
  color: white !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-novedad, :global(.dark .disponibilidad-timeline .vis-item-novedad) {
  background-color: rgba(14, 165, 233, 0.25) !important;
  color: #bae6fd !important;
  border-color: rgba(14, 165, 233, 0.5) !important;
}

:global(.dark .disponibilidad-timeline .vis-item-no-disponible) {
  background-color: rgba(239, 68, 68, 0.22) !important; /* Rojo suave en oscuro */
  color: #fecaca !important;
  border-color: rgba(239, 68, 68, 0.5) !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.dark) .legend-puerto, :global(.dark .disponibilidad-timeline .vis-item-puerto) {
  background-color: rgba(234, 88, 12, 0.25) !important;
  color: #ffedd5 !important;
  border-color: rgba(234, 88, 12, 0.5) !important;
}

:global(.dark) .legend-viaje, :global(.dark .disponibilidad-timeline .vis-item-viaje) {
  background-color: rgba(79, 70, 229, 0.25) !important;
  color: #e0e7ff !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-ez, :global(.dark .disponibilidad-timeline .vis-item-ez) {
  background-color: #374151 !important;
  color: #e5e7eb !important;
  border-color: #4b5563 !important;
}

:global(.dark) .legend-impedido, :global(.dark .disponibilidad-timeline .vis-item-impedido) {
  background-color: #991b1b !important;
  color: white !important;
  border-color: #7f1d1d !important;
}

:global(.dark) .legend-flexible, :global(.dark .disponibilidad-timeline .vis-item-flexible) {
  border-color: #f59e0b !important;
  background-color: rgba(245, 158, 11, 0.2) !important;
  color: #fef3c7 !important;
}

:global(.disponibilidad-timeline .vis-item-content) {
  padding: 4px 6px !important;
  width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: 11px !important;
  font-weight: 700 !important;
  box-sizing: border-box !important;
  line-height: 1.2 !important;
  display: block !important;
}

:global(.vis-tooltip) {
  background-color: #111827 !important;
  color: #ffffff !important;
  font-size: 12px !important;
  font-family: inherit !important;
  padding: 10px !important;
  border-radius: 6px !important;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.2) !important;
  border: none !important;
  z-index: 1000 !important;
  pointer-events: none !important;
  white-space: normal !important;
  max-width: 280px !important;
}

:global(.dark .vis-tooltip) {
  background-color: #1f2937 !important;
  border: 1px solid #374151 !important;
  color: #f3f4f6 !important;
}
</style>
