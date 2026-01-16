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
                <Badge
                  :color="getBadgeColor(localAlert.prioridad)"
                  variant="solid"
                  size="sm"
                  class="font-black text-[10px] uppercase tracking-widest px-3 py-2.5 rounded-lg"
                >
                    {{ localAlert.prioridad || 'N/D' }}
                </Badge>
                <span class="text-text font-black uppercase tracking-tight">{{ localAlert.titulo || 'Alerta' }}</span>
                <Badge
                  v-if="localAlert.referenciaTipo"
                  :color="getOriginBadgeColor(localAlert.referenciaTipo)"
                  variant="light"
                  size="sm"
                  class="font-bold text-[10px] uppercase tracking-wider h-6"
                >
                    {{ localAlert.referenciaTipo || 'N/D' }}
                </Badge>
            </div>
            <Button
                v-if="localAlert.referenciaId"
                @click="goToFullHistory"
                variant="soft"
                size="sm"
                class="gap-2 ml-4 text-[11px] font-bold"
                title="Ver detalle del origen"
            >
                {{ isMarea ? 'Ir a Marea' : 'Ver' }}
                <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/><polyline points="15 3 21 3 21 9"/><line x1="10" y1="14" x2="21" y2="3"/></svg>
            </Button>
        </div>
    </template>

    <div class="flex flex-col gap-6 py-2">
        <!-- Top Section: Details & Timeline -->
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Main Content (Left) -->
            <div class="flex-1 space-y-6">
              <div class="p-4 bg-surface-muted/50 border border-border rounded-2xl">
                <h4 class="font-black text-[10px] uppercase tracking-widest text-text-muted mb-2">Detalles del Incidente</h4>
                <p class="text-sm text-text/80 leading-relaxed">{{ localAlert.descripcion }}</p>

                <!-- Incongruency Diff Table -->
                <div v-if="isIncongruency && incongruencyData" class="mt-4 bg-surface border border-border rounded-xl overflow-hidden">
                    <table class="w-full text-xs">
                        <thead>
                            <tr class="bg-surface-muted/50 border-b border-border">
                                <th class="px-3 py-2 text-left font-black text-text-muted uppercase tracking-wider text-[10px]">Dato</th>
                                <th class="px-3 py-2 text-left font-black text-text-muted uppercase tracking-wider text-[10px]">Sistema Local</th>
                                <th class="px-3 py-2 text-left font-black text-text-muted uppercase tracking-wider text-[10px]">Access (Externo)</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-border">
                            <tr v-for="field in incongruencyFields" :key="field.key" :class="{ 'bg-error/5': field.hasDiff }">
                                <td class="px-3 py-2 font-bold text-text-muted">{{ field.label }}</td>
                                <td class="px-3 py-2 font-mono text-text">
                                    {{ field.localVal || 'N/D' }}
                                </td>
                                <td class="px-3 py-2 font-mono" :class="field.hasDiff ? 'text-error font-bold' : 'text-text'">
                                    {{ field.externalVal || 'N/D' }}
                                    <span v-if="field.hasDiff" class="ml-1 text-[9px] text-error bg-error/10 px-1 rounded">DIFERENTE</span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="mt-4 pt-4 border-t border-border flex items-center gap-4">
                    <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">ID: <span class="font-mono text-text/60">{{ localAlert.codigoUnico }}</span></div>
                    <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">Detectado: <span class="text-text/60">{{ formatDate(localAlert.fechaDetectada) }}</span></div>
                </div>
                <div v-if="isMarea" class="mt-4 pt-4 border-t border-border space-y-2">
                    <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">
                        Marea: <span class="text-text/70">{{ mareaLabel }}</span>
                    </div>
                    <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">
                        Observadores: <span class="text-text/70">{{ mareaObserversLabel }}</span>
                    </div>
                </div>
              </div>

              <!-- Action Area -->
              <div v-if="!isClosed" class="space-y-4">
                    <div v-if="isClaimableAlert" class="flex items-center justify-between p-4 bg-info/5 border border-info/20 rounded-2xl">
                        <div>
                            <p class="text-xs font-black uppercase tracking-widest text-info/60">Reclamo de Documentación</p>
                            <p class="text-[11px] text-info/50 mt-1">Disponible para alertas por retraso en entrega de datos.</p>
                        </div>
                        <Button
                            variant="soft"
                            size="sm"
                            @click="openReclamo"
                            class="bg-info/10 text-info hover:bg-info/20 border-none"
                            :disabled="processing || reclamoLoading"
                        >
                            {{ reclamoLoading ? 'Cargando...' : 'Enviar Reclamo' }}
                        </Button>
                    </div>

                    <!-- Smart Actions Area -->
                    <div v-if="hasSmartAction" class="p-4 bg-primary/5 border border-primary/20 rounded-2xl flex items-center justify-between animate-in zoom-in-95 duration-300">
                        <div class="flex items-center gap-4">
                            <div class="p-2.5 bg-primary/10 rounded-xl text-primary">
                                <component :is="smartActionConfig.icon" class="w-5 h-5" />
                            </div>
                            <div>
                                <p class="text-xs font-black uppercase tracking-widest text-primary/60">Acción Recomendada</p>
                                <p class="text-[11px] text-text-muted mt-0.5">{{ smartActionConfig.description }}</p>
                            </div>
                        </div>
                        <Button
                            variant="primary"
                            size="sm"
                            @click="executeSmartAction"
                            class="font-black text-[10px] uppercase tracking-widest"
                            :disabled="processing"
                        >
                            {{ smartActionConfig.label }}
                        </Button>
                    </div>

                    <h4 class="font-black text-[10px] uppercase tracking-widest text-text-muted">Notas de Gestión</h4>
                    <textarea
                        v-model="comment"
                        class="w-full bg-surface-muted/30 border border-border rounded-2xl focus:ring-4 focus:ring-primary/10 focus:border-primary outline-none transition-all p-4 text-sm h-16 text-text placeholder:text-text-muted/40"
                        placeholder="Agregar notas de seguimiento, causas o detalles de la resolución..."
                    ></textarea>

                    <!-- Follow Up Date Picker -->
                    <div class="p-4 bg-surface-muted/30 rounded-2xl border border-border animate-in fade-in slide-in-from-top-2">
                        <label class="block text-[10px] font-black uppercase tracking-widest text-text-muted mb-3">
                            Fecha de Re-Check
                        </label>
                        <div class="flex flex-wrap gap-2 items-center">
                            <Button variant="soft" size="xs" class="font-bold h-7" @click="setFollowUp(1)">1 d.</Button>
                            <Button variant="soft" size="xs" class="font-bold h-7" @click="setFollowUp(recheckCorto)">3 d.</Button>
                            <Button variant="soft" size="xs" class="font-bold h-7" @click="setFollowUp(recheckMedio)">1 sem.</Button>
                            <Button variant="soft" size="xs" class="font-bold h-7" @click="setFollowUp(recheckLargo)">15 d.</Button>
                            <input
                                type="date"
                                class="ml-auto bg-surface-muted border border-border rounded-lg px-2 h-7 text-[10px] font-bold text-text focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all"
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
            <div class="w-full md:w-80 border-l border-border pl-8">
                <h4 class="font-black text-[10px] uppercase tracking-widest text-text-muted mb-6">Historial de Auditoría</h4>
                <div class="max-h-112.5 overflow-y-auto pr-4 custom-scrollbar">
                    <AlertTimeline :eventos="localAlert.eventos || []" />
                </div>
            </div>
        </div>

        <!-- Unified Actions Row (Bottom) -->
        <div v-if="!isClosed" class="pt-6 border-t border-border flex items-center gap-3 w-full">
            <Button
                variant="soft"
                size="sm"
                class="flex-1 font-bold h-10"
                @click="requestConfirmation('SEGUIMIENTO')"
                :disabled="processing"
            >
                Seguimiento
            </Button>

            <Button
                 variant="outline"
                 size="sm"
                 class="flex-1 font-bold h-10 border-error/30 text-error hover:bg-error/10"
                 @click="requestConfirmation('DESCARTADA')"
                 :disabled="processing"
            >
                Descartar
            </Button>

            <Button
                variant="success"
                size="sm"
                class="flex-1 font-bold h-10"
                @click="requestConfirmation('RESUELTA')"
                :disabled="processing"
            >
                Resolver
            </Button>
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
      <p class="text-sm text-text/80 leading-relaxed">{{ confirmationMessage }}</p>
      <div class="flex items-center gap-3 justify-end">
        <Button variant="soft" size="sm" class="font-bold" @click="closeConfirmation">Cancelar</Button>
        <Button variant="primary" size="sm" class="font-bold" @click="confirmAction" :disabled="processing">Confirmar</Button>
      </div>
    </div>
  </BaseModal>

  <!-- Smart Action: Gestion de Etapas -->
  <GestionEtapasMareaDialog
    :show="showStagesDialog"
    :mode="stagesDialogMode"
    :marea="mareaDataForStages"
    :current-stages="mareaStagesForStages"
    @close="showStagesDialog = false"
    @confirm="handleStagesConfirm"
  />
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { type Alerta, alertsService } from '../services/alerts.service'
import AlertTimeline from './AlertTimeline.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import { toast } from 'vue-sonner'
import {
    CheckIcon,
    ShipIcon,
    MapPinIcon,
    RefreshIcon,
    ChevronRightIcon,
    InfoIcon
} from '@/icons'
import dashboardService from '@/modules/dashboard/services/dashboard.service'
import ReclamoEntregaDialog from '@/modules/dashboard/components/ReclamoEntregaDialog.vue'
import mareasService from '@/modules/mareas/services/mareas.service'
import GestionEtapasMareaDialog from '@/modules/mareas/components/GestionEtapasMareaDialog.vue'
import { storeToRefs } from 'pinia'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'
import { useWorkflowStore } from '@/modules/shared/stores/workflow.store'

