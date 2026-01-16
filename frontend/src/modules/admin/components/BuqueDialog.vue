<template>
  <BaseModal 
    :show="show" 
    :title="isEditing ? 'Editar Buque' : 'Nuevo Buque'"
    @close="emit('close')"
    maxWidth="5xl"
    variant="danger"
  >
    <form @submit.prevent="handleSubmit" class="space-y-6">
        <!-- Información Principal -->
        <div class="space-y-4">
            <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">Información del Buque</h3>
            
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div class="sm:col-span-2">
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre del Buque</label>
                    <input
                        v-model="form.nombreBuque"
                        type="text"
                        required
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Matrícula</label>
                    <input
                        v-model="form.matricula"
                        type="text"
                        required
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Tipo de Flota</label>
                    <SearchableSelect
                        v-model="form.tipoFlotaId as any"
                        :options="tipoFlotaOptions"
                        placeholder="Seleccione..."
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Puerto Base</label>
                    <SearchableSelect
                        v-model="form.puertoBaseId as any"
                        :options="puertoOptions"
                        placeholder="Seleccione..."
                    />
                </div>
                <div>
                  <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Código Interno</label>
                  <input
                    v-model.number="form.codigoInterno"
                    type="number"
                    class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                  />
                </div>
            </div>
        </div>

        <!-- Especificaciones Técnicas -->
        <div class="space-y-4 pt-4">
            <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">Especificaciones Técnicas</h3>
            
            <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Eslora (m)</label>
                    <input
                        v-model.number="form.esloraM"
                        type="number"
                        step="0.01"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Potencia (HP)</label>
                    <input
                        v-model.number="form.potenciaHp"
                        type="number"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Días Marea Est.</label>
                    <input
                        v-model.number="form.diasMareaEstimada"
                        type="number"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    &nbsp;
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Pesquería Habitual</label>
                    <SearchableSelect
                        v-model="form.pesqueriaHabitualId as any"
                        :options="pesqueriaOptions"
                        placeholder="Seleccione..."
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Arte de Pesca Habitual</label>
                    <SearchableSelect
                        v-model="form.arteHabitualId as any"
                        :options="arteOptions"
                        placeholder="Seleccione..."
                    />
                </div>
            </div>
        </div>

        <!-- Contacto / Empresa -->
        <div class="space-y-4 pt-4">
            <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">Empresa y Armador</h3>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre Empresa</label>
                    <input
                        v-model="form.empresaNombre"
                        type="text"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Localidad Empresa</label>
                    <input
                        v-model="form.empresaLocalidad"
                        type="text"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre Armador</label>
                    <input
                        v-model="form.armadorNombre"
                        type="text"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Teléfono Armador</label>
                    <input
                        v-model="form.armadorTelefono"
                        type="text"
                        class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                    />
                </div>
            </div>
        </div>

        <div>
            <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Observaciones</label>
            <textarea
                v-model="form.observaciones"
                rows="3"
                class="w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
            ></textarea>
        </div>

        <div class="flex gap-6">
            <label class="flex items-center text-sm font-medium text-text-muted cursor-pointer select-none group">
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
        </div>

        <div class="mt-5 sm:mt-8 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
            <button
                type="submit"
                class="flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest text-primary-fg transition-all rounded-lg bg-primary shadow-theme-xs hover:bg-primary-hover active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed sm:col-start-2"
                :disabled="isSaving"
            >
                {{ isSaving ? 'Guardando...' : 'Guardar' }}
            </button>
            <button
                type="button"
                class="mt-3 flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest text-text-muted transition-all bg-surface border border-border rounded-lg shadow-theme-xs hover:bg-surface-muted hover:text-text active:scale-95 sm:col-start-1 sm:mt-0"
                @click="emit('close')"
            >
                Cancelar
            </button>
        </div>
    </form>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import type { Buque, TipoFlota, Puerto, Pesqueria, ArtePesca } from '../interfaces/buque.interface'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'

const props = defineProps<{
  show: boolean
  buque?: Partial<Buque> | null
  isSaving?: boolean
  tiposFlota: TipoFlota[]
  puertos: Puerto[]
  pesquerias: Pesqueria[]
  artesPesca: ArtePesca[]
}>()

const tipoFlotaOptions = computed(() => props.tiposFlota.map(t => ({ value: t.id, label: t.nombre })))
const puertoOptions = computed(() => props.puertos.map(p => ({ value: p.id, label: p.nombre })))
const pesqueriaOptions = computed(() => props.pesquerias.map(p => ({ value: p.id, label: p.nombre })))
const arteOptions = computed(() => props.artesPesca.map(a => ({ value: a.id, label: a.nombre })))

const emit = defineEmits(['close', 'save'])

const isEditing = computed(() => !!props.buque?.id)

const initialForm: Partial<Buque> = {
    nombreBuque: '',
    matricula: '',
    codigoInterno: null,
    tipoFlotaId: null,
    puertoBaseId: null,
    pesqueriaHabitualId: null,
    arteHabitualId: null,
    esloraM: null,
    potenciaHp: null,
    diasMareaEstimada: null,
    empresaNombre: '',
    empresaLocalidad: '',
    armadorNombre: '',
    armadorTelefono: '',
    activo: true,
    observaciones: ''
}

const form = ref({ ...initialForm })

watch(
  () => props.buque,
  (newBuque) => {
    if (newBuque) {
      form.value = { ...initialForm, ...newBuque }
    } else {
      form.value = { ...initialForm }
    }
  },
  { immediate: true }
)

const handleSubmit = () => {
    emit('save', { ...form.value })
}
</script>
