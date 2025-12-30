<template>
  <AdminDashboardLayout>
    <div class="flex flex-col gap-6">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestión de Buques</h1>
          <p class="text-gray-500 dark:text-gray-400">Administra la flota de buques y sus especificaciones</p>
        </div>
        <div class="flex gap-2">
          <button
            @click="openCreateModal"
            class="flex items-center justify-center gap-2 rounded-lg bg-brand-500 px-4 py-2.5 text-sm font-medium text-white shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 transition-colors"
          >
            Nuevo Buque
          </button>
        </div>
      </div>

      <!-- Filters & Search -->
      <div class="p-6 bg-white border border-gray-200 rounded-xl dark:bg-gray-800 dark:border-gray-700">
        <div class="flex sm:flex-row flex-col items-center justify-between gap-4 mb-6">
            <div class="relative w-full max-w-sm">
                 <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
                    <SearchIcon class="w-5 h-5 text-gray-400" />
                </div>
                <input 
                    v-model="searchQuery" 
                    type="text" 
                    placeholder="Buscar por nombre o matrícula..." 
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent py-2 pl-10 pr-3 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                />
            </div>
        </div>

        <!-- Table -->
        <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
          <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th scope="col" class="px-6 py-3">Buque</th>
                <th scope="col" class="px-6 py-3">Matrícula</th>
                <th scope="col" class="px-6 py-3">Tipo Flota</th>
                <th scope="col" class="px-6 py-3">Puerto Base</th>
                <th scope="col" class="px-6 py-3">Estado</th>
                <th scope="col" class="px-6 py-3 text-right">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="isLoading">
                  <td colspan="6" class="px-6 py-4 text-center">Cargando buques...</td>
              </tr>
              <tr v-else-if="filteredBuques.length === 0">
                  <td colspan="6" class="px-6 py-4 text-center text-gray-400">No se encontraron buques</td>
              </tr>
              <tr 
                v-for="buque in filteredBuques" 
                :key="buque.id"
                class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700/50"
              >
                <th scope="row" class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                  {{ buque.nombreBuque }}
                </th>
                <td class="px-6 py-4">
                  {{ buque.matricula }}
                </td>
                <td class="px-6 py-4">
                  {{ buque.tipoFlota?.nombre || '-' }}
                </td>
                <td class="px-6 py-4">
                  {{ buque.puertoBase?.nombre || '-' }}
                </td>
                <td class="px-6 py-4">
                    <span :class="[
                        'px-2.5 py-0.5 rounded-full text-xs font-medium',
                        buque.activo ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300' : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
                    ]">
                        {{ buque.activo ? 'Activo' : 'Inactivo' }}
                    </span>
                </td>
                <td class="px-6 py-4 text-right">
                  <button @click="openEditModal(buque)" class="font-medium text-brand-600 dark:text-brand-500 hover:underline">Editar</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

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
import { useBuques } from '../composables/useBuques'
import { SearchIcon } from '@/icons'

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
