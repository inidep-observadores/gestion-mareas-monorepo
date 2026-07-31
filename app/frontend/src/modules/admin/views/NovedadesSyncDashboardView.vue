<template>
  <AdminDashboardLayout
    title="Novedades por Email"
    description="Configuración de lectura automática de emails e IA para registro de Novedades de Observadores"
  >
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      
      <!-- Panel de Configuración Automática -->
      <div class="flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div class="flex items-center gap-3 mb-2">
          <div class="p-2 bg-primary/10 rounded-lg text-primary">
            <SettingsIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Ejecución Automática</h3>
        </div>
        
        <p class="text-sm text-text-muted mb-4">
          Configure la frecuencia del proceso de lectura automática de correos entrantes (IMAP) y su análisis mediante Inteligencia Artificial.
        </p>

        <div class="space-y-6">
          <div class="p-4 bg-surface-muted/30 rounded-lg border border-border">
            <div class="flex justify-between items-center mb-4">
              <div>
                <h4 class="font-bold text-text">Lectura IMAP e Inteligencia Artificial</h4>
                <p class="text-xs text-text-muted">Procesamiento automático de adjuntos y textos.</p>
              </div>
              <label class="relative inline-flex items-center cursor-pointer">
                <input type="checkbox" v-model="config.enabled" class="sr-only peer">
                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
              </label>
            </div>
            <div class="flex flex-col gap-4">
              <!-- Selector de Modo -->
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Modo de ejecución:</span>
                <div class="flex items-center gap-4">
                  <label class="flex items-center gap-2 text-sm text-text cursor-pointer">
                    <input type="radio" v-model="config.mode" value="periodic" class="radio radio-primary radio-sm">
                    Periódico
                  </label>
                  <label class="flex items-center gap-2 text-sm text-text cursor-pointer">
                    <input type="radio" v-model="config.mode" value="daily" class="radio radio-primary radio-sm">
                    Diario (Hora Fija)
                  </label>
                </div>
              </div>

              <!-- Input condicional para Periódico -->
              <div v-if="config.mode === 'periodic'" class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Intervalo:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="number" 
                    v-model.number="config.intervalMinutes"
                    class="w-20 bg-surface border border-border rounded px-2 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                    min="5"
                  />
                  <span class="text-sm text-text-muted">minutos</span>
                </div>
              </div>

              <!-- Input condicional para Diario -->
              <div v-if="config.mode === 'daily'" class="flex items-center gap-3">
                <span class="text-xs font-semibold text-text-muted uppercase w-32">Hora de ejecución:</span>
                <div class="flex items-center gap-2">
                  <input 
                    type="time" 
                    v-model="config.hour"
                    class="bg-surface border border-border rounded px-3 py-1 text-sm font-bold text-center outline-none focus:ring-1 focus:ring-primary"
                  />
                  <span class="text-xs text-text-muted">(Hora local Argentina)</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <button 
          @click="saveConfig"
          :disabled="isSaving"
          class="mt-4 w-full py-3 bg-primary text-primary-fg rounded-lg font-bold shadow-lg shadow-primary/20 hover:bg-primary/90 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
        >
          <CheckIcon v-if="!isSaving" class="w-4 h-4" />
          <RefreshIcon v-else class="w-4 h-4 animate-spin" />
          {{ isSaving ? 'Guardando...' : 'Guardar Configuración' }}
        </button>
      </div>

      <!-- Panel de Ejecución Manual -->
      <div class="flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
        <div class="flex items-center gap-3 mb-2">
          <div class="p-2 bg-info/10 rounded-lg text-info">
            <HistoryIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Ejecución Manual</h3>
        </div>

        <p class="text-sm text-text-muted mb-4">
          Forzar la ejecución inmediata del proceso de lectura de bandeja de entrada IMAP, ignorando el intervalo programado.
        </p>

        <div class="space-y-4">
          <div class="grid grid-cols-1 gap-3 pt-4">
            <button 
              @click="runManualSync"
              :disabled="isSyncingManual"
              class="py-3 bg-warning/10 border border-warning/20 text-warning rounded-lg font-bold hover:bg-warning/20 transition-all flex items-center justify-center gap-2 disabled:opacity-50"
            >
              <MailIcon class="w-4 h-4" />
              Sincronizar Emails Ahora
            </button>
          </div>

          <div v-if="manualSyncResult" class="mt-4 p-4 rounded-lg text-sm" :class="manualSyncResult.success ? 'bg-success/10 text-success' : 'bg-error/10 text-error'">
            <p class="font-bold mb-1">{{ manualSyncResult.message }}</p>
          </div>
        </div>
      </div>

    </div>

    <!-- Sección de Auditoría -->
    <div class="mt-8 flex flex-col gap-6 bg-surface p-6 rounded-xl border border-border shadow-sm">
      <div class="flex flex-col lg:flex-row lg:items-center justify-between mb-2 gap-4">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-secondary/10 rounded-lg text-secondary">
            <HistoryIcon class="w-5 h-5" />
          </div>
          <h3 class="text-lg font-bold text-text">Auditoría de Emails Procesados</h3>
        </div>
        
        <!-- Filtros -->
        <div class="flex flex-wrap items-center gap-3">
          <div class="w-72">
            <SearchInput 
              v-model="filters.search" 
              placeholder="Buscar remitente, asunto, estado, error..."
            />
          </div>
          <div class="w-40">
            <DatePicker v-model="filters.startDate" placeholder="Fecha Desde" class="w-full text-sm" @update:modelValue="applyFilters" />
          </div>
          <div class="w-40">
            <DatePicker v-model="filters.endDate" placeholder="Fecha Hasta" class="w-full text-sm" @update:modelValue="applyFilters" />
          </div>
          <button @click="resetFilters" class="btn btn-sm btn-ghost" title="Limpiar Filtros">
            Limpiar
          </button>
          <button @click="applyFilters" class="btn btn-sm btn-primary" :disabled="isLoadingLogs">
            <RefreshIcon v-if="isLoadingLogs" class="w-4 h-4 animate-spin" />
            <RefreshIcon v-else class="w-4 h-4" />
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <!-- Tabla (Maestro) -->
        <div class="overflow-x-auto rounded-lg border border-border" :class="selectedLog ? 'lg:col-span-8' : 'lg:col-span-12'">
          <table class="table w-full border-collapse text-sm">
            <thead class="bg-surface-muted border-b border-border text-text">
              <tr>
                <th @click="toggleSort('fechaRecepcion')" class="cursor-pointer hover:bg-surface p-3 text-left font-bold select-none whitespace-nowrap">
                  Fecha 
                  <span v-if="filters.sortBy === 'fechaRecepcion'">{{ filters.sortOrder === 'asc' ? '↑' : '↓' }}</span>
                </th>
                <th @click="toggleSort('remitente')" class="cursor-pointer hover:bg-surface p-3 text-left font-bold select-none whitespace-nowrap">
                  Remitente
                  <span v-if="filters.sortBy === 'remitente'">{{ filters.sortOrder === 'asc' ? '↑' : '↓' }}</span>
                </th>
                <th @click="toggleSort('asunto')" class="cursor-pointer hover:bg-surface p-3 text-left font-bold select-none min-w-[200px]">
                  Asunto
                  <span v-if="filters.sortBy === 'asunto'">{{ filters.sortOrder === 'asc' ? '↑' : '↓' }}</span>
                </th>
                <th @click="toggleSort('estado')" class="cursor-pointer hover:bg-surface p-3 text-left font-bold select-none whitespace-nowrap">
                  Estado
                  <span v-if="filters.sortBy === 'estado'">{{ filters.sortOrder === 'asc' ? '↑' : '↓' }}</span>
                </th>
                <template v-if="!selectedLog">
                  <th class="p-3 text-left font-bold select-none">Triage (Candidatos)</th>
                  <th class="p-3 text-left font-bold select-none">Resultados IA</th>
                </template>
              </tr>
            </thead>
            <tbody class="divide-y divide-border">
              <tr v-if="isLoadingLogs">
                <td :colspan="selectedLog ? 4 : 6" class="text-center py-8">Cargando...</td>
              </tr>
              <tr v-else-if="logs.length === 0">
                <td :colspan="selectedLog ? 4 : 6" class="text-center py-8 text-text-muted">No hay registros que coincidan con la búsqueda.</td>
              </tr>
              <tr 
                v-for="log in logs" 
                :key="log.id" 
                v-else
                @click="selectLog(log)"
                class="hover:bg-primary/5 cursor-pointer transition-colors"
                :class="{'bg-primary/10 border-l-4 border-l-primary': selectedLog?.id === log.id}"
              >
                <td class="whitespace-nowrap p-3">{{ new Date(log.fechaRecepcion).toLocaleString('es-AR') }}</td>
                <td class="truncate max-w-[150px] p-3" :title="log.remitente">{{ log.remitente }}</td>
                <td class="truncate p-3" :class="selectedLog ? 'max-w-[150px]' : 'max-w-[250px]'" :title="log.asunto">{{ log.asunto }}</td>
                <td class="p-3">
                  <span class="badge badge-sm" :class="{
                    'badge-success': log.estado === 'PROCESADO',
                    'badge-warning': log.estado === 'CON_ADVERTENCIAS' || log.estado === 'ERROR_TEMPORAL' || log.estado === 'PROCESANDO',
                    'badge-error': log.estado === 'CON_ERRORES',
                    'badge-neutral': log.estado === 'IGNORADO' || log.estado === 'SIN_NOVEDAD'
                  }">{{ log.estado }}</span>
                </td>
                <template v-if="!selectedLog">
                  <td class="p-3">
                    <div v-if="log.clasificacionTriage?.candidatos?.length" class="flex flex-col gap-1">
                      <span v-for="(cand, idx) in log.clasificacionTriage.candidatos" :key="idx" class="text-xs bg-base-200 px-2 py-1 rounded">
                        <b>{{ cand.tipoDocumento }}</b> en {{ cand.fuente }} 
                        <span v-if="cand.nombreArchivo" class="text-text-muted">({{ cand.nombreArchivo }})</span>
                      </span>
                    </div>
                    <span v-else class="text-xs text-text-muted">No detectado</span>
                  </td>
                  <td class="p-3">
                    <div v-if="log.detalles?.length" class="flex flex-col gap-1">
                      <span v-for="det in log.detalles" :key="det.id" class="text-xs" :class="det.estado === 'ERROR' ? 'text-error font-semibold' : 'text-success'">
                        {{ det.fuente }}: {{ det.estado }}
                        <span v-if="det.novedadId" class="badge badge-xs badge-success ml-1">Novedad Creada</span>
                      </span>
                    </div>
                    <span v-else class="text-xs text-text-muted">-</span>
                  </td>
                </template>
              </tr>
            </tbody>
          </table>

          <!-- Paginación Simple -->
          <div class="flex items-center justify-between p-4 bg-surface" v-if="totalLogs > 0">
            <span class="text-xs text-text-muted">Mostrando {{ logs.length }} de {{ totalLogs }} registros</span>
            <div class="join">
              <button class="join-item btn btn-xs" :disabled="currentPage === 1" @click="loadLogs(currentPage - 1)">«</button>
              <button class="join-item btn btn-xs">Pág {{ currentPage }} de {{ totalPages }}</button>
              <button class="join-item btn btn-xs" :disabled="currentPage === totalPages" @click="loadLogs(currentPage + 1)">»</button>
            </div>
          </div>
        </div>

        <!-- Panel Lateral (Detalle) -->
        <div v-if="selectedLog" class="lg:col-span-4 bg-surface border border-border rounded-lg shadow-lg flex flex-col h-full">
          <div class="flex items-center justify-between p-4 border-b border-border bg-surface-muted/30">
            <h4 class="font-bold text-text truncate pr-2">Detalle de Registro</h4>
            <div class="flex items-center gap-2">
              <button @click="isModalOpen = true" class="p-1.5 text-text-muted hover:text-primary hover:bg-primary/10 rounded transition-colors" title="Abrir consulta ampliada">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4" />
                </svg>
              </button>
              <button @click="selectedLog = null" class="p-1.5 text-text-muted hover:text-error hover:bg-error/10 rounded transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
          </div>
          
          <div class="p-4 overflow-y-auto max-h-[600px] flex-1 text-sm space-y-5">
            <div>
              <span class="block text-xs font-semibold text-text-muted uppercase mb-1">Fecha</span>
              <p class="font-medium">{{ new Date(selectedLog.fechaRecepcion).toLocaleString('es-AR') }}</p>
            </div>
            
            <div>
              <span class="block text-xs font-semibold text-text-muted uppercase mb-1">Remitente</span>
              <p class="font-medium break-all">{{ selectedLog.remitente }}</p>
            </div>
            
            <div>
              <span class="block text-xs font-semibold text-text-muted uppercase mb-1">Asunto</span>
              <p class="font-medium break-words">{{ selectedLog.asunto }}</p>
            </div>

            <hr class="border-border border-dashed" />

            <!-- Clasificación Triage -->
            <div>
              <span class="block text-xs font-semibold text-text-muted uppercase mb-2">Clasificación Inicial (Triage)</span>
              <div v-if="selectedLog.clasificacionTriage?.candidatos?.length" class="space-y-2">
                <div v-for="(cand, idx) in selectedLog.clasificacionTriage.candidatos" :key="idx" class="p-3 bg-surface-muted rounded border border-border">
                  <p class="font-bold text-primary">{{ cand.tipoDocumento }}</p>
                  <p class="text-xs text-text-muted mt-1">Fuente: <span class="font-mono text-text">{{ cand.fuente }}</span></p>
                  <p v-if="cand.nombreArchivo" class="text-xs text-text-muted mt-1">Archivo: <span class="font-mono text-text break-all">{{ cand.nombreArchivo }}</span></p>
                </div>
              </div>
              <p v-else class="text-text-muted text-xs italic">La IA no detectó candidatos relevantes en este correo.</p>
            </div>

            <!-- Detalles de Extracción -->
            <div v-if="selectedLog.detalles?.length">
              <div class="flex items-center justify-between mb-2">
                <span class="block text-xs font-semibold text-text-muted uppercase">Resultados de Procesamiento</span>
                
                <button 
                  type="button"
                  @click="toggleViewMode"
                  class="flex items-center gap-1.5 px-2 py-1 bg-surface border border-border rounded hover:border-primary transition-colors text-[10px] font-bold text-text-muted hover:text-primary group"
                >
                  <span v-if="viewMode === 'inline'" class="flex items-center gap-1">
                    <ListIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
                    Ver como Lista
                  </span>
                  <span v-else class="flex items-center gap-1">
                    <EyeIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
                    Ver Previsualización
                  </span>
                </button>
              </div>
              <div class="space-y-3">
                <div v-for="det in selectedLog.detalles" :key="det.id" class="p-3 bg-surface-muted rounded border border-border">
                  <div class="flex justify-between items-start mb-2">
                    <span class="font-semibold text-xs truncate max-w-[200px]" :title="det.fuente">{{ det.fuente }}</span>
                    <span class="badge badge-xs" :class="det.estado === 'ERROR' ? 'badge-error' : 'badge-success'">{{ det.estado }}</span>
                  </div>
                  
                  <div v-if="det.errorDetalle" class="mt-2 text-xs text-error bg-error/10 p-2 rounded">
                    {{ det.errorDetalle }}
                  </div>

                  <div v-if="det.novedadId" class="mt-2 text-xs">
                    <span class="badge badge-success badge-outline">Novedad creada exitosamente</span>
                  </div>

                  <!-- Documentos Adjuntos (Si los hay) -->
                  <AttachmentViewer 
                    v-if="det.novedad?.archivos?.length"
                    :archivos="det.novedad.archivos"
                    title="Archivos Generados/Adjuntos:"
                    class="mt-3"
                    :hideToggle="true"
                  />
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>
    </div>

    <!-- Modal Ampliado de Detalles -->
    <TransitionRoot appear :show="isModalOpen" as="template">
      <Dialog as="div" @close="isModalOpen = false" class="relative z-50">
        <TransitionChild
          as="template"
          enter="duration-300 ease-out"
          enter-from="opacity-0"
          enter-to="opacity-100"
          leave="duration-200 ease-in"
          leave-from="opacity-100"
          leave-to="opacity-0"
        >
          <div class="fixed inset-0 bg-black/50 backdrop-blur-sm" />
        </TransitionChild>

        <div class="fixed inset-0 overflow-y-auto">
          <div class="flex min-h-full items-center justify-center p-4 text-center">
            <TransitionChild
              as="template"
              enter="duration-300 ease-out"
              enter-from="opacity-0 scale-95"
              enter-to="opacity-100 scale-100"
              leave="duration-200 ease-in"
              leave-from="opacity-100 scale-100"
              leave-to="opacity-0 scale-95"
            >
              <DialogPanel class="w-full max-w-4xl transform overflow-hidden rounded-2xl bg-surface p-6 text-left align-middle shadow-xl transition-all border border-border flex flex-col h-[80vh]">
                <div class="flex justify-between items-start mb-4 shrink-0">
                  <DialogTitle as="h3" class="text-xl font-bold leading-6 text-text">
                    Auditoría Detallada del Correo
                  </DialogTitle>
                  <button @click="isModalOpen = false" class="text-text-muted hover:text-error transition-colors">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
                
                <div class="overflow-y-auto flex-1 pr-2 space-y-6" v-if="selectedLog">
                  <!-- Información Básica -->
                  <div class="grid grid-cols-2 gap-4 bg-surface-muted p-4 rounded-lg border border-border">
                    <div>
                      <span class="block text-xs font-semibold text-text-muted uppercase">Fecha de Recepción</span>
                      <p class="font-medium text-text">{{ new Date(selectedLog.fechaRecepcion).toLocaleString('es-AR') }}</p>
                    </div>
                    <div>
                      <span class="block text-xs font-semibold text-text-muted uppercase">Remitente</span>
                      <p class="font-medium text-text">{{ selectedLog.remitente }}</p>
                    </div>
                    <div class="col-span-2">
                      <span class="block text-xs font-semibold text-text-muted uppercase">Asunto</span>
                      <p class="font-medium text-text">{{ selectedLog.asunto }}</p>
                    </div>
                  </div>

                  <!-- Triage Detallado -->
                  <div>
                    <h4 class="font-bold text-lg text-text border-b border-border pb-2 mb-4">Clasificación de Inteligencia Artificial (Fase 1: Triage)</h4>
                    <div v-if="selectedLog.clasificacionTriage?.candidatos?.length" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                      <div v-for="(cand, idx) in selectedLog.clasificacionTriage.candidatos" :key="idx" class="p-4 bg-surface rounded-lg border border-border shadow-sm">
                        <div class="flex justify-between items-center mb-2">
                          <span class="text-sm font-bold text-primary">{{ cand.tipoDocumento }}</span>
                          <span class="badge badge-sm badge-neutral">{{ cand.fuente }}</span>
                        </div>
                        <p v-if="cand.nombreArchivo" class="text-sm text-text-muted break-all">
                          <span class="font-semibold text-text">Archivo:</span> {{ cand.nombreArchivo }}
                        </p>
                      </div>
                    </div>
                    <div v-else class="p-4 bg-warning/10 text-warning rounded-lg border border-warning/20">
                      La IA determinó que este correo no contiene información relevante (IRRELEVANTE).
                    </div>
                  </div>

                  <!-- Extracción Detallada -->
                  <div v-if="selectedLog.detalles?.length">
                    <div class="flex flex-col sm:flex-row sm:items-center justify-between border-b border-border pb-2 mb-4 gap-2">
                      <h4 class="font-bold text-lg text-text">Resultados de Extracción de Datos (Fase 2)</h4>
                      <button 
                        type="button"
                        @click="toggleViewMode"
                        class="flex items-center gap-1.5 px-2 py-1 bg-surface border border-border rounded hover:border-primary transition-colors text-[10px] font-bold text-text-muted hover:text-primary group w-fit"
                      >
                        <span v-if="viewMode === 'inline'" class="flex items-center gap-1">
                          <ListIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
                          Ver como Lista
                        </span>
                        <span v-else class="flex items-center gap-1">
                          <EyeIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
                          Ver Previsualización
                        </span>
                      </button>
                    </div>
                    <div class="space-y-4">
                      <div v-for="det in selectedLog.detalles" :key="det.id" class="p-4 bg-surface rounded-lg border border-border shadow-sm flex flex-col md:flex-row gap-6">
                        <div class="flex-1">
                          <div class="flex items-center gap-3 mb-2">
                            <h5 class="font-bold text-text truncate" :title="det.fuente">{{ det.fuente }}</h5>
                            <span class="badge badge-sm" :class="det.estado === 'ERROR' ? 'badge-error' : 'badge-success'">{{ det.estado }}</span>
                          </div>
                          <p v-if="det.errorDetalle" class="text-sm text-error bg-error/10 p-2 rounded mb-2">
                            {{ det.errorDetalle }}
                          </p>
                          <div v-if="det.extraccionAi" class="mt-2">
                            <p class="text-xs font-semibold text-text-muted mb-1">Datos Extraídos (Raw JSON):</p>
                            <pre class="bg-base-200 p-2 rounded text-xs overflow-x-auto max-h-40 font-mono text-text-muted">{{ JSON.stringify(det.extraccionAi, null, 2) }}</pre>
                          </div>
                        </div>

                        <!-- Panel de Archivos Asociados -->
                        <div v-if="det.novedad?.archivos?.length" class="w-full md:w-[350px] shrink-0 bg-surface-muted p-3 rounded-lg border border-border">
                          <AttachmentViewer 
                            :archivos="det.novedad.archivos"
                            title="Documentos Adjuntos"
                            :hideToggle="true"
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                </div>
              </DialogPanel>
            </TransitionChild>
          </div>
        </div>
      </Dialog>
    </TransitionRoot>

  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed, watch } from 'vue'
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue'
import novedadesAdminApi from '../services/novedades-admin.service'
import { toast } from 'vue-sonner'
import { 
  SettingsIcon, 
  HistoryIcon, 
  CheckIcon, 
  RefreshIcon
} from '@/icons'
import MailIcon from '@/icons/MailIcon.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import AttachmentViewer from '@/components/common/AttachmentViewer.vue'
import { Dialog, DialogPanel, DialogTitle, TransitionChild, TransitionRoot } from '@headlessui/vue'
import { useAttachmentViewMode } from '@/composables/useAttachmentViewMode'
import EyeIcon from '@/icons/EyeIcon.vue'
import ListIcon from '@/icons/ListIcon.vue'

