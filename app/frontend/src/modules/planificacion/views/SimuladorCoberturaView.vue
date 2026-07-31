<template>
  <PlanificacionDashboardLayout
    title="Simulador de Cobertura"
    description="Proyección interactiva de mareas y asignación de observadores en la línea de tiempo"
  >
    <div class="space-y-6">
      <!-- Cabecera de Controles y Escenarios -->
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between bg-surface p-4 rounded-2xl border border-border shadow-sm">
        <div class="flex flex-wrap items-center gap-3">
          <BackButton routeName="PlanificacionDashboard" label="Regresar" containerClass="mb-0" />
          <div class="h-6 w-px bg-border hidden sm:block"></div>
          <div>
            <div class="flex items-center gap-2">
              <h1 class="text-lg font-black text-text uppercase tracking-tight">Escenario Actual: {{ escenarioActual.nombre }}</h1>
              <span class="px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wider bg-primary/10 border border-primary/30 text-primary">
                {{ escenarioActual.estado }}
              </span>
            </div>
            <p class="text-xs text-text-muted">Arrastre recursos desde el panel lateral para asignar o redistribuir mareas en la línea de tiempo.</p>
          </div>
        </div>

        <div class="flex flex-wrap items-center gap-3">
          <!-- Selector de Mes -->
          <div class="relative">
            <select
              v-model="selectedMonth"
              @change="fetchData"
              class="h-10 pl-3 pr-8 rounded-xl border bg-surface text-xs font-bold border-border outline-none focus:border-primary transition-all text-text cursor-pointer"
            >
              <option v-for="(m, i) in months" :key="i" :value="i + 1">{{ m }}</option>
            </select>
            <ChevronDownIcon class="absolute right-2.5 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          </div>

          <!-- Selector de Año -->
          <div class="relative">
            <select
              v-model="selectedYear"
              @change="fetchData"
              class="h-10 pl-3 pr-8 rounded-xl border bg-surface text-xs font-bold border-border outline-none focus:border-primary transition-all text-text cursor-pointer"
            >
              <option v-for="y in availableYears" :key="y" :value="y">{{ y }}</option>
            </select>
            <ChevronDownIcon class="absolute right-2.5 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted pointer-events-none" />
          </div>

          <!-- Botones de Acción de Escenario -->
          <button
            @click="guardarBorrador"
            class="h-10 px-3.5 inline-flex items-center justify-center gap-2 text-xs font-extrabold tracking-wider uppercase transition-all rounded-xl bg-primary text-white hover:bg-primary/90 active:scale-95 shadow-sm"
          >
            <DraftIcon class="w-4 h-4" />
            Guardar Borrador
          </button>

          <button
            @click="limpiarSimulacion"
            class="h-10 px-3 inline-flex items-center justify-center gap-1.5 text-xs font-bold tracking-wider uppercase transition-all rounded-xl bg-surface border border-border text-error hover:bg-error/10 active:scale-95"
            title="Limpiar bloques simulados del lienzo"
          >
            <TrashIcon class="w-4 h-4" />
            Limpiar
          </button>
        </div>
      </div>

      <!-- Leyenda y Filtros Rápidos -->
      <div class="flex flex-wrap items-center justify-between gap-4 p-4 rounded-xl border border-border bg-surface shadow-sm">
        <div class="flex flex-wrap items-center gap-4">
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-ejecucion"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">En Ejecución</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-finalizada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Finalizada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-designada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Designada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-licencia"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Licencia</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-proyectada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Proyectada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded bg-error border border-error animate-pulse"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Conflicto</span>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <SearchInput v-model="searchQuery" placeholder="Buscar observador..." class="w-56" />
          <button
            @click="toggleSidebar"
            class="h-9 px-3 inline-flex items-center gap-2 text-xs font-bold rounded-lg border border-border bg-surface text-text hover:bg-surface-muted transition-colors"
          >
            <LayersIcon class="w-4 h-4" />
            {{ sidebarOpen ? 'Ocultar Recursos' : 'Mostrar Recursos' }}
          </button>
        </div>
      </div>

      <!-- Alertas / Advertencias de Conflicto -->
      <div v-if="conflictosDetectados.length > 0" class="p-4 rounded-xl border border-error/30 bg-error/10 text-error flex flex-col gap-2">
        <div class="flex items-center gap-2 font-black text-xs uppercase tracking-wider">
          <WarningIcon class="w-5 h-5 shrink-0" />
          <span>Advertencias de Conflicto Detectadas ({{ conflictosDetectados.length }})</span>
        </div>
        <ul class="text-xs space-y-1 pl-7 list-disc">
          <li v-for="(conf, idx) in conflictosDetectados" :key="idx">
            {{ conf }}
          </li>
        </ul>
      </div>

      <!-- Layout Principal: Sidebar Izquierdo + Timeline Central -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <!-- Sidebar Izquierdo: Mareas y Pesquerías Requeridas Arrastrables -->
        <div
          v-show="sidebarOpen"
          class="lg:col-span-3 bg-surface rounded-2xl border border-border shadow-sm p-4 flex flex-col gap-4 max-h-[72vh] overflow-y-auto"
        >
          <div class="flex items-center justify-between border-b border-border pb-3">
            <div>
              <h3 class="text-sm font-bold text-text uppercase tracking-tight">Recursos Pendientes</h3>
              <p class="text-[11px] text-text-muted">Pesquerías / Mareas a cubrir</p>
            </div>
            <div class="flex items-center gap-2">
              <span class="px-2 py-0.5 rounded-full bg-info/10 text-info text-xs font-bold">
                {{ recursosPendientes.length }}
              </span>
              <button 
                @click="abrirModalCrearRecurso"
                class="p-1.5 rounded-lg bg-primary/10 text-primary hover:bg-primary/20 transition-colors"
                title="Crear nuevo requerimiento"
              >
                <PlusIcon class="w-4 h-4" />
              </button>
            </div>
          </div>

          <div class="space-y-3">
            <div
              v-for="recurso in recursosPendientes"
              :key="recurso.id"
              draggable="true"
              @dragstart="onDragStartRecurso($event, recurso)"
              @dblclick="abrirModalEditarRecurso(recurso)"
              class="p-3.5 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all cursor-grab active:cursor-grabbing shadow-sm group relative"
            >
              <div class="flex items-center justify-between mb-1.5 pr-14 relative">
                <span class="text-xs font-extrabold text-primary group-hover:text-primary-hover transition-colors truncate pr-2">
                  {{ recurso.pesqueriaNombre }}
                </span>
                
                <div class="absolute right-0 top-0 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button @click="abrirModalEditarRecurso(recurso)" class="p-1 rounded text-text-muted hover:text-primary hover:bg-primary/10 transition-colors" title="Editar">
                    <EditIcon class="w-3.5 h-3.5" />
                  </button>
                  <button @click="eliminarRecurso(recurso.id)" class="p-1 rounded text-text-muted hover:text-error hover:bg-error/10 transition-colors" title="Eliminar">
                    <TrashIcon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
              
              <div class="flex items-center justify-between mb-2">
                <span
                  class="px-1.5 py-0.5 rounded text-[10px] font-black uppercase tracking-wider"
                  :class="recurso.prioridad === 'ALTA' ? 'bg-error/10 text-error' : 'bg-info/10 text-info'"
                >
                  {{ recurso.prioridad }}
                </span>
              </div>

              <div class="text-xs text-text-muted space-y-1">
                <div v-if="recurso.buqueNombre" class="flex items-center gap-1">
                  <ShipIcon class="w-3.5 h-3.5 shrink-0" />
                  <span class="font-medium text-text">{{ recurso.buqueNombre }}</span>
                </div>
                <div class="flex items-center justify-between text-[11px]">
                  <span>Duración estimada:</span>
                  <span class="font-bold text-text">{{ recurso.diasEstimados }} días</span>
                </div>
                <div v-if="recurso.puertoSugerido" class="flex items-center justify-between text-[11px]">
                  <span>Puerto base:</span>
                  <span class="font-bold text-text">{{ recurso.puertoSugerido }}</span>
                </div>
              </div>

              <div class="mt-2 text-[10px] text-primary/80 font-bold flex items-center justify-end gap-1 opacity-80 group-hover:opacity-100">
                <span>Arrastrar al timeline</span>
                <span>➔</span>
              </div>
            </div>

            <div v-if="recursosPendientes.length === 0" class="p-6 text-center text-text-muted text-xs border border-dashed border-border rounded-xl">
              No hay recursos pendientes en este escenario.
            </div>
          </div>
        </div>

        <!-- Canvas Central (vis-timeline) -->
        <div
          :class="[sidebarOpen ? 'lg:col-span-9' : 'lg:col-span-12']"
          class="bg-surface rounded-2xl shadow-sm border border-border p-4 transition-all flex flex-col gap-4 relative"
        >
          <!-- Loading State -->
          <div v-if="isLoading" class="p-12 flex flex-col items-center justify-center bg-surface rounded-2xl">
            <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="text-sm font-bold text-text-muted">Cargando disponibilidad de observadores...</p>
          </div>

          <!-- Timeline Container -->
          <div
            ref="timelineContainer"
            @dragover.capture.prevent
            @dragenter.capture.prevent
            @drop.capture="onDropTimeline"
            class="w-full h-[65vh] bg-surface text-text rounded-xl border border-border shadow-inner simulador-timeline"
          ></div>
        </div>
      </div>
    </div>

    <!-- Modal Crear/Editar Recurso -->
    <BaseModal 
      :show="isResourceModalOpen" 
      @close="cerrarModalRecurso" 
      maxWidth="md" 
      :title="editingRecursoId ? 'Editar Requerimiento' : 'Crear Requerimiento'"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div class="space-y-4" v-if="!loadingCatalogs">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Pesquería (obligatorio)</label>
            <SearchableSelect 
              ref="pesqueriaSelectRef"
              v-model="resourceForm.pesqueriaId" 
              :options="pesqueriaOptions" 
              :icon="WaveIcon" 
              placeholder="Seleccione pesquería..." 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque (opcional)</label>
            <SearchableSelect 
              v-model="resourceForm.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
              @change="handleBuqueChange"
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Días Estimados</label>
              <input v-model="resourceForm.diasEstimados" type="number" class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Prioridad</label>
              <select v-model="resourceForm.prioridad" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-colors shadow-theme-xs">
                <option value="ALTA">Alta</option>
                <option value="MEDIA">Media</option>
                <option value="BAJA">Baja</option>
              </select>
            </div>
          </div>
        </div>
        <div v-else class="flex items-center justify-center py-10">
          <div class="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
        </div>
        
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="cerrarModalRecurso" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">Cancelar</button>
          <button @click="guardarRecurso" :disabled="loadingCatalogs" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Guardar</button>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Editar Bloque Simulado -->
    <BaseModal 
      :show="isEditBlockModalOpen" 
      @close="cerrarModalEditarBloque" 
      maxWidth="xl" 
      title="Editar Marea Simulada"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div v-if="editingBlockData" class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Pesquería</label>
            <SearchableSelect 
              v-model="editingBlockData.pesqueriaId" 
              :options="pesqueriaOptions" 
              :icon="WaveIcon" 
              placeholder="Seleccione pesquería..." 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              v-model="editingBlockData.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Días Estimados</label>
              <input v-model="editingBlockData.diasEstimados" type="number" class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Prioridad</label>
              <select v-model="editingBlockData.prioridad" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-colors shadow-theme-xs">
                <option value="ALTA">Alta</option>
                <option value="MEDIA">Media</option>
                <option value="BAJA">Baja</option>
              </select>
            </div>
          </div>
        </div>
        
        <div class="mt-8 pt-6 flex items-center justify-between border-t border-border gap-3">
          <button @click="devolverRecursoPendiente" class="px-4 py-3 text-xs font-black uppercase tracking-widest text-error hover:bg-error/10 rounded-lg transition-all flex items-center gap-2">
            <TrashIcon class="w-4 h-4" />
            Quitar de planificación
          </button>
          <div class="flex gap-2">
            <button @click="cerrarModalEditarBloque" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-text transition-all">Cancelar</button>
            <button @click="guardarEdicionBloque" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95">Guardar</button>
          </div>
        </div>
      </div>
    </BaseModal>
  </PlanificacionDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch, nextTick, onBeforeUnmount } from 'vue';
