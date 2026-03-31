<template>
  <AdminLayout title="Bandeja de Entrada"
    description="Gestión de tareas pendientes, alertas de sistema y seguimiento de procesos.">
    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10 flex flex-col xl:flex-row gap-8 items-start">
      <div class="flex-1 min-w-0 w-full">

        <!-- 1. ALERTAS URGENTES (Urgente) -->
        <section v-if="alertasUrgente.misAlertas.length > 0 || alertasUrgente.disponibles.length > 0"
          class="mb-8 space-y-4">
          <button @click="toggleAlertSection('urgente')"
            class="flex items-center justify-between w-full px-2 group cursor-pointer">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-error flex items-center gap-2">
              <span class="flex h-3 w-3 relative">
                <span
                  class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/60 opacity-75"></span>
                <span
                  class="relative inline-flex rounded-full h-3 w-3 bg-error shadow-[0_0_10px_rgba(244,63,94,0.5)]"></span>
              </span>
              Atención Inmediata (Prioridad Urgente)
            </h2>
            <ChevronDownIcon class="w-4 h-4 text-error transition-transform duration-300"
              :class="{ 'rotate-180': !expandedAlerts.urgente }" />
          </button>
          <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
            <div v-if="expandedAlerts.urgente" class="space-y-6">
              <!-- Mis Alertas -->
              <div v-if="alertasUrgente.misAlertas.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">Mis
                  Alertas</label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasUrgente.misAlertas" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>

              <!-- Alertas Disponibles -->
              <div v-if="alertasUrgente.disponibles.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">
                  {{ isAdminOrCoordinator ? 'Alertas Disponibles / De otros' : 'Alertas Disponibles / Sin asignar' }}
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasUrgente.disponibles" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>
            </div>
          </Transition>
        </section>

        <!-- 2. ALERTAS CRÍTICAS (Alta) -->
        <section v-if="alertasAlta.misAlertas.length > 0 || alertasAlta.disponibles.length > 0" class="mb-8 space-y-4">
          <button @click="toggleAlertSection('alta')"
            class="flex items-center justify-between w-full px-2 group cursor-pointer">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-warning flex items-center gap-2">
              <span class="flex h-2 w-2 relative">
                <span class="relative inline-flex rounded-full h-2 w-2 bg-warning"></span>
              </span>
              Gestión Prioritaria (Prioridad Alta)
            </h2>
            <ChevronDownIcon class="w-4 h-4 text-warning transition-transform duration-300"
              :class="{ 'rotate-180': !expandedAlerts.alta }" />
          </button>
          <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
            <div v-if="expandedAlerts.alta" class="space-y-6">
              <!-- Mis Alertas -->
              <div v-if="alertasAlta.misAlertas.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">Mis
                  Alertas</label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasAlta.misAlertas" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>

              <!-- Alertas Disponibles -->
              <div v-if="alertasAlta.disponibles.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">
                  {{ isAdminOrCoordinator ? 'Alertas Disponibles / De otros' : 'Alertas Disponibles / Sin asignar' }}
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasAlta.disponibles" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>
            </div>
          </Transition>
        </section>

        <!-- 3. ALERTAS RECOMENDADAS (Media) -->
        <section v-if="alertasMedia.misAlertas.length > 0 || alertasMedia.disponibles.length > 0"
          class="mb-8 space-y-4">
          <button @click="toggleAlertSection('media')"
            class="flex items-center justify-between w-full px-2 group cursor-pointer">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-info flex items-center gap-2">
              <span class="flex h-2 w-2 relative">
                <span class="relative inline-flex rounded-full h-2 w-2 bg-info"></span>
              </span>
              Atención Recomendada (Prioridad Media)
            </h2>
            <ChevronDownIcon class="w-4 h-4 text-info transition-transform duration-300"
              :class="{ 'rotate-180': !expandedAlerts.media }" />
          </button>
          <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
            <div v-if="expandedAlerts.media" class="space-y-6">
              <!-- Mis Alertas -->
              <div v-if="alertasMedia.misAlertas.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">Mis
                  Alertas</label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasMedia.misAlertas" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>

              <!-- Alertas Disponibles -->
              <div v-if="alertasMedia.disponibles.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">
                  {{ isAdminOrCoordinator ? 'Alertas Disponibles / De otros' : 'Alertas Disponibles / Sin asignar' }}
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasMedia.disponibles" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>
            </div>
          </Transition>
        </section>

        <!-- 4. ALERTAS INFORMATIVAS (Baja) -->
        <section v-if="alertasBaja.misAlertas.length > 0 || alertasBaja.disponibles.length > 0" class="mb-8 space-y-4">
          <button @click="toggleAlertSection('baja')"
            class="flex items-center justify-between w-full px-2 group cursor-pointer">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-purple flex items-center gap-2">
              <span class="flex h-2 w-2 relative">
                <span class="relative inline-flex rounded-full h-2 w-2 bg-purple"></span>
              </span>
              Notificaciones (Prioridad Baja)
            </h2>
            <ChevronDownIcon class="w-4 h-4 text-purple transition-transform duration-300"
              :class="{ 'rotate-180': !expandedAlerts.baja }" />
          </button>
          <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
            <div v-if="expandedAlerts.baja" class="space-y-6">
              <!-- Mis Alertas -->
              <div v-if="alertasBaja.misAlertas.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">Mis
                  Alertas</label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasBaja.misAlertas" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>

              <!-- Alertas Disponibles -->
              <div v-if="alertasBaja.disponibles.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">
                  {{ isAdminOrCoordinator ? 'Alertas Disponibles / De otros' : 'Alertas Disponibles / Sin asignar' }}
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasBaja.disponibles" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>
            </div>
          </Transition>
        </section>

        <!-- 1b. HEADER: ALERTAS EN SEGUIMIENTO -->
        <section v-if="alertasSeguimiento.misAlertas.length > 0 || alertasSeguimiento.disponibles.length > 0"
          class="mb-8 space-y-4">
          <button @click="toggleAlertSection('seguimiento')"
            class="flex items-center justify-between w-full px-2 group cursor-pointer">
            <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-warning flex items-center gap-2">
              <div class="p-1 bg-warning/10 rounded">
                <BellIcon class="w-3 h-3" />
              </div>
              Alertas en Seguimiento
            </h2>
            <ChevronDownIcon class="w-4 h-4 text-warning transition-transform duration-300"
              :class="{ 'rotate-180': !expandedAlerts.seguimiento }" />
          </button>
          <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
            <div v-if="expandedAlerts.seguimiento" class="space-y-6">
              <!-- Mis Alertas -->
              <div v-if="alertasSeguimiento.misAlertas.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">Mis
                  Alertas</label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasSeguimiento.misAlertas" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" :estado="AlertaEstado.SEGUIMIENTO"
                    @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>

              <!-- Alertas Disponibles -->
              <div v-if="alertasSeguimiento.disponibles.length > 0" class="space-y-3">
                <label class="text-[9px] font-black uppercase tracking-widest text-text-muted/60 ml-2">
                  {{ isAdminOrCoordinator ? 'Alertas Disponibles / De otros' : 'Alertas Disponibles / Sin asignar' }}
                </label>
                <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
                  <InboxAlertCard v-for="alerta in alertasSeguimiento.disponibles" :key="alerta.id" v-bind="alerta"
                    :fecha="formatDate(alerta.fechaDetectada)" :estado="AlertaEstado.SEGUIMIENTO"
                    @action="(type) => handleAlertAction(alerta.id, type)" />
                </div>
              </div>
            </div>
          </Transition>
        </section>

        <!-- 2. TABS & FILTERS -->
        <div class="sticky top-0 z-20 bg-background/80 backdrop-blur-md py-4 mb-6 -mx-2 px-2 border-b border-border">
          <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
            <!-- Premium Tabs -->
            <div class="flex p-1 bg-surface-muted border border-border rounded-2xl w-fit shadow-sm">
              <button v-for="tab in tabs" :key="tab.id" @click="activeTab = tab.id"
                class="relative px-6 py-2 text-xs font-black uppercase tracking-tight transition-all duration-300 rounded-xl overflow-hidden"
                :class="activeTab === tab.id ? 'text-primary-fg' : 'text-text-muted hover:text-text'">
                <div v-if="activeTab === tab.id" class="absolute inset-0 bg-primary transition-all duration-300"></div>
                <span class="relative z-10 flex items-center gap-2">
                  {{ tab.label }}
                  <Badge variant="solid" size="sm" class="font-extrabold h-4 px-1.5"
                    :color="activeTab === tab.id ? 'light' : 'primary'"
                    :style="activeTab === tab.id ? 'background-color: rgba(255,255,255,0.2)' : ''">
                    {{ tab.count }}
                  </Badge>
                </span>
              </button>
            </div>

            <!-- Search & Sort -->
            <div class="flex items-center gap-3">
              <SearchInput v-model="searchQuery" placeholder="Buscar por buque, marea, observador..." class="w-full sm:w-96" />
              <button @click="sortBy = sortBy === 'buque' ? 'observador' : 'buque'"
                class="p-2.5 bg-background border border-border rounded-xl text-text-muted hover:text-text transition-all shadow-sm flex items-center gap-2"
                :title="`Ordenar por: ${sortBy === 'buque' ? 'Buque' : 'Observador'}`">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2">
                  <path d="m3 16 4 4 4-4" />
                  <path d="M7 20V4" />
                  <path d="m21 8-4-4-4 4" />
                  <path d="M17 4v16" />
                </svg>
                <span class="text-[10px] font-black uppercase tracking-tighter">{{ sortBy }}</span>
              </button>
            </div>
          </div>
        </div>

        <!-- 3. TASK GRID -->
        <div v-if="loading" class="flex items-center justify-center py-20">
          <div class="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
        </div>

        <transition-group v-else name="list" tag="div" class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6">
          <TaskCard v-for="task in filteredTasks" :key="task.id" v-bind="task" :show-observer="true"
            :compact="!!selectedMarea" @click="openDetails(task)" @action="(key) => handleTaskAction(task.id, key)" />
        </transition-group>

        <!-- 4. HISTORIAL DE GESTIÓN (Nueva Sección Inferior) -->
        <section class="mt-16 pt-12 border-t border-border/50 space-y-8">
          <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 px-2">
            <div>
              <h2 class="text-sm font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
                <DocsIcon class="w-4 h-4" />
                Historial de Gestión
              </h2>
              <p class="text-[10px] font-bold text-text-muted/60 uppercase tracking-tighter mt-1">Registros de mareas
                concluidas y alertas resueltas</p>
            </div>

            <div class="w-full md:w-96">
              <SearchInput v-model="historySearchQuery" placeholder="Buscar en el historial..." class="w-full sm:w-96" />
            </div>
          </div>

          <div class="space-y-6">
            <!-- Collapsible: Alertas Cerradas -->
            <div class="rounded-3xl border border-border bg-background shadow-sm overflow-hidden">
              <button @click="toggleHistorialSection('alertas')"
                class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
                :class="{ 'border-border bg-surface-muted/30': expandedHistorialSection === 'alertas' }">
                <div class="flex items-center gap-3">
                  <div class="p-2 bg-success/10 rounded-xl">
                    <BellIcon class="w-5 h-5 text-success" />
                  </div>
                  <div>
                    <h4 class="text-sm font-black text-text/90 uppercase tracking-tight flex items-center gap-2">
                      Alertas Cerradas
                      <Badge variant="light" size="sm" class="font-black px-1.5 h-4">
                        {{ filteredHistoryAlerts.length }}
                      </Badge>
                    </h4>
                  </div>
                </div>
                <svg xmlns="http://www.w3.org/2000/svg"
                  class="w-5 h-5 text-text-muted transition-transform duration-300"
                  :class="{ 'rotate-180': expandedHistorialSection === 'alertas' }" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </button>

              <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
                enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
                leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
                <div v-if="expandedHistorialSection === 'alertas'" class="p-5 pt-2">
                  <div v-if="filteredHistoryAlerts.length > 0"
                    class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6">
                    <InboxAlertCard v-for="alert in filteredHistoryAlerts" :key="alert.id" :titulo="alert.titulo"
                      :descripcion="alert.descripcion" :fecha="formatDate(alert.fechaCierre || alert.fechaDetectada)"
                      :estado="alert.estado" :notaGestion="alert.notaGestion"
                      @action="(type) => handleAlertAction(alert.id, type)" />
                  </div>
                  <div v-else
                    class="text-center py-6 bg-surface-muted/30 rounded-2xl border border-dashed border-border text-xs text-text-muted">
                    Sin registros que coincidan con la búsqueda.
                  </div>
                </div>
              </Transition>
            </div>

            <!-- Collapsible: Historial de Mareas -->
            <div class="rounded-3xl border border-border bg-background shadow-sm overflow-hidden">
              <button @click="toggleHistorialSection('mareas')"
                class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
                :class="{ 'border-border bg-surface-muted/30': expandedHistorialSection === 'mareas' }">
                <div class="flex items-center gap-3">
                  <div class="p-2.5 bg-surface-muted rounded-2xl border border-border">
                    <DocsIcon class="w-5 h-5 text-text-muted" />
                  </div>
                  <div>
                    <h4 class="text-sm font-black text-text/80 uppercase tracking-tight flex items-center gap-2">
                      Historial de Mareas
                      <Badge variant="light" size="sm" class="font-black px-1.5 h-4">
                        {{ filteredHistoryTasks.length }}
                      </Badge>
                    </h4>
                  </div>
                </div>
                <svg xmlns="http://www.w3.org/2000/svg"
                  class="w-5 h-5 text-text-muted transition-transform duration-300"
                  :class="{ 'rotate-180': expandedHistorialSection === 'mareas' }" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polyline points="6 9 12 15 18 9" />
                </svg>
              </button>

              <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
                enter-to-class="max-h-[2000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
                leave-from-class="max-h-[2000px] opacity-100" leave-to-class="max-h-0 opacity-0">
                <div v-if="expandedHistorialSection === 'mareas'" class="p-5 pt-2">
                  <div v-if="filteredHistoryTasks.length > 0"
                    class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6">
                    <TaskCard v-for="task in filteredHistoryTasks" :key="task.id" v-bind="task" :show-observer="true"
                      :compact="!!selectedMarea" @click="openDetails(task)"
                      @action="(key) => handleTaskAction(task.id, key)" />
                  </div>
                  <div v-else
                    class="text-center py-6 bg-surface-muted/30 rounded-2xl border border-dashed border-border text-xs text-text-muted">
                    Sin registros que coincidan con la búsqueda.
                  </div>
                </div>
              </Transition>
            </div>
          </div>
        </section>

      </div>

      <!-- PANEL DE DETALLE LATERAL (Sustituye al sidebar en esta vista) -->
      <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="translate-x-4 opacity-0"
        enter-to-class="translate-x-0 opacity-100" leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-x-0 opacity-100" leave-to-class="translate-x-4 opacity-0">
        <div v-if="selectedMarea"
          class="w-full xl:w-[400px] shrink-0 sticky top-6 bg-surface border border-border rounded-[2.5rem] shadow-xl overflow-hidden self-start hidden xl:block">
          <MareaContextDetailContent :marea="selectedMarea" :context="selectedMareaContext"
            @close="selectedMarea = null" @open-detalle="goToDetalle" @action="executeSidebarAction" @manage-alert="handleAlertAction" />
        </div>
      </Transition>
    </div>

    <!-- ALERT MANAGEMENT DIALOG -->
    <AlertManagementDialog :is-open="isAlertDialogOpen" :alert="selectedAlert" @close="isAlertDialogOpen = false"
      @refresh="loadInbox" />

    <!-- RECIBIR ARCHIVOS DIALOG -->
    <RecibirArchivosDialog :show="showRecibirDialog" :marea="mareaToManage" @close="handleRecibirCancel"
      @confirm="handleRecibirConfirm" />

    <GestionEtapasMareaDialog v-if="mareaToManage" :show="showGestionDialog" :mode="gestionMode" :marea="mareaToManage"
      :currentStages="mareaToManage?.etapas || []" :initialPortId="mareaToManage?.puertoBaseId"
      @close="handleGestionCancel" @confirm="handleGestionConfirm" />

    <MareaGenericActionDialog :show="showGenericDialog" :marea="mareaToManage" :actionKey="selectedActionKey"
      :actionData="selectedActionData" :loading="executingAction" @close="showGenericDialog = false"
      @confirm="handleGenericConfirm" />

    <FinalizarProtocolizacionDialog
      :show="showProtocolizacionDialog"
      :marea="mareaToManage"
      :loading="executingAction"
      @close="showProtocolizacionDialog = false"
      @confirm="handleProtocolizacionConfirm"
    />
      
    <EditMareaDesignadaDialog 
      v-if="selectedMarea"
      :show="showEditDesignadaDialog" 
      :initial-data="selectedMareaContext?.marea || selectedMarea" 
      :marea-id="selectedMarea.id"
      @close="showEditDesignadaDialog = false" 
      @success="handleEditSuccess" 
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, markRaw } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import TaskCard from '../components/TaskCard.vue'
import InboxAlertCard from '../components/InboxAlertCard.vue'
import MareaContextDetailContent from '../components/MareaContextDetailContent.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
import MareaGenericActionDialog from '../components/MareaGenericActionDialog.vue'
import FinalizarProtocolizacionDialog from '../components/FinalizarProtocolizacionDialog.vue'
import EditMareaDesignadaDialog from '../components/EditMareaDesignadaDialog.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import mareasService from '../services/mareas.service'
import { alertsService } from '@/modules/alerts/services/alerts.service'
import { EditIcon, CheckIcon, DocsIcon, BellIcon, ChevronDownIcon } from '@/icons'
import { useMareas } from '../composables/useMareas'
import { toast } from 'vue-sonner'
import { AlertaEstado, AlertaPrioridad } from '../../alerts/services/alerts.service'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const router = useRouter()
const authStore = useAuthStore()
const { fetchMareaContext, selectedMareaContext, executeAction } = useMareas()

