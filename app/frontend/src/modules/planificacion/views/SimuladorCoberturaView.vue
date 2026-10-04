<template>
  <PlanificacionDashboardLayout
    title="Simulador de Cobertura"
    description="Proyección interactiva de mareas y asignación de observadores en la línea de tiempo"
  >
    <div class="space-y-6">
      <!-- Cabecera de Controles y Escenarios -->
      <div class="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between bg-surface p-4 rounded-2xl border border-border shadow-sm">
        <div class="flex flex-wrap items-center gap-3">
          <BackButton routeName="PlanificacionDashboard" label="Regresar" containerClass="mb-0" />
          <div class="h-6 w-px bg-border hidden sm:block"></div>
          <div>
            <div class="flex items-center gap-4">
              <h1 class="text-lg font-black text-text uppercase tracking-tight">Escenario:</h1>
              <select v-model="selectedEscenarioId" @change="onEscenarioChange" class="h-9 px-3 text-sm font-bold rounded-lg border border-border bg-surface text-text focus:outline-none focus:border-primary">
                <option value="new">+ Crear Nuevo Escenario</option>
                <option disabled>──────────</option>
                <option v-for="esc in listaEscenarios" :key="esc.id" :value="esc.id">
                  {{ esc.nombre }}
                </option>
              </select>
            </div>
            <p class="text-xs text-text-muted">Haga doble clic en áreas vacías de la línea de tiempo para crear nuevas mareas simuladas.</p>
          </div>
        </div>

        <div class="flex flex-wrap items-center gap-3">


          <!-- Botones de Acción de Escenario -->
          <button
            v-if="escenarioActual && escenarioActual.id"
            :disabled="!isLockedByMe"
            @click="abrirModalEditarEscenario"
            class="h-10 px-3.5 inline-flex items-center justify-center gap-2 text-xs font-extrabold tracking-wider uppercase transition-all rounded-xl bg-surface border border-border text-text hover:bg-surface-muted active:scale-95 shadow-sm disabled:opacity-50 disabled:pointer-events-none"
            title="Editar nombre y descripción del escenario"
          >
            <EditIcon class="w-4 h-4" />
            Editar
          </button>
          
          <button
            v-if="escenarioActual && escenarioActual.id"
            @click="clonarEscenario"
            class="h-10 px-3.5 inline-flex items-center justify-center gap-2 text-xs font-extrabold tracking-wider uppercase transition-all rounded-xl bg-surface border border-border text-text hover:bg-surface-muted active:scale-95 shadow-sm"
            title="Crear una copia exacta de este escenario para probar alternativas"
          >
            <PlusIcon class="w-4 h-4" />
            Clonar
          </button>

          <button
            v-show="false"
            v-if="escenarioActual && escenarioActual.id"
            @click="guardarEscenario"
            class="h-10 px-3.5 inline-flex items-center justify-center gap-2 text-xs font-extrabold tracking-wider uppercase transition-all rounded-xl bg-primary text-white hover:bg-primary/90 active:scale-95 shadow-sm"
          >
            <DraftIcon class="w-4 h-4" />
            Guardar Cambios
          </button>

          <button
            v-if="escenarioActual && escenarioActual.id"
            :disabled="!isLockedByMe"
            @click="eliminarEscenario"
            class="h-10 px-3 inline-flex items-center justify-center gap-1.5 text-xs font-bold tracking-wider uppercase transition-all rounded-xl bg-surface border border-border text-error hover:bg-error/10 active:scale-95 disabled:opacity-50 disabled:pointer-events-none"
            title="Eliminar escenario"
          >
            <TrashIcon class="w-4 h-4" />
            Eliminar
          </button>
        </div>
      </div>

      <!-- Alerta de Solo Lectura por Bloqueo -->
      <div v-if="!isLockedByMe && lockedByOtherUser" class="p-4 rounded-xl border border-warning/30 bg-warning/10 text-warning-800 dark:text-warning-100 flex items-center gap-3">
        <AlertTriangleIcon class="w-5 h-5 shrink-0 text-warning-600 dark:text-warning-500" />
        <div class="text-sm">
          <span class="font-bold">Modo Consulta: </span>
          El escenario está siendo modificado por <span class="font-bold">{{ lockedByOtherUser }}</span>. No es posible realizar cambios.
        </div>
      </div>

      <!-- Leyenda y Filtros Rápidos -->
        <div class="flex flex-wrap items-center justify-between gap-4 p-4 rounded-xl border border-border bg-surface shadow-sm">
        <div class="flex flex-wrap items-center gap-4">
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-ejecucion"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">En Ejecución</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-finalizada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Finalizada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-designada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Designada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-licencia"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Licencia</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded border-2 legend-proyectada"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Proyectada</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-6 h-5 rounded bg-error border border-error animate-pulse"></div>
            <span class="text-[11px] font-bold uppercase text-text-muted">Conflicto</span>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <div class="flex items-center gap-1 bg-surface border border-border p-1 rounded-lg">
            <button @click="timeScale = 'day'" :class="timeScale === 'day' ? 'bg-primary/10 text-primary' : 'text-text-muted hover:bg-surface-muted'" class="px-3 py-1.5 text-xs font-bold rounded-md transition-colors">Diaria</button>
            <button @click="timeScale = 'month'" :class="timeScale === 'month' ? 'bg-primary/10 text-primary' : 'text-text-muted hover:bg-surface-muted'" class="px-3 py-1.5 text-xs font-bold rounded-md transition-colors">Mensual</button>
          </div>
          <div class="flex items-center gap-1 bg-surface border border-border p-1 rounded-lg">
            <button @click="zoomOutTimeline" class="px-2.5 py-1.5 text-xs font-black text-text-muted hover:text-text hover:bg-surface-muted rounded-md transition-colors" title="Alejar (Zoom Out)">
              –
            </button>
            <button @click="resetZoomTimeline" class="px-2.5 py-1.5 text-xs font-black text-text-muted hover:text-text hover:bg-surface-muted rounded-md transition-colors" title="Restaurar Vista (Reset Zoom)">
              ↺
            </button>
            <button @click="zoomInTimeline" class="px-2.5 py-1.5 text-xs font-black text-text-muted hover:text-text hover:bg-surface-muted rounded-md transition-colors" title="Acercar (Zoom In)">
              +
            </button>
          </div>
          <button
            v-show="false"
            @click="toggleSidebar"
            class="h-9 px-3 inline-flex items-center gap-2 text-xs font-bold rounded-lg border border-border bg-surface text-text hover:bg-surface-muted transition-colors"
          >
            <LayersIcon class="w-4 h-4" />
            {{ sidebarOpen ? 'Ocultar Recursos' : 'Mostrar Recursos' }}
          </button>
        </div>
      </div>

      <!-- Alertas / Advertencias de Conflicto -->
      <div v-if="conflictosDetectados.length > 0" class="p-4 rounded-xl border border-error/30 bg-error/10 text-error flex flex-col gap-2">
        <div class="flex items-center gap-2 font-black text-xs uppercase tracking-wider">
          <WarningIcon class="w-5 h-5 shrink-0" />
          <span>Advertencias de Conflicto Detectadas ({{ conflictosDetectados.length }})</span>
        </div>
        <ul class="text-xs space-y-1 pl-7 list-disc">
          <li v-for="(conf, idx) in conflictosDetectados" :key="idx">
            {{ conf.mensaje }}
          </li>
        </ul>
      </div>

      <!-- Layout Principal: Sidebar Izquierdo + Timeline Central -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <!-- Sidebar Izquierdo: Mareas y Pesquerías Requeridas Arrastrables -->
        <div
          v-show="false"
          class="lg:col-span-3 bg-surface rounded-2xl border border-border shadow-sm p-4 flex flex-col gap-4 max-h-[72vh] overflow-y-auto"
        >
          <div class="flex items-center justify-between border-b border-border pb-3">
            <div>
              <h3 class="text-sm font-bold text-text uppercase tracking-tight">Recursos Pendientes</h3>
              <p class="text-[11px] text-text-muted">Pesquerías / Mareas a cubrir</p>
            </div>
            <div class="flex items-center gap-2">
              <span class="px-2 py-0.5 rounded-full bg-info/10 text-info text-xs font-bold">
                {{ recursosPendientes.length }}
              </span>
              <button 
                @click="abrirModalCrearRecurso"
                class="p-1.5 rounded-lg bg-primary/10 text-primary hover:bg-primary/20 transition-colors"
                title="Crear nuevo requerimiento"
              >
                <PlusIcon class="w-4 h-4" />
              </button>
            </div>
          </div>

          <div class="space-y-3">
            <div
              v-for="recurso in recursosVisibles"
              :key="recurso.id"
              draggable="true"
              @dragstart="onDragStartRecurso($event, recurso)"
              @dblclick="abrirModalEditarRecurso(recurso)"
              class="p-3.5 rounded-xl border border-border bg-surface hover:bg-surface-muted hover:border-primary/50 transition-all cursor-grab active:cursor-grabbing shadow-sm group relative"
            >
              <div class="flex items-center justify-between mb-1.5 pr-14 relative">
                <span class="text-xs font-extrabold text-primary group-hover:text-primary-hover transition-colors truncate pr-2">
                  {{ activeTab === 'observador' ? recurso.buqueNombre : recurso.observadorNombre }}
                </span>
                
                <div class="absolute right-0 top-0 flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                  <button @click="abrirModalEditarRecurso(recurso)" class="p-1 rounded text-text-muted hover:text-primary hover:bg-primary/10 transition-colors" title="Editar">
                    <EditIcon class="w-3.5 h-3.5" />
                  </button>
                  <button @click="eliminarRecurso(recurso.id)" class="p-1 rounded text-text-muted hover:text-error hover:bg-error/10 transition-colors" title="Eliminar">
                    <TrashIcon class="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
              
              <div class="flex items-center justify-between mb-2">
                <span
                  class="px-1.5 py-0.5 rounded text-[10px] font-black uppercase tracking-wider"
                  :class="recurso.prioridad === 'ALTA' ? 'bg-error/10 text-error' : 'bg-info/10 text-info'"
                >
                  {{ recurso.prioridad }}
                </span>
              </div>

              <div class="text-xs text-text-muted space-y-1">
                <div v-if="activeTab === 'observador' && recurso.pesqueriaNombre" class="flex items-center gap-1">
                  <WaveIcon class="w-3.5 h-3.5 shrink-0" />
                  <span class="font-medium text-text">{{ recurso.pesqueriaNombre }}</span>
                </div>
                <div class="flex items-center justify-between text-[11px]">
                  <span>Duración estimada:</span>
                  <span class="font-bold text-text">{{ recurso.diasEstimados }} días</span>
                </div>

              </div>

              <div class="mt-2 text-[10px] text-primary/80 font-bold flex items-center justify-end gap-1 opacity-80 group-hover:opacity-100">
                <span>Arrastrar al timeline</span>
                <span>➔</span>
              </div>
            </div>

            <div v-if="recursosPendientes.length === 0" class="p-6 text-center text-text-muted text-xs border border-dashed border-border rounded-xl">
              No hay recursos pendientes en este escenario.
            </div>
          </div>
        </div>

        <!-- Canvas Central (vis-timeline) -->
        <div
          :class="[sidebarOpen ? 'lg:col-span-9' : 'lg:col-span-12']"
          class="bg-surface rounded-2xl shadow-sm border border-border p-4 transition-all flex flex-col gap-4 relative overflow-hidden min-h-[500px]"
        >
          <!-- Placeholder cuando no hay escenario -->
          <div v-if="!escenarioActual" class="absolute inset-0 flex flex-col items-center justify-center bg-surface/80 backdrop-blur-sm z-10 p-8 text-center rounded-2xl">
            <LayersIcon class="w-16 h-16 text-primary/20 mb-4" />
            <h2 class="text-xl font-black text-text mb-2">No hay un escenario seleccionado</h2>
            <p class="text-sm text-text-muted max-w-md mb-6">Seleccione un escenario en el panel superior o cree uno nuevo para comenzar a trabajar en la planificación de mareas.</p>
            <button
              @click="selectedEscenarioId = 'new'; onEscenarioChange()"
              class="px-6 py-3 bg-primary text-white rounded-xl text-sm font-bold shadow-md hover:bg-primary/90 transition-colors flex items-center gap-2"
            >
              <PlusIcon class="w-5 h-5" />
              Crear Nuevo Escenario
            </button>
          </div>

          <!-- Tabs de Vista -->
          <div class="flex items-center gap-1 border-b border-border bg-surface-muted/30 -mx-4 -mt-4 px-4 pt-2 mb-2">
            <button 
              @click="activeTab = 'buque'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'buque' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <ShipIcon class="w-4 h-4" />
              Por buque
            </button>

            <button 
              @click="activeTab = 'observador'" 
              class="px-5 py-3 text-sm font-black uppercase tracking-wider border-b-2 transition-colors -mb-px flex items-center gap-2"
              :class="activeTab === 'observador' ? 'border-primary text-primary' : 'border-transparent text-text-muted hover:text-text'"
            >
              <UserCircleIcon class="w-4 h-4" />
              Por observador
            </button>
            <div class="ml-auto pr-4 pb-2 flex flex-col items-end gap-2">
              <div v-if="activeTab === 'observador'" class="flex gap-2">
                <button
                  v-for="type in [{ key: 'OBSERVADOR', label: 'Observadores' }, { key: 'TECNICO', label: 'Técnicos' }]"
                  :key="type.key" @click="toggleType(type.key)"
                  class="px-4 py-1 rounded-full text-[10px] font-black uppercase tracking-tight transition-all duration-200"
                  :class="[
                    selectedTypes.includes(type.key)
                      ? 'bg-primary text-white shadow-sm ring-1 ring-primary'
                      : 'bg-surface-muted text-text-muted border border-border hover:bg-surface hover:text-text'
                  ]">
                  {{ type.label }}
                </button>
              </div>
              <div class="flex items-center gap-3">
                <label class="flex items-center gap-2 px-3 h-9 bg-surface-muted rounded-lg border border-border cursor-pointer hover:bg-surface transition-colors shadow-sm whitespace-nowrap">
                  <input type="checkbox" v-model="soloMareasPlanificadas" class="w-3.5 h-3.5 text-primary bg-surface border-border rounded focus:ring-primary focus:ring-2">
                  <span class="text-[10px] font-black text-text-muted uppercase tracking-widest mt-0.5">SÓLO PLANIFICADAS Y ACTIVAS</span>
                </label>
                <SearchInput 
                  v-model="searchQuery" 
                  :placeholder="activeTab === 'observador' ? 'Buscar observador...' : 'Buscar buque...'" 
                  class="w-40 h-9" 
                />
                <select 
                  v-if="activeTab === 'buque'"
                  v-model="filtroPesqueria"
                  class="h-9 px-3 border border-border rounded-lg bg-surface text-xs text-text-muted focus:ring-2 focus:ring-primary focus:border-primary outline-none cursor-pointer shadow-sm"
                >
                  <option value="">Todas las pesquerías</option>
                  <option v-for="p in pesqueriasNombresDisponibles" :key="p" :value="p">{{ p }}</option>
                </select>
                <button 
                  v-show="false"
                  v-if="activeTab === 'buque'"
                  @click="isAddBuqueModalOpen = true"
                  class="px-3 py-1.5 h-9 text-xs font-bold text-primary border border-primary rounded hover:bg-primary hover:text-white transition-colors flex items-center gap-1"
                >
                  <PlusIcon class="w-3.5 h-3.5" /> Agregar Buque
                </button>
                
                <!-- History Buttons -->
                <div class="flex items-center gap-1 bg-surface-muted rounded-lg border border-border p-1 shadow-sm h-9">
                  <button 
                    @click="handleUndo" 
                    :disabled="!canUndo"
                    class="p-1.5 rounded text-text-muted hover:bg-surface hover:text-text disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    title="Deshacer"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7v6h6"/><path d="M21 17a9 9 0 0 0-9-9 9 9 0 0 0-6 2.3L3 13"/></svg>
                  </button>
                  <div class="w-px h-4 bg-border"></div>
                  <button 
                    @click="handleRedo" 
                    :disabled="!canRedo"
                    class="p-1.5 rounded text-text-muted hover:bg-surface hover:text-text disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
                    title="Rehacer"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M21 7v6h-6"/><path d="M3 17a9 9 0 0 1 9-9 9 9 0 0 1 6 2.3l3 2.7"/></svg>
                  </button>
                </div>
                <ExportExcelButton
                  label="EXPORTAR"
                  title="Exportar planificación a Excel"
                  @click="abrirModalExportacion"
                  class="px-4 py-1.5 h-9 rounded bg-surface shadow-theme-xs border-border"
                />

                <button 
                  :disabled="!isLockedByMe"
                  @click="abrirModalCrearBloque()" title="Crea una marea simulada para este escenario (no es una marea real)"
                  class="px-4 py-1.5 h-9 text-xs font-black uppercase tracking-wider text-white bg-primary rounded shadow-theme-xs shadow-primary/20 hover:bg-primary-hover active:scale-95 transition-all flex items-center gap-1.5 disabled:opacity-50 disabled:cursor-not-allowed disabled:pointer-events-none"
                >
                  <PlusIcon class="w-4 h-4" /> Nueva Marea
                </button>
              </div>
            </div>
          </div>

          <!-- Loading State -->
          <div v-if="isLoading" class="p-12 flex flex-col items-center justify-center bg-surface rounded-2xl">
            <div class="w-8 h-8 border-4 border-primary border-t-transparent rounded-full animate-spin mb-4"></div>
            <p class="text-sm font-bold text-text-muted">Cargando disponibilidad de observadores...</p>
          </div>

          <!-- Timelines -->
          <div v-if="!isLoading" class="w-full h-full relative">
            <SimuladorTimeline
            :readonly="!isLockedByMe" 
              v-if="hasOpenedObservador"
              v-show="activeTab === 'observador'"
              ref="timelineObservadorRef"
              mode="observador"
              :groups="timelineObservadorGroups"
              :items="timelineObservadorItems"
              :timeScale="timeScale"
              @item-moved="handleItemMoved"
              @item-removed="handleItemRemoved"
              @drop-recurso="handleDropRecurso"
              @edit-item="handleEditItem"
              @add-marea="(payload) => handleAddMarea(payload, 'observador')"
              class="h-[65vh] border-t border-border"
            />

            <SimuladorTimeline
            :readonly="!isLockedByMe" 
              v-if="hasOpenedBuque"
              v-show="activeTab === 'buque'"
              ref="timelineBuqueRef"
              mode="buque"
              :groups="timelineBuqueGroups"
              :items="timelineBuqueItems"
              :timeScale="timeScale"
              @item-moved="handleItemMoved"
              @item-removed="handleItemRemoved"
              @drop-recurso="handleDropRecurso"
              @edit-item="handleEditItem"
              @add-marea="(payload) => handleAddMarea(payload, 'buque')"
              class="h-[65vh] border-t border-border"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Crear/Editar Recurso -->
    <BaseModal 
      :show="isResourceModalOpen" 
      @close="cerrarModalRecurso" 
      maxWidth="md" 
      :title="editingRecursoId ? 'Editar Requerimiento' : 'Crear Requerimiento'"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div class="space-y-4" v-if="!loadingCatalogs">
          <div class="space-y-1.5" v-if="activeTab === 'observador'">
            <label class="block text-xs font-bold text-text-muted">Buque (obligatorio)</label>
            <SearchableSelect 
              ref="buqueSelectRef"
              v-model="resourceForm.buqueId" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
              @change="onBuqueResourceChange"
            />
          </div>
          <div class="space-y-1.5" v-if="activeTab === 'buque'">
            <label class="block text-xs font-bold text-text-muted">Observador (obligatorio)</label>
            <SearchableSelect 
              ref="observadorSelectRef"
              v-model="resourceForm.observadorId" 
              :options="observadorOptions" 
              :icon="UserCircleIcon" 
              placeholder="Seleccione observador..." 
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Días Estimados</label>
              <input v-model="resourceForm.diasEstimados" type="number" autocomplete="off" class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Prioridad</label>
              <select v-model="resourceForm.prioridad" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-colors shadow-theme-xs">
                <option value="ALTA">Alta</option>
                <option value="MEDIA">Media</option>
                <option value="BAJA">Baja</option>
              </select>
            </div>
          </div>
        </div>
        <div v-else class="flex items-center justify-center py-10">
          <div class="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
        </div>
        
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="cerrarModalRecurso" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">Cancelar</button>
          <button @click="guardarRecurso" :disabled="loadingCatalogs" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Guardar</button>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Escenario -->
    <BaseModal
      :show="isEscenarioModalOpen"
      @close="isEscenarioModalOpen = false"
      :title="escenarioModalMode === 'edit' ? 'Editar Escenario' : (escenarioModalMode === 'clone' ? 'Clonar Escenario' : 'Nuevo Escenario')"
    >
      <div v-form-nav>
        <div class="space-y-4">
          <div>
          <label class="block text-xs font-bold text-text-muted mb-1.5">Nombre <span class="text-error">*</span></label>
          <input
            ref="nombreEscenarioInput"
            v-model="escenarioForm.nombre"
            type="text"
            class="w-full h-10 px-3 rounded-lg border border-border bg-surface text-sm focus:outline-none focus:border-primary"
            placeholder="Ej: Simulacion Base 2026"
          />
        </div>
        <div>
          <label class="block text-xs font-bold text-text-muted mb-1.5">Descripción</label>
          <textarea
            v-model="escenarioForm.descripcion"
            class="w-full p-3 rounded-lg border border-border bg-surface text-sm focus:outline-none focus:border-primary"
            placeholder="Opcional"
            rows="3"
          ></textarea>
        </div>
      </div>
      <div class="mt-6 flex justify-end gap-3">
        <button
          @click="isEscenarioModalOpen = false"
          class="px-4 py-2 text-sm font-bold text-text hover:bg-surface-muted rounded-lg transition-colors"
        >
          Cancelar
        </button>
        <button
          @click="guardarModalEscenario"
          :disabled="!escenarioForm.nombre"
          data-allow-enter
          class="px-4 py-2 text-sm font-bold text-white bg-primary rounded-lg hover:bg-primary/90 transition-colors disabled:opacity-50"
        >
          Guardar
        </button>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Agregar Buque al Timeline -->
    <BaseModal 
      :show="isAddBuqueModalOpen" 
      @close="isAddBuqueModalOpen = false" 
      maxWidth="md" 
      title="Agregar Buque al Timeline"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              v-model="selectedBuqueToAdd" 
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
        </div>
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="isAddBuqueModalOpen = false" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">Cancelar</button>
          <button @click="addBuqueToTimeline"  class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 disabled:opacity-50">Aceptar</button>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Editar Bloque Simulado -->
    <BaseModal 
      :show="isEditBlockModalOpen" 
      @close="cerrarModalEditarBloque" 
      maxWidth="xl" 
      title="Editar Marea Simulada"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div v-if="editingBlockData" class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              ref="editBuqueSelectRef"
              :modelValue="editingBlockData.buqueId ?? null"
              @update:modelValue="(v) => onEditBlockBuqueChange(v as string | null)"
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Observador</label>
            <SearchableSelect 
              :modelValue="editingBlockData.observadorId ?? null"
              @update:modelValue="(v) => (editingBlockData!.observadorId = v as string | null)"
              :options="observadorOptions" 
              :icon="UserCircleIcon" 
              placeholder="Seleccione observador..." 
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Fecha Inicial</label>
              <DatePicker v-model="blockZarpadaStr" placeholder="Seleccione fecha inicial" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Fecha Final</label>
              <DatePicker v-model="blockArriboStr" placeholder="Seleccione fecha final" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Días Estimados</label>
              <input v-model="editingBlockData.diasEstimados" @input="onDiasEstimadosChange" type="number" autocomplete="off" min="1" class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Prioridad</label>
              <select v-model="editingBlockData.prioridad" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-colors shadow-theme-xs">
                <option value="ALTA">Alta</option>
                <option value="MEDIA">Media</option>
                <option value="BAJA">Baja</option>
              </select>
            </div>
          </div>
          <div class="space-y-1.5 pt-2">
            <label class="block text-xs font-bold text-text-muted">Comentario</label>
            <textarea v-model="editingBlockData.comentario" rows="2" placeholder="Comentario opcional..." class="w-full px-4 py-2 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs resize-none"></textarea>
          </div>
        </div>
        
        <div class="mt-8 pt-6 flex items-center justify-between border-t border-border gap-3">
          <button @click="devolverRecursoPendiente" class="px-4 py-3 text-xs font-black uppercase tracking-widest text-error hover:bg-error/10 rounded-lg transition-all flex items-center gap-2">
            <TrashIcon class="w-4 h-4" />
            Quitar de planificación
          </button>
          <div class="flex gap-2">
            <button @click="cerrarModalEditarBloque" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-text transition-all">Cancelar</button>
            <button @click="guardarEdicionBloque" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95">Guardar</button>
          </div>
        </div>
      </div>
    </BaseModal>

    <!-- Modal Crear Marea Simulada -->
    <BaseModal 
      :show="isCreateBlockModalOpen" 
      @close="cerrarModalCrearBloque" 
      maxWidth="xl" 
      title="Crear Marea Planificada"
    >
      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <div v-if="newBlockData" class="space-y-4">
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Buque</label>
            <SearchableSelect 
              ref="crearBuqueSelectRef"
              :modelValue="newBlockData.buqueId ?? null"
              @update:modelValue="(v) => onNewBlockBuqueChange(v as string | null)"
              :options="buqueOptions" 
              :icon="ShipIcon" 
              placeholder="Seleccione buque..." 
            />
          </div>
          <div class="space-y-1.5">
            <label class="block text-xs font-bold text-text-muted">Observador</label>
            <SearchableSelect 
              ref="crearObservadorSelectRef"
              :modelValue="newBlockData.observadorId ?? null"
              @update:modelValue="(v) => (newBlockData!.observadorId = v as string | null)"
              :options="observadorOptions" 
              :icon="UserCircleIcon" 
              placeholder="Seleccione observador..." 
            />
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Fecha Inicial</label>
              <DatePicker v-model="newBlockZarpadaStr" placeholder="Seleccione fecha inicial" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Fecha Final</label>
              <DatePicker v-model="newBlockArriboStr" placeholder="Seleccione fecha final" />
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Días Estimados</label>
              <input v-model="newBlockData.diasEstimados" @input="onNewDiasEstimadosChange" type="number" autocomplete="off" min="1" class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs" />
            </div>
            <div class="space-y-1.5">
              <label class="block text-xs font-bold text-text-muted">Prioridad</label>
              <select v-model="newBlockData.prioridad" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-colors shadow-theme-xs">
                <option value="ALTA">Alta</option>
                <option value="MEDIA">Media</option>
                <option value="BAJA">Baja</option>
              </select>
            </div>
          </div>
          <div class="space-y-1.5 pt-2">
            <label class="block text-xs font-bold text-text-muted">Comentario</label>
            <textarea v-model="newBlockData.comentario" rows="2" placeholder="Comentario opcional..." class="w-full px-4 py-2 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all shadow-theme-xs resize-none"></textarea>
          </div>
        </div>
        
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="cerrarModalCrearBloque" class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-text transition-all">Cancelar</button>
          <button @click="guardarCreacionBloque" data-allow-enter class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95">Guardar</button>
        </div>
      </div>
    </BaseModal>

    <ConfirmationDialog
      :show="showConfirmChangeScenario"
      title="Cambios sin guardar"
      message="Tiene cambios sin guardar en el escenario actual. ¿Desea continuar y perder los cambios?"
      confirmText="Sí, descartar cambios"
      cancelText="Cancelar"
      confirmButtonClass="bg-error hover:bg-error-hover shadow-error/20"
      @confirm="handleConfirmChangeScenario"
      @close="handleCancelChangeScenario"
    />

    <ConfirmationDialog
      :show="showConfirmDeleteScenario"
      title="Eliminar escenario"
      message="¿Seguro que desea eliminar el escenario actual? Esta acción no se puede deshacer."
      confirmText="Sí, eliminar"
      cancelText="Cancelar"
      confirmButtonClass="bg-error hover:bg-error-hover shadow-error/20"
      @confirm="handleConfirmDeleteScenario"
      @close="showConfirmDeleteScenario = false"
    />

    <!-- Modal Exportar Excel -->
    <BaseModal 
      :show="isExportModalOpen" 
      title="Exportar Planificación" 
      @close="isExportModalOpen = false"
      maxWidth="md"
    >
      <div class="p-6 space-y-6">
        <p class="text-sm text-text-muted">
          Seleccione el rango de fechas que desea incluir en el archivo Excel.
        </p>

        <div class="flex flex-col sm:flex-row gap-4">
          <div class="flex-1 space-y-1">
            <label class="text-xs font-bold text-text">Fecha Desde</label>
            <DatePicker v-model="exportForm.fechaDesde" placeholder="Desde" />
          </div>
          <div class="flex-1 space-y-1">
            <label class="text-xs font-bold text-text">Fecha Hasta</label>
            <DatePicker v-model="exportForm.fechaHasta" placeholder="Hasta" />
          </div>
        </div>

        <div class="flex flex-col sm:flex-row gap-4">
          <div class="flex-1 space-y-1">
            <label class="text-xs font-bold text-text">Formato</label>
            <select v-model="exportForm.formato" class="w-full h-9 px-3 rounded-lg border border-border bg-surface text-sm focus:outline-none focus:border-primary">
              <option value="EXCEL">Excel (.xlsx)</option>
              <option value="PDF">PDF (Oficio Apaisado)</option>
              <option value="PNG">Imagen (.png)</option>
            </select>
          </div>
          <div class="flex-1 space-y-1" v-if="exportForm.formato === 'EXCEL'">
             <div class="flex items-center gap-2 mt-7">
               <input type="checkbox" id="exportSoloPlanificadas" v-model="exportForm.soloPlanificadas" class="w-4 h-4 text-primary rounded border-border focus:ring-primary" />
               <label for="exportSoloPlanificadas" class="text-sm text-text cursor-pointer">Sólo Planificadas</label>
             </div>
          </div>
        </div>

        <div class="flex items-center gap-2 p-3 bg-primary/5 border border-primary/20 rounded-lg" v-if="exportForm.formato !== 'EXCEL'">
          <span class="text-xs text-primary"><strong>Nota:</strong> La exportación a imagen/PDF capturará exactamente lo que se ve en pantalla. El sistema hará zoom automáticamente a las fechas seleccionadas.</span>
        </div>

        <div class="flex justify-end gap-3 pt-4 border-t border-border mt-6">
          <button @click="isExportModalOpen = false" class="px-5 py-2 text-sm font-bold text-text-muted hover:text-text transition-colors">
            Cancelar
          </button>
          <button @click="procesarExportacion" :disabled="isExporting" class="px-6 py-2 bg-primary text-white rounded-lg text-sm font-bold shadow-md hover:bg-primary/90 transition-all flex items-center gap-2 disabled:opacity-50">
            <DownloadIcon v-if="!isExporting" class="w-4 h-4" />
            <span v-if="isExporting" class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></span>
            Exportar
          </button>
        </div>
      </div>
    </BaseModal>

    <ConfirmationDialog
      :show="showConfirmNoObserver"
      title="Planificar sin observador"
      message="¿Seguro que desea planificar esta marea simulada sin asignarle un observador? Se mostrará en el sistema como 'Sin observador'."
      confirmText="Sí, planificar"
      cancelText="Cancelar"
      @confirm="confirmarSinObservador"
      @close="cancelarSinObservador"
    />

    <!-- Modal de Bloqueo Pesimista -->
    <BaseModal :show="showLockedModal" title="Escenario Bloqueado" icon="warning">
      <div class="space-y-4">
        <p class="text-sm text-text">
          La planificación está siendo editada actualmente por <span class="font-bold text-primary">{{ lockedByOtherUser }}</span>.
        </p>
        <p class="text-xs text-text-muted">
          Para evitar conflictos de datos, has ingresado en modo de solo lectura. No podrás modificar ni guardar cambios hasta que el otro usuario termine de trabajar.
        </p>
        <div class="flex justify-end pt-4">
          <button @click="showLockedModal = false" class="px-6 py-2 bg-primary text-white rounded text-xs font-bold uppercase hover:bg-primary-hover">
            Entendido
          </button>
        </div>
      </div>
    </BaseModal>

  </PlanificacionDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch, nextTick, onBeforeUnmount } from 'vue';
