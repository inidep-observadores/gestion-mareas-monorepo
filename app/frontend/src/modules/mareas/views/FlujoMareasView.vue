<template>
  <AdminLayout title="Flujo Operativo" description="Seguimiento detallado de mareas por estado del proceso.">
    <div class="relative min-h-[calc(100vh-100px)] z-1">

      <div class="flex flex-wrap items-center gap-2 mb-6">
        <span class="text-[10px] font-black uppercase tracking-widest text-text-muted mr-2">
          Mostrar grupos:
        </span>
        <div class="flex flex-wrap items-center gap-2">
          <StatusFilterChip v-for="kpi in kpis" :key="kpi.label" v-show="kpi.value > 0" :label="kpi.label"
            :value="kpi.value" :icon="kpi.icon" :active="!collapsedGroups.has(kpi.codigo)" :color-class="kpi.color"
            :bg-class="kpi.bg" :border-class="kpi.border" @click="toggleGroupCollapse(kpi.codigo)"
            class="scale-90 origin-left" />
        </div>

        <div class="flex items-center gap-2 ml-2 pl-4 border-l border-border/50">
          <button
            @click="selectAllGroups"
            class="text-[10px] font-black uppercase tracking-tight text-primary hover:text-primary-hover transition-all px-2 py-1 rounded-lg hover:bg-primary/5 active:scale-95"
          >
            Marcar todo
          </button>
          <button
            @click="deselectAllGroups"
            class="text-[10px] font-black uppercase tracking-tight text-text-muted hover:text-text transition-all px-2 py-1 rounded-lg hover:bg-surface-muted/50 active:scale-95"
          >
            Desmarcar todo
          </button>
        </div>
      </div>

      <div class="flex flex-col xl:flex-row gap-6 items-start">
        <!-- Main Board -->
        <div class="flex-1 min-w-0 transition-all duration-300">
          <div class="bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
            <div
              class="py-3 px-5 border-b border-border flex flex-col sm:flex-row items-center justify-between gap-4 bg-surface-muted/30">
              <h2 class="font-black text-text flex items-center gap-2">
                <div class="w-2 h-2 rounded-full bg-primary animate-pulse"></div>
                Flujo de Mareas
              </h2>
              <div class="flex flex-wrap items-center gap-3 w-full sm:w-auto">
                <div class="flex items-center gap-2 bg-surface border border-border rounded-xl px-3 py-1.5 focus-within:ring-2 focus-within:ring-primary/20 transition-all shadow-sm group">
                  <span class="text-text-muted group-focus-within:text-primary transition-colors">
                    <ShipIcon class="w-3.5 h-3.5" />
                  </span>
                  <select v-model="filterPesqueria"
                    class="bg-transparent border-none outline-none text-sm font-bold text-text-muted focus:text-text transition-colors cursor-pointer min-w-[140px] appearance-none pr-4">
                    <option value="" class="bg-surface text-text">Todas las pesquerías</option>
                    <option v-for="pesqueria in availablePesquerias" :key="pesqueria" :value="pesqueria" class="bg-surface text-text">
                      {{ pesqueria }}
                    </option>
                  </select>
                </div>
                <SearchInput v-model="searchQuery" class="md:w-96" placeholder="Buscar buque o marea..." />
                <ExportExcelButton
                  :loading="exporting"
                  :label="searchQuery ? 'Filtradas' : 'Excel'"
                  :title="searchQuery ? 'Exportar mareas filtradas' : 'Exportar todas las mareas del año'"
                  @click="handleExport"
                />
                <button v-if="!isReadOnly" @click="router.push('/mareas/nueva')"
                  class="flex items-center justify-center gap-2 px-4 py-2 bg-primary text-primary-fg rounded-xl text-sm font-bold hover:bg-primary-hover transition-all shadow-lg shadow-primary/20 active:scale-95">
                  <PlusIcon class="w-4 h-4" />
                  Nueva Marea
                </button>
              </div>
            </div>

            <div class="flex-1 overflow-y-auto custom-scrollbar">
              <!-- Loading State -->
              <div v-if="loading" class="flex items-center justify-center h-full py-20 flex-col">
                <LoadingSpinner size="xl" class="text-primary" />
                <span class="mt-4 text-text-muted font-bold">Cargando flujo operativo...</span>
              </div>

              <!-- Content -->
              <template v-else-if="hasMareas">

                <!-- VISTA MÓVIL: TARJETAS AGRUPADAS -->
                <div class="xl:hidden p-4 space-y-6">
                  <div v-for="group in groupedMareas" :key="group.code" v-show="group.items.length > 0"
                    class="space-y-3">
                    <!-- Group Header Mobile -->
                    <div @click="toggleGroupCollapse(group.code)"
                      class="flex items-center justify-between gap-2 px-1 cursor-pointer">
                      <div class="flex items-center gap-2">
                        <span class="text-xs font-black uppercase tracking-widest text-text-muted">{{ group.label
                        }}</span>
                        <span class="px-2 py-0.5 bg-surface-muted rounded-full text-[10px] font-bold text-text">{{
                          group.items.length }}</span>
                      </div>
                      <ChevronDownIcon class="w-4 h-4 text-text-muted transition-transform duration-300"
                        :class="{ 'rotate-180': !group.expanded }" />
                    </div>

                    <!-- Cards Grid -->
                    <div v-show="group.expanded" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                      <div v-for="marea in group.items" :key="marea.id" @click="openSidebar(marea)"
                        class="bg-surface border border-border rounded-2xl p-4 shadow-sm active:scale-[0.98] transition-all hover:border-primary/50">
                        <!-- Header Tarjeta -->
                        <div class="flex justify-between items-start mb-3">
                          <span
                            class="text-[10px] font-mono font-black text-text-muted/60 uppercase tracking-widest bg-surface-muted px-2 py-0.5 rounded">
                            {{ marea.id_marea }}
                          </span>
                          <div class="flex flex-col items-end gap-1">
                            <div class="flex items-center gap-1">
                              <span class="px-2 py-0.5 rounded-full text-[9px] font-black uppercase tracking-tighter"
                                :class="getStatusClasses(marea.estado_codigo)">
                                {{ marea.estado }}
                              </span>
                              <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'"
                                class="px-2 py-0.5 bg-surface-muted text-text-muted rounded-full text-[9px] font-black uppercase tracking-tighter border border-border">
                                Etapa {{ marea.total_etapas }}
                              </span>
                            </div>
                            <span v-if="marea.en_tierra"
                              class="px-2 py-0.5 bg-success/10 text-success rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap border border-success/20">
                              En Tierra
                            </span>
                          </div>
                        </div>

                        <!-- Datos Principales -->
                        <div class="mb-3">
                          <div class="flex items-center gap-2 mb-1">
                            <ShipIcon class="w-3.5 h-3.5 text-primary" />
                            <h4 class="text-sm font-black text-text">{{ marea.buque_nombre }}</h4>
                          </div>
                          <div class="flex flex-col gap-0.5 ml-5">
                            <p class="text-[10px] font-black text-text-muted uppercase tracking-tight">
                              {{ marea.pesquerias_nombres.join(' / ') || 'Sin pesquería' }}
                            </p>
                            <p class="text-[9px] font-bold text-text-muted/70 italic leading-none">
                              {{ marea.flota }}
                            </p>
                          </div>
                          <p class="text-xs font-bold text-text-muted truncate mt-1 ml-5">{{ marea.observador || 'No asignado' }}
                          </p>
                        </div>

                        <!-- Fechas (Zarpada / Arribo) en móvil -->
                        <div
                          class="grid grid-cols-2 gap-2 mb-3 bg-surface-muted/30 p-2 rounded-xl border border-border/50">
                          <div>
                            <span
                              class="text-[8px] font-black text-text-muted uppercase tracking-widest block mb-0.5">Zarpada</span>
                            <span class="text-[10px] font-bold text-text">{{ formatDate(marea.fecha_zarpada) }}</span>
                          </div>
                          <div>
                            <span
                              class="text-[8px] font-black text-text-muted uppercase tracking-widest block mb-0.5">Últ.
                              Arribo</span>
                            <div v-if="marea.fecha_arribo" class="flex flex-wrap items-center gap-1.5 mt-0.5">
                              <span class="text-[10px] font-bold text-text">{{ formatDate(marea.fecha_arribo) }}</span>
                              <span v-if="marea.en_tierra"
                                class="px-2 py-0.5 bg-warning/10 text-warning rounded-full text-[10px] font-black uppercase tracking-tighter border border-warning/20 whitespace-nowrap">
                                Esperando zarpada
                              </span>
                            </div>
                            <div v-else-if="marea.estado_codigo === 'EN_EJECUCION'" class="flex items-center gap-1.5 flex-wrap">
                              <span class="text-[10px] font-black text-primary italic">Navegando...</span>
                              <span v-if="marea.en_prospeccion"
                                class="px-2 py-0.5 bg-purple-500/10 text-purple-600 rounded-full text-[8px] font-black uppercase tracking-tighter whitespace-nowrap border border-purple-500/20">
                                Prospección
                              </span>
                            </div>
                            <span v-else class="text-[10px] font-bold text-text-muted/40 italic">N/D</span>
                          </div>
                        </div>

                        <!-- Info Operativa -->
                        <div class="flex items-center justify-between gap-4 pt-3 border-t border-border">
                          <div class="flex-1 flex flex-col gap-1">
                            <div class="flex justify-between items-center">
                              <span
                                class="text-[9px] font-bold text-text-muted uppercase tracking-widest">Progreso</span>
                              <span class="text-[10px] font-black"
                                :class="marea.progreso > 100 ? 'text-error' : 'text-primary'">{{ marea.progreso
                                }}%</span>
                            </div>
                            <div class="h-1.5 w-full bg-surface-muted rounded-full overflow-hidden">
                              <div class="h-full transition-all duration-1000"
                                :class="marea.progreso > 100 ? 'bg-error' : 'bg-primary'"
                                :style="{ width: Math.min(marea.progreso, 100) + '%' }"></div>
                            </div>
                            <div class="flex justify-between items-center">
                              <span class="text-[8px] font-bold text-text-muted/70 uppercase tracking-tight">Días transcurridos</span>
                              <span class="text-[9px] font-bold" :class="marea.progreso > 100 ? 'text-error' : 'text-text-muted'">{{ marea.dias_marea || 0 }} / {{ marea.dias_estimados || 30 }}</span>
                            </div>
                          </div>

                          <div v-if="marea.alertas?.length"
                            class="flex items-center gap-1.5 px-2 py-1 bg-error/10 rounded-lg shrink-0">
                            <WarningIcon class="w-3 h-3 text-error" />
                            <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- VISTA ESCRITORIO: TABLA AGRUPADA -->
                <div class="hidden xl:block overflow-x-auto">
                  <table class="w-full text-left border-collapse">
                    <thead
                      class="bg-surface-muted/50 text-[10px] font-black uppercase tracking-widest text-text-muted border-b border-border sticky top-0 z-10 backdrop-blur-sm">
                      <tr>
                        <th @click="toggleSort('id_marea')"
                          class="px-4 py-3 w-28 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Marea
                            <ChevronDownIcon v-if="sortBy === 'id_marea'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('buque_nombre')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Buque
                            <ChevronDownIcon v-if="sortBy === 'buque_nombre'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('pesquerias_nombres')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Pesquería / Flota
                            <ChevronDownIcon v-if="sortBy === 'pesquerias_nombres'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('fecha_zarpada')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Zarpada
                            <ChevronDownIcon v-if="sortBy === 'fecha_zarpada'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th @click="toggleSort('fecha_arribo')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Último Arribo
                            <ChevronDownIcon v-if="sortBy === 'fecha_arribo'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('progreso')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Progreso
                            <ChevronDownIcon v-if="sortBy === 'progreso'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                        <th v-if="!selectedMarea" @click="toggleSort('alertas')"
                          class="px-5 py-3 cursor-pointer hover:text-primary transition-colors group">
                          <div class="flex items-center gap-1">
                            Alertas
                            <ChevronDownIcon v-if="sortBy === 'alertas'"
                              class="w-3 h-3 text-primary transition-transform duration-300"
                              :class="{ 'rotate-180': sortOrder === 'asc' }" />
                          </div>
                        </th>
                      </tr>
                    </thead>

                    <tbody v-for="group in groupedMareas" :key="group.code"
                      class="divide-y divide-border border-b border-border/50 last:border-0"
                      v-show="group.items.length > 0">
                      <!-- Group Header Row -->
                      <tr class="bg-surface-muted/20 hover:bg-surface-muted/40 cursor-pointer transition-colors"
                        @click="toggleGroupCollapse(group.code)">
                        <td :colspan="selectedMarea ? 4 : 6" class="px-4 py-2">
                          <div class="flex items-center gap-3">
                            <button
                              class="w-6 h-6 flex items-center justify-center rounded-full bg-surface border border-border text-text-muted hover:text-primary transition-colors">
                              <ChevronDownIcon class="w-3.5 h-3.5 transition-transform duration-300"
                                :class="{ '-rotate-90': !group.expanded }" />
                            </button>
                            <div class="flex items-center gap-2">
                              <component :is="group.kpiData.icon" class="w-4 h-4" :class="group.kpiData.color" />
                              <span class="text-xs font-black uppercase text-text tracking-wide">{{ group.label
                              }}</span>
                              <span
                                class="px-2 py-0.5 bg-surface text-text-muted border border-border rounded-full text-[10px] font-bold">{{
                                  group.items.length }}</span>
                            </div>
                          </div>
                        </td>
                      </tr>

                      <!-- Item Rows -->
                      <tr v-for="marea in group.items" :key="marea.id" v-show="group.expanded"
                        @click="openSidebar(marea)"
                        class="group odd:bg-surface-muted/10 hover:bg-primary/5 transition-all cursor-pointer border-l-4 border-l-transparent"
                        :class="{ 'bg-primary/10 !border-l-primary': selectedMarea?.id === marea.id }">
                        <td class="px-4 py-1.5 w-28">
                          <span class="text-[11px] font-mono font-bold text-text-muted uppercase leading-none">{{
                            marea.id_marea }}</span>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex items-center gap-2.5">
                            <div
                              class="w-7 h-7 rounded-lg bg-surface-muted flex items-center justify-center text-text-muted group-hover:bg-primary/10 group-hover:text-primary transition-colors shrink-0">
                              <ShipIcon class="w-3.5 h-3.5" />
                            </div>
                            <div class="flex flex-col min-w-0">
                              <div class="flex items-center gap-2">
                                <span class="text-sm font-bold text-text leading-tight truncate">{{ marea.buque_nombre
                                }}</span>
                                <!-- Indicadores movidos aquí -->
                                <span v-if="marea.total_etapas > 1 && marea.estado_codigo === 'EN_EJECUCION'"
                                  class="px-1.5 py-0 bg-surface-muted text-text-muted rounded-md text-[8px] font-black uppercase border border-border"
                                  title="Etapa actual">
                                  E{{ marea.total_etapas }}
                                </span>
                                <span v-if="marea.en_tierra"
                                  class="px-1.5 py-0 bg-success/10 text-success rounded-md text-[8px] font-black uppercase border border-success/20">
                                  Tierra
                                </span>
                              </div>
                              <span class="text-[10px] font-bold text-text-muted leading-tight truncate mt-0.5">{{
                                marea.observador || 'Sin asignar' }}</span>
                            </div>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex flex-col">
                            <span class="text-[11px] font-black text-text-muted uppercase tracking-tight leading-tight">
                              {{ marea.pesquerias_nombres.join('\n') || 'N/D' }}
                            </span>
                            <span class="text-[9px] font-bold text-primary/70 italic leading-none mt-0.5">
                              {{ marea.flota }}
                            </span>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex flex-col">
                            <span class="text-xs font-bold text-text leading-none">{{ formatDate(marea.fecha_zarpada)
                            }}</span>
                            <span class="text-[10px] text-text-muted leading-none mt-1">{{ marea.puerto }}</span>
                          </div>
                        </td>
                        <td class="px-5 py-1.5">
                          <div class="flex flex-col gap-1" v-if="marea.fecha_arribo">
                            <div class="flex flex-wrap items-center gap-1.5">
                              <span class="text-xs font-bold text-text leading-none">{{ formatDate(marea.fecha_arribo) }}</span>
                              <span v-if="marea.en_tierra"
                                class="px-2 py-0.5 bg-warning/10 text-warning rounded-full text-[10px] font-black uppercase tracking-tighter border border-warning/20 whitespace-nowrap">
                                Esperando zarpada
                              </span>
                            </div>
                            <span class="text-[10px] text-text-muted leading-none">{{ marea.puerto_arribo || 'N/D' }}</span>
                          </div>
                          <div v-else-if="marea.estado_codigo === 'EN_EJECUCION'" class="flex items-center gap-1.5 flex-wrap">
                            <div class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></div>
                            <span
                              class="text-[10px] font-black text-primary uppercase tracking-tighter italic">Navegando...</span>
                            <span v-if="marea.en_prospeccion"
                              class="px-2 py-0.5 bg-purple-500/10 text-purple-600 rounded-full text-[10px] font-black uppercase tracking-tighter whitespace-nowrap border border-purple-500/20">
                              Prospección
                            </span>
                          </div>
                          <span v-else class="text-[10px] font-bold text-text-muted/40 italic">No disponible</span>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div class="flex flex-col gap-1 w-fit">
                            <div class="flex items-center gap-2">
                              <div class="w-16 h-1.5 bg-surface-muted rounded-full overflow-hidden">
                                <div class="h-full transition-all duration-1000"
                                  :class="marea.progreso > 100 ? 'bg-error' : 'bg-success'"
                                  :style="{ width: Math.min(marea.progreso, 100) + '%' }"></div>
                              </div>
                              <span class="text-[10px] font-black" :class="marea.progreso > 100 ? 'text-error' : 'text-text-muted'">{{ marea.progreso }}%</span>
                            </div>
                            <span class="text-[8px] font-bold text-text-muted/70 tracking-tight text-right w-full">
                              {{ marea.dias_marea || 0 }} / {{ marea.dias_estimados || 30 }} d
                            </span>
                          </div>
                        </td>
                        <td v-if="!selectedMarea" class="px-5 py-1.5">
                          <div v-if="marea.alertas?.length"
                            class="flex items-center gap-1.5 px-2 py-0.5 bg-error/10 rounded-lg w-fit">
                            <div class="w-1 h-1 rounded-full bg-error animate-pulse"></div>
                            <span class="text-[10px] font-black text-error">{{ marea.alertas.length }}</span>
                          </div>
                          <span v-else class="text-[10px] font-bold text-text-muted/40">Ninguna</span>
                        </td>
                      </tr>
                    </tbody>
                  </table>
                </div>
              </template>

              <!-- Empty State -->
              <div v-else class="p-20 flex flex-col items-center justify-center text-center">
                <div class="w-20 h-20 bg-surface-muted rounded-full flex items-center justify-center mb-4">
                  <ShipIcon class="w-10 h-10 text-text-muted/40" />
                </div>
                <h3 class="text-lg font-bold text-text">No hay mareas</h3>
                <p class="text-text-muted text-sm mt-1 max-w-xs">No se encontraron operaciones en este año operativo.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- PANEL DE DETALLE LATERAL PERSISTENTE -->
        <Transition enter-active-class="transition duration-300 ease-out" enter-from-class="translate-x-4 opacity-0"
          enter-to-class="translate-x-0 opacity-100" leave-active-class="transition duration-200 ease-in"
          leave-from-class="translate-x-0 opacity-100" leave-to-class="translate-x-4 opacity-0">
          <div v-if="selectedMarea"
            class="w-full xl:w-[320px] 2xl:w-[400px] shrink-0 sticky top-6 h-[calc(100vh-3rem)] flex flex-col bg-surface border border-border rounded-2xl shadow-sm overflow-hidden self-start hidden xl:block z-10">
            <MareaContextDetailContent :marea="selectedMarea" :context="selectedMareaContext" :read-only="isReadOnly"
              @close="closeSidebar" @open-detalle="goToDetalle" @view-trajectory="goToTrajectory"
              @action="executeActionFromSidebar" @manage-alert="handleManageAlert" />
          </div>
        </Transition>
      </div>
    </div>

    <GestionEtapasMareaDialog v-if="mareaToManage" :show="showGestionDialog" :mode="gestionMode" :marea="mareaToManage"
      :currentStages="mareaToManage?.etapas || []" :initialPortId="mareaToManage?.puertoBaseId"
      @close="handleGestionCancel" @confirm="handleGestionConfirm" />

    <RecibirArchivosDialog :show="showRecibirDialog" :marea="mareaToManage" @close="handleRecibirCancel"
      @confirm="handleRecibirConfirm" />

    <CancelarMareaDialog :show="showCancelarDialog" :marea="mareaToManage" :loading="executingAction"
      @close="showCancelarDialog = false" @confirm="handleCancelarConfirm" />

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

    <AprobarInformeDialog
      :show="showAprobarInformeDialog"
      :marea="mareaToManage"
      :loading="executingAction"
      @close="showAprobarInformeDialog = false"
      @confirm="handleAprobarInformeConfirm"
    />

    <EditMareaDesignadaDialog
      v-if="selectedMarea"
      :show="showEditDesignadaDialog"
      :initial-data="selectedMarea"
      :marea-id="selectedMarea.id"
      @close="showEditDesignadaDialog = false"
      @success="handleEditSuccess"
    />

    <AlertManagementDialog :is-open="isAlertDialogOpen" :alert="selectedAlert" @close="isAlertDialogOpen = false"
      @refresh="handleAlertRefresh" />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import MareaContextDetailContent from '../components/MareaContextDetailContent.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