const isReadOnly = computed(() => {
  const roles = authStore.user?.roles || []
  return !roles.includes(ValidRoles.admin) && !roles.includes(ValidRoles.tecnico)
})

// Data State
const loading = ref(true)
const alertas = ref<any[]>([])
const alertasHistoricas = ref<any[]>([])
const tasks = ref<any[]>([])
const activeTab = ref('urgentes')
const searchQuery = ref('')
const historySearchQuery = ref('')
const sortBy = ref<'buque' | 'observador'>('buque')

const expandedAlerts = ref({
  urgente: true,
  alta: true,
  media: true,
  baja: true,
  seguimiento: true
})

const toggleAlertSection = (section: keyof typeof expandedAlerts.value) => {
  expandedAlerts.value[section] = !expandedAlerts.value[section]
}

// 1. Computed properties
const tareasUrgentes = computed(() => tasks.value.filter(t => t.tab === 'urgentes'))
const tareasPendientes = computed(() => tasks.value.filter(t => t.tab === 'pendientes'))

// Nuevas subdivisiones de alertas activas por prioridad y asignación
const isAdminOrCoordinator = computed(() => {
  const roles = authStore.user?.roles || []
  return roles.includes(ValidRoles.admin) || roles.includes(ValidRoles.coordinador)
})

