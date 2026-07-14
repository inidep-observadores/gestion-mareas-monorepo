<template>
  <AdminDashboardLayout
    title="Auditoría de Procesamiento de Emails (Novedades)"
    description="Historial detallado de lectura y extracción de novedades desde correos electrónicos"
  >
    <div class="flex flex-col lg:flex-row gap-6 h-[calc(100vh-160px)] relative min-w-0 overflow-x-hidden lg:overflow-x-visible">

      <!-- Lista de Logs -->
      <div
        class="w-full lg:w-1/4 lg:max-w-xs xl:max-w-[320px] flex flex-col bg-surface rounded-3xl shadow-sm border border-border overflow-hidden transition-all duration-300 shrink-0"
        :class="{ 'hidden lg:flex': selectedLog && isMobileView }"
      >
        <div class="p-5 border-b border-border flex justify-between items-center bg-surface-muted">
          <h2 class="text-sm font-bold text-text uppercase tracking-widest flex items-center gap-2">
            <HistoryIcon class="w-4 h-4 text-primary" />
            Historial
          </h2>
          <button
            @click="fetchLogs(1)"
            class="p-2 rounded-xl hover:bg-surface-muted transition-all group"
            :class="{ 'animate-spin': isLoading }"
            title="Refrescar historial"
          >
             <RefreshIcon class="w-4 h-4 text-text-muted group-hover:text-primary" />
          </button>
        </div>

        <div class="flex-1 overflow-y-auto custom-scrollbar">
          <div v-if="logs.length === 0 && !isLoading" class="p-12 text-center">
            <div class="w-16 h-16 bg-surface-muted rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckIcon class="w-6 h-6 text-border" />
            </div>
            <p class="text-xs font-bold text-text-muted uppercase tracking-widest">Sin correos registrados</p>
          </div>

          <div
            v-for="log in logs"
            :key="log.id"
            @click="selectLog(log)"
            class="p-5 border-b border-border/50 cursor-pointer hover:bg-surface-muted transition-all relative group"
            :class="{
                'bg-primary/5 border-l-4': selectedLog?.id === log.id,
                'border-l-error': selectedLog?.id === log.id && log.estado === 'ERROR',
                'border-l-warning': selectedLog?.id === log.id && log.estado.startsWith('IGNORADO'),
                'border-l-success': selectedLog?.id === log.id && log.estado === 'PROCESADO'
            }"
          >
            <div class="flex justify-between items-start mb-3">
              <span
                class="text-[9px] font-black px-2 py-0.5 rounded-md uppercase tracking-widest shadow-xs truncate max-w-[120px]"
                :class="getLevelClass(log.estado)"
                :title="log.estado"
              >
                {{ formatEstadoCorto(log.estado) }}
              </span>
              <span class="text-[9px] font-bold text-text-muted font-mono tracking-tighter">{{ formatDateShort(log.fechaProcesamiento) }}</span>
            </div>
            <div
              class="font-semibold text-xs line-clamp-2 mb-3 leading-relaxed"
              :class="selectedLog?.id === log.id ? 'text-text' : 'text-text-muted'"
            >
              {{ log.asunto || '(Sin Asunto)' }}
            </div>
            <div class="flex items-center gap-2">
              <span class="bg-surface-muted px-1.5 py-0.5 rounded text-[9px] font-black text-text-muted uppercase truncate max-w-full" :title="log.remitente">{{ log.remitente || 'Desconocido' }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Detalle del Log -->
      <div
        class="flex-1 bg-surface rounded-3xl shadow-sm border border-border overflow-hidden flex flex-col transition-all duration-300 min-w-0 lg:h-full"
        :class="{ 'hidden lg:flex': !selectedLog, 'flex': selectedLog }"
      >
        <template v-if="selectedLog">
          <div class="flex-1 overflow-y-auto custom-scrollbar flex flex-col h-full min-w-0">
            <!-- Header del Detalle -->
            <div class="p-6 md:p-8 border-b border-border bg-linear-to-b from-surface-muted to-transparent shrink-0 min-w-0">
            <div class="flex items-center gap-4 mb-6 lg:hidden">
                <button
                    @click="selectedLog = null"
                    class="p-2 rounded-xl bg-surface-muted text-text-muted hover:text-primary transition-all"
                >
                    <ArrowLeftIcon class="w-5 h-5" />
                </button>
                <h2 class="text-sm font-bold uppercase tracking-widest text-text">Volver al Historial</h2>
            </div>

            <div class="flex flex-col xl:flex-row justify-between items-start gap-6 mb-8">
              <div class="flex-1 min-w-0 w-full">
                <div class="flex flex-wrap items-center gap-3 mb-4">
                    <span class="text-[10px] font-black py-1.5 px-3 rounded-lg shadow-xs uppercase tracking-widest" :class="getLevelClass(selectedLog.estado)">
                        {{ selectedLog.estado }}
                    </span>
                    <span class="text-[10px] font-mono text-text-muted bg-surface-muted px-2.5 py-1.5 rounded-lg border border-border truncate max-w-full" v-if="selectedLog.messageId">
                        Message-ID: {{ selectedLog.messageId }}
                    </span>
                </div>
                <!-- Sección con Scroll para el Mensaje -->
                <div class="bg-surface-muted p-5 rounded-2xl border border-border shadow-sm max-h-40 overflow-y-auto custom-scrollbar group min-w-0">
                    <h3 class="text-sm md:text-base font-semibold text-text leading-relaxed break-all">
                        {{ selectedLog.asunto || '(Sin Asunto)' }}
                    </h3>
                </div>
              </div>

              <div class="bg-surface p-5 rounded-2xl border border-border shadow-sm flex flex-col items-center justify-center w-full xl:w-56 shrink-0">
                <div class="flex items-center gap-2 text-[10px] uppercase font-black text-text-muted mb-2 tracking-widest">
                    <CalenderIcon class="w-3.5 h-3.5" />
                    Registro Temporal
                </div>
                <div class="text-sm font-bold text-text">{{ formatDateFull(selectedLog.fechaProcesamiento) }}</div>
                <div class="text-[10px] text-text-muted mt-1 font-mono tracking-tighter">Procesado</div>
              </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 2xl:grid-cols-3 gap-4 min-w-0">
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <UserCircleIcon class="w-3.5 h-3.5 text-primary" /> Remitente
                </div>
                <div class="text-xs font-bold text-text truncate" :title="selectedLog.remitente">{{ selectedLog.remitente || 'Desconocido' }}</div>
              </div>
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <CalenderIcon class="w-3.5 h-3.5 text-primary" /> Fecha Recepción
                </div>
                <div class="text-xs font-bold text-text truncate">
                  {{ selectedLog.fechaRecepcion ? formatDateFull(selectedLog.fechaRecepcion) : 'N/D' }}
                </div>
              </div>
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <PlugInIcon class="w-3.5 h-3.5 text-primary" /> Novedad Creada
                </div>
                <div class="text-xs font-bold text-text truncate">
                    <template v-if="selectedLog.novedadId">
                        ID: {{ selectedLog.novedadId.substring(0,8) }}...
                    </template>
                    <template v-else>
                        Ninguna
                    </template>
                </div>
              </div>
            </div>
          </div>

            <!-- Contenido Detallado -->
            <div class="p-6 md:p-8 space-y-10 bg-surface-muted/20 min-w-0">
            <!-- Detalle Error -->
            <section v-if="selectedLog.errorDetalle" class="animate-in fade-in slide-in-from-bottom-4 duration-500">
               <div class="flex justify-between items-center mb-5">
                  <h4 class="text-[10px] font-black uppercase tracking-widest text-error flex items-center gap-2">
                    <ChatIcon class="w-4 h-4 text-error" /> Motivo del Fallo
                  </h4>
               </div>
               <div class="p-6 bg-error/5 rounded-3xl border border-error/20 text-sm italic text-error shadow-inner leading-relaxed">
                {{ selectedLog.errorDetalle }}
              </div>
            </section>

            <!-- Contexto de Ejecución (JSON AI) -->
            <section v-if="selectedLog.extraccionAi" class="animate-in fade-in slide-in-from-bottom-4 duration-700">
              <div class="flex justify-between items-center mb-5">
                  <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
                    <BoxIcon class="w-4 h-4 text-primary" /> Resultado Extracción AI (Gemini)
                  </h4>
                  <button
                    @click="copyToClipboard(JSON.stringify(selectedLog.extraccionAi, null, 2))"
                    class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-muted text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-primary hover:text-primary-fg transition-all shadow-xs"
                  >
                    <DocsIcon class="w-3.5 h-3.5" /> Copiar JSON
                  </button>
              </div>
              <div class="bg-surface-muted rounded-3xl border border-border shadow-sm overflow-hidden">
                <div class="flex items-center gap-1.5 px-6 py-3 bg-surface/50 border-b border-border">
                    <span class="text-[10px] text-text-muted font-bold uppercase tracking-widest font-mono">datos_extraccion.json</span>
                </div>
                <div class="p-6 md:p-8 overflow-x-auto custom-scrollbar">
                    <code class="text-[11px] font-mono leading-relaxed text-text whitespace-pre">{{ JSON.stringify(selectedLog.extraccionAi, null, 2) }}</code>
                </div>
              </div>
            </section>
          </div>
        </div>
        </template>

        <!-- Empty State -->
        <div v-else class="flex-1 flex flex-col items-center justify-center text-text-muted p-12 bg-surface/10">
          <div class="w-48 h-48 bg-surface-muted rounded-full flex items-center justify-center mb-10 shadow-inner group">
            <BoxCubeIcon class="w-20 h-20 text-border group-hover:scale-110 transition-transform duration-500" />
          </div>
          <h2 class="text-xl font-black text-text-muted mb-3 uppercase tracking-tighter">Panel de Auditoría de Correos</h2>
          <p class="text-xs font-bold text-text-muted uppercase tracking-widest text-center max-w-xs leading-loose">
            Seleccione un correo del historial para inspeccionar la extracción de la IA
          </p>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import { useNovedadesEmailLogs } from '../composables/useNovedadesEmailLogs';
import { toast } from 'vue-sonner';
import {
    HistoryIcon,
    RefreshIcon,
    CheckIcon,
    ArrowLeftIcon,
    CalenderIcon,
    PlugInIcon,
    UserCircleIcon,
    DocsIcon,
    BoxIcon,
    ChatIcon,
    BoxCubeIcon
} from '@/icons';

const { logs, selectedLog, isLoading, fetchLogs, selectLog } = useNovedadesEmailLogs();

// Responsividad Check
const isMobileView = ref(false);
const checkMobile = () => {
    isMobileView.value = window.innerWidth < 1024;
};

onMounted(() => {
    checkMobile();
    window.addEventListener('resize', checkMobile);
});

onUnmounted(() => {
    window.removeEventListener('resize', checkMobile);
});

const getLevelClass = (estado: string) => {
  switch (estado) {
    case 'PROCESADO': return 'bg-success/10 text-success border border-success/50';
    case 'ERROR': return 'bg-error/10 text-error border border-error/50';
    case 'IGNORADO_SIN_OBSERVADOR':
    case 'IGNORADO_SIN_TIPO_NOVEDAD': 
        return 'bg-warning/10 text-warning border border-warning/50';
    default: return 'bg-primary/10 text-primary border border-primary/50';
  }
}

const formatEstadoCorto = (estado: string) => {
    if (estado === 'IGNORADO_SIN_OBSERVADOR') return 'IGN: OBS';
    if (estado === 'IGNORADO_SIN_TIPO_NOVEDAD') return 'IGN: TIPO';
    return estado;
}

const formatDateShort = (dateStr: string) => {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  return date.toLocaleTimeString('es-AR', { hour: '2-digit', minute: '2-digit' }) +
         ' · ' +
         date.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit' });
}

const formatDateFull = (dateStr: string) => {
  if (!dateStr) return '';
  return new Date(dateStr).toLocaleString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  });
}

const copyToClipboard = (text: string) => {
  navigator.clipboard.writeText(text);
  toast.success('Copiado al portapapeles con éxito');
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(156, 163, 175, 0.2);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Animations */
.animate-in {
    animation-fill-mode: both;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.flex-1 > template {
  animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}
</style>
