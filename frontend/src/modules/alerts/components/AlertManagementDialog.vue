<template>
  <BaseModal
    :show="isOpen"
    @close="close"
    maxWidth="4xl"
    :title="localAlert.titulo || ''"
  >
    <template #title>
        <div class="flex items-center justify-between w-full pr-8 py-1">
            <div class="flex items-center gap-4">
                <span :class="['badge badge-sm rounded-lg py-3 px-3 border-none font-black text-[10px] uppercase tracking-widest', getBadgeClass(localAlert.prioridad)]">
                    {{ localAlert.prioridad || 'N/D' }}
                </span>
                <span class="text-base-content font-black uppercase tracking-tight">{{ localAlert.titulo || 'Alerta' }}</span>
                <span v-if="localAlert.referenciaTipo" :class="['badge badge-sm border-none font-bold text-[10px] uppercase tracking-wider', getOriginBadgeClass(localAlert.referenciaTipo)]">
                    {{ localAlert.referenciaTipo || 'N/D' }}
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
                <div v-if="isMarea" class="mt-4 pt-4 border-t border-base-content/10 space-y-2">
                    <div class="text-[10px] font-bold text-base-content/40 uppercase tracking-tight">
                        Marea: <span class="text-base-content/70">{{ mareaLabel }}</span>
                    </div>
                    <div class="text-[10px] font-bold text-base-content/40 uppercase tracking-tight">
                        Observadores: <span class="text-base-content/70">{{ mareaObserversLabel }}</span>
                    </div>
                </div>
              </div>

              <!-- Action Area -->
              <div v-if="!isClosed" class="space-y-4">
                    <div v-if="isClaimableAlert" class="flex items-center justify-between p-4 bg-base-200/50 border border-base-content/10 rounded-2xl">
                        <div>
                            <p class="text-xs font-black uppercase tracking-widest text-base-content/60">Reclamo de Documentación</p>
                            <p class="text-[11px] text-base-content/50 mt-1">Disponible para alertas por retraso en entrega de datos.</p>
                        </div>
                        <button
                            class="btn btn-sm btn-soft btn-info"
                            @click="openReclamo"
                            :disabled="processing || reclamoLoading"
                        >
                            {{ reclamoLoading ? 'Cargando...' : 'Enviar Reclamo' }}
                        </button>
                    </div>
                    <h4 class="font-black text-[10px] uppercase tracking-widest text-base-content/60">Notas de Gestión</h4>
                    <textarea
                        v-model="comment"
                        class="textarea textarea-bordered w-full bg-base-200/50 border-base-content/10 rounded-2xl focus:ring-2 focus:ring-info/30 text-sm h-32"
                        placeholder="Agregar notas de seguimiento, causas o detalles de la resolución..."
                    ></textarea>

                    <!-- Follow Up Date Picker -->
                    <div class="p-4 bg-base-200/50 rounded-2xl border border-base-content/10 animate-in fade-in slide-in-from-top-2">
                        <label class="block text-[10px] font-black uppercase tracking-widest text-base-content/60 mb-3">
                            Fecha de Re-Check
                        </label>
                        <div class="flex flex-wrap gap-2 items-center">
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(recheckCorto)">3 d.</button>
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(recheckMedio)">1 sem.</button>
                            <button class="btn btn-xs btn-soft btn-neutral" @click="setFollowUp(recheckLargo)">15 d.</button>
                            <input
                                type="date"
                                class="input input-xs input-bordered ml-auto font-bold bg-base-200/50 border-base-content/10 text-base-content/80"
                                v-model="customFollowUpDate"
                                :min="minFollowUpDate"
                            />
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
                <div class="max-h-112.5 overflow-y-auto pr-4 custom-scrollbar">
                    <AlertTimeline :eventos="localAlert.eventos || []" />
                </div>
            </div>
        </div>

        <!-- Unified Actions Row (Bottom) -->
        <div v-if="!isClosed" class="pt-6 border-t border-base-content/10 flex items-center gap-3 w-full">
            <button
                class="btn btn-sm btn-soft flex-1"
                @click="requestConfirmation('SEGUIMIENTO')"
                :disabled="processing"
            >
                Seguimiento
            </button>

            <button
                 class="btn btn-sm btn-soft btn-error flex-1"
                 @click="requestConfirmation('DESCARTADA')"
                 :disabled="processing"
            >
                Descartar
            </button>

            <button
                class="btn btn-sm btn-success text-white flex-1"
                @click="requestConfirmation('RESUELTA')"
                :disabled="processing"
            >
                Resolver
            </button>
        </div>
    </div>
  </BaseModal>

  <ReclamoEntregaDialog
    :show="showReclamoDialog"
    :id="reclamoData?.id || ''"
    :marea-id="reclamoData?.mareaId || ''"
    :vessel-name="reclamoData?.vesselName || ''"
    :obs-name="reclamoData?.obsName || ''"
    :email="reclamoData?.email || null"
    :delay-days="reclamoData?.delayDays || 0"
    :arrival-date="reclamoData?.arrivalDate || ''"
    @close="showReclamoDialog = false"
    @confirm="handleReclamoConfirm"
  />

  <BaseModal
    :show="isConfirmationOpen"
    @close="closeConfirmation"
    maxWidth="xl"
    title="Confirmar acción"
  >
    <div class="space-y-5">
      <p class="text-sm text-base-content/80 leading-relaxed">{{ confirmationMessage }}</p>
      <div class="flex items-center gap-3 justify-end">
        <button class="btn btn-sm btn-soft btn-neutral" @click="closeConfirmation">Cancelar</button>
        <button class="btn btn-sm btn-primary" @click="confirmAction" :disabled="processing">Confirmar</button>
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
import dashboardService from '@/modules/dashboard/services/dashboard.service'
import ReclamoEntregaDialog from '@/modules/dashboard/components/ReclamoEntregaDialog.vue'
import mareasService from '@/modules/mareas/services/mareas.service'
import { storeToRefs } from 'pinia'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'