const alertasPendientesTotal = computed(() => alertas.value.filter(a => [AlertaEstado.PENDIENTE, AlertaEstado.VENCIDA].includes(a.estado)))

const getAlertsByPriority = (prioridad: AlertaPrioridad) => {
  const filtradas = alertasPendientesTotal.value.filter(a => a.prioridad === prioridad)
  const userId = authStore.user?.id

  // Si no hay ID de usuario (aún cargando o no auth), no hay "Mis Alertas"
  const misAlertas = userId
    ? filtradas.filter(a => a.asignadoId === userId)
    : []

  const disponibles = filtradas.filter(a => {
    if (isAdminOrCoordinator.value) {
      // Admins y coordinadores ven todo lo que NO es suyo
      // Si no hay userId, ven todo
      return !userId || a.asignadoId !== userId
    }
    // Usuarios regulares solo ven lo que NO está asignado
    return !a.asignadoId
  })

  return { misAlertas, disponibles }
}

const alertasUrgente = computed(() => getAlertsByPriority(AlertaPrioridad.URGENTE))
const alertasAlta = computed(() => getAlertsByPriority(AlertaPrioridad.ALTA))
const alertasMedia = computed(() => getAlertsByPriority(AlertaPrioridad.MEDIA))
const alertasBaja = computed(() => getAlertsByPriority(AlertaPrioridad.BAJA))