import CancelarMareaDialog from '../components/CancelarMareaDialog.vue'
import MareaGenericActionDialog from '../components/MareaGenericActionDialog.vue'
import FinalizarProtocolizacionDialog from '../components/FinalizarProtocolizacionDialog.vue'
import AprobarInformeDialog from '../components/AprobarInformeDialog.vue'
import EditMareaDesignadaDialog from '../components/EditMareaDesignadaDialog.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import StatusFilterChip from '../components/StatusFilterChip.vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useMareas } from '../composables/useMareas'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import mareasService from '../services/mareas.service'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import {
  ShipIcon,
  SearchIcon,
  TaskIcon,
  HistoryIcon,
  ArchiveIcon,
  FileTextIcon,
  PlusIcon,
  ChevronDownIcon,
  WarningIcon,
  EditIcon,
  DownloadIcon
} from '@/icons'
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';

import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const router = useRouter()
const route = useRoute()
const {
  loading,
  kpis: rawKpis,
  mareas,
  fetchDashboard,
  fetchMareaContext,
  executeAction,
  selectedMareaContext,
  searchQuery,
  filterPesqueria,
  availablePesquerias,
  sortBy,
  sortOrder,
  toggleSort
} = useMareas()

const authStore = useAuthStore()
const isReadOnly = computed(() => {
  const roles = authStore.user?.roles || []
  return !roles.includes(ValidRoles.admin) && !roles.includes(ValidRoles.tecnico)
})