const props = defineProps<{
  isOpen: boolean
  alert: Alerta | null
}>()

const emit = defineEmits(['close', 'refresh'])
const router = useRouter()

type AlertMetadata = {
  mareaCode?: string
  vessel?: string
  busDays?: number
  observerName?: string
  days?: number
}

type LocalAlert = Partial<Alerta> & { metadata?: AlertMetadata }

type Observador = {
  nombre?: string
  apellido?: string
  email?: string
}

type MareaEtapaObservador = {
  rol?: string
  observador?: Observador
}

type MareaEtapa = {
  fechaArribo?: string | null
  observadores?: MareaEtapaObservador[]
}

type MareaData = {
  id?: string
  anioMarea?: number
  nroMarea?: number
  tipoMarea?: string
  buque?: { nombreBuque?: string }
  etapas?: MareaEtapa[]
}

const localAlert = ref<LocalAlert>({})
const comment = ref('')
const processing = ref(false)
const customFollowUpDate = ref('')
const showReclamoDialog = ref(false)
const reclamoLoading = ref(false)
const reclamoData = ref<{
  id: string
  mareaId: string
  vesselName: string
  obsName: string
  email?: string | null
  delayDays: number
  arrivalDate?: string
} | null>(null)
const isConfirmationOpen = ref(false)
const pendingAction = ref<'SEGUIMIENTO' | 'DESCARTADA' | 'RESUELTA' | ''>('')
const confirmationMessage = ref('')
const mareaObservers = ref<string[]>([])
const businessRulesStore = useBusinessRulesStore()
const { rules } = storeToRefs(businessRulesStore)
const recheckCorto = computed(() => rules.value.PLAZO_RECHECK_CORTO || 0)
const recheckMedio = computed(() => rules.value.PLAZO_RECHECK_MEDIO || 0)
const recheckLargo = computed(() => rules.value.PLAZO_RECHECK_LARGO || 0)

const getTomorrow = () => {
    const tomorrow = new Date()
    tomorrow.setDate(tomorrow.getDate() + 1)
    tomorrow.setHours(0, 0, 0, 0)
    return tomorrow
}

const minFollowUpDate = computed(() => getTomorrow().toISOString().split('T')[0])

const setDefaultFollowUpDate = (dateStr?: string | null) => {
    const minDate = getTomorrow()
    if (dateStr) {
        const parsed = new Date(dateStr)
        if (!Number.isNaN(parsed.getTime()) && parsed >= minDate) {
            customFollowUpDate.value = parsed.toISOString().split('T')[0]
            return
        }
    }

    const fallback = new Date()
    fallback.setDate(fallback.getDate() + (recheckMedio.value || 0))
    customFollowUpDate.value = fallback.toISOString().split('T')[0]
}

