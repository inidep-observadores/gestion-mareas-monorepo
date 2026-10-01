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
              v-for="recurso in recursosVisibles"
              :key="recurso.id"
              draggable="true"
              @dragstart="onDragStartRecurso($event, recurso)"
              @dblclick="abrirModalEditarRecurso(recurso)"
              class="p-3.5 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all cursor-grab active:cursor-grabbing shadow-sm group relative"
            >
              <div class="flex items-center justify-between mb-1.5 pr-14 relative">
                <span class="text-xs font-extrabold text-primary group-hover:text-primary-hover transition-colors truncate pr-2">
                  {{ activeTab === 'observador' ? recurso.buqueNombre : recurso.observadorNombre }}
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
                <div v-if="activeTab === 'observador' && recurso.pesqueriaNombre" class="flex items-center gap-1">
                  <WaveIcon class="w-3.5 h-3.5 shrink-0" />
                  <span class="font-medium text-text">{{ recurso.pesqueriaNombre }}</span>
                </div>
                <div class="flex items-center justify-between text-[11px]">
                  <span>Duración estimada:</span>
                  <span class="font-bold text-text">{{ recurso.diasEstimados }} días</span>
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
          class="bg-surface rounded-2xl shadow-sm border border-border p-4 transition-all flex flex-col gap-4 relative overflow-hidden"
        >
          <!-- Tabs de Vista -->
          <div class="flex items-center gap-1 border-b border-border bg-surface-muted/30 -mx-4 -mt-4 px-4 pt-2 mb-2">
            <button 
              @click="activeTab = 'observador'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'observador' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <UserCircleIcon class="w-4 h-4" />
              Por observador
            </button>
            
            <button 
              @click="activeTab = 'buque'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'buque' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <ShipIcon class="w-4 h-4" />
              Por buque
            </button>
            <div class="ml-auto pr-4" v-if="activeTab === 'buque'">
              <button 
                @click="isAddBuqueModalOpen = true"
                class="px-3 py-1.5 text-xs font-bold text-primary border border-primary rounded hover:bg-primary hover:text-white transition-colors flex items-center gap-1"
              >
                <PlusIcon class="w-3.5 h-3.5" /> Agregar Buque
              </button>
            </div>
          </div>

          <!-- Loading State -->
          <div v-if="isLoading" class="p-12 flex flex-col items-center justify-center bg-surface rounded-2xl">
            <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="text-sm font-bold text-text-muted">Cargando disponibilidad de observadores...</p>
          </div>

          <!-- Timelines -->
          <SimuladorTimeline 
            v-if="!isLoading && activeTab === 'observador'"
            mode="observador"
            :groups="timelineObservadorGroups"
            :items="timelineObservadorItems"
            @item-moved="handleItemMoved"
            @item-removed="handleItemRemoved"
            @drop-recurso="handleDropRecurso"
            @edit-item="handleEditItem"
            class="h-[65vh] border-t border-border"
          />

          <SimuladorTimeline 
            v-if="!isLoading && activeTab === 'buque'"
            mode="buque"
            :groups="timelineBuqueGroups"
            :items="timelineBuqueItems"
            @item-moved="handleItemMoved"
            @item-removed="handleItemRemoved"
            @drop-recurso="handleDropRecurso"
            @edit-item="handleEditItem"
            class="h-[65vh] border-t border-border"
          />
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
          <div class="space-y-1.5" v-if="activeTab === 'observador'">
            <label class="block text-xs font-bold text-text-muted">Buque (obligatorio)</label>
            <SearchableSelect 
              ref="buqueSelectRef"
              v-model="resourceForm.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
              @change="onBuqueResourceChange"
            />
          </div>
          <div class="space-y-1.5" v-if="activeTab === 'buque'">
            <label class="block text-xs font-bold text-text-muted">Observador (obligatorio)</label>
            <SearchableSelect 
              ref="observadorSelectRef"
              v-model="resourceForm.observadorId" 
              :options="observadorOptions" 
              :icon="UserCircleIcon" 
              placeholder="Seleccione observador..." 
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

    <!-- Modal Agregar Buque al Timeline -->
    <BaseModal 
      :show="isAddBuqueModalOpen" 
      @close="isAddBuqueModalOpen = false" 
      maxWidth="md" 
      title="Agregar Buque al Timeline"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              v-model="selectedBuqueToAdd" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
        </div>
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="isAddBuqueModalOpen = false" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">Cancelar</button>
          <button @click="addBuqueToTimeline"  class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Aceptar</button>
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
              :modelValue="editingBlockData.buqueId ?? null"
              @update:modelValue="(v) => (editingBlockData!.buqueId = v as string | null)"
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
  EditIcon,
  UserCircleIcon
} from '@/icons';
import { toast } from 'vue-sonner';
import disponibilidadApi from '@/modules/admin/services/disponibilidad.service';
import type { DisponibilidadResponse, ObservadorDisponibilidadRow } from '@/modules/admin/interfaces/disponibilidad.interface';
import { getBloqueLabel, getItemVisClass, formatItemTooltip } from '@/modules/shared/utils/timeline-styles';
import catalogosService from '../../mareas/services/catalogos.service';
import type { MareaSimuladaItem, EscenarioSimulacionState } from '../interfaces/simulador.interface';
import SimuladorTimeline from '../components/SimuladorTimeline.vue';