// UI State
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)
const showGestionDialog = ref(false)
const showRecibirDialog = ref(false)
const showCancelarDialog = ref(false)
const showGenericDialog = ref(false)
const showProtocolizacionDialog = ref(false)
const showAprobarInformeDialog = ref(false)
const selectedActionKey = ref<string | null>(null)
const selectedActionData = ref<any>(null)

const exporting = ref(false)
const configStore = useConfigStore()

const handleExport = async () => {
  try {
    exporting.value = true
    const params: any = {
      year: configStore.selectedYear
    }

    // Enviamos los IDs de las mareas visibles actualmente para respetar filtros
    if (filteredMareas.value.length > 0) {
      params.ids = filteredMareas.value.map(m => m.id)
    }

    if (searchQuery.value) {
      params.searchQuery = searchQuery.value
    }

    const blob = await mareasService.exportToExcel(params)
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url

    const filename = `MAREAS_${configStore.selectedYear}.xlsx`

    link.setAttribute('download', filename)
    document.body.appendChild(link)
    link.click()
    document.body.removeChild(link)
    window.URL.revokeObjectURL(url)
  } catch (err) {
    console.error('Error al exportar Excel:', err)
  } finally {
    exporting.value = false
  }
}
const executingAction = ref(false)
const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)

// Grouping State
const collapsedGroups = ref<Set<string>>(new Set())

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const handleManageAlert = (alert: any) => {
  selectedAlert.value = null
  setTimeout(() => {
    selectedAlert.value = alert
    isAlertDialogOpen.value = true
  }, 0)
}

