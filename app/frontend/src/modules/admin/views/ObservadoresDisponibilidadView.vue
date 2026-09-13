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
import { ChevronDownIcon } from '@/icons';
import { toast } from 'vue-sonner';
import disponibilidadApi from '../services/disponibilidad.service';
import type { DisponibilidadResponse, ObservadorDisponibilidadItem } from '../interfaces/disponibilidad.interface';
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

const filteredObservadores = computed(() => {
  if (!data.value) return [];
  return data.value.observadores.filter(r => {
    const o = r.observador;
    const s = searchQuery.value.toLowerCase();
    const matchSearch = !s || `${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s);
    const matchTO = activeTipoObservador.value.has(o.tipoObservador);
    const matchTC = activeTipoContrato.value.has(o.tipoContrato);
    return matchSearch && matchTO && matchTC;
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
  } catch (error) {
    toast.error('Ocurrió un error al cargar la disponibilidad');
    data.value = null;
  } finally {
    isLoading.value = false;
  }
};

const cambiarHorizonte = (hValor: string) => {
  horizonteSeleccionado.value = hValor;
  if (!timelineInstance || !data.value) return;
  const hoy = new Date(data.value.fechaHoy + 'T00:00:00');
  const fin = calcularFinVentana(hoy, hValor);
  timelineInstance.setWindow(hoy, fin, { animation: true });
};

const centrarEnHoy = () => {
  if (!timelineInstance || !data.value) return;
  const hoy = new Date(data.value.fechaHoy + 'T00:00:00');
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
    if (item.codigoCorto === 'NO_DISP' || item.codigoCorto === 'NO DISPONIBLE') {
      titulo = 'No Disponible';
      tituloColor = 'text-sky-400';
    } else if (item.codigoCorto === 'FC') {
      titulo = 'Franco Compensatorio';
      tituloColor = 'text-amber-400';
    } else {
      titulo = item.codigoCorto || 'Novedad';
      tituloColor = 'text-sky-400';
    }
  } else if (item.estado === 'CONFLICTO') {
    titulo = 'Conflicto de eventos';
    tituloColor = 'text-red-400';
  } else {
    titulo = item.estado;
  }

  const rangoStr = formatFechasRango(item.startDate, item.endDate);

  let html = `<div class="font-bold text-xs ${tituloColor} mb-0.5">${titulo}</div>`;
  html += `<div class="text-[11px] text-gray-300 font-mono mb-1">📅 ${rangoStr}</div>`;

  // Detalle adicional limpio (solo si aporta información y no repite el título)
  if (item.estado === 'DESIGNADA') {
    if (item.detalle) {
      html += `<div class="text-xs text-gray-100 font-medium mt-1">${item.detalle}</div>`;
    }
    html += `<div class="text-[10px] text-emerald-300/80 mt-0.5 italic">Asignación prevista aún no confirmada</div>`;
  } else if (item.estado === 'NOVEDAD' && (item.codigoCorto === 'NO_DISP' || item.codigoCorto === 'NO DISPONIBLE')) {
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

const getBloqueLabel = (item: ObservadorDisponibilidadItem): string => {
  switch (item.estado) {
    case 'DISPONIBLE':
      return 'DISPONIBLE';
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
      if (item.codigoCorto === 'NO_DISP' || item.codigoCorto === 'NO DISPONIBLE') {
        return 'NO DISPONIBLE';
      }
      if (item.codigoCorto === 'FC') {
        return 'FRANCO';
      }
      return item.codigoCorto || 'NOVEDAD';
    default:
      return item.codigoCorto || item.estado;
  }
};

const getItemVisClass = (item: ObservadorDisponibilidadItem): string => {
  let baseClass = 'vis-item-default';

  if (item.estado === 'DISPONIBLE') {
    baseClass = 'vis-item-disponible';
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
    baseClass = 'vis-item-novedad';
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
