<template>
  <BaseModal 
    :show="show" 
    :title="isEditing ? 'Editar Observador' : 'Nuevo Observador'"
    @close="closeModal"
    maxWidth="3xl"
  >
    <form @submit.prevent="handleSubmit" class="space-y-4">
        <!-- Foto Preview/Upload -->
        <div class="flex flex-col items-center mb-6">
            <div class="relative group">
                <div class="w-24 h-24 overflow-hidden rounded-full ring-4 ring-gray-100 dark:ring-gray-700 bg-gray-100">
                    <img
                        :src="getFullImageUrl(previewUrl || form.fotoUrl)"
                        alt="Foto"
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

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Código Interno</label>
                <input
                    v-model.number="form.codigoInterno"
                    type="number"
                    required
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                />
            </div>
            <div>
                &nbsp;
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Nombre</label>
                <input
                    v-model="form.nombre"
                    type="text"
                    required
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                />
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Apellido</label>
                <input
                    v-model="form.apellido"
                    type="text"
                    required
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                />
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Tipo Observador</label>
                <select
                    v-model="form.tipoObservador"
                    required
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                >
                    <option v-for="tipo in TIPO_OBSERVADOR" :key="tipo.id" :value="tipo.id">{{ tipo.name }}</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Tipo Contrato</label>
                <select
                    v-model="form.tipoContrato"
                    required
                    class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                >
                    <option v-for="tipo in TIPO_CONTRATO" :key="tipo.id" :value="tipo.id">{{ tipo.name }}</option>
                </select>
            </div>
        </div>

        <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Observaciones</label>
            <textarea
                v-model="form.observaciones"
                rows="3"
                class="dark:bg-dark-900 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
            ></textarea>
        </div>

        <div class="flex gap-6">
            <label class="flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400 group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.activo" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.activo
                            ? 'border-brand-500 bg-brand-500'
                            : 'bg-transparent border-gray-300 dark:border-gray-700 group-hover:border-brand-300'
                        "
                        class="mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
                    >
                        <span :class="form.activo ? '' : 'opacity-0'">
                            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                    </div>
                </div>
                <span class="transition-colors group-hover:text-gray-900 dark:group-hover:text-white">Activo</span>
            </label>

            <label class="flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400 group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.disponible" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.disponible
                            ? 'border-brand-500 bg-brand-500'
                            : 'border-gray-300 bg-transparent dark:border-gray-700 group-hover:border-brand-300'
                        "
                        class="mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
                    >
                        <span :class="form.disponible ? '' : 'opacity-0'">
                            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                    </div>
                </div>
                <span class="transition-colors group-hover:text-gray-900 dark:group-hover:text-white">Disponible</span>
            </label>
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
import type { Observador } from '../interfaces/observador.interface'
import { getFullImageUrl } from '@/helpers/image.helper'
import observadoresApi from '../services/observadores.service'
import { toast } from 'vue-sonner'
import BaseModal from '@/components/common/BaseModal.vue'
import { TIPO_OBSERVADOR, TIPO_CONTRATO } from '../constants/observador.constants'

const props = defineProps<{
  show: boolean
  observador?: Observador | null
  isSaving?: boolean
}>()

const emit = defineEmits(['close', 'save'])

const isEditing = computed(() => !!props.observador)
const previewUrl = ref('')
const isUploading = ref(false)

const initialForm = {
    codigoInterno: 0,
    nombre: '',
    apellido: '',
    tipoObservador: 'OBSERVADOR',
    tipoContrato: 'LEY MARCO',
    activo: true,
    disponible: true,
    fotoUrl: undefined as string | undefined,
    observaciones: ''
}

const form = ref({ ...initialForm })

watch(
  () => props.observador,
  (newObservador) => {
    previewUrl.value = ''
    if (newObservador) {
      form.value = {
        codigoInterno: newObservador.codigoInterno,
        nombre: newObservador.nombre,
        apellido: newObservador.apellido,
        tipoObservador: newObservador.tipoObservador,
        tipoContrato: newObservador.tipoContrato,
        activo: newObservador.activo,
        disponible: newObservador.disponible,
        fotoUrl: newObservador.fotoUrl,
        observaciones: newObservador.observaciones || ''
      }
    } else {
      form.value = { ...initialForm }
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
            const url = await observadoresApi.uploadFoto(file)
            form.value.fotoUrl = url
        } catch (error) {
            toast.error('Error al subir la imagen')
        } finally {
            isUploading.value = false
        }
    }
}

const handleSubmit = async () => {
    emit('save', { ...form.value, id: props.observador?.id })
}
</script>
