<template>
  <BaseModal
    :show="isOpen"
    @close="close"
    maxWidth="4xl"
    :title="localAlert.titulo"
  >
    <template #title>
        <div class="flex items-center justify-between w-full pr-8 py-1">
            <div class="flex items-center gap-4">
                <span :class="['badge badge-sm rounded-lg py-3 px-3 border-none font-black text-[10px] uppercase tracking-widest', getBadgeClass(localAlert.prioridad)]">
                    {{ localAlert.prioridad }}
                </span>
                <span class="text-base-content font-black uppercase tracking-tight">{{ localAlert.titulo }}</span>
                <span v-if="localAlert.referenciaTipo" :class="['badge badge-sm border-none font-bold text-[10px] uppercase tracking-wider', getOriginBadgeClass(localAlert.referenciaTipo)]">
                    {{ localAlert.referenciaTipo }}
                </span>
            </div>
            <button
                v-if="localAlert.referenciaId"
                @click="goToFullHistory"
                class="btn btn-sm btn-soft btn-neutral gap-2 ml-4"
                title="Ver detalle del origen"
            >
                {{ isMarea ? 'Ir a Marea' : 'Ver' }}
                <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
            </button>
        </div>
    </template>

    <div class="flex flex-col gap-6 py-2">
        <!-- Top Section: Details & Timeline -->
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Main Content (Left) -->
            <div class="flex-1 space-y-6">
              <div class="p-4 bg-base-200/50 border border-base-content/10 rounded-2xl">
                <h4 class="font-black text-[10px] uppercase tracking-widest text-base-content/40 mb-2">Detalles del Incidente</h4>
                <p class="text-sm text-base-content/80 leading-relaxed">{{ localAlert.descripcion }}</p>
                <div class="mt-4 pt-4 border-t border-base-content/10 flex items-center gap-4">
                    <div class="text-[10px] font-bold text-base-content/40 uppercase tracking-tight">ID: <span class="font-mono text-base-content/60">{{ localAlert.codigoUnico }}</span></div>
                    <div class="text-[10px] font-bold text-base-content/40 uppercase tracking-tight">Detectado: <span class="text-base-content/60">{{ formatDate(localAlert.fechaDetectada) }}</span></div>
                </div>
              </div>

              <!-- Action Area -->
              <div v-if="!isClosed" class="space-y-4">
                    <h4 class="font-black text-[10px] uppercase tracking-widest text-base-content/60">Notas de Gestión</h4>
                    <textarea
                        v-model="comment"
                        class="textarea textarea-bordered w-full bg-base-200/50 border-base-content/10 rounded-2xl focus:ring-2 focus:ring-info/30 text-sm h-32"
                        placeholder="Agregar notas de seguimiento, causas o detalles de la resolución..."
                    ></textarea>

                    <!-- Follow Up Date Picker (Moved here to stay contextual) -->
                    <div v-if="showDatePicker || localAlert.estado === 'SEGUIMIENTO'" class="p-4 bg-base-200/50 rounded-2xl border border-base-content/10 animate-in fade-in slide-in-from-top-2">
                        <label class="block text-[10px] font-black uppercase tracking-widest text-base-content/60 mb-3">
                            Fecha de Re-Check
                        </label>
                        <div class="flex flex-wrap gap-2 items-center">
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(3)">3 d.</button>
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(7)">1 sem.</button>
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(15)">15 d.</button>
                            <input type="date" class="input input-xs input-bordered ml-auto font-bold bg-base-200/50 border-base-content/10 text-base-content/80" v-model="customFollowUpDate" />
                        </div>
                    </div>
              </div>

               <div v-else class="flex items-center gap-3 p-4 bg-success/5 text-success rounded-2xl border border-success/10">
                 <CheckIcon class="w-5 h-5" />
                 <span class="text-xs font-bold uppercase tracking-tight">Incidente Cerrado el {{ localAlert.fechaCierre ? formatDate(localAlert.fechaCierre) : 'N/A' }}</span>
               </div>
            </div>

            <!-- Sidebar / Timeline (Right) -->
            <div class="w-full md:w-80 border-l border-base-content/10 pl-8">
                <h4 class="font-black text-[10px] uppercase tracking-widest text-base-content/60 mb-6">Historial de Auditoría</h4>
                <div class="max-h-[450px] overflow-y-auto pr-4 custom-scrollbar">
                    <AlertTimeline :eventos="localAlert.eventos || []" />
                </div>
            </div>
        </div>

        <!-- Unified Actions Row (Bottom) -->
        <div v-if="!isClosed" class="pt-6 border-t border-base-content/10 flex items-center gap-3 w-full">
            <button
                v-if="localAlert.estado !== 'SEGUIMIENTO'"
                class="btn btn-sm btn-soft flex-1"
                @click="startFollowUp"
                :disabled="processing"
            >
                Seguimiento
            </button>

            <button
                 class="btn btn-sm btn-soft btn-error flex-1"
                 @click="updateStatus('DESCARTADA')"
                 :disabled="processing"
            >
                Descartar
            </button>

            <button
                v-if="localAlert.estado === 'SEGUIMIENTO'"
                class="btn btn-sm btn-soft btn-info flex-1"
                @click="updateStatus('SEGUIMIENTO')"
                :disabled="processing"
            >
                Actualizar
            </button>

            <button
                class="btn btn-sm btn-success text-white flex-1"
                @click="updateStatus('RESUELTA')"
                :disabled="processing"
            >
                Resolver
            </button>
        </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { type Alerta, alertsService } from '../services/alerts.service'