const handleAlertRefresh = async () => {
  await fetchDashboard(true)
  if (selectedMarea.value) {
    await fetchMareaContext(selectedMarea.value.id)
  }
}

// Map icons/colors to backend kpis
const getKpiMeta = (codigo: string) => {
  const meta: Record<string, any> = {
    'DESIGNADA': {
      icon: TaskIcon,
      color: 'text-info',
      border: 'border-info/30',
      bg: 'bg-info/10'
    },
    'EN_EJECUCION': {
      icon: ShipIcon,
      color: 'text-primary',
      border: 'border-primary/30',
      bg: 'bg-primary/10'
    },
    'ESPERANDO_ENTREGA': {
      icon: HistoryIcon,
      color: 'text-warning',
      border: 'border-warning/30',
      bg: 'bg-warning/10'
    },
    'ENTREGADA_RECIBIDA': {
      icon: ArchiveIcon,
      color: 'text-success',
      border: 'border-success/30',
      bg: 'bg-success/10'
    },
    'VERIFICACION_INICIAL': {
      icon: SearchIcon,
      color: 'text-info',
      border: 'border-info/30',
      bg: 'bg-info/10'
    },
    'EN_CORRECCION': {
      icon: EditIcon,
      color: 'text-warning',
      border: 'border-warning/30',
      bg: 'bg-warning/10'
    },
    'PENDIENTE_DE_INFORME': {
      icon: FileTextIcon,
      color: 'text-primary',
      border: 'border-primary/30',
      bg: 'bg-primary/10'
    },
    'ESPERANDO_REVISION': {
      icon: SearchIcon,
      color: 'text-info',
      border: 'border-info/30',
      bg: 'bg-info/10'
    },
    'ESPERANDO_PROTOCOLIZACION': {
      icon: TaskIcon,
      color: 'text-primary',
      border: 'border-primary/30',
      bg: 'bg-primary/10'
    },
    'PROTOCOLIZADA': {
      icon: ArchiveIcon,
      color: 'text-text-muted',
      border: 'border-border',
      bg: 'bg-surface-muted/30'
    }
  }
  return meta[codigo] || { icon: ShipIcon, color: 'text-text-muted', border: 'border-border', bg: 'bg-surface-muted/30' }
}

