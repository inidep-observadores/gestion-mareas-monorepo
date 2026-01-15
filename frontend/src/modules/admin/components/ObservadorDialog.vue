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
                <div class="w-24 h-24 overflow-hidden rounded-full ring-4 ring-surface-muted bg-surface-muted">
                    <img
                        :src="getFullImageUrl(previewUrl || form.fotoUrl)"
                        alt="Foto"
                        class="object-cover w-full h-full"
                        @error="(e: any) => e.target.src = '/placeholder-avatar.png'"
                    />
                </div>
                <label
                    class="absolute bottom-0 right-0 p-1.5 bg-primary rounded-full cursor-pointer hover:bg-primary/90 transition-colors shadow-lg text-primary-fg"
                    title="Cambiar foto"
                >
                    <input type="file" class="hidden" accept="image/*" @change="handleFileChange" />
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                    </svg>
                </label>
            </div>
            <p v-if="isUploading" class="text-center text-xs text-primary mt-2">Subiendo imagen...</p>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            <div>
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Código Interno</label>
                <input
                    v-model.number="form.codigoInterno"
                    type="number"
                    required
                    :class="[
                        'h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.codigoInterno ? 'border-error bg-error/5' : 'border-border focus:border-primary'
                    ]"
                />
                <p v-if="fieldErrors.codigoInterno" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.codigoInterno }}</p>
            </div>
            
            <div class="sm:col-span-2">
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Email</label>
                <input
                    v-model="form.email"
                    type="email"
                    placeholder="email@ejemplo.com"
                    :class="[
                        'h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.email ? 'border-error bg-error/5' : 'border-border focus:border-primary'
                    ]"
                />
                <p v-if="fieldErrors.email" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.email }}</p>
            </div>

            <div>
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Nombre</label>
                <input
                    v-model="form.nombre"
                    type="text"
                    required
                    :class="[
                        'h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.nombre ? 'border-error bg-error/5' : 'border-border focus:border-primary'
                    ]"
                />
                <p v-if="fieldErrors.nombre" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.nombre }}</p>
            </div>
            <div>
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Apellido</label>
                <input
                    v-model="form.apellido"
                    type="text"
                    required
                    :class="[
                        'h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                        fieldErrors.apellido ? 'border-error bg-error/5' : 'border-border focus:border-primary'
                    ]"
                />
                <p v-if="fieldErrors.apellido" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.apellido }}</p>
            </div>

            <div>
                 <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Tipo Observador</label>
                <SearchableSelect
                    v-model="form.tipoObservador"
                    :options="tipoObservadorOptions"
                    :error="fieldErrors.tipoObservador"
                    placeholder="Seleccione..."
                />
                <p v-if="fieldErrors.tipoObservador" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.tipoObservador }}</p>
            </div>
        </div>

        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Tipo Contrato</label>
                <SearchableSelect
                    v-model="form.tipoContrato"
                    :options="tipoContratoOptions"
                    :error="fieldErrors.tipoContrato"
                    placeholder="Seleccione..."
                />
                <p v-if="fieldErrors.tipoContrato" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.tipoContrato }}</p>
            </div>
            <div>
                <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Fecha Próxima Disponibilidad</label>
                <DatePicker 
                    v-model="form.fechaProximaDisponibilidad"
                    :show-time="false"
                    :error="fieldErrors.fechaProximaDisponibilidad"
                />
                <p v-if="fieldErrors.fechaProximaDisponibilidad" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.fechaProximaDisponibilidad }}</p>
            </div>
        </div>

        <div>
            <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Observaciones</label>
            <textarea
                v-model="form.observaciones"
                rows="3"
                class="w-full rounded-lg border border-border bg-transparent px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10"
            ></textarea>
        </div>

        <div class="flex flex-wrap gap-6 p-4 bg-surface-muted rounded-xl border border-border">
            <label class="flex items-center text-sm font-normal text-text-muted cursor-pointer select-none group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.activo" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.activo
                            ? 'border-primary bg-primary'
                            : 'bg-transparent border-border group-hover:border-primary/50'
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
                <span class="transition-colors group-hover:text-text">Activo</span>
            </label>

            <label class="flex items-center text-sm font-normal text-text-muted cursor-pointer select-none group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.disponible" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.disponible
                            ? 'border-primary bg-primary'
                            : 'border-border bg-transparent group-hover:border-primary/50'
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
                <span class="transition-colors group-hover:text-text">Disponible</span>
            </label>

            <label class="flex items-center text-sm font-normal text-text-muted cursor-pointer select-none group">
                <div class="relative">
                    <input 
                        type="checkbox" 
                        v-model="form.conImpedimento" 
                        class="sr-only"
                    >
                    <div
                        :class="
                            form.conImpedimento
                            ? 'border-primary bg-primary'
                            : 'border-border bg-transparent group-hover:border-primary/50'
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
                <span class="transition-colors group-hover:text-text">Con Impedimento</span>
            </label>
        </div>

        <div v-if="form.conImpedimento" class="animate-in fade-in slide-in-from-top-2 duration-300">
            <label class="block text-xs font-bold text-text-muted uppercase tracking-widest mb-1.5">Motivo Impedimento</label>
            <input
                v-model="form.motivoImpedimento"
                type="text"
                :required="form.conImpedimento"
                placeholder="Describa el motivo (licencia, etc.)..."
                :class="[
                    'h-11 w-full rounded-lg border bg-transparent px-4 py-2.5 text-sm transition-all outline-none',
                    fieldErrors.motivoImpedimento ? 'border-error bg-error/5' : 'border-border focus:border-primary'
                ]"
            />
            <p v-if="fieldErrors.motivoImpedimento" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.motivoImpedimento }}</p>
        </div>

        <div class="mt-8 flex flex-col-reverse sm:grid sm:grid-cols-2 sm:gap-3">
            <button
                type="button"
                class="mt-3 sm:mt-0 flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-text-muted transition bg-surface border border-border rounded-xl hover:bg-surface-muted hover:text-text"
                @click="closeModal"
            >
                Cancelar
            </button>
            <button
                type="submit"
                class="flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-primary-fg transition rounded-xl bg-primary shadow-lg shadow-primary/20 hover:bg-primary/90 disabled:opacity-50 disabled:cursor-not-allowed"
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