import AlertTimeline from './AlertTimeline.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import { toast } from 'vue-sonner'
import { CheckIcon } from '@/icons'

const props = defineProps<{
  isOpen: boolean
  alert: Alerta | null
}>()

const emit = defineEmits(['close', 'refresh'])
const router = useRouter()

const localAlert = ref<Alerta | any>({})
const comment = ref('')
const processing = ref(false)
const targetState = ref('')
const customFollowUpDate = ref('')
const showDatePicker = ref(false)

watch(() => props.alert, (newVal) => {
    if (newVal) {
        localAlert.value = { ...newVal } // Sync immediately
        loadFullAlert(newVal.id)
        if (newVal.fechaVencimiento) {
             customFollowUpDate.value = new Date(newVal.fechaVencimiento).toISOString().split('T')[0]
        }
    }
}, { immediate: true })

const startFollowUp = () => {
    localAlert.value.estado = 'SEGUIMIENTO'
    showDatePicker.value = true
}

const loadFullAlert = async (id: string) => {
    try {
        const full = await alertsService.getOne(id)
        localAlert.value = full
    } catch (e) {
        console.error('Error cargando detalle de alerta:', e)
    }
}

const isClosed = computed(() => ['RESUELTA', 'DESCARTADA'].includes(localAlert.value.estado))

const getBadgeClass = (prio: string) => {
    switch (prio) {
        case 'ALTA': return 'badge-error text-white'
        case 'MEDIA': return 'badge-warning text-white'
        case 'BAJA': return 'badge-info text-white'
        default: return 'badge-ghost'
    }
}

const getOriginBadgeClass = (type: string) => {
    switch (type) {
        case 'MAREA': return 'badge-info bg-info/20 text-info'
        case 'OBSERVADOR': return 'badge-secondary bg-secondary/20 text-secondary'
        case 'BUQUE': return 'badge-accent bg-accent/20 text-accent'
        default: return 'badge-neutral bg-base-content/10 text-base-content/60'
    }
}

const isMarea = computed(() => !localAlert.value.referenciaTipo || localAlert.value.referenciaTipo === 'MAREA')

const goToFullHistory = () => {
    if (localAlert.value.referenciaId) {
        if (isMarea.value) {
            emit('close')
            router.push({
                path: `/mareas/${localAlert.value.referenciaId}`,
                query: { tab: 'historial_alertas' }
            })
        } else {
             toast.info(`Navegación para ${localAlert.value.referenciaTipo} en desarrollo`)
        }
    } else {
        toast.error('No hay una entidad asociada a esta alerta')
    }
}

const updateStatus = async (newState: string) => {
    if (!comment.value.trim() && ['SEGUIMIENTO', 'DESCARTADA', 'RESUELTA'].includes(newState)) {
        toast.error('Debe ingresar una nota de gestion para continuar.')
        return
    }

    targetState.value = newState
    await submitUpdate(newState)
}

const submitUpdate = async (status: string) => {
    try {
        processing.value = true
        let followUp = undefined

        if (status === 'SEGUIMIENTO') {
            const date = customFollowUpDate.value ? new Date(customFollowUpDate.value) : new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)
            followUp = date.toISOString()
        }

        await alertsService.update(localAlert.value.id, {
            estado: status,
            comment: comment.value,
            fechaVencimiento: followUp
        })

        toast.success('Acción procesada con éxito')
        emit('refresh')
        emit('close')
    } catch (e) {
        console.error('Error al actualizar alerta:', e)
        toast.error('Hubo un error al procesar la acción.')
    } finally {
        processing.value = false
        comment.value = ''
        targetState.value = ''
    }
}

const setFollowUp = (days: number) => {
    const d = new Date()
    d.setDate(d.getDate() + days)
    customFollowUpDate.value = d.toISOString().split('T')[0]
}

const close = () => {
    emit('close')
}

const formatDate = (dateStr: string) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    })
}
</script>

<style scoped>
</style>