import { useConfigStore } from '@/modules/shared/stores/config.store';
const configStore = useConfigStore();

const isLoading = ref(false);
const searchQuery = ref('');
const debouncedSearchQuery = ref('');
let searchTimeout: ReturnType<typeof setTimeout>;

watch(searchQuery, (newVal) => {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    debouncedSearchQuery.value = newVal;
  }, 300);
});

const sidebarOpen = ref(true);
const activeTab = ref<'observador' | 'buque'>('observador');

// Estado del Escenario Borrador
const escenarioActual = ref<EscenarioSimulacionState>({
  id: 'escenario-draft-1',
  nombre: 'Escenario Borrador 1',
  anioOperativo: configStore.selectedYear,
  estado: 'BORRADOR',
  fechaCreacion: new Date().toISOString(),
  items: []
});

// Datos de Recursos Pendientes (Simulados / Requerimientos)
export interface RecursoPendiente {
  id: string;
  tipo: 'buque' | 'observador';
  buqueId?: string;
  buqueNombre?: string;
  pesqueriaId?: string;
  pesqueriaNombre?: string;
  observadorId?: string;
  observadorNombre?: string;
  diasEstimados: number;
  prioridad: string;
}

const recursosPendientes = ref<RecursoPendiente[]>([]);

const recursosVisibles = computed(() => {
  return recursosPendientes.value.filter(r => r.tipo === (activeTab.value === 'observador' ? 'buque' : 'observador'));
});

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
const isAddBuqueModalOpen = ref(false);
const selectedBuqueToAdd = ref('');
const buquesAdicionales = ref<string[]>([]);

const addBuqueToTimeline = () => {
  if (selectedBuqueToAdd.value && !buquesAdicionales.value.includes(selectedBuqueToAdd.value)) {
    buquesAdicionales.value.push(selectedBuqueToAdd.value);
  }
  isAddBuqueModalOpen.value = false;
  selectedBuqueToAdd.value = '';
};

// Datos de Simulación
const datosSimulacion = ref<DisponibilidadResponse | null>(null);

// Observadores extraídos de los datos de simulación
const observadoresBase = computed(() => {
  if (!datosSimulacion.value) return [];
  return datosSimulacion.value.observadores.map(r => r.observador);
});

// Estado para modales
const isResourceModalOpen = ref(false);
const editingRecursoId = ref<string | null>(null);
const resourceForm = ref<{
  pesqueriaId: string;
  buqueId: string | null;
  observadorId: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  pesqueriaId: '',
  buqueId: null,
  observadorId: null,
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
    buqueId: null,
    observadorId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    pesqueriaSelectRef.value?.focus();
  });
};

