<template>
  <BaseModal 
    :show="show" 
    :title="isEditing ? 'Editar Observador' : 'Nuevo Observador'"
    @close="closeModal"
    maxWidth="3xl"
    variant="danger"
  >
    <form @submit.prevent="handleSubmit" class="space-y-6" novalidate>
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

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Código Interno</label>
                <input
                    v-model.number="form.codigoInterno"
                    type="number"
                    required
                    :class="[
                        'dark:bg-dark-900 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.codigoInterno ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800 focus:border-brand-500'
                    ]"
                />
                <p v-if="fieldErrors.codigoInterno" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.codigoInterno }}</p>
            </div>
            
            <div class="sm:col-span-2">
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Email</label>
                <input
                    v-model="form.email"
                    type="email"
                    placeholder="email@ejemplo.com"
                    :class="[
                        'dark:bg-dark-900 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.email ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800 focus:border-brand-500'
                    ]"
                />
                <p v-if="fieldErrors.email" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.email }}</p>
            </div>

            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Nombre</label>
                <input
                    v-model="form.nombre"
                    type="text"
                    required
                    :class="[
                        'dark:bg-dark-900 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.nombre ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800 focus:border-brand-500'
                    ]"
                />
                <p v-if="fieldErrors.nombre" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.nombre }}</p>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Apellido</label>
                <input
                    v-model="form.apellido"
                    type="text"
                    required
                    :class="[
                        'dark:bg-dark-900 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.apellido ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800 focus:border-brand-500'
                    ]"
                />
                <p v-if="fieldErrors.apellido" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.apellido }}</p>
            </div>

            <div>
                 <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Tipo Observador</label>
                <SearchableSelect
                    v-model="form.tipoObservador"
                    :options="tipoObservadorOptions"
                    :error="fieldErrors.tipoObservador"
                    placeholder="Seleccione..."
                />
                <p v-if="fieldErrors.tipoObservador" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.tipoObservador }}</p>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Tipo Contrato</label>
                <SearchableSelect
                    v-model="form.tipoContrato"
                    :options="tipoContratoOptions"
                    :error="fieldErrors.tipoContrato"
                    placeholder="Seleccione..."
                />
                <p v-if="fieldErrors.tipoContrato" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.tipoContrato }}</p>
            </div>
            <div>
                <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Fecha Próxima Disponibilidad</label>
                <DatePicker 
                    v-model="form.fechaProximaDisponibilidad"
                    :show-time="false"
                    :error="fieldErrors.fechaProximaDisponibilidad"
                />
                <p v-if="fieldErrors.fechaProximaDisponibilidad" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.fechaProximaDisponibilidad }}</p>
            </div>
        </div>

        <div>
            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Observaciones</label>
            <textarea
                v-model="form.observaciones"
                rows="3"
                class="dark:bg-dark-900 w-full rounded-lg border border-gray-200 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-800 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
            ></textarea>
        </div>

        <div class="flex flex-wrap gap-6 p-4 bg-gray-50/50 dark:bg-gray-900/50 rounded-xl border border-gray-100 dark:border-gray-800">
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

            <label class="flex items-center text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400 group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.conImpedimento" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.conImpedimento
                            ? 'border-brand-500 bg-brand-500'
                            : 'border-gray-300 bg-transparent dark:border-gray-700 group-hover:border-brand-300'
                        "
                        class="mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px] transition-colors"
                    >
                        <span :class="form.conImpedimento ? '' : 'opacity-0'">
                            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                                <path d="M11.6666 3.5L5.24992 9.91667L2.33325 7" stroke="white" stroke-width="1.94437" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                        </span>
                    </div>
                </div>
                <span class="transition-colors group-hover:text-gray-900 dark:group-hover:text-white">Con Impedimento</span>
            </label>
        </div>

        <div v-if="form.conImpedimento" class="animate-in fade-in slide-in-from-top-2 duration-300">
            <label class="block text-xs font-bold text-gray-400 uppercase tracking-widest mb-1.5">Motivo Impedimento</label>
            <input
                v-model="form.motivoImpedimento"
                type="text"
                :required="form.conImpedimento"
                placeholder="Describa el motivo (licencia, etc.)..."
                :class="[
                    'dark:bg-dark-900 h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                    fieldErrors.motivoImpedimento ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800 focus:border-brand-500'
                ]"
            />
            <p v-if="fieldErrors.motivoImpedimento" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.motivoImpedimento }}</p>
        </div>

        <div class="mt-8 flex flex-col-reverse sm:grid sm:grid-cols-2 sm:gap-3">
            <button
                type="button"
                class="mt-3 sm:mt-0 flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-gray-500 transition bg-white border border-gray-200 rounded-xl hover:bg-gray-50 hover:text-gray-800 dark:border-gray-800 dark:bg-gray-800/50 dark:text-gray-400 dark:hover:bg-white/[0.03] dark:hover:text-gray-200"
                @click="closeModal"
            >
                Cancelar
            </button>
            <button
                type="submit"
                class="flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-white transition rounded-xl bg-brand-500 shadow-lg shadow-brand-500/20 hover:bg-brand-600 disabled:opacity-50 disabled:cursor-not-allowed"
                :disabled="isSaving || isUploading"
            >
                <span v-if="isSaving" class="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent"></span>
                {{ isSaving ? 'Guardando...' : 'Guardar' }}
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
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import { TIPO_OBSERVADOR, TIPO_CONTRATO } from '../constants/observador.constants'