import PlanificacionDashboardLayout from '../layouts/PlanificacionDashboardLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import BaseModal from '@/components/common/BaseModal.vue';
import {
  ChevronDownIcon,
  ShipIcon,
  TrashIcon,
  DraftIcon,
  LayersIcon,
  WarningIcon,
  PlusIcon,
  XIcon,
  WaveIcon,
  EditIcon
} from '@/icons';
import { toast } from 'vue-sonner';
import { planificacionService } from '../services/planificacion.service';
import catalogosService from '../../mareas/services/catalogos.service';
import type { MareaSimuladaItem, RecursoMareaPendiente, EscenarioSimulacionState } from '../interfaces/simulador.interface';
import { Timeline, type TimelineOptions } from 'vis-timeline/standalone';
import { DataSet } from 'vis-data';
import 'vis-timeline/styles/vis-timeline-graph2d.min.css';

const currentDate = new Date();
const selectedMonth = ref(currentDate.getMonth() + 1);
const selectedYear = ref(currentDate.getFullYear());
const availableYears = Array.from({ length: 5 }, (_, i) => currentDate.getFullYear() - 2 + i);

const months = [
  'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
  'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
];

const isLoading = ref(false);
const searchQuery = ref('');
const sidebarOpen = ref(true);

// Estado del Escenario Borrador
const escenarioActual = ref<EscenarioSimulacionState>({
  id: 'escenario-draft-1',
  nombre: 'Escenario Borrador 1',
  anioOperativo: selectedYear.value,
  estado: 'BORRADOR',
  fechaCreacion: new Date().toISOString(),
  items: []
});

