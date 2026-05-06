<template>
  <AdminLayout>
    <BaseDataList title="Gestión de Buques" description="Administra la flota de buques y sus especificaciones técnicas"
      :button-text="canEdit ? 'Nuevo Buque' : undefined" :items="filteredBuques" :is-loading="isLoading"
      v-model:search="searchQuery" search-placeholder="Buscar por nombre o matrícula..." @create="openCreateModal">
      
      <template #header-actions v-if="isAdmin">
        <button 
          @click="exportDbf"
          :disabled="isExporting"
          class="flex items-center justify-center gap-2 px-4 py-2 bg-primary/10 border border-primary/20 text-primary rounded-lg hover:bg-primary/20 transition-all font-semibold text-sm disabled:opacity-50 shadow-sm"
        >
          <DownloadIcon class="w-4 h-4" :class="{ 'animate-bounce': isExporting }" />
          {{ isExporting ? 'Exportando...' : 'Exportar DBF' }}
        </button>

        <button 
          @click="triggerVesselSync"
          :disabled="triggeringVessel"
          class="flex items-center justify-center gap-2 px-4 py-2 bg-secondary/10 border border-secondary/20 text-secondary rounded-lg hover:bg-secondary/20 transition-all font-semibold text-sm disabled:opacity-50 shadow-sm"
        >
          <RefreshIcon class="w-4 h-4" :class="{ 'animate-spin': triggeringVessel }" />
          {{ triggeringVessel ? 'Sincronizando...' : 'Sincronizar Buques' }}
        </button>
      </template>

      <template #table-header>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('nombreBuque')">
          <div class="flex items-center gap-2">
            Buque
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'nombreBuque' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'nombreBuque' && sortOrder === 'asc' ? 'rotate-180' : ''
            ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('matricula')">
          <div class="flex items-center gap-2">
            Matrícula
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'matricula' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'matricula' && sortOrder === 'asc' ? 'rotate-180' : ''
            ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('tipoFlota')">
          <div class="flex items-center gap-2">
            Tipo Flota
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'tipoFlota' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'tipoFlota' && sortOrder === 'asc' ? 'rotate-180' : ''
            ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('puertoBase')">
          <div class="flex items-center gap-2">
            Puerto Base
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'puertoBase' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'puertoBase' && sortOrder === 'asc' ? 'rotate-180' : ''
            ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('activo')">
          <div class="flex items-center gap-2">
            Estado
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'activo' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'activo' && sortOrder === 'asc' ? 'rotate-180' : ''
            ]" />
          </div>
        </th>
        <th scope="col" class="px-6 py-3 text-right">Acciones</th>
      </template>

      <template #table-row="{ item: buque }">
        <th scope="row" class="px-6 py-4 font-bold text-text whitespace-nowrap">
          {{ buque.nombreBuque }}
        </th>
        <td class="px-6 py-4 font-mono font-bold text-primary">
          {{ buque.matricula }}
        </td>
        <td class="px-6 py-4 font-medium">
          {{ buque.tipoFlota?.nombre || '-' }}
        </td>
        <td class="px-6 py-4 text-text-muted">
          {{ buque.puertoBase?.nombre || '-' }}
        </td>
        <td class="px-6 py-4">
          <span :class="[
            'px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-tight',
            buque.activo ? 'bg-success/10 text-success' : 'bg-error/10 text-error'
          ]">
            {{ buque.activo ? 'Activo' : 'Inactivo' }}
          </span>
        </td>
        <td class="px-6 py-4 text-right">
          <button @click="openEditModal(buque)" class="font-bold text-primary hover:underline">
            {{ canEdit ? 'Editar' : 'Ver Detalle' }}
          </button>
        </td>
      </template>

      <template #card-item="{ item: buque }">
        <div class="flex justify-between items-start mb-4">
          <div class="flex-1 min-w-0">
            <div class="font-black text-text text-lg truncate leading-tight mb-1">{{ buque.nombreBuque }}</div>
            <div class="text-xs text-primary font-mono font-bold flex items-center gap-1">
              <span class="text-text-muted font-normal">Matrícula:</span>
              {{ buque.matricula }}
            </div>
          </div>
          <span :class="[
            'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest',
            buque.activo
              ? 'bg-success/10 text-success'
              : 'bg-error/10 text-error'
          ]">
            {{ buque.activo ? 'Activo' : 'Inactivo' }}
          </span>
        </div>

        <div class="grid grid-cols-2 gap-4 mb-4 p-3 bg-surface-muted rounded-xl border border-border">
          <div>
            <div class="text-[10px] text-text-muted uppercase font-black mb-1">Tipo de Flota</div>
            <div class="text-xs text-text font-bold truncate">
              {{ buque.tipoFlota?.nombre || '-' }}
            </div>
          </div>
          <div>
            <div class="text-[10px] text-text-muted uppercase font-black mb-1">Puerto Base</div>
            <div class="text-xs text-text font-bold truncate">
              {{ buque.puertoBase?.nombre || '-' }}
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-border">
          <button @click="openEditModal(buque)"
            class="w-full py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2">
            <component :is="canEdit ? EditIcon : SearchIcon" class="w-4 h-4" />
            {{ canEdit ? 'Editar Especificaciones' : 'Ver Especificaciones' }}
          </button>
        </div>
      </template>
    </BaseDataList>

    <!-- Buque Modal -->
    <BuqueDialog :show="isModalOpen" :buque="currentBuque" :is-saving="isSaving" :tipos-flota="tiposFlota"
      :puertos="puertos" :pesquerias="pesquerias" :artesPesca="artesPesca" :read-only="!canEdit" @close="closeModal"
      @save="handleSave" />
  </AdminLayout>