import PlanificacionDashboardLayout from '../layouts/PlanificacionDashboardLayout.vue';
import BackButton from '@/components/common/BackButton.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import BaseModal from '@/components/common/BaseModal.vue';
import DatePicker from '@/components/common/DatePicker.vue';
import {
  ChevronDownIcon,
  ShipIcon,
  TrashIcon,
  DraftIcon,
  LayersIcon,
  AlertTriangleIcon,
  WarningIcon,
  PlusIcon,
  XIcon,
  WaveIcon,
  EditIcon,
  UserCircleIcon,
  DownloadIcon
} from '@/icons';
import { toast } from 'vue-sonner';
import * as htmlToImage from 'html-to-image';
import { jsPDF } from 'jspdf';
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';
import disponibilidadApi from '@/modules/admin/services/disponibilidad.service';
import type { DisponibilidadResponse, ObservadorDisponibilidadRow } from '@/modules/admin/interfaces/disponibilidad.interface';
import { getBloqueLabel, getItemVisClass, formatItemTooltip } from '@/modules/shared/utils/timeline-styles';
import catalogosService from '../../mareas/services/catalogos.service';
import { planificacionService } from '../services/planificacion.service';
import { useSimuladorHistory } from '../composables/useSimuladorHistory';
import { useSimuladorLock } from '../composables/useSimuladorLock';