const { viewMode, toggleViewMode } = useAttachmentViewMode()

const config = reactive({
  enabled: true,
  mode: 'periodic',
  intervalMinutes: 60,
  hour: '14:00'
})

const isSaving = ref(false)
const isSyncingManual = ref(false)
const manualSyncResult = ref<{ success: boolean; message: string } | null>(null)

// Estado para Logs
const logs = ref<any[]>([])
const totalLogs = ref(0)
const currentPage = ref(1)
const limit = ref(10)
const isLoadingLogs = ref(false)
const selectedLog = ref<any | null>(null)
const isModalOpen = ref(false)

const filters = reactive({
  search: '',
  startDate: '',
  endDate: '',
  sortBy: 'fechaRecepcion',
  sortOrder: 'desc' as 'asc' | 'desc'
})

let searchTimeout: any = null
watch(() => filters.search, () => {
  if (searchTimeout) clearTimeout(searchTimeout)
  searchTimeout = setTimeout(() => {
    applyFilters()
  }, 500)
})

const totalPages = computed(() => Math.ceil(totalLogs.value / limit.value))

// Cargar configuración inicial
const loadConfig = async () => {
  try {
    const remoteConfig = await novedadesAdminApi.getConfig()
    Object.assign(config, remoteConfig)
  } catch (error) {
    toast.error('Error al cargar la configuración de novedades')
  }
}

