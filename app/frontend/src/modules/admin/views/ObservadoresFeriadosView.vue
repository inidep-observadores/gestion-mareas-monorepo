<template>
  <AdminLayout>
    <BaseDataList 
      title="Feriados Nacionales" 
      :description="`Administración de feriados y días no laborables para el año operativo ${configStore.selectedYear}`"
      button-text="Nuevo Feriado" 
      :items="filteredFeriados"
      :is-loading="isLoading" 
      v-model:search="searchQuery" 
      search-placeholder="Buscar feriado por nombre o tipo..."
      @create="openCreateModal">
      
      <template #header-actions>
        <button 
          @click="sincronizarFeriados" 
          :disabled="isSyncing"
          class="h-10 px-4 inline-flex items-center justify-center gap-2 text-sm font-bold tracking-widest uppercase transition-all rounded-lg bg-surface border border-border text-primary hover:bg-primary/5 active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed"
        >
          <span v-if="isSyncing" class="w-4 h-4 border-2 border-primary border-t-transparent rounded-full animate-spin"></span>
          Sincronizar API
        </button>
      </template>

      <template #table-header>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('fecha')">
          <div class="flex items-center gap-2">
              Fecha
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'fecha' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'fecha' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('nombre')">
          <div class="flex items-center gap-2">
              Nombre
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'nombre' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'nombre' && sortOrder === 'asc' ? 'rotate-180' : ''
              ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('tipo')">
          <div class="flex items-center gap-2">
              Tipo
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'tipo' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'tipo' && sortOrder === 'asc' ? 'rotate-180' : ''
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
        <th scope="col" class="px-6 py-3 text-right">Acciones</th>
      </template>

      <template #table-row="{ item: feriado }">
        <td class="px-6 py-4 font-mono font-bold text-text whitespace-nowrap">
          {{ formatDate(feriado.fecha) }}
        </td>
        <td class="px-6 py-4 font-medium text-text">
          {{ feriado.nombre }}
        </td>
        <td class="px-6 py-4">
          <span class="bg-info/10 text-info text-[11px] font-bold px-2 py-0.5 rounded-full border border-info/20 uppercase tracking-tighter">
            {{ feriado.tipo }}
          </span>
        </td>
        <td class="px-6 py-4">
          <span :class="[
            'text-[10px] font-bold px-2 py-0.5 rounded-full w-fit uppercase tracking-wider border',
            feriado.origen === 'API' ? 'bg-primary/10 text-primary border-primary/20' : 'bg-warning/10 text-warning border-warning/20'
          ]">
            {{ feriado.origen }}
          </span>
        </td>
        <td class="px-6 py-4 text-right">
          <div class="flex items-center justify-end gap-3">
            <button @click="openEditModal(feriado)" class="font-bold text-primary hover:underline">
                Editar
            </button>
            <button @click="deleteFeriado(feriado.fecha)" class="font-bold text-error hover:underline" title="Eliminar">
              <TrashIcon class="w-4 h-4" />
            </button>
          </div>
        </td>
      </template>

      <template #card-item="{ item: feriado }">
        <div class="flex items-start gap-4 mb-4">
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1.5">
              <span class="text-[10px] font-black bg-info/10 text-info px-2 py-0.5 rounded-md uppercase">
                {{ formatDate(feriado.fecha) }}
              </span>
              <span :class="[
                  'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest',
                  feriado.origen === 'API' ? 'bg-primary/10 text-primary' : 'bg-warning/10 text-warning'
              ]">
                  {{ feriado.origen }}
              </span>
            </div>
            <div class="font-extrabold text-text text-base truncate">{{ feriado.nombre }}</div>
          </div>
        </div>

        <div class="grid grid-cols-1 gap-3 mb-4 p-3 bg-surface-muted rounded-xl border border-border">
          <div>
            <div class="text-[10px] text-text-muted uppercase font-black mb-1">Tipo</div>
            <div class="text-xs font-bold text-text uppercase tracking-tight">
                {{ feriado.tipo }}
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-border flex gap-2">
          <button @click="openEditModal(feriado)"
              class="flex-1 py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
              <EditIcon class="w-4 h-4" />
              Editar
          </button>
          <button @click="deleteFeriado(feriado.fecha)"
              class="px-4 py-2.5 text-sm font-bold text-error bg-error/10 rounded-lg hover:bg-error/20 transition-colors flex items-center justify-center">
              <TrashIcon class="w-4 h-4" />
          </button>
        </div>
      </template>
    </BaseDataList>

    <FeriadoDialog 
      :show="showModal" 
      :feriado="selectedFeriado" 
      :is-saving="isSaving"
      @close="closeModal" 
      @save="handleSave" 
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BaseDataList from '@/components/common/BaseDataList.vue';
import FeriadoDialog from '../components/FeriadoDialog.vue';
import { useConfigStore } from '@/modules/shared/stores/config.store';
import feriadosApi from '../services/feriados.service';
import type { Feriado } from '../interfaces/feriados.interface';
import { toast } from 'vue-sonner';
import { TrashIcon, ChevronDownIcon, EditIcon } from '@/icons';