import type { MareaSimuladaItem, EscenarioSimulacionState } from '../interfaces/simulador.interface';
import SimuladorTimeline from '../components/SimuladorTimeline.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';

import { useConfigStore } from '@/modules/shared/stores/config.store';
const configStore = useConfigStore();

const isLoading = ref(false);
const searchQuery = ref('');
const debouncedSearchQuery = ref('');
let searchTimeout: ReturnType<typeof setTimeout>;

watch(searchQuery, (newVal) => {
  clearTimeout(searchTimeout);
  searchTimeout = setTimeout(() => {
    debouncedSearchQuery.value = newVal;
  }, 300);
});

const sidebarOpen = ref(false);
const activeTab = ref<'observador' | 'buque'>('buque');

const timelineObservadorRef = ref<any>(null);
const timelineBuqueRef = ref<any>(null);
const timeScale = ref<'day' | 'month'>('day');

const hasOpenedObservador = ref(activeTab.value === 'observador');
const hasOpenedBuque = ref(activeTab.value === 'buque');

const zoomInTimeline = () => {
  timelineObservadorRef.value?.zoomIn();
  timelineBuqueRef.value?.zoomIn();
};

const zoomOutTimeline = () => {
  timelineObservadorRef.value?.zoomOut();
  timelineBuqueRef.value?.zoomOut();
};

const resetZoomTimeline = () => {
  timelineObservadorRef.value?.resetZoom();
  timelineBuqueRef.value?.resetZoom();
};

watch(activeTab, (newTab) => {
  if (newTab === 'observador') hasOpenedObservador.value = true;
  if (newTab === 'buque') hasOpenedBuque.value = true;

  nextTick(() => {
    if (newTab === 'observador') {
      timelineObservadorRef.value?.redraw();
    } else {
      timelineBuqueRef.value?.redraw();
    }
  });
});

// Estado del Escenario
const listaEscenarios = ref<EscenarioSimulacionState[]>([]);
const selectedEscenarioId = ref<string>('');
const escenarioActual = ref<EscenarioSimulacionState | null>(null);

// Exportación
const isExportModalOpen = ref(false);
const isExporting = ref(false);
const exportForm = ref({
  fechaDesde: '',
  fechaHasta: '',
  soloPlanificadas: true,
  formato: 'EXCEL' as 'EXCEL' | 'PDF' | 'PNG'
});

const abrirModalExportacion = () => {
  if (!escenarioActual.value || !escenarioActual.value.id) {
    toast.error('Debe seleccionar un escenario primero');
    return;
  }
  
  // Por defecto sugerimos los próximos 3 meses
  const ahora = new Date();
  const tresMeses = new Date(ahora.getTime() + 90 * 24 * 60 * 60 * 1000);
  
  exportForm.value.fechaDesde = ahora.toISOString().split('T')[0];
  exportForm.value.fechaHasta = tresMeses.toISOString().split('T')[0];
  exportForm.value.soloPlanificadas = true;
  
  isExportModalOpen.value = true;
};