// Datos de Recursos Pendientes (Simulados / Requerimientos)
const recursosPendientes = ref<RecursoMareaPendiente[]>([]);

// Catálogos
const loadingCatalogs = ref(true);
const buques = ref<any[]>([]);
const pesquerias = ref<any[]>([]);

const buqueOptions = computed(() => {
  return buques.value.map(b => ({
    value: b.id,
    label: `${b.nombreBuque} (${b.matricula})`
  }));
});

const pesqueriaOptions = computed(() => {
  return pesquerias.value.map(p => ({
    value: p.id,
    label: p.nombre
  }));
});

// Datos de Simulación
const datosSimulacion = ref<{ observadores: any[], eventos: any[] } | null>(null);

// Observadores extraídos de los datos de simulación
const observadoresBase = computed(() => {
  if (!datosSimulacion.value) return [];
  return datosSimulacion.value.observadores;
});

// Estado para modales
const isResourceModalOpen = ref(false);
const editingRecursoId = ref<string | null>(null);
const resourceForm = ref({
  pesqueriaId: '',
  buqueId: '',
  diasEstimados: 30,
  prioridad: 'MEDIA'
});

const isEditBlockModalOpen = ref(false);
const editingBlockData = ref<MareaSimuladaItem | null>(null);

const pesqueriaSelectRef = ref<any>(null);

const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    pesqueriaId: '',
    buqueId: '',
    diasEstimados: 30,
    prioridad: 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    pesqueriaSelectRef.value?.focus();
  });
};

const abrirModalEditarRecurso = (recurso: RecursoMareaPendiente) => {
  editingRecursoId.value = recurso.id;
  resourceForm.value = {
    pesqueriaId: recurso.pesqueriaId || '',
    buqueId: recurso.buqueId || '',
    diasEstimados: recurso.diasEstimados,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    pesqueriaSelectRef.value?.focus();
  });
};

const eliminarRecurso = (id: string) => {
  const idx = recursosPendientes.value.findIndex(r => r.id === id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
    toast.success('Recurso eliminado');
  }
};

const cerrarModalRecurso = () => {
  isResourceModalOpen.value = false;
};

