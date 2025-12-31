<template>
  <AdminDashboardLayout 
    title="Auditoría de Errores" 
    description="Seguimiento detallado de fallos del sistema y excepciones del backend"
  >
    <div class="flex flex-col md:flex-row gap-6 h-[calc(100vh-220px)]">
      
      <!-- Lista de Logs -->
      <div 
        class="w-full md:w-[380px] flex flex-col bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden"
      >
        <div class="p-4 border-b border-gray-200 dark:border-gray-800 flex justify-between items-center bg-gray-50/50 dark:bg-gray-800/50">
          <h2 class="text-lg font-bold text-gray-800 dark:text-white flex items-center gap-2">
            Historial de Errores
          </h2>
          <button 
            @click="fetchErrorLogs" 
            class="p-2 rounded-full hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
            :class="{ 'animate-spin': isLoading }"
          >
             <i class="pi pi-refresh text-gray-500"></i>
          </button>
        </div>

        <div class="flex-1 overflow-y-auto custom-scrollbar">
          <div v-if="errorLogs.length === 0 && !isLoading" class="p-8 text-center text-gray-400">
            No se han registrado errores
          </div>
          
          <div 
            v-for="log in errorLogs" 
            :key="log.id"
            @click="selectLog(log)"
            class="p-4 border-b border-gray-100 dark:border-gray-800 cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-all"
            :class="{ 'bg-blue-50/50 dark:bg-blue-900/10 border-l-4 border-l-blue-600': selectedLog?.id === log.id }"
          >
            <div class="flex justify-between items-start mb-2">
              <span 
                class="text-[10px] font-bold px-2 py-0.5 rounded-full uppercase tracking-wider shadow-sm" 
                :class="getLevelClass(log.level)"
              >
                {{ log.level }}
              </span>
              <span class="text-[10px] font-medium text-gray-400 font-mono">{{ formatDateShort(log.timestamp) }}</span>
            </div>
            <div 
              class="font-bold text-xs line-clamp-2 mb-2 leading-relaxed" 
              :class="selectedLog?.id === log.id ? 'text-blue-600 dark:text-blue-400' : 'text-gray-700 dark:text-gray-300'"
            >
              {{ log.message }}
            </div>
            <div class="text-[10px] text-gray-400 flex items-center gap-2 truncate">
              <span class="bg-gray-100 dark:bg-gray-800 px-1.5 py-0.5 rounded font-bold text-gray-500">{{ log.method }}</span>
              <span class="truncate font-mono">{{ log.path }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Detalle del Log -->
      <div 
        class="flex-1 bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden flex flex-col"
      >
        <template v-if="selectedLog">
          <!-- Header del Detalle -->
          <div class="p-6 border-b border-gray-200 dark:border-gray-800 bg-gray-50/30 dark:bg-gray-800/20">
            <div class="flex flex-col xl:flex-row justify-between items-start gap-4 mb-6">
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-3 mb-3">
                    <span class="badge font-bold py-3 px-4 shadow-sm" :class="getLevelClass(selectedLog.level)">{{ selectedLog.level }}</span>
                    <span class="text-xs font-mono text-gray-400 bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded">ID: {{ selectedLog.id }}</span>
                </div>
                <h3 class="text-xl md:text-2xl font-black text-gray-900 dark:text-white leading-tight tracking-tight break-words">
                    {{ selectedLog.message }}
                </h3>
              </div>
              <div class="bg-white dark:bg-gray-800 p-3 rounded-2xl border border-gray-200 dark:border-gray-700 shadow-sm flex flex-col items-center justify-center min-w-[140px]">
                <div class="text-[10px] uppercase font-black text-gray-400 mb-1 tracking-widest">Fecha y Hora</div>
                <div class="text-sm font-bold text-gray-700 dark:text-gray-200">{{ formatDateFull(selectedLog.timestamp) }}</div>
              </div>
            </div>

            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
              <div class="bg-white dark:bg-gray-800/50 p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                <div class="text-[10px] uppercase tracking-tighter text-gray-400 font-black mb-2 flex items-center gap-1.5">
                    <i class="pi pi-server text-[10px]"></i> Origen
                </div>
                <div class="text-sm font-bold text-gray-700 dark:text-gray-300">{{ selectedLog.source }}</div>
              </div>
              <div class="bg-white dark:bg-gray-800/50 p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                <div class="text-[10px] uppercase tracking-tighter text-gray-400 font-black mb-2 flex items-center gap-1.5">
                    <i class="pi pi-directions text-[10px]"></i> Método / Ruta
                </div>
                <div class="text-xs font-bold flex items-center gap-2 truncate text-gray-700 dark:text-gray-300">
                  <span class="text-blue-600 dark:text-blue-400 font-black">{{ selectedLog.method }}</span>
                  <span class="truncate font-mono">{{ selectedLog.path }}</span>
                </div>
              </div>
              <div class="bg-white dark:bg-gray-800/50 p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                <div class="text-[10px] uppercase tracking-tighter text-gray-400 font-black mb-2 flex items-center gap-1.5">
                    <i class="pi pi-user text-[10px]"></i> Usuario
                </div>
                <div class="text-sm font-bold text-gray-700 dark:text-gray-300 truncate">{{ selectedLog.userEmail || 'Anónimo' }}</div>
              </div>
              <div class="bg-white dark:bg-gray-800/50 p-4 rounded-xl border border-gray-100 dark:border-gray-800">
                <div class="text-[10px] uppercase tracking-tighter text-gray-400 font-black mb-2 flex items-center gap-1.5">
                    <i class="pi pi-globe text-[10px]"></i> Dirección IP
                </div>
                <div class="text-sm font-bold text-gray-700 dark:text-gray-300">{{ selectedLog.ip || 'Interno' }}</div>
              </div>
            </div>
          </div>

          <!-- Tabs de Contenido -->
          <div class="flex-1 overflow-y-auto p-6 space-y-8 bg-gray-50/20 dark:bg-gray-950/20 custom-scrollbar">
            <section v-if="selectedLog.stack">
               <div class="flex justify-between items-center mb-4">
                  <h4 class="text-xs font-black uppercase tracking-widest text-gray-400 flex items-center gap-2">
                    <i class="pi pi-align-left text-blue-500"></i> Stack Trace
                  </h4>
                  <button 
                    @click="copyToClipboard(selectedLog.stack || '')" 
                    class="btn btn-ghost btn-xs text-[10px] gap-2 hover:bg-blue-50 dark:hover:bg-blue-900/20"
                  >
                    <i class="pi pi-copy"></i> COPIAR STACK
                  </button>
               </div>
               <div class="relative group">
                <pre 
                    class="bg-gray-900 text-gray-100 p-6 rounded-2xl text-[11px] overflow-x-auto whitespace-pre-wrap leading-relaxed max-h-[400px] border border-gray-800 shadow-2xl font-mono custom-scrollbar"
                >{{ selectedLog.stack }}</pre>
              </div>
            </section>

            <section v-if="selectedLog.detail">
              <h4 class="text-xs font-black uppercase tracking-widest text-gray-400 mb-4 flex items-center gap-2">
                <i class="pi pi-database text-blue-500"></i> Detalles Técnicos (Auditoría JSON)
              </h4>
              <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-200 dark:border-gray-700 shadow-sm overflow-hidden min-w-full">
                <div class="flex items-center gap-1.5 px-4 py-2 bg-gray-50 dark:bg-gray-800 border-b border-gray-200 dark:border-gray-700">
                    <span class="w-2.5 h-2.5 rounded-full bg-red-400"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-yellow-400"></span>
                    <span class="w-2.5 h-2.5 rounded-full bg-green-400"></span>
                    <span class="text-[10px] ml-2 text-gray-400 font-bold uppercase tracking-widest">payload_inspect.json</span>
                </div>
                <pre class="p-6 overflow-x-auto"><code class="text-xs font-mono leading-relaxed text-gray-700 dark:text-gray-300">{{ JSON.stringify(selectedLog.detail, null, 2) }}</code></pre>
              </div>
            </section>

            <section v-if="selectedLog.context">
              <h4 class="text-xs font-black uppercase tracking-widest text-gray-400 mb-4">Contexto de Aplicación</h4>
              <div class="p-5 bg-blue-50/30 dark:bg-blue-900/10 rounded-2xl border border-blue-100 dark:border-blue-900/30 text-sm italic text-gray-600 dark:text-gray-400 shadow-inner">
                {{ selectedLog.context }}
              </div>
            </section>
          </div>
        </template>
        
        <div v-else class="flex-1 flex flex-col items-center justify-center text-gray-300 p-12 bg-gray-50/10 dark:bg-gray-900/10">
          <div class="w-40 h-40 bg-gray-100 dark:bg-gray-800 rounded-full flex items-center justify-center mb-8 shadow-inner animate-pulse">
            <i class="pi pi-shield text-6xl opacity-20"></i>
          </div>
          <h2 class="text-2xl font-black text-gray-400 mb-2 uppercase tracking-tighter">Panel de Auditoría</h2>
          <p class="text-sm font-medium text-gray-400">Seleccione un registro del historial para iniciar la inspección técnica</p>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import { useErrorLogs } from '../composables/useErrorLogs';
import { toast } from 'vue-sonner';

const { errorLogs, selectedLog, isLoading, fetchErrorLogs, selectLog } = useErrorLogs();

const getLevelClass = (level: string) => {
  switch (level) {
    case 'CRITICAL': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400 border border-red-200 dark:border-red-800';
    case 'WARN': return 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400 border border-amber-200 dark:border-amber-800';
    default: return 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400 border border-blue-200 dark:border-blue-800';
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
  toast.success('Contenido copiado al portapapeles');
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 5px;
  height: 5px;
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

/* Glass effect animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.flex-1 > template {
  animation: fadeIn 0.3s ease-out forwards;
}
</style>