const procesarExportacion = async () => {
  if (!escenarioActual.value || !escenarioActual.value.id) return;
  if (!exportForm.value.fechaDesde || !exportForm.value.fechaHasta) {
    toast.error('Debe seleccionar el rango de fechas completo');
    return;
  }

  try {
    isExporting.value = true;
    
    if (exportForm.value.formato === 'EXCEL') {
      const blob = await planificacionService.exportarEscenarioAExcel(escenarioActual.value.id, exportForm.value);
      const url = window.URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      link.setAttribute('download', `planificacion_${escenarioActual.value.nombre.replace(/\s+/g, '_')}_${exportForm.value.fechaDesde}_${exportForm.value.fechaHasta}.xlsx`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      window.URL.revokeObjectURL(url);
      toast.success('Archivo Excel descargado exitosamente');
    } else {
      // PDF o PNG (Captura de pantalla del Timeline)
      const tlComponent = activeTab.value === 'buque' ? timelineBuqueRef.value : timelineObservadorRef.value;
      if (!tlComponent) throw new Error('Timeline component no encontrado');
      
      const tlInstance = (tlComponent as any).getTimelineInstance();
      const container = (tlComponent as any).$el as HTMLElement;
      
      if (!tlInstance || !container) throw new Error('No se pudo acceder al canvas del timeline');

      // Guardar vista actual
      const currentWindow = tlInstance.getWindow();
      
      // Ajustar vista a las fechas requeridas
      const fDesde = new Date(exportForm.value.fechaDesde);
      const fHasta = new Date(exportForm.value.fechaHasta);
      fHasta.setHours(23, 59, 59, 999);
      
      tlInstance.setWindow(fDesde, fHasta, { animation: false });
      
      // Esperar a que renderice y redibuje el DOM
      await new Promise(r => setTimeout(r, 600));
      
      const imgData = await htmlToImage.toPng(container, {
        pixelRatio: 2, // Alta resolución
        backgroundColor: '#ffffff'
      });
      
      // Restaurar vista original
      tlInstance.setWindow(currentWindow.start, currentWindow.end, { animation: false });
      
      const filename = `timeline_${activeTab.value}_${exportForm.value.fechaDesde}`;
      
      if (exportForm.value.formato === 'PNG') {
        const link = document.createElement('a');
        link.download = `${filename}.png`;
        link.href = imgData;
        link.click();
        toast.success('Imagen PNG descargada exitosamente');
      } else if (exportForm.value.formato === 'PDF') {
        const pdf = new jsPDF({
          orientation: 'landscape',
          unit: 'mm',
          format: 'legal' // Oficio (216 x 356 mm)
        });
        
        const pdfWidth = 356;
        const pdfHeight = 216;
        const imgProps = pdf.getImageProperties(imgData);
        const ratio = imgProps.width / imgProps.height;
        
        let finalWidth = pdfWidth - 20; // 10mm margenes
        let finalHeight = finalWidth / ratio;
        
        if (finalHeight > (pdfHeight - 20)) {
          finalHeight = pdfHeight - 20;
          finalWidth = finalHeight * ratio;
        }
        
        // Centrar vertical y horizontalmente
        const xOffset = (pdfWidth - finalWidth) / 2;
        const yOffset = (pdfHeight - finalHeight) / 2;
        
        pdf.addImage(imgData, 'PNG', xOffset, yOffset, finalWidth, finalHeight);
        pdf.save(`${filename}.pdf`);
        toast.success('PDF descargado exitosamente');
      }
    }
    
    isExportModalOpen.value = false;
  } catch (error) {
    console.error('Error al exportar escenario:', error);
    toast.error(`Hubo un error al generar la exportación a ${exportForm.value.formato}`);
  } finally {
    isExporting.value = false;
  }
};


const showConfirmChangeScenario = ref(false);

const showLockedModal = ref(false);

const handleLockFailed = (user: string) => {
  showLockedModal.value = true;
};

const { isLockedByMe, lockedByOtherUser, lockTabId, tryAcquireLock, releaseLock } = useSimuladorLock(selectedEscenarioId);

watch(selectedEscenarioId, async (newVal, oldVal) => {
  if (oldVal && oldVal !== 'new') {
    releaseLock(oldVal);
  }
  if (newVal && newVal !== 'new') {
    await tryAcquireLock(handleLockFailed);
  }
}, { immediate: true });



const { 
  canUndo, 
  canRedo, 
  takeSnapshot, 
  undo, 
  redo 
} = useSimuladorHistory(selectedEscenarioId);

const handleUndo = () => {
  if (!escenarioActual.value) return;
  const previous = undo(escenarioActual.value.items, recursosPendientes.value);
  if (previous) {
    escenarioActual.value.items = previous.items;
    recursosPendientes.value = previous.recursosPendientes;
    hasUnsavedChanges.value = true;
    guardarEscenario();
  }
};

const handleRedo = () => {
  if (!escenarioActual.value) return;
  const next = redo(escenarioActual.value.items, recursosPendientes.value);
  if (next) {
    escenarioActual.value.items = next.items;
    recursosPendientes.value = next.recursosPendientes;
    hasUnsavedChanges.value = true;
    guardarEscenario();
  }
};

const showConfirmNoObserver = ref(false);
let pendingNoObserverAction: (() => void) | null = null;

const confirmarSinObservador = () => {
  if (pendingNoObserverAction) {
    pendingNoObserverAction();
    pendingNoObserverAction = null;
  }
  showConfirmNoObserver.value = false;
};

const cancelarSinObservador = () => {
  pendingNoObserverAction = null;
  showConfirmNoObserver.value = false;
};

const showConfirmDeleteScenario = ref(false);
const pendingEscenarioId = ref('');

const handleConfirmChangeScenario = () => {
  showConfirmChangeScenario.value = false;
  selectedEscenarioId.value = pendingEscenarioId.value;
  performScenarioChange();
};

const handleCancelChangeScenario = () => {
  showConfirmChangeScenario.value = false;
  selectedEscenarioId.value = escenarioActual.value?.id || '';
};

const handleConfirmDeleteScenario = async () => {
  showConfirmDeleteScenario.value = false;
  if (!escenarioActual.value) return;
  try {
    await planificacionService.deleteEscenario(escenarioActual.value.id);
    toast.success('Escenario eliminado');
    await cargarEscenarios();
    if (listaEscenarios.value.length > 0) {
      selectedEscenarioId.value = listaEscenarios.value[0].id;
      await performScenarioChange();
    } else {
      escenarioActual.value = null;
      selectedEscenarioId.value = '';
    }
  } catch (error) {
    toast.error('Error al eliminar');
  }
};

const isEscenarioModalOpen = ref(false);
const escenarioModalMode = ref<'create' | 'edit' | 'clone'>('create');
const escenarioForm = ref({
  id: '',
  nombre: '',
  descripcion: '',
});
const hasUnsavedChanges = ref(false);


// Datos de Recursos Pendientes (Simulados / Requerimientos)
export interface RecursoPendiente {
  id: string;
  tipo: 'buque' | 'observador';
  buqueId?: string;
  buqueNombre?: string;
  pesqueriaId?: string;
  pesqueriaNombre?: string;
  observadorId?: string;
  observadorNombre?: string;
  diasEstimados: number;
  prioridad: string;
}

const recursosPendientes = ref<RecursoPendiente[]>([]);

const recursosVisibles = computed(() => {
  return recursosPendientes.value.filter(r => r.tipo === (activeTab.value === 'observador' ? 'buque' : 'observador'));
});

// Catálogos
const loadingCatalogs = ref(true);
const buques = ref<any[]>([]);
const pesquerias = ref<any[]>([]);

const filtroPesqueria = ref<string>('');

const pesqueriasNombresDisponibles = computed(() => {
  return [...new Set(pesquerias.value.map(p => p.nombre))].sort();
});

const buqueOptions = computed(() => {
  return buques.value.map(b => ({
    value: b.id,
    label: `${b.nombreBuque} (${b.matricula})`
  }));
});

const pesqueriaOptions = computed(() => {
  return pesquerias.value.map(p => ({
    value: p.id,
    label: p.nombre
  }));
});

// Datos de Simulación
const isAddBuqueModalOpen = ref(false);
const selectedBuqueToAdd = ref('');
const buquesAdicionales = ref<string[]>([]);

const addBuqueToTimeline = () => {
  if (selectedBuqueToAdd.value && !buquesAdicionales.value.includes(selectedBuqueToAdd.value)) {
    buquesAdicionales.value.push(selectedBuqueToAdd.value);
  }
  isAddBuqueModalOpen.value = false;
  selectedBuqueToAdd.value = '';
};

// Datos de Simulación
const datosSimulacion = ref<DisponibilidadResponse | null>(null);

// Observadores extraídos de los datos de simulación
const observadoresBase = computed(() => {
  if (!datosSimulacion.value) return [];
  return datosSimulacion.value.observadores.map(r => r.observador);
});

// Estado para modales
const isResourceModalOpen = ref(false);
const editingRecursoId = ref<string | null>(null);
const resourceForm = ref<{
  pesqueriaId: string;
  buqueId: string | null;
  observadorId: string | null;
  diasEstimados: number;
  prioridad: string;
}>({
  pesqueriaId: '',
  buqueId: null,
  observadorId: null,
  diasEstimados: 30,
  prioridad: 'MEDIA'
});

const isEditBlockModalOpen = ref(false);
const editingBlockData = ref<MareaSimuladaItem | null>(null);

const blockZarpadaStr = computed({
  get: () => {
    if (!editingBlockData.value?.fechaZarpada) return null;
    return new Date(editingBlockData.value.fechaZarpada).toISOString();
  },
  set: (val: string | null) => {
    if (val && editingBlockData.value) {
      editingBlockData.value.fechaZarpada = val;
      const start = new Date(val);
      
      // Siempre mantenemos la cantidad de días estimados y desplazamos la fecha final
      const end = new Date(start.getTime() + (editingBlockData.value.diasEstimados * 86400000));
      editingBlockData.value.fechaArribo = end;
    }
  }
});

const blockArriboStr = computed({
  get: () => {
    if (!editingBlockData.value?.fechaArribo) return null;
    return new Date(editingBlockData.value.fechaArribo).toISOString();
  },
  set: (val: string | null) => {
    if (val && editingBlockData.value) {
      const start = new Date(editingBlockData.value.fechaZarpada);
      const end = new Date(val);
      
      if (end <= start) {
         toast.error('La fecha final debe ser mayor a la inicial');
         return;
      }
      
      editingBlockData.value.fechaArribo = val;
      const diff = Math.round((end.getTime() - start.getTime()) / 86400000);
      editingBlockData.value.diasEstimados = diff;
    }
  }
});

const onDiasEstimadosChange = () => {
  if (editingBlockData.value && editingBlockData.value.diasEstimados > 0) {
     const start = new Date(editingBlockData.value.fechaZarpada);
     editingBlockData.value.fechaArribo = new Date(start.getTime() + (editingBlockData.value.diasEstimados * 86400000));
  }
};

const onEditBlockBuqueChange = (buqueId: string | null) => {
  if (!editingBlockData.value) return;
  editingBlockData.value.buqueId = buqueId;
  if (buqueId) {
    const buque = buques.value.find(b => b.id === buqueId);
    if (buque && buque.diasMareaEstimada) {
      editingBlockData.value.diasEstimados = buque.diasMareaEstimada;
      if (editingBlockData.value.fechaZarpada) {
        const start = new Date(editingBlockData.value.fechaZarpada);
        editingBlockData.value.fechaArribo = new Date(start.getTime() + (buque.diasMareaEstimada * 86400000));
      }
    }
  }
};

const isCreateBlockModalOpen = ref(false);
const newBlockData = ref<MareaSimuladaItem | null>(null);

const newBlockZarpadaStr = computed({
  get: () => {
    if (!newBlockData.value?.fechaZarpada) return null;
    return new Date(newBlockData.value.fechaZarpada).toISOString();
  },
  set: (val: string | null) => {
    if (val && newBlockData.value) {
      newBlockData.value.fechaZarpada = val;
      const start = new Date(val);
      const end = new Date(start.getTime() + (newBlockData.value.diasEstimados * 86400000));
      newBlockData.value.fechaArribo = end;
    }
  }
});

const newBlockArriboStr = computed({
  get: () => {
    if (!newBlockData.value?.fechaArribo) return null;
    return new Date(newBlockData.value.fechaArribo).toISOString();
  },
  set: (val: string | null) => {
    if (val && newBlockData.value) {
      const start = new Date(newBlockData.value.fechaZarpada);
      const end = new Date(val);
      if (end <= start) {
         toast.error('La fecha final debe ser mayor a la inicial');
         return;
      }
      newBlockData.value.fechaArribo = val;
      const diff = Math.round((end.getTime() - start.getTime()) / 86400000);
      newBlockData.value.diasEstimados = diff;
    }
  }
});

const onNewDiasEstimadosChange = () => {
  if (newBlockData.value && newBlockData.value.diasEstimados > 0) {
     const start = new Date(newBlockData.value.fechaZarpada);
     newBlockData.value.fechaArribo = new Date(start.getTime() + (newBlockData.value.diasEstimados * 86400000));
  }
};

const onNewBlockBuqueChange = (buqueId: string | null) => {
  if (!newBlockData.value) return;
  newBlockData.value.buqueId = buqueId;
  if (buqueId) {
    const buque = buques.value.find(b => b.id === buqueId);
    if (buque && buque.diasMareaEstimada) {
      newBlockData.value.diasEstimados = buque.diasMareaEstimada;
      if (newBlockData.value.fechaZarpada) {
        const start = new Date(newBlockData.value.fechaZarpada);
        newBlockData.value.fechaArribo = new Date(start.getTime() + (buque.diasMareaEstimada * 86400000));
      }
    }
  }
};

const abrirModalCrearBloque = (prefill?: { date?: Date; buqueId?: string; observadorId?: string }) => {
  let today = prefill?.date || new Date();
  today = new Date(today); // create a copy
  today.setHours(0, 0, 0, 0);
  
  const in30Days = new Date(today.getTime() + (30 * 86400000));
  
  newBlockData.value = {
    id: `sim-${Date.now()}`,
    tipoBloque: 'MAREA_SIMULADA',
    buqueId: prefill?.buqueId || null,
    observadorId: prefill?.observadorId || null,
    pesqueriaId: '',
    pesqueriaNombre: '',
    fechaZarpada: today,
    fechaArribo: in30Days,
    diasEstimados: 30,
    estado: 'PENDIENTE',
    prioridad: 'MEDIA'
  };
  
  if (prefill?.buqueId) {
    onNewBlockBuqueChange(prefill.buqueId);
  }
  
  isCreateBlockModalOpen.value = true;
  setTimeout(() => {
    if (prefill?.buqueId && crearObservadorSelectRef.value) {
      crearObservadorSelectRef.value.focus();
    } else {
      crearBuqueSelectRef.value?.focus();
    }
  }, 100);
};

const cerrarModalCrearBloque = () => {
  isCreateBlockModalOpen.value = false;
  newBlockData.value = null;
};

const guardarCreacionBloque = () => {
  if (!newBlockData.value) return;
  
  if (!newBlockData.value.buqueId) {
    toast.error('Debe seleccionar un buque');
    return;
  }

  const processSave = () => {
    const buque = buques.value.find(b => b.id === newBlockData.value?.buqueId);
    if (buque) {
      newBlockData.value!.buqueNombre = buque.nombreBuque;
      newBlockData.value!.pesqueriaId = buque.pesqueriaHabitualId;
      newBlockData.value!.pesqueriaNombre = buque.pesqueriaHabitual?.nombre || '';
      
      // Agregar el buque al timeline si no estaba
      if (!buquesAdicionales.value.includes(buque.id)) {
        buquesAdicionales.value.push(buque.id);
      }
    }

    if (newBlockData.value!.observadorId) {
      const obsData = datosSimulacion.value?.observadores.find(o => o.observador.id === newBlockData.value!.observadorId)?.observador;
      if (obsData) {
        newBlockData.value!.observadorNombre = `${obsData.apellido}, ${obsData.nombre}`;
      }
    } else {
      newBlockData.value!.observadorNombre = undefined;
    }

    const fechaZarpada = new Date(newBlockData.value!.fechaZarpada);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (fechaZarpada < today) {
      toast.error('No se pueden proyectar mareas en fechas pasadas');
      return;
    }

    if (escenarioActual.value) {
      takeSnapshot(escenarioActual.value.items, recursosPendientes.value);
      escenarioActual.value.items.push({ ...newBlockData.value! });
      hasUnsavedChanges.value = true;
      guardarEscenario();
      toast.success('Marea planificada creada correctamente');
    } else {
      toast.error('No hay escenario actual seleccionado');
    }
    
    cerrarModalCrearBloque();
  };

  if (!newBlockData.value.observadorId) {
    pendingNoObserverAction = processSave;
    showConfirmNoObserver.value = true;
  } else {
    processSave();
  }
};

const pesqueriaSelectRef = ref<any>(null);

const buqueSelectRef = ref<any>(null);
const observadorSelectRef = ref<any>(null);

const abrirModalCrearRecurso = () => {
  editingRecursoId.value = null;
  resourceForm.value = {
    pesqueriaId: '',
    buqueId: null,
    observadorId: null,
    diasEstimados: 30,
    prioridad: 'MEDIA'
  };
  isResourceModalOpen.value = true;
  nextTick(() => {
    if (activeTab.value === 'observador') {
      buqueSelectRef.value?.focus();
    } else {
      observadorSelectRef.value?.focus();
    }
  });
};

const abrirModalEditarRecurso = (recurso: RecursoPendiente) => {
  editingRecursoId.value = recurso.id || null;
  resourceForm.value = {
    pesqueriaId: recurso.pesqueriaId || '',
    buqueId: recurso.buqueId || null,
    observadorId: recurso.observadorId || null,
    diasEstimados: recurso.diasEstimados || 30,
    prioridad: recurso.prioridad || 'MEDIA'
  };
  isResourceModalOpen.value = true;
};

const eliminarRecurso = (id: string) => {
  const idx = recursosPendientes.value.findIndex(r => r.id === id);
  if (idx !== -1) {
    recursosPendientes.value.splice(idx, 1);
    toast.success('Recurso eliminado');
  }
};

const cerrarModalRecurso = () => {
  isResourceModalOpen.value = false;
};

const handleBuqueChange = () => {
  const buque = buques.value.find(b => b.id === resourceForm.value.buqueId);
  if (buque) {
    if (buque.pesqueriaHabitualId && !resourceForm.value.pesqueriaId) {
      resourceForm.value.pesqueriaId = buque.pesqueriaHabitualId;
    }
    if (buque.diasMareaEstimada) {
      resourceForm.value.diasEstimados = buque.diasMareaEstimada;
    }
  }
};

const guardarRecurso = () => {
  if (activeTab.value === 'observador') {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (!b) {
      toast.error('Debe seleccionar un buque');
      return;
    }
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          buqueId: b.id,
          buqueNombre: b.nombreBuque,
          pesqueriaId: b.pesqueriaHabitualId,
          pesqueriaNombre: b.pesqueriaHabitual?.nombre,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'buque',
        buqueId: b.id,
        buqueNombre: b.nombreBuque,
        pesqueriaId: b.pesqueriaHabitualId,
        pesqueriaNombre: b.pesqueriaHabitual?.nombre,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
  } else {
    const o = observadoresBase.value.find(x => x.id === resourceForm.value.observadorId);
    if (!o) {
      toast.error('Debe seleccionar un observador');
      return;
    }
    
    if (editingRecursoId.value) {
      const idx = recursosPendientes.value.findIndex(r => r.id === editingRecursoId.value);
      if (idx !== -1) {
        recursosPendientes.value[idx] = {
          ...recursosPendientes.value[idx],
          observadorId: o.id,
          observadorNombre: `${o.apellido}, ${o.nombre}`,
          diasEstimados: resourceForm.value.diasEstimados,
          prioridad: resourceForm.value.prioridad
        };
        toast.success('Recurso actualizado');
      }
    } else {
      recursosPendientes.value.push({
        id: `rec-${Date.now()}`,
        tipo: 'observador',
        observadorId: o.id,
        observadorNombre: `${o.apellido}, ${o.nombre}`,
        diasEstimados: resourceForm.value.diasEstimados,
        prioridad: resourceForm.value.prioridad
      });
      toast.success('Recurso agregado');
    }
  }
  
  cerrarModalRecurso();
};

const cerrarModalEditarBloque = () => {
  isEditBlockModalOpen.value = false;
  editingBlockData.value = null;
};

const guardarEdicionBloque = () => {
  if (!editingBlockData.value) return;
  const idx = escenarioActual.value!.items.findIndex(i => i.id === editingBlockData.value?.id);
  if (idx !== -1) {
    const buque = buques.value.find(b => b.id === editingBlockData.value?.buqueId);
    
    if (buque) {
      editingBlockData.value.buqueNombre = buque.nombreBuque;
      editingBlockData.value.pesqueriaId = buque.pesqueriaHabitualId;
      editingBlockData.value.pesqueriaNombre = buque.pesqueriaHabitual?.nombre || '';
    }

    if (editingBlockData.value.observadorId) {
      const obsData = datosSimulacion.value?.observadores.find(o => o.observador.id === editingBlockData.value!.observadorId)?.observador;
      if (obsData) {
        editingBlockData.value.observadorNombre = `${obsData.apellido}, ${obsData.nombre}`;
      }
    } else {
      editingBlockData.value.observadorNombre = undefined;
    }
    
    // Recalcular la fecha de arribo basada en los nuevos días estimados
    const fechaZarpada = new Date(editingBlockData.value.fechaZarpada);
    const fechaArribo = new Date(fechaZarpada.getTime() + (editingBlockData.value.diasEstimados * 24 * 60 * 60 * 1000));

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    if (fechaZarpada < today) {
      toast.error('No se pueden proyectar mareas en fechas pasadas');
      return;
    }

    editingBlockData.value.fechaArribo = fechaArribo;

    takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);
    escenarioActual.value!.items[idx] = { ...editingBlockData.value };
    hasUnsavedChanges.value = true;
    guardarEscenario();

    toast.success('Marea simulada actualizada');
  }
  cerrarModalEditarBloque();
};