const handleBuqueChange = () => {
  const buque = buques.value.find(b => b.id === resourceForm.value.buqueId);
  if (buque) {
    if (buque.pesqueriaHabitualId && !resourceForm.value.pesqueriaId) {
      resourceForm.value.pesqueriaId = buque.pesqueriaHabitualId;
    }
    if (buque.diasMareaEstimada) {
      resourceForm.value.diasEstimados = buque.diasMareaEstimada;
    }
  }
};

const guardarRecurso = () => {
  if (!resourceForm.value.pesqueriaId) {
    toast.error('Debe seleccionar una pesquería');
    return;
  }
  
  const pesqueria = pesquerias.value.find(p => p.id === resourceForm.value.pesqueriaId);
  const buque = buques.value.find(b => b.id === resourceForm.value.buqueId);
  
  if (editingRecursoId.value) {
    // Editar existente
    const recurso = recursosPendientes.value.find(r => r.id === editingRecursoId.value);
    if (recurso) {
      recurso.pesqueriaId = resourceForm.value.pesqueriaId;
      recurso.pesqueriaNombre = pesqueria?.nombre || '';
      recurso.buqueId = resourceForm.value.buqueId;
      recurso.buqueNombre = buque?.nombreBuque || '';
      recurso.diasEstimados = resourceForm.value.diasEstimados;
      recurso.prioridad = resourceForm.value.prioridad as any;
      toast.success('Requerimiento actualizado exitosamente');
    }
  } else {
    // Crear nuevo
    recursosPendientes.value.push({
      id: `rec-custom-${Date.now()}`,
      pesqueriaId: resourceForm.value.pesqueriaId,
      pesqueriaNombre: pesqueria?.nombre || '',
      buqueId: resourceForm.value.buqueId,
      buqueNombre: buque?.nombreBuque || '',
      diasEstimados: resourceForm.value.diasEstimados || 30,
      puertoSugerido: buque?.puertoBase?.nombre || '',
      prioridad: (resourceForm.value.prioridad as 'ALTA' | 'MEDIA' | 'BAJA') || 'MEDIA',
      mesProyectado: selectedMonth.value
    });
    toast.success('Requerimiento creado exitosamente');
  }
  
  cerrarModalRecurso();
};

const cerrarModalEditarBloque = () => {
  isEditBlockModalOpen.value = false;
  editingBlockData.value = null;
};

const guardarEdicionBloque = () => {
  if (!editingBlockData.value) return;
  const idx = escenarioActual.value.items.findIndex(i => i.id === editingBlockData.value?.id);
  if (idx !== -1) {
    const pesqueria = pesquerias.value.find(p => p.id === editingBlockData.value?.pesqueriaId);
    const buque = buques.value.find(b => b.id === editingBlockData.value?.buqueId);
    
    if (pesqueria) {
      editingBlockData.value.pesqueriaNombre = pesqueria.nombre;
    }
    if (buque) {
      editingBlockData.value.buqueNombre = buque.nombreBuque;
    }
    
    // Recalcular la fecha de arribo basada en los nuevos días estimados
    const fechaZarpada = new Date(editingBlockData.value.fechaZarpada);
    const fechaArribo = new Date(fechaZarpada.getTime() + (editingBlockData.value.diasEstimados * 24 * 60 * 60 * 1000));

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (fechaZarpada < today) {
      toast.error('No se pueden proyectar mareas en fechas pasadas');
      return;
    }

    editingBlockData.value.fechaArribo = fechaArribo;

    escenarioActual.value.items[idx] = { ...editingBlockData.value };
    
    // Actualizar DataSet
    const finInclusivo = new Date(fechaArribo.getTime() - 86400000);
    currentItemsDataSet?.update({
      id: editingBlockData.value.id,
      start: fechaZarpada,
      end: fechaArribo,
      content: `<div class="flex items-center gap-1 font-bold"><span class="text-[10px]">✨</span> ${editingBlockData.value.pesqueriaNombre} [${editingBlockData.value.diasEstimados}d] (Proyectada)</div>`,
      title: `<strong>Inicio:</strong> ${new Date(fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`
    });

    toast.success('Marea simulada actualizada');
  }
  cerrarModalEditarBloque();
};

const devolverRecursoPendiente = () => {
  if (!editingBlockData.value) return;
  const idx = escenarioActual.value.items.findIndex(i => i.id === editingBlockData.value?.id);
  if (idx !== -1) {
    const removedItem = escenarioActual.value.items[idx];
    escenarioActual.value.items.splice(idx, 1);
    currentItemsDataSet?.remove(removedItem.id);
    
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      pesqueriaId: removedItem.pesqueriaId,
      pesqueriaNombre: removedItem.pesqueriaNombre,
      buqueId: removedItem.buqueId,
      buqueNombre: removedItem.buqueNombre,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA',
      mesProyectado: selectedMonth.value
    });
    
    toast.success('Marea devuelta a recursos pendientes');
  }
  cerrarModalEditarBloque();
};


// vis-timeline
const timelineContainer = ref<HTMLElement | null>(null);
let timelineInstance: Timeline | null = null;
let currentItemsDataSet: DataSet<any> | null = null;

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value;
};

