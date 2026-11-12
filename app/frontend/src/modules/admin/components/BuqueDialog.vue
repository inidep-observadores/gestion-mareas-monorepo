<template>
    <BaseModal :show="show" :title="readOnly ? 'Detalle del Buque' : (isEditing ? 'Editar Buque' : 'Nuevo Buque')"
        @close="emit('close')" maxWidth="5xl" variant="default">
        <form v-form-nav @submit.prevent="handleSubmit" class="space-y-6">
            <fieldset :disabled="readOnly" class="space-y-6">
                <!-- Información Principal -->
                <div class="space-y-4">
                    <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                        Información del Buque</h3>

                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div class="sm:col-span-2">
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre
                                del Buque</label>
                            <input v-model="form.nombreBuque" type="text" required
                                ref="firstInput"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Matrícula</label>
                            <input v-model="form.matricula" type="text" required
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Tipo
                                de Flota</label>
                            <SearchableSelect v-model="form.tipoFlotaId as any" :options="tipoFlotaOptions"
                                placeholder="Seleccione..." />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Puerto
                                Base</label>
                            <SearchableSelect v-model="form.puertoBaseId as any" :options="puertoOptions"
                                placeholder="Seleccione..." />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Código
                                Interno</label>
                            <input v-model.number="form.codigoInterno" type="number"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                    </div>
                </div>

                <!-- Especificaciones Técnicas -->
                <div class="space-y-4 pt-4">
                    <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                        Especificaciones Técnicas</h3>

                    <div class="grid grid-cols-1 sm:grid-cols-4 gap-4">
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Eslora
                                (m)</label>
                            <input v-model.number="form.esloraM" type="number" step="0.01"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Potencia
                                (HP)</label>
                            <input v-model.number="form.potenciaHp" type="number"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Días
                                Marea Est.</label>
                            <input v-model.number="form.diasMareaEstimada" type="number"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            &nbsp;
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Pesquería
                                Habitual</label>
                            <SearchableSelect v-model="form.pesqueriaHabitualId as any" :options="pesqueriaOptions"
                                placeholder="Seleccione..." />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Arte
                                de Pesca Habitual</label>
                            <SearchableSelect v-model="form.arteHabitualId as any" :options="arteOptions"
                                placeholder="Seleccione..." />
                        </div>
                    </div>
                </div>

                <!-- Contacto / Empresa -->
                <div class="space-y-4 pt-4">
                    <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                        Empresa y Armador</h3>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre
                                Empresa</label>
                            <input v-model="form.empresaNombre" type="text"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Localidad
                                Empresa</label>
                            <input v-model="form.empresaLocalidad" type="text"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Nombre
                                Armador</label>
                            <input v-model="form.armadorNombre" type="text"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                        <div>
                            <label
                                class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">Teléfono
                                Armador</label>
                            <input v-model="form.armadorTelefono" type="text"
                                class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all" />
                        </div>
                    </div>
                </div>

                <!-- Calificación del Buque -->
                <div class="space-y-3 pt-2">
                    <div class="flex items-center justify-between border-b border-border pb-2">
                        <h3 class="text-base font-black uppercase tracking-tight text-text">
                            Calificación del Buque
                        </h3>
                        <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-primary/10 text-primary">
                            {{ form.calificacion ?? 0 }} de 5 estrellas
                        </span>
                    </div>

                    <div class="flex flex-wrap items-center gap-4 p-3 bg-surface-muted/60 rounded-xl border border-border">
                        <div class="flex items-center gap-1">
                            <button
                                v-for="star in 5"
                                :key="star"
                                type="button"
                                :disabled="readOnly"
                                @click="setCalificacion(star)"
                                @mouseenter="hoverCalificacion = star"
                                @mouseleave="hoverCalificacion = 0"
                                class="p-1 rounded-md transition-transform hover:scale-110 focus:outline-hidden disabled:cursor-not-allowed disabled:hover:scale-100"
                                :title="`Calificar con ${star} estrella${star > 1 ? 's' : ''}`"
                            >
                                <svg
                                    class="w-6 h-6 transition-colors"
                                    :class="getStarColorClass(star)"
                                    viewBox="0 0 20 20"
                                    fill="currentColor"
                                >
                                    <path
                                        d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"
                                    />
                                </svg>
                            </button>
                        </div>

                        <button
                            v-if="!readOnly"
                            type="button"
                            @click="setCalificacion(0)"
                            class="text-xs font-semibold px-2.5 py-1 rounded-md border border-border text-text-muted hover:text-text hover:bg-surface transition-colors"
                            :class="{ 'opacity-50 pointer-events-none': (form.calificacion ?? 0) === 0 }"
                        >
                            Restablecer a 0
                        </button>

                        <div v-if="(form.calificacion ?? 0) < 3" class="text-xs text-warning flex items-center gap-1.5 font-medium ml-auto">
                            <svg class="w-4 h-4 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                            </svg>
                            <span>Observaciones requeridas (calificación &lt; 3)</span>
                        </div>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                        Observaciones
                        <span v-if="(form.calificacion ?? 0) < 3" class="text-error font-bold ml-1">* Obligatorio por baja calificación</span>
                    </label>
                    <textarea v-model="form.observaciones" rows="3"
                        :required="(form.calificacion ?? 0) < 3"
                        :class="[
                            'w-full rounded-lg border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:outline-hidden focus:ring-3 transition-all',
                            (form.calificacion ?? 0) < 3 && (!form.observaciones || form.observaciones.trim() === '')
                                ? 'border-warning/80 focus:border-warning focus:ring-warning/20'
                                : 'border-border focus:border-primary focus:ring-primary/10'
                        ]"
                        placeholder="Ingrese observaciones pertinentes sobre el buque..."></textarea>
                </div>

                <div class="flex flex-wrap items-center gap-8 pt-2">
                    <!-- Apto Observadoras Mujeres -->
                    <label class="flex items-center gap-3 text-sm font-medium text-text cursor-pointer select-none">
                        <input
                            type="checkbox"
                            v-model="form.habitabilidadFemeninaApta"
                            class="w-5 h-5 rounded-md border-border text-primary focus:ring-primary/20 focus:ring-2 cursor-pointer transition-colors"
                        />
                        <span class="font-bold text-text">Apto para observadoras mujeres</span>
                    </label>

                    <!-- Activo -->
                    <label class="flex items-center gap-3 text-sm font-medium text-text cursor-pointer select-none">
                        <input
                            type="checkbox"
                            v-model="form.activo"
                            class="w-5 h-5 rounded-md border-border text-primary focus:ring-primary/20 focus:ring-2 cursor-pointer transition-colors"
                        />
                        <span class="font-bold text-text">Activo</span>
                    </label>
                </div>
            </fieldset>

            <div class="mt-5 sm:mt-8 sm:grid sm:grid-flow-row-dense sm:grid-cols-2 sm:gap-3">
                <button v-if="!readOnly" type="submit"
                    data-allow-enter
                    class="flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest text-primary-fg transition-all rounded-lg bg-primary shadow-theme-xs hover:bg-primary-hover active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed sm:col-start-2"
                    :disabled="isSaving">
                    {{ isSaving ? 'Guardando...' : 'Guardar' }}
                </button>
                <button type="button" :class="[
                    'mt-3 flex items-center justify-center w-full px-4 py-3 text-xs font-black uppercase tracking-widest transition-all rounded-lg shadow-theme-xs active:scale-95 sm:mt-0',
                    readOnly
                        ? 'bg-primary text-primary-fg hover:bg-primary-hover sm:col-span-2'
                        : 'text-text-muted bg-surface border border-border hover:bg-surface-muted hover:text-text sm:col-start-1'
                ]" @click="emit('close')">
                    {{ readOnly ? 'Cerrar' : 'Cancelar' }}
                </button>
            </div>
        </form>
    </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed, nextTick } from 'vue'
