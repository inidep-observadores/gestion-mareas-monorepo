<template>
  <BaseModal 
    :show="show" 
    :title="isEditing ? 'Editar Usuario' : 'Nuevo Usuario'"
    @close="closeModal"
    maxWidth="2xl"
    variant="danger"
  >
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
                <p v-if="isUploading" class="text-center text-xs text-blue-500 mt-2">Subiendo imagen...</p>
        </div>

        <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Nombre Completo</label>
            <input
                v-model="form.fullName"
                type="text"
                required
                class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
            />
        </div>

        <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Email</label>
            <input
                v-model="form.email"
                type="email"
                required
                :disabled="isEditing"
                class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800 disabled:opacity-50"
            />
        </div>

        <div v-if="!isEditing || showPassword">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">
                {{ isEditing ? 'Nueva Contraseña (Opcional)' : 'Contraseña' }}
            </label>
            <input
                v-model="form.password"
                type="password"
                :required="!isEditing"
                minlength="6"
                class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
            />
        </div>
        <div v-if="isEditing" class="flex justify-end">
            <button type="button" @click="showPassword = !showPassword" class="text-xs text-blue-600 hover:text-blue-500">
                    {{ showPassword ? 'Cancelar cambio de contraseña' : 'Cambiar contraseña' }}
            </button>
        </div>

        <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-2">Roles</label>
            <div class="flex gap-4 flex-wrap">
                <label v-for="role in ROLES" :key="role.id" class="flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400 group">
                    <div class="relative">
                        <input 
                            type="checkbox" 
                            :value="role.id" 
                            v-model="form.roles" 
                            class="sr-only"
                        >
                        <div
                            :class="
                                form.roles.includes(role.id)
                                ? 'border-brand-500 bg-brand-500'
                                : 'bg-transparent border-gray-300 dark:border-gray-700 group-hover:border-brand-300'
                            "
                            class="mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
                        >
                            <span :class="form.roles.includes(role.id) ? '' : 'opacity-0'">
                                <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </span>
                        </div>
                    </div>
                    <span class="transition-colors group-hover:text-gray-900 dark:group-hover:text-white">{{ role.name }}</span>
                </label>
            </div>
        </div>

        <div class="mt-5 sm:mt-6 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
            <button
                type="submit"
                class="flex items-center justify-center w-full px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 disabled:cursor-not-allowed sm:col-start-2"
                :disabled="isSaving || isUploading"
            >
                {{ isSaving ? 'Guardando...' : 'Guardar' }}
            </button>
            <button
                type="button"
                class="mt-3 flex items-center justify-center w-full px-4 py-3 text-sm font-medium text-gray-700 transition bg-white border border-gray-300 rounded-lg shadow-theme-xs hover:bg-gray-50 hover:text-gray-800 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200 sm:col-start-1 sm:mt-0"
                @click="closeModal"
            >
                Cancelar
            </button>
        </div>
    </form>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import type { User } from '@/modules/auth/types/auth.types'
import { getFullImageUrl } from '@/helpers/image.helper'
import usersAdminApi from '../services/users.service'
import { toast } from 'vue-sonner'
import BaseModal from '@/components/common/BaseModal.vue'
import { ROLES } from '../constants/roles.constants'

const props = defineProps<{
  show: boolean
  user?: User | null
  isSaving?: boolean
}>()

const emit = defineEmits(['close', 'save'])

const isEditing = computed(() => !!props.user)
const showPassword = ref(false)
const previewUrl = ref('')
const isUploading = ref(false)

const initialForm = {
    fullName: '',
    email: '',
    password: '',
    roles: ['asistente_administrativo'] as string[],
    avatarUrl: undefined as string | undefined
}

const form = ref({ ...initialForm })

watch(
  () => props.user,
  (newUser) => {
    previewUrl.value = ''
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
      form.value = { ...initialForm, roles: ['asistente_administrativo'] }
      showPassword.value = false
    }
  },
  { immediate: true }
)

const closeModal = () => {
    if (previewUrl.value) URL.revokeObjectURL(previewUrl.value)
    emit('close')
}

const handleFileChange = async (event: Event) => {
    const target = event.target as HTMLInputElement
    if (target.files && target.files[0]) {
        const file = target.files[0]
        if (!file.type.startsWith('image/')) {
            toast.error('Por favor seleccione un archivo de imagen válido')
            return
        }

        if (previewUrl.value) URL.revokeObjectURL(previewUrl.value)
        previewUrl.value = URL.createObjectURL(file)

        isUploading.value = true
        try {
            const url = await usersAdminApi.uploadOnly(file)
            form.value.avatarUrl = url
        } catch (error) {
            toast.error('Error al subir la imagen')
        } finally {
            isUploading.value = false
        }
    }
}

const handleSubmit = async () => {
    if (form.value.roles.length === 0) {
        toast.error('Debe seleccionar al menos un rol')
        return
    }
    emit('save', { ...form.value, id: props.user?.id })
}
</script>