const kpis = computed(() => {
  return rawKpis.value.map(k => ({
    ...k,
    ...getKpiMeta(k.codigo)
  }))
})

const groupedMareas = computed(() => {
  const groups: any[] = []

  // Sort logic function using composable state
  const sortItems = (items: any[]) => {
    if (!sortBy.value) return items;

    return [...items].sort((a, b) => {
      const key = sortBy.value as any;
      let valA: any = a[key];
      let valB: any = b[key];

      if (key === 'alertas') {
        valA = a.alertas?.length || 0;
        valB = b.alertas?.length || 0;
      }

      if (key === 'id_marea') {
        if (a.anio_marea !== b.anio_marea) {
          return sortOrder.value === 'asc'
            ? a.anio_marea - b.anio_marea
            : b.anio_marea - a.anio_marea;
        }
        return sortOrder.value === 'asc'
          ? a.nro_marea - b.nro_marea
          : b.nro_marea - a.nro_marea;
      }

      if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1;
      if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1;
      return 0;
    });
  }

  // Iterate over KPIs to guarantee order
  rawKpis.value.forEach(kpi => {
    const items = filteredMareas.value.filter(m => m.estado_codigo === kpi.codigo)

    groups.push({
      code: kpi.codigo,
      label: kpi.label,
      items: sortItems(items),
      expanded: !collapsedGroups.value.has(kpi.codigo) || (searchQuery.value.trim().length > 0 && items.length > 0),
      kpiData: getKpiMeta(kpi.codigo)
    })
  })

  return groups
})

