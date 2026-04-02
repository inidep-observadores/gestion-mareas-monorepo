<template>
    <BaseModal
        :show="show"
        :title="isEditing ? 'Editar Transición de Estado' : 'Nueva Transición de Estado'"
        @close="emit('close')"
        maxWidth="2xl"
    >
        <form @submit.prevent="handleSubmit" class="space-y-5">
            <!-- Estados: Origen → Destino -->
            <div class="space-y-4">
                <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                    Flujo de Transición
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                            Estado Origen
                        </label>
                        <SearchableSelect
                            v-model="form.estadoOrigenId as any"
                            :options="estadoOptions"
                            placeholder="Seleccione estado origen..."
                        />
                    </div>
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                            Estado Destino
                        </label>
                        <SearchableSelect
                            v-model="form.estadoDestinoId as any"
                            :options="estadoOptions"
                            placeholder="Seleccione estado destino..."
                        />
                    </div>
                </div>

                <!-- Preview del flujo -->
                <div v-if="origenNombre || destinoNombre"
                    class="flex items-center gap-3 px-4 py-3 bg-primary/5 border border-primary/10 rounded-xl text-sm">
                    <span class="font-bold text-text truncate max-w-[35%]">{{ origenNombre || '—' }}</span>
                    <ArrowRightIcon class="w-4 h-4 text-primary flex-shrink-0" />
                    <span class="font-bold text-text truncate max-w-[35%]">{{ destinoNombre || '—' }}</span>
                </div>
            </div>

            <!-- Acción y Etiqueta -->
            <div class="space-y-4">
                <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                    Identificación
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                            Código de Acción
                            <span class="text-text-muted/60 normal-case font-normal ml-1">(interno, ej: CANCELAR)</span>
                        </label>
                        <input
                            v-model="form.accion"
                            type="text"
                            required
                            placeholder="REGISTRAR_INICIO"
                            class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text font-mono shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all uppercase"
                            @input="form.accion = (form.accion ?? '').toUpperCase().replace(/\s+/g, '_')"
                        />
                    </div>
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                            Etiqueta del Botón
                            <span class="text-text-muted/60 normal-case font-normal ml-1">(visible al usuario)</span>
                        </label>
                        <input
                            v-model="form.etiqueta"
                            type="text"
                            required
                            placeholder="Confirmar Arribo"
                            class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                        />
                    </div>
                </div>
            </div>

            <!-- Apariencia y Comportamiento -->
            <div class="space-y-4">
                <h3 class="text-base font-black uppercase tracking-tight text-text border-b border-border pb-2">
                    Apariencia y Comportamiento
                </h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-black uppercase tracking-widest text-text-muted mb-1.5">
                            Estilo del Botón
                        </label>
                        <select
                            v-model="form.claseBoton"
                            class="h-11 w-full rounded-lg border border-border bg-surface px-4 py-2.5 text-sm text-text shadow-theme-xs focus:border-primary focus:outline-hidden focus:ring-3 focus:ring-primary/10 transition-all"
                        >
                            <option value="primary">Primary (azul)</option>
                            <option value="secondary">Secondary (gris)</option>
                            <option value="success">Success (verde)</option>
                            <option value="warning">Warning (ámbar)</option>
                            <option value="error">Error / Danger (rojo)</option>
                        </select>
                        <!-- Preview del botón -->
                        <div class="mt-2 flex items-center gap-2">
                            <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">Preview:</span>
                            <span :class="btnPreviewClass" class="px-3 py-1 rounded-lg text-xs font-bold">
                                {{ form.etiqueta || 'Acción' }}
                            </span>
                        </div>
                    </div>
                    <div class="flex flex-col gap-4 justify-center">
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <div class="relative">
                                <input v-model="form.requiereObs" type="checkbox" class="sr-only peer" />
                                <div class="w-10 h-5 bg-surface-muted border border-border rounded-full peer-checked:bg-primary transition-colors"></div>
                                <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5"></div>
                            </div>
                            <div>
                                <span class="text-sm font-bold text-text group-hover:text-primary transition-colors">Requiere observaciones</span>
                                <p class="text-[10px] text-text-muted">El usuario debe ingresar un comentario</p>
                            </div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <div class="relative">
                                <input v-model="form.mostrarEnPanel" type="checkbox" class="sr-only peer" />
                                <div class="w-10 h-5 bg-surface-muted border border-border rounded-full peer-checked:bg-primary transition-colors"></div>
                                <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5"></div>
                            </div>
                            <div>
                                <span class="text-sm font-bold text-text group-hover:text-primary transition-colors">Mostrar en panel</span>
                                <p class="text-[10px] text-text-muted">Aparece como acción en el panel lateral</p>
                            </div>
                        </label>
                        <label class="flex items-center gap-3 cursor-pointer group">
                            <div class="relative">
                                <input v-model="form.activo" type="checkbox" class="sr-only peer" />
                                <div class="w-10 h-5 bg-surface-muted border border-border rounded-full peer-checked:bg-primary transition-colors"></div>
                                <div class="absolute top-0.5 left-0.5 w-4 h-4 bg-white rounded-full shadow transition-transform peer-checked:translate-x-5"></div>
                            </div>
                            <div>
                                <span class="text-sm font-bold text-text group-hover:text-primary transition-colors">Activo</span>
                                <p class="text-[10px] text-text-muted">La transición está disponible en el sistema</p>
                            </div>
                        </label>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="flex justify-end gap-3 pt-2 border-t border-border">
                <button type="button" @click="emit('close')"
                    class="px-4 py-2.5 rounded-lg border border-border text-sm font-bold text-text-muted hover:bg-surface-muted transition-colors">
                    Cancelar
                </button>
                <button type="submit" :disabled="isSaving || !form.estadoOrigenId || !form.estadoDestinoId"
                    class="px-4 py-2.5 rounded-lg bg-primary text-white text-sm font-bold hover:bg-primary/90 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2">
                    <span v-if="isSaving" class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
                    {{ isSaving ? 'Guardando...' : (isEditing ? 'Actualizar' : 'Crear Transición') }}
                </button>
            </div>
        </form>
    </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import type { TransicionEstado, EstadoMareaResumen } from '../interfaces/transicion-estado.interface'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import { ArrowRightIcon } from '@/icons'

