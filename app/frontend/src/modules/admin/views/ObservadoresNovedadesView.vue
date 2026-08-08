<template>
  <AdminLayout>
    <div class="sticky top-[56px] lg:top-[72px] z-30 bg-surface pt-2 pb-2 -mx-4 px-4 sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8 border-b border-border mb-6">
      <BackButton routeName="SistemaObservadores" label="Regresar al Panel" class="mb-4" />
      
      <div class="flex gap-6 overflow-x-auto">
        <button 
          @click="activeTab = 'historial'" 
          class="pb-3 px-1 border-b-2 font-bold transition-colors whitespace-nowrap"
          :class="activeTab === 'historial' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
        >
          Historial Completo
        </button>
        <button 
          @click="activeTab = 'pendientes'" 
          class="pb-3 px-1 border-b-2 font-bold transition-colors whitespace-nowrap flex items-center gap-2"
          :class="activeTab === 'pendientes' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
        >
          Bandeja de Pendientes
          <span v-if="pendientesCount > 0" class="bg-error text-white text-[10px] px-2 py-0.5 rounded-full">
            {{ pendientesCount }}
          </span>
        </button>
        <button 
          v-show="false"
          @click="activeTab = 'calendario'" 
          class="pb-3 px-1 border-b-2 font-bold transition-colors whitespace-nowrap"
          :class="activeTab === 'calendario' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
        >
          Calendario
        </button>
      </div>
    </div>

    <div class="flex flex-col xl:flex-row gap-6 items-start">
      <div class="flex-1 min-w-0 w-full transition-all duration-300">
        <BaseDataList 
          v-if="activeTab !== 'calendario'"
          title="Gestión de Novedades" 
      description="Administración de licencias, francos compensatorios y otras novedades de los observadores."
      :items="filteredNovedades"
      :is-loading="isLoading" 
      v-model:search="searchQuery" 
      search-placeholder="Buscar novedad por observador o motivo...">

      <template #filters>
        <div class="flex flex-col items-end gap-3 w-full">
          <button 
            @click="openCreateModal" 
            class="flex items-center justify-center gap-2 rounded-lg bg-brand-500 px-4 py-2 text-sm font-semibold text-white shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 transition-colors"
          >
            <PlusIcon class="w-4 h-4 stroke-[3]" />
            Nueva Novedad
          </button>

          <div class="flex flex-wrap items-center gap-2">
            <select 
              v-model="filterContrato"
              class="px-3 py-2.5 bg-surface border border-border rounded-lg text-sm focus:outline-none focus:border-primary cursor-pointer text-text"
            >
              <option value="">Contrato (Todos)</option>
              <option v-for="c in TIPO_CONTRATO" :key="c.id" :value="c.id">{{ c.name }}</option>
            </select>

            <select 
              v-model="filterOrigen"
              class="px-3 py-2.5 bg-surface border border-border rounded-lg text-sm focus:outline-none focus:border-primary cursor-pointer text-text"
            >
              <option value="">Origen (Todos)</option>
              <option v-for="o in origenesPermitidos" :key="o" :value="o">{{ o }}</option>
            </select>

            <div class="flex items-center gap-2">
              <DatePicker 
                v-model="filterFechaInicio"
                placeholder="Desde..."
                class="w-32"
              />
              <span class="text-text-muted">-</span>
              <DatePicker 
                v-model="filterFechaFin"
                placeholder="Hasta..."
                class="w-32"
              />
            </div>

            <button @click="clearFilters"
              class="group flex items-center gap-2 px-4 py-2.5 rounded-xl border border-border text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-surface-muted hover:text-primary transition-all active:scale-95 bg-surface shadow-theme-xs"
              title="Limpiar filtros">
              <RefreshCcwIcon class="w-3.5 h-3.5 group-hover:rotate-180 transition-transform duration-500" />
              Limpiar
            </button>
          </div>
        </div>
      </template>
      
      <template #table-header>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('observador.apellido')">
          <div class="flex items-center gap-2">
              Observador
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'observador.apellido' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'observador.apellido' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('tipoNovedad.descripcion')">
          <div class="flex items-center gap-2">
              Tipo
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'tipoNovedad.descripcion' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'tipoNovedad.descripcion' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('origen')">
          <div class="flex items-center gap-2">
              Origen
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'origen' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'origen' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('fechaInicio')">
          <div class="flex items-center gap-2">
              Fecha Inicio
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'fechaInicio' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'fechaInicio' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('fechaFin')">
          <div class="flex items-center gap-2">
              Fecha Fin
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'fechaFin' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'fechaFin' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 text-right">Acciones</th>
      </template>

      <template #table-row="{ item: novedad }">
        <td class="px-6 py-4 font-medium text-text cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(novedad)">
          {{ novedad.observador?.apellido }}, {{ novedad.observador?.nombre }}
          <div class="text-[10px] text-text-muted mt-0.5">{{ novedad.observador?.codigoInterno }}</div>
        </td>
        <td class="px-6 py-4 cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(novedad)">
          <div class="flex flex-col gap-1 items-start">
            <div class="flex items-center gap-2">
              <span class="inline-flex items-center bg-info/10 text-info text-[11px] font-bold px-2 py-0.5 rounded-full border border-info/20 uppercase tracking-tighter">
                {{ novedad.tipoNovedad?.descripcion || 'Desconocido' }}
              </span>
              <PaperclipIcon v-if="novedad.archivos?.length" class="h-4 w-4 text-primary shrink-0" title="Contiene archivos adjuntos" />
            </div>
            <span v-if="!novedad.activo" class="bg-error/10 text-error text-[9px] font-black px-2 py-0.5 rounded-full uppercase tracking-tighter">
              Eliminada
            </span>
            <span v-else-if="novedad.estadoAprobacion === 'PENDIENTE'" class="bg-warning/10 text-warning text-[9px] font-black px-2 py-0.5 rounded-full uppercase tracking-tighter">
              Pendiente
            </span>
            <span v-else-if="novedad.estadoAprobacion === 'RECHAZADA'" class="bg-error/10 text-error text-[9px] font-black px-2 py-0.5 rounded-full uppercase tracking-tighter">
              Rechazada
            </span>
          </div>
        </td>
        <td class="px-6 py-4 cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(novedad)">
          <span class="bg-surface-muted text-text-muted text-[10px] font-bold px-2 py-0.5 rounded border border-border uppercase tracking-widest">
            {{ novedad.origen || 'MANUAL' }}
          </span>
        </td>
        <td class="px-6 py-4 font-mono font-bold text-text whitespace-nowrap cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(novedad)">
          {{ formatDate(novedad.fechaInicio) }}
        </td>
        <td class="px-6 py-4 font-mono font-bold text-text whitespace-nowrap cursor-pointer hover:bg-surface-muted/50 transition-colors" @click="openSidePanel(novedad)">
          {{ novedad.fechaFin ? formatDate(novedad.fechaFin) : '-' }}
        </td>
        <td class="px-6 py-4 text-right">
          <div class="flex items-center justify-end gap-3">
            <template v-if="novedad.activo && novedad.estadoAprobacion === 'PENDIENTE'">
              <button @click="promptAction(novedad, 'APROBADA')" class="font-bold text-success hover:underline text-xs bg-success/10 px-2 py-1 rounded">
                  Aprobar
              </button>
              <button @click="promptAction(novedad, 'RECHAZADA')" class="font-bold text-error hover:underline text-xs bg-error/10 px-2 py-1 rounded">
                  Rechazar
              </button>
            </template>
            <button v-if="novedad.activo && novedad.estadoAprobacion !== 'RECHAZADA'" @click="openEditModal(novedad)" class="font-bold text-primary hover:underline">
                Editar
            </button>
            <button v-if="novedad.activo" @click="deleteNovedad(novedad)" class="font-bold text-error hover:underline" title="Eliminar">
              <TrashIcon class="w-4 h-4" />
            </button>
          </div>
        </td>
      </template>

      <template #card-item="{ item: novedad }">
        <div class="cursor-pointer hover:bg-surface-muted/30 transition-colors rounded-xl -mx-2 -mt-2 p-2" @click="openSidePanel(novedad)">
          <div class="flex items-start gap-4 mb-4">
            <div class="flex-1 min-w-0">
              <div class="flex items-center gap-2 mb-1.5">
                <div class="flex items-center gap-1.5">
                  <span class="inline-flex items-center text-[10px] font-black bg-info/10 text-info px-2 py-0.5 rounded-md uppercase">
                    {{ novedad.tipoNovedad?.descripcion || 'Desconocido' }}
                  </span>
                  <PaperclipIcon v-if="novedad.archivos?.length" class="h-4 w-4 text-primary shrink-0" title="Contiene archivos adjuntos" />
                </div>
                <span class="text-[9px] font-bold text-text-muted border border-border px-1.5 py-0.5 rounded uppercase">
                  {{ novedad.origen || 'MANUAL' }}
                </span>
              </div>
              <div class="font-extrabold text-text text-base truncate">{{ novedad.observador?.apellido }}, {{ novedad.observador?.nombre }}</div>
            </div>
          </div>

          <div class="grid grid-cols-2 gap-3 mb-4 p-3 bg-surface-muted rounded-xl border border-border">
            <div>
              <div class="text-[10px] text-text-muted uppercase font-black mb-1">Inicio</div>
              <div class="text-xs font-bold text-text uppercase tracking-tight">
                  {{ formatDate(novedad.fechaInicio) }}
              </div>
            </div>
            <div>
              <div class="text-[10px] text-text-muted uppercase font-black mb-1">Fin</div>
              <div class="text-xs font-bold text-text uppercase tracking-tight">
                  {{ novedad.fechaFin ? formatDate(novedad.fechaFin) : '-' }}
              </div>
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-border flex gap-2">
          <button v-if="novedad.activo && novedad.estadoAprobacion !== 'RECHAZADA'" @click="openEditModal(novedad)"
              class="flex-1 py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
              <EditIcon class="w-4 h-4" />
              Editar
          </button>
          <button v-if="novedad.activo" @click="deleteNovedad(novedad)"
              class="px-4 py-2.5 text-sm font-bold text-error bg-error/10 rounded-lg hover:bg-error/20 transition-colors flex items-center justify-center">
              <TrashIcon class="w-4 h-4" />
          </button>
        </div>
      </template>
        </BaseDataList>
        
        <ObservadorCalendarView 
          v-else 
          :novedades="novedades" 
          @eventClick="openSidePanel" 
          @observerChanged="closeSidePanel"
        />
      </div>

      <!-- PANEL DE DETALLE LATERAL PERSISTENTE -->
      <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="translate-x-4 opacity-0"
        enter-to-class="translate-x-0 opacity-100" leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-x-0 opacity-100" leave-to-class="translate-x-4 opacity-0">
        <div v-if="showSidePanel && sidePanelNovedad"
          class="w-full xl:w-[350px] 2xl:w-[450px] shrink-0 sticky top-24 h-[calc(100vh-14rem)] flex flex-col bg-surface border border-border rounded-2xl shadow-sm overflow-hidden self-start z-10 hidden xl:block">
          <NovedadContextDetailContent
            :novedad="sidePanelNovedad"
            @close="showSidePanel = false"
            @approve="(n) => { showSidePanel = false; promptAction(n, 'APROBADA'); }"
            @reject="(n) => { showSidePanel = false; promptAction(n, 'RECHAZADA'); }"
            @edit="(n) => { showSidePanel = false; openEditModal(n); }"
          />
        </div>
      </Transition>
    </div>

    <!-- NovedadContextDetailContent (Mobile Modal) -->
    <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0" enter-to-class="opacity-100" leave-active-class="transition duration-200 ease-in" leave-from-class="opacity-100" leave-to-class="opacity-0">
      <div v-if="showSidePanel && sidePanelNovedad !== null" class="fixed inset-0 z-50 xl:hidden">
        <!-- Backdrop -->
        <div class="fixed inset-0 bg-black/25 backdrop-blur-sm" @click="showSidePanel = false"></div>
        <!-- Contenido -->
        <div class="fixed inset-0 overflow-y-auto pointer-events-none">
          <div class="flex min-h-full items-center justify-center p-4 text-center">
            <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="opacity-0 scale-95" enter-to-class="opacity-100 scale-100" leave-active-class="transition duration-200 ease-in" leave-from-class="opacity-100 scale-100" leave-to-class="opacity-0 scale-95">
              <div v-if="showSidePanel && sidePanelNovedad !== null" class="w-full max-w-md transform overflow-hidden rounded-2xl bg-surface text-left align-middle shadow-xl transition-all pointer-events-auto flex flex-col max-h-[90vh]">
                <NovedadContextDetailContent
                  :novedad="sidePanelNovedad"
                  @close="showSidePanel = false"
                  @approve="(n) => { showSidePanel = false; promptAction(n, 'APROBADA'); }"
                  @reject="(n) => { showSidePanel = false; promptAction(n, 'RECHAZADA'); }"
                  @edit="(n) => { showSidePanel = false; openEditModal(n); }"
                />
              </div>
            </Transition>
          </div>
        </div>
      </div>
    </Transition>

    <NovedadDialog 
      :show="showModal" 
      :editData="selectedNovedad" 
      @close="closeModal" 
      @save="handleSave" 
    />
    
    <ConfirmationDialog
      :show="showConfirmDelete"
      title="Eliminar Novedad"
      message="¿Estás seguro de eliminar esta novedad? Esto podría alterar el historial de presentismo."
      confirmText="Eliminar"
      @confirm="confirmDelete"
      @close="showConfirmDelete = false"
    />

    <NovedadSidePanel
      :show="showSidePanel"
      :novedad="sidePanelNovedad"
      @close="showSidePanel = false"
      @approve="(n: any) => { showSidePanel = false; promptAction(n, 'APROBADA'); }"
      @reject="(n: any) => { showSidePanel = false; promptAction(n, 'RECHAZADA'); }"
      @edit="(n: any) => { showSidePanel = false; openEditModal(n); }"
    />

    <!-- Action Dialog for Approve/Reject -->
    <ConfirmationDialog
      :show="showActionModal"
      :title="actionType === 'APROBADA' ? 'Aprobar Novedad' : 'Rechazar Novedad'"
      :confirmText="actionType === 'APROBADA' ? 'Confirmar Aprobación' : 'Rechazar Definitivamente'"
      :message="actionType === 'APROBADA' ? '¿Estás seguro que deseas aprobar esta novedad y registrarla en el sistema?' : 'Por favor, ingresa el motivo del rechazo. Este campo es obligatorio para rechazar.'"
      @confirm="confirmAction"
      @close="closeActionModal"
    >
      <template #default>
        <div class="mt-4">
          <label class="block text-sm font-bold text-text mb-1">Comentario / Motivo</label>
          <textarea
            v-model="actionComment"
            rows="3"
            class="w-full px-3 py-2 bg-surface border border-border rounded-lg text-text focus:outline-none focus:ring-2 focus:ring-primary/50"
            :placeholder="actionType === 'APROBADA' ? 'Opcional: Detalles adicionales...' : 'Obligatorio: Motivo del rechazo...'"
          ></textarea>
        </div>
      </template>
    </ConfirmationDialog>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import BaseDataList from '@/components/common/BaseDataList.vue';