const configStore = useConfigStore();
const feriados = ref<Feriado[]>([]);
const isSyncing = ref(false);
const isLoading = ref(true);
const searchQuery = ref('');

const showModal = ref(false);
const selectedFeriado = ref<Feriado | null>(null);
const isSaving = ref(false);

const sortKey = ref<string>('fecha');
const sortOrder = ref<'asc' | 'desc'>('asc');

const handleSort = (key: string) => {
    if (sortKey.value === key) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    } else {
        sortKey.value = key;
        sortOrder.value = 'asc';
    }
};

const getSortIcon = () => ChevronDownIcon;

const filteredFeriados = computed(() => {
    let items = [...feriados.value];

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        items = items.filter(f => 
            f.nombre.toLowerCase().includes(query) || 
            f.tipo.toLowerCase().includes(query)
        );
    }

    items.sort((a: any, b: any) => {
        const valA = a[sortKey.value];
        const valB = b[sortKey.value];

        if (typeof valA === 'string') {
            return sortOrder.value === 'asc'
                ? valA.localeCompare(valB)
                : valB.localeCompare(valA);
        }

        return sortOrder.value === 'asc' ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1);
    });

    return items;
});

const loadFeriados = async () => {
  isLoading.value = true;
  try {
    feriados.value = await feriadosApi.getFeriados(configStore.selectedYear);
  } catch (error) {
    toast.error('Error al cargar feriados desde el servidor');
  } finally {
    isLoading.value = false;
  }
};

const openCreateModal = () => {
  selectedFeriado.value = null;
  showModal.value = true;
};

const openEditModal = (feriado: Feriado) => {
  selectedFeriado.value = feriado;
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  selectedFeriado.value = null;
};

const handleSave = async (data: any) => {
  isSaving.value = true;
  try {
    if (selectedFeriado.value) {
      // Update
      await feriadosApi.updateFeriado(selectedFeriado.value.fecha, data);
      toast.success('Feriado actualizado exitosamente');
    } else {
      // Create
      await feriadosApi.createFeriado(data);
      toast.success('Feriado creado exitosamente');
    }
    closeModal();
    await loadFeriados();
  } catch (error: any) {
    toast.error(error.response?.data?.message || 'Error al guardar el feriado');
  } finally {
    isSaving.value = false;
  }
};

const sincronizarFeriados = async () => {
  if (isSyncing.value) return;
  isSyncing.value = true;
  isLoading.value = true;
  try {
    const res = await feriadosApi.sincronizarConApi(configStore.selectedYear);
    toast.success(`Se sincronizaron ${res.count} feriados con éxito`);
    await loadFeriados();
  } catch (error) {
    toast.error('Error al sincronizar con la API de ArgentinaDatos');
    isLoading.value = false;
  } finally {
    isSyncing.value = false;
  }
};

const deleteFeriado = async (fecha: string) => {
  if (!confirm('¿Seguro que desea eliminar este feriado de la base de datos?')) return;
  try {
    await feriadosApi.deleteFeriado(fecha);
    toast.success('Feriado eliminado exitosamente');
    await loadFeriados();
  } catch (error) {
    toast.error('Ocurrió un error al intentar eliminar el feriado');
  }
};

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleDateString('es-AR', { timeZone: 'UTC' });
};

watch(() => configStore.selectedYear, () => {
  loadFeriados();
});

onMounted(() => {
  loadFeriados();
});
</script>