const abrirModalEditarRecurso = (recurso: RecursoPendiente) => {
  editingRecursoId.value = recurso.id || null;
  resourceForm.value = {
    pesqueriaId: recurso.pesqueriaId || '',
    buqueId: recurso.buqueId || null,
    observadorId: recurso.observadorId || null,
    diasEstimados: recurso.diasEstimados || 30,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
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
  if (activeTab.value === 'observador') {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (!b) {
      toast.error('Debe seleccionar un buque');
      return;
    }
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          buqueId: b.id,
          buqueNombre: b.nombreBuque,
          pesqueriaId: b.pesqueriaHabitualId,
          pesqueriaNombre: b.pesqueriaHabitual?.nombre,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'buque',
        buqueId: b.id,
        buqueNombre: b.nombreBuque,
        pesqueriaId: b.pesqueriaHabitualId,
        pesqueriaNombre: b.pesqueriaHabitual?.nombre,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
  } else {
    const o = observadoresBase.value.find(x => x.id === resourceForm.value.observadorId);
    if (!o) {
      toast.error('Debe seleccionar un observador');
      return;
    }
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          observadorId: o.id,
          observadorNombre: `${o.apellido}, ${o.nombre}`,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'observador',
        observadorId: o.id,
        observadorNombre: `${o.apellido}, ${o.nombre}`,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
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
    
    // Actualizar escenarioActual (reactivo, SimuladorTimeline lo reflejará)

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
    
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      tipo: activeTab.value === 'observador' ? 'buque' : 'observador',
      pesqueriaId: removedItem.pesqueriaId || undefined,
      pesqueriaNombre: removedItem.pesqueriaNombre || undefined,
      buqueId: removedItem.buqueId || undefined,
      buqueNombre: removedItem.buqueNombre || undefined,
      observadorId: removedItem.observadorId || undefined,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA'
    });
    
    toast.success('Marea devuelta a recursos pendientes');
  }
  cerrarModalEditarBloque();
};


// Sidebar state

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value;
};

