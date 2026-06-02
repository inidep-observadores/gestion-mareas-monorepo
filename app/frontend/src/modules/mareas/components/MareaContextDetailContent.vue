<template>
  <div class="flex flex-col h-full overflow-hidden bg-background">
    <!-- Header -->
    <div class="p-4 border-b border-border flex items-center justify-between bg-surface-muted/50 shrink-0">
      <div class="flex-1 min-w-0">
        <h3 class="text-lg font-black text-text truncate leading-tight">
          {{ mareaTitle }}
        </h3>
        <div class="flex items-center gap-2 mt-0.5">
          <div
            class="px-1.5 py-0.5 bg-primary/10 rounded text-[10px] font-mono font-bold text-primary uppercase tracking-wider">
            {{ mareaCode }}
          </div>
          <span class="text-[10px] font-black text-text-muted uppercase tracking-widest truncate">
            {{ currentMarea.observador }}
          </span>
        </div>
      </div>
      <button @click="$emit('close')"
        class="p-2 hover:bg-surface-muted rounded-xl transition-all text-text-muted hover:text-text">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>

    <!-- Content -->
    <div class="flex-1 overflow-y-auto custom-scrollbar p-6 space-y-8">
      <!-- Loading State -->
      <div v-if="!context" class="flex flex-col items-center py-20">
        <LoadingSpinner size="lg" class="text-primary" />
        <span class="text-xs text-text-muted mt-4 font-bold uppercase tracking-widest">Cargando contexto...</span>
      </div>

      <template v-else>
        <!-- 1. Stats & Progress -->
        <section v-if="showOperationalInfo" class="space-y-6">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Estado & Progreso</h4>
            <span class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter shadow-sm"
              :class="getStatusClasses(context.marea.estado_codigo)">
              {{ context.marea.estado }}
            </span>
          </div>

          <!-- Progress Bar -->
          <div class="space-y-2">
            <div class="flex justify-between items-end">
              <span class="text-[10px] font-bold text-text-muted uppercase tracking-widest">Avance Estimado</span>
              <span v-if="currentMarea?.progreso !== undefined" class="text-xs font-black text-primary">{{
                currentMarea.progreso }}%</span>
            </div>
            <div class="h-2 w-full bg-surface-muted rounded-full overflow-hidden border border-border">
              <div class="h-full transition-all duration-1000 ease-out"
                :class="(currentMarea?.progreso || 0) > 100 ? 'bg-error' : 'bg-primary'"
                :style="{ width: (currentMarea?.progreso || 0) + '%' }"></div>
            </div>
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div
              class="bg-surface-muted/50 border border-border p-4 rounded-2xl hover:bg-surface transition-colors group">
              <p
                class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1 group-hover:text-primary transition-colors">
                Días Marea</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-text">{{ context.marea.dias_marea }}</span>
                <span class="text-[10px] font-bold text-text-muted">días</span>
              </div>
            </div>
            <div
              class="bg-surface-muted/50 border border-border p-4 rounded-2xl hover:bg-surface transition-colors group">
              <p
                class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1 group-hover:text-primary transition-colors">
                Días Nav.</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-text">{{ context.marea.dias_navegados }}</span>
                <span class="text-[10px] font-bold text-text-muted">días</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 2. Logistics Section -->
        <section v-if="showOperationalInfo" class="space-y-4">
          <div class="flex items-center justify-between cursor-pointer group"
            @click="isLogisticaCollapsed = !isLogisticaCollapsed">
            <div class="flex items-center gap-2">
              <h4
                class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted group-hover:text-primary transition-colors">
                Logística de Operación</h4>
              <ChevronRightIcon class="w-3 h-3 text-text-muted transition-transform duration-300"
                :class="{ 'rotate-90': !isLogisticaCollapsed }" />
              <button @click.stop="handleExportBundle"
                class="ml-2 p-1.5 rounded-lg bg-surface-muted/50 text-text-muted hover:bg-primary/10 hover:text-primary transition-all active:scale-95 group/btn"
                title="Exportar Logística (ZIP)" :disabled="isExporting">
                <DownloadIcon v-if="!isExporting" class="w-3.5 h-3.5" />
                <LoadingSpinner v-else size="xs" class="text-primary" />
              </button>
            </div>
            <span
              class="px-2 py-0.5 bg-surface-muted rounded text-[9px] font-bold text-text-muted uppercase tracking-tighter">
              {{ countEtapas }} {{ countEtapas === 1 ? 'Etapa' : 'Etapas' }}
            </span>
          </div>

          <div class="bg-primary/5 border border-primary/20 rounded-2xl p-5 space-y-4 relative overflow-hidden">
            <!-- Indicador En Tierra -->
            <div v-if="isEnTierra"
              class="absolute top-0 right-0 px-3 py-1 bg-success/10 text-success text-[10px] font-black uppercase tracking-tighter rounded-bl-xl border-l border-b border-success/20 z-10 flex items-center gap-1.5">
              <span class="flex h-1.5 w-1.5 relative">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-success opacity-75"></span>
                <span class="relative inline-flex rounded-full h-1.5 w-1.5 bg-success"></span>
              </span>
              En Tierra
            </div>

            <!-- CASE: DESIGNADA -->
            <template v-if="currentMarea.estado_codigo === 'DESIGNADA'">
              <div class="flex items-center gap-4">
                <div class="p-2.5 bg-surface rounded-xl shadow-sm text-primary shrink-0">
                  <ShipIcon class="w-4 h-4" />
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-[9px] font-bold text-primary uppercase tracking-widest mb-0.5">Zarpada Prevista</p>
                  <p class="text-sm font-black text-text truncate">
                    {{ formatDate(currentMarea.fecha_zarpada) }} <span class="mx-1 text-primary/60">en</span> {{
                      puertoZarpada }}
                  </p>
                </div>
              </div>
            </template>

            <!-- CASE: OTHER STATUSES (EXECUTION/REVISION) -->
            <template v-else>
              <div class="grid grid-cols-1 gap-3">
                <!-- Inicio Observador (Always Visible) -->
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-lg bg-surface flex items-center justify-center text-primary shrink-0">
                    <HistoryIcon class="w-3.5 h-3.5" />
                  </div>
                  <div>
                    <p class="text-[8px] font-bold text-text-muted uppercase tracking-widest mb-0.5">Inicio Obs.</p>
                    <p class="text-xs font-black text-text">{{ formatDate(currentMarea.fecha_inicio_observador) }}</p>
                  </div>
                </div>

                <!-- Navigation Summary (Collapsed) or Stages List (Expanded) -->
                <div v-if="isLogisticaCollapsed" class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-lg bg-surface flex items-center justify-center text-primary shrink-0">
                    <ShipIcon class="w-3.5 h-3.5" />
                  </div>
                  <div>
                    <p class="text-[8px] font-bold text-text-muted uppercase tracking-widest mb-0.5">Navegación</p>
                    <p class="text-xs font-black text-text">
                      {{ firstStageZarpada }} - {{ lastStageArribo }}
                    </p>
                  </div>
                </div>

                <!-- Stages List (Expanded) -->
                <div v-else class="space-y-1.5 py-1">
                  <div v-for="etapa in (props.context?.marea?.etapas || [])" :key="etapa.id"
                    class="flex items-center justify-between p-2.5 rounded-xl bg-surface/50 border border-border/10">
                    <div class="flex items-center gap-3">
                      <span class="text-[10px] font-black text-primary w-5">#{{ etapa.nroEtapa }}</span>
                      <div class="flex flex-col">
                        <div class="flex items-center gap-1.5">
                          <p class="text-[10px] font-bold text-text truncate max-w-[110px]">
                            {{ etapa.puertoZarpadaCodigo || etapa.puertoZarpadaNombre || '?' }} → {{ etapa.puertoArriboCodigo || etapa.puertoArriboNombre || '?' }}
                          </p>
                          <span v-if="etapa.tipoEtapa === 'EP'" title="Etapa de Prospección" class="px-1.5 py-0.5 bg-purple-500/10 text-purple-600 rounded-[4px] text-[8px] font-black uppercase tracking-tighter border border-purple-500/20 leading-none shrink-0">
                            P
                          </span>
                        </div>
                      </div>
                    </div>
                    <div class="text-[9px] font-bold text-text-muted tabular-nums whitespace-nowrap">
                      {{ formatDate(etapa.fechaZarpada) }} - {{ formatDate(etapa.fechaArribo) || 'Nav...' }}
                    </div>
                  </div>
                </div>

                <!-- Fin Observador (Always Visible) -->
                <div class="flex items-center gap-3">
                  <div class="w-8 h-8 rounded-lg bg-surface flex items-center justify-center text-primary shrink-0">
                    <SportsScoreIcon class="w-3.5 h-3.5" />
                  </div>
                  <div>
                    <p class="text-[8px] font-bold text-text-muted uppercase tracking-widest mb-0.5">Fin Obs.</p>
                    <p class="text-xs font-black text-text">{{ formatDate(currentMarea.fecha_fin_observador) }}</p>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </section>

        <!-- 3. Actions -->
        <section v-if="!readOnly && canManage" class="space-y-4">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted italic">Acciones sugeridas</h4>
          </div>
          <div class="flex flex-col gap-2.5">
            <button v-for="(action, key) in context.actions" :key="key" @click="onAction(key)"
              class="group relative flex items-center justify-between p-4 rounded-2xl border transition-all duration-300"
              :class="[
                action.enabled
                  ? 'bg-surface border-border hover:shadow-lg transition-all'
                  : 'bg-surface-muted/30 border-border/50 text-text-muted cursor-not-allowed',
                action.enabled && action.claseBoton === 'error' ? 'hover:border-error/50 hover:shadow-error/5' : 'hover:border-primary/50 hover:shadow-primary/5'
              ]" :disabled="!action.enabled">
              <div class="flex items-center gap-4">
                <div class="p-2 rounded-xl transition-colors" :class="[
                  !action.enabled ? 'bg-surface-muted text-text-muted' :
                    action.claseBoton === 'error' ? 'bg-error/10 text-error' : 'bg-primary/10 text-primary'
                ]">
                  <component :is="getActionIcon(key)" class="w-4 h-4" />
                </div>
                <div class="text-left">
                  <p class="text-sm font-bold"
                    :class="action.enabled && action.claseBoton === 'error' ? 'text-error' : 'text-text'">{{
                      action.label }}</p>
                  <p v-if="!action.enabled" class="text-[10px] font-medium text-text-muted mt-0.5">{{
                    action.blockedReason }}</p>
                </div>
              </div>
              <ChevronRightIcon v-if="action.enabled" class="w-4 h-4 transition-transform group-hover:translate-x-1"
                :class="action.claseBoton === 'error' ? 'text-error/40' : 'text-text-muted/40'" />
              <LockIcon v-else class="w-3.5 h-3.5 text-text-muted/40" />
            </button>
          </div>
        </section>

        <!-- 3.5 Trajectory Quick Access -->
        <button @click="$emit('view-trajectory')"
          class="w-full py-3.5 bg-primary/5 border border-primary/20 hover:border-primary/50 text-text rounded-2xl text-sm font-black transition-all hover:shadow-lg hover:shadow-primary/5 active:scale-[0.98] flex items-center justify-center gap-3 group">
          <MapPinIcon class="w-5 h-5 text-primary transition-transform group-hover:scale-110" />
          <span>Visualizar Trayectoria</span>
          <ChevronRightIcon class="w-4 h-4 ml-auto text-primary/40 group-hover:translate-x-1 transition-transform" />
        </button>

        <!-- 4. Active Alerts -->
        <section v-if="currentMarea?.alertas?.length" class="space-y-4">
          <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-error flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/40 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-error"></span>
            </span>
            Alertas Críticas
          </h4>
          <div class="space-y-3">
            <div v-for="alerta in currentMarea.alertas" :key="alerta.id"
              class="p-4 bg-error/5 border border-error/20 rounded-2xl relative overflow-hidden group">
              <div class="absolute top-0 right-0 p-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <WarningIcon class="w-12 h-12 text-error/10 -mr-4 -mt-4 rotate-12" />
              </div>
              <p class="text-xs font-black text-error uppercase tracking-tight">{{ alerta.titulo }}</p>
              <p class="text-[11px] text-error/80 mt-1 leading-relaxed">{{ alerta.descripcion }}</p>
              <div v-if="!readOnly" class="flex justify-end mt-4">
                <button @click="$emit('manage-alert', alerta)"
                  class="px-4 py-2 bg-error text-error-fg text-[10px] font-black uppercase tracking-widest rounded-xl hover:opacity-90 transition-all shadow-lg shadow-error/20 active:scale-95 flex items-center gap-2">
                  Gestionar
                  <ChevronRightIcon class="w-3 h-3" />
                </button>
              </div>
            </div>
          </div>
        </section>

        <!-- 5. Quick Timeline -->
        <section class="space-y-4 pb-4">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Actividad Reciente</h4>
            <HistoryIcon class="w-4 h-4 text-text-muted/40" />
          </div>
          <div class="relative pl-6 space-y-6">
            <div class="absolute left-[7px] top-2 bottom-2 w-[1px] bg-border"></div>
            <div v-for="event in context.lastEvents" :key="event.id" class="relative group">
              <div
                class="absolute -left-[23px] top-1.5 w-2 h-2 rounded-full border-2 border-surface bg-primary z-10 transition-transform group-hover:scale-125">
              </div>
              <div>
                <p class="text-[11px] font-bold text-text">{{ event.titulo }}</p>
                <div class="flex items-center gap-2 mt-0.5">
                  <span class="text-[10px] text-text-muted font-mono">{{ formatDate(event.fecha) }}</span>
                  <span class="w-1 h-1 rounded-full bg-border"></span>
                  <span class="text-[10px] text-primary font-bold uppercase tracking-tighter">{{ event.usuario }}</span>
                </div>
                <div v-if="event.comentarios" class="mt-1.5 p-2 bg-surface-muted/30 border-l-2 border-primary/30 rounded-r-lg">
                  <p class="text-[10px] text-text-muted leading-relaxed italic">
                    {{ event.comentarios }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>
      </template>
    </div>

    <!-- Footer Actions -->
    <div class="p-6 border-t border-border bg-surface-muted/50 space-y-3 shrink-0">
      <button v-if="canViewFullDetail" @click="$emit('open-detalle')"
        :disabled="currentMarea.estado_codigo === 'A_REASIGNAR'"
        class="w-full py-3.5 rounded-2xl text-sm font-bold shadow-xl transition-all flex items-center justify-center gap-2"
        :class="currentMarea.estado_codigo === 'A_REASIGNAR' 
          ? 'bg-surface-muted text-text-muted/50 cursor-not-allowed shadow-none' 
          : 'bg-primary hover:bg-primary-hover text-primary-fg shadow-primary/20 hover:-translate-y-0.5 active:scale-[0.98]'">
        <LockIcon v-if="currentMarea.estado_codigo === 'A_REASIGNAR'" class="w-4 h-4" />
        <DocsIcon v-else class="w-4 h-4" />
        <span v-if="currentMarea.estado_codigo === 'A_REASIGNAR'">Edición Bloqueada</span>
        <span v-else-if="currentMarea.estado_codigo === 'DESIGNADA' && canManage">Editar Datos Básicos</span>
        <span v-else>{{ buttonText }}</span>
      </button>

      <button @click="$emit('close')"
        class="w-full py-3 text-text-muted text-xs font-bold hover:text-text transition-colors">
        Cerrar Panel
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import httpClient from '@/config/http/http.client'
import { toast } from 'vue-sonner'
import {
  ChevronRightIcon,
  LockIcon,
  HistoryIcon,
  WarningIcon,
  DocsIcon,
  MapPinIcon,
  CloudUploadIcon,
  PlusIcon,
  TaskIcon,
  ShipIcon,
  SearchIcon,
  EditIcon,
  CheckIcon,
  HorizontalDots,
  ArrowLeftIcon,
  SendIcon,
  SuccessIcon,
  ErrorIcon,
  ShieldIcon,
  SportsScoreIcon,
  ArchiveIcon,
  DownloadIcon
} from '@/icons'
import type { MareaContext } from '../types/marea.types'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

interface Props {
  marea: any | null
  context: MareaContext | null
  readOnly?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  readOnly: false
})

