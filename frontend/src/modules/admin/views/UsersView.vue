<template>
  <AdminDashboardLayout>
    <div class="flex flex-col gap-6">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Gestión de Usuarios</h1>
          <p class="text-gray-500 dark:text-gray-400">Administra los accesos y roles de los usuarios del sistema</p>
        </div>
        <div class="flex gap-2">
          <button
            @click="openCreateModal"
            class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-lg hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          >
            Nuevo Usuario
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
                <input v-model="searchQuery" type="text" placeholder="Buscar usuarios..." class="block w-full py-2 pl-10 pr-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" />
            </div>
            <!-- <div class="flex gap-2">
                 <button class="px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-700">Filtrar</button>
            </div> -->
        </div>

        <!-- Table -->
        <div class="relative overflow-x-auto shadow-md sm:rounded-lg">
          <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
            <thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
              <tr>
                <th scope="col" class="px-6 py-3">Nombre</th>
                <th scope="col" class="px-6 py-3">Roles</th>
                <th scope="col" class="px-6 py-3">Estado</th>
                <th scope="col" class="px-6 py-3">Acciones</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="isLoading">
                  <td colspan="4" class="px-6 py-4 text-center">Cargando usuarios...</td>
              </tr>
              <tr v-else-if="filteredUsers.length === 0">
                  <td colspan="4" class="px-6 py-4 text-center">No se encontraron usuarios.</td>
              </tr>
              <tr v-for="user in filteredUsers" :key="user.id" class="bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600">
                <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
                    <div class="flex items-center gap-3">
                         <img :src="user.avatarUrl || '/placeholder-avatar.png'" class="w-8 h-8 rounded-full object-cover" alt="Avatar">
                         <div>
                            <div class="font-semibold">{{ user.fullName }}</div>
                            <div class="text-xs text-gray-500">{{ user.email }}</div>
                         </div>
                    </div>
                </td>
                <td class="px-6 py-4">
                    <div class="flex gap-1 flex-wrap">
                        <span v-for="role in user.roles" :key="role" class="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded dark:bg-blue-900 dark:text-blue-300 border border-blue-400">
                            {{ roleLabels[role] || role }}
                        </span>
                    </div>
                </td>
                <td class="px-6 py-4">
                  <span
                    :class="[
                        'text-xs font-medium mr-2 px-2.5 py-0.5 rounded',
                        user.isActive
                            ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
                            : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'
                    ]"
                  >
                    {{ user.isActive ? 'Activo' : 'Inactivo' }}
                  </span>
                </td>
                <td class="px-6 py-4 flex gap-3">
                  <button @click="openEditModal(user)" class="font-medium text-blue-600 dark:text-blue-500 hover:underline">Editar</button>
                  <button
                    @click="handleToggleStatus(user)"
                    :class="['font-medium hover:underline', user.isActive ? 'text-red-600 dark:text-red-500' : 'text-green-600 dark:text-green-500']"
                  >
                    {{ user.isActive ? 'Desactivar' : 'Activar' }}
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

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
import { ref, computed, onMounted } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import { SearchIcon } from '@/icons';
import UserDialog from '../components/UserDialog.vue'
import usersAdminApi, { type CreateUserDto, type UpdateUserDto } from '../services/users.service'
import type { User } from '@/modules/auth/types/auth.types'
import { toast } from 'vue-sonner'

const users = ref<User[]>([])
const isLoading = ref(true)
const searchQuery = ref('')
const showModal = ref(false)
const selectedUser = ref<User | null>(null)
const isSaving = ref(false)

const roleLabels: Record<string, string> = {
    admin: 'Administrador',
    asistente_administrativo: 'Asistente Adm.',
    tecnico_datos: 'Técnico Datos',
    coordinador: 'Coordinador',
    // Fallback for old ones if any
    user: 'Usuario',
    observer: 'Observador'
}

const fetchUsers = async () => {
    isLoading.value = true;
    try {
        users.value = await usersAdminApi.getUsers();
    } catch (error) {
        toast.error('Error al cargar usuarios');
    } finally {
        isLoading.value = false;
    }
}

const filteredUsers = computed(() => {
    if (!searchQuery.value) return users.value;
    const lower = searchQuery.value.toLowerCase();
    return users.value.filter(u =>
        u.fullName.toLowerCase().includes(lower) ||
        u.email.toLowerCase().includes(lower)
    );
})

const openCreateModal = () => {
    selectedUser.value = null;
    showModal.value = true;
}

const openEditModal = (user: User) => {
    selectedUser.value = { ...user }; // Clone to avoid direct mutation
    showModal.value = true;
}

const closeModal = () => {
    showModal.value = false;
    selectedUser.value = null;
}

const handleSave = async (data: any) => {
    isSaving.value = true;
    try {
        const { id, ...payload } = data;
        
        // Cleanup payload: remove empty password
        if (!payload.password) delete payload.password;

        if (id) {
            // Update
            await usersAdminApi.updateUser(id, payload);
            toast.success('Usuario actualizado correctamente');
        } else {
            // Create
            await usersAdminApi.createUser(payload as CreateUserDto);
            toast.success('Usuario creado correctamente');
        }
        await fetchUsers();
        closeModal();
    } catch (error: any) {
        console.error('Save error:', error);
        const errorMessage = error.response?.data?.message || 'Error al guardar usuario';
        
        if (Array.isArray(errorMessage)) {
            errorMessage.forEach(msg => toast.error(msg));
        } else {
            toast.error(errorMessage);
        }
    } finally {
        isSaving.value = false;
    }
}

const handleToggleStatus = async (user: User) => {
    try {
        await usersAdminApi.toggleStatus(user.id);
        toast.success(`Usuario ${user.isActive ? 'desactivado' : 'activado'} correctamente`);
        await fetchUsers();
    } catch (error: any) {
        const errorMessage = error.response?.data?.message || 'Error al cambiar estado';
        toast.error(errorMessage);
    }
}

onMounted(() => {
    fetchUsers();
})
</script>