watch(() => props.alert, (newVal) => {
    if (newVal) {
        localAlert.value = { ...newVal } // Sync immediately
        comment.value = ''
        loadFullAlert(newVal.id)
        setDefaultFollowUpDate(newVal.fechaVencimiento || null)
        if (newVal.referenciaTipo === 'MAREA' && newVal.referenciaId) {
            loadMareaObservers(newVal.referenciaId)
        } else {
            mareaObservers.value = []
        }
    }
}, { immediate: true })

watch(() => props.isOpen, (isOpen) => {
    if (!isOpen) {
        comment.value = ''
        customFollowUpDate.value = ''
        isConfirmationOpen.value = false
        pendingAction.value = ''
        confirmationMessage.value = ''
    }
})

const loadFullAlert = async (id: string) => {
    try {
        const full = await alertsService.getOne(id)
        localAlert.value = full
        setDefaultFollowUpDate(full?.fechaVencimiento || null)
    } catch (e) {
        console.error('Error cargando detalle de alerta:', e)
    }
}

const isClosed = computed(() => ['RESUELTA', 'DESCARTADA'].includes(localAlert.value.estado ?? ''))
const isClaimableAlert = computed(() => localAlert.value?.tipo === 'RETRASO_DATOS' && localAlert.value?.referenciaId)
const mareaLabel = computed(() => localAlert.value?.metadata?.mareaCode || localAlert.value?.referenciaId || 'N/D')
const mareaObserversLabel = computed(() => mareaObservers.value.length ? mareaObservers.value.join(', ') : 'Sin asignar')

const getBadgeClass = (prio?: string) => {
    switch (prio || '') {
        case 'ALTA': return 'badge-error text-white'
        case 'MEDIA': return 'badge-warning text-white'
        case 'BAJA': return 'badge-info text-white'
        default: return 'badge-ghost'
    }
}

const getOriginBadgeClass = (type?: string) => {
    switch (type || '') {
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

const buildMareaCode = (marea?: MareaData | null) => {
    if (!marea) return ''
    const yearSuffix = String(marea.anioMarea || '').slice(-2)
    return `${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${yearSuffix}`
}

const getPrimaryObserver = (etapa?: MareaEtapa | null) => {
    if (!etapa?.observadores?.length) return null
    return etapa.observadores.find((o) => o.rol === 'PRINCIPAL') || etapa.observadores[0]
}

const formatShortDate = (dateStr?: string | Date | null) => {
    if (!dateStr) return ''
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    })
}

const resolveDelayDays = (arrivalDate?: string | null, fallback?: number) => {
    if (typeof fallback === 'number') return fallback
    if (!arrivalDate) return 0
    const arrival = new Date(arrivalDate)
    const now = new Date()
    arrival.setHours(0, 0, 0, 0)
    now.setHours(0, 0, 0, 0)
    return Math.max(0, Math.floor((now.getTime() - arrival.getTime()) / (1000 * 60 * 60 * 24)))
}

const loadReclamoData = async () => {
    if (!localAlert.value?.referenciaId) return
    reclamoLoading.value = true
    try {
        const marea = await mareasService.getById(localAlert.value.referenciaId) as MareaData
        const etapas = marea?.etapas || []
        const etapaActual = etapas[etapas.length - 1]
        const primaryObs = getPrimaryObserver(etapaActual)
        const obs = primaryObs?.observador || {}
        const metadata = localAlert.value?.metadata || {}
        const arrivalDateRaw = etapaActual?.fechaArribo || null

        reclamoData.value = {
            id: marea?.id || localAlert.value.referenciaId,
            mareaId: metadata.mareaCode || buildMareaCode(marea),
            vesselName: metadata.vessel || marea?.buque?.nombreBuque || 'Sin asignar',
            obsName: obs?.nombre ? `${obs.nombre} ${obs.apellido}` : 'Sin asignar',
            email: obs?.email || null,
            delayDays: resolveDelayDays(arrivalDateRaw, typeof metadata.busDays === 'number' ? metadata.busDays : undefined),
            arrivalDate: formatShortDate(arrivalDateRaw)
        }
    } catch (e) {
        console.error('Error cargando datos para reclamo:', e)
        toast.error('No se pudo cargar la información para el reclamo.')
    } finally {
        reclamoLoading.value = false
    }
}