const emit = defineEmits(['close', 'open-detalle', 'action', 'manage-alert', 'view-trajectory'])

const authStore = useAuthStore()

const canManage = computed(() => {
  const roles = authStore.user?.roles || []
  return roles.includes(ValidRoles.admin) || roles.includes(ValidRoles.tecnico)
})

const canViewFullDetail = computed(() => {
  const roles = authStore.user?.roles || []
  return canManage.value || roles.includes(ValidRoles.asistente) || roles.includes(ValidRoles.coordinador)
})

const buttonText = computed(() => {
  return canManage.value ? 'Editar Detalles Completos' : 'Consultar Detalles Completos'
})

const showOperationalInfo = computed(() => {
  const estado = currentMarea.value?.estado_codigo
  return estado !== 'DESIGNADA' && estado !== 'A_REASIGNAR'
})

const currentMarea = computed(() => {
  const m = props.context?.marea || props.marea
  // Fallback de seguridad: si el contexto no trajo progreso, usar el de la lista original
  if (m && m.progreso === undefined && props.marea?.progreso !== undefined) {
    return { ...m, progreso: props.marea.progreso }
  }
  return m
})

const mareaTitle = computed(() => {
  return currentMarea.value?.buque_nombre || currentMarea.value?.buque?.nombre || 'Marea sin nombre'
})

