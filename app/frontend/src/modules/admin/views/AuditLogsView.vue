<template>
  <AdminDashboardLayout
    title="Centro de Control de Auditoría"
    description="Seguimiento integral de actividad, integridad de datos y eventos de negocio"
  >
    <div class="flex flex-col lg:flex-row gap-6 h-[calc(100vh-160px)] relative min-w-0 overflow-x-hidden lg:overflow-x-visible">
      
      <!-- Lista de Logs y Filtros -->
      <div
        class="w-full lg:w-1/4 lg:max-w-xs xl:max-w-[360px] flex flex-col bg-surface rounded-3xl shadow-sm border border-border overflow-hidden transition-all duration-300 shrink-0"
        :class="{ 'hidden lg:flex': selectedLog && isMobileView }"
      >
        <!-- Selectores (Chips) -->
        <div class="p-4 border-b border-border bg-surface-muted/30">
          <div class="flex justify-between items-start mb-4">
            <div class="flex flex-wrap gap-2">
              <button
                v-for="type in auditTypes"
                :key="type.id"
                @click="setAuditType(type.id)"
                class="px-4 py-2 rounded-full text-[10px] font-black uppercase tracking-widest transition-all border-2"
                :class="activeType === type.id 
                  ? 'bg-primary text-primary-fg border-primary shadow-lg shadow-primary/20 scale-105' 
                  : 'bg-surface border-border text-text-muted hover:border-primary/30'"
              >
                {{ type.label }}
              </button>
            </div>
            <button
              @click="fetchLogs"
              class="p-2 rounded-xl hover:bg-surface-muted transition-all group shrink-0 ml-2"
              :class="{ 'animate-spin': isLoading }"
              title="Refrescar logs"
            >
              <RefreshIcon class="w-4 h-4 text-text-muted group-hover:text-primary" />
            </button>
          </div>

            <SearchInput
              :model-value="filters.busqueda || ''"
              @update:model-value="filters.busqueda = $event"
              placeholder="Buscar por usuario, ruta..."
            />
        </div>

        <!-- Lista -->
        <div 
          ref="listContainer"
          class="flex-1 overflow-y-auto custom-scrollbar bg-linear-to-b from-surface to-surface-muted/20"
        >
          <div v-if="isLoading && logs.length === 0" class="p-12 text-center">
            <RefreshIcon class="w-8 h-8 text-primary animate-spin mx-auto mb-4" />
            <p class="text-[10px] font-black text-text-muted uppercase tracking-widest">Cargando bitácora...</p>
          </div>

          <div v-else-if="logs.length === 0" class="p-12 text-center">
            <div class="w-16 h-16 bg-surface-muted rounded-full flex items-center justify-center mx-auto mb-4 border border-border">
              <ShieldIcon class="w-6 h-6 text-border" />
            </div>
            <p class="text-[10px] font-black text-text-muted uppercase tracking-widest">Sin registros encontrados</p>
          </div>

          <template
            v-for="(log, index) in logs"
            :key="log.id"
          >
            <!-- Separador de Fecha Discreto -->
            <div 
              v-if="shouldShowDateHeader(log, index)"
              class="px-4 py-2 bg-surface-muted/50 border-y border-border/30"
            >
              <span class="text-[9px] font-black text-text-muted uppercase tracking-[0.2em]">
                {{ formatDateGroup(log.timestamp) }}
              </span>
            </div>

            <div
              @click="selectLog(log)"
              class="p-4 border-b border-border/50 cursor-pointer hover:bg-surface transition-all relative group"
              :class="{ 'bg-primary/5 border-l-4 border-l-primary shadow-inner': selectedLog?.id === log.id }"
            >
              <div class="flex justify-between items-center mb-2">
                <span 
                  class="text-[9px] font-black px-2 py-0.5 rounded uppercase tracking-tighter"
                  :class="getStatusClass(log)"
                >
                  {{ getLogTag(log) }}
                </span>
                <span class="text-[9px] font-bold text-text-muted font-mono">{{ formatDateShort(log.timestamp) }}</span>
              </div>
              
              <h4 class="text-[11px] font-bold text-text line-clamp-2 leading-snug mb-2 group-hover:text-primary transition-colors">
                {{ getLogTitle(log) }}
              </h4>

              <div class="flex items-center gap-2">
                <div v-if="log.usuario || log.usuarioEmail || log.usuarioId" class="flex items-center gap-1.5 truncate">
                  <UserCircleIcon class="w-3 h-3 text-text-muted" />
                  <span class="text-[10px] text-text-muted font-bold truncate">
                    {{ log.usuario?.fullName || log.usuarioEmail || log.usuarioId }}
                  </span>
                </div>
                <div v-else class="flex items-center gap-1.5">
                  <BoxCubeIcon class="w-3 h-3 text-text-muted" />
                  <span class="text-[10px] text-text-muted font-bold italic">Sistema</span>
                </div>
              </div>
            </div>
          </template>
        </div>

        <!-- Paginación Simple -->
        <div class="p-4 border-t border-border bg-surface-muted/50 flex justify-between items-center">
          <button 
             @click="filters.page!--" 
             :disabled="filters.page! <= 1"
             class="p-2 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all disabled:opacity-30"
          >
            <ArrowLeftIcon class="w-4 h-4" />
          </button>
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Pág {{ filters.page }}</span>
          <button 
             @click="filters.page!++" 
             :disabled="logs.length < (filters.limit || 20)"
             class="p-2 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all disabled:opacity-30"
          >
            <ArrowRightIcon class="w-4 h-4" />
          </button>
        </div>
      </div>

      <!-- Detalle -->
      <div
        class="flex-1 bg-surface rounded-3xl shadow-sm border border-border overflow-hidden flex flex-col transition-all duration-300 min-w-0"
        :class="{ 'hidden lg:flex': !selectedLog, 'flex': selectedLog }"
      >
        <template v-if="selectedLog">
          <div class="flex-1 overflow-y-auto custom-scrollbar flex flex-col h-full bg-linear-to-b from-surface-muted/30 to-surface">
            <!-- Header Detalle -->
            <div class="p-8 border-b border-border bg-surface/50">
               <div class="flex items-center gap-4 mb-6 lg:hidden">
                <button
                    @click="selectedLog = null"
                    class="p-2 rounded-xl bg-surface-muted text-text-muted"
                >
                    <ArrowLeftIcon class="w-5 h-5" />
                </button>
                <h2 class="text-sm font-bold uppercase tracking-widest text-text">Bitácora</h2>
              </div>

              <div class="flex flex-col xl:flex-row justify-between items-start gap-8 mb-8">
                <div class="min-w-0 flex-1">
                   <div class="flex flex-wrap items-center gap-3 mb-4">
                      <span class="px-3 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-widest bg-primary/10 text-primary border border-primary/20">
                        {{ getLogTag(selectedLog) }}
                      </span>
                      <span class="text-[10px] font-mono text-text-muted bg-surface-muted px-3 py-1.5 rounded-lg border border-border">
                        {{ selectedLog.id }}
                      </span>
                   </div>
                   <h2 class="text-2xl font-black text-text leading-tight tracking-tighter">
                      {{ getLogTitle(selectedLog) }}
                   </h2>
                </div>
                <div class="bg-surface p-6 rounded-2xl border-2 border-primary/10 shadow-sm flex flex-col items-center justify-center shrink-0 w-full xl:w-64">
                   <div class="text-[10px] font-black text-text-muted uppercase tracking-widest mb-2">Momento del Registro</div>
                   <div class="text-lg font-black text-text">{{ formatDateFull(selectedLog.timestamp) }}</div>
                   <div class="text-[10px] text-primary font-bold mt-1 uppercase">Sincronizado vía RTC</div>
                </div>
              </div>

              <!-- Grid de Atributos -->
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-surface-muted p-4 rounded-2xl border border-border/50">
                   <div class="text-[9px] font-black uppercase text-text-muted mb-2 tracking-widest flex items-center gap-2">
                     <UserCircleIcon class="w-3.5 h-3.5 text-primary" /> Actor
                   </div>
                   <div class="text-xs font-bold text-text truncate">
                      {{ selectedLog.usuario?.fullName || selectedLog.usuarioEmail || selectedLog.usuarioId || 'Proceso de Sistema' }}
                   </div>
                   <div class="text-[10px] text-text-muted truncate mt-1">{{ selectedLog.usuario?.email || 'INTERNAL_TASK' }}</div>
                </div>
                <div v-if="selectedLog.ip" class="bg-surface-muted p-4 rounded-2xl border border-border/50">
                   <div class="text-[9px] font-black uppercase text-text-muted mb-2 tracking-widest flex items-center gap-2">
                     <MapPinIcon class="w-3.5 h-3.5 text-primary" /> Conectividad
                   </div>
                   <div class="text-xs font-bold text-text">{{ selectedLog.ip }}</div>
                   <div class="text-[10px] text-text-muted truncate mt-1">Terminal Autorizada</div>
                </div>
                <div class="bg-surface-muted p-4 rounded-2xl border border-border/50">
                   <div class="text-[9px] font-black uppercase text-text-muted mb-2 tracking-widest flex items-center gap-2">
                     <BoxCubeIcon class="w-3.5 h-3.5 text-primary" /> Subsistema
                   </div>
                   <div class="text-xs font-bold text-text truncate uppercase">
                      {{ activeType === 'api' ? 'API Engine' : activeType === 'entidades' ? 'Data Integrity' : activeType === 'eventos' ? 'Business Logic' : 'User Journey' }}
                   </div>
                </div>
              </div>
            </div>

            <!-- Inspectores de Data -->
            <div class="p-8 space-y-12">
               <!-- Vista para API -->
               <template v-if="activeType === 'api'">
                  <DataInspector title="Request Context" :data="{ 
                    method: selectedLog.metodo, 
                    path: selectedLog.ruta,
                    query: selectedLog.queryParams,
                    body: selectedLog.requestBody
                  }" />
                  <DataInspector title="Response Analytics" :data="{
                    status: selectedLog.statusCode,
                    duration: `${selectedLog.duracionMs}ms`,
                    body: selectedLog.responseBody,
                    error: selectedLog.mensajeError
                  }" />
               </template>

               <!-- Vista para Entidades -->
               <template v-else-if="activeType === 'entidades'">
                  <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
                    <DataInspector title="Valores Anteriores" :data="selectedLog.valoresAnteriores" variant="warning" />
                    <DataInspector title="Nuevos Valores" :data="selectedLog.valoresNuevos" variant="success" />
                  </div>
                  <DataInspector title="Metadatos del Trigger" :data="selectedLog.contexto" />
               </template>

               <!-- Vista para Eventos -->
               <template v-else-if="activeType === 'eventos'">
                  <DataInspector title="Entidad Principal" :data="selectedLog.entidadPrincipal" />
                  <div class="grid grid-cols-1 xl:grid-cols-2 gap-8">
                    <DataInspector title="Impacto Relacionado" :data="selectedLog.entidadesRelacionadas" />
                    <DataInspector title="Carga Útil (Payload)" :data="selectedLog.metadata" />
                  </div>
               </template>

                <!-- Vista para Navegación -->
                <template v-else-if="activeType === 'navegacion'">
                   <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                     <DataInspector title="Origen" :data="{ ruta: selectedLog.rutaOrigen || 'Inicio de Sesión' }" />
                     <DataInspector title="Destino" :data="{ ruta: selectedLog.rutaDestino }" />
                   </div>
                   <DataInspector title="Sesión y Parámetros" :data="{ 
                     sessionId: selectedLog.sessionId,
                     params: selectedLog.parametros,
                     viewTime: selectedLog.tiempoVistaMs ? `${selectedLog.tiempoVistaMs}ms` : 'N/A'
                   }" />
                </template>
            </div>
          </div>
        </template>

        <div v-else class="flex-1 flex flex-col items-center justify-center p-12 bg-surface">
           <div class="w-64 h-64 bg-surface-muted rounded-full flex items-center justify-center mb-10 shadow-inner group">
              <SecurityIcon class="w-32 h-32 text-border group-hover:scale-110 transition-transform duration-700" />
           </div>
           <h2 class="text-2xl font-black text-text mb-4 uppercase tracking-tighter">Sala de Auditoría</h2>
           <p class="text-[10px] font-black text-text-muted uppercase tracking-widest max-w-sm text-center leading-loose">
             Seleccione un rastro del historial para inspeccionar el flujo de datos y la trazabilidad del sistema
           </p>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import DataInspector from '@/components/admin/DataInspector.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import { useAuditLogs, type AuditType } from '../composables/useAuditLogs';
