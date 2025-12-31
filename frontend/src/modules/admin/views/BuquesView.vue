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
          <th scope="row" class="px-6 py-4 font-bold text-gray-900 whitespace-nowrap dark:text-white">
            {{ buque.nombreBuque }}
          </th>
          <td class="px-6 py-4 font-mono font-bold text-brand-600 dark:text-brand-400">
            {{ buque.matricula }}
          </td>
          <td class="px-6 py-4 font-medium">
            {{ buque.tipoFlota?.nombre || '-' }}
          </td>
          <td class="px-6 py-4 text-gray-500">
            {{ buque.puertoBase?.nombre || '-' }}
          </td>
          <td class="px-6 py-4">
              <span :class="[
                  'px-2.5 py-1 rounded-full text-[11px] font-bold uppercase tracking-tight',
                  buque.activo ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400' : 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
              ]">
                  {{ buque.activo ? 'Activo' : 'Inactivo' }}
              </span>
          </td>
          <td class="px-6 py-4 text-right">
            <button @click="openEditModal(buque)" class="font-bold text-brand-600 dark:text-brand-400 hover:underline">Editar</button>
          </td>
        </template>

        <template #card-item="{ item: buque }">
            <div class="flex justify-between items-start mb-4">
                <div class="flex-1 min-w-0">
                    <div class="font-black text-gray-900 dark:text-white text-lg truncate leading-tight mb-1">{{ buque.nombreBuque }}</div>
                    <div class="text-xs text-brand-700 dark:text-brand-400 font-mono font-bold flex items-center gap-1">
                        <span class="text-gray-400 font-normal">Matrícula:</span>
                        {{ buque.matricula }}
                    </div>
                </div>
                <span
                    :class="[
                        'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-widest',
                        buque.activo
                            ? 'bg-green-100 text-green-800 dark:bg-green-800/30 dark:text-green-400'
                            : 'bg-red-100 text-red-800 dark:bg-red-800/30 dark:text-red-400'
                    ]"
                >
                    {{ buque.activo ? 'Activo' : 'Inactivo' }}
                </span>
            </div>

            <div class="grid grid-cols-2 gap-4 mb-4 p-3 bg-gray-50/50 dark:bg-gray-700/30 rounded-xl border border-gray-100 dark:border-gray-700/50">
                <div>
                    <div class="text-[10px] text-gray-400 uppercase font-black mb-1">Tipo de Flota</div>
                    <div class="text-xs text-gray-800 dark:text-gray-200 font-bold truncate">
                         {{ buque.tipoFlota?.nombre || '-' }}
                    </div>
                </div>
                <div>
                    <div class="text-[10px] text-gray-400 uppercase font-black mb-1">Puerto Base</div>
                    <div class="text-xs text-gray-800 dark:text-gray-200 font-bold truncate">
                         {{ buque.puertoBase?.nombre || '-' }}
                    </div>
                </div>
            </div>

            <div class="pt-3 border-t border-gray-100 dark:border-gray-700">
                <button 
                    @click="openEditModal(buque)" 
                    class="w-full py-2.5 text-sm font-bold text-brand-700 dark:text-brand-400 bg-brand-50 dark:bg-brand-400/10 rounded-lg hover:bg-brand-100 transition-colors flex items-center justify-center gap-2"
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