// Guardar configuración
const saveConfig = async () => {
  if (config.mode === 'periodic' && (!config.intervalMinutes || config.intervalMinutes < 5)) {
    toast.error('Error: El intervalo mínimo es 5 minutos para evitar bloqueos del servidor IMAP.')
    return
  }

  if (config.mode === 'daily' && !config.hour) {
    toast.error('Error: Debe especificar una hora de ejecución válida.')
    return
  }

  isSaving.value = true
  try {
    await novedadesAdminApi.updateConfig(config)
    toast.success('Configuración guardada correctamente')
  } catch (error) {
    toast.error('Error al guardar la configuración')
  } finally {
    isSaving.value = false
  }
}

// Sincronización manual
const runManualSync = async () => {
  isSyncingManual.value = true
  manualSyncResult.value = null
  
  try {
    await novedadesAdminApi.syncManual()
    
    manualSyncResult.value = {
      success: true,
      message: 'Sincronización encolada. El proceso de lectura se está ejecutando en segundo plano.',
    }
    toast.success('Sincronización encolada')
  } catch (error) {
    manualSyncResult.value = {
      success: false,
      message: 'Error al solicitar la sincronización manual.'
    }
    toast.error('Error en sincronización manual')
  } finally {
    isSyncingManual.value = false
  }
}