import NovedadDialog from '../components/NovedadDialog.vue';
import NovedadContextDetailContent from '../components/NovedadContextDetailContent.vue';
import ObservadorCalendarView from '../components/ObservadorCalendarView.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import { novedadesService } from '../services/novedades.service';
import type { Novedad } from '../interfaces/novedad.interface';
import { toast } from 'vue-sonner';
import { TrashIcon, ChevronDownIcon, EditIcon, PlusIcon, PaperclipIcon } from '@/icons';
import { RefreshCcwIcon } from 'lucide-vue-next';
import { TIPO_CONTRATO } from '../constants/observador.constants';
import DatePicker from '@/components/common/DatePicker.vue';

const novedades = ref<Novedad[]>([]);
const isLoading = ref(true);
const searchQuery = ref('');

const filterContrato = ref('');
const filterOrigen = ref('');
const filterFechaInicio = ref<string | null>(null);
const filterFechaFin = ref<string | null>(null);

const origenesPermitidos = computed(() => {
  const set = new Set(novedades.value.map(n => n.origen || 'MANUAL'));
  return Array.from(set).sort();
});

const clearFilters = () => {
  searchQuery.value = '';
  filterContrato.value = '';
  filterOrigen.value = '';
  filterFechaInicio.value = null;
  filterFechaFin.value = null;
};

