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
          <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap text-text-muted">
              <div class="flex items-center gap-3">
                   <img :src="getFullImageUrl(user.avatarUrl)" class="w-8 h-8 rounded-full object-cover" alt="Avatar">
                   <div>
                      <div class="font-semibold">{{ user.fullName }}</div>
                      <div class="text-xs text-text-muted">{{ user.email }}</div>
                   </div>
              </div>
          </td>
          <td class="px-6 py-4">
              <div class="flex gap-1 flex-wrap">
                  <span v-for="role in user.roles" :key="role" class="bg-primary/10 text-primary border-primary/20">
                      {{ ROLE_LABELS[role] || role }}
                  </span>
              </div>
          </td>
          <td class="px-6 py-4">
            <span
              :class="[
                  'text-xs font-bold px-2.5 py-1 rounded-full uppercase tracking-tight',
                  user.isActive
                      ? 'bg-success/10 text-success border border-success/20'
                      : 'bg-error/10 text-error border border-error/20'
              ]"
            >
              {{ user.isActive ? 'Activo' : 'Inactivo' }}
            </span>
          </td>
          <td class="px-6 py-4">
            <div class="flex gap-3">
                <button @click="openEditModal(user)" class="font-bold text-primary hover:text-primary-hover hover:underline">Editar</button>
                <button
                    @click="handleToggleStatus(user)"
                    :class="['font-bold hover:underline', user.isActive ? 'text-error hover:text-error-hover' : 'text-success hover:text-success-hover']"
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
                    <div class="font-extrabold text-gray-900 text-text-muted truncate">{{ user.fullName }}</div>
                    <div class="text-sm text-text-muted truncate">{{ user.email }}</div>
                </div>
                <span
                    :class="[
                        'text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider',
                        user.isActive
                            ? 'bg-success/10 text-success dark:bg-success/30 dark:text-success'
                            : 'bg-error/10 text-error dark:bg-error/30 dark:text-error'
                    ]"
                >
                    {{ user.isActive ? 'Activo' : 'Inactivo' }}
                </span>
            </div>

            <div class="mb-4">
                <div class="text-[10px] text-gray-400 uppercase font-bold mb-1.5 tracking-tight">Roles Asignados</div>
                <div class="flex gap-1.5 flex-wrap">
                    <span v-for="role in user.roles" :key="role" class="bg-surface-muted text-text-muted border-border">
                        {{ ROLE_LABELS[role] || role }}
                    </span>
                </div>
            </div>

            <div class="flex gap-2 pt-3 border-t border-border">
                <button 
                    @click="openEditModal(user)" 
                    class="flex-1 py-2 text-sm font-bold text-primary bg-primary/5 border border-primary/10 hover:bg-primary/10 flex items-center justify-center gap-2"
                >
                    <EditIcon class="w-4 h-4" />
                    Editar
                </button>
                <button 
                    @click="handleToggleStatus(user)" 
                    :class="[
                        'flex-1 py-2 text-sm font-bold rounded-lg transition-colors',
                        user.isActive 
                            ? 'text-error bg-error/5 border border-error/10 hover:bg-error/10' 
                            : 'text-success bg-success/5 border border-success/10 hover:bg-success/10'
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