// Ordenamiento
const toggleSort = (field: string) => {
  if (filters.sortBy === field) {
    filters.sortOrder = filters.sortOrder === 'asc' ? 'desc' : 'asc'
  } else {
    filters.sortBy = field
    filters.sortOrder = 'asc'
  }
  loadLogs(1)
}

const applyFilters = () => {
  selectedLog.value = null // Deseleccionar al filtrar
  loadLogs(1)
}

const resetFilters = () => {
  filters.search = ''
  filters.startDate = ''
  filters.endDate = ''
  filters.sortBy = 'fechaRecepcion'
  filters.sortOrder = 'desc'
  applyFilters()
}

const selectLog = (log: any) => {
  if (selectedLog.value?.id === log.id) {
    selectedLog.value = null
  } else {
    selectedLog.value = log
  }
}

// Cargar Logs de Auditoría
const loadLogs = async (page: number = 1) => {
  isLoadingLogs.value = true
  try {
    const data = await novedadesAdminApi.getLogs({ 
      page, 
      limit: limit.value,
      search: filters.search,
      startDate: filters.startDate,
      endDate: filters.endDate,
      sortBy: filters.sortBy,
      sortOrder: filters.sortOrder
    })
    logs.value = data.items
    totalLogs.value = data.total
    currentPage.value = data.page
  } catch (error) {
    toast.error('Error al cargar la auditoría de correos')
  } finally {
    isLoadingLogs.value = false
  }
}

onMounted(() => {
  loadConfig()
  loadLogs()
})
</script>
