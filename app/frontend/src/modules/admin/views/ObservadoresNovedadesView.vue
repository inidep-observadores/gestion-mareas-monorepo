<template>
  <AdminLayout>
    <BackButton routeName="SistemaObservadores" label="Regresar al Panel" />
    <BaseDataList 
      title="Gestión de Novedades" 
      description="Administración de licencias, francos compensatorios y otras novedades de los observadores."
      button-text="Nueva Novedad" 
      :items="filteredNovedades"
      :is-loading="isLoading" 
      v-model:search="searchQuery" 
      search-placeholder="Buscar novedad por observador o motivo..."
      @create="openCreateModal">
      
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
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('estadoDisponibilidad')">
          <div class="flex items-center gap-2">
              Tipo
              <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
                  sortKey === 'estadoDisponibilidad' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
                  sortKey === 'estadoDisponibilidad' && sortOrder === 'asc' ? 'rotate-180' : ''
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
        <td class="px-6 py-4 font-medium text-text">
          {{ novedad.observador?.apellido }}, {{ novedad.observador?.nombre }}
          <div class="text-[10px] text-text-muted mt-0.5">{{ novedad.observador?.codigoInterno }}</div>
        </td>
        <td class="px-6 py-4">
          <span class="bg-info/10 text-info text-[11px] font-bold px-2 py-0.5 rounded-full border border-info/20 uppercase tracking-tighter">
            {{ formatDisponibilidad(novedad.estadoDisponibilidad) }}
          </span>
        </td>
        <td class="px-6 py-4 font-mono font-bold text-text whitespace-nowrap">
          {{ formatDate(novedad.fechaInicio) }}
        </td>
        <td class="px-6 py-4 font-mono font-bold text-text whitespace-nowrap">
          {{ novedad.fechaFin ? formatDate(novedad.fechaFin) : '-' }}
        </td>
        <td class="px-6 py-4 text-right">
          <div class="flex items-center justify-end gap-3">
            <button @click="openEditModal(novedad)" class="font-bold text-primary hover:underline">
                Editar
            </button>
            <button @click="deleteNovedad(novedad)" class="font-bold text-error hover:underline" title="Eliminar">
              <TrashIcon class="w-4 h-4" />
            </button>
          </div>
        </td>
      </template>

      <template #card-item="{ item: novedad }">
        <div class="flex items-start gap-4 mb-4">
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1.5">
              <span class="text-[10px] font-black bg-info/10 text-info px-2 py-0.5 rounded-md uppercase">
                {{ formatDisponibilidad(novedad.estadoDisponibilidad) }}
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

        <div class="pt-3 border-t border-border flex gap-2">
          <button @click="openEditModal(novedad)"
              class="flex-1 py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
              <EditIcon class="w-4 h-4" />
              Editar
          </button>
          <button @click="deleteNovedad(novedad)"
              class="px-4 py-2.5 text-sm font-bold text-error bg-error/10 rounded-lg hover:bg-error/20 transition-colors flex items-center justify-center">
              <TrashIcon class="w-4 h-4" />
          </button>
        </div>
      </template>
    </BaseDataList>

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
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import BaseDataList from '@/components/common/BaseDataList.vue';
import NovedadDialog from '../components/NovedadDialog.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import { novedadesService } from '../services/novedades.service';
import type { Novedad } from '../interfaces/novedad.interface';
import { toast } from 'vue-sonner';
import { TrashIcon, ChevronDownIcon, EditIcon } from '@/icons';

const novedades = ref<Novedad[]>([]);
const isLoading = ref(true);
const searchQuery = ref('');

const showModal = ref(false);
const selectedNovedad = ref<Novedad | null>(null);

const showConfirmDelete = ref(false);
const novedadToDelete = ref<Novedad | null>(null);

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

const formatDisponibilidad = (codigo: string) => {
  const map: Record<string, string> = {
    'LICEN': 'Licencia',
    'FC': 'Franco Compensatorio',
    'RP': 'Razones Particulares',
    'ENFERMEDAD': 'Enfermedad',
    'MATERNIDAD': 'Maternidad',
    'NACIMIENTO': 'Nacimiento',
    'FALLECIMIENTO': 'Fallecimiento',
    'EXAMEN': 'Examen',
    'DONACION_SANGRE': 'Donación de Sangre',
    'VIAJE_INICIO': 'Aviso de Viaje (Inicio)',
    'VIAJE_FIN': 'Aviso de Viaje (Fin)'
  };
  return map[codigo] || codigo;
};

const filteredNovedades = computed(() => {
    let items = [...novedades.value];

    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        items = items.filter(n => {
            const obsNombre = `${n.observador?.apellido || ''} ${n.observador?.nombre || ''}`.toLowerCase();
            const motivo = (n.motivo || '').toLowerCase();
            const tipo = formatDisponibilidad(n.estadoDisponibilidad).toLowerCase();
            return obsNombre.includes(query) || motivo.includes(query) || tipo.includes(query);
        });
    }

    items.sort((a: any, b: any) => {
        let valA = a;
        let valB = b;
        
        if (sortKey.value === 'observador.apellido') {
          valA = a.observador?.apellido || '';
          valB = b.observador?.apellido || '';
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

onMounted(() => {
  loadNovedades();
});
</script>
