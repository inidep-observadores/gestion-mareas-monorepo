<template>
  <div class="flex flex-col h-full overflow-hidden bg-background">
    <!-- Header -->
    <div class="p-4 border-b border-border flex items-center justify-between bg-surface-muted/50 shrink-0">
      <div class="flex-1 min-w-0">
        <h3 class="text-lg font-black text-text truncate leading-tight">
          {{ mareaTitle }}
        </h3>
        <div class="flex items-center gap-2 mt-0.5">
           <div class="px-1.5 py-0.5 bg-primary/10 rounded text-[10px] font-mono font-bold text-primary uppercase tracking-wider">
             {{ mareaCode }}
           </div>
           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest truncate">
             {{ marea.observador }}
           </span>
        </div>
      </div>
      <button 
        @click="$emit('close')"
        class="p-2 hover:bg-surface-muted rounded-xl transition-all text-text-muted hover:text-text"
      >
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
        <section class="space-y-6">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Estado & Progreso</h4>
            <span
              class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter shadow-sm"
              :class="getStatusClasses(context.marea.estado_codigo)"
            >
              {{ context.marea.estado }}
            </span>
          </div>

          <!-- Progress Bar -->
          <div class="space-y-2">
            <div class="flex justify-between items-end">
              <span class="text-[10px] font-bold text-text-muted uppercase tracking-widest">Avance Estimado</span>
              <span class="text-xs font-black text-primary">{{ marea.progreso }}%</span>
            </div>
            <div class="h-2 w-full bg-surface-muted rounded-full overflow-hidden border border-border">
              <div 
                class="h-full transition-all duration-1000 ease-out"
                :class="marea.progreso > 100 ? 'bg-error' : 'bg-primary'"
                :style="{ width: marea.progreso + '%' }"
              ></div>
            </div>
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div class="bg-surface-muted/50 border border-border p-4 rounded-2xl hover:bg-surface transition-colors group">
              <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1 group-hover:text-primary transition-colors">Días Marea</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-text">{{ context.marea.dias_marea }}</span>
                <span class="text-[10px] font-bold text-text-muted">días</span>
              </div>
            </div>
            <div class="bg-surface-muted/50 border border-border p-4 rounded-2xl hover:bg-surface transition-colors group">
              <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1 group-hover:text-primary transition-colors">Días Nav.</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-text">{{ context.marea.dias_navegados }}</span>
                <span class="text-[10px] font-bold text-text-muted">días</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 2. Logistics Section -->
        <section class="space-y-4">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Logística de Operación</h4>
            <span class="px-2 py-0.5 bg-surface-muted rounded text-[9px] font-bold text-text-muted uppercase tracking-tighter">
              {{ countEtapas }} {{ countEtapas === 1 ? 'Etapa' : 'Etapas' }}
            </span>
          </div>
          
          <div class="bg-primary/5 border border-primary/20 rounded-2xl p-5 space-y-4 relative overflow-hidden">
            <!-- Indicador En Tierra -->
            <div v-if="isEnTierra" class="absolute top-0 right-0 px-3 py-1 bg-success/10 text-success text-[10px] font-black uppercase tracking-tighter rounded-bl-xl border-l border-b border-success/20 z-10 flex items-center gap-1.5">
              <span class="flex h-1.5 w-1.5 relative">
                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-success opacity-75"></span>
                <span class="relative inline-flex rounded-full h-1.5 w-1.5 bg-success"></span>
              </span>
              En Tierra
            </div>

            <div class="flex items-center gap-4">
              <div class="p-2.5 bg-surface rounded-xl shadow-sm text-primary shrink-0">
                <ShipIcon class="w-4 h-4" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-[9px] font-bold text-primary uppercase tracking-widest mb-0.5">Zarpada Confirmada</p>
                <p class="text-sm font-black text-text truncate">
                  {{ formatDate(marea.fecha_zarpada) }} <span class="mx-1 text-primary/60">en</span> {{ puertoZarpada }}
                </p>
              </div>
            </div>

            <!-- Arribo Final (Condicional) -->
            <div v-if="finalArribo" class="flex items-center gap-4 pt-4 border-t border-primary/10">
              <div class="p-2.5 bg-surface rounded-xl shadow-sm text-primary shrink-0">
                <MapPinIcon class="w-4 h-4" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="text-[9px] font-bold text-primary uppercase tracking-widest mb-0.5">Arribo Final</p>
                <p class="text-sm font-black text-text truncate">
                  {{ formatDate(finalArribo.fechaArribo) }} <span class="mx-1 text-primary/60">en</span> {{ finalArribo.puertoArriboNombre }}
                </p>
              </div>
            </div>
          </div>
        </section>

        <!-- 3. Actions -->
        <section v-if="!readOnly" class="space-y-4">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 italic">Acciones sugeridas</h4>
          </div>
          <div class="flex flex-col gap-2.5">
            <button
              v-for="(action, key) in context.actions"
              :key="key"
              @click="onAction(key)"
              class="group relative flex items-center justify-between p-4 rounded-2xl border transition-all duration-300"
              :class="action.enabled 
                ? 'bg-white dark:bg-gray-950 border-gray-200 dark:border-gray-800 hover:border-brand-500/50 hover:shadow-lg hover:shadow-brand-500/5 text-gray-700 dark:text-gray-200' 
                : 'bg-gray-50/50 dark:bg-gray-900/30 border-gray-100 dark:border-gray-800/50 text-gray-400 cursor-not-allowed'"
              :disabled="!action.enabled"
            >
              <div class="flex items-center gap-4">
                <div 
                  class="p-2 rounded-xl transition-colors"
                  :class="action.enabled ? 'bg-primary/10 text-primary' : 'bg-surface-muted text-text-muted'"
                >
                  <component :is="getActionIcon(key)" class="w-4 h-4" />
                </div>
                <div class="text-left">
                  <p class="text-sm font-bold">{{ action.label }}</p>
                  <p v-if="!action.enabled" class="text-[10px] font-medium text-text-muted mt-0.5">{{ action.blockedReason }}</p>
                </div>
              </div>
              <ChevronRightIcon v-if="action.enabled" class="w-4 h-4 transition-transform group-hover:translate-x-1 text-text-muted/40" />
              <LockIcon v-else class="w-3.5 h-3.5 text-text-muted/40" />
            </button>
          </div>
        </section>

        <!-- 4. Active Alerts -->
        <section v-if="marea?.alertas?.length" class="space-y-4">
          <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-error flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/40 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-error"></span>
            </span>
            Alertas Críticas
          </h4>
          <div class="space-y-3">
            <div 
              v-for="alerta in marea.alertas" 
              :key="alerta.id"
              class="p-4 bg-error/5 border border-error/20 rounded-2xl relative overflow-hidden group"
            >
              <div class="absolute top-0 right-0 p-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <WarningIcon class="w-12 h-12 text-error/10 -mr-4 -mt-4 rotate-12" />
              </div>
              <p class="text-xs font-black text-error uppercase tracking-tight">{{ alerta.titulo }}</p>
              <p class="text-[11px] text-error/80 mt-1 leading-relaxed">{{ alerta.descripcion }}</p>
              <div v-if="!readOnly" class="flex justify-end mt-4">
                <button 
                  @click="$emit('manage-alert', alerta)"
                  class="px-4 py-2 bg-error text-error-fg text-[10px] font-black uppercase tracking-widest rounded-xl hover:opacity-90 transition-all shadow-lg shadow-error/20 active:scale-95 flex items-center gap-2"
                >
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
              <div class="absolute -left-[23px] top-1.5 w-2 h-2 rounded-full border-2 border-surface bg-primary z-10 transition-transform group-hover:scale-125"></div>
              <div>
                <p class="text-[11px] font-bold text-text">{{ event.titulo }}</p>
                <div class="flex items-center gap-2 mt-0.5">
                  <span class="text-[10px] text-text-muted font-mono">{{ formatDate(event.fecha) }}</span>
                  <span class="w-1 h-1 rounded-full bg-border"></span>
                  <span class="text-[10px] text-primary font-bold uppercase tracking-tighter">{{ event.usuario }}</span>
                </div>
              </div>
            </div>
          </div>
        </section>
      </template>
    </div>

    <!-- Footer Actions -->
    <div class="p-6 border-t border-border bg-surface-muted/50 space-y-3 shrink-0">
      <button 
        v-if="!readOnly"
        @click="$emit('open-detalle')"
        class="w-full py-3.5 bg-primary hover:bg-primary-hover text-primary-fg rounded-2xl text-sm font-bold shadow-xl shadow-primary/20 transition-all hover:-translate-y-0.5 active:scale-[0.98] flex items-center justify-center gap-2"
      >
        <DocsIcon class="w-4 h-4" />
        Editar Detalles Completos
      </button>
      <button 
        @click="$emit('close')"
        class="w-full py-3 text-text-muted text-xs font-bold hover:text-text transition-colors"
      >
        Cerrar Panel
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
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
  ShieldIcon
} from '@/icons'
import type { MareaContext } from '../services/mareas.service'

interface Props {
  marea: any | null
  context: MareaContext | null
  readOnly?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  readOnly: false
})

const mareaTitle = computed(() => {
  const m = props.context?.marea || props.marea
  return m?.buque_nombre || m?.buque?.nombre || 'Marea sin nombre'
})

const mareaCode = computed(() => {
  const m = props.context?.marea || props.marea
  return m?.id_marea || '0000-000'
})

const emit = defineEmits(['close', 'open-detalle', 'action', 'manage-alert'])

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
  // If we have stages, get the zarpada of the first stage (ordered by desc)
  if (props.context?.marea?.etapas?.length) {
    // This is a bit tricky since etapas are desc, but maybe we want the first stage's zarpada?
    // User wants "Fecha de zarpada y puerto" in one line.
    // Usually means the "Initial zarpada" or the current one.
    // Let's assume the first stage ever (last in desc array).
    const stages = props.context.marea.etapas
    return stages[stages.length - 1].puertoZarpadaNombre || m?.puerto || 'N/D'
  }
  return m?.puerto || 'N/D'
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
    REGISTRAR_ARRIBO: MapPinIcon,
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
    FINALIZAR_PROTOCOLIZACION: ShieldIcon
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
  background: #e2e8f0;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}
</style>