const workflowStore = useWorkflowStore()

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
  subTipo?: string
  nroEtapa?: number
  externalData?: any
  localData?: any
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

const formatToLocalISODate = (date: Date) => {
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0')
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
}

const getTomorrow = () => {
    const tomorrow = new Date()
    tomorrow.setDate(tomorrow.getDate() + 1)
    tomorrow.setHours(0, 0, 0, 0)
    return tomorrow
}

const minFollowUpDate = computed(() => formatToLocalISODate(getTomorrow()))

const setDefaultFollowUpDate = (dateStr?: string | null) => {
    const minDate = getTomorrow()
    if (dateStr) {
        const parsed = new Date(dateStr)
        if (!Number.isNaN(parsed.getTime()) && parsed >= minDate) {
            customFollowUpDate.value = formatToLocalISODate(parsed)
            return
        }
    }

    const fallback = new Date()
    fallback.setDate(fallback.getDate() + (recheckMedio.value || 0))
    customFollowUpDate.value = formatToLocalISODate(fallback)
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

const isIncongruency = computed(() => localAlert.value?.metadata?.subTipo === 'INCONGRUENCIA')
const incongruencyData = computed(() => localAlert.value?.metadata)

const incongruencyFields = computed(() => {
    if (!incongruencyData.value) return []
    const ext = incongruencyData.value.externalData || {}
    const loc = incongruencyData.value.localData || {}

    const fields = [
        { key: 'fechaZarpada', label: 'Fecha Zarpada' },
        { key: 'fechaArribo', label: 'Fecha Arribo' }
    ]

    return fields.map(f => {
        const valLoc = formatToLocalISODate(new Date(loc[f.key] || ''))
        const valExt = formatToLocalISODate(new Date(ext[f.key] || ''))
        // Comparación simple de fechas YYYY-MM-DD
        const niceLoc = isActiveDate(loc[f.key]) ? formatDate(loc[f.key]) : 'N/D'
        const niceExt = isActiveDate(ext[f.key]) ? formatDate(ext[f.key]) : 'N/D'

        return {
            key: f.key,
            label: f.label,
            localVal: niceLoc,
            externalVal: niceExt,
            hasDiff: niceLoc !== niceExt && (niceLoc !== 'N/D' || niceExt !== 'N/D')
        }
    })
})

const isActiveDate = (d: any) => {
    if (!d) return false
    const date = new Date(d)
    return !isNaN(date.getTime()) && date.getFullYear() > 1900
}

// --- Smart Actions Logic ---
const showStagesDialog = ref(false)
const stagesDialogMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('EDITAR')
const mareaDataForStages = ref<any>(null)
const mareaStagesForStages = ref<any[]>([])

const smartActionConfig = computed(() => {
    const subTipo = localAlert.value?.metadata?.subTipo || localAlert.value?.tipo
    switch (subTipo) {
        case 'NUEVA_MAREA':
            return {
                label: 'Registrar Marea',
                description: 'La marea detectada externamente no existe en nuestro sistema. Inicie el alta oficial.',
                icon: ShipIcon,
                handler: () => {
                    workflowStore.setAlertData(localAlert.value)
                    emit('close')
                    router.push('/mareas/nueva')
                }
            }
        case 'NUEVA_ETAPA':
            return {
                label: 'Registrar Etapa',
                description: 'Se detectó una nueva etapa (# '+ (localAlert.value?.metadata?.nroEtapa || '') +'). Inicie el registro local.',
                icon: MapPinIcon,
                handler: async () => {
                    await prepareStagesData()
                    stagesDialogMode.value = 'INICIAR'
                    showStagesDialog.value = true
                }
            }
        case 'INCONGRUENCIA':
            return {
                label: 'Conciliar Datos',
                description: 'Existen diferencias entre las fechas locales y las informadas por Access.',
                icon: RefreshIcon,
                handler: async () => {
                    await prepareStagesData()
                    stagesDialogMode.value = 'EDITAR'
                    showStagesDialog.value = true
                }
            }
        case 'ARRIBO':
            return {
                label: 'Gestionar Etapas',
                description: 'Se detectó el arribo de una etapa. Actualice el cronograma de la marea.',
                icon: MapPinIcon,
                handler: async () => {
                    await prepareStagesData()
                    stagesDialogMode.value = 'EDITAR'
                    showStagesDialog.value = true
                }
            }
        default:
            return null
    }
})

const hasSmartAction = computed(() => !!smartActionConfig.value && !isClosed.value)

const executeSmartAction = () => {
    smartActionConfig.value?.handler()
}

const prepareStagesData = async () => {
    if (!localAlert.value.referenciaId) return
    processing.value = true
    try {
        const marea = await mareasService.getById(localAlert.value.referenciaId)
        mareaDataForStages.value = marea
        mareaStagesForStages.value = marea.etapas || []
    } catch (e) {
        toast.error('Error al cargar datos de marea.')
    } finally {
        processing.value = false
    }
}

const handleStagesConfirm = async (data: any) => {
    try {
        processing.value = true
        if (localAlert.value.referenciaId) {
            await mareasService.update(localAlert.value.referenciaId, {
                fechaInicioObservador: data.fechaInicioObservador,
                fechaFinObservador: data.fechaFinObservador,
                etapas: data.etapas
            })
            toast.success('Cambios guardados con éxito')

            // Auto-comment for resolution if user didn't type one
            if (!comment.value) {
                const actionType = stagesDialogMode.value === 'INICIAR' ? 'Registro de Nueva Etapa' : 'Conciliación de Datos/Etapas'
                comment.value = `${actionType} realizada exitosamente. Resolución automática.`
            }

            await submitUpdate('RESUELTA')
        }
    } catch (e) {
        toast.error('Error al guardar cambios.')
    } finally {
        showStagesDialog.value = false
        processing.value = false
    }
}
// ----------------------------

const getBadgeColor = (prio?: string) => {
    switch (prio || '') {
        case 'URGENTE': return 'error'
        case 'ALTA': return 'warning'
        case 'MEDIA': return 'info'
        case 'BAJA': return 'purple'
        default: return 'light'
    }
}

const getOriginBadgeColor = (type?: string) => {
    switch (type || '') {
        case 'MAREA': return 'info'
        case 'OBSERVADOR': return 'primary'
        case 'BUQUE': return 'warning'
        default: return 'light'
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
        const minDateStr = formatToLocalISODate(getTomorrow())
        const selectedStr = customFollowUpDate.value

        if (!selectedStr || selectedStr < minDateStr) {
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
            let date: Date
            if (customFollowUpDate.value) {
                const [y, m, d] = customFollowUpDate.value.split('-').map(Number)
                date = new Date(y, m - 1, d, 0, 0, 0, 0)
            } else {
                date = new Date(Date.now() + (recheckMedio.value || 0) * 24 * 60 * 60 * 1000)
            }
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
    customFollowUpDate.value = formatToLocalISODate(d)
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