import { 
    RefreshIcon, 
    ShieldIcon, 
    UserCircleIcon, 
    BoxCubeIcon, 
    HistoryIcon,
    ArrowLeftIcon,
    ArrowRightIcon,
    MapPinIcon,
    ShieldIcon as SecurityIcon
} from '@/icons';

const { 
    activeType,
    apiLogs, 
    entityLogs, 
    eventLogs, 
    navigationLogs,
    selectedLog, 
    isLoading, 
    filters, 
    fetchLogs, 
    selectLog, 
    setAuditType 
} = useAuditLogs();

const auditTypes = [
    { id: 'api', label: 'API / HTTP' },
    { id: 'entidades', label: 'Datos / Tablas' },
    { id: 'eventos', label: 'Negocio / App' },
    { id: 'navegacion', label: 'Navegación' }
] as { id: AuditType, label: string }[];

const logs = computed(() => {
    if (activeType.value === 'api') return apiLogs.value;
    if (activeType.value === 'entidades') return entityLogs.value;
    if (activeType.value === 'eventos') return eventLogs.value;
    return navigationLogs.value;
});

// Scroll al tope
const listContainer = ref<HTMLElement | null>(null);
const scrollToTop = () => {
    if (listContainer.value) {
        listContainer.value.scrollTo({ top: 0, behavior: 'smooth' });
    }
};