const props = defineProps<{
    show: boolean
    transicion: Partial<TransicionEstado> | null
    estados: EstadoMareaResumen[]
    isSaving?: boolean
}>()

const emit = defineEmits(['close', 'save'])

const isEditing = computed(() => !!props.transicion?.id)

const estadoOptions = computed(() =>
    [...props.estados]
        .sort((a, b) => a.orden - b.orden)
        .map(e => ({ value: e.id, label: `${e.nombre} (${e.codigo})` }))
)

const origenNombre = computed(() =>
    props.estados.find(e => e.id === form.value.estadoOrigenId)?.nombre ?? ''
)
const destinoNombre = computed(() =>
    props.estados.find(e => e.id === form.value.estadoDestinoId)?.nombre ?? ''
)

const btnPreviewClass = computed(() => {
    const map: Record<string, string> = {
        primary: 'bg-primary/10 text-primary',
        secondary: 'bg-surface-muted text-text-muted',
        success: 'bg-success/10 text-success',
        warning: 'bg-warning/10 text-warning',
        error: 'bg-error/10 text-error',
    }
    return map[form.value.claseBoton ?? 'primary'] ?? map['primary']
})

const initialForm: Partial<TransicionEstado> = {
    estadoOrigenId: '',
    estadoDestinoId: '',
    accion: '',
    etiqueta: '',
    claseBoton: 'primary',
    requiereObs: false,
    mostrarEnPanel: true,
    activo: true,
}

const form = ref({ ...initialForm })

watch(
    () => props.transicion,
    (val) => {
        form.value = val ? { ...initialForm, ...val } : { ...initialForm }
    },
    { immediate: true }
)

const handleSubmit = () => {
    emit('save', { ...form.value })
}
</script>