const filteredObservadores = computed(() => {
  if (observadoresBase.value.length === 0) return [];
  return observadoresBase.value.filter(o => {
    const s = searchQuery.value.toLowerCase();
    return !s || `${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s);
  });
});

// Conflictos detectados en tiempo real
const conflictosDetectados = computed(() => {
  const alertas: string[] = [];
  const simulados = escenarioActual.value.items.filter(i => i.tipoBloque === 'MAREA_SIMULADA');

  simulados.forEach(sim => {
    if (sim.observadorId && datosSimulacion.value) {
      const inicio = new Date(sim.fechaZarpada);
      const fin = new Date(sim.fechaArribo);
      
      const eventosObs = datosSimulacion.value.eventos.filter((e: any) => e.observadorId === sim.observadorId);
      
      for (const ev of eventosObs) {
        if (ev.estado !== 'LIBRE' && ev.estado !== 'FIN_SEMANA') {
          const evStart = new Date(ev.startDate);
          const evEnd = new Date(ev.endDate);
          
          if (inicio <= evEnd && fin >= evStart) {
            const tipoStr = ev.detalle ? `${ev.estado} - ${ev.detalle}` : ev.estado;
            alertas.push(
              `Marea simulada "${sim.pesqueriaNombre}" se solapa con [${tipoStr}] del ${evStart.toLocaleDateString('es-AR')} al ${evEnd.toLocaleDateString('es-AR')}.`
            );
          }
        }
      }
    }
  });

  return alertas;
});

const fetchData = async () => {
  isLoading.value = true;
  try {
    // Fetches from January up to selectedMonth + 5 months
    const data = await planificacionService.obtenerEventosSimulador(selectedYear.value, 1, selectedMonth.value + 5);
    datosSimulacion.value = data;
  } catch (error) {
    toast.error('Ocurrió un error al cargar los datos de planificación');
    datosSimulacion.value = null;
  } finally {
    isLoading.value = false;
  }
};

watch([filteredObservadores, selectedMonth, selectedYear], async () => {
  if (!datosSimulacion.value) return;
  await nextTick();
  renderTimeline();
}, { immediate: true });

const renderTimeline = () => {
  if (!timelineContainer.value) return;

  if (timelineInstance) {
    timelineInstance.destroy();
    timelineInstance = null;
  }

  // Limites totales de los datos para restringir scroll
  const dataStart = new Date(selectedYear.value, 0, 1);
  const dataEndMonthRaw = selectedMonth.value + 5;
  const dataEndYear = selectedYear.value + Math.floor((dataEndMonthRaw - 1) / 12);
  const dataEndMonth = ((dataEndMonthRaw - 1) % 12) + 1;
  const dataEnd = new Date(dataEndYear, dataEndMonth, 0, 23, 59, 59);

  // Ventana visible inicial (zoom)
  let visibleStart: Date;
  let visibleEnd: Date;
  
  if (selectedYear.value < currentDate.getFullYear()) {
     // Si es año pasado, zoom en Diciembre del año seleccionado
     visibleStart = new Date(selectedYear.value, 11, 1);
     visibleEnd = new Date(selectedYear.value, 11, 31, 23, 59, 59);
  } else if (selectedYear.value === currentDate.getFullYear()) {
     // Si es año actual, zoom en el mes actual
     visibleStart = new Date(selectedYear.value, currentDate.getMonth(), 1);
     visibleEnd = new Date(selectedYear.value, currentDate.getMonth() + 1, 0, 23, 59, 59);
  } else {
     // Si es año futuro, zoom en el mes seleccionado
     visibleStart = new Date(selectedYear.value, selectedMonth.value - 1, 1);
     visibleEnd = new Date(selectedYear.value, selectedMonth.value, 0, 23, 59, 59);
  }

  const groups = new DataSet(
    filteredObservadores.value.map(obs => ({
      id: obs.id,
      content: `<div class="text-text font-bold text-xs">${obs.apellido}, ${obs.nombre}</div>`,
      value: obs.apellido
    }))
  );

  const itemsArray: any[] = [];

  // 1. Cargar items reales/duros combinando los eventos nativos
  if (datosSimulacion.value) {
    const obsSet = new Set(filteredObservadores.value.map(o => o.id));
    const eventosFiltrados = datosSimulacion.value.eventos.filter((e: any) => obsSet.has(e.observadorId));
    
    eventosFiltrados.forEach((ev: any) => {
      let visClass = 'vis-item-puerto bg-[#FFE4C4] text-black';
      let title = ev.estado;
      let isEditable: boolean | { updateTime?: boolean, updateGroup?: boolean, remove?: boolean } = false;

      if (ev.estado === 'NAVEGANDO') {
        const mareaCode = ev.detalle || 'Marea';
        const durationDays = Math.round((new Date(ev.endDate).getTime() - new Date(ev.startDate).getTime()) / 86400000) + 1;
        const durStr = `[${durationDays}d]`;

        if (ev.mareaEstado === 'DESIGNADA') {
          visClass = 'vis-item-designada';
          title = `${mareaCode} ${durStr} (Designada)`;
          isEditable = { updateTime: true, updateGroup: false, remove: false };
        } else if (ev.mareaEstado === 'EN_EJECUCION') {
          visClass = 'vis-item-ejecucion';
          title = `${mareaCode} ${durStr} (Navegando)`;
          isEditable = { updateTime: true, updateGroup: false, remove: false };
        } else {
          // FINALIZADA, PROTOCOLIZADA, A_REASIGNAR, etc.
          visClass = 'vis-item-navegando';
          title = `${mareaCode} ${durStr} (Finalizada)`;
          isEditable = false;
        }
      } else if (ev.estado === 'NOVEDAD') {
        visClass = 'vis-item-novedad';
        title = ev.codigoCorto || 'Licencia';
      } else if (ev.estado === 'CONFLICTO') {
        visClass = 'vis-item-conflicto';
        title = 'Conflicto';
      }

      // Add 1 day to endDate to make it inclusive visually in vis-timeline
      const endExclusive = new Date(ev.endDate);
      endExclusive.setDate(endExclusive.getDate() + 1);

      itemsArray.push({
        id: ev.id,
        group: ev.observadorId,
        start: new Date(ev.startDate),
        end: endExclusive,
        content: title,
        title: `<strong>Inicio:</strong> ${new Date(ev.startDate).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${new Date(ev.endDate).toLocaleDateString('es-AR')}`,
        className: visClass,
        editable: isEditable
      });
    });
  }

  // 2. Cargar items simulados (borradores)
  escenarioActual.value.items.forEach(sim => {
    const duracionSim = Math.round((new Date(sim.fechaArribo).getTime() - new Date(sim.fechaZarpada).getTime()) / 86400000);
    const finInclusivo = new Date(new Date(sim.fechaArribo).getTime() - 86400000);
    itemsArray.push({
      id: sim.id,
      group: sim.observadorId ?? '',
      start: new Date(sim.fechaZarpada),
      end: new Date(sim.fechaArribo),
      content: `<div class="flex items-center gap-1 font-bold"><span class="text-[10px]">✨</span> ${sim.pesqueriaNombre} [${duracionSim}d] (Proyectada)</div>`,
      title: `<strong>Inicio:</strong> ${new Date(sim.fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`,
      className: 'vis-item-simulada border-2 border-dashed border-primary bg-primary/20 text-primary font-bold shadow-sm',
      editable: { updateTime: true, updateGroup: true, remove: true }
    });
  });

  currentItemsDataSet = new DataSet(itemsArray);

  const options: TimelineOptions = {
    locale: 'es',
    stack: false,
    maxHeight: '65vh',
    verticalScroll: true,
    horizontalScroll: true,
    zoomKey: 'ctrlKey',
    zoomMin: 1000 * 60 * 60 * 24 * 2,
    zoomMax: 1000 * 60 * 60 * 24 * 31 * 3,
    margin: { item: 8, axis: 8 },
    orientation: 'top',
    editable: {
      updateTime: true,
      updateGroup: true,
      remove: true,
      add: true,
      overrideItems: false
    },
    showCurrentTime: false,
    timeAxis: { scale: 'day', step: 1 },
    snap: function (date: Date, scale: string, step: number) {
      const clone = new Date(date.valueOf());
      clone.setHours(0, 0, 0, 0);
      return clone;
    },
    tooltip: {
      followMouse: true,
      overflowMethod: 'cap'
    },
    start: visibleStart,
    end: visibleEnd,
    min: dataStart,
    max: dataEnd,
    onAdd: (item: any, callback: any) => {
      // Cancelamos la creación por doble clic nativa de vis-timeline
      callback(null);
    },
    onMoving: (item: any, callback: any) => {
      if (item.id && item.id.toString().startsWith('real-')) {
        const orig = currentItemsDataSet?.get(item.id) as any;
        if (orig && orig.className && orig.className.includes('vis-item-ejecucion')) {
          // Bloquear fecha de inicio y grupo para las mareas en ejecución (solo permitir cambiar fin)
          item.start = orig.start;
          item.group = orig.group;
        } else if (orig && orig.className && orig.className.includes('vis-item-designada')) {
          // Si es designada, impedimos cambio de grupo de items reales
          item.group = orig.group;
        }
      }

      // Evitar colocar en fechas pasadas
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      if (item.start < today) {
        const diff = item.end.getTime() - item.start.getTime();
        item.start = today;
        item.end = new Date(today.getTime() + diff);
      }

      // Actualizar interactivamente el texto de la duración
      if (item.content && item.start && item.end) {
        const newDuration = Math.round((new Date(item.end).getTime() - new Date(item.start).getTime()) / 86400000);
        item.content = item.content.replace(/\[\d+d\]/, `[${newDuration}d]`);
        const finInclusivo = new Date(new Date(item.end).getTime() - 86400000);
        item.title = `<strong>Inicio:</strong> ${new Date(item.start).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`;
      }

      callback(item);
    },
    onUpdate: (item: any, callback: any) => {
      const sim = escenarioActual.value.items.find(i => i.id === item.id);
      if (sim) {
        editingBlockData.value = { ...sim };
        isEditBlockModalOpen.value = true;
      }
      callback(null); // we handle it ourselves to not let vis-timeline show default prompt
    },
    onMove: (item: any, callback: any) => {
      // Nos aseguramos de actualizar también al soltar
      if (item.content && item.start && item.end) {
        const newDuration = Math.round((new Date(item.end).getTime() - new Date(item.start).getTime()) / 86400000);
        item.content = item.content.replace(/\[\d+d\]/, `[${newDuration}d]`);
        const finInclusivo = new Date(new Date(item.end).getTime() - 86400000);
        item.title = `<strong>Inicio:</strong> ${new Date(item.start).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`;
      }

      // Actualizar el estado borrador cuando el usuario mueve un bloque simulado
      const sim = escenarioActual.value.items.find(i => i.id === item.id);
      if (sim) {
        const obsCambiado = sim.observadorId !== String(item.group);
        
        sim.observadorId = String(item.group);
        sim.fechaZarpada = item.start;
        sim.fechaArribo = item.end;
        
        callback(item);
        
        if (obsCambiado) {
          toast.info(`Marea simulada movida a un nuevo observador`);
        } else {
          toast.info('Fechas de la marea simulada actualizadas');
        }
      } else if (item.id && item.id.toString().startsWith('real-')) {
        // Se permite ajustar longitud (y para DESIGNADAS, inicio) de mareas reales proyectadas
        const orig = currentItemsDataSet?.get(item.id) as any;
        if (orig) {
          if (orig.className && orig.className.includes('vis-item-ejecucion')) {
             if (item.start.getTime() !== orig.start.getTime() || item.group !== orig.group) {
                // Debería estar prevenido por onMoving, pero por seguridad:
                item.start = orig.start;
                item.group = orig.group;
             }
             toast.info('Se ajustó la fecha de fin de la marea en ejecución');
          } else {
             toast.info('Se ajustó la marea designada en la simulación');
          }
        }
        callback(item);
      } else {
        // Bloque inamovible
        toast.warning('No es posible mover mareas finalizadas ni licencias');
        callback(null);
      }
    },
    onRemove: (item: any, callback: any) => {
      const idx = escenarioActual.value.items.findIndex(i => i.id === item.id);
      if (idx !== -1) {
        const removedItem = escenarioActual.value.items[idx];
        escenarioActual.value.items.splice(idx, 1);
        
        recursosPendientes.value.push({
          id: `rec-returned-${Date.now()}`,
          pesqueriaId: removedItem.pesqueriaId,
          pesqueriaNombre: removedItem.pesqueriaNombre,
          buqueId: removedItem.buqueId,
          buqueNombre: removedItem.buqueNombre,
          diasEstimados: removedItem.diasEstimados,
          prioridad: removedItem.prioridad || 'MEDIA',
          mesProyectado: selectedMonth.value
        });
        
        toast.success('Marea simulada eliminada y devuelta a recursos');
        callback(item);
      } else {
        toast.warning('No se pueden eliminar bloques inamovibles');
        callback(null);
      }
    }
  };

  timelineInstance = new Timeline(timelineContainer.value, currentItemsDataSet, groups, options);
};

// Drag & Drop HTML5 desde Sidebar a Timeline
let draggedRecurso: RecursoMareaPendiente | null = null;

const onDragStartRecurso = (event: DragEvent, recurso: RecursoMareaPendiente) => {
  draggedRecurso = recurso;
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'copy';
    // Enviamos JSON por si vis-timeline lo intercepta, y también para leerlo directamente en el drop
    event.dataTransfer.setData('application/json', JSON.stringify(recurso));
    event.dataTransfer.setData('text/plain', recurso.id);
  }
};

const onDropTimeline = (event: DragEvent) => {
  event.preventDefault();
  event.stopPropagation(); // Evitamos que vis-timeline procese el evento y falle
  
  // Intentar recuperar el recurso desde dataTransfer si la variable global falló
  let recursoArrastrado = draggedRecurso;
  if (!recursoArrastrado && event.dataTransfer) {
    try {
      const dataStr = event.dataTransfer.getData('application/json');
      if (dataStr) {
        recursoArrastrado = JSON.parse(dataStr);
      }
    } catch (e) {
      console.error('Error parseando dataTransfer', e);
    }
  }

  if (!recursoArrastrado || !timelineInstance) {
    toast.error('No se pudo identificar el recurso arrastrado o el timeline no está listo');
    return;
  }

  const props = timelineInstance.getEventProperties(event);
  if (props && props.group) {
    const obsId = props.group;
    const rawTime = props.snappedTime || props.time;
    let fechaInicio = rawTime ? new Date(rawTime) : new Date(selectedYear.value, selectedMonth.value - 1, 1);
    
    // Evitar colocar en fechas pasadas
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (fechaInicio < today) {
      fechaInicio = today;
    }

    const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

    const nuevoItemSimulado: MareaSimuladaItem = {
      id: `sim-${Date.now()}`,
      observadorId: String(obsId),
      pesqueriaId: recursoArrastrado.pesqueriaId,
      pesqueriaNombre: recursoArrastrado.pesqueriaNombre,
      buqueNombre: recursoArrastrado.buqueNombre,
      fechaZarpada: fechaInicio,
      fechaArribo: fechaFin,
      diasEstimados: recursoArrastrado.diasEstimados,
      estado: 'PENDIENTE',
      tipoBloque: 'MAREA_SIMULADA',
      prioridad: recursoArrastrado.prioridad
    };

    escenarioActual.value.items.push(nuevoItemSimulado);

    // Remover del sidebar pendiente
    const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado?.id);
    if (idxRec !== -1) {
      recursosPendientes.value.splice(idxRec, 1);
      if (recursosPendientes.value.length === 0) {
        sidebarOpen.value = false;
      }
    }

    // Actualizar DataSet directamente
    const finInclusivo = new Date(nuevoItemSimulado.fechaArribo.getTime() - 86400000);
    currentItemsDataSet?.add({
      id: nuevoItemSimulado.id,
      group: nuevoItemSimulado.observadorId,
      start: nuevoItemSimulado.fechaZarpada,
      end: nuevoItemSimulado.fechaArribo,
      content: `<div class="flex items-center gap-1 font-bold"><span class="text-[10px]">✨</span> ${nuevoItemSimulado.pesqueriaNombre} [${nuevoItemSimulado.diasEstimados}d] (Proyectada)</div>`,
      title: `<strong>Inicio:</strong> ${new Date(nuevoItemSimulado.fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`,
      className: 'vis-item-simulada',
      editable: { updateTime: true, updateGroup: true, remove: true }
    });

    toast.success(`Marea simulada "${recursoArrastrado.pesqueriaNombre}" asignada`);
  } else {
    toast.warning('Suelte el recurso dentro de la fila de un observador específico');
  }

  draggedRecurso = null;
};

const guardarBorrador = () => {
  escenarioActual.value.fechaUltimaModificacion = new Date().toISOString();
  localStorage.setItem('sigmasimulador_draft', JSON.stringify(escenarioActual.value));
  toast.success('Borrador de simulación guardado localmente');
};

const limpiarSimulacion = () => {
  escenarioActual.value.items = [];
  renderTimeline();
  toast.info('Se han limpiado los bloques simulados');
};

onMounted(async () => {
  try {
    const [b, p] = await Promise.all([
      catalogosService.getBuques(),
      catalogosService.getPesquerias()
    ]);
    buques.value = b;
    pesquerias.value = p;
  } catch (e) {
    console.error('Error fetching catalogs:', e);
    toast.error('Ocurrió un error al cargar catálogos.');
  } finally {
    loadingCatalogs.value = false;
  }
  
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
:deep(.vis-item) {
  border-radius: 6px;
  box-shadow: inset 0 0 0 1px rgba(0,0,0,0.1);
}

:deep(.vis-item-simulada) {
  border: 2px dashed var(--color-primary, #0284c7) !important;
  background-color: rgba(2, 132, 199, 0.15) !important;
  color: var(--color-primary, #0284c7) !important;
  font-weight: bold !important;
}

:deep(.vis-item-content) {
  padding: 3px 5px !important;
  width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: 11px !important;
  font-weight: 500 !important;
  box-sizing: border-box !important;
  line-height: 1.2 !important;
  display: block !important;
}

:deep(.vis-label) {
  font-size: 12px !important;
}

:deep(.vis-label .vis-inner) {
  padding: 6px 4px !important;
}

:deep(.vis-label .vis-inner div) {
  font-size: 12px !important;
  line-height: 1.2 !important;
}

:deep(.vis-time-axis .vis-text) {
  font-weight: 500;
  color: var(--color-text-muted, #374151) !important;
  font-size: 11px !important;
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
</style>

<style scoped>
/* LIGHT MODE */
/* Legend */
.legend-designada { background-color: #e0f2fe; border-color: #0ea5e9; }
.legend-ejecucion { background-color: #22c55e; border-color: #16a34a; }
.legend-finalizada { background-color: #dcfce7; border-color: #86efac; }
.legend-licencia { background-color: #f3f4f6; border-color: #d1d5db; }
.legend-proyectada { background-color: rgba(59, 130, 246, 0.2); border-color: #3b82f6; border-style: dashed; }

/* Timeline Items */
:global(.simulador-timeline .vis-item) { border-radius: 4px; }
:global(.simulador-timeline .vis-item-designada) { background-color: #e0f2fe !important; border: 2px solid #0ea5e9 !important; color: #0369a1 !important; }
:global(.simulador-timeline .vis-item-ejecucion) { background-color: #22c55e !important; border: 2px solid #16a34a !important; color: #ffffff !important; }
:global(.simulador-timeline .vis-item-navegando) { background-color: #dcfce7 !important; border: 2px solid #86efac !important; color: #15803d !important; opacity: 0.8 !important; }
:global(.simulador-timeline .vis-item-novedad) { background-color: #f3f4f6 !important; border: 2px solid #d1d5db !important; color: #6b7280 !important; }
:global(.simulador-timeline .vis-item-simulada) { background-color: rgba(59, 130, 246, 0.2) !important; border: 2px dashed #3b82f6 !important; color: #1d4ed8 !important; }
:global(.simulador-timeline .vis-item-conflicto) { background-color: #ef4444 !important; border: 2px solid #b91c1c !important; color: #ffffff !important; }
:global(.simulador-timeline .vis-item-content) { font-weight: bold !important; padding: 4px 8px !important; }

/* DARK MODE */
/* Legend */
:global(.dark) .legend-designada { background-color: rgba(14, 165, 233, 0.2); border-color: #0284c7; }
:global(.dark) .legend-ejecucion { background-color: #15803d; border-color: #166534; }
:global(.dark) .legend-finalizada { background-color: rgba(22, 163, 74, 0.2); border-color: #15803d; }
:global(.dark) .legend-licencia { background-color: rgba(107, 114, 128, 0.2); border-color: #4b5563; }
:global(.dark) .legend-proyectada { background-color: rgba(59, 130, 246, 0.15); border-color: #3b82f6; }

/* Timeline Items */
:global(.dark .simulador-timeline .vis-item-designada) { background-color: rgba(14, 165, 233, 0.2) !important; border-color: #0284c7 !important; color: #bae6fd !important; }
:global(.dark .simulador-timeline .vis-item-ejecucion) { background-color: #15803d !important; border-color: #166534 !important; color: #ffffff !important; }
:global(.dark .simulador-timeline .vis-item-navegando) { background-color: rgba(22, 163, 74, 0.2) !important; border-color: #15803d !important; color: #86efac !important; opacity: 0.8 !important; }
:global(.dark .simulador-timeline .vis-item-novedad) { background-color: rgba(107, 114, 128, 0.2) !important; border-color: #4b5563 !important; color: #d1d5db !important; }
:global(.dark .simulador-timeline .vis-item-simulada) { background-color: rgba(59, 130, 246, 0.15) !important; border-color: #3b82f6 !important; color: #93c5fd !important; }
:global(.dark .simulador-timeline .vis-item-conflicto) { background-color: #991b1b !important; border-color: #7f1d1d !important; color: #ffffff !important; }
</style>
