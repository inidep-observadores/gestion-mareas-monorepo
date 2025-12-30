<template>
  <div v-if="isOpen" class="relative z-50" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" @click="closeModal"></div>

    <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
      <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
        <div
          class="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg dark:bg-gray-800"
          @click.stop
        >
          <div class="bg-white px-4 pb-4 pt-5 sm:p-6 dark:bg-gray-800">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-white" id="modal-title">
                {{ isEditing ? 'Editar Usuario' : 'Nuevo Usuario' }}
              </h3>
              <button
                @click="closeModal"
                class="text-gray-400 hover:text-gray-500 focus:outline-none"
              >
                <span class="sr-only">Cerrar</span>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <form @submit.prevent="handleSubmit" class="space-y-4">
               <!-- Avatar Preview/Upload -->
                <div class="flex flex-col items-center mb-6">
                    <div class="relative group">
                        <div class="w-24 h-24 overflow-hidden rounded-full ring-4 ring-gray-100 dark:ring-gray-700 bg-gray-100">
                            <img
                                :src="getFullImageUrl(previewUrl || form.avatarUrl)"
                                alt="Avatar"
                                class="object-cover w-full h-full"
                                @error="(e: any) => e.target.src = '/placeholder-avatar.png'"
                            />
                        </div>
                        <label
                            class="absolute bottom-0 right-0 p-1.5 bg-blue-500 rounded-full cursor-pointer hover:bg-blue-600 transition-colors shadow-lg text-white"
                            title="Cambiar foto"
                        >
                            <input type="file" class="hidden" accept="image/*" @change="handleFileChange" />
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                            </svg>
                        </label>
                    </div>
                     <p v-if="isUploading" class="text-center text-xs text-blue-500">Subiendo imagen...</p>
                </div>


              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Nombre Completo
                </label>
                <input
                  v-model="form.fullName"
                  type="text"
                  required
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm dark:bg-gray-700 dark:border-gray-600 dark:text-white px-3 py-2 border"
                />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  Email
                </label>
                <input
                  v-model="form.email"
                  type="email"
                  required
                  :disabled="isEditing"
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm dark:bg-gray-700 dark:border-gray-600 dark:text-white disabled:opacity-50 px-3 py-2 border"
                />
              </div>

               <div v-if="!isEditing || showPassword">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  {{ isEditing ? 'Nueva Contraseña (Opcional)' : 'Contraseña' }}
                </label>
                <input
                  v-model="form.password"
                  type="password"
                  :required="!isEditing"
                  minlength="6"
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500 sm:text-sm dark:bg-gray-700 dark:border-gray-600 dark:text-white px-3 py-2 border"
                />
              </div>
               <div v-if="isEditing" class="flex justify-end">
                    <button type="button" @click="showPassword = !showPassword" class="text-xs text-blue-600 hover:text-blue-500">
                         {{ showPassword ? 'Cancelar cambio de contraseña' : 'Cambiar contraseña' }}
                    </button>
               </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                  Roles
                </label>
                <div class="flex gap-4">
                <div class="flex gap-4 flex-wrap">
                    <label class="inline-flex items-center">
                        <input type="checkbox" value="asistente_administrativo" v-model="form.roles" class="rounded border-gray-300 text-blue-600 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        <span class="ml-2 text-gray-700 dark:text-gray-300 text-sm">Asistente Adm.</span>
                    </label>
                    <label class="inline-flex items-center">
                        <input type="checkbox" value="tecnico_datos" v-model="form.roles" class="rounded border-gray-300 text-blue-600 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        <span class="ml-2 text-gray-700 dark:text-gray-300 text-sm">Técnico Datos</span>
                    </label>
                    <label class="inline-flex items-center">
                        <input type="checkbox" value="coordinador" v-model="form.roles" class="rounded border-gray-300 text-blue-600 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        <span class="ml-2 text-gray-700 dark:text-gray-300 text-sm">Coordinador</span>
                    </label>
                     <label class="inline-flex items-center">
                        <input type="checkbox" value="admin" v-model="form.roles" class="rounded border-gray-300 text-blue-600 shadow-sm focus:border-blue-300 focus:ring focus:ring-blue-200 focus:ring-opacity-50">
                        <span class="ml-2 text-gray-700 dark:text-gray-300 text-sm">Administrador</span>
                    </label>
                </div>
                </div>
              </div>

              <div class="mt-5 sm:mt-6 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
                 <button
                  type="submit"
                  class="inline-flex w-full justify-center rounded-md border border-transparent bg-blue-600 px-4 py-2 text-base font-medium text-white shadow-sm hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 sm:col-start-2 sm:text-sm"
                  :disabled="isSavingLocally || isUploading"
                >
                  {{ isSavingLocally ? 'Guardando...' : 'Guardar' }}
                </button>
                <button
                  type="button"
                  class="mt-3 inline-flex w-full justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-base font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 sm:col-start-1 sm:mt-0 sm:text-sm dark:bg-gray-700 dark:text-gray-300 dark:border-gray-600 dark:hover:bg-gray-600"
                  @click="closeModal"
                >
                  Cancelar
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import type { User } from '@/modules/auth/types/auth.types'
import { getFullImageUrl } from '@/helpers/image.helper'
import usersAdminApi from '../services/users.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
  show: boolean
  user?: User | null
  isSaving?: boolean
}>()

const emit = defineEmits(['close', 'save'])

const isOpen = computed(() => props.show)
const isEditing = computed(() => !!props.user)
const isSavingLocally = computed(() => props.isSaving)
const showPassword = ref(false)
const previewUrl = ref('')
const isUploading = ref(false)

const form = ref({
  fullName: '',
  email: '',
  password: '',
  roles: ['asistente_administrativo'] as string[],
  avatarUrl: undefined as string | undefined
})

watch(
  () => props.user,
  (newUser) => {
    previewUrl.value = '';
    if (newUser) {
      form.value = {
        fullName: newUser.fullName,
        email: newUser.email,
        password: '',
        roles: [...newUser.roles],
        avatarUrl: newUser.avatarUrl
      }
      showPassword.value = false
    } else {
      form.value = {
        fullName: '',
        email: '',
        password: '',
        roles: ['asistente_administrativo'],
        avatarUrl: undefined
      }
      showPassword.value = false
    }
  },
  { immediate: true }
)

const closeModal = () => {
    // Revoke object URL
    if (previewUrl.value) URL.revokeObjectURL(previewUrl.value);
  emit('close')
}

const handleFileChange = async (event: Event) => {
    const target = event.target as HTMLInputElement;
    if (target.files && target.files[0]) {
        const file = target.files[0];
         if (!file.type.startsWith('image/')) {
            toast.error('Por favor seleccione un archivo de imagen válido');
            return;
        }

        // Preview
        if (previewUrl.value) URL.revokeObjectURL(previewUrl.value);
        previewUrl.value = URL.createObjectURL(file);

        // Upload immediately to get URL
        isUploading.value = true;
        try {
            const url = await usersAdminApi.uploadOnly(file);
            form.value.avatarUrl = url;
        } catch (error) {
            toast.error('Error al subir la imagen');
            // Revert preview?
        } finally {
            isUploading.value = false;
        }
    }
}

const handleSubmit = async () => {
    if (form.value.roles.length === 0) {
        toast.error('Debe seleccionar al menos un rol');
        return;
    }
    
    emit('save', { ...form.value, id: props.user?.id });
}
</script>