const showSidePanel = ref(false);
const sidePanelNovedad = ref<Novedad | null>(null);

const openSidePanel = (novedad: Novedad) => {
  sidePanelNovedad.value = novedad;
  showSidePanel.value = true;
};

const closeSidePanel = () => {
  showSidePanel.value = false;
  sidePanelNovedad.value = null;
};

const showModal = ref(false);
const selectedNovedad = ref<Novedad | null>(null);

const showConfirmDelete = ref(false);
const novedadToDelete = ref<Novedad | null>(null);

const activeTab = ref<'historial' | 'pendientes' | 'calendario'>('historial');
const pendientesCount = computed(() => novedades.value.filter(n => n.estadoAprobacion === 'PENDIENTE' && n.activo !== false).length);

const showActionModal = ref(false);
const actionType = ref<'APROBADA' | 'RECHAZADA'>('APROBADA');
const actionComment = ref('');
const novedadToAction = ref<Novedad | null>(null);

const sortKey = ref<string>('fechaInicio');
const sortOrder = ref<'asc' | 'desc'>('desc');

const handleSort = (key: string) => {
    if (sortKey.value === key) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    } else {
        sortKey.value = key;
        sortOrder.value = 'asc';
    }
};

const getSortIcon = () => ChevronDownIcon;