const devolverRecursoPendiente = () => {
  if (!editingBlockData.value) return;
  const idx = escenarioActual.value!.items.findIndex(i => i.id === editingBlockData.value?.id);
  if (idx !== -1) {
    takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);
    const removedItem = escenarioActual.value!.items[idx];
    escenarioActual.value!.items.splice(idx, 1);
    hasUnsavedChanges.value = true;
    guardarEscenario();
    
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      tipo: activeTab.value === 'observador' ? 'buque' : 'observador',
      pesqueriaId: removedItem.pesqueriaId || undefined,
      pesqueriaNombre: removedItem.pesqueriaNombre || undefined,
      buqueId: removedItem.buqueId || undefined,
      buqueNombre: removedItem.buqueNombre || undefined,
      observadorId: removedItem.observadorId || undefined,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA'
    });
    
    toast.success('Marea devuelta a recursos pendientes');
  }
  cerrarModalEditarBloque();
};


// Sidebar state

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value;
};

const selectedTypes = computed({
  get: () => configStore.simuladorSelectedTypes,
  set: (val) => configStore.setSimuladorSelectedTypes(val)
});

const soloMareasPlanificadas = computed({
  get: () => configStore.simuladorSoloPlanificadas,
  set: (val) => configStore.setSimuladorSoloPlanificadas(val)
});

const toggleType = (type: string) => {
  const current = [...selectedTypes.value];
  const index = current.indexOf(type);
  if (index > -1) {
    if (current.length > 1) {
      current.splice(index, 1);
      selectedTypes.value = current;
    }
  } else {
    current.push(type);
    selectedTypes.value = current;
  }
};

const filteredObservadores = computed(() => {
  if (observadoresBase.value.length === 0) return [];
  return observadoresBase.value.filter(o => {
    // Filtrar por tipo
    const rawType = (o.tipoObservador || '').toString().toUpperCase();
    let itemType = 'OBSERVADOR';
    if (rawType.includes('TECNIC')) itemType = 'TECNICO';
    if (!selectedTypes.value.includes(itemType)) return false;

    // Filtrar por texto
    const s = debouncedSearchQuery.value.toLowerCase();
    if (s && !`${o.nombre} ${o.apellido} ${o.codigoInterno}`.toLowerCase().includes(s)) return false;

    // Filtrar por mareas planificadas o activas si está activo
    if (soloMareasPlanificadas.value) {
      let tieneActivaOPlanificada = false;
      if (escenarioActual.value) {
        tieneActivaOPlanificada = escenarioActual.value.items.some(
          sim => sim.tipoBloque === 'MAREA_SIMULADA' && sim.observadorId === o.id
        );
      }
      
      if (!tieneActivaOPlanificada && datosSimulacion.value) {
        const row = datosSimulacion.value.observadores.find(r => r.observador.id === o.id);
        if (row && row.eventos.some(ev => (ev.estado === 'NAVEGANDO' && !ev.isPast) || ev.estado === 'DESIGNADA')) {
          tieneActivaOPlanificada = true;
        }
      }

      if (!tieneActivaOPlanificada) return false;
    }

    return true;
  });
});

// Conflictos detectados en tiempo real
const conflictosDetectados = computed(() => {
  const alertas: { simId: string; mensaje: string }[] = [];
  const simulados = (escenarioActual.value?.items || []).filter(i => i.tipoBloque === 'MAREA_SIMULADA');
  if (simulados.length === 0 || !datosSimulacion.value) return alertas;

  simulados.forEach(sim => {
    const inicio = new Date(sim.fechaZarpada);
    inicio.setHours(0, 0, 0, 0);
    const fin = new Date(sim.fechaArribo);
    fin.setHours(23, 59, 59, 999);

    // 1. Conflictos de Observador
    if (sim.observadorId) {
      // 1.a. Simulada vs Real
      const row = datosSimulacion.value!.observadores.find(r => r.observador.id === sim.observadorId);
      if (row) {
        for (const ev of row.eventos) {
          if (ev.estado === 'DISPONIBLE' || ev.estado === 'DISPONIBLE_NO_CONFIRMADA') continue;
          if (ev.estado === 'NOVEDAD' && ev.flexible) continue;

          const evStart = new Date(ev.startDate + 'T00:00:00');
          const evEnd = new Date(ev.endDate + 'T00:00:00');
          
          if (inicio <= evEnd && fin >= evStart) {
            const obsName = `${row.observador.nombre} ${row.observador.apellido}`;
            const buqueSimName = sim.buqueNombre ? ` (Buque: ${sim.buqueNombre})` : '';
            const buqueEvName = ev.buqueNombre ? ` (Buque: ${ev.buqueNombre})` : '';
            
            alertas.push({
              simId: sim.id,
              mensaje: `[${obsName}] Conflicto: La marea simulada "${sim.pesqueriaNombre}"${buqueSimName} se solapa con [${getBloqueLabel(ev)}]${buqueEvName} del ${evStart.toLocaleDateString('es-AR')} al ${evEnd.toLocaleDateString('es-AR')}.`
            });
          }
        }
      }
      
      // 1.b. Simulada vs Simulada (para el mismo observador)
      for (const otherSim of simulados) {
        if (otherSim.id === sim.id) continue;
        if (otherSim.observadorId === sim.observadorId) {
          const otherStart = new Date(otherSim.fechaZarpada);
          otherStart.setHours(0, 0, 0, 0);
          const otherEnd = new Date(otherSim.fechaArribo);
          otherEnd.setHours(23, 59, 59, 999);
          
          if (inicio <= otherEnd && fin >= otherStart) {
            alertas.push({
              simId: sim.id,
              mensaje: `[Observador: ${sim.observadorNombre || sim.observadorId}] Conflicto: Se solapa con otra marea simulada planificada del ${otherStart.toLocaleDateString('es-AR')} al ${otherEnd.toLocaleDateString('es-AR')}.`
            });
          }
        }
      }
    }

    // 2. Conflictos de Buque (Marea Simulada vs Marea Simulada)
    if (sim.buqueId) {
      for (const otherSim of simulados) {
        if (otherSim.id === sim.id) continue;
        if (otherSim.buqueId === sim.buqueId) {
          const otherStart = new Date(otherSim.fechaZarpada);
          otherStart.setHours(0, 0, 0, 0);
          const otherEnd = new Date(otherSim.fechaArribo);
          otherEnd.setHours(23, 59, 59, 999);
          
          if (inicio <= otherEnd && fin >= otherStart) {
            alertas.push({
              simId: sim.id,
              mensaje: `[Buque: ${sim.buqueNombre}] Conflicto: Se solapa con otra marea simulada del ${otherStart.toLocaleDateString('es-AR')} al ${otherEnd.toLocaleDateString('es-AR')}.`
            });
          }
        }
      }
      
      // 3. Conflictos de Buque (Marea Simulada vs Marea Real)
      datosSimulacion.value!.observadores.forEach(r => {
        r.eventos.forEach(ev => {
          if (ev.buqueId === sim.buqueId && ev.estado !== 'DISPONIBLE' && ev.estado !== 'DISPONIBLE_NO_CONFIRMADA') {
            const evStart = new Date(ev.startDate + 'T00:00:00');
            const evEnd = new Date(ev.endDate + 'T00:00:00');
            if (inicio <= evEnd && fin >= evStart) {
              const obsEvName = `${r.observador.nombre} ${r.observador.apellido}`;
              alertas.push({
                simId: sim.id,
                mensaje: `[Buque: ${sim.buqueNombre}] Conflicto: Se solapa con marea real [${getBloqueLabel(ev)}] de ${obsEvName} del ${evStart.toLocaleDateString('es-AR')} al ${evEnd.toLocaleDateString('es-AR')}.`
              });
            }
          }
        });
      });
    }
  });

  return alertas;
});

