<template>
  <Transition
    enter-active-class="transition duration-300 ease-out"
    enter-from-class="translate-x-full opacity-0"
    enter-to-class="translate-x-0 opacity-100"
    leave-active-class="transition duration-200 ease-in"
    leave-from-class="translate-x-0 opacity-100"
    leave-to-class="translate-x-full opacity-0"
  >
    <div
      v-if="isOpen && marea"
      class="fixed inset-y-0 right-0 w-[400px] bg-white dark:bg-gray-950 shadow-2xl z-[60] border-l border-gray-200 dark:border-gray-800 flex flex-col"
    >
      <!-- Header -->
      <div class="p-6 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between bg-gray-50/50 dark:bg-gray-900/50">
        <div>
          <div class="flex items-center gap-2 mb-1">
            <div class="p-1.5 bg-brand-50 dark:bg-brand-900/30 rounded-lg">
              <ShipIcon class="w-5 h-5 text-brand-500" />
            </div>
            <h3 class="text-lg font-bold text-gray-800 dark:text-white leading-tight">
              {{ marea.buque_nombre || 'Sin Buque' }}
            </h3>
          </div>
          <p class="text-[10px] text-gray-400 font-mono tracking-wider uppercase ml-9">
             {{ marea.id_marea }}
          </p>
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
          <!-- 1. Stats -->
          <section class="space-y-4">
            <div class="flex items-center justify-between">
              <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Resumen Operativo</h4>
              <span
                class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter"
                :class="getStatusClasses(context.marea.estado_codigo)"
              >
                {{ context.marea.estado }}
              </span>
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div class="bg-gray-50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 p-4 rounded-2xl">
                <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-1">Días Marea</p>
                <div class="flex items-baseline gap-1">
                  <span class="text-2xl font-black text-gray-800 dark:text-gray-100">{{ context.marea.dias_marea }}</span>
                  <span class="text-[10px] font-bold text-gray-400">días</span>
                </div>
              </div>
              <div class="bg-gray-50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 p-4 rounded-2xl">
                <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-1">Días Nav.</p>
                <div class="flex items-baseline gap-1">
                  <span class="text-2xl font-black text-gray-800 dark:text-gray-100">{{ context.marea.dias_navegados }}</span>
                  <span class="text-[10px] font-bold text-gray-400">días</span>
                </div>
              </div>
            </div>
          </section>

          <!-- 2. Actions -->
          <section class="space-y-4">
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

          <!-- 3. Active Alerts -->
          <section v-if="marea.alertas?.length" class="space-y-4">
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

          <!-- 4. Quick Timeline -->
          <section class="space-y-4">
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
      <div class="p-6 border-t border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/50 space-y-3">
        <button 
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
  </Transition>
  
  <!-- Backdrop -->
  <Transition
    enter-active-class="transition-opacity duration-300 ease-linear"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition-opacity duration-200 ease-linear"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div 
      v-if="isOpen" 
      @click="$emit('close')"
      class="fixed inset-0 bg-gray-900/40 dark:bg-black/60 backdrop-blur-sm z-[50]"
    ></div>
  </Transition>
</template>

<script setup lang="ts">
import { 
  ShipIcon, 
  ChevronRightIcon, 
  LockIcon, 
  HistoryIcon, 
  WarningIcon, 
  DocsIcon,
  MapPinIcon,
  CloudUploadIcon,
  PlusIcon,
  TaskIcon,
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
  isOpen: boolean
  marea: any | null
  context: MareaContext | null
}

const props = defineProps<Props>()

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
  return `${d.toLocaleDateString()} ${d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}`
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