// Responsividad
const isMobileView = ref(false);
const checkMobile = () => isMobileView.value = window.innerWidth < 1024;

// Búsqueda proactiva
watch(() => filters.value.busqueda, () => {
    filters.value.page = 1;
    fetchLogs();
});

// Watcher para scroll al cambiar página
watch(() => filters.value.page, () => {
    scrollToTop();
});

onMounted(() => {
    checkMobile();
    window.addEventListener('resize', checkMobile);
    fetchLogs();
});
onUnmounted(() => window.removeEventListener('resize', checkMobile));

// Utils de visualización
const getLogTag = (log: any) => {
    if (activeType.value === 'api') return log.metodo;
    if (activeType.value === 'entidades') return log.operacion;
    if (activeType.value === 'navegacion') return 'NAV';
    return log.categoria;
};

const getLogTitle = (log: any) => {
    if (activeType.value === 'api') return log.ruta;
    if (activeType.value === 'entidades') return `${log.entidadTipo} [${log.entidadId}]`;
    if (activeType.value === 'navegacion') return `${log.rutaOrigen || '(Inicio)'} → ${log.rutaDestino}`;
    return log.descripcion;
};

const getStatusClass = (log: any) => {
    if (activeType.value === 'api') return log.esError ? 'bg-error/20 text-error' : 'bg-success/20 text-success';
    if (activeType.value === 'entidades') {
        if (log.operacion === 'INSERT') return 'bg-success/20 text-success';
        if (log.operacion === 'UPDATE') return 'bg-warning/20 text-warning';
        return 'bg-error/20 text-error';
    }
    if (activeType.value === 'navegacion') return 'bg-info/20 text-info';
    return log.resultado === 'ERROR' ? 'bg-error/20 text-error' : 'bg-success/20 text-success';
};

const shouldShowDateHeader = (log: any, index: number) => {
    if (index === 0) return true;
    const prevLog = logs.value[index - 1];
    const currentDate = new Date(log.timestamp).toLocaleDateString();
    const prevDate = new Date(prevLog.timestamp).toLocaleDateString();
    return currentDate !== prevDate;
};

const formatDateGroup = (dateStr: string) => {
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: 'numeric',
        month: 'long',
        year: 'numeric'
    });
};

const formatDateShort = (dateStr: string) => {
    const date = new Date(dateStr);
    return date.toLocaleString('es-AR', { 
        day: '2-digit', 
        month: '2-digit',
        hour: '2-digit', 
        minute: '2-digit',
        hour12: false
    }).replace(',', '');
};

const formatDateFull = (dateStr: string) => {
    return new Date(dateStr).toLocaleString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric',
        hour: '2-digit', minute: '2-digit', second: '2-digit',
        hour12: false
    });
};
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar { width: 4px; height: 4px; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(var(--primary-rgb), 0.1); border-radius: 10px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
</style>