const fetchData = async () => {
  isLoading.value = true;
  let dataLoaded = false;
  try {
    // Pedimos 12 meses de disponibilidad para simulación a mediano plazo
    const data = await disponibilidadApi.obtenerDisponibilidad(12);
    datosSimulacion.value = data;
    dataLoaded = true;
  } catch (error) {
    console.error('[SimuladorCobertura] Error al cargar datos:', error);
    toast.error('Ocurrió un error al cargar los datos de planificación');
    datosSimulacion.value = null;
  } finally {
    isLoading.value = false;
  }
};

// Re-renderizar cuando cambien los filtros de búsqueda o el año operativo
// (el render inicial lo hace fetchData() directamente)
watch([filteredObservadores, () => configStore.selectedYear], async () => {
  if (!datosSimulacion.value) return;
});

const timelineObservadorGroups = computed(() => {
  return filteredObservadores.value.map(obs => ({
    id: obs.id,
    content: `<div class="text-text font-bold text-xs">${obs.apellido}, ${obs.nombre}</div>`,
    value: `${obs.apellido}, ${obs.nombre}`
  }));
});

const timelineObservadorItems = computed(() => {
  const items: any[] = [];
  
  if (datosSimulacion.value) {
    filteredObservadores.value.forEach(obs => {
      const row = datosSimulacion.value!.observadores.find(r => r.observador.id === obs.id);
      if (!row) return;

      const nombreObs = `${obs.apellido}, ${obs.nombre}`;
      const eventosUnificados = row.eventos.reduce((acc: any[], curr: any) => {
        const last = acc[acc.length - 1];
        if (last && last.estado === curr.estado && last.codigoCorto === curr.codigoCorto && last.detalle === curr.detalle && last.buqueId === curr.buqueId && last.endDate === curr.startDate) {
          last.endDate = curr.endDate;
        } else {
          acc.push({ ...curr, isPast: false });
        }
        return acc;
      }, []);

      eventosUnificados.forEach(item => {
        let baseClass = getItemVisClass(item);
        if (item.estado === 'DISPONIBLE' || item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
          baseClass += ' opacity-40 hover:opacity-100 transition-opacity duration-200';
        }

        items.push({
          id: `real-${obs.id}-${item.id}`,
          group: obs.id,
          start: new Date(item.startDate + 'T00:00:00'),
          end: new Date(item.endDate + 'T00:00:00'),
          content: getBloqueLabel(item),
          className: baseClass,
          title: formatItemTooltip(item, nombreObs),
          editable: false
        });
      });
    });
  }

  (escenarioActual.value?.items || []).forEach(sim => {
    const duracionSim = Math.round((new Date(sim.fechaArribo).getTime() - new Date(sim.fechaZarpada).getTime()) / 86400000);
    const finInclusivo = new Date(new Date(sim.fechaArribo).getTime() - 86400000);
    const label = sim.buqueNombre || sim.pesqueriaNombre;
    const conflictosDelBloque = conflictosDetectados.value.filter((c: any) => c.simId === sim.id);
    const conflicto = conflictosDelBloque.length > 0;
    
    let contentHtml = '';
    const comentarioHtml = sim.comentario ? `<div class="text-[9px] italic font-normal opacity-75 mt-0.5 truncate max-w-full">${sim.comentario}</div>` : '';
    if (conflicto) {
      contentHtml = `<div class="flex flex-col"><div class="flex items-center gap-1 font-bold"><span class="text-error" style="font-size: 11px;">⚠️</span> ${label} [${duracionSim}d]</div>${comentarioHtml}</div>`;
    } else {
      contentHtml = `<div class="flex flex-col"><div class="flex items-center gap-1 font-bold"><span class="text-[10px]">✨</span> ${label} [${duracionSim}d]</div>${comentarioHtml}</div>`;
    }

    const conflictosHtml = conflicto ? '<br><br><strong class="text-error">Conflictos:</strong><br><span class="text-error">' + conflictosDelBloque.map(c => c.mensaje).join('<br>') + '</span>' : '';
    const tooltipComentario = sim.comentario ? `<br><br><strong>Comentario:</strong><br><em>${sim.comentario}</em>` : '';

    items.push({
      id: sim.id,
      group: sim.observadorId ?? '',
      start: new Date(sim.fechaZarpada),
      end: new Date(sim.fechaArribo),
      content: contentHtml,
      title: `<strong>Inicio:</strong> ${new Date(sim.fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}${tooltipComentario}${conflictosHtml}`,
      className: conflicto ? 'vis-item-simulada-conflicto border-2 border-solid border-error bg-error/20 text-error font-bold shadow-sm' : 'vis-item-simulada border-2 border-dashed border-primary bg-primary/20 text-primary font-bold shadow-sm',
      editable: isLockedByMe.value ? { updateTime: true, updateGroup: true, remove: true } : false
    });
  });

  return items;
});

const timelineBuqueGroups = computed(() => {
  if (!datosSimulacion.value) return [];
  
  const buquesMap = new Map<string, { nombre: string; pesqueria: string }>();
  
  // Extraer buques de mareas reales
  datosSimulacion.value.observadores.forEach(obsRow => {
    obsRow.eventos.forEach(ev => {
      if (ev.buqueId && ev.buqueNombre) {
        const bCatalog = buques.value.find(b => b.id === ev.buqueId);
        const pName = (ev as any).pesqueriaNombre || bCatalog?.pesqueriaHabitual?.nombre || 'Sin pesquería';
        buquesMap.set(ev.buqueId, { nombre: ev.buqueNombre, pesqueria: pName });
      }
    });
  });
  
  // Extraer buques de mareas simuladas
  (escenarioActual.value?.items || []).forEach(sim => {
    if (sim.buqueId && sim.buqueNombre) {
      const bCatalog = buques.value.find(b => b.id === sim.buqueId);
      const pName = sim.pesqueriaNombre || bCatalog?.pesqueriaHabitual?.nombre || 'Sin pesquería';
      buquesMap.set(sim.buqueId, { nombre: sim.buqueNombre, pesqueria: pName });
    }
  });

  // Extraer buques agregados manualmente al timeline
  buquesAdicionales.value.forEach(bId => {
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog && !buquesMap.has(bId)) {
      buquesMap.set(bId, { nombre: bCatalog.nombreBuque || bCatalog.nombre, pesqueria: bCatalog.pesqueriaHabitual?.nombre || 'Sin pesquería' });
    }
  });

  // 1. Preparar grupos hijos (buques)
  let buquesList = Array.from(buquesMap.entries()).map(([id, data]) => ({ id, ...data }));
  
  if (debouncedSearchQuery.value) {
    const sq = debouncedSearchQuery.value.toLowerCase();
    buquesList = buquesList.filter(b => b.nombre.toLowerCase().includes(sq));
  }
  
  if (filtroPesqueria.value) {
    buquesList = buquesList.filter(b => b.pesqueria === filtroPesqueria.value);
  }

  if (soloMareasPlanificadas.value) {
    buquesList = buquesList.filter(b => {
      let tiene = false;
      if (escenarioActual.value) {
        tiene = escenarioActual.value.items.some(sim => sim.tipoBloque === 'MAREA_SIMULADA' && sim.buqueId === b.id);
      }
      if (!tiene && datosSimulacion.value) {
        tiene = datosSimulacion.value.observadores.some(obsRow => 
          obsRow.eventos.some(ev => ev.buqueId === b.id && ((ev.estado === 'NAVEGANDO' && !ev.isPast) || ev.estado === 'DESIGNADA'))
        );
      }
      return tiene;
    });
  }
  
  buquesList.sort((a, b) => a.nombre.localeCompare(b.nombre));

  const pesqueriasUnicas = new Set<string>();
  buquesList.forEach(b => pesqueriasUnicas.add(b.pesqueria));

  const groups: any[] = [];
  const parentGroups: any[] = [];
  const parentIds: string[] = [];

  // 2. Preparar grupos padres (pesquerías)
  Array.from(pesqueriasUnicas).sort().forEach(pName => {
    const parentId = `pesqueria-${pName}`;
    parentIds.push(parentId);
    parentGroups.push({
      id: parentId,
      content: `<div class="font-bold text-primary uppercase text-[10px] tracking-wider py-1">${pName}</div>`,
      nestedGroups: [],
      showNested: true
    });
  });

  // Asignar hijos a padres y agregar hijos al array principal
  buquesList.forEach(b => {
    const parentId = `pesqueria-${b.pesqueria}`;
    const parent = parentGroups.find(g => g.id === parentId);
    if (parent) {
      parent.nestedGroups.push(b.id);
    }
    groups.push({
      id: b.id,
      content: `<div class="text-text font-bold text-xs flex items-center gap-1 pl-2"><span class="text-sm mr-1">⛴</span> ${b.nombre}</div>`,
      value: b.nombre
    });
  });

  // Agregar los padres AL FINAL para que Vis-Timeline encuentre a los hijos ya insertados
  parentGroups.forEach(pg => groups.push(pg));

  return groups;
});

const timelineBuqueItems = computed(() => {
  const items: any[] = [];
  
  if (datosSimulacion.value) {
    datosSimulacion.value.observadores.forEach(row => {
      const nombreObs = `${row.observador.apellido}, ${row.observador.nombre}`;
      
      const eventosUnificados = row.eventos.reduce((acc: any[], curr: any) => {
        const last = acc[acc.length - 1];
        if (last && last.estado === curr.estado && last.codigoCorto === curr.codigoCorto && last.detalle === curr.detalle && last.buqueId === curr.buqueId && last.endDate === curr.startDate) {
          last.endDate = curr.endDate;
        } else {
          acc.push({ ...curr, isPast: false });
        }
        return acc;
      }, []);

      eventosUnificados.forEach(item => {
        if (!item.buqueId) return; // Solo ploteamos mareas con buque
        
        let baseClass = getItemVisClass(item);
        if (item.estado === 'DISPONIBLE' || item.estado === 'DISPONIBLE_NO_CONFIRMADA') {
          baseClass += ' opacity-40 hover:opacity-100 transition-opacity duration-200';
        }

        items.push({
          id: `real-${row.observador.id}-${item.id}`,
          group: item.buqueId,
          start: new Date(item.startDate + 'T00:00:00'),
          end: new Date(item.endDate + 'T00:00:00'),
          content: `<div class="text-[10px] truncate max-w-[120px] font-bold"><span>${nombreObs}</span> <span class="opacity-75 font-normal">(${getBloqueLabel(item)})</span></div>`,
          className: baseClass,
          title: formatItemTooltip(item, nombreObs),
          editable: false
        });
      });
    });
  }

  (escenarioActual.value?.items || []).forEach(sim => {
    if (!sim.buqueId) return;
    
    // Buscar nombre de observador para las simuladas
    let obsNombre = "Sin observador";
    if (sim.observadorId) {
      const obsInfo = datosSimulacion.value?.observadores.find(o => o.observador.id === sim.observadorId)?.observador;
      if (obsInfo) obsNombre = `${obsInfo.apellido}, ${obsInfo.nombre}`;
    }

    const duracionSim = Math.round((new Date(sim.fechaArribo).getTime() - new Date(sim.fechaZarpada).getTime()) / 86400000);
    const finInclusivo = new Date(new Date(sim.fechaArribo).getTime() - 86400000);
    const conflictosDelBloque = conflictosDetectados.value.filter((c: any) => c.simId === sim.id);
    const conflicto = conflictosDelBloque.length > 0;

    let contentHtml = '';
    const comentarioHtml = sim.comentario ? `<div class="text-[9px] italic font-normal opacity-75 mt-0.5 truncate max-w-full">${sim.comentario}</div>` : '';
    if (conflicto) {
      contentHtml = `<div class="flex flex-col"><div class="flex items-center gap-1 font-bold"><span class="text-error" style="font-size: 11px;">⚠️</span><span class="text-[10px] truncate max-w-[120px]">${obsNombre}</span><span class="text-[10px] opacity-75 whitespace-nowrap">[${duracionSim}d]</span></div>${comentarioHtml}</div>`;
    } else {
      contentHtml = `<div class="flex flex-col"><div class="flex items-center gap-1 font-bold"><span class="text-[10px] truncate max-w-[120px]">${obsNombre}</span><span class="text-[10px] opacity-75 whitespace-nowrap">[${duracionSim}d]</span></div>${comentarioHtml}</div>`;
    }

    const conflictosHtml = conflicto ? '<br><br><strong class="text-error">Conflictos:</strong><br><span class="text-error">' + conflictosDelBloque.map(c => c.mensaje).join('<br>') + '</span>' : '';
    const tooltipComentario = sim.comentario ? `<br><br><strong>Comentario:</strong><br><em>${sim.comentario}</em>` : '';

    items.push({
      id: sim.id,
      group: sim.buqueId,
      start: new Date(sim.fechaZarpada),
      end: new Date(sim.fechaArribo),
      content: contentHtml,
      title: `<strong>Inicio:</strong> ${new Date(sim.fechaZarpada).toLocaleDateString('es-AR')}<br><strong>Fin:</strong> ${finInclusivo.toLocaleDateString('es-AR')}${tooltipComentario}${conflictosHtml}`,
      className: conflicto ? 'vis-item-simulada-conflicto border-2 border-solid border-error bg-error/20 text-error font-bold shadow-sm' : 'vis-item-simulada border-2 border-dashed border-primary bg-primary/20 text-primary font-bold shadow-sm',
      editable: isLockedByMe.value ? { updateTime: true, updateGroup: true, remove: true } : false
    });
  });

  return items;
});