const filteredObservadores = computed(() => {
  if (observadoresBase.value.length === 0) return [];
  return observadoresBase.value.filter(o => {
    const s = debouncedSearchQuery.value.toLowerCase();
    return !s || `${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s);
  });
});

// Conflictos detectados en tiempo real
const conflictosDetectados = computed(() => {
  const alertas: string[] = [];
  const simulados = escenarioActual.value.items.filter(i => i.tipoBloque === 'MAREA_SIMULADA');
  if (simulados.length === 0 || !datosSimulacion.value) return alertas;

  simulados.forEach(sim => {
    if (!sim.observadorId) return;

    const inicio = new Date(sim.fechaZarpada);
    inicio.setHours(0, 0, 0, 0);
    const fin = new Date(sim.fechaArribo);
    fin.setHours(23, 59, 59, 999);

    const row = datosSimulacion.value!.observadores.find(r => r.observador.id === sim.observadorId);
    if (!row) return;

    for (const ev of row.eventos) {
      if (ev.estado === 'DISPONIBLE' || ev.estado === 'DISPONIBLE_NO_CONFIRMADA') continue;
      if (ev.estado === 'NOVEDAD' && ev.flexible) continue;

      const evStart = new Date(ev.startDate + 'T00:00:00');
      const evEnd = new Date(ev.endDate + 'T00:00:00');
      
      if (inicio <= evEnd && fin >= evStart) {
        alertas.push(
          `Marea simulada "${sim.pesqueriaNombre}" se solapa con [${getBloqueLabel(ev)}] del ${evStart.toLocaleDateString('es-AR')} al ${evEnd.toLocaleDateString('es-AR')}.`
        );
      }
    }
  });

  return alertas;
});

const fetchData = async () => {
  isLoading.value = true;
  let dataLoaded = false;
  try {
    // Pedimos 12 meses de disponibilidad para simulación a mediano plazo
    const data = await disponibilidadApi.obtenerDisponibilidad(12);
    datosSimulacion.value = data;
    dataLoaded = true;
  } catch (error) {
    console.error('[SimuladorCobertura] Error al cargar datos:', error);
    toast.error('Ocurrió un error al cargar los datos de planificación');
    datosSimulacion.value = null;
  } finally {
    isLoading.value = false;
  }
};

// Re-renderizar cuando cambien los filtros de búsqueda o el año operativo
// (el render inicial lo hace fetchData() directamente)
watch([filteredObservadores, () => configStore.selectedYear], async () => {
  if (!datosSimulacion.value) return;
});

const timelineObservadorGroups = computed(() => {
  return filteredObservadores.value.map(obs => ({
    id: obs.id,
    content: `<div class="text-text font-bold text-xs">${obs.apellido}, ${obs.nombre}</div>`,
    value: obs.apellido
  }));
});

const timelineObservadorItems = computed(() => {
  const items: any[] = [];
  
  if (datosSimulacion.value) {
    filteredObservadores.value.forEach(obs => {
      const row = datosSimulacion.value!.observadores.find(r => r.observador.id === obs.id);
      if (!row) return;

      const nombreObs = `${obs.apellido}, ${obs.nombre}`;
      row.eventos.forEach(item => {
        items.push({
          id: `real-${obs.id}-${item.id}`,
          group: obs.id,
          start: new Date(item.startDate + 'T00:00:00'),
          end: new Date(item.endDate + 'T00:00:00'),
          content: getBloqueLabel(item),
          className: getItemVisClass(item),
          title: formatItemTooltip(item, nombreObs),
          editable: false
        });
      });
    });
  }

  escenarioActual.value.items.forEach(sim => {
    const duracionSim = Math.round((new Date(sim.fechaArribo).getTime() - new Date(sim.fechaZarpada).getTime()) / 86400000);
    const finInclusivo = new Date(new Date(sim.fechaArribo).getTime() - 86400000);
    items.push({
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

  return items;
});

const timelineBuqueGroups = computed(() => {
  if (!datosSimulacion.value) return [];
  
  const buquesMap = new Map<string, string>();
  
  // Extraer buques de mareas reales
  datosSimulacion.value.observadores.forEach(obsRow => {
    obsRow.eventos.forEach(ev => {
      if (ev.buqueId && ev.buqueNombre) {
        buquesMap.set(ev.buqueId, ev.buqueNombre);
      }
    });
  });
  
  // Extraer buques de mareas simuladas
  escenarioActual.value.items.forEach(sim => {
    if (sim.buqueId && sim.buqueNombre) {
      buquesMap.set(sim.buqueId, sim.buqueNombre);
    }
  });

  const groups = Array.from(buquesMap.entries()).map(([id, nombre]) => ({
    id: id,
    content: `<div class="text-text font-bold text-xs flex items-center gap-1"><span class="text-sm mr-1">⛴</span> ${nombre}</div>`,
    value: nombre
  }));
  
  // Ordenar alfabéticamente
  groups.sort((a, b) => a.value.localeCompare(b.value));
  return groups;
});

const timelineBuqueItems = computed(() => {
  const items: any[] = [];
  
  if (datosSimulacion.value) {
    datosSimulacion.value.observadores.forEach(row => {
      const nombreObs = `${row.observador.apellido}, ${row.observador.nombre}`;
      
      row.eventos.forEach(item => {
        if (!item.buqueId) return; // Solo ploteamos mareas con buque
        
        items.push({
          id: `real-${row.observador.id}-${item.id}`,
          group: item.buqueId,
          start: new Date(item.startDate + 'T00:00:00'),
          end: new Date(item.endDate + 'T00:00:00'),
          content: `<div class="text-[10px] truncate max-w-[120px] font-bold flex flex-col"><span>${nombreObs}</span><span class="opacity-75 font-normal">${getBloqueLabel(item)}</span></div>`,
          className: getItemVisClass(item),
          title: formatItemTooltip(item, nombreObs),
          editable: false
        });
      });
    });
  }

  escenarioActual.value.items.forEach(sim => {
    if (!sim.buqueId) return;
    
    // Buscar nombre de observador para las simuladas
    let obsNombre = "Sin Asignar";
    if (sim.observadorId) {
      const obsInfo = datosSimulacion.value?.observadores.find(o => o.observador.id === sim.observadorId)?.observador;
      if (obsInfo) obsNombre = `${obsInfo.apellido}, ${obsInfo.nombre}`;
    }

    const duracionSim = Math.round((new Date(sim.fechaArribo).getTime() - new Date(sim.fechaZarpada).getTime()) / 86400000);
    const finInclusivo = new Date(new Date(sim.fechaArribo).getTime() - 86400000);
    items.push({
      id: sim.id,
      group: sim.buqueId,
      start: new Date(sim.fechaZarpada),
      end: new Date(sim.fechaArribo),
      content: `<div class="flex flex-col items-start leading-tight"><span class="text-[10px] font-black truncate max-w-[100px]">${obsNombre}</span><span class="text-[9px] opacity-70 truncate max-w-[100px]">✨ ${sim.pesqueriaNombre} [${duracionSim}d]</span></div>`,
      title: `<strong>Inicio:</strong> ${new Date(sim.fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}`,
      className: 'vis-item-simulada border-2 border-dashed border-primary bg-primary/20 text-primary font-bold shadow-sm',
      editable: { updateTime: true, updateGroup: true, remove: true }
    });
  });

  return items;
});

const handleItemMoved = (payload: { id: string; start: Date; end: Date; group: string; isReal: boolean }) => {
  if (payload.isReal) {
     return;
  }
  
  const sim = escenarioActual.value.items.find(i => i.id === payload.id);
  if (sim) {
    if (activeTab.value === 'observador') {
      sim.observadorId = payload.group;
    } else if (activeTab.value === 'buque') {
      sim.buqueId = payload.group;
    }
    sim.fechaZarpada = payload.start;
    sim.fechaArribo = payload.end;
  }
};

const handleItemRemoved = (id: string) => {
  const idx = escenarioActual.value.items.findIndex(i => i.id === id);
  if (idx !== -1) {
    const removedItem = escenarioActual.value.items[idx];
    escenarioActual.value.items.splice(idx, 1);
    
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      tipo: activeTab.value === 'observador' ? 'buque' : 'observador',
      pesqueriaId: removedItem.pesqueriaId || undefined,
      pesqueriaNombre: removedItem.pesqueriaNombre || undefined,
      buqueId: removedItem.buqueId || undefined,
      buqueNombre: removedItem.buqueNombre || undefined,
      observadorId: removedItem.observadorId || undefined,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA'
    });
    
    toast.success('Marea simulada eliminada y devuelta a recursos');
  }
};

const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
  const recursoArrastrado = payload.recurso;
  let fechaInicio = payload.date;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaInicio < today) {
    fechaInicio = today;
  }

  const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

  let obsId = undefined;
  let bId = recursoArrastrado.buqueId;
  let bNombre = recursoArrastrado.buqueNombre;
  let pId = recursoArrastrado.pesqueriaId;
  let pNombre = recursoArrastrado.pesqueriaNombre;
  
  if (activeTab.value === 'observador') {
    obsId = payload.group;
  } else {
    // payload.group es el buqueId
    bId = payload.group;
    obsId = recursoArrastrado.observadorId!;
    // Rellenar pesqueria si el buque existe en catalogo
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog) {
       bNombre = bCatalog.nombreBuque;
       pId = bCatalog.pesqueriaHabitualId;
       pNombre = bCatalog.pesqueriaHabitual?.nombre;
    }
  }

  const nuevoItemSimulado: MareaSimuladaItem = {
    id: `sim-${Date.now()}`,
    tipoBloque: 'MAREA_SIMULADA',
    pesqueriaId: pId,
    pesqueriaNombre: pNombre,
    buqueId: bId,
    buqueNombre: bNombre,
    observadorId: obsId,
    fechaZarpada: fechaInicio,
    fechaArribo: fechaFin,
    diasEstimados: recursoArrastrado.diasEstimados,
    estado: 'PENDIENTE',
    prioridad: recursoArrastrado.prioridad || 'MEDIA'
  };

  escenarioActual.value.items.push(nuevoItemSimulado);

  // Remover del sidebar pendiente
  const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado.id);
  if (idxRec !== -1) {
    recursosPendientes.value.splice(idxRec, 1);
    if (recursosPendientes.value.length === 0) {
      sidebarOpen.value = false;
    }
  }

  toast.success('Marea simulada asignada');
};

const handleEditItem = (id: string) => {
  const sim = escenarioActual.value.items.find(i => i.id === id);
  if (sim) {
    editingBlockData.value = { ...sim };
    isEditBlockModalOpen.value = true;
  }
};

// Drag & Drop HTML5 desde Sidebar a Timeline (inicio)
let draggedRecurso: RecursoPendiente | null = null;

const onDragStartRecurso = (event: DragEvent, recurso: RecursoPendiente) => {
  draggedRecurso = recurso;
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'copy';
    // Enviamos tipo='buque' u observador no importa, usamos 'buque' genérico
    const dropData = {
      type: 'buque', // Para que lo atrape el SimuladorTimeline
      ...recurso
    };
    event.dataTransfer.setData('application/json', JSON.stringify(dropData));
    event.dataTransfer.setData('text/plain', recurso.id);
  }
};

const guardarBorrador = () => {
  escenarioActual.value.fechaUltimaModificacion = new Date().toISOString();
  localStorage.setItem('sigmasimulador_draft', JSON.stringify(escenarioActual.value));
  toast.success('Borrador de simulación guardado localmente');
};

const limpiarSimulacion = () => {
  escenarioActual.value.items = [];
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


const isResourceFormValid = computed(() => {
  if (activeTab.value === 'observador') return !!resourceForm.value.buqueId;
  return !!resourceForm.value.observadorId;
});

const onBuqueResourceChange = () => {
  if (resourceForm.value.buqueId) {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (b && b.diasMareaEstimada) {
      resourceForm.value.diasEstimados = b.diasMareaEstimada;
    }
  }
};

const observadorOptions = computed(() => 
  observadoresBase.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre}`
  }))
);

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

.simulador-timeline {
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
.legend-disponible, :global(.simulador-timeline .vis-item-disponible) {
  background-color: #facc15 !important; /* Amarillo vibrante */
  color: #713f12 !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.simulador-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(250, 204, 21, 0.22) !important; /* Mismo color pero atenuado */
  color: #854d0e !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

.legend-navegando, :global(.simulador-timeline .vis-item-navegando) {
  background-color: #22c55e !important;
  color: white !important;
  border-color: #16a34a !important;
  border-width: 2px !important;
  border-style: solid !important;
}

:global(.simulador-timeline .vis-item-navegando-proyectada) {
  background-color: #dcfce7 !important; /* Verde atenuado */
  color: #15803d !important;            /* Texto verde */
  border-color: #22c55e !important;     /* Borde verde */
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado para proyectados */
  font-weight: 800 !important;
}

.legend-naveg-viaje, :global(.simulador-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #16a34a 50%, #4338ca 50%) !important;
  color: white !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-designada, :global(.simulador-timeline .vis-item-designada) {
  background-color: #dcfce7 !important;
  color: #15803d !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

.legend-novedad, :global(.simulador-timeline .vis-item-novedad) {
  background-color: #e0f2fe !important;
  color: #0369a1 !important;
  border-color: #7dd3fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

:global(.simulador-timeline .vis-item-no-disponible) {
  background-color: #fee2e2 !important; /* Rojo suave */
  color: #991b1b !important;            /* Texto contrastado */
  border-color: #fca5a5 !important;     /* Borde rojo suave */
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.simulador-timeline .vis-item-no-disponible-proyectada) {
  background-color: #fff1f2 !important; /* Rojo más claro/atenuado */
  color: #9f1239 !important;
  border-color: #f43f5e !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado para proyectados */
  font-weight: 700 !important;
}

.legend-puerto, :global(.simulador-timeline .vis-item-puerto) {
  background-color: #ffedd5 !important;
  color: #c2410c !important;
  border-color: #fdba74 !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-viaje, :global(.simulador-timeline .vis-item-viaje) {
  background-color: #e0e7ff !important;
  color: #4338ca !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-ez, :global(.simulador-timeline .vis-item-ez) {
  background-color: #f3f4f6 !important;
  color: #374151 !important;
  border-color: #d1d5db !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-impedido, :global(.simulador-timeline .vis-item-impedido) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-conflicto, :global(.simulador-timeline .vis-item-conflicto) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

/* Eventos flexibles (borde punteado y efecto) */
.legend-flexible, :global(.simulador-timeline .vis-item-flexible) {
  border-style: dashed !important;
  border-width: 2px !important;
  border-color: #f59e0b !important;
  background-color: #fef3c7 !important;
  color: #92400e !important;
}

/* ESTILOS EN MODO OSCURO */
:global(.dark) .legend-disponible, :global(.dark .simulador-timeline .vis-item-disponible) {
  background-color: #ca8a04 !important;
  color: #fef08a !important;
  border-color: #a16207 !important;
}

:global(.dark .simulador-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(202, 138, 4, 0.22) !important; /* Atenuado */
  color: #fef08a !important;
  border-color: #ca8a04 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

:global(.dark) .legend-navegando, :global(.dark .simulador-timeline .vis-item-navegando) {
  background-color: #15803d !important;
  color: white !important;
  border-color: #166534 !important;
}

:global(.dark .simulador-timeline .vis-item-navegando-proyectada) {
  background-color: rgba(34, 197, 94, 0.2) !important; /* Verde atenuado */
  color: #86efac !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado */
  font-weight: 800 !important;
}

:global(.dark) .legend-designada, :global(.dark .simulador-timeline .vis-item-designada) {
  background-color: rgba(34, 197, 94, 0.2) !important;
  color: #86efac !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

:global(.dark) .legend-naveg-viaje, :global(.dark .simulador-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #15803d 50%, rgba(79, 70, 229, 0.4) 50%) !important;
  color: white !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-novedad, :global(.dark .simulador-timeline .vis-item-novedad) {
  background-color: rgba(14, 165, 233, 0.25) !important;
  color: #bae6fd !important;
  border-color: rgba(14, 165, 233, 0.5) !important;
}

:global(.dark .simulador-timeline .vis-item-no-disponible) {
  background-color: rgba(239, 68, 68, 0.22) !important; /* Rojo suave en oscuro */
  color: #fecaca !important;
  border-color: rgba(239, 68, 68, 0.5) !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.dark .simulador-timeline .vis-item-no-disponible-proyectada) {
  background-color: rgba(244, 63, 94, 0.12) !important; /* Atenuado */
  color: #fecdd3 !important;
  border-color: rgba(244, 63, 94, 0.6) !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado */
  font-weight: 700 !important;
}

:global(.dark) .legend-puerto, :global(.dark .simulador-timeline .vis-item-puerto) {
  background-color: rgba(234, 88, 12, 0.25) !important;
  color: #ffedd5 !important;
  border-color: rgba(234, 88, 12, 0.5) !important;
}

:global(.dark) .legend-viaje, :global(.dark .simulador-timeline .vis-item-viaje) {
  background-color: rgba(79, 70, 229, 0.25) !important;
  color: #e0e7ff !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-ez, :global(.dark .simulador-timeline .vis-item-ez) {
  background-color: #374151 !important;
  color: #e5e7eb !important;
  border-color: #4b5563 !important;
}

:global(.dark) .legend-impedido, :global(.dark .simulador-timeline .vis-item-impedido) {
  background-color: #991b1b !important;
  color: white !important;
  border-color: #7f1d1d !important;
}

:global(.dark) .legend-flexible, :global(.dark .simulador-timeline .vis-item-flexible) {
  border-color: #f59e0b !important;
  background-color: rgba(245, 158, 11, 0.2) !important;
  color: #fef3c7 !important;
}

:global(.simulador-timeline .vis-item-content) {
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


:global(.simulador-timeline .vis-item-simulada) {
  background-color: rgba(59, 130, 246, 0.15) !important;
  border-color: #3b82f6 !important;
  color: #1d4ed8 !important;
  border-width: 2px !important;
  border-style: dashed !important;
  font-weight: 800 !important;
}
:global(.dark .simulador-timeline .vis-item-simulada) {
  background-color: rgba(59, 130, 246, 0.15) !important;
  border-color: #3b82f6 !important;
  color: #93c5fd !important;
}

</style>