// 1. Get filtered list based on search and fishery
const filteredMareas = computed(() => {
  return mareas.value.filter(m => {
    // Filtro por pesquería
    const matchesPesqueria = !filterPesqueria.value ||
      (m.pesquerias_nombres && m.pesquerias_nombres.includes(filterPesqueria.value));

    const query = searchQuery.value;
    if (!query) return matchesPesqueria;

    const normalize = (s: string) => s.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toLowerCase().trim();
    const queryNorm = normalize(query);

    const matchesText = normalize(m.buque_nombre).includes(queryNorm) ||
      normalize(m.id_marea).includes(queryNorm) ||
      (m.observador && normalize(m.observador).includes(queryNorm)) ||
      (m.pesquerias_nombres && m.pesquerias_nombres.some(p => normalize(p).includes(queryNorm)));

    return matchesPesqueria && matchesText;
  });
});

const hasMareas = computed(() => groupedMareas.value.some(g => g.items.length > 0))

const toggleGroupCollapse = (codigo: string) => {
  if (collapsedGroups.value.has(codigo)) {
    collapsedGroups.value.delete(codigo)
  } else {
    collapsedGroups.value.add(codigo)
  }
}

const selectAllGroups = () => {
  collapsedGroups.value = new Set()
}

const deselectAllGroups = () => {
  collapsedGroups.value = new Set(rawKpis.value.map(k => k.codigo))
}

