<template>
  <AdminDashboardLayout>
      <BaseDataList
        title="Gestión de Buques"
        description="Administra la flota de buques y sus especificaciones técnicas"
        button-text="Nuevo Buque"
        :items="filteredBuques"
        :is-loading="isLoading"
        v-model:search="searchQuery"
        search-placeholder="Buscar por nombre o matrícula..."
        @create="openCreateModal"
      >
        <template #table-header>
          <th scope="col" class="px-6 py-3">Buque</th>
          <th scope="col" class="px-6 py-3">Matrícula</th>
          <th scope="col" class="px-6 py-3">Tipo Flota</th>
          <th scope="col" class="px-6 py-3">Puerto Base</th>
          <th scope="col" class="px-6 py-3">Estado</th>
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
            <button @click="openEditModal(buque)" class="font-bold text-primary hover:underline">Editar</button>
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
                <span
                    :class="[
                        'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest',
                        buque.activo
                            ? 'bg-success/10 text-success'
                            : 'bg-error/10 text-error'
                    ]"
                >
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
                <button 
                    @click="openEditModal(buque)" 
                    class="w-full py-2.5 text-sm font-bold text-primary bg-primary/10 rounded-lg hover:bg-primary/20 transition-colors flex items-center justify-center gap-2"
                >
                    <EditIcon class="w-4 h-4" />
                    Editar Especificaciones
                </button>
            </div>
        </template>
      </BaseDataList>

    <!-- Buque Modal -->
    <BuqueDialog
      :show="isModalOpen"
      :buque="currentBuque"
      :is-saving="isSaving"
      :tipos-flota="tiposFlota"
      :puertos="puertos"
      :pesquerias="pesquerias"
      :artesPesca="artesPesca"
      @close="closeModal"
      @save="handleSave"
    />
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import BuqueDialog from '../components/BuqueDialog.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import { useBuques } from '../composables/useBuques'
import { EditIcon } from '@/icons'

const {
    isLoading,
    isSaving,
    searchQuery,
    isModalOpen,
    currentBuque,
    filteredBuques,
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
} = useBuques()

onMounted(async () => {
    // Parallel fetch for better performance
    await Promise.all([
        fetchBuques(),
        fetchCatalogs()
    ])
})
</script>
