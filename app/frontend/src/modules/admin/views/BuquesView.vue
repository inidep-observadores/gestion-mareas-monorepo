<template>
  <AdminLayout>
    <BaseDataList title="Gestión de Buques" description="Administra la flota de buques y sus especificaciones técnicas"
      :button-text="canEdit ? 'Nuevo Buque' : undefined" :items="filteredBuques" :is-loading="isLoading"
      v-model:search="searchQuery" search-placeholder="Buscar por nombre o matrícula..." @create="openCreateModal">
      
      <template #filters>
        <!-- Filtro por Calificación -->
        <div class="flex items-center gap-1.5 bg-surface-muted/60 dark:bg-gray-700/50 p-1.5 rounded-lg border border-border">
          <span class="text-xs font-bold text-text-muted px-1 flex items-center gap-1">
            <svg class="w-3.5 h-3.5 text-amber-400 fill-current" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
            </svg>
            Calificación:
          </span>
          <select
            v-model="filtroModoCalificacion"
            class="text-xs rounded-md border-border bg-surface text-text px-2 py-1 font-medium focus:ring-1 focus:ring-primary focus:border-primary"
          >
            <option value="todas">Todas</option>
            <option value="gte">≥ Mayor o igual que</option>
            <option value="lte">≤ Menor o igual que</option>
          </select>

          <select
            v-if="filtroModoCalificacion !== 'todas'"
            v-model.number="filtroLimiteCalificacion"
            class="text-xs rounded-md border-border bg-surface text-text px-2 py-1 font-bold focus:ring-1 focus:ring-primary focus:border-primary"
          >
            <option :value="0">0 estrellas</option>
            <option :value="1">1 estrella</option>
            <option :value="2">2 estrellas</option>
            <option :value="3">3 estrellas</option>
            <option :value="4">4 estrellas</option>
            <option :value="5">5 estrellas</option>
          </select>
        </div>

        <!-- Filtro Aptitud Femenina -->
        <button
          type="button"
          @click="filtroSoloMujeres = !filtroSoloMujeres"
          :class="[
            'flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold transition-all border shadow-xs',
            filtroSoloMujeres
              ? 'bg-secondary/15 border-secondary text-secondary'
              : 'bg-surface border-border text-text-muted hover:text-text hover:bg-surface-muted'
          ]"
        >
          <span class="w-2 h-2 rounded-full" :class="filtroSoloMujeres ? 'bg-secondary' : 'bg-text-muted/40'"></span>
          Apto mujeres
        </button>
      </template>

      <template #header-actions>
        <!-- Exportar DBF: Solo para Administradores -->
        <button 
          v-if="isAdmin"
          @click="exportDbf"
          :disabled="isExporting"
          class="flex items-center justify-center gap-2 px-4 py-2 bg-primary/10 border border-primary/20 text-primary rounded-lg hover:bg-primary/20 transition-all font-semibold text-sm disabled:opacity-50 shadow-sm"
        >
          <DownloadIcon class="w-4 h-4" :class="{ 'animate-bounce': isExporting }" />
          {{ isExporting ? 'Exportando...' : 'Exportar DBF' }}
        </button>

        <!-- Sincronizar: Disponible para Admin y Técnico -->
        <button 
          v-if="canEdit"
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
        <th scope="col" class="px-6 py-3 cursor-pointer group" @click="handleSort('calificacion')">
          <div class="flex items-center gap-2">
            Calificación
            <component :is="getSortIcon()" class="w-3.5 h-3.5 transition-all duration-200" :class="[
              sortKey === 'calificacion' ? 'opacity-100 text-primary' : 'opacity-0 group-hover:opacity-50',
              sortKey === 'calificacion' && sortOrder === 'asc' ? 'rotate-180' : ''
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
          <div class="flex items-center gap-2">
            <span>{{ buque.nombreBuque }}</span>
            <span
              v-if="buque.habitabilidadFemeninaApta"
              class="px-1.5 py-0.5 rounded text-[10px] font-bold bg-secondary/10 text-secondary border border-secondary/20"
              title="Apto para observadoras mujeres"
            >
              ♀ Apto
            </span>
          </div>
        </th>
        <td class="px-6 py-4 font-mono font-bold text-primary">
          {{ buque.matricula }}
        </td>
        <td class="px-6 py-4">
          <div class="flex items-center gap-1">
            <div class="flex items-center">
              <svg
                v-for="star in 5"
                :key="star"
                class="w-4 h-4"
                :class="star <= (buque.calificacion ?? 0) ? 'text-amber-400 fill-current' : 'text-gray-300 dark:text-gray-600 fill-current'"
                viewBox="0 0 20 20"
              >
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
              </svg>
            </div>
            <span class="text-xs font-bold text-text-muted ml-1 font-mono">({{ buque.calificacion ?? 0 }})</span>
          </div>
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
            <div class="font-black text-text text-lg truncate leading-tight mb-1 flex items-center gap-2">
              <span>{{ buque.nombreBuque }}</span>
              <span
                v-if="buque.habitabilidadFemeninaApta"
                class="px-1.5 py-0.5 rounded text-[10px] font-bold bg-secondary/10 text-secondary border border-secondary/20 shrink-0"
                title="Apto para observadoras mujeres"
              >
                ♀ Apto
              </span>
            </div>
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
            <div class="text-[10px] text-text-muted uppercase font-black mb-1">Calificación</div>
            <div class="flex items-center gap-1">
              <svg
                v-for="star in 5"
                :key="star"
                class="w-3.5 h-3.5"
                :class="star <= (buque.calificacion ?? 0) ? 'text-amber-400 fill-current' : 'text-gray-300 dark:text-gray-600 fill-current'"
                viewBox="0 0 20 20"
              >
                <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
              </svg>
              <span class="text-xs font-bold text-text ml-1">({{ buque.calificacion ?? 0 }})</span>
            </div>
          </div>
          <div>
            <div class="text-[10px] text-text-muted uppercase font-black mb-1">Tipo de Flota</div>
            <div class="text-xs text-text font-bold truncate">
              {{ buque.tipoFlota?.nombre || '-' }}
            </div>
          </div>
          <div class="col-span-2">
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

// Filtros de Calificación y Aptitud
const filtroModoCalificacion = ref<'todas' | 'gte' | 'lte'>('todas')
const filtroLimiteCalificacion = ref<number>(3)
const filtroSoloMujeres = ref(false)

const filteredBuques = computed(() => {
  let items = [...baseFilteredBuques.value]

  // Filtro por Calificación
  if (filtroModoCalificacion.value === 'gte') {
    items = items.filter(b => (b.calificacion ?? 0) >= filtroLimiteCalificacion.value)
  } else if (filtroModoCalificacion.value === 'lte') {
    items = items.filter(b => (b.calificacion ?? 0) <= filtroLimiteCalificacion.value)
  }

  // Filtro por Aptitud para Observadoras Mujeres
  if (filtroSoloMujeres.value) {
    items = items.filter(b => !!b.habitabilidadFemeninaApta)
  }

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
    } else if (sortKey.value === 'calificacion') {
      valA = a.calificacion ?? 0
      valB = b.calificacion ?? 0
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