const applyExpandFilter = () => {
  const expandParam = route.query.expand as string | undefined
  if (expandParam) {
    const expandList = expandParam.split(',').map(s => s.trim()).filter(Boolean)
    if (expandList.length) {
      // Por defecto colapsamos todo lo que NO esté en la lista expand
      const nextCollapsed = new Set<string>()
      rawKpis.value.forEach(k => {
        if (!expandList.includes(k.codigo)) {
          nextCollapsed.add(k.codigo)
        }
      })
      collapsedGroups.value = nextCollapsed
    }
  } else {
    // Si no hay parámetro de expansión, desmarcamos todo por defecto
    deselectAllGroups()
  }
}

onMounted(async () => {
  await fetchDashboard(true) // Pass true to load all states (operational year)
  applyExpandFilter()
})

watch(
  () => route.query.expand,
  () => {
    applyExpandFilter()
  }
)


const openSidebar = async (marea: any) => {
  if (window.innerWidth < 1280) {
    // Navigate to mobile detail route if strictly mobile,
    // BUT user asked to replicate PanelOperationalView which does navigating on mobile < 1280
    // Checking logic in PanelOperativo:
    router.push({ name: 'MareaOperativaDetalle', params: { id: marea.id } })
    return
  }
  selectedMarea.value = marea
  await fetchMareaContext(marea.id)
}

