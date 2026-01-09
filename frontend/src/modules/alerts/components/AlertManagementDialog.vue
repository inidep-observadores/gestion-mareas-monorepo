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
                <span class="text-gray-900 dark:text-white font-black uppercase tracking-tight">{{ localAlert.titulo }}</span>
            </div>
            <button 
                v-if="localAlert.referenciaId"
                @click="goToFullHistory"
                class="btn btn-sm btn-soft btn-primary gap-2 ml-4"
                title="Ver historial completo en la marea"
            >
                Ir a Marea
                <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
            </button>
        </div>
    </template>

    <div class="flex flex-col md:flex-row gap-8 py-2">
        <!-- Main Content -->
        <div class="flex-1 space-y-6">
          <div class="p-4 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl">
            <h4 class="font-black text-[10px] uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-2">Detalles del Incidente</h4>
            <p class="text-sm text-gray-700 dark:text-gray-300 leading-relaxed">{{ localAlert.descripcion }}</p>
            <div class="mt-4 pt-4 border-t border-gray-200 dark:border-gray-700 flex items-center gap-4">
                <div class="text-[10px] font-bold text-gray-400 dark:text-gray-500">ID: <span class="font-mono">{{ localAlert.codigoUnico }}</span></div>
                <div class="text-[10px] font-bold text-gray-400 dark:text-gray-500">Detectado: {{ formatDate(localAlert.fechaDetectada) }}</div>
            </div>
          </div>

          <!-- Action Area -->
          <div v-if="!isClosed" class="space-y-4">
                <h4 class="font-black text-[10px] uppercase tracking-widest text-brand-500 dark:text-brand-400">Gestionar Resolución</h4>
                
                <textarea 
                    v-model="comment" 
                    class="textarea textarea-bordered w-full bg-gray-50 dark:bg-gray-900 border-gray-200 dark:border-gray-800 rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-sm h-24 text-gray-900 dark:text-white placeholder:text-gray-400" 
                    placeholder="Agregar notas de seguimiento, causas o detalles de la resolución..."
                ></textarea>

                <div class="flex flex-wrap gap-2 justify-end">
                    <!-- Botones Principales -->
                    <button 
                        v-if="localAlert.estado !== 'SEGUIMIENTO'" 
                        class="btn btn-sm btn-ghost"
                        @click="startFollowUp"
                        :disabled="processing"
                    >
                        Iniciar Seguimiento
                    </button>

                    <button 
                         class="btn btn-sm btn-outline btn-error"
                         @click="updateStatus('DESCARTADA')"
                         :disabled="processing"
                    >
                        Descartar Alerta
                    </button>

                    <button 
                        v-if="localAlert.estado === 'SEGUIMIENTO'"
                        class="btn btn-sm btn-primary"
                        @click="updateStatus('SEGUIMIENTO')"
                        :disabled="processing"
                    >
                        Actualizar Seguimiento
                    </button>

                    <button 
                        class="btn btn-sm btn-success text-white px-6"
                        @click="updateStatus('RESUELTA')"
                        :disabled="processing"
                    >
                        Marcar como Resuelta
                    </button>
                </div>

                <!-- Follow Up Date Picker -->
                 <div v-if="showDatePicker || localAlert.estado === 'SEGUIMIENTO'" class="mt-4 p-4 bg-brand-50 dark:bg-brand-900/10 rounded-2xl border border-brand-100 dark:border-brand-500/20 animate-in fade-in slide-in-from-top-2">
                    <label class="block text-[10px] font-black uppercase tracking-widest text-brand-600 dark:text-brand-400 mb-3">
                        Fecha de Re-Check (Escalado automático si no se resuelve)
                    </label>
                    <div class="flex flex-wrap gap-2 items-center">
                        <button class="btn btn-xs bg-brand-100 text-brand-700 hover:bg-brand-200 dark:bg-brand-500/20 dark:text-brand-300 dark:hover:bg-brand-500/30 border-none" @click="setFollowUp(3)">3 días</button>
                        <button class="btn btn-xs bg-brand-100 text-brand-700 hover:bg-brand-200 dark:bg-brand-500/20 dark:text-brand-300 dark:hover:bg-brand-500/30 border-none" @click="setFollowUp(7)">1 semana</button>
                        <button class="btn btn-xs bg-brand-100 text-brand-700 hover:bg-brand-200 dark:bg-brand-500/20 dark:text-brand-300 dark:hover:bg-brand-500/30 border-none" @click="setFollowUp(15)">15 días</button>
                        <input type="date" class="input input-xs input-bordered ml-auto font-bold bg-white dark:bg-gray-800 text-gray-900 dark:text-white border-gray-200 dark:border-gray-700" v-model="customFollowUpDate" />
                    </div>
                </div>
          </div>
          
           <div v-else class="flex items-center gap-3 p-4 bg-green-50 dark:bg-green-500/10 text-green-700 dark:text-green-400 rounded-2xl border border-green-100 dark:border-green-500/20">
             <CheckIcon class="w-5 h-5" />
             <span class="text-xs font-bold uppercase tracking-tight">Incidente Cerrado el {{ localAlert.fechaCierre ? formatDate(localAlert.fechaCierre) : 'N/A' }}</span>
           </div>
        </div>

        <!-- Sidebar / Timeline -->
        <div class="w-full md:w-80 border-l border-gray-200 dark:border-gray-800 pl-8">
            <h4 class="font-black text-[10px] uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-6">Historial de Auditoría</h4>
            <div class="max-h-[500px] overflow-y-auto pr-4 custom-scrollbar">
                <AlertTimeline :eventos="localAlert.eventos || []" />
            </div>
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
        case 'ALTA': return 'bg-red-500 text-white shadow-lg shadow-red-500/20'
        case 'MEDIA': return 'bg-amber-500 text-white shadow-lg shadow-amber-500/20'
        case 'BAJA': return 'bg-blue-500 text-white shadow-lg shadow-blue-500/20'
        default: return 'bg-gray-500 text-white'
    }
}

const goToFullHistory = () => {
    if (localAlert.value.referenciaId) {
        emit('close')
        router.push({ 
            path: `/mareas/${localAlert.value.referenciaId}`,
            query: { tab: 'historial_alertas' }
        })
    } else {
        toast.error('No hay una marea asociada a esta alerta')
    }
}

const updateStatus = async (newState: string) => {
    if (!comment.value && newState === 'DESCARTADA') {
        toast.error('Por favor ingrese un motivo para descartar.')
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
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(0,0,0,0.1);
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(255,255,255,0.1);
}
</style>