const alertasSeguimiento = computed(() => {
  const filtradas = alertas.value.filter(a => a.estado === AlertaEstado.SEGUIMIENTO)
  const userId = authStore.user?.id

  return {
    misAlertas: userId ? filtradas.filter(a => a.asignadoId === userId) : [],
    disponibles: filtradas.filter(a => {
      if (isAdminOrCoordinator.value) {
        return !userId || a.asignadoId !== userId
      }
      return !a.asignadoId
    })
  }
})

const tabs = computed(() => [
  { id: 'urgentes', label: 'Acciones Urgentes', count: tareasUrgentes.value?.length || 0 },
  { id: 'pendientes', label: 'Pendientes', count: tareasPendientes.value?.length || 0 },
  { id: 'proceso', label: 'En Proceso', count: 0 },
])

const activeTabLabel = computed(() => tabs.value.find(t => t.id === activeTab.value)?.label)

const filteredTasks = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  let result = tasks.value.filter(t => t.tab === activeTab.value)

  if (query) {
    result = result.filter(task => {
      const values = [
        task.buque,
        task.idMarea,
        task.observador,
        task.hito,
        task.estadoDescripcion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  // Sort
  return result.sort((a, b) => {
    if (sortBy.value === 'buque') {
      return a.buque.localeCompare(b.buque)
    } else {
      return (a.observador || '').localeCompare(b.observador || '')
    }
  })
})

const filteredHistoryTasks = computed(() => {
  const query = historySearchQuery.value.trim().toLowerCase()
  let result = tasks.value.filter(t => t.tab === 'historial')

  if (query) {
    result = result.filter(task => {
      const values = [
        task.buque,
        task.idMarea,
        task.observador,
        task.hito,
        task.estadoDescripcion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  return result.sort((a, b) => a.buque.localeCompare(b.buque))
})

const filteredHistoryAlerts = computed(() => {
  const query = historySearchQuery.value.trim().toLowerCase()
  let result = alertasHistoricas.value

  if (query) {
    result = result.filter(alert => {
      const values = [
        alert.titulo,
        alert.descripcion,
        alert.notaGestion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  return result
})

const formatDate = (dateStr?: string) => {
  if (!dateStr) return 'N/A'
  return new Date(dateStr).toLocaleDateString('es-AR', {
    day: '2-digit', month: '2-digit', year: 'numeric'
  })
}

const resolveActions = (task: any) => {
  if (task.tab === 'urgentes') {
    return [
      { label: 'Corregir', key: 'edit', icon: markRaw(EditIcon), primary: true },
      { label: 'Revisar', key: 'review', icon: markRaw(DocsIcon) }
    ]
  }
  if (task.tab === 'pendientes') {
    return [
      { label: 'Gestionar', key: 'manage', icon: markRaw(CheckIcon), primary: true },
      { label: 'Ver Detalle', key: 'view', icon: markRaw(DocsIcon) }
    ]
  }
  return [
    { label: 'Ver Detalle', key: 'view', icon: markRaw(DocsIcon) }
  ]
}

const loadInbox = async () => {
  try {
    loading.value = true
    const data = await mareasService.getInbox()
    alertas.value = data.alerts || []
    tasks.value = (data.tasks || []).map(t => ({
      ...t,
      actions: resolveActions(t)
    }))
  } catch (error) {
    console.error('Error loading inbox:', error)
    toast.error('Error al actualizar la bandeja de entrada')
  } finally {
    loading.value = false
  }

  // Load historic alerts independently — does not block the task grid
  loadHistoricalAlerts()
}

const loadHistoricalAlerts = async () => {
  try {
    const allAlerts = await alertsService.getAll({ status: `${AlertaEstado.RESUELTA},${AlertaEstado.DESCARTADA}` }) || []
    alertasHistoricas.value = allAlerts.sort((a, b) => {
      const dateA = new Date(a.fechaCierre || a.fechaDetectada || 0).getTime()
      const dateB = new Date(b.fechaCierre || b.fechaDetectada || 0).getTime()
      return dateB - dateA
    })
  } catch (error) {
    console.error('Error loading historical alerts:', error)
  }
}

onMounted(loadInbox)

// UI Actions
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)
const showGestionDialog = ref(false)
const showRecibirDialog = ref(false)
const showCancelarDialog = ref(false)
const showGenericDialog = ref(false)
const showProtocolizacionDialog = ref(false)
const selectedActionKey = ref<string | null>(null)
const selectedActionData = ref<any>(null)
const executingAction = ref(false)
const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)

const expandedHistorialSection = ref<'alertas' | 'mareas' | null>(null)

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const openDetails = async (task: any) => {
  if (window.innerWidth < 1280) {
    router.push({ name: 'MareaOperativaDetalle', params: { id: task.id } })
    return
  }
  selectedMarea.value = { id: task.id, id_marea: task.idMarea, buque_nombre: task.buque }
  await fetchMareaContext(task.id)
}

const handleTaskAction = (taskId: string, actionKey: string) => {
  if (actionKey === 'edit' || actionKey === 'manage' || actionKey === 'view') {
    router.push({ name: 'MareaDetalle', params: { id: taskId } })
  }
}

const handleAlertAction = (alertId: string | object, type?: string) => {
  const alert = typeof alertId === 'object'
    ? alertId
    : (alertas.value.find(a => a.id === alertId) || alertasHistoricas.value.find(a => a.id === alertId))

  if (alert) {
    selectedAlert.value = null
    setTimeout(() => {
      selectedAlert.value = alert as any
      isAlertDialogOpen.value = true
    }, 0)
  }
}

const executeSidebarAction = async (key: string) => {
  if (!selectedMarea.value) return

  if (key === 'REGISTRAR_INICIO') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    gestionMode.value = 'INICIAR'
    showGestionDialog.value = true
    return
  }

  if (key === 'EDITAR_ETAPAS') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    gestionMode.value = 'EDITAR'
    showGestionDialog.value = true
    return
  }

  if (key === 'REGISTRAR_FINALIZACION') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    gestionMode.value = 'FINALIZAR'
    showGestionDialog.value = true
    return
  }

  if (key === 'RECIBIR_DATOS') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    showRecibirDialog.value = true
    return
  }

  if (key === 'FINALIZAR_PROTOCOLIZACION') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    showProtocolizacionDialog.value = true
    return
  }

  // Si la acción tiene metadatos en el contexto y no es una de las especiales, usar diálogo genérico
  const actionMetadata = selectedMareaContext.value?.actions[key]
  if (actionMetadata) {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    selectedActionKey.value = key
    selectedActionData.value = actionMetadata
    showGenericDialog.value = true
    return
  }

  try {
    executingAction.value = true
    await executeAction(selectedMarea.value.id, key)
    await loadInbox()
  } catch (err) {
    console.error('Action failed:', err)
  } finally {
    executingAction.value = false
  }
}

const handleGenericConfirm = async (payload: any) => {
  if (!mareaToManage.value || !selectedActionKey.value) return

  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, selectedActionKey.value, payload)
    showGenericDialog.value = false
    mareaToManage.value = null
    selectedActionKey.value = null
    selectedActionData.value = null
    await loadInbox()
  } catch (err) {
    console.error("Error en acción de marea:", err)
  } finally {
    executingAction.value = false
  }
}

const handleProtocolizacionConfirm = async (payload: any) => {
  if (!mareaToManage.value) return

  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, 'FINALIZAR_PROTOCOLIZACION', payload)
    showProtocolizacionDialog.value = false
    mareaToManage.value = null
    selectedMarea.value = null
    await loadInbox()
  } catch (err) {
    console.error("Error en protocolización de marea:", err)
  } finally {
    executingAction.value = false
  }
}