const loadMareaObservers = async (mareaId: string) => {
    try {
        const marea = await mareasService.getById(mareaId) as MareaData
        const etapas = marea?.etapas || []
        const names = new Set<string>()

        etapas.forEach((etapa: MareaEtapa) => {
            const observadores = etapa?.observadores || []
            observadores.forEach((o: MareaEtapaObservador) => {
                const obs = o?.observador
                if (obs?.nombre && obs?.apellido) {
                    names.add(`${obs.nombre} ${obs.apellido}`)
                }
            })
        })

        mareaObservers.value = Array.from(names)
    } catch (e) {
        console.error('Error cargando observadores de la marea:', e)
        mareaObservers.value = []
    }
}

const openReclamo = async () => {
    if (!reclamoData.value) {
        await loadReclamoData()
    }
    if (reclamoData.value) {
        showReclamoDialog.value = true
    }
}

const handleReclamoConfirm = async (payload: { to: string; body: string; mareaId: string; id: string }) => {
    try {
        await dashboardService.sendClaim(payload)
        toast.success('Se envió el reclamo correctamente.')

        if (localAlert.value?.id) {
            const note = `Se envió un reclamo de documentación por correo electrónico el ${formatShortDate(new Date())}.`
            await alertsService.update(localAlert.value.id, { comment: note })
            await loadFullAlert(localAlert.value.id)
            emit('refresh')
        }
    } catch (error) {
        console.error('Error enviando reclamo:', error)
        toast.error('No se pudo enviar el reclamo.')
    } finally {
        showReclamoDialog.value = false
        reclamoData.value = null
    }
}

const requestConfirmation = (newState: 'SEGUIMIENTO' | 'DESCARTADA' | 'RESUELTA') => {
    if (!comment.value.trim() && ['SEGUIMIENTO', 'DESCARTADA', 'RESUELTA'].includes(newState)) {
        toast.error('Debe ingresar una nota de gestión para continuar.')
        return
    }

    pendingAction.value = newState
    confirmationMessage.value = buildConfirmationMessage(newState)
    isConfirmationOpen.value = true
}

const buildConfirmationMessage = (state: 'SEGUIMIENTO' | 'DESCARTADA' | 'RESUELTA') => {
    if (state === 'SEGUIMIENTO') {
        return 'Si confirma, la alerta quedará en seguimiento y continuará visible en la lista de alertas de atención inmediata. Seleccione esta opción si la situación aún no está resuelta.'
    }

    if (state === 'DESCARTADA') {
        return 'Si confirma, la alerta se descartará y se dará por concluida. Dejará de aparecer en la lista de alertas de atención inmediata. Si la situación aún no está resuelta, seleccione la opción de seguimiento para mantenerla vigente.'
    }

    return 'Si confirma, la alerta se marcará como resuelta y se dará por concluida. Dejará de aparecer en la lista de alertas de atención inmediata. Si la situación aún no está resuelta, seleccione la opción de seguimiento para mantenerla vigente.'
}

const closeConfirmation = () => {
    isConfirmationOpen.value = false
    pendingAction.value = ''
}

const confirmAction = async () => {
    if (!pendingAction.value) return
    const action = pendingAction.value
    if (action === 'SEGUIMIENTO') {
        const minDate = getTomorrow()
        const selected = customFollowUpDate.value ? new Date(customFollowUpDate.value) : null
        if (!selected || Number.isNaN(selected.getTime()) || selected < minDate) {
            toast.error('La fecha de re-check debe ser desde mañana en adelante.')
            setDefaultFollowUpDate(null)
            return
        }
    }
    closeConfirmation()
    await submitUpdate(action)
}

const submitUpdate = async (status: string) => {
    try {
        processing.value = true
        let followUp = undefined

        if (status === 'SEGUIMIENTO') {
            const date = customFollowUpDate.value
                ? new Date(customFollowUpDate.value)
                : new Date(Date.now() + (recheckMedio.value || 0) * 24 * 60 * 60 * 1000)
            followUp = date.toISOString()
        }

        if (!localAlert.value.id) {
            toast.error('No se pudo actualizar la alerta seleccionada.')
            return
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
    }
}

const setFollowUp = (days: number) => {
    const d = new Date()
    d.setDate(d.getDate() + days)
    customFollowUpDate.value = d.toISOString().split('T')[0]
}

const close = () => {
    comment.value = ''
    customFollowUpDate.value = ''
    isConfirmationOpen.value = false
    pendingAction.value = ''
    confirmationMessage.value = ''
    emit('close')
}

const formatDate = (dateStr?: string) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    })
}
</script>

<style scoped>
</style>
