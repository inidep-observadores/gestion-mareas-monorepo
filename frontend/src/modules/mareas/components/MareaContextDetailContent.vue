<template>
  <div class="flex flex-col h-full overflow-hidden bg-white dark:bg-gray-950">
    <!-- Header -->
    <div class="p-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between bg-gray-50/50 dark:bg-gray-900/50 shrink-0">
      <div class="flex-1 min-w-0">
        <h3 class="text-lg font-black text-gray-900 dark:text-white truncate leading-tight">
          {{ mareaTitle }}
        </h3>
        <div class="flex items-center gap-2 mt-0.5">
           <div class="px-1.5 py-0.5 bg-brand-500/10 rounded text-[10px] font-mono font-bold text-brand-600 dark:text-brand-400 uppercase tracking-wider">
             {{ mareaCode }}
           </div>
           <span class="text-[10px] font-black text-gray-400 dark:text-gray-500 uppercase tracking-widest truncate">
             {{ marea.observador }}
           </span>
        </div>
      </div>
      <button 
        @click="$emit('close')"
        class="p-2 hover:bg-gray-200 dark:hover:bg-gray-800 rounded-xl transition-all text-gray-400 hover:text-gray-600 dark:hover:text-gray-200"
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
        <div class="loading loading-spinner text-brand-500"></div>
        <span class="text-xs text-gray-400 mt-4 font-bold uppercase tracking-widest">Cargando contexto...</span>
      </div>

      <template v-else>
        <!-- 1. Stats & Progress -->
        <section class="space-y-6">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Estado & Progreso</h4>
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
              <span class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Avance Estimado</span>
              <span class="text-xs font-black text-brand-500">{{ marea.progreso }}%</span>
            </div>
            <div class="h-2 w-full bg-gray-100 dark:bg-gray-900 rounded-full overflow-hidden border border-gray-50 dark:border-gray-800">
              <div 
                class="h-full transition-all duration-1000 ease-out shadow-[0_0_12px_rgba(59,130,246,0.3)]"
                :class="marea.progreso > 100 ? 'bg-error-500' : 'bg-brand-500'"
                :style="{ width: marea.progreso + '%' }"
              ></div>
            </div>
          </div>

          <div class="grid grid-cols-2 gap-3">
            <div class="bg-gray-50/50 dark:bg-gray-900/50 border border-gray-100 dark:border-gray-800/60 p-4 rounded-2xl hover:bg-white dark:hover:bg-gray-900 transition-colors group">
              <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-1 group-hover:text-brand-500 transition-colors">Días Marea</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-gray-800 dark:text-gray-100">{{ context.marea.dias_marea }}</span>
                <span class="text-[10px] font-bold text-gray-400">días</span>
              </div>
            </div>
            <div class="bg-gray-50/50 dark:bg-gray-900/50 border border-gray-100 dark:border-gray-800/60 p-4 rounded-2xl hover:bg-white dark:hover:bg-gray-900 transition-colors group">
              <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-1 group-hover:text-brand-500 transition-colors">Días Nav.</p>
              <div class="flex items-baseline gap-1">
                <span class="text-2xl font-black text-gray-800 dark:text-gray-100">{{ context.marea.dias_navegados }}</span>
                <span class="text-[10px] font-bold text-gray-400">días</span>
              </div>
            </div>
          </div>
        </section>

        <!-- 2. Logistics Section -->
        <section class="space-y-4">
          <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Logística de Operación</h4>
          <div class="bg-indigo-50/30 dark:bg-indigo-500/5 border border-indigo-100/50 dark:border-indigo-500/10 rounded-2xl p-5 space-y-4">
            <div class="flex items-center gap-4">
              <div class="p-2.5 bg-white dark:bg-gray-900 rounded-xl shadow-sm text-indigo-500">
                <ShipIcon class="w-4 h-4" />
              </div>
              <div class="flex-1">
                <p class="text-[9px] font-bold text-indigo-400 uppercase tracking-widest mb-0.5">Zarpada Confirmada</p>
                <p class="text-sm font-black text-gray-700 dark:text-gray-300">
                  {{ formatDate(marea.fecha_zarpada) }}
                </p>
              </div>
            </div>
            <div class="flex items-center gap-4">
              <div class="p-2.5 bg-white dark:bg-gray-900 rounded-xl shadow-sm text-indigo-500">
                <MapPinIcon class="w-4 h-4" />
              </div>
              <div class="flex-1">
                <p class="text-[9px] font-bold text-indigo-400 uppercase tracking-widest mb-0.5">Puerto Base / Operación</p>
                <p class="text-sm font-black text-gray-700 dark:text-gray-300">
                  {{ marea.puerto }}
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
                  :class="action.enabled ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-500' : 'bg-gray-100 dark:bg-gray-800 text-gray-400'"
                >
                  <component :is="getActionIcon(key)" class="w-4 h-4" />
                </div>
                <div class="text-left">
                  <p class="text-sm font-bold">{{ action.label }}</p>
                  <p v-if="!action.enabled" class="text-[10px] font-medium text-gray-400 mt-0.5">{{ action.blockedReason }}</p>
                </div>
              </div>
              <ChevronRightIcon v-if="action.enabled" class="w-4 h-4 transition-transform group-hover:translate-x-1 text-gray-300" />
              <LockIcon v-else class="w-3.5 h-3.5 text-gray-300" />
            </button>
          </div>
        </section>

        <!-- 4. Active Alerts -->
        <section v-if="marea?.alertas?.length" class="space-y-4">
          <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-error-500 flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error-400 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-error-500"></span>
            </span>
            Alertas Críticas
          </h4>
          <div class="space-y-3">
            <div 
              v-for="alerta in marea.alertas" 
              :key="alerta.id"
              class="p-4 bg-error-50 dark:bg-error-500/5 border border-error-100 dark:border-error-500/10 rounded-2xl relative overflow-hidden group"
            >
              <div class="absolute top-0 right-0 p-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <WarningIcon class="w-12 h-12 text-error-500/10 -mr-4 -mt-4 rotate-12" />
              </div>
              <p class="text-xs font-black text-error-700 dark:text-error-400 uppercase tracking-tight">{{ alerta.titulo }}</p>
              <p class="text-[11px] text-error-600/80 dark:text-error-500/80 mt-1 leading-relaxed">{{ alerta.descripcion }}</p>
              <div class="flex gap-3 mt-4">
                <button class="px-3 py-1.5 bg-error-500 text-white text-[10px] font-bold rounded-lg hover:bg-error-600 transition-all shadow-lg shadow-error-500/20 active:scale-95">
                  Confirmar
                </button>
                <button class="px-3 py-1.5 text-[10px] font-bold text-error-500 hover:bg-error-100 dark:hover:bg-error-500/10 rounded-lg transition-all">
                  Ignorar
                </button>
              </div>
            </div>
          </div>
        </section>

        <!-- 5. Quick Timeline -->
        <section class="space-y-4 pb-4">
          <div class="flex items-center justify-between">
            <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Actividad Reciente</h4>
            <HistoryIcon class="w-4 h-4 text-gray-300" />
          </div>
          <div class="relative pl-6 space-y-6">
            <div class="absolute left-[7px] top-2 bottom-2 w-[1px] bg-gray-100 dark:bg-gray-800"></div>
            <div v-for="event in context.lastEvents" :key="event.id" class="relative group">
              <div class="absolute -left-[23px] top-1.5 w-2 h-2 rounded-full border-2 border-white dark:border-gray-950 bg-brand-500 z-10 transition-transform group-hover:scale-125"></div>
              <div>
                <p class="text-[11px] font-bold text-gray-700 dark:text-gray-200">{{ event.titulo }}</p>
                <div class="flex items-center gap-2 mt-0.5">
                  <span class="text-[10px] text-gray-400 font-mono">{{ formatDate(event.fecha) }}</span>
                  <span class="w-1 h-1 rounded-full bg-gray-200 dark:bg-gray-700"></span>
                  <span class="text-[10px] text-brand-500 font-bold uppercase tracking-tighter">{{ event.usuario }}</span>
                </div>
              </div>
            </div>
          </div>
        </section>
      </template>
    </div>

    <!-- Footer Actions -->
    <div class="p-6 border-t border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50 space-y-3 shrink-0">
      <button 
        v-if="!readOnly"
        @click="$emit('open-detalle')"
        class="w-full py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-2xl text-sm font-bold shadow-xl shadow-brand-500/20 transition-all hover:-translate-y-0.5 active:scale-[0.98] flex items-center justify-center gap-2"
      >
        <DocsIcon class="w-4 h-4" />
        Editar Detalles Completos
      </button>
      <button 
        @click="$emit('close')"
        class="w-full py-3 text-gray-500 dark:text-gray-400 text-xs font-bold hover:text-gray-700 dark:hover:text-gray-200 transition-colors"
      >
        Cerrar Panel
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
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

const emit = defineEmits(['close', 'open-detalle', 'action'])

const getStatusClasses = (status?: string) => {
  if (!status) return 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-400'
  
  const s = status.toUpperCase()
  if (s.includes('NAVEGANDO'))
    return 'bg-blue-100 text-blue-700 dark:bg-blue-500/20 dark:text-blue-400'
  if (s.includes('ESPERANDO') || s.includes('ZARPADA') || s.includes('DESIGNADA'))
    return 'bg-amber-100 text-amber-700 dark:bg-amber-500/20 dark:text-amber-400'
  if (s.includes('BLOQUEADA') || s.includes('ERROR'))
    return 'bg-red-100 text-red-700 dark:bg-red-500/20 dark:text-red-400'
  if (s.includes('ARRIBADA') || s.includes('FINAL'))
    return 'bg-green-100 text-green-700 dark:bg-green-500/20 dark:text-green-400'
  
  return 'bg-gray-100 text-gray-700 dark:bg-gray-800 dark:text-gray-400'
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
