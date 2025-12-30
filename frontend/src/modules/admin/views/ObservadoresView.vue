<template>
  <AdminDashboardLayout>
    <div class="flex flex-col gap-6">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestión de Observadores</h1>
          <p class="text-gray-500 dark:text-gray-400">Administra el personal de observación y técnicos</p>
        </div>
        <div class="flex gap-2">
          <button
            @click="openCreateModal"
            class="flex items-center justify-center gap-2 rounded-lg bg-brand-500 px-4 py-2.5 text-sm font-medium text-white shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 transition-colors"
          >
            Nuevo Observador
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
                    placeholder="Buscar observadores..." 
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent py-2 pl-10 pr-3 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                />
            </div>
        </div>

        <!-- Table -->
        <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
          <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th scope="col" class="px-6 py-3">Código</th>
                <th scope="col" class="px-6 py-3">Nombre</th>
                <th scope="col" class="px-6 py-3">Tipo</th>
                <th scope="col" class="px-6 py-3">Estado</th>
                <th scope="col" class="px-6 py-3">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="isLoading">
                  <td colspan="5" class="px-6 py-4 text-center">Cargando observadores...</td>
              </tr>
              <tr v-else-if="filteredObservadores.length === 0">
                  <td colspan="5" class="px-6 py-4 text-center">No se encontraron observadores.</td>
              </tr>
              <tr v-for="obs in filteredObservadores" :key="obs.id" class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <td class="px-6 py-4 font-mono font-bold text-blue-600 dark:text-blue-400">
                    {{ obs.codigoInterno }}
                </td>
                <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                    <div class="flex items-center gap-3">
                         <img :src="getFullImageUrl(obs.fotoUrl)" class="w-8 h-8 rounded-full object-cover" alt="Foto">
                         <div>
                            <div class="font-semibold">{{ obs.apellido }}, {{ obs.nombre }}</div>
                            <div class="text-xs text-gray-500">{{ TIPO_CONTRATO_LABELS[obs.tipoContrato] }}</div>
                         </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <span class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300 border border-blue-400">
                        {{ TIPO_OBSERVADOR_LABELS[obs.tipoObservador] }}
                    </span>
                </td>
                <td class="px-6 py-4">
                  <div class="flex flex-col gap-1">
                      <span :class="[
                          'text-xs font-medium px-2.5 py-0.5 rounded w-fit',
                          obs.activo ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300' : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
                      ]">
                        {{ obs.activo ? 'Activo' : 'Inactivo' }}
                      </span>
                      <span v-if="obs.activo" :class="[
                          'text-[10px] font-medium px-2 py-0.2 rounded w-fit',
                          obs.disponible ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300' : 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300'
                      ]">
                        {{ obs.disponible ? 'Disponible' : 'No Disponible' }}
                      </span>
                  </div>
                </td>
                <td class="px-6 py-4 flex gap-3">
                  <button @click="openEditModal(obs)" class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Editar</button>
                  <button @click="handleDelete(obs.id)" class="font-medium text-red-600 dark:text-red-500 hover:underline">Eliminar</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <ObservadorDialog
      :show="showModal"
      :observador="selectedObservador"
      :is-saving="isSaving"
      @close="closeModal"
      @save="handleSave"
    />
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import { SearchIcon } from '@/icons';
import ObservadorDialog from '../components/ObservadorDialog.vue'
import { useObservadores } from '../composables/useObservadores'
import { TIPO_OBSERVADOR_LABELS, TIPO_CONTRATO_LABELS } from '../constants/observador.constants'
import { getFullImageUrl } from '@/helpers/image.helper'

const {
    isLoading,
    searchQuery,
    showModal,
    selectedObservador,
    isSaving,
    filteredObservadores,
    fetchObservadores,
    openCreateModal,
    openEditModal,
    closeModal,
    handleSave,
    handleDelete
} = useObservadores()

onMounted(() => {
    fetchObservadores()
})
</script>