const formatDate = (isoStr: string) => {
  if (!isoStr) return '';
  const date = new Date(isoStr);
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
};



const filteredNovedades = computed(() => {
    let items = [...novedades.value];

    // Filter by Tab
    if (activeTab.value === 'pendientes') {
      items = items.filter(n => n.estadoAprobacion === 'PENDIENTE' && n.activo !== false);
    } else {
      items = items.filter(n => n.estadoAprobacion !== 'PENDIENTE' || n.activo === false);
    }

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        items = items.filter(n => {
            const obsNombre = `${n.observador?.apellido || ''} ${n.observador?.nombre || ''}`.toLowerCase();
            const motivo = (n.motivo || '').toLowerCase();
            const tipo = (n.tipoNovedad?.descripcion || '').toLowerCase();
            return obsNombre.includes(query) || motivo.includes(query) || tipo.includes(query);
        });
    }

    if (filterContrato.value) {
        items = items.filter(n => n.observador?.tipoContrato === filterContrato.value);
    }
    
    if (filterOrigen.value) {
        items = items.filter(n => (n.origen || 'MANUAL') === filterOrigen.value);
    }

    if (filterFechaInicio.value) {
        const start = new Date(filterFechaInicio.value).setHours(0,0,0,0);
        items = items.filter(n => new Date(n.fechaInicio).getTime() >= start);
    }

    if (filterFechaFin.value) {
        const end = new Date(filterFechaFin.value).setHours(23,59,59,999);
        items = items.filter(n => new Date(n.fechaInicio).getTime() <= end);
    }

    items.sort((a: any, b: any) => {
        let valA = a;
        let valB = b;
        
        if (sortKey.value === 'observador.apellido') {
          valA = a.observador?.apellido || '';
          valB = b.observador?.apellido || '';
        } else if (sortKey.value === 'tipoNovedad.descripcion') {
          valA = a.tipoNovedad?.descripcion || '';
          valB = b.tipoNovedad?.descripcion || '';
        } else {
          valA = a[sortKey.value];
          valB = b[sortKey.value];
        }

        if (typeof valA === 'string' && typeof valB === 'string') {
            return sortOrder.value === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA);
        }

        return sortOrder.value === 'asc' ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1);
    });

    return items;
});