const handleItemMoved = (payload: { id: string; start: Date; end: Date; group: string; isReal: boolean }) => {
  if (payload.isReal) {
     return;
  }
  
  const sim = (escenarioActual.value?.items || []).find(i => i.id === payload.id);
  if (sim) {
    takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);
    
    if (activeTab.value === 'observador') {
      sim.observadorId = payload.group;
      const obsData = datosSimulacion.value?.observadores.find(o => o.observador.id === payload.group)?.observador;
      if (obsData) {
        sim.observadorNombre = `${obsData.apellido}, ${obsData.nombre}`;
      }
    } else if (activeTab.value === 'buque') {
      sim.buqueId = payload.group;
      const bCatalog = buques.value.find(b => b.id === payload.group);
      if (bCatalog) {
        sim.buqueNombre = bCatalog.nombreBuque;
        sim.pesqueriaId = bCatalog.pesqueriaHabitualId;
        sim.pesqueriaNombre = bCatalog.pesqueriaHabitual?.nombre;
      }
    }
    
    sim.fechaZarpada = payload.start;
    sim.fechaArribo = payload.end;
    hasUnsavedChanges.value = true;
    guardarEscenario();
  }
};

const handleItemRemoved = (id: string) => {
  const idx = escenarioActual.value!.items.findIndex(i => i.id === id);
  if (idx !== -1) {
    takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);
    const removedItem = escenarioActual.value!.items[idx];
    escenarioActual.value!.items.splice(idx, 1);
    hasUnsavedChanges.value = true;
    guardarEscenario();
    
    recursosPendientes.value.push({
      id: `rec-returned-${Date.now()}`,
      tipo: activeTab.value === 'observador' ? 'buque' : 'observador',
      pesqueriaId: removedItem.pesqueriaId || undefined,
      pesqueriaNombre: removedItem.pesqueriaNombre || undefined,
      buqueId: removedItem.buqueId || undefined,
      buqueNombre: removedItem.buqueNombre || undefined,
      observadorId: removedItem.observadorId || undefined,
      diasEstimados: removedItem.diasEstimados,
      prioridad: removedItem.prioridad || 'MEDIA'
    });
    
    toast.success('Marea simulada eliminada y devuelta a recursos');
  }
};

const handleDropRecurso = (payload: { recurso: any; group: string; date: Date }) => {
  const recursoArrastrado = payload.recurso;
  let fechaInicio = payload.date;
  
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  if (fechaInicio < today) {
    fechaInicio = today;
  }

  const fechaFin = new Date(fechaInicio.getTime() + recursoArrastrado.diasEstimados * 24 * 60 * 60 * 1000);

  let obsId = undefined;
  let bId = recursoArrastrado.buqueId;
  let bNombre = recursoArrastrado.buqueNombre;
  let pId = recursoArrastrado.pesqueriaId;
  let pNombre = recursoArrastrado.pesqueriaNombre;
  
  if (activeTab.value === 'observador') {
    obsId = payload.group;
  } else {
    // payload.group es el buqueId
    bId = payload.group;
    obsId = recursoArrastrado.observadorId || undefined;
    // Rellenar pesqueria si el buque existe en catalogo
    const bCatalog = buques.value.find(b => b.id === bId);
    if (bCatalog) {
       bNombre = bCatalog.nombreBuque;
       pId = bCatalog.pesqueriaHabitualId;
       pNombre = bCatalog.pesqueriaHabitual?.nombre;
    }
  }

  const processDrop = () => {
    const nuevoItemSimulado: MareaSimuladaItem = {
      id: `sim-${Date.now()}`,
      tipoBloque: 'MAREA_SIMULADA',
      pesqueriaId: pId,
      pesqueriaNombre: pNombre,
      buqueId: bId,
      buqueNombre: bNombre,
      observadorId: obsId,
      fechaZarpada: fechaInicio,
      fechaArribo: fechaFin,
      diasEstimados: recursoArrastrado.diasEstimados,
      estado: 'PENDIENTE',
      prioridad: recursoArrastrado.prioridad || 'MEDIA'
    };

    takeSnapshot(escenarioActual.value!.items, recursosPendientes.value);
    escenarioActual.value!.items.push(nuevoItemSimulado);
    hasUnsavedChanges.value = true;
    guardarEscenario();

    // Remover del sidebar pendiente
    const idxRec = recursosPendientes.value.findIndex(r => r.id === recursoArrastrado.id);
    if (idxRec !== -1) {
      recursosPendientes.value.splice(idxRec, 1);
      if (recursosPendientes.value.length === 0) {
        sidebarOpen.value = false;
      }
    }

    toast.success('Marea simulada asignada');
  };

  if (!obsId) {
    pendingNoObserverAction = processDrop;
    showConfirmNoObserver.value = true;
  } else {
    processDrop();
  }
};

const editBuqueSelectRef = ref<any>(null);
const crearBuqueSelectRef = ref<any>(null);
const crearObservadorSelectRef = ref<any>(null);

const handleEditItem = (id: string) => {
  const sim = (escenarioActual.value?.items || []).find(i => i.id === id);
  if (sim) {
    editingBlockData.value = { ...sim };
    isEditBlockModalOpen.value = true;
    setTimeout(() => {
      editBuqueSelectRef.value?.focus();
    }, 100);
  }
};

// Drag & Drop HTML5 desde Sidebar a Timeline (inicio)
let draggedRecurso: RecursoPendiente | null = null;

const onDragStartRecurso = (event: DragEvent, recurso: RecursoPendiente) => {
  draggedRecurso = recurso;
  if (event.dataTransfer) {
    event.dataTransfer.effectAllowed = 'copy';
    // Enviamos tipo='buque' u observador no importa, usamos 'buque' genérico
    const dropData = {
      type: 'buque', // Para que lo atrape el SimuladorTimeline
      ...recurso
    };
    event.dataTransfer.setData('application/json', JSON.stringify(dropData));
    event.dataTransfer.setData('text/plain', recurso.id);
  }
};

// Lógica de Escenarios
const cargarEscenarios = async () => {
  try {
    listaEscenarios.value = await planificacionService.getEscenariosPorAnio(configStore.selectedYear);
    if (listaEscenarios.value.length > 0 && !selectedEscenarioId.value) {
      // Intentar cargar el último usado o el primero si no hay
      const lastId = configStore.lastScenarioId;
      if (lastId && listaEscenarios.value.some(e => e.id === lastId)) {
        selectedEscenarioId.value = lastId;
      } else {
        selectedEscenarioId.value = listaEscenarios.value[0].id;
      }
      await onEscenarioChange();
    }
  } catch (error) {
    console.error(error);
    toast.error('Error al cargar escenarios');
  }
};

const nombreEscenarioInput = ref<HTMLInputElement | null>(null);

const onEscenarioChange = async () => {
  await performScenarioChange();
};

const performScenarioChange = async () => {
  if (selectedEscenarioId.value === 'new') {
    escenarioModalMode.value = 'create';
    escenarioForm.value = { 
      id: '', 
      nombre: `Escenario ${listaEscenarios.value.length + 1}`, 
      descripcion: '' 
    };
    isEscenarioModalOpen.value = true;
    selectedEscenarioId.value = escenarioActual.value?.id || '';
    nextTick(() => {
      nombreEscenarioInput.value?.focus();
    });
    return;
  }
  try {
    isLoading.value = true;
    const esc = await planificacionService.getEscenario(selectedEscenarioId.value);
    escenarioActual.value = esc;
    configStore.setLastScenarioId(selectedEscenarioId.value);
    hasUnsavedChanges.value = false;
  } catch (error) {
    toast.error('Error al cargar escenario');
  } finally {
    isLoading.value = false;
  }
};

const abrirModalEditarEscenario = () => {
  if (!escenarioActual.value) return;
  escenarioModalMode.value = 'edit';
  escenarioForm.value = {
    id: escenarioActual.value.id,
    nombre: escenarioActual.value.nombre,
    descripcion: escenarioActual.value.descripcion || ''
  };
  isEscenarioModalOpen.value = true;
  nextTick(() => {
    nombreEscenarioInput.value?.focus();
  });
};

const handleAddMarea = (payload: { date: Date, group: string }, mode: 'observador' | 'buque') => {
  if (String(payload.group).startsWith('pesqueria-')) {
    return;
  }
  
  abrirModalCrearBloque({
    date: payload.date,
    buqueId: mode === 'buque' ? payload.group : undefined,
    observadorId: mode === 'observador' ? payload.group : undefined
  });
};

const clonarEscenario = async () => {
  if (!escenarioActual.value) return;
  escenarioModalMode.value = 'clone';
  escenarioForm.value = {
    id: '',
    nombre: escenarioActual.value.nombre + ' (Copia)',
    descripcion: escenarioActual.value.descripcion || ''
  };
  isEscenarioModalOpen.value = true;
  nextTick(() => {
    nombreEscenarioInput.value?.focus();
  });
};

const eliminarEscenario = () => {
  if (!escenarioActual.value) return;
  showConfirmDeleteScenario.value = true;
};

const guardarModalEscenario = async () => {
  try {
    if (escenarioModalMode.value === 'edit') {
      await planificacionService.updateEscenario(escenarioForm.value.id, {
        nombre: escenarioForm.value.nombre,
        descripcion: escenarioForm.value.descripcion
      });
      toast.success('Escenario actualizado');
    } else if (escenarioModalMode.value === 'clone' && escenarioActual.value) {
      const clon = await planificacionService.cloneEscenario(escenarioActual.value.id, {
        nombre: escenarioForm.value.nombre,
        descripcion: escenarioForm.value.descripcion
      });
      toast.success('Escenario clonado');
      selectedEscenarioId.value = clon.id;
    } else {
      const nuevo = await planificacionService.createEscenario({
        nombre: escenarioForm.value.nombre,
        descripcion: escenarioForm.value.descripcion,
        anioOperativo: configStore.selectedYear,
        items: []
      });
      toast.success('Escenario creado');
      selectedEscenarioId.value = nuevo.id;
    }
    isEscenarioModalOpen.value = false;
    await cargarEscenarios();
    if (!escenarioForm.value.id && selectedEscenarioId.value) {
      await onEscenarioChange();
    }
  } catch (error) {
    toast.error('Error al guardar escenario');
  }
};

const guardarEscenario = async () => {
  if (!escenarioActual.value) return;
  try {
    await planificacionService.updateEscenario(escenarioActual.value.id, {
      items: escenarioActual.value.items
    });
    // Autoguardado silencioso para no interferir con la UI, hasUnsavedChanges pasa a false
    hasUnsavedChanges.value = false;
  } catch(error) {
    toast.error('Error al guardar cambios en el escenario');
  }
};

onMounted(async () => {
  try {
    const [b, p] = await Promise.all([
      catalogosService.getBuques(),
      catalogosService.getPesquerias()
    ]);
    buques.value = b;
    pesquerias.value = p;
  } catch (e) {
    console.error('Error fetching catalogs:', e);
    toast.error('Ocurrió un error al cargar catálogos.');
  } finally {
    loadingCatalogs.value = false;
  }
  
  await cargarEscenarios();
  fetchData();
  
  window.addEventListener('keydown', handleGlobalKeydown);
});

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleGlobalKeydown);
});