const mareaCode = computed(() => {
  return currentMarea.value?.id_marea || '0000-000'
})

const countEtapas = computed(() => {
  return props.context?.marea?.etapas?.length || 0
})

const isEnTierra = computed(() => {
  if (!props.context?.marea) return false
  const m = props.context.marea
  if (m.estado_codigo !== 'EN_EJECUCION') return false
  const etapas = m.etapas
  if (!etapas || etapas.length === 0) return false
  return etapas.every((e: any) => e.fechaArribo && e.puertoArriboId)
})

const finalArribo = computed(() => {
  if (!props.context?.marea) return null
  const etapas = props.context.marea.etapas
  if (!etapas || etapas.length === 0) return null

  const allComplete = etapas.every((e: any) => e.fechaArribo && e.puertoArriboId)
  if (!allComplete) return null

  // Stages are ordered by nroEtapa desc
  return etapas[0]
})

const puertoZarpada = computed(() => {
  const m = props.context?.marea || props.marea
  // Prioridad al puerto base si es designada
  if (m?.estado_codigo === 'DESIGNADA') {
    return m.puertoBaseCodigo || m.puertoBaseNombre || 'N/D'
  }
  // Si tenemos etapas, obtener la zarpada de la primera etapa (nroEtapa 1)
  if (props.context?.marea?.etapas?.length) {
    const stages = props.context.marea.etapas
    const firstStage = stages.find((e: any) => e.nroEtapa === 1) || stages[0]
    return firstStage.puertoZarpadaCodigo || firstStage.puertoZarpadaNombre || m?.puerto || 'N/D'
  }
  return m?.puerto || 'N/D'
})