const loadNovedades = async () => {
  isLoading.value = true;
  try {
    novedades.value = await novedadesService.getAll();
  } catch (error) {
    toast.error('Error al cargar novedades desde el servidor');
  } finally {
    isLoading.value = false;
  }
};

const openCreateModal = () => {
  selectedNovedad.value = null;
  showModal.value = true;
};

const openEditModal = (novedad: Novedad) => {
  selectedNovedad.value = novedad;
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  selectedNovedad.value = null;
};

const handleSave = async (data: any) => {
  try {
    if (selectedNovedad.value) {
      // Update
      await novedadesService.update(selectedNovedad.value.id, data);
      toast.success('Novedad actualizada exitosamente');
    } else {
      // Create
      await novedadesService.create(data);
      toast.success('Novedad creada exitosamente');
    }
    closeModal();
    await loadNovedades();
  } catch (error: any) {
    toast.error(error.response?.data?.message || 'Error al guardar la novedad');
  }
};

const deleteNovedad = (novedad: Novedad) => {
  novedadToDelete.value = novedad;
  showConfirmDelete.value = true;
};

const confirmDelete = async () => {
  if (!novedadToDelete.value) return;
  
  try {
    await novedadesService.delete(novedadToDelete.value.id);
    toast.success('Novedad eliminada correctamente');
    showConfirmDelete.value = false;
    novedadToDelete.value = null;
    await loadNovedades();
  } catch (error) {
    toast.error('Error al eliminar la novedad');
  }
};

const promptAction = (novedad: Novedad, type: 'APROBADA' | 'RECHAZADA') => {
  novedadToAction.value = novedad;
  actionType.value = type;
  actionComment.value = '';
  showActionModal.value = true;
};

const closeActionModal = () => {
  showActionModal.value = false;
  novedadToAction.value = null;
};

const confirmAction = async () => {
  if (!novedadToAction.value) return;
  
  if (actionType.value === 'RECHAZADA' && !actionComment.value.trim()) {
    toast.error('El motivo del rechazo es obligatorio');
    return;
  }

  try {
    await novedadesService.update(novedadToAction.value.id, {
      estadoAprobacion: actionType.value,
      comentarioMovimiento: actionComment.value
    });
    toast.success(`Novedad ${actionType.value.toLowerCase()} correctamente`);
    closeActionModal();
    await loadNovedades();
  } catch (error) {
    toast.error('Error al procesar la acción');
  }
};

onMounted(() => {
  loadNovedades();
});
</script>