const handleGlobalKeydown = (e: KeyboardEvent) => {
  if (['INPUT', 'TEXTAREA'].includes((e.target as HTMLElement).tagName)) return;
  if (e.ctrlKey || e.metaKey) {
    if (e.key === 'z') {
      if (e.shiftKey) {
        if (canRedo.value) handleRedo();
      } else {
        if (canUndo.value) handleUndo();
      }
      e.preventDefault();
    }
    if (e.key === 'y') {
      if (canRedo.value) handleRedo();
      e.preventDefault();
    }
  }
};


const isResourceFormValid = computed(() => {
  if (activeTab.value === 'observador') return !!resourceForm.value.buqueId;
  return true; // Ya no es obligatorio el observador
});

const onBuqueResourceChange = () => {
  if (resourceForm.value.buqueId) {
    const b = buques.value.find(x => x.id === resourceForm.value.buqueId);
    if (b && b.diasMareaEstimada) {
      resourceForm.value.diasEstimados = b.diasMareaEstimada;
    }
  }
};

const observadorOptions = computed(() => 
  observadoresBase.value.map(o => ({
    value: o.id,
    label: `${o.apellido}, ${o.nombre}`
  }))
);

</script>

<style scoped>
:deep(.vis-item) {
  border-radius: 6px;
  box-shadow: inset 0 0 0 1px rgba(0,0,0,0.1);
}

:deep(.vis-item-simulada) {
  border: 2px dashed var(--color-primary, #0284c7) !important;
  background-color: rgba(2, 132, 199, 0.15) !important;
  color: var(--color-primary, #0284c7) !important;
  font-weight: bold !important;
}

:deep(.vis-item-simulada-conflicto) {
  border: 2px solid var(--color-error, #ef4444) !important;
  background-color: rgba(239, 68, 68, 0.15) !important;
  color: var(--color-error, #ef4444) !important;
  font-weight: bold !important;
}

:deep(.vis-item-content) {
  padding: 3px 5px !important;
  width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: 11px !important;
  font-weight: 500 !important;
  box-sizing: border-box !important;
  line-height: 1.2 !important;
  display: block !important;
}

:deep(.vis-label) {
  font-size: 12px !important;
}

:deep(.vis-label .vis-inner) {
  padding: 6px 4px !important;
}

:deep(.vis-label .vis-inner div) {
  font-size: 12px !important;
  line-height: 1.2 !important;
}

:deep(.vis-time-axis .vis-text) {
  font-weight: 500;
  color: var(--color-text-muted, #374151) !important;
  font-size: 11px !important;
}

:deep(.vis-panel.vis-background),
:deep(.vis-panel.vis-bottom),
:deep(.vis-panel.vis-center),
:deep(.vis-panel.vis-left),
:deep(.vis-panel.vis-right),
:deep(.vis-panel.vis-top) {
  border-color: var(--color-border, #e5e7eb) !important;
}

:deep(.vis-time-axis .vis-grid.vis-minor),
:deep(.vis-time-axis .vis-grid.vis-major) {
  border-color: var(--color-border, #e5e7eb) !important;
}
</style>

<style scoped>

.simulador-timeline {
  overflow: hidden;
}

:deep(.vis-timeline) {
  border: none !important;
  font-family: inherit;
}

:deep(.vis-panel.vis-background),
:deep(.vis-panel.vis-bottom),
:deep(.vis-panel.vis-center),
:deep(.vis-panel.vis-left),
:deep(.vis-panel.vis-right),
:deep(.vis-panel.vis-top) {
  border-color: var(--color-border, #e5e7eb) !important;
}

:deep(.vis-time-axis .vis-grid.vis-minor),
:deep(.vis-time-axis .vis-grid.vis-major) {
  border-color: var(--color-border, #e5e7eb) !important;
}

:deep(.vis-labelset .vis-label) {
  border-color: var(--color-border, #e5e7eb) !important;
  color: var(--color-text) !important;
  font-size: 13px !important;
}

:deep(.vis-label .vis-inner) {
  padding: 8px 6px !important;
}

:deep(.vis-time-axis .vis-text) {
  font-weight: 500;
  color: var(--color-text-muted, #374151) !important;
}

:deep(.vis-time-axis .vis-text.vis-saturday),
:deep(.vis-time-axis .vis-text.vis-sunday) {
  color: #ef4444 !important;
  font-weight: bold !important;
}

/* Eventos pasados atenuados */
:deep(.vis-item-attenuated) {
  opacity: 0.35 !important;
  filter: grayscale(0.7) !important;
}

/* ESTILOS DE BLOQUES EN VIS-TIMELINE - MODO CLARO */
.legend-disponible, :global(.simulador-timeline .vis-item-disponible) {
  background-color: #facc15 !important; /* Amarillo vibrante */
  color: #713f12 !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.simulador-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(250, 204, 21, 0.22) !important; /* Mismo color pero atenuado */
  color: #854d0e !important;
  border-color: #eab308 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

.legend-navegando, :global(.simulador-timeline .vis-item-navegando) {
  background-color: #22c55e !important;
  color: white !important;
  border-color: #16a34a !important;
  border-width: 2px !important;
  border-style: solid !important;
}

:global(.simulador-timeline .vis-item-navegando-proyectada) {
  background-color: #dcfce7 !important; /* Verde atenuado */
  color: #15803d !important;            /* Texto verde */
  border-color: #22c55e !important;     /* Borde verde */
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado para proyectados */
  font-weight: 800 !important;
}

.legend-naveg-viaje, :global(.simulador-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #16a34a 50%, #4338ca 50%) !important;
  color: white !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-designada, :global(.simulador-timeline .vis-item-designada) {
  background-color: #cffafe !important;
  color: #0e7490 !important;
  border-color: #67e8f9 !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

:global(.simulador-timeline .vis-item-warning-doc) {
  background-image: repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(245, 158, 11, 0.15) 10px, rgba(245, 158, 11, 0.15) 20px) !important;
  border-color: #f59e0b !important;
}

.legend-novedad, :global(.simulador-timeline .vis-item-novedad) {
  background-color: #e0f2fe !important;
  color: #0369a1 !important;
  border-color: #7dd3fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

:global(.simulador-timeline .vis-item-no-disponible) {
  background-color: #fee2e2 !important; /* Rojo suave */
  color: #991b1b !important;            /* Texto contrastado */
  border-color: #fca5a5 !important;     /* Borde rojo suave */
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.simulador-timeline .vis-item-no-disponible-proyectada) {
  background-color: #fff1f2 !important; /* Rojo más claro/atenuado */
  color: #9f1239 !important;
  border-color: #f43f5e !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado para proyectados */
  font-weight: 700 !important;
}

.legend-puerto, :global(.simulador-timeline .vis-item-puerto) {
  background-color: #ffedd5 !important;
  color: #c2410c !important;
  border-color: #fdba74 !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-viaje, :global(.simulador-timeline .vis-item-viaje) {
  background-color: #e0e7ff !important;
  color: #4338ca !important;
  border-color: #a5b4fc !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-ez, :global(.simulador-timeline .vis-item-ez) {
  background-color: #f3f4f6 !important;
  color: #374151 !important;
  border-color: #d1d5db !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-impedido, :global(.simulador-timeline .vis-item-impedido) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

.legend-conflicto, :global(.simulador-timeline .vis-item-conflicto) {
  background-color: #ef4444 !important;
  color: white !important;
  border-color: #b91c1c !important;
  border-width: 2px !important;
  border-style: solid !important;
}

/* Eventos flexibles (borde punteado y efecto) */
.legend-flexible, :global(.simulador-timeline .vis-item-flexible) {
  border-style: dashed !important;
  border-width: 2px !important;
  border-color: #f59e0b !important;
  background-color: #fef3c7 !important;
  color: #92400e !important;
}

/* ESTILOS EN MODO OSCURO */
:global(.dark) .legend-disponible, :global(.dark .simulador-timeline .vis-item-disponible) {
  background-color: #ca8a04 !important;
  color: #fef08a !important;
  border-color: #a16207 !important;
}

:global(.dark .simulador-timeline .vis-item-disponible-no-confirmada) {
  background-color: rgba(202, 138, 4, 0.22) !important; /* Atenuado */
  color: #fef08a !important;
  border-color: #ca8a04 !important;
  border-width: 2px !important;
  border-style: dashed !important; /* Borde punteado */
  font-weight: 800 !important;
}

:global(.dark) .legend-navegando, :global(.dark .simulador-timeline .vis-item-navegando) {
  background-color: #15803d !important;
  color: white !important;
  border-color: #166534 !important;
}

:global(.dark .simulador-timeline .vis-item-navegando-proyectada) {
  background-color: rgba(34, 197, 94, 0.2) !important; /* Verde atenuado */
  color: #86efac !important;
  border-color: #22c55e !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado */
  font-weight: 800 !important;
}

:global(.dark) .legend-designada, :global(.dark .simulador-timeline .vis-item-designada) {
  background-color: rgba(6, 182, 212, 0.15) !important;
  color: #67e8f9 !important;
  border-color: #06b6d4 !important;
  border-width: 2px !important;
  border-style: dashed !important;
}

:global(.dark .simulador-timeline .vis-item-warning-doc) {
  background-image: repeating-linear-gradient(45deg, transparent, transparent 10px, rgba(251, 191, 36, 0.15) 10px, rgba(251, 191, 36, 0.15) 20px) !important;
  border-color: rgba(251, 191, 36, 0.8) !important;
}

:global(.dark) .legend-naveg-viaje, :global(.dark .simulador-timeline .vis-item-naveg-viaje) {
  background: linear-gradient(135deg, #15803d 50%, rgba(79, 70, 229, 0.4) 50%) !important;
  color: white !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-novedad, :global(.dark .simulador-timeline .vis-item-novedad) {
  background-color: rgba(14, 165, 233, 0.25) !important;
  color: #bae6fd !important;
  border-color: rgba(14, 165, 233, 0.5) !important;
}

:global(.dark .simulador-timeline .vis-item-no-disponible) {
  background-color: rgba(239, 68, 68, 0.22) !important; /* Rojo suave en oscuro */
  color: #fecaca !important;
  border-color: rgba(239, 68, 68, 0.5) !important;
  border-width: 2px !important;
  border-style: solid !important;
  font-weight: 800 !important;
}

:global(.dark .simulador-timeline .vis-item-no-disponible-proyectada) {
  background-color: rgba(244, 63, 94, 0.12) !important; /* Atenuado */
  color: #fecdd3 !important;
  border-color: rgba(244, 63, 94, 0.6) !important;
  border-width: 2px !important;
  border-style: dashed !important;     /* Borde punteado */
  font-weight: 700 !important;
}

:global(.dark) .legend-puerto, :global(.dark .simulador-timeline .vis-item-puerto) {
  background-color: rgba(234, 88, 12, 0.25) !important;
  color: #ffedd5 !important;
  border-color: rgba(234, 88, 12, 0.5) !important;
}

:global(.dark) .legend-viaje, :global(.dark .simulador-timeline .vis-item-viaje) {
  background-color: rgba(79, 70, 229, 0.25) !important;
  color: #e0e7ff !important;
  border-color: rgba(79, 70, 229, 0.5) !important;
}

:global(.dark) .legend-ez, :global(.dark .simulador-timeline .vis-item-ez) {
  background-color: #374151 !important;
  color: #e5e7eb !important;
  border-color: #4b5563 !important;
}

:global(.dark) .legend-impedido, :global(.dark .simulador-timeline .vis-item-impedido) {
  background-color: #991b1b !important;
  color: white !important;
  border-color: #7f1d1d !important;
}

:global(.dark) .legend-flexible, :global(.dark .simulador-timeline .vis-item-flexible) {
  border-color: #f59e0b !important;
  background-color: rgba(245, 158, 11, 0.2) !important;
  color: #fef3c7 !important;
}

:global(.simulador-timeline .vis-item-content) {
  padding: 4px 6px !important;
  width: 100% !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  font-size: 11px !important;
  font-weight: 700 !important;
  box-sizing: border-box !important;
  line-height: 1.2 !important;
  display: block !important;
}

:global(.vis-tooltip) {
  background-color: #111827 !important;
  color: #ffffff !important;
  font-size: 12px !important;
  font-family: inherit !important;
  padding: 10px !important;
  border-radius: 6px !important;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.2) !important;
  border: none !important;
  z-index: 1000 !important;
  pointer-events: none !important;
  white-space: normal !important;
  max-width: 280px !important;
}

:global(.dark .vis-tooltip) {
  background-color: #1f2937 !important;
  border: 1px solid #374151 !important;
  color: #f3f4f6 !important;
}


:global(.simulador-timeline .vis-item-simulada) {
  background-color: rgba(59, 130, 246, 0.15) !important;
  border-color: #3b82f6 !important;
  color: #1d4ed8 !important;
  border-width: 2px !important;
  border-style: dashed !important;
  font-weight: 800 !important;
}
:global(.dark .simulador-timeline .vis-item-simulada) {
  background-color: rgba(59, 130, 246, 0.15) !important;
  border-color: #3b82f6 !important;
  color: #93c5fd !important;
}

</style>