const isLogisticaCollapsed = ref(true)
const isExporting = ref(false)

const handleExportBundle = async () => {
  if (isExporting.value) return
  
  try {
    isExporting.value = true
    const mareaId = currentMarea.value?.id
    if (!mareaId) throw new Error('ID de marea no encontrado')

    const response = await httpClient.get(`/tracking/export/bundle/${mareaId}`, { 
      responseType: 'blob' 
    })
    
    // Extract filename from Content-Disposition if possible
    const contentDisposition = response.headers['content-disposition']
    let fileName = 'Marea_export.zip'

    // Fallback robusto basado en id_marea (ej: "0726-26" -> "Marea_726.zip")
    const m = currentMarea.value
    if (m?.id_marea) {
      const parts = m.id_marea.split('-')
      if (parts.length === 2) {
        const nro = parseInt(parts[0], 10)
        const anio = parts[1]
        fileName = `Marea_${nro}${anio}.zip`
      }
    }

    if (contentDisposition) {
      const fileNameMatch = contentDisposition.match(/filename=["']?([^"';]+)["']?/)
      if (fileNameMatch) fileName = fileNameMatch[1]
    }

    const url = window.URL.createObjectURL(new Blob([response.data]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', fileName)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)

    toast.success('Exportación generada correctamente')
  } catch (error) {
    console.error('Export error:', error)
    toast.error('No se pudo generar la exportación de logística')
  } finally {
    isExporting.value = false
  }
}

const firstStageZarpada = computed(() => {
  const etapas = props.context?.marea?.etapas
  if (!etapas || etapas.length === 0) return '---'
  // Etapas ordenadas por número ascendente, la primera es el índice 0
  const first = etapas[0]
  return first.fechaZarpada ? formatDate(first.fechaZarpada) : '---'
})

const lastStageArribo = computed(() => {
  const etapas = props.context?.marea?.etapas
  if (!etapas || etapas.length === 0) return '---'
  // Etapas ordenadas por número ascendente, la última etapa es el final del array
  const last = etapas[etapas.length - 1]
  if (last.fechaArribo) return formatDate(last.fechaArribo)
  return 'Navegando'
})

const getStatusClasses = (status?: string) => {
  if (!status) return 'bg-surface-muted text-text-muted'

  const s = status.toUpperCase()
  if (s.includes('NAVEGANDO'))
    return 'bg-info/10 text-info'
  if (s.includes('ESPERANDO') || s.includes('ZARPADA') || s.includes('DESIGNADA'))
    return 'bg-warning/10 text-warning'
  if (s.includes('BLOQUEADA') || s.includes('ERROR'))
    return 'bg-error/10 text-error'
  if (s.includes('ARRIBADA') || s.includes('FINAL'))
    return 'bg-success/10 text-success'

  return 'bg-surface-muted text-text-muted'
}

const getActionIcon = (key: string | number) => {
  const meta: Record<string, any> = {
    REGISTRAR_INICIO: TaskIcon,
    REGISTRAR_FINALIZACION: MapPinIcon,
    EDITAR_ETAPAS: EditIcon,
    RECIBIR_DATOS: CloudUploadIcon,
    INICIAR_VERIFICACION: SearchIcon,
    ABRIR_CORRECCION: EditIcon,
    PASAR_A_INFORME: DocsIcon,
    FINALIZAR_CORRECCION: CheckIcon,
    DELEGAR_EXTERNA: HorizontalDots,
    RETORNAR_CORRECCION: ArrowLeftIcon,
    ENVIAR_A_REVISION: SendIcon,
    APROBAR_INFORME: SuccessIcon,
    RECHAZAR_INFORME: ErrorIcon,
    INICIAR_TRAMITE: HistoryIcon,
    FINALIZAR_PROTOCOLIZACION: ShieldIcon,
    CANCELAR: ErrorIcon,
    PASAR_A_REASIGNAR: ArchiveIcon
  }
  return meta[key] || PlusIcon
}

const onAction = (key: string | number) => {
  emit('action', key)
}

const formatDate = (date?: string) => {
  if (!date) return '---'
  const d = new Date(date)
  return d.toLocaleDateString()
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
  background: var(--color-border);
  border-radius: 10px;
}

.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
}
</style>
