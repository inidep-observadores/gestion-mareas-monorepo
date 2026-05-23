<template>
    <BaseModal :show="isOpen" @close="close" maxWidth="4xl" :title="localAlert.titulo || ''">
        <template #title>
            <div class="flex items-center justify-between w-full pr-8 py-1">
                <div class="flex items-center gap-4">
                    <Badge :color="getBadgeColor(localAlert.prioridad)" variant="solid" size="sm"
                        class="font-bold text-[10px] uppercase tracking-wider px-3 py-1">
                        {{ localAlert.prioridad || 'N/D' }}
                    </Badge>
                    <span class="text-text font-bold uppercase tracking-tight">{{ localAlert.titulo || 'Alerta'
                    }}</span>
                    <Badge v-if="localAlert.referenciaTipo" :color="getOriginBadgeColor(localAlert.referenciaTipo)"
                        variant="light" size="sm" class="font-bold text-[10px] uppercase tracking-wider h-6">
                        {{ localAlert.referenciaTipo || 'N/D' }}
                    </Badge>
                </div>
                <Button v-if="localAlert.referenciaId" @click="handleHeaderAction" variant="soft" size="sm"
                    class="gap-2 ml-4 text-[11px] font-bold" title="Ver detalle del origen">
                    {{ isMarea ? 'Detalles de la marea' : 'Ver historial' }}
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                        <polyline points="15 3 21 3 21 9" />
                        <line x1="10" y1="14" x2="21" y2="3" />
                    </svg>
                </Button>
            </div>
        </template>

        <div v-form-nav class="flex flex-col gap-6 py-2">
            <!-- Top Section: Details & Timeline -->
            <div class="flex flex-col md:flex-row gap-8">
                <!-- Main Content (Left) -->
                <div class="flex-1 space-y-6">
                    <div class="p-4 bg-surface-muted/50 border border-border rounded-xl">
                        <h4 class="font-semibold text-[10px] uppercase tracking-wider text-text-muted mb-2">Detalles del
                            Incidente
                        </h4>
                        <p class="text-sm text-text/80 leading-relaxed font-medium">{{ localAlert.descripcion }}</p>

                        <!-- Incongruency Diff Table -->
                        <div v-if="isIncongruency && incongruencyData"
                            class="mt-4 bg-surface border border-border rounded-xl overflow-hidden">
                            <table class="w-full text-xs">
                                <thead>
                                    <tr class="bg-surface-muted/50 border-b border-border">
                                        <th
                                            class="px-3 py-2 text-left font-semibold text-text-muted uppercase tracking-wider text-[10px]">
                                            Dato</th>
                                        <th
                                            class="px-3 py-2 text-left font-semibold text-text-muted uppercase tracking-wider text-[10px]">
                                            Sistema Local</th>
                                        <th
                                            class="px-3 py-2 text-left font-semibold text-text-muted uppercase tracking-wider text-[10px]">
                                            {{ externalSourceName }}</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-border">
                                    <tr v-for="field in incongruencyFields" :key="field.key"
                                        :class="{ 'bg-error/5': field.hasDiff }">
                                        <td class="px-3 py-2 font-bold text-text-muted">{{ field.label }}</td>
                                        <td class="px-3 py-2 font-mono text-text">
                                            {{ field.localVal || 'N/D' }}
                                        </td>
                                        <td class="px-3 py-2 font-mono"
                                            :class="field.hasDiff ? 'text-error font-bold' : 'text-text'">
                                            {{ field.externalVal || 'N/D' }}
                                            <span v-if="field.hasDiff"
                                                class="ml-1 text-[9px] text-error bg-error/10 px-1 rounded">DIFERENTE</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-4 pt-4 border-t border-border flex flex-col gap-3">
                            <div class="flex items-center justify-between">
                                <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">Detectado:
                                    <span class="text-text/60">{{ formatDate(localAlert.fechaDetectada) }}</span>
                                </div>
                                <div class="flex gap-1.5">
                                    <template v-for="src in alertSources" :key="src.name">
                                        <TrajectorySourceBadge v-if="src.name === 'Tracking' || src.name === 'PNA'"
                                            :source="src.name === 'PNA' ? 'PNA' : 'TRACKING'" :vesselId="mapVesselId"
                                            :vesselName="mapVesselName" :referenceDate="mapReferenceDate"
                                            :endDate="mapEndDate" :mareaId="localAlert?.referenciaId"
                                            :mareaCode="fixedMareaLabel" size="sm" />
                                        <Badge v-else :color="getSourceColor(src.name)" variant="light" size="sm"
                                            class="font-black text-[9px] uppercase px-2">
                                            {{ src.name }}
                                        </Badge>
                                    </template>
                                </div>
                            </div>
                        </div>
                        <div v-if="isMarea" class="mt-4 pt-4 border-t border-border space-y-2">
                            <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">
                                Marea: <span class="text-text/70">{{ fixedMareaLabel }}</span>
                            </div>
                            <div class="text-[10px] font-bold text-text-muted uppercase tracking-tight">
                                Observador: <span class="text-text/70">{{ mareaObserversLabel }}</span>
                            </div>
                            <div v-if="externalObserverLabel && mareaObserversLabel === 'Sin asignar'"
                                class="text-[10px] font-bold text-warning uppercase tracking-tight">
                                Observador Externo ({{ externalSourceName }}): <span class="text-warning/90">{{
                                    externalObserverLabel
                                    }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action Area -->
                    <div v-if="!isClosed" class="space-y-4">
                        <div v-if="isClaimableAlert"
                            class="flex items-center justify-between p-4 bg-info/5 border border-info/20 rounded-xl">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-wider text-info/60">Reclamo de
                                    Documentación
                                </p>
                                <p class="text-[11px] text-info/50 mt-1 font-medium">Disponible para alertas por retraso
                                    en
                                    entrega
                                    de
                                    datos.</p>
                            </div>
                            <Button variant="soft" size="sm" @click="openReclamo"
                                class="bg-info/10 text-info hover:bg-info/20 border-none"
                                :disabled="processing || reclamoLoading">
                                {{ reclamoLoading ? 'Cargando...' : 'Enviar Reclamo' }}
                            </Button>
                        </div>

                        <!-- Smart Actions Area -->
                        <div v-if="smartActionConfig && !isClosed"
                            class="p-4 bg-primary/5 border border-primary/20 rounded-xl flex items-center justify-between animate-in zoom-in-95 duration-300 shadow-sm">
                            <div class="flex items-center gap-4">
                                <div class="p-2.5 bg-primary/10 rounded-xl text-primary">
                                    <component :is="smartActionConfig.icon" class="w-5 h-5" />
                                </div>
                                <div>
                                    <h4 class="text-xs font-bold text-primary uppercase tracking-wider mb-1">{{
                                        smartActionConfig.label }}</h4>
                                    <p
                                        class="text-[10px] text-text/80 font-semibold uppercase tracking-tight leading-tight">
                                        {{
                                            smartActionDescription }}</p>
                                </div>
                            </div>
                            <Button variant="primary" size="sm" @click="executeSmartAction"
                                class="font-bold text-[10px] uppercase tracking-wider px-4" :disabled="processing">
                                {{ smartActionConfig.label }}
                            </Button>
                        </div>

                        <h4 class="font-black text-[10px] uppercase tracking-widest text-text-muted mt-5 mb-2">
                            Responsable</h4>
                        <div class="relative">
                            <div class="flex items-center gap-2" v-if="!isAssigning">
                                <div
                                    class="flex items-center gap-2 flex-1 p-3 bg-surface-muted/30 border border-border rounded-xl">
                                    <template v-if="currentAssignee">
                                        <div
                                            class="w-6 h-6 rounded-full bg-primary/10 flex items-center justify-center text-[10px] font-black text-primary overflow-hidden">
                                            <img v-if="currentAssignee.avatarUrl" :src="currentAssignee.avatarUrl"
                                                class="w-full h-full object-cover" />
                                            <span v-else>{{ getInitials(currentAssignee.fullName) }}</span>
                                        </div>
                                        <span class="text-xs font-bold text-text">{{ currentAssignee.fullName }}</span>
                                    </template>
                                    <template v-else>
                                        <div
                                            class="w-6 h-6 rounded-full bg-text-muted/10 flex items-center justify-center">
                                            <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5 text-text-muted"
                                                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                                                <circle cx="12" cy="7" r="4" />
                                            </svg>
                                        </div>
                                        <span class="text-xs text-text-muted italic">Sin asignar</span>
                                    </template>
                                </div>
                                <Button variant="soft" size="sm" class="h-11 px-4" @click="isAssigning = true">
                                    {{ currentAssignee ? 'Cambiar' : 'Asignar' }}
                                </Button>
                            </div>

                            <!-- Assignment Dropdown Mode -->
                            <div v-else class="space-y-2 animate-in fade-in zoom-in-95 duration-200">
                                <div class="relative">
                                    <select v-model="pendingAssigneeId"
                                        class="w-full appearance-none bg-surface border border-primary rounded-xl px-4 py-3 pr-10 text-xs font-bold text-text focus:outline-none focus:ring-4 focus:ring-primary/10 transition-all cursor-pointer"
                                        :disabled="processingAssignment">
                                        <option value="" class="text-text-muted">-- Sin asignar (Visible para todos) --
                                        </option>
                                        <option v-for="user in availableUsers" :key="user.id" :value="user.id">
                                            {{ user.fullName }}
                                        </option>
                                    </select>
                                    <div
                                        class="absolute inset-y-0 right-0 flex items-center px-3 pointer-events-none text-primary">
                                        <ChevronDownIcon class="w-4 h-4" />
                                    </div>
                                </div>
                                <div class="flex items-center gap-2 justify-end">
                                    <Button variant="ghost" size="xs" @click="cancelAssignment"
                                        :disabled="processingAssignment">Cancelar</Button>
                                    <Button variant="primary" size="xs" @click="confirmAssignment"
                                        data-allow-enter
                                        :disabled="processingAssignment">
                                        {{ processingAssignment ? 'Guardando...' : 'Confirmar' }}
                                    </Button>
                                </div>
                            </div>
                        </div>

                        <h4 class="font-black text-[10px] uppercase tracking-widest text-text-muted mt-5">Notas de
                            Gestión</h4>
                        <textarea v-model="comment"
                            ref="commentInput"
                            class="w-full bg-surface-muted/30 border border-border rounded-xl focus:ring-4 focus:ring-primary/10 focus:border-primary outline-none transition-all p-4 text-sm h-16 text-text font-medium placeholder:text-text-muted/40"
                            placeholder="Agregar notas de seguimiento, causas o detalles de la resolución..."></textarea>

                        <!-- Follow Up Date Picker -->
                        <div
                            class="p-4 bg-surface-muted/30 rounded-xl border border-border animate-in fade-in slide-in-from-top-2">
                            <label
                                class="block text-[10px] font-semibold uppercase tracking-wider text-text-muted mb-3">
                                Fecha de Re-Check
                            </label>
                            <div class="flex flex-wrap gap-2 items-center">
                                <Button variant="soft" size="xs" class="font-bold h-7" @click="setFollowUp(1)">1
                                    d.</Button>
                                <Button variant="soft" size="xs" class="font-bold h-7"
                                    @click="setFollowUp(recheckCorto)">3
                                    d.</Button>
                                <Button variant="soft" size="xs" class="font-bold h-7"
                                    @click="setFollowUp(recheckMedio)">1
                                    sem.</Button>
                                <Button variant="soft" size="xs" class="font-bold h-7"
                                    @click="setFollowUp(recheckLargo)">15
                                    d.</Button>
                                <input type="date"
                                    class="ml-auto bg-surface-muted border border-border rounded-lg px-2 h-7 text-[10px] font-bold text-text focus:border-primary focus:ring-4 focus:ring-primary/10 outline-none transition-all"
                                    v-model="customFollowUpDate" :min="minFollowUpDate" />
                            </div>
                        </div>
                    </div>

                    <div v-else
                        class="flex items-center gap-3 p-4 bg-success/5 text-success rounded-xl border border-success/10 font-semibold text-xs uppercase tracking-tight">
                        <CheckIcon class="w-5 h-5 text-success" />
                        <span>Incidente Cerrado el {{
                            localAlert.fechaCierre
                                ? formatDate(localAlert.fechaCierre) : 'N/A' }}</span>
                    </div>
                </div>

                <!-- Sidebar / Timeline (Right) -->
                <div class="w-full md:w-80 border-l border-border pl-8">
                    <h4 class="font-semibold text-[10px] uppercase tracking-wider text-text-muted mb-6">Historial de
                        Auditoría
                    </h4>
                    <div class="max-h-112.5 overflow-y-auto pr-4 custom-scrollbar">
                        <AlertTimeline :eventos="localAlert.eventos || []" />
                    </div>
                </div>
            </div>

            <!-- Unified Actions Row (Bottom) -->
            <div v-if="!isClosed" class="pt-4 flex items-center gap-3 w-full">
                <Button variant="soft" size="sm" class="flex-1 font-semibold h-10"
                    @click="requestConfirmation('SEGUIMIENTO')" :disabled="processing">
                    Seguimiento
                </Button>

                <Button variant="outline" size="sm"
                    class="flex-1 font-bold h-10 border-error/30 text-error hover:bg-error/10"
                    @click="requestConfirmation('DESCARTADA')" :disabled="processing">
                    Descartar
                </Button>

                <Button variant="success" size="sm" class="flex-1 font-bold h-10"
                    @click="requestConfirmation('RESUELTA')" :disabled="processing">
                    Resolver
                </Button>
            </div>
        </div>
    </BaseModal>

    <ReclamoEntregaDialog :show="showReclamoDialog" :id="reclamoData?.id || ''" :marea-id="reclamoData?.mareaId || ''"
        :vessel-name="reclamoData?.vesselName || ''" :obs-name="reclamoData?.obsName || ''"
        :email="reclamoData?.email || null" :delay-days="reclamoData?.delayDays || 0"
        :arrival-date="reclamoData?.arrivalDate || ''" @close="showReclamoDialog = false"
        @confirm="handleReclamoConfirm" />

    <BaseModal ref="confirmationModal" :show="isConfirmationOpen" @close="closeConfirmation" maxWidth="xl"
        :title="'Confirmar acción'">
        <div class="space-y-5">
            <p class="text-sm text-text/80 leading-relaxed font-medium">{{ confirmationMessage }}</p>
            <div class="flex items-center gap-3 justify-end">
                <Button variant="soft" size="sm" class="font-semibold" @click="closeConfirmation">Cancelar</Button>
                <Button variant="primary" size="sm" class="font-bold" @click="confirmAction"
                    data-allow-enter
                    :disabled="processing">Confirmar</Button>
            </div>
        </div>
    </BaseModal>

    <!-- Smart Action: Gestion de Etapas -->
    <GestionEtapasMareaDialog :show="showStagesDialog" :mode="stagesDialogMode" :marea="mareaDataForStages"
        :current-stages="mareaStagesForStages" @close="showStagesDialog = false" @confirm="handleStagesConfirm" />

    <!-- Smart Action: Registro de Nueva Marea -->
    <NuevaMareaDialog :show="showNuevaMareaDialog" :init-from-alert="true" @close="showNuevaMareaDialog = false"
        @success="handleMareaSuccess" />

    <MareaQuickDetailModal :isOpen="showMareaQuickDetail" :mareaId="localAlert.referenciaId || null"
        @close="showMareaQuickDetail = false" />

    <ObservadorTimelineDialog :show="showObservadorTimeline" :observadorId="localAlert.referenciaId || null"
        :observadorName="localAlert.metadata?.observerName || 'Observador'" :year="configStore.selectedYear"
        @close="showObservadorTimeline = false" />
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, markRaw, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { storeToRefs } from 'pinia'
import { toast } from 'vue-sonner'

import Badge from '@/components/ui/Badge.vue'
import Button from '@/components/ui/Button.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import TrajectorySourceBadge from '@/modules/alerts/components/TrajectorySourceBadge.vue'
import AlertTimeline from '@/modules/alerts/components/AlertTimeline.vue'
import { TrajectoryRangeUtils } from '@/modules/alerts/utils/trajectory-range.utils'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'
import ObservadorTimelineDialog from '@/modules/admin/components/ObservadorTimelineDialog.vue'
import dashboardService from '@/modules/dashboard/services/dashboard.service'
import ReclamoEntregaDialog from '@/modules/dashboard/components/ReclamoEntregaDialog.vue'
import GestionEtapasMareaDialog from '@/modules/mareas/components/GestionEtapasMareaDialog.vue'
import NuevaMareaDialog from '@/modules/mareas/components/NuevaMareaDialog.vue'

// Icons
import {
    CheckIcon,
    ShipIcon,
    MapPinIcon,
    RefreshIcon,
    ChevronRightIcon,
    InfoIcon,
    WarningIcon,
    ChevronDownIcon
} from '@/icons'

// Services & Types
import { type Alerta, alertsService } from '../services/alerts.service'
import type { AlertMetadata } from '../interfaces/alert-metadata.interface'
import mareasService from '@/modules/mareas/services/mareas.service'
import usersAdminApi from '@/modules/admin/services/users.service'
import type { User } from '@/modules/auth/types/auth.types'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'
import { TipoEtapa, TipoMarea } from '@/modules/mareas/types/enums'

// Stores
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'
import { useWorkflowStore } from '@/modules/shared/stores/workflow.store'
import { useConfigStore } from '@/modules/shared/stores/config.store'

const workflowStore = useWorkflowStore()

const props = defineProps<{
    isOpen: boolean
    alert: Alerta | null
}>()

// Assignment State
const availableUsers = ref<User[]>([])
const isAssigning = ref(false)
const pendingAssigneeId = ref<string>('')
const processingAssignment = ref(false)

onMounted(async () => {
    try {
        const users = await usersAdminApi.getUsers()
        availableUsers.value = users.filter(u =>
            u.isActive &&
            (u.roles.includes(ValidRoles.coordinador) || u.roles.includes(ValidRoles.tecnico))
        )
    } catch (e) {
        console.error('Error fetching users for assignment:', e)
    }
})

const currentAssignee = computed(() => localAlert.value?.asignadoA) // Backend includes asignadoA relation

const cancelAssignment = () => {
    isAssigning.value = false
    pendingAssigneeId.value = ''
}

const confirmAssignment = async () => {
    if (!localAlert.value?.id) return

    processingAssignment.value = true
    try {
        // Optimistic update
        const selectedUser = availableUsers.value.find(u => u.id === pendingAssigneeId.value)
        const previous = localAlert.value.asignadoA

        if (pendingAssigneeId.value) {
            await alertsService.update(localAlert.value.id, {
                asignadoId: pendingAssigneeId.value
            })
        } else {
            // Unassign: usually update DTOs might want explicit null or specific handling.
            // Assuming service handles null for optional string.
            await alertsService.update(localAlert.value.id, {
                asignadoId: null as any // Force null to clear
            })
        }

        // Update local object to reflect change immediately
        if (pendingAssigneeId.value && selectedUser) {
            localAlert.value.asignadoId = selectedUser.id
            localAlert.value.asignadoA = selectedUser as any
            toast.success(`Asignado a ${selectedUser.fullName}`)
        } else {
            localAlert.value.asignadoId = null
            localAlert.value.asignadoA = null
            toast.success('Alerta desasignada (visible para todos)')
        }

    } catch (e) {
        console.error(e)
        toast.error('Error al actualizar la asignación')
    } finally {
        processingAssignment.value = false
        isAssigning.value = false
        emit('refresh') // Refresh list to update state if needed
    }
}

const getInitials = (name?: string) => {
    if (!name) return '?'
    return name.split(' ').map(n => n[0]).slice(0, 2).join('').toUpperCase()
}

const emit = defineEmits(['close', 'refresh'])
const router = useRouter()

type LocalAlert = Omit<Partial<Alerta>, 'asignadoA'> & {
    metadata?: AlertMetadata
    asignadoA?: User | { fullName: string; avatarUrl?: string } | null
}

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
    observadorPrincipal?: Observador
    etapas?: MareaEtapa[]
    estado_codigo?: string
    estadoActual?: {
        codigo: string
        nombre: string
    }
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
const showNuevaMareaDialog = ref(false)
const showMareaQuickDetail = ref(false)
const showObservadorTimeline = ref(false)
const commentInput = ref<HTMLTextAreaElement | null>(null)
const businessRulesStore = useBusinessRulesStore()
const configStore = useConfigStore()
const { rules } = storeToRefs(businessRulesStore)
const recheckCorto = computed(() => rules.value?.PLAZO_RECHECK_CORTO || 0)
const recheckMedio = computed(() => rules.value?.PLAZO_RECHECK_MEDIO || 0)
const recheckLargo = computed(() => rules.value?.PLAZO_RECHECK_LARGO || 0)

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



const getMetadataObserver = () => {
    return localAlert.value?.metadata?.observerName || (localAlert.value as any)?.metadata?.obs || null
}

const loadFullAlert = async (id: string) => {
    try {
        const full = await alertsService.getOne(id)
        localAlert.value = full
        if (full.referenciaTipo === 'MAREA' && full.referenciaId) {
            loadMareaData(full.referenciaId)
        }
        setDefaultFollowUpDate(full?.fechaVencimiento || null)
        
        nextTick(() => {
            commentInput.value?.focus()
        })
    } catch (e) {
        console.error('Error cargando detalle de alerta:', e)
    }
}

const isClosed = computed(() => ['RESUELTA', 'DESCARTADA'].includes(localAlert.value.estado ?? ''))
const isClaimableAlert = computed(() => localAlert.value?.tipo === 'RETRASO_DATOS' && localAlert.value?.referenciaId)

const mareaData = ref<MareaData | null>(null)

const fixedMareaLabel = computed(() => {
    if (localAlert.value?.metadata?.mareaCode) return localAlert.value.metadata.mareaCode
    if (mareaData.value) return buildFormattedMareaCode(mareaData.value)
    return 'N/D'
})

const externalObserverLabel = computed(() => {
    const extObs = localAlert.value?.metadata?.externalObserver
    if (!extObs) return null
    return `${extObs.nombre} ${extObs.apellido} (Cód: ${extObs.codigo})`
})

const mareaObserversLabel = computed(() => {
    if (mareaObservers.value.length) return mareaObservers.value.join(', ')

    // Fallback: Metadata de la propia alerta
    const metaObs = getMetadataObserver()
    if (metaObs && metaObs !== 'Sin Asignar' && metaObs !== 'Sin asignar') return metaObs

    return 'Sin asignar'
})

const alertSources = computed(() => {
    const meta = localAlert.value?.metadata || {}
    const sources = (meta as any).sources || []

    // 1. Si hay lista de fuentes estructurada (Source Stacking)
    if (sources.length > 0) {
        return sources.map((s: { name: string }) => {
            let name = s.name
            if (name === 'API_PNA' || name === 'PNA') name = 'PNA'
            else if (name === 'ACCESS_IMPORT') name = 'Access'
            else if (name === 'TRACKING_CSV') name = 'Tracking'
            return { name }
        })
    }

    // 2. Fallback: Campo source único (Access o PNA creados sin stacking)
    if (meta.source) {
        let name = meta.source
        if (name === 'API_PNA' || name === 'PNA') name = 'PNA'
        else if (name === 'ACCESS_IMPORT') name = 'Access'
        else if (name === 'TRACKING_CSV') name = 'Tracking'
        return [{ name }]
    }

    // 3. Fallback: Tipos de monitoreo satelital (VMS)
    const monitoringTypes = ['MONITOREO_SATELITAL', 'GAP_DETECTADO', 'POSIBLE_ZARPADA', 'POSIBLE_ARRIBO', 'ERROR_REGISTRO_PUERTO']
    const isMonitoring = monitoringTypes.includes(localAlert.value?.tipo ?? '') || !!meta.type
    if (isMonitoring) return [{ name: 'VMS' }]

    return [{ name: 'Sistema' }]
})



const externalSourceName = computed(() => {
    const sources = alertSources.value
    if (sources.length > 0) {
        // Si hay PNA, priorizar ese nombre para la tabla de comparación si existe
        const pna = sources.find((s: { name: string }) => s.name === 'PNA')
        if (pna) return 'PNA (API)'
        return sources[0].name
    }
    return 'Sistema Externo'
})

// --- Map data resolution ---
const mapVesselId = computed(() => {
    // Priority: Metadata vesselId/buqueId (from tracking/access) > Marea BuqueId > null
    if (localAlert.value?.metadata?.vesselId) return localAlert.value.metadata.vesselId
    if (localAlert.value?.metadata?.buqueId) return localAlert.value.metadata.buqueId

    // Safer access with casting since local type definition might be incomplete
    const m = mareaData.value as any
    if (m?.buque?.id) return m.buque.id
    if (m?.buqueId) return m.buqueId

    return null
})

const mapVesselName = computed(() => {
    if (localAlert.value?.metadata?.vessel) return localAlert.value.metadata.vessel
    if (mareaData.value?.buque?.nombreBuque) return mareaData.value.buque.nombreBuque
    return 'Buque'
})

const mapReferenceDate = computed(() => {
    return TrajectoryRangeUtils.resolveAlertDates(localAlert.value).referenceDate
})

const mapEndDate = computed(() => {
    return TrajectoryRangeUtils.resolveAlertDates(localAlert.value).endDate
})

const canShowMap = computed(() => {
    // We need both a vessel and a valid reference date to show the map
    return (localAlert.value?.referenciaTipo === 'MAREA' || localAlert.value?.referenciaTipo === 'BUQUE') &&
        !!localAlert.value?.referenciaId &&
        !!mapVesselId.value &&
        !!mapReferenceDate.value
})

const smartActionDescription = computed(() => {
    const subTipo = localAlert.value?.metadata?.subTipo || localAlert.value?.tipo
    if (subTipo === 'INCONGRUENCIA') {
        const source = externalSourceName.value
        const isPortDiff = localAlert.value?.tipo === 'ERROR_REGISTRO_PUERTO'
        const diffType = isPortDiff ? 'los puertos' : 'las fechas'
        return `Existen diferencias entre ${diffType} locales y las detectadas por ${source === 'Monitoreo Satelital' ? 'el sistema de seguimiento' : 'Access (Externo)'}.`
    }
    return smartActionConfig.value?.description || ''
})

const isIncongruency = computed(() => localAlert.value?.metadata?.subTipo === 'INCONGRUENCIA')
const incongruencyData = computed(() => localAlert.value?.metadata)

const incongruencyFields = computed(() => {
    if (!incongruencyData.value) return []
    const ext = incongruencyData.value.externalData || {}
    const loc = incongruencyData.value.localData || {}
    const type = incongruencyData.value.type // 'ZARPADA' or 'ARRIBO'

    const fields = []
    if (!type || type === 'ZARPADA') {
        fields.push({ key: 'fechaZarpada', label: 'Fecha Zarpada', type: 'date' })
        fields.push({ key: 'puertoZarpadaNombre', label: 'Puerto Zarpada', type: 'text' })
    }
    if (!type || type === 'ARRIBO') {
        fields.push({ key: 'fechaArribo', label: 'Fecha Arribo', type: 'date' })
        fields.push({ key: 'puertoArriboNombre', label: 'Puerto Arribo', type: 'text' })
    }

    return fields.map(f => {
        let niceLoc = 'N/D'
        let niceExt = 'N/D'

        if (f.type === 'date') {
            niceLoc = isActiveDate(loc[f.key]) ? formatDate(loc[f.key]) : 'N/D'
            niceExt = isActiveDate(ext[f.key]) ? formatDate(ext[f.key]) : 'N/D'
        } else {
            niceLoc = loc[f.key] || 'N/D'
            niceExt = ext[f.key] || 'N/D'
        }

        return {
            key: f.key,
            label: f.label,
            localVal: niceLoc,
            externalVal: niceExt,
            hasDiff: String(niceLoc).trim() !== String(niceExt).trim() && (niceLoc !== 'N/D' || niceExt !== 'N/D')
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
    const tipo = localAlert.value?.tipo
    const metadata = localAlert.value?.metadata || {}
    const subTipoMetadata = metadata.subTipo

    // Determinar la clave de acción priorizando tipos específicos
    let actionKey = subTipoMetadata || tipo

    // Fallback para datos históricos de tracking (cuando tipo era TRACKING_EVENT)
    if (tipo === 'TRACKING_EVENT' && metadata.type === 'ZARPADA') {
        actionKey = 'ZARPADA'
    }

    switch (actionKey) {
        case 'NUEVA_MAREA':
            return {
                label: 'Registrar Marea',
                description: `La marea detectada por ${externalSourceName.value} no existe en nuestro sistema. Inicie el alta oficial.`,
                icon: ShipIcon,
                handler: () => {
                    workflowStore.setAlertData(localAlert.value)
                    showNuevaMareaDialog.value = true
                }
            }
        case 'NUEVA_ETAPA':
            return {
                label: 'Registrar Etapa',
                description: 'Se detectó una nueva etapa (# ' + (metadata.nroEtapa || '') + '). Inicie el registro local.',
                icon: MapPinIcon,
                handler: async () => {
                    await prepareStagesData(true) // Pass true to indicate creating a new stage
                    stagesDialogMode.value = 'EDITAR' // Must be EDITAR to show full list and new item
                    showStagesDialog.value = true
                }
            }
        case 'INCONGRUENCIA':
        case 'EDITAR_ETAPA':
            return {
                label: 'Gestionar Etapas',
                description: subTipoMetadata === 'EDITAR_ETAPA'
                    ? 'Se detectaron discrepancias con los datos oficiales. Se recomienda revisar y corregir la etapa.'
                    : `Existen diferencias entre las fechas locales y las informadas por ${externalSourceName.value}.`,
                icon: RefreshIcon,
                handler: async () => {
                    await prepareStagesData()
                    stagesDialogMode.value = 'EDITAR'
                    showStagesDialog.value = true
                }
            }
        case 'RECOMENDACION_FIN_MAREA':
        case 'FIN_MAREA':
            return {
                label: 'Finalizar Marea',
                description: 'Se recomienda finalizar la marea actual para dar inicio a la siguiente marea designada.',
                icon: CheckIcon,
                handler: async () => {
                    await prepareStagesData()
                    stagesDialogMode.value = 'FINALIZAR'
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
        case 'POSIBLE_ZARPADA':
        case 'ZARPADA':
            const mareaStatusCode = mareaData.value?.estadoActual?.codigo || mareaData.value?.estado_codigo
            if (mareaStatusCode === 'DESIGNADA') {
                return {
                    label: 'Registrar Inicio',
                    description: 'Se detectó la zarpada de una marea designada. Inicie el registro oficial del viaje.',
                    icon: ShipIcon,
                    handler: async () => {
                        await prepareStagesData(true)
                        stagesDialogMode.value = 'INICIAR'
                        showStagesDialog.value = true
                    }
                }
            } else {
                return {
                    label: 'Gestionar Etapas',
                    description: 'Se detectó una zarpada. El buque ya se encuentra en navegación. Actualice las etapas del viaje.',
                    icon: MapPinIcon,
                    handler: async () => {
                        await prepareStagesData(true)
                        stagesDialogMode.value = 'EDITAR'
                        showStagesDialog.value = true
                    }
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

const prepareStagesData = async (isNewStageConfig = false) => {
    if (!localAlert.value.referenciaId) return
    processing.value = true
    try {
        const marea = await mareasService.getById(localAlert.value.referenciaId)
        mareaDataForStages.value = marea
        // Ensure strictly editable copy
        const currentStages = marea.etapas ? JSON.parse(JSON.stringify(marea.etapas)) : []

        const subTipo = localAlert.value?.metadata?.subTipo || localAlert.value?.tipo
        const ext = localAlert.value.metadata?.externalData || {}
        const nroEtapaAlert = localAlert.value.metadata?.nroEtapa
        const sources = (localAlert.value?.metadata as any)?.sources || []

        // Ajuste sugerido por el usuario: Fecha Inicio Observador
        if (ext.fechaZarpada) {
            const alertZarpadaDate = new Date(ext.fechaZarpada)
            const currentStartStr = marea.fechaInicioObservador

            if (!currentStartStr) {
                marea.fechaInicioObservador = ext.fechaZarpada
            } else {
                const currentStartDate = new Date(currentStartStr)
                if (alertZarpadaDate < currentStartDate) {
                    marea.fechaInicioObservador = ext.fechaZarpada
                }
            }
        }

        if (isNewStageConfig) {
            const lastStage = currentStages.length > 0 ? currentStages[currentStages.length - 1] : null
            // Heredar del último o usar puerto de alerta/base
            const portFromAlert = localAlert.value.metadata?.portId || ext.puertoZarpadaId || ext.portId;
            const puertoZarpadaId = portFromAlert || lastStage?.puertoArriboId || marea.puertoBaseId || '';

            const newStage = {
                id: null, // Nueva etapa
                nroEtapa: (lastStage?.nroEtapa || 0) + 1,
                puertoZarpadaId: puertoZarpadaId,
                // Usar datos del alerta para fechas
                fechaZarpada: ext.fechaZarpada || '',
                puertoArriboId: ext.puertoArriboId || '', // Sugerir si viene en el alerta
                fechaArribo: ext.fechaArribo || '',
                // Heredar configuración
                pesqueriaId: lastStage?.pesqueriaId || marea.buque?.pesqueriaHabitualId || marea.id_pesqueria,
                tipoEtapa: lastStage?.tipoEtapa || TipoEtapa.EC,
                observaciones: `Etapa detectada automáticamente desde ${externalSourceName.value}`,
                fuentesZarpada: sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null,
                observadores: []
            }
            currentStages.push(newStage)
        } else if (subTipo && ['ARRIBO', 'INCONGRUENCIA', 'ZARPADA', 'POSIBLE_ZARPADA', 'FIN_MAREA', 'RECOMENDACION_FIN_MAREA'].includes(subTipo as string)) {
            // Caso Actualización de Etapa: Buscar la etapa y sugerir cambios de Access/Tracking
            let stageToUpdate = null;

            if (nroEtapaAlert) {
                stageToUpdate = currentStages.find((s: any) =>
                    (s.nroEtapa === nroEtapaAlert) || (s.nro_etapa === nroEtapaAlert)
                )
            } else if (['ARRIBO', 'FIN_MAREA', 'RECOMENDACION_FIN_MAREA'].includes(subTipo as string) && currentStages.length > 0) {
                // Fallback: Si no hay nroEtapa pero es un arribo, usar la última etapa
                stageToUpdate = currentStages[currentStages.length - 1]
            }

            if (stageToUpdate) {
                if (ext.fechaZarpada) {
                    stageToUpdate.fechaZarpada = ext.fechaZarpada
                    stageToUpdate.fuentesZarpada = sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null
                }
                if (ext.puertoZarpadaId) {
                    stageToUpdate.puertoZarpadaId = ext.puertoZarpadaId
                    stageToUpdate.fuentesZarpada = sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null
                }
                if (ext.fechaArribo) {
                    stageToUpdate.fechaArribo = ext.fechaArribo
                    stageToUpdate.fuentesArribo = sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null
                }
                if (ext.puertoArriboId) {
                    stageToUpdate.puertoArriboId = ext.puertoArriboId
                    stageToUpdate.fuentesArribo = sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null
                }
                // Si la metadata trae un puerto específico de la alerta (fuente PNA simple) y no está en externalData
                if (!ext.puertoArriboId && localAlert.value.metadata?.portId && (subTipo === 'ARRIBO' || subTipo === 'FIN_MAREA')) {
                    stageToUpdate.puertoArriboId = localAlert.value.metadata.portId
                    stageToUpdate.fuentesArribo = sources.length > 0 ? { ...(localAlert.value.metadata || {}), manual: true } : null
                }
            }
        }

        mareaStagesForStages.value = currentStages
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
            const actionKey = stagesDialogMode.value === 'INICIAR'
                ? 'REGISTRAR_INICIO'
                : stagesDialogMode.value === 'FINALIZAR'
                    ? 'REGISTRAR_FINALIZACION'
                    : 'EDITAR_ETAPAS';

            await mareasService.executeAction(localAlert.value.referenciaId, actionKey, {
                fechaInicioObservador: data.fechaInicioObservador,
                fechaFinObservador: data.fechaFinObservador,
                etapas: data.etapas
            })
            toast.success('Cambios guardados con éxito')

            // Reload alert to verify diffs if needed (optional)
            await loadFullAlert(localAlert.value.id!)
        }
    } catch (e) {
        toast.error('Error al guardar cambios.')
    } finally {
        showStagesDialog.value = false
        processing.value = false
    }
}

const handleMareaSuccess = () => {
    showNuevaMareaDialog.value = false
    emit('refresh')
    emit('close')
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

const getSourceColor = (name: string): 'primary' | 'success' | 'error' | 'warning' | 'info' | 'purple' | 'light' | 'dark' => {
    const colors: Record<string, 'primary' | 'success' | 'error' | 'warning' | 'info' | 'purple' | 'light' | 'dark'> = {
        'PNA': 'warning',
        'Access': 'purple',
        'VMS': 'success',
        'Tracking': 'success',
        'Sistema': 'light'
    }
    return colors[name] || 'light'
}

const getOriginBadgeColor = (type?: string): 'primary' | 'success' | 'error' | 'warning' | 'info' | 'purple' | 'light' | 'dark' => {
    switch (type) {
        case 'MAREA': return 'info'
        case 'OBSERVADOR': return 'primary'
        case 'BUQUE': return 'warning'
        default: return 'light'
    }
}

const isMarea = computed(() => !localAlert.value.referenciaTipo || localAlert.value.referenciaTipo === 'MAREA')

const handleHeaderAction = () => {
    if (!localAlert.value.referenciaId) return

    if (localAlert.value.referenciaTipo === 'MAREA') {
        showMareaQuickDetail.value = true
        return
    }

    if (localAlert.value.referenciaTipo === 'OBSERVADOR') {
        showObservadorTimeline.value = true
        return
    }

    // Fallback logic (original implementation or generic routing)
    // For now, if it's not handled, we do nothing or could implement generic routing
    // original:
    // const route = isMarea.value ? `/mareas/detalle/${localAlert.value.referenciaId}` : `/admin/observadores/${localAlert.value.referenciaId}`
    // router.push(route)
    // emit('close')
    goToFullHistory()
}

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

const buildFormattedMareaCode = (marea?: MareaData | null) => {
    if (!marea) return ''
    const yearSuffix = String(marea.anioMarea || '').slice(-2)
    const tipo = marea.tipoMarea === TipoMarea.CI ? 'CI' : 'MC'
    return `${tipo}-${marea.nroMarea}-${yearSuffix}`
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

        // Prioridad 1: Observador Principal de la marea (Cabecera)
        // Prioridad 2: Observador Principal de la etapa actual
        const primaryObsFromEtapa = getPrimaryObserver(etapaActual)
        const obs = marea.observadorPrincipal || primaryObsFromEtapa?.observador || {}

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
        // Usar getMareaContext en lugar de getById ya que el contexto
        // ya trae el campo "observador" aplanado y formateado desde el back
        const context = await mareasService.getMareaContext(mareaId)
        if (context?.marea?.observador && context.marea.observador !== 'No asignado') {
            mareaObservers.value = [context.marea.observador]
        } else {
            mareaObservers.value = []
        }
    } catch (e) {
        console.error('Error cargando observadores de la marea:', e)
        mareaObservers.value = []
    }
}

const loadMareaData = async (mareaId: string) => {
    try {
        const data = await mareasService.getById(mareaId)
        mareaData.value = data
    } catch (e) {
        console.error('Error cargando datos de marea:', e)
        mareaData.value = null
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
        return 'Si confirma, el alerta quedará en seguimiento y continuará visible en la lista de alertas de atención inmediata. Seleccione esta opción si la situación aún no está resuelta.'
    }

    if (state === 'DESCARTADA') {
        return 'Si confirma, el alerta se descartará y se dará por concluida. Dejará de aparecer en la lista de alertas de atención inmediata. Si la situación aún no está resuelta, seleccione la opción de seguimiento para mantenerla vigente.'
    }

    return 'Si confirma, el alerta se marcará como resuelta y se dará por concluida. Dejará de aparecer en la lista de alertas de atención inmediata. Si la situación aún no está resuelta, seleccione la opción de seguimiento para mantenerla vigente.'
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
        // No limpiar observers inmediatamente para evitar parpadeo si se reabre la misma
    }
})

const formatDate = (dateStr?: string) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    })
}
</script>

<style scoped></style>
