<template>
  <dialog :class="['modal', { 'modal-open': isOpen }]">
    <div class="modal-box w-11/12 max-w-3xl flex flex-col gap-4">
      <!-- HEADER -->
      <div class="flex justify-between items-start">
        <div>
          <h3 class="font-bold text-lg flex items-center gap-2">
            <span :class="['badge badge-sm', getBadgeClass(localAlert.prioridad)]">{{ localAlert.prioridad }}</span>
            {{ localAlert.titulo }}
          </h3>
          <p class="text-sm text-base-content/70 mt-1">ID: {{ localAlert.codigoUnico }}</p>
        </div>
        <button class="btn btn-sm btn-circle btn-ghost" @click="close">✕</button>
      </div>

      <!-- BODY -->
      <div class="flex flex-col md:flex-row gap-6">
        <!-- Main Content -->
        <div class="flex-1 space-y-4">
          <div class="alert shadow-sm bg-base-200/50 border border-base-content/10">
            <div>
              <h4 class="font-semibold text-sm mb-1">Descripción del Problema</h4>
              <p class="text-sm">{{ localAlert.descripcion }}</p>
            </div>
          </div>

          <!-- Action Area based on Status -->
          <div v-if="!isClosed" class="card bg-base-100 border border-base-content/10 shadow-sm">
            <div class="card-body p-4">
                <h4 class="card-title text-sm mb-2">Gestionar Incidente</h4>
                
                <textarea 
                    v-model="comment" 
                    class="textarea textarea-bordered w-full" 
                    placeholder="Agregar nota de seguimiento o razón de resolución..."
                ></textarea>

                <div class="flex flex-wrap gap-2 mt-4 justify-end">
                    <button 
                        v-if="localAlert.estado !== 'SEGUIMIENTO'" 
                        class="btn btn-sm" 
                        @click="updateStatus('SEGUIMIENTO')"
                        :disabled="processing"
                    >
                        Iniciar Seguimiento
                    </button>
                    
                    <button 
                        class="btn btn-sm btn-success text-white" 
                        @click="updateStatus('RESUELTA')"
                        :disabled="processing"
                    >
                        Marca como Resuelta
                    </button>

                    <button 
                         class="btn btn-sm btn-error btn-outline" 
                         @click="updateStatus('DESCARTADA')"
                         :disabled="processing"
                    >
                        Descartar
                    </button>
                </div>

                <!-- Follow Up Date Picker (Only visible if Follow Up selected or active) -->
                 <div v-if="localAlert.estado === 'SEGUIMIENTO' || targetState === 'SEGUIMIENTO'" class="mt-4 pt-4 border-t border-base-content/10">
                    <label class="label">
                        <span class="label-text">Recordar revisar en:</span>
                    </label>
                    <div class="join">
                        <button class="join-item btn btn-sm" @click="setFollowUp(3)">3 días</button>
                        <button class="join-item btn btn-sm" @click="setFollowUp(7)">1 semana</button>
                        <button class="join-item btn btn-sm" @click="setFollowUp(15)">15 días</button>
                        <input type="date" class="join-item input input-sm input-bordered" v-model="customFollowUpDate" />
                    </div>
                </div>
            </div>
          </div>
          
           <div v-else class="alert alert-success shadow-sm">
             <span>Esta alerta fue cerrada el {{ new Date(localAlert.fechaCierre!).toLocaleDateString() }}</span>
           </div>

        </div>

        <!-- Sidebar / Timeline -->
        <div class="w-full md:w-80 border-l border-base-content/10 pl-6">
            <h4 class="font-semibold text-sm mb-4">Historial de Eventos</h4>
            <div class="max-h-[400px] overflow-y-auto pr-2">
                <AlertTimeline :eventos="localAlert.eventos || []" />
            </div>
        </div>
      </div>
    </div>
  </dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { type Alerta, alertsService } from '../services/alerts.service'
import AlertTimeline from './AlertTimeline.vue'

const props = defineProps<{
  isOpen: boolean
  alert: Alerta | null
}>()

const emit = defineEmits(['close', 'refresh'])

const localAlert = ref<Alerta | any>({})
const comment = ref('')
const processing = ref(false)
const targetState = ref('')
const customFollowUpDate = ref('')

watch(() => props.alert, (newVal) => {
    if (newVal) {
        // Fetch full details including timeline
        loadFullAlert(newVal.id)
    }
}, { immediate: true })

const loadFullAlert = async (id: string) => {
    try {
        localAlert.value = await alertsService.getOne(id)
    } catch (e) {
        console.error(e)
    }
}

const isClosed = computed(() => ['RESUELTA', 'DESCARTADA'].includes(localAlert.value.estado))

const getBadgeClass = (prio: string) => {
    switch (prio) {
        case 'ALTA': return 'badge-error'
        case 'MEDIA': return 'badge-warning'
        case 'BAJA': return 'badge-info'
        default: return 'badge-ghost'
    }
}

const updateStatus = async (newState: string) => {
    if (!comment.value && newState === 'DESCARTADA') {
        alert('Por favor ingrese un motivo para descartar.')
        return
    }
    
    targetState.value = newState
    
    // If setting to FOLLOW UP, we might wait for date selection if needed, 
    // but for simplicity let's assume default 7 days if not picked, or handle mainly via button
    if (newState === 'SEGUIMIENTO') {
        // Just local state change to show date picker, not submit yet?
        // Let's make it direct for now or logic to require date?
        // For MVP: Apply direct with default or wait?
        // Let's apply with default 7 days if not set
    } 
    
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
        
        emit('refresh')
        emit('close')
    } catch (e) {
        console.error(e)
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

const close = () => emit('close')

</script>
