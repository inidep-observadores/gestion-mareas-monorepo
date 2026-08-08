<template>
    <BaseModal :show="show" title="Historial del Observador" @close="emit('close')" maxWidth="2xl" variant="default">
        <div class="flex flex-col h-[70vh]">
            <!-- Header Info -->
            <div class="px-6 py-4 bg-surface-muted/30 border-b border-border flex items-center gap-4 shrink-0">
                <div
                    class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center border border-primary/20">
                    <span class="text-sm font-black text-primary">{{ initials }}</span>
                </div>
                <div class="flex-1 min-w-0">
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <h2 class="text-base font-black text-text uppercase tracking-tight leading-none">{{
                                observadorName }}</h2>
                            <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter mt-1">
                                Historial Completo
                            </p>
                        </div>

                        <!-- Botón Editar (Solo ícono) -->
                        <button v-if="canManageObservations && observador && !isEditing" @click="startEditing"
                            class="p-2 hover:bg-primary/10 text-primary rounded-lg transition-colors shrink-0"
                            title="Editar observaciones">
                            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                            </svg>
                        </button>
                    </div>

                    <!-- Modo Vista / Edición de Observaciones -->
                    <div v-if="isEditing" class="mt-3 flex flex-col gap-2 max-w-sm">
                        <textarea v-model="tempObservaciones"
                            class="w-full bg-surface border border-primary/30 rounded-xl p-3 text-[10px] font-medium text-text focus:outline-none focus:ring-2 focus:ring-primary/20 min-h-[80px] custom-scrollbar"
                            placeholder="Escriba aquí las observaciones..."></textarea>
                        <div class="flex justify-end gap-2">
                            <button @click="isEditing = false"
                                class="px-3 py-1.5 text-[9px] font-black uppercase tracking-widest text-text-muted hover:bg-surface-muted rounded-lg transition-colors">
                                Cancelar
                            </button>
                            <button @click="saveObservaciones" :disabled="saving"
                                class="px-4 py-1.5 bg-primary text-white text-[9px] font-black uppercase tracking-widest rounded-lg hover:bg-primary-hover transition-all disabled:opacity-50">
                                {{ saving ? 'Guardando...' : 'Guardar' }}
                            </button>
                        </div>
                    </div>
                    <p v-else-if="canManageObservations && observador?.observaciones"
                        class="text-[10px] font-medium text-text-muted italic mt-2 leading-tight max-w-sm border-l-2 border-primary/20 pl-2">
                        {{ observador.observaciones }}
                    </p>
                </div>
            </div>

            <!-- Timeline Content -->
            <ObservadorTimeline :observador-id="observadorId || null" class="flex-1 min-h-0" />

            <!-- Footer Actions -->
            <div class="p-4 border-t border-border flex justify-end shrink-0">
                <button @click="emit('close')"
                    class="px-6 py-2.5 bg-surface text-text-muted text-[10px] font-black uppercase tracking-widest rounded-xl border border-border hover:bg-surface-muted transition-all">
                    Cerrar
                </button>
            </div>
        </div>
    </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import ObservadorTimeline from './ObservadorTimeline.vue'
import observadoresApi from '../services/observadores.service'
import { toast } from 'vue-sonner'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const props = defineProps<{
    show: boolean
    observadorId?: string | null
    observadorName?: string
}>()

const emit = defineEmits(['close', 'refresh'])

const observador = ref<any>(null)

const authStore = useAuthStore()
const canManageObservations = computed(() => {
    return authStore.user?.roles.some(role =>
        [ValidRoles.admin, ValidRoles.coordinador].includes(role)
    ) ?? false
})

// Edición de Observaciones
const isEditing = ref(false)
const saving = ref(false)
const tempObservaciones = ref('')

const startEditing = () => {
    tempObservaciones.value = observador.value?.observaciones || ''
    isEditing.value = true
}

const saveObservaciones = async () => {
    if (!props.observadorId || !observador.value) return

    saving.value = true
    try {
        const updated = await observadoresApi.updateObservador(props.observadorId, {
            observaciones: tempObservaciones.value
        })
        observador.value.observaciones = updated.observaciones
        isEditing.value = false
        toast.success('Observaciones actualizadas correctamente')
        emit('refresh')
    } catch (error) {
        console.error('Error al guardar observaciones:', error)
        toast.error('No se pudieron guardar las observaciones')
    } finally {
        saving.value = false
    }
}

const initials = computed(() => {
    if (!props.observadorName) return '?'
    return props.observadorName
        .split(' ')
        .filter(Boolean)
        .map(n => n[0])
        .join('')
        .slice(0, 2)
        .toUpperCase()
})

const loadObservadorInfo = async () => {
    if (!props.observadorId) return
    try {
        observador.value = await observadoresApi.getObservador(props.observadorId)
    } catch (error) {
        console.error('Error cargando información del observador:', error)
        toast.error('No se pudo cargar la información del observador')
    }
}

watch(() => props.show, (newShow) => {
    if (newShow) {
        loadObservadorInfo()
    } else {
        observador.value = null
        isEditing.value = false
        tempObservaciones.value = ''
    }
}, { immediate: true })

</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
    background: var(--color-border);
    border-radius: 10px;
}
</style>
