<template>
  <AdminDashboardLayout
    title="Auditoría de Errores"
    description="Seguimiento detallado de fallos del sistema y excepciones del backend"
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
            @click="fetchErrorLogs"
            class="p-2 rounded-xl hover:bg-surface-muted transition-all group"
            :class="{ 'animate-spin': isLoading }"
            title="Refrescar historial"
          >
             <RefreshIcon class="w-4 h-4 text-text-muted group-hover:text-primary" />
          </button>
        </div>

        <div class="flex-1 overflow-y-auto custom-scrollbar">
          <div v-if="errorLogs.length === 0 && !isLoading" class="p-12 text-center">
            <div class="w-16 h-16 bg-surface-muted rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckIcon class="w-6 h-6 text-border" />
            </div>
            <p class="text-xs font-bold text-text-muted uppercase tracking-widest">Sin errores registrados</p>
          </div>

          <div
            v-for="log in errorLogs"
            :key="log.id"
            @click="selectLog(log)"
            class="p-5 border-b border-border/50 cursor-pointer hover:bg-surface-muted transition-all relative group"
            :class="{
                'bg-primary/5 border-l-4': selectedLog?.id === log.id,
                'border-l-error': selectedLog?.id === log.id && log.level === 'CRITICAL',
                'border-l-warning': selectedLog?.id === log.id && log.level === 'WARN',
                'border-l-primary': selectedLog?.id === log.id && log.level !== 'CRITICAL' && log.level !== 'WARN'
            }"
          >
            <div class="flex justify-between items-start mb-3">
              <span
                class="text-[9px] font-black px-2 py-0.5 rounded-md uppercase tracking-widest shadow-xs"
                :class="getLevelClass(log.level)"
              >
                {{ log.level }}
              </span>
              <span class="text-[9px] font-bold text-gray-400 font-mono tracking-tighter">{{ formatDateShort(log.timestamp) }}</span>
            </div>
            <div
              class="font-semibold text-xs line-clamp-2 mb-3 leading-relaxed"
              :class="selectedLog?.id === log.id ? 'text-text' : 'text-text-muted'"
            >
              {{ log.message }}
            </div>
            <div class="flex items-center gap-2">
              <span class="bg-surface-muted px-1.5 py-0.5 rounded text-[9px] font-black text-text-muted uppercase">{{ log.method }}</span>
              <span class="text-[10px] text-text-muted truncate font-mono tracking-tighter">{{ log.path }}</span>
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
            <!-- Header del Detalle (Ahora parte del scroll) -->
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
                    <span class="text-[10px] font-black py-1.5 px-3 rounded-lg shadow-xs uppercase tracking-widest" :class="getLevelClass(selectedLog.level)">
                        {{ selectedLog.level }}
                    </span>
                    <span class="text-[10px] font-mono text-text-muted bg-surface-muted px-2.5 py-1.5 rounded-lg border border-border truncate max-w-full">
                        UUID: {{ selectedLog.id }}
                    </span>
                </div>
                <!-- Sección con Scroll para el Mensaje -->
                <div class="bg-surface-muted p-5 rounded-2xl border border-border shadow-sm max-h-40 overflow-y-auto custom-scrollbar group min-w-0">
                    <h3 class="text-sm md:text-base font-semibold text-text leading-relaxed break-all">
                        {{ selectedLog.message }}
                    </h3>
                </div>
              </div>

              <div class="bg-surface p-5 rounded-2xl border border-border shadow-sm flex flex-col items-center justify-center w-full xl:w-56 shrink-0">
                <div class="flex items-center gap-2 text-[10px] uppercase font-black text-text-muted mb-2 tracking-widest">
                    <CalenderIcon class="w-3.5 h-3.5" />
                    Registro Temporal
                </div>
                <div class="text-sm font-bold text-text">{{ formatDateFull(selectedLog.timestamp) }}</div>
                <div class="text-[10px] text-text-muted mt-1 font-mono tracking-tighter">GMT -03:00</div>
              </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 2xl:grid-cols-4 gap-4 min-w-0">
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <BoxCubeIcon class="w-3.5 h-3.5 text-primary" /> Origen
                </div>
                <div class="text-xs font-bold text-text truncate">{{ selectedLog.source }}</div>
              </div>
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <PlugInIcon class="w-3.5 h-3.5 text-primary" /> Endpoint
                </div>
                <div class="text-[10px] font-bold flex items-center gap-2 text-text min-w-0">
                  <span class="text-primary font-black px-1.5 py-0.5 bg-primary/10 rounded shrink-0">{{ selectedLog.method }}</span>
                  <span class="truncate font-mono tracking-tighter">{{ selectedLog.path }}</span>
                </div>
              </div>
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <UserCircleIcon class="w-3.5 h-3.5 text-primary" /> Identidad
                </div>
                <div class="text-xs font-bold text-text truncate">{{ selectedLog.userEmail || 'Anónimo / Sistema' }}</div>
              </div>
              <div class="bg-surface-muted p-4 rounded-2xl border border-border/50 hover:border-primary transition-colors min-w-0">
                <div class="text-[9px] uppercase tracking-widest text-text-muted font-black mb-2 flex items-center gap-2">
                    <MapPinIcon class="w-3.5 h-3.5 text-primary" /> Infraestructura
                </div>
                <div class="text-xs font-bold text-text truncate">{{ selectedLog.ip || 'Local / Interno' }}</div>
              </div>
            </div>
          </div>

            <!-- Contenido Detallado -->
            <div class="p-6 md:p-8 space-y-10 bg-gray-50/20 dark:bg-gray-950/20 min-w-0">
            <!-- Stack Trace -->
            <section v-if="selectedLog.stack" class="animate-in fade-in slide-in-from-bottom-4 duration-500">
               <div class="flex justify-between items-center mb-5">
                  <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
                    <ListIcon class="w-4 h-4 text-primary" /> Trazabilidad del Error
                  </h4>
                  <button
                    @click="copyToClipboard(selectedLog.stack || '')"
                    class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-muted text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-primary hover:text-primary-fg transition-all shadow-xs"
                  >
                    <DocsIcon class="w-3.5 h-3.5" /> Copiar Traza
                  </button>
               </div>
               <div class="relative group shadow-sm rounded-3xl overflow-hidden border border-border">
                <pre
                    class="bg-surface-muted text-text p-6 md:p-8 text-[11px] overflow-x-auto whitespace-pre-wrap leading-relaxed max-h-[500px] font-mono custom-scrollbar selection:bg-primary/30"
                >{{ selectedLog.stack }}</pre>
              </div>
            </section>

            <!-- Contexto de Ejecución (JSON) -->
            <section v-if="selectedLog.detail" class="animate-in fade-in slide-in-from-bottom-4 duration-700">
              <div class="flex justify-between items-center mb-5">
                  <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
                    <BoxIcon class="w-4 h-4 text-primary" /> Contexto de Ejecución
                  </h4>
                  <button
                    @click="copyToClipboard(JSON.stringify(selectedLog.detail, null, 2))"
                    class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-surface-muted text-[10px] font-black uppercase tracking-widest text-text-muted hover:bg-primary hover:text-primary-fg transition-all shadow-xs"
                  >
                    <DocsIcon class="w-3.5 h-3.5" /> Copiar JSON
                  </button>
              </div>
              <div class="bg-surface-muted rounded-3xl border border-border shadow-sm overflow-hidden">
                <div class="flex items-center gap-1.5 px-6 py-3 bg-surface/50 border-b border-border">
                    <span class="text-[10px] text-text-muted font-bold uppercase tracking-widest font-mono">datos_ejecucion.json</span>
                </div>
                <div class="p-6 md:p-8 overflow-x-auto custom-scrollbar">
                    <code class="text-[11px] font-mono leading-relaxed text-text whitespace-pre">{{ JSON.stringify(selectedLog.detail, null, 2) }}</code>
                </div>
              </div>
            </section>

            <!-- Contexto de Aplicación -->
            <section v-if="selectedLog.context" class="animate-in fade-in slide-in-from-bottom-4 duration-1000">
              <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-5 flex items-center gap-2">
                <ChatIcon class="w-4 h-4 text-primary" /> Observaciones del Sistema
              </h4>
              <div class="p-6 bg-primary/5 rounded-3xl border border-primary/20 text-sm italic text-text-muted shadow-inner leading-relaxed">
                {{ selectedLog.context }}
              </div>
            </section>
          </div>
        </div>
        </template>

        <!-- Empty State -->
        <div v-else class="flex-1 flex flex-col items-center justify-center text-text-muted p-12 bg-surface/10">
          <div class="w-48 h-48 bg-surface-muted rounded-full flex items-center justify-center mb-10 shadow-inner group">
            <ShieldIcon class="w-20 h-20 text-border group-hover:scale-110 transition-transform duration-500" />
          </div>
          <h2 class="text-xl font-black text-text-muted mb-3 uppercase tracking-tighter">Panel de Auditoría</h2>
          <p class="text-xs font-bold text-text-muted uppercase tracking-widest text-center max-w-xs leading-loose">
            Seleccione un evento del historial para iniciar la inspección técnica detallada
          </p>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import { useErrorLogs } from '../composables/useErrorLogs';
import { toast } from 'vue-sonner';
import {
    HistoryIcon,
    RefreshIcon,
    CheckIcon,
    ArrowLeftIcon,
    CalenderIcon,
    BoxCubeIcon,
    PlugInIcon,
    UserCircleIcon,
    MapPinIcon,
    ListIcon,
    DocsIcon,
    BoxIcon,
    ChatIcon,
    ShieldIcon
} from '@/icons';

const { errorLogs, selectedLog, isLoading, fetchErrorLogs, selectLog } = useErrorLogs();

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

const getLevelClass = (level: string) => {
  switch (level) {
    case 'CRITICAL': return 'bg-error/10 text-error border border-error/50';
    case 'WARN': return 'bg-warning/10 text-warning border border-warning/50';
    default: return 'bg-primary/10 text-primary border border-primary/50';
  }
}

const formatDateShort = (dateStr: string) => {
  const date = new Date(dateStr);
  return date.toLocaleTimeString('es-AR', { hour: '2-digit', minute: '2-digit' }) +
         ' · ' +
         date.toLocaleDateString('es-AR', { day: '2-digit', month: '2-digit' });
}

const formatDateFull = (dateStr: string) => {
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