</template>

<script setup lang="ts">
import { onMounted, computed, ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BuqueDialog from '../components/BuqueDialog.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import { useBuques } from '../composables/useBuques'
import { EditIcon, SearchIcon, ChevronDownIcon, RefreshIcon, DownloadIcon } from '@/icons'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'
import { jobQueueService } from '../services/JobQueueService'
import { toast } from 'vue-sonner'

const authStore = useAuthStore()
const canEdit = computed(() => {
  const roles = authStore.user?.roles || []
  return roles.includes(ValidRoles.admin) || roles.includes(ValidRoles.tecnico)
})


const isAdmin = computed(() => {
  const roles = authStore.user?.roles || []
  return roles.includes(ValidRoles.admin)
})

const triggeringVessel = ref(false)

const {
  isLoading,
  isSaving,
  isExporting,
  searchQuery,
  isModalOpen,
  currentBuque,
  filteredBuques: baseFilteredBuques,
  tiposFlota,
  puertos,
  pesquerias,
  artesPesca,
  fetchBuques,
  fetchCatalogs,
  openCreateModal,
  openEditModal,
  closeModal,
  handleSave,
  exportDbf
} = useBuques()

const triggerVesselSync = async () => {
  triggeringVessel.value = true
  try {
    await jobQueueService.triggerJob('VESSEL_SYNC')
    toast.success('Sincronización de buques iniciada correctamente')
    // Refrescar lista después de un momento
    setTimeout(() => fetchBuques(), 5000)
  } catch (error) {
    toast.error('Error al iniciar sincronización de buques')
    console.error(error)
  } finally {
    triggeringVessel.value = false
  }
}

// Sorting Logic
const sortKey = ref<string>('nombreBuque')
const sortOrder = ref<'asc' | 'desc'>('asc')

const handleSort = (key: string) => {
  if (sortKey.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortOrder.value = 'asc'
  }
}

const getSortIcon = () => ChevronDownIcon

const filteredBuques = computed(() => {
  const items = [...baseFilteredBuques.value]

  items.sort((a: any, b: any) => {
    let valA = a[sortKey.value]
    let valB = b[sortKey.value]

    // Handle nested objects
    if (sortKey.value === 'tipoFlota') {
      valA = a.tipoFlota?.nombre || ''
      valB = b.tipoFlota?.nombre || ''
    } else if (sortKey.value === 'puertoBase') {
      valA = a.puertoBase?.nombre || ''
      valB = b.puertoBase?.nombre || ''
    }

    if (typeof valA === 'string') {
      return sortOrder.value === 'asc'
        ? valA.localeCompare(valB)
        : valB.localeCompare(valA)
    }

    return sortOrder.value === 'asc' ? (valA > valB ? 1 : -1) : (valA < valB ? 1 : -1)
  })

  return items
})

onMounted(async () => {
  // Parallel fetch for better performance
  await Promise.all([
    fetchBuques(),
    fetchCatalogs()
  ])
})
</script>
