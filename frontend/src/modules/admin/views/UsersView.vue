<template>
  <AdminDashboardLayout>
      <BaseDataList
        title="Gestión de Usuarios"
        description="Administra los accesos y roles de los usuarios del sistema"
        button-text="Nuevo Usuario"
        :items="filteredUsers"
        :is-loading="isLoading"
        v-model:search="searchQuery"
        search-placeholder="Buscar usuarios..."
        @create="openCreateModal"
      >
        <template #table-header>
          <th scope="col" class="px-6 py-3">Nombre</th>
          <th scope="col" class="px-6 py-3">Roles</th>
          <th scope="col" class="px-6 py-3">Estado</th>
          <th scope="col" class="px-6 py-3">Acciones</th>
        </template>

        <template #table-row="{ item: user }">
          <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
              <div class="flex items-center gap-3">
                   <img :src="getFullImageUrl(user.avatarUrl)" class="w-8 h-8 rounded-full object-cover" alt="Avatar">
                   <div>
                      <div class="font-semibold">{{ user.fullName }}</div>
                      <div class="text-xs text-gray-500">{{ user.email }}</div>
                   </div>
              </div>
          </td>
          <td class="px-6 py-4">
              <div class="flex gap-1 flex-wrap">
                  <span v-for="role in user.roles" :key="role" class="bg-blue-100 text-blue-800 text-[11px] font-medium px-2 py-0.5 rounded dark:bg-blue-900/30 dark:text-blue-300 border border-blue-200 dark:border-blue-800">
                      {{ ROLE_LABELS[role] || role }}
                  </span>
              </div>
          </td>
          <td class="px-6 py-4">
            <span
              :class="[
                  'text-xs font-bold px-2.5 py-1 rounded-full uppercase tracking-tight',
                  user.isActive
                      ? 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400'
                      : 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400'
              ]"
            >
              {{ user.isActive ? 'Activo' : 'Inactivo' }}
            </span>
          </td>
          <td class="px-6 py-4">
            <div class="flex gap-3">
                <button @click="openEditModal(user)" class="font-bold text-blue-600 dark:text-blue-400 hover:underline">Editar</button>
                <button
                    @click="handleToggleStatus(user)"
                    :class="['font-bold hover:underline', user.isActive ? 'text-red-600 dark:text-red-400' : 'text-green-600 dark:text-green-400']"
                >
                    {{ user.isActive ? 'Desactivar' : 'Activar' }}
                </button>
            </div>
          </td>
        </template>

        <template #card-item="{ item: user }">
            <div class="flex items-center gap-4 mb-4">
                <img :src="getFullImageUrl(user.avatarUrl)" class="w-12 h-12 rounded-full object-cover shadow-sm" alt="Avatar">
                <div class="flex-1 min-w-0">
                    <div class="font-extrabold text-gray-900 dark:text-white truncate">{{ user.fullName }}</div>
                    <div class="text-sm text-gray-500 truncate">{{ user.email }}</div>
                </div>
                <span
                    :class="[
                        'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider',
                        user.isActive
                            ? 'bg-green-100 text-green-800 dark:bg-green-800/30 dark:text-green-400'
                            : 'bg-red-100 text-red-800 dark:bg-red-800/30 dark:text-red-400'
                    ]"
                >
                    {{ user.isActive ? 'Activo' : 'Inactivo' }}
                </span>
            </div>

            <div class="mb-4">
                <div class="text-[10px] text-gray-400 uppercase font-bold mb-1.5 tracking-tight">Roles Asignados</div>
                <div class="flex gap-1.5 flex-wrap">
                    <span v-for="role in user.roles" :key="role" class="bg-gray-100 text-gray-700 text-[11px] font-semibold px-2 py-0.5 rounded dark:bg-gray-700 dark:text-gray-300 border border-transparent dark:border-gray-600">
                        {{ ROLE_LABELS[role] || role }}
                    </span>
                </div>
            </div>

            <div class="flex gap-2 pt-3 border-t border-gray-100 dark:border-gray-700">
                <button 
                    @click="openEditModal(user)" 
                    class="flex-1 py-2 text-sm font-bold text-blue-700 dark:text-blue-400 bg-blue-50 dark:bg-blue-400/10 rounded-lg hover:bg-blue-100 transition-colors flex items-center justify-center gap-2"
                >
                    <EditIcon class="w-4 h-4" />
                    Editar
                </button>
                <button 
                    @click="handleToggleStatus(user)" 
                    :class="[
                        'flex-1 py-2 text-sm font-bold rounded-lg transition-colors',
                        user.isActive 
                            ? 'text-red-700 dark:text-red-400 bg-red-50 dark:bg-red-400/10 hover:bg-red-100' 
                            : 'text-green-700 dark:text-green-400 bg-green-50 dark:bg-green-400/10 hover:bg-green-100'
                    ]"
                >
                    {{ user.isActive ? 'Desactivar' : 'Activar' }}
                </button>
            </div>
        </template>
      </BaseDataList>

    <UserDialog
      :show="showModal"
      :user="selectedUser"
      :is-saving="isSaving"
      @close="closeModal"
      @save="handleSave"
    />
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import { EditIcon } from '@/icons';
import UserDialog from '../components/UserDialog.vue'
import BaseDataList from '@/components/common/BaseDataList.vue'
import { useUsers } from '../composables/useUsers'
import { ROLE_LABELS } from '../constants/roles.constants'
import { getFullImageUrl } from '@/helpers/image.helper';

const {
    isLoading,
    searchQuery,
    showModal,
    selectedUser,
    isSaving,
    filteredUsers,
    fetchUsers,
    openCreateModal,
    openEditModal,
    closeModal,
    handleSave,
    handleToggleStatus
} = useUsers()

onMounted(() => {
    fetchUsers()
})
</script>