const props = defineProps<{
  show: boolean
  observador?: Observador | null
  isSaving?: boolean
}>()

const tipoObservadorOptions = computed(() => TIPO_OBSERVADOR.map(t => ({ value: t.id, label: t.name })))
const tipoContratoOptions = computed(() => TIPO_CONTRATO.map(t => ({ value: t.id, label: t.name })))

const emit = defineEmits(['close', 'save'])

const isEditing = computed(() => !!props.observador)
const previewUrl = ref('')
const isUploading = ref(false)
const fieldErrors = ref<Record<string, string>>({})

const initialForm = {
    codigoInterno: null as number | null,
    nombre: '',
    apellido: '',
    email: '',
    tipoObservador: 'OBSERVADOR',
    tipoContrato: 'LEY MARCO',
    activo: true,
    disponible: true,
    conImpedimento: false,
    motivoImpedimento: '',
    fechaProximaDisponibilidad: '',
    fotoUrl: undefined as string | undefined,
    observaciones: ''
}

const form = ref({ ...initialForm })

watch(
  () => props.observador,
  (newObservador) => {
    previewUrl.value = ''
    fieldErrors.value = {}
    if (newObservador) {
      form.value = {
        codigoInterno: newObservador.codigoInterno,
        nombre: newObservador.nombre,
        apellido: newObservador.apellido,
        email: newObservador.email || '',
        tipoObservador: newObservador.tipoObservador,
        tipoContrato: newObservador.tipoContrato,
        activo: newObservador.activo,
        disponible: newObservador.disponible,
        conImpedimento: newObservador.conImpedimento ?? false,
        motivoImpedimento: newObservador.motivoImpedimento || '',
        fechaProximaDisponibilidad: newObservador.fechaProximaDisponibilidad || '',
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
    fieldErrors.value = {}
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

const validate = () => {
    fieldErrors.value = {}
    let isValid = true

    if (!form.value.codigoInterno) {
        fieldErrors.value.codigoInterno = 'El código interno es obligatorio'
        isValid = false
    }

    if (!form.value.nombre) {
        fieldErrors.value.nombre = 'El nombre es obligatorio'
        isValid = false
    }

    if (!form.value.apellido) {
        fieldErrors.value.apellido = 'El apellido es obligatorio'
        isValid = false
    }

    if (form.value.email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.value.email)) {
        fieldErrors.value.email = 'El formato del email no es válido'
        isValid = false
    }

    if (form.value.conImpedimento && !form.value.motivoImpedimento) {
        fieldErrors.value.motivoImpedimento = 'El motivo de impedimento es obligatorio'
        isValid = false
    }

    return isValid
}

const handleSubmit = async () => {
    if (!validate()) {
        toast.error('Por favor, revise los errores en el formulario')
        return
    }
    const data = { ...form.value, id: props.observador?.id }
    if (!data.fechaProximaDisponibilidad) data.fechaProximaDisponibilidad = null as any
    emit('save', data)
}
</script>