const showEditDesignadaDialog = ref(false)

const goToDetalle = () => {
  if (selectedMarea.value) {
    if (selectedMareaContext.value?.marea?.estado_codigo === 'DESIGNADA' && !isReadOnly.value) {
      showEditDesignadaDialog.value = true
    } else {
      router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
    }
  }
}

const handleEditSuccess = async () => {
  showEditDesignadaDialog.value = false
  if (selectedMarea.value) {
    await fetchMareaContext(selectedMarea.value.id)
  }
  await loadInbox()
}

const handleRecibirCancel = () => {
  showRecibirDialog.value = false
}



const handleRecibirConfirm = async (payload: any) => {
  try {
    await executeAction(mareaToManage.value.id, 'RECIBIR_DATOS', payload)
    showRecibirDialog.value = false
    mareaToManage.value = null
    selectedMarea.value = null
    await loadInbox()
  } catch (err) {
    console.error("Error en recepción de archivos:", err)
  }
}

const handleGestionCancel = () => {
  showGestionDialog.value = false
  mareaToManage.value = null
  selectedMarea.value = null
}

const handleGestionConfirm = async (payload: any) => {
  try {
    const actionKey = gestionMode.value === 'INICIAR'
      ? 'REGISTRAR_INICIO'
      : gestionMode.value === 'FINALIZAR'
        ? 'REGISTRAR_FINALIZACION'
        : 'EDITAR_ETAPAS';

    await executeAction(mareaToManage.value.id, actionKey, payload)
    showGestionDialog.value = false
    mareaToManage.value = null
    selectedMarea.value = null
    await loadInbox()
  } catch (err) {
    console.error("Error en gestión de marea:", err)
  }
}

const toggleHistorialSection = (section: 'alertas' | 'mareas') => {
  expandedHistorialSection.value = expandedHistorialSection.value === section ? null : section
}
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}

.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