const executeActionFromSidebar = async (actionKey: string) => {
  if (!selectedMarea.value) return

  const mareaContext = selectedMareaContext.value?.marea || selectedMarea.value

  if (actionKey === 'REGISTRAR_INICIO') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'INICIAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'EDITAR_ETAPAS') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'EDITAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'REGISTRAR_FINALIZACION') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'FINALIZAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'RECIBIR_DATOS') {
    mareaToManage.value = mareaContext
    showRecibirDialog.value = true
    return
  }

  if (actionKey === 'CANCELAR') {
    mareaToManage.value = mareaContext
    showCancelarDialog.value = true
    return
  }

  if (actionKey === 'FINALIZAR_PROTOCOLIZACION') {
    mareaToManage.value = mareaContext
    showProtocolizacionDialog.value = true
    return
  }

  if (actionKey === 'APROBAR_INFORME') {
    mareaToManage.value = mareaContext
    showAprobarInformeDialog.value = true
    return
  }

  // Si la acción tiene metadatos en el contexto y no es una de las especiales manejadas arriba, usar diálogo genérico
  const actionMetadata = selectedMareaContext.value?.actions[actionKey]
  if (actionMetadata) {
    mareaToManage.value = mareaContext
    selectedActionKey.value = actionKey
    selectedActionData.value = actionMetadata
    showGenericDialog.value = true
    return
  }

  try {
    await executeAction(selectedMarea.value.id, actionKey)
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error('Action failed:', err)
  }
}

const handleAprobarInformeConfirm = async (file: File, comentarios: string) => {
  if (!mareaToManage.value) return
  try {
    executingAction.value = true
    await mareasService.aprobarInforme(mareaToManage.value.id, file, comentarios)
    showAprobarInformeDialog.value = false
    mareaToManage.value = null
    closeSidebar()
    await fetchDashboard()
  } catch (err) {
    console.error('Error aprobando informe:', err)
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
    closeSidebar()
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
    closeSidebar()
  } catch (err) {
    console.error("Error en protocolización de marea:", err)
  } finally {
    executingAction.value = false
  }
}

const handleGestionCancel = () => {
  showGestionDialog.value = false
  mareaToManage.value = null
  closeSidebar()
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
    closeSidebar()
  } catch (err) {
    console.error("Error en gestión de marea:", err)
  }
}

const handleRecibirCancel = () => {
  showRecibirDialog.value = false
  closeSidebar()
}

const handleRecibirConfirm = async (payload: any) => {
  try {
    await executeAction(mareaToManage.value.id, 'RECIBIR_DATOS', payload)
    showRecibirDialog.value = false
    mareaToManage.value = null
    closeSidebar()
  } catch (err) {
    console.error("Error en recepción de archivos:", err)
  }
}

const handleCancelarConfirm = async (payload: any) => {
  try {
    executingAction.value = true
    await executeAction(mareaToManage.value.id, 'CANCELAR', payload)
    showCancelarDialog.value = false
    mareaToManage.value = null
    closeSidebar()
  } catch (err) {
    console.error("Error al cancelar marea:", err)
  } finally {
    executingAction.value = false
  }
}

const closeSidebar = () => {
  isSidebarOpen.value = false
  setTimeout(() => {
    selectedMarea.value = null
  }, 300)
}

const showEditDesignadaDialog = ref(false)

const goToDetalle = () => {
  if (selectedMarea.value) {
    if (selectedMarea.value.estado_codigo === 'DESIGNADA' && !isReadOnly.value) {
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
  await fetchDashboard(true)
}

const goToTrajectory = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaTrajectory', params: { mareaId: selectedMarea.value.id } })
  }
}

const getStatusClasses = (status?: string) => {
  if (!status) return 'bg-surface-muted text-text-muted'

  const s = status.toUpperCase()
  if (s === 'DESIGNADA')
    return 'bg-info/10 text-info'
  if (s === 'EN_EJECUCION' || s === 'NAVEGANDO')
    return 'bg-primary/10 text-primary'
  if (s === 'ESPERANDO_ENTREGA')
    return 'bg-warning/10 text-warning'
  if (s === 'ENTREGADA_RECIBIDA')
    return 'bg-success/10 text-success'
  if (s === 'VERIFICACION_INICIAL')
    return 'bg-info/10 text-info'
  if (s === 'EN_CORRECCION')
    return 'bg-warning/10 text-warning'
  if (s === 'PENDIENTE_DE_INFORME')
    return 'bg-primary/10 text-primary'

  return 'bg-surface-muted text-text-muted'
}

const formatDate = (date?: string) => {
  if (!date) return 'N/D'
  return new Date(date).toLocaleDateString('es-AR', { day: '2-digit', month: 'short' })
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
  height: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
}

.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
}
</style>