import type { Buque, TipoFlota, Puerto, Pesqueria, ArtePesca } from '../interfaces/buque.interface'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import { toast } from 'vue-sonner'

const props = defineProps<{
    show: boolean
    buque?: Partial<Buque> | null
    isSaving?: boolean
    readOnly?: boolean
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
    calificacion: 3,
    habitabilidadFemeninaApta: false,
    activo: true,
    observaciones: ''
}

const form = ref({ ...initialForm })
const firstInput = ref<HTMLInputElement | null>(null)
const hoverCalificacion = ref(0)

const setCalificacion = (rating: number) => {
    form.value.calificacion = rating
}

const getStarColorClass = (star: number) => {
    const activeVal = hoverCalificacion.value || (form.value.calificacion ?? 0)
    return star <= activeVal ? 'text-amber-400' : 'text-gray-300 dark:text-gray-600'
}

watch(
    () => props.buque,
    (newBuque) => {
        if (newBuque) {
            form.value = {
                ...initialForm,
                ...newBuque,
                calificacion: newBuque.calificacion !== undefined && newBuque.calificacion !== null ? newBuque.calificacion : 3,
                habitabilidadFemeninaApta: newBuque.habitabilidadFemeninaApta ?? false
            }
        } else {
            form.value = { ...initialForm }
        }
        
        if (props.show) {
            nextTick(() => {
                firstInput.value?.focus()
            })
        }
    },
    { immediate: true }
)

watch(() => props.show, (val) => {
    if (val) {
        nextTick(() => {
            firstInput.value?.focus()
        })
    }
})

const handleSubmit = () => {
    const calif = form.value.calificacion ?? 0
    if (calif < 3) {
        if (!form.value.observaciones || form.value.observaciones.trim() === '') {
            toast.error('Para buques con calificación menor a 3 estrellas, es obligatorio ingresar un detalle en Observaciones.')
            return
        }
    }
    emit('save', { ...form.value })
}
</script>
