<template>
   <AdminLayout title="Centro de Análisis"
      description="Inteligencia institucional y monitoreo de desempeño estratégico.">
      <div class="relative min-h-screen pb-20 animate-in fade-in duration-700">

         <!-- TOP ANALYTICS FILTERS -->
         <section class="mb-8">
            <StatsFilterBar title="Análisis de Gestión" subtitle="Filtros dinámicos de periodo" :icon="BarChartIcon"
               :loading="loading" v-model:mode="mode" :protocolizedOnly="protocolizedOnly"
               @update:protocolizedOnly="protocolizedOnly = $event" :includeOutOfPeriod="includeOutOfPeriod"
               @update:includeOutOfPeriod="includeOutOfPeriod = $event" @refresh="fetchData"
               v-model:daysCalculationMode="daysCalculationMode" v-model:includeCampaigns="includeCampaigns" />

            <div class="mt-4">
               <TimeFilterBar :year="year" :startDate="startDate" :endDate="endDate"
                  @update:filter="handleTimeFilter" />
            </div>

            <!-- Collapsible Criteria Explanation -->
            <div
               class="mt-4 bg-surface-muted/30 border border-border/50 rounded-xl overflow-hidden transition-all duration-300">
               <button @click="isCriteriaOpen = !isCriteriaOpen"
                  class="w-full flex items-center justify-between p-3 px-4 text-xs font-medium text-text-muted hover:text-text hover:bg-surface-muted/50 transition-colors">
                  <div class="flex items-center gap-2">
                     <InfoIcon class="w-4 h-4 text-primary/70" />
                     <span>Criterios de Análisis Aplicados</span>
                  </div>
                  <component :is="isCriteriaOpen ? ChevronUpIcon : ChevronDownIcon" class="w-4 h-4" />
               </button>

               <div v-if="isCriteriaOpen"
                  class="p-4 pt-0 border-t border-border/50 animate-in slide-in-from-top-2 duration-200">
                  <ul class="space-y-2 mt-3">
                     <li v-for="(criterion, index) in criteriaList" :key="index"
                        class="flex items-start gap-2 text-xs text-text-muted">
                        <div class="w-1.5 h-1.5 rounded-full bg-primary/40 mt-1.5 shrink-0"></div>
                        <span v-html="criterion"></span>
                     </li>
                  </ul>
               </div>
            </div>

         </section>

         <div v-if="stats" class="space-y-8">
            <!-- ROW 1: CORE ANALYTICAL KPIs -->
            <section class="grid grid-cols-1 md:grid-cols-3 gap-6">
               <StatKpiCard label="Total Mareas" :value="stats.totalMareas" :icon="ShipIcon" color="primary"
                  subtext="Mareas registradas en el periodo" />
               <StatKpiCard label="Días Navegados" :value="stats.totalDaysNavigated" :icon="CalendarClockIcon"
                  color="secondary" subtext="Total acumulado de días de operación" />
               <StatKpiCard label="Promedio Días / Marea" :value="stats.avgDaysPerMarea" :icon="TimerIcon"
                  color="accent" subtext="Eficiencia operativa promedio" />
            </section>

            <!-- ROW 2: TEMPORAL TRENDS -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12 lg:col-span-8">
                  <ChartWidget title="Tendencia Mensual" subtitle="Mareas iniciadas y Días Navegados por mes" type="bar"
                     :series="monthlySeries" :options="monthlyChartOptions" allow-download
                     @download="handleDownload('Tendencia_Mensual')" />
               </div>
               <div class="col-span-12 lg:col-span-4 space-y-8">
                  <ChartWidget title="Distribución por Flota" type="pie" :series="fleetSeries"
                     :options="fleetChartOptions" allow-download @dataPointClick="handleFleetClick"
                     @download="handleDownload('Distribucion_Flota', 'FLEET')" />
               </div>
            </section>

            <!-- ROW 3: FISHERIES & OBSERVERS -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12 lg:col-span-5">
                  <ChartWidget title="Participación por Pesquería" subtitle="Días navegados por especie objetivo"
                     type="donut" :series="fisherySeries" :options="fisheryChartOptions" allow-download
                     @dataPointClick="handleFisheryClick"
                     @download="handleDownload('Participacion_Pesqueria', 'FISHERY')" />
               </div>
               <div class="col-span-12 lg:col-span-7">
                  <ChartWidget title="Ranking de Observadores" subtitle="Top 10 por días navegados" type="bar"
                     :series="observerSeries" :options="observerChartOptions" allow-download
                     @dataPointClick="handleObserverClick"
                     @download="handleDownload('Ranking_Observadores', 'OBSERVER')">
                     <template #header-action>
                        <button @click="rankingModalOpen = true"
                           class="text-primary hover:text-primary-hover transition-colors p-1"
                           title="Ver ranking completo">
                           <Maximize2Icon class="w-4 h-4" />
                        </button>
                     </template>
                  </ChartWidget>
               </div>
            </section>

            <!-- ROW 4: DETAILED FISHERY ANALYSIS & OPERATIONAL PROFILE -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12 lg:col-span-7">
                  <ChartWidget title="Detalle de Actividad por Pesquería"
                     subtitle="Comparativa de Mareas y Días Navegados" type="bar" :series="fisheryDualAxisSeries"
                     :options="fisheryDualAxisOptions" allow-download @dataPointClick="handleFisheryClick"
                     @download="handleDownload('Detalle_Pesqueria_Mareas_Dias', 'FISHERY')" />
               </div>
               <div class="col-span-12 lg:col-span-5">
                  <ChartWidget title="Perfil Operativo" subtitle="Esfuerzo (Días) vs Frecuencia (Mareas)" type="scatter"
                     :series="fisheryProfileSeries" :options="fisheryProfileOptions" allow-download
                     @dataPointClick="handleFisheryClick"
                     @download="handleDownload('Perfil_Operativo_Pesqueria', 'FISHERY')" />
               </div>
            </section>

            <!-- ROW 5: TEMPORAL DISTRIBUTION (GANTT) + COVERAGE -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12 space-y-4">
                  <!-- Sincronized Monthly Coverage Chart -->
                  <div class="bg-surface rounded-2xl border border-border shadow-theme-xs p-4 pb-0">
                     <div class="flex items-center justify-between mb-2">
                        <div>
                           <h3 class="text-[10px] font-black text-text-muted uppercase tracking-widest flex items-center gap-2">
                              <LayoutGridIcon class="w-3.5 h-3.5 text-sky-500" />
                              Cobertura Mensual (Barcos Únicos)
                           </h3>
                        </div>
                        <div class="text-[10px] font-bold text-text-muted uppercase">
                           Total embarcaciones cubiertas por mes
                        </div>
                     </div>
                     <apexchart type="bar" height="150" :options="monthlyCoverageChartOptions" :series="monthlyCoverageSeries" />
                  </div>

                  <!-- Sincronized Daily Coverage Chart -->
                  <div class="bg-surface rounded-2xl border border-border shadow-theme-xs p-4 pb-0">
                     <div class="flex items-center justify-between mb-2">
                        <div>
                           <h3 class="text-[10px] font-black text-text-muted uppercase tracking-widest flex items-center gap-2">
                              <TrendingUpIcon class="w-3.5 h-3.5 text-primary" />
                              Evolución de Cobertura Diaria
                           </h3>
                        </div>
                        <div class="text-[10px] font-bold text-text-muted uppercase">
                           Total embarcaciones activas por día
                        </div>
                     </div>
                     <apexchart type="area" height="150" :options="coverageChartOptions" :series="coverageSeries" />
                  </div>

                  <ChartWidget title="Cronograma de Distribución de Mareas"
                     subtitle="Distribución temporal de mareas y etapas por buque" type="rangeBar" :series="ganttSeries"
                     :options="ganttChartOptions" :chart-height="dynamicChartHeight"
                     chart-container-class="max-h-[600px] overflow-y-auto custom-scrollbar" allow-download
                      @download="handleDownload('Distribucion_Temporal_Gantt')">
                     <template #header-action>
                        <div class="flex items-center gap-6">

                           <div class="flex items-center gap-2">
                              <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Filtrar
                                 Pesquería:</span>
                              <select v-model="selectedDistributionFishery"
                                 class="bg-surface border border-border rounded-lg px-3 py-1 text-xs font-bold text-text focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none">
                                 <option value="ALL">Todas las Pesquerías</option>
                                 <option v-for="f in ganttFisheries" :key="f" :value="f">{{ f }}</option>
                              </select>
                           </div>
                        </div>
                     </template>
                  </ChartWidget>
               </div>
            </section>

         </div>

         <!-- Loading State -->
         <div v-else-if="loading" class="flex items-center justify-center py-20">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
         </div>

         <!-- Empty State -->
         <div v-else class="text-center py-20 text-text-muted">
            No hay datos disponibles para la configuración seleccionada.
         </div>

         <!-- DRILL DOWN DIALOG -->
         <BaseModal :show="dialogOpen" maxWidth="6xl" @close="closeDialog">
            <template #title>
               <div class="flex items-center gap-4">
                  <div>
                     <span class="text-sm font-black text-text uppercase tracking-tight leading-none block mb-0.5">{{
                        dialogTitle }}</span>
                     <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">Detalle de mareas
                        asociadas</p>
                  </div>

                  <!-- Layout Toggle (Hidden on mobile) -->
                  <div
                     class="hidden lg:flex items-center bg-surface border border-border rounded-lg p-0.5 ml-4 shadow-sm">
                     <button @click="detailViewMode = 'cards'" :class="[
                        'p-1.5 rounded-md transition-all duration-200',
                        detailViewMode === 'cards' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text hover:bg-surface-muted'
                     ]" title="Vista de Tarjetas">
                        <LayoutGridIcon class="w-4 h-4" />
                     </button>
                     <button @click="detailViewMode = 'table'" :class="[
                        'p-1.5 rounded-md transition-all duration-200',
                        detailViewMode === 'table' ? 'bg-primary text-primary-fg shadow-sm' : 'text-text-muted hover:text-text hover:bg-surface-muted'
                     ]" title="Vista de Tabla">
                        <LayoutListIcon class="w-4 h-4" />
                     </button>
                  </div>
               </div>
            </template>

            <div class="flex flex-col min-h-0 -mx-6 -mb-6 -mt-6 h-[80vh] max-h-[85vh]">
               <!-- Search bar (Fixed) -->
               <div class="px-6 py-4 border-b border-border bg-surface-muted/20 flex items-center gap-4 flex-none">
                  <div class="relative flex-1 group">
                     <SearchIcon
                        class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted group-focus-within:text-primary transition-colors" />
                     <input v-model="searchTerm" type="text" placeholder="Filtrar por marea, buque, observador..."
                        class="w-full pl-9 pr-10 py-2 bg-surface border border-border rounded-xl text-sm focus:bg-surface focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200 shadow-sm" />
                     <button v-if="searchTerm" @click="searchTerm = ''"
                        class="absolute right-3 top-1/2 -translate-y-1/2 p-1 rounded-full text-text-muted hover:text-error hover:bg-error/10 transition-all duration-200"
                        title="Limpiar filtro">
                        <XIcon class="w-3.5 h-3.5" />
                     </button>
                  </div>
                  <div
                     class="text-[10px] font-black text-text-muted uppercase tracking-widest whitespace-nowrap bg-surface px-3 py-1.5 rounded-lg border border-border shadow-theme-xs">
                     {{ filteredDialogItems.length }} Resultados
                  </div>
               </div>

               <!-- Scrollable content -->
               <div class="flex-1 overflow-y-auto custom-scrollbar bg-surface/30">
                  <div v-if="dialogLoading" class="flex justify-center items-center h-full">
                     <div class="flex flex-col items-center gap-4">
                        <Loader2Icon class="w-10 h-10 animate-spin text-primary" />
                        <span class="text-xs font-bold text-text-muted uppercase tracking-widest">Cargando
                           datos...</span>
                     </div>
                  </div>

                  <div v-else class="p-6">
                     <!-- CARD VIEW (Responsive: Always on mobile, or forced in desktop) -->
                     <div v-if="detailViewMode === 'cards' || detailViewMode === 'table'"
                        :class="{ 'lg:hidden': detailViewMode === 'table' }" class="space-y-3">
                        <div v-for="marea in filteredDialogItems" :key="marea.id" @click="openMareaDetail(marea.id)"
                           class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between p-4 rounded-xl border border-border bg-surface shadow-theme-xs hover:shadow-theme-md hover:border-primary/40 transition-all duration-200 group cursor-pointer">
                           <div class="flex-1 min-w-0">
                              <div class="flex items-center gap-2 mb-2">
                                 <span class="font-black text-sm text-text tabular-nums tracking-tighter">{{
                                    marea.id_marea
                                    }}</span>
                                 <span
                                    class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-widest bg-secondary/10 text-secondary border border-secondary/20">{{
                                       marea.estado }}</span>
                                 <span v-if="marea.tipoMarea === TipoMarea.CI"
                                    class="px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-widest bg-accent/10 text-accent border border-accent/20">Campaña</span>
                              </div>
                              <div class="text-[11px] text-text-muted grid grid-cols-2 lg:grid-cols-4 gap-4">
                                 <div class="flex flex-col">
                                    <span
                                       class="font-black opacity-40 uppercase tracking-tighter text-[9px] mb-0.5">Buque</span>
                                    <span class="font-bold text-text truncate">{{ marea.buque }}</span>
                                 </div>
                                 <div class="flex flex-col">
                                    <span
                                       class="font-black opacity-40 uppercase tracking-tighter text-[9px] mb-0.5">Flota</span>
                                    <span class="font-bold text-text truncate">{{ marea.flota }}</span>
                                 </div>
                                 <div class="flex flex-col">
                                    <span
                                       class="font-black opacity-40 uppercase tracking-tighter text-[9px] mb-0.5">Pesquería</span>
                                    <span class="font-bold text-text truncate">{{ marea.pesqueria }}</span>
                                 </div>
                                 <div v-if="filterType !== 'OBSERVER'" class="flex flex-col">
                                    <span
                                       class="font-black opacity-40 uppercase tracking-tighter text-[9px] mb-0.5">Observador</span>
                                    <span class="font-bold text-text truncate">{{ marea.observador }}</span>
                                 </div>
                                 <div class="flex flex-col">
                                    <span
                                       class="font-black opacity-40 uppercase tracking-tighter text-[9px] mb-0.5">Inicio</span>
                                    <span class="font-bold text-text">{{ marea.fechaInicio ? new
                                       Date(marea.fechaInicio).toLocaleDateString() : '-' }}</span>
                                 </div>
                              </div>
                           </div>

                           <!-- Dual Metrics (Responsive alignment) -->
                           <div
                              class="flex items-center gap-4 sm:pl-4 min-w-[140px] justify-end sm:border-l border-border/40 sm:ml-4 pt-3 sm:pt-0 mt-3 sm:mt-0 border-t sm:border-t-0">
                              <div v-if="mode === 'CALENDAR'" class="flex items-center gap-3">
                                 <div class="text-right">
                                    <span class="block text-xl font-black text-primary leading-tight tabular-nums">{{
                                       marea.diasCalendario }}</span>
                                    <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">Días
                                       {{ year
                                       }}</span>
                                 </div>
                                 <div class="w-px h-8 bg-border"></div>
                                 <div class="text-right">
                                    <span
                                       class="block text-xl font-bold text-text-muted/80 leading-tight tabular-nums">{{
                                          marea.diasTotales }}</span>
                                    <span
                                       class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">Totales</span>
                                 </div>
                              </div>
                              <div v-else class="text-right">
                                 <span class="block text-2xl font-black text-primary leading-tight tabular-nums">{{
                                    marea.diasTotales }}</span>
                                 <span class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1">Días
                                    Totales</span>
                              </div>
                           </div>
                        </div>
                     </div>

                     <!-- TABLE VIEW (Desktop only) -->
                     <div v-if="detailViewMode === 'table'"
                        class="hidden lg:block bg-surface rounded-xl border border-border shadow-theme-xs overflow-hidden">
                        <table class="w-full text-left border-collapse">
                           <thead>
                              <tr class="bg-surface-muted/50 border-b border-border">
                                 <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group"
                                    @click="handleSort('id_marea')">
                                    <div class="flex items-center gap-2">
                                       Marea
                                       <component :is="getSortIcon('id_marea')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'id_marea' }" />
                                    </div>
                                 </th>
                                 <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group"
                                    @click="handleSort('buque')">
                                    <div class="flex items-center gap-2">
                                       Buque
                                       <component :is="getSortIcon('buque')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'buque' }" />
                                    </div>
                                 </th>
                                 <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group"
                                    @click="handleSort('flota')">
                                    <div class="flex items-center gap-2">
                                       Flota
                                       <component :is="getSortIcon('flota')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'flota' }" />
                                    </div>
                                 </th>
                                 <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group"
                                    @click="handleSort('pesqueria')">
                                    <div class="flex items-center gap-2">
                                       Pesquería
                                       <component :is="getSortIcon('pesqueria')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'pesqueria' }" />
                                    </div>
                                 </th>
                                 <th v-if="filterType !== 'OBSERVER'"
                                    class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group"
                                    @click="handleSort('observador')">
                                    <div class="flex items-center gap-2">
                                       Observador
                                       <component :is="getSortIcon('observador')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'observador' }" />
                                    </div>
                                 </th>
                                 <th class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group text-right"
                                    @click="handleSort(mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales')">
                                    <div class="flex items-center justify-end gap-2">
                                       Días {{ mode === 'CALENDAR' ? year : 'Tot.' }}
                                       <component
                                          :is="getSortIcon(mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === (mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales') }" />
                                    </div>
                                 </th>
                                 <th v-if="mode === 'CALENDAR'"
                                    class="px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted cursor-pointer hover:bg-surface-muted transition-colors group text-right"
                                    @click="handleSort('diasTotales')">
                                    <div class="flex items-center justify-end gap-2">
                                       Total Marea
                                       <component :is="getSortIcon('diasTotales')"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === 'diasTotales' }" />
                                    </div>
                                 </th>
                              </tr>
                           </thead>
                           <tbody class="divide-y divide-border">
                              <tr v-for="marea in filteredDialogItems" :key="marea.id"
                                 @click="openMareaDetail(marea.id)"
                                 class="hover:bg-primary/5 transition-colors group cursor-pointer">
                                 <td class="px-4 py-2 border-r border-border/50">
                                    <div class="flex flex-col">
                                       <span class="font-black text-xs text-text tabular-nums">{{ marea.id_marea
                                          }}</span>
                                       <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">{{
                                          marea.estado }}</span>
                                    </div>
                                 </td>
                                 <td class="px-4 py-2 text-xs font-bold text-text border-r border-border/50">{{
                                    marea.buque }}
                                 </td>
                                 <td class="px-4 py-2 text-xs font-bold text-text border-r border-border/50">{{
                                    marea.flota }}
                                 </td>
                                 <td class="px-4 py-2 text-xs font-bold text-text border-r border-border/50">{{
                                    marea.pesqueria
                                    }}</td>
                                 <td v-if="filterType !== 'OBSERVER'"
                                    class="px-4 py-2 text-xs font-bold text-text border-r border-border/50">{{
                                       marea.observador
                                    }}</td>
                                 <td class="px-4 py-2 text-right border-r border-border/50">
                                    <span
                                       :class="['font-black text-sm tabular-nums', mode === 'CALENDAR' ? 'text-primary' : 'text-text']">
                                       {{ mode === 'CALENDAR' ? marea.diasCalendario : marea.diasTotales }}
                                    </span>
                                 </td>
                                 <td v-if="mode === 'CALENDAR'" class="px-4 py-2 text-right">
                                    <span class="font-bold text-xs text-text-muted tabular-nums opacity-80">{{
                                       marea.diasTotales
                                       }}</span>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>

                     <!-- Empty Filter Result -->
                     <div v-if="filteredDialogItems.length === 0"
                        class="flex flex-col items-center justify-center py-20 px-4 text-center">
                        <SearchIcon class="w-12 h-12 text-text-muted/20 mb-4" />
                        <p class="text-xs font-black text-text-muted uppercase tracking-widest">No hay resultados para
                           "{{
                              searchTerm }}"</p>
                        <p class="text-[10px] text-text-muted/60 mt-2 font-bold uppercase">Intenta ajustar los criterios
                           de
                           búsqueda</p>
                     </div>
                  </div>
               </div>

               <!-- Footer (Redesigned) -->
               <div
                  class="flex justify-end gap-3 p-4 border-t border-border bg-surface-muted/20 flex-none bg-surface/50 backdrop-blur-md">
                  <button
                     class="flex items-center gap-2 px-4 py-2 rounded-lg border border-border text-xs font-black uppercase tracking-widest hover:bg-surface-muted transition-colors bg-surface shadow-sm active:scale-95 duration-200"
                     @click="handleDownload('Detalle', filterType || undefined)">
                     <DownloadIcon class="w-4 h-4" />
                     Exportar Detalle
                  </button>
                  <button
                     class="px-6 py-2 rounded-lg bg-primary text-primary-fg text-xs font-black uppercase tracking-widest hover:bg-primary-hover transition-colors shadow-theme-sm active:scale-95 duration-200"
                     @click="closeDialog">
                     Cerrar
                  </button>
               </div>
            </div>
         </BaseModal>

         <!-- FULL OBSERVER RANKING DIALOG -->
         <BaseModal :show="rankingModalOpen" maxWidth="4xl" @close="rankingModalOpen = false">
            <template #title>
               <div class="flex items-center gap-3">
                  <div class="p-2 bg-primary/10 rounded-lg text-primary">
                     <TrendingUpIcon class="w-5 h-5" />
                  </div>
                  <div>
                     <span class="text-sm font-black text-text uppercase tracking-tight leading-none block mb-0.5">Ranking Completo de Observadores</span>
                     <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">{{ year }} • {{ mode === 'CALENDAR' ? 'Periodo' : 'Total' }}</p>
                  </div>
               </div>
            </template>

            <div class="flex flex-col min-h-0 -mx-6 -mb-6 -mt-6 h-[80vh] max-h-[85vh]">
               <!-- Search bar -->
               <div class="px-6 py-4 border-b border-border bg-surface-muted/20 flex items-center gap-4 flex-none">
                  <div class="relative flex-1 group">
                     <SearchIcon
                        class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-text-muted group-focus-within:text-primary transition-colors" />
                     <input v-model="rankingSearch" type="text" placeholder="Buscar observador..."
                        class="w-full pl-9 pr-10 py-2 bg-surface border border-border rounded-xl text-sm focus:bg-surface focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all duration-200 shadow-sm" />
                     <button v-if="rankingSearch" @click="rankingSearch = ''"
                        class="absolute right-3 top-1/2 -translate-y-1/2 p-1 rounded-full text-text-muted hover:text-error hover:bg-error/10 transition-all duration-200">
                        <XIcon class="w-3.5 h-3.5" />
                     </button>
                  </div>
                  <div
                     class="text-[10px] font-black text-text-muted uppercase tracking-widest whitespace-nowrap bg-surface px-3 py-1.5 rounded-lg border border-border shadow-theme-xs">
                     {{ fullObserverRanking.length }} Registros
                  </div>
               </div>

               <!-- Ranking List -->
               <div class="flex-1 overflow-y-auto custom-scrollbar bg-surface/30">
                  <div class="bg-surface border-b border-border shadow-theme-xs">
                     <table class="w-full text-left border-collapse">
                        <thead>
                           <tr class="bg-surface-muted/50 border-b border-border">
                              <th
                                 class="sticky top-0 z-20 bg-surface/95 backdrop-blur-md shadow-sm px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted w-16">
                                 Pos</th>
                              <th
                                 class="sticky top-0 z-20 bg-surface/95 backdrop-blur-md shadow-sm px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">
                                 Observador</th>
                              <th
                                 class="sticky top-0 z-20 bg-surface/95 backdrop-blur-md shadow-sm px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-24">
                                 Mareas</th>
                              <th
                                 class="sticky top-0 z-20 bg-surface/95 backdrop-blur-md shadow-sm px-4 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-right">
                                 Días Navegados</th>
                           </tr>
                        </thead>
                        <tbody class="divide-y divide-border">
                           <tr v-for="(obs, index) in fullObserverRanking" :key="obs.id"
                              @click="openObserverDetail(obs)"
                              class="hover:bg-primary/5 transition-colors group cursor-pointer">
                              <td class="px-4 py-3 border-r border-border/50">
                                 <span class="font-black text-xs text-text-muted tabular-nums">#{{ index + 1 }}</span>
                              </td>
                              <td class="px-4 py-3 border-r border-border/50">
                                 <div class="flex flex-col">
                                    <span
                                       class="font-bold text-sm text-text group-hover:text-primary transition-colors">{{
                                          obs.name }}</span>
                                    <span v-if="!obs.active"
                                       class="text-[9px] font-bold text-error uppercase tracking-tighter">Inactivo</span>
                                 </div>
                              </td>
                              <td class="px-4 py-3 text-center border-r border-border/50 font-bold text-xs text-text">{{
                                 obs.mareas }}</td>
                              <td class="px-4 py-3 text-right">
                                 <div class="flex items-center justify-end gap-3">
                                    <div
                                       class="flex-1 max-w-[100px] h-1.5 bg-surface-muted rounded-full overflow-hidden hidden sm:block">
                                       <div class="h-full bg-primary"
                                          :style="{ width: `${(obs.days / (fullObserverRanking[0]?.days || 1)) * 100}%` }">
                                       </div>
                                    </div>
                                    <span class="font-black text-sm text-primary tabular-nums">{{ obs.days }}</span>
                                 </div>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>

                  <div v-if="fullObserverRanking.length === 0"
                     class="flex flex-col items-center justify-center py-20 text-center">
                     <SearchIcon class="w-12 h-12 text-text-muted/20 mb-4" />
                     <p class="text-xs font-black text-text-muted uppercase tracking-widest">No hay resultados</p>
                  </div>
               </div>

               <div
                  class="flex justify-end p-4 border-t border-border bg-surface-muted/20 flex-none bg-surface/50 backdrop-blur-md">
                  <button
                     class="px-6 py-2 rounded-lg bg-primary text-primary-fg text-xs font-black uppercase tracking-widest hover:bg-primary-hover transition-colors shadow-theme-sm"
                     @click="rankingModalOpen = false">
                     Cerrar
                  </button>
               </div>
            </div>
         </BaseModal>

         <!-- MONTHLY VESSELS DRILL DOWN DIALOG -->
         <BaseModal :show="vesselsDialogOpen" maxWidth="4xl" @close="vesselsDialogOpen = false">
            <template #title>
               <div class="flex items-center gap-4">
                  <div class="p-2 bg-sky-500/10 rounded-lg text-sky-500">
                     <ShipIcon class="w-5 h-5" />
                  </div>
                  <div>
                     <span class="text-sm font-black text-text uppercase tracking-tight leading-none block mb-0.5">
                        Cobertura por Mes: <span class="capitalize">{{ selectedMonthLabel }}</span>
                     </span>
                     <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">Desglose de buques únicos cubiertos</p>
                  </div>
               </div>
            </template>

            <div class="flex flex-col min-h-0 -mx-6 -mb-6 -mt-6 h-[70vh] max-h-[75vh]">
               <div class="px-6 py-4 border-b border-border bg-surface-muted/20 flex items-center justify-between flex-none">
                  <div class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                     {{ monthlyVessels.length }} Embarcaciones Identificadas
                  </div>
               </div>

               <div class="flex-1 overflow-y-auto custom-scrollbar bg-surface/30 p-6">
                  <div v-if="vesselsLoading" class="flex justify-center items-center h-full">
                     <div class="flex flex-col items-center gap-4">
                        <Loader2Icon class="w-10 h-10 animate-spin text-sky-500" />
                        <span class="text-xs font-bold text-text-muted uppercase tracking-widest">Cargando flota...</span>
                     </div>
                  </div>

                  <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4">
                     <div v-for="vessel in monthlyVessels" :key="vessel.buqueId"
                        class="p-4 rounded-2xl border border-border bg-surface shadow-theme-xs hover:border-sky-500/40 transition-all duration-200 group">
                        <div class="flex justify-between items-start mb-3">
                           <div class="flex flex-col">
                              <span class="text-xs font-black text-text uppercase tracking-tight">{{ vessel.buqueNombre }}</span>
                              <span class="text-[9px] font-bold text-text-muted uppercase tracking-widest">{{ vessel.flota }}</span>
                           </div>
                           <div class="text-right">
                              <span class="block text-lg font-black text-sky-500 leading-none tabular-nums">{{ vessel.diasEnMes }}</span>
                              <span class="text-[8px] font-bold text-text-muted uppercase tracking-tighter">Días en Mes</span>
                           </div>
                        </div>
                        
                        <div class="pt-3 border-t border-border/50 flex items-center justify-between">
                           <div class="flex items-center gap-1.5">
                              <div class="w-1.5 h-1.5 rounded-full bg-primary/40"></div>
                              <span class="text-[10px] font-bold text-text-muted uppercase truncate max-w-[150px]">
                                 {{ vessel.pesqueriaHabitual }}
                              </span>
                           </div>
                           <div class="px-2 py-0.5 rounded bg-surface-muted border border-border text-[9px] font-bold text-text-muted uppercase">
                              {{ vessel.mareasEnMes }} {{ vessel.mareasEnMes === 1 ? 'Marea' : 'Mareas' }}
                           </div>
                        </div>
                     </div>
                  </div>

                  <!-- Empty State -->
                  <div v-if="!vesselsLoading && monthlyVessels.length === 0" class="flex flex-col items-center justify-center py-20 text-center">
                     <ShipIcon class="w-12 h-12 text-text-muted/20 mb-4" />
                     <p class="text-xs font-black text-text-muted uppercase tracking-widest">Sin actividad registrada</p>
                  </div>
               </div>

               <div class="flex justify-end p-4 border-t border-border bg-surface-muted/20 flex-none bg-surface/50 backdrop-blur-md">
                  <button
                     class="px-6 py-2 rounded-lg bg-primary text-primary-fg text-xs font-black uppercase tracking-widest hover:bg-primary-hover transition-colors shadow-theme-sm active:scale-95 duration-200"
                     @click="vesselsDialogOpen = false">
                     Cerrar
                  </button>
               </div>
            </div>
         </BaseModal>

         <!-- Individual Marea Quick Detail -->
         <MareaQuickDetailModal 
            :is-open="isMareaDetailOpen" 
            :marea-id="selectedMareaId"
            @close="isMareaDetailOpen = false" 
         />
      </div>
   </AdminLayout>
</template>

<script setup lang="ts">
import { ref, watch, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import StatsFilterBar from '@/modules/stats/components/StatsFilterBar.vue'
import StatKpiCard from '@/modules/stats/components/StatKpiCard.vue'
import ChartWidget from '@/modules/stats/components/ChartWidget.vue'
import TimeFilterBar from '@/modules/stats/components/TimeFilterBar.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import { useThemeStore } from '@/modules/shared/stores/theme.store'
import {
   BarChartIcon,
   ShipIcon,
   CalendarClockIcon,
   TimerIcon,
   Loader2Icon,
   DownloadIcon,
   InfoIcon,
   ChevronDownIcon,
   ChevronUpIcon,
   TerminalIcon,
   CopyIcon,
   CheckIcon,
   SearchIcon,
   LayoutListIcon,
   LayoutGridIcon,
   XIcon,
   Maximize2Icon,
   TrendingUpIcon
} from 'lucide-vue-next'
import { statsService, type DashboardStats, type StatsDetailItem, type MareaDistributionItem } from '@/modules/stats/services/stats.service'
import { TipoMarea } from '@/modules/mareas/types/enums'
import { toast } from 'vue-sonner'

const configStore = useConfigStore();
const themeStore = useThemeStore();
const router = useRouter();
const year = computed(() => configStore.selectedYear);
const detailViewMode = computed({
   get: () => configStore.statsDetailViewMode,
   set: (val) => configStore.setStatsDetailViewMode(val)
});

const mode = ref<'CALENDAR' | 'TOTAL'>('CALENDAR');
const protocolizedOnly = ref(false);
const includeOutOfPeriod = ref(false);
const daysCalculationMode = ref<'SHIP' | 'OBSERVER'>('SHIP');
const includeCampaigns = ref(true);

const startDate = ref<string | null>(null);
const endDate = ref<string | null>(null);

const filterType = ref<'FISHERY' | 'FLEET' | 'OBSERVER' | null>(null);
const filterValue = ref<string | null>(null);

const stats = ref<DashboardStats | null>(null);
const distributionData = ref<MareaDistributionItem[]>([]);
const selectedDistributionFishery = ref<string>('ALL');
const loading = ref(false);

// --- Detail Dialogs State ---
const selectedMareaId = ref<string | null>(null);
const isMareaDetailOpen = ref(false);
const vesselsDialogOpen = ref(false);
const vesselsLoading = ref(false);
const monthlyVessels = ref<any[]>([]);
const selectedMonthLabel = ref('');

const openMareaDetail = (mareaId: string) => {
   selectedMareaId.value = mareaId;
   isMareaDetailOpen.value = true;
};

// --- Time Range Constants ---
const timeRange = computed(() => {
   return {
      min: new Date(year.value, 0, 1, 0, 0, 0).getTime(),
      max: new Date(year.value, 11, 31, 23, 59, 59).getTime()
   };
});

// --- Coverage Timeline Logic ---
const coverageSeries = computed(() => {
   const { min: yearStart, max: yearEnd } = timeRange.value;
   const oneDay = 24 * 60 * 60 * 1000;
   
   let filtered = distributionData.value;
   if (selectedDistributionFishery.value !== 'ALL') {
      filtered = filtered.filter(item => item.pesqueria === selectedDistributionFishery.value);
   }

   const data: { x: number, y: number }[] = [];
   
   // Generar puntos diarios
   for (let t = yearStart; t <= yearEnd; t += oneDay) {
      const dayStart = t;
      const dayEnd = t + oneDay - 1;

      const activeVessels = new Set(
         filtered
            .filter(item => {
               const start = new Date(item.fechaZarpada).getTime();
               const end = item.fechaArribo ? new Date(item.fechaArribo).getTime() : Date.now();
               // Un barco está activo ese día si su rango de marea solapa con el rango del día
               return start <= dayEnd && end >= dayStart;
            })
            .map(item => item.buque)
      );
      data.push({ x: t, y: activeVessels.size });
   }

   return [{ name: 'Barcos Activos', data }];
});

const monthlyCoverageSeries = computed(() => {
   let filtered = distributionData.value;
   if (selectedDistributionFishery.value !== 'ALL') {
      filtered = filtered.filter(item => item.pesqueria === selectedDistributionFishery.value);
   }

   const data: { x: number, y: number }[] = [];
   
   for (let m = 0; m < 12; m++) {
      const monthStart = new Date(year.value, m, 1).getTime();
      const monthEnd = new Date(year.value, m + 1, 0, 23, 59, 59, 999).getTime();

      const uniqueVessels = new Set(
         filtered
            .filter(item => {
               const start = new Date(item.fechaZarpada).getTime();
               const end = item.fechaArribo ? new Date(item.fechaArribo).getTime() : Date.now();
               return start <= monthEnd && end >= monthStart;
            })
            .map(item => item.buque)
      );
      
      data.push({
         x: new Date(year.value, m, 15).getTime(),
         y: uniqueVessels.size
      });
   }

   return [{
      name: 'Barcos Mensuales (Únicos)',
      data
   }];
});

const coverageChartOptions = computed(() => {
   const isDark = themeStore.darkMode;
   
   return {
      chart: {
         id: 'coverage-chart',
         group: 'gantt-group',
         type: 'area',
         height: 160,
         sparkline: { enabled: false },
         toolbar: { 
            show: true,
            offsetX: -10,
            offsetY: 0,
            tools: {
               download: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>',
               selection: true,
               zoom: true,
               zoomin: true,
               zoomout: true,
               pan: true,
               reset: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>'
            }
         },
         animations: { enabled: false },
         background: 'transparent',
         fontFamily: 'Inter, sans-serif',
         locales: [{
            name: 'es',
            options: {
               months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
               shortMonths: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
               days: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
               shortDays: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
               toolbar: {
                  exportToSVG: 'Descargar SVG',
                  exportToPNG: 'Descargar PNG',
                  exportToCSV: 'Descargar CSV',
                  selection: 'Selección',
                  selectionZoom: 'Zoom de Selección',
                  zoomIn: 'Acercar',
                  zoomOut: 'Alejar',
                  pan: 'Desplazamiento',
                  reset: 'Restablecer Zoom'
               }
            }
         }],
         defaultLocale: 'es',
         events: {
            click: (event: any, chartContext: any, config: any) => {
               // Evitar disparar el diálogo si se hace clic en la toolbar
               if (event.target?.closest('.apexcharts-toolbar')) return;

               // En este contexto, globals parece estar directamente en config
               const globals = config.globals || config.w?.globals;
               
               let timestamp = globals?.lastXAxisTraversedValue;

               if (!timestamp && config.dataPointIndex !== -1 && globals?.seriesX) {
                  const sIdx = config.seriesIndex >= 0 ? config.seriesIndex : 0;
                  if (globals.seriesX[sIdx]) {
                     timestamp = globals.seriesX[sIdx][config.dataPointIndex];
                  }
               }

               if (timestamp) {
                  const date = new Date(timestamp);
                  const dateStr = date.toISOString().split('T')[0];
                  
                  const type = selectedDistributionFishery.value === 'ALL' ? undefined : 'FISHERY';
                  const value = selectedDistributionFishery.value === 'ALL' ? undefined : selectedDistributionFishery.value;
                  const title = `Barcos Activos: ${date.toLocaleDateString()}`;
                  
                  openDialog(type, value, title, dateStr, dateStr);
               }
            }
         }
      },
      markers: {
         size: 0,
         strokeWidth: 2,
         hover: { size: 6 }
      },
      colors: ['var(--color-primary, #0ea5e9)'],
      fill: {
         type: 'gradient',
         gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.45,
            opacityTo: 0.05,
            stops: [20, 100]
         }
      },
      stroke: { curve: 'smooth', width: 2 },
      xaxis: {
         type: 'datetime',
         min: timeRange.value.min,
         max: timeRange.value.max,
         labels: { show: false },
         axisBorder: { show: false },
         axisTicks: { show: false },
         tooltip: { enabled: false }
      },
      yaxis: {
         tickAmount: 3,
         labels: {
            minWidth: 150,
            maxWidth: 150,
            style: { 
               fontSize: '10px', 
               fontWeight: 600, 
               colors: isDark ? '#94a3b8' : '#64748b' 
            }
         }
      },
      grid: {
         borderColor: 'var(--color-border)',
         opacity: 0.1,
         padding: { bottom: -20, left: 10, right: 10 }
      },
      theme: { mode: isDark ? 'dark' : 'light' },
      tooltip: {
         enabled: true,
         theme: isDark ? 'dark' : 'light',
         x: { format: 'dd MMM yyyy' },
         custom: function({ series, seriesIndex, dataPointIndex, w }: any) {
            const val = series[seriesIndex][dataPointIndex];
            const timestamp = w.globals.seriesX[seriesIndex][dataPointIndex];
            const date = new Date(timestamp).toLocaleDateString('es-AR', {
               day: '2-digit',
               month: 'short',
               year: 'numeric'
            });
            return `
               <div class="px-4 py-3 bg-surface/90 backdrop-blur-md text-text border border-border shadow-2xl rounded-2xl min-w-[180px] animate-in fade-in zoom-in-95 duration-200">
                  <div class="flex items-center justify-between mb-2 pb-2 border-b border-border/50">
                     <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">${date}</span>
                     <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" class="text-primary"><polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/></svg>
                  </div>
                  <div class="flex items-baseline gap-2">
                     <span class="text-2xl font-black text-primary tabular-nums">${val}</span>
                     <span class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Barcos Activos</span>
                  </div>
               </div>
            `;
         }
      },
      dataLabels: { enabled: false }
   };
});

const monthlyCoverageChartOptions = computed(() => {
   const isDark = themeStore.darkMode;
   
   return {
      chart: {
         id: 'monthly-coverage-chart',
         group: 'gantt-group',
         type: 'bar',
         height: 180,
         toolbar: { 
            show: true,
            offsetX: -10,
            offsetY: 0,
            tools: {
               download: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>',
               selection: true,
               zoom: true,
               zoomin: true,
               zoomout: true,
               pan: true,
               reset: '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>'
            }
         },
         animations: { enabled: true },
         fontFamily: 'Inter, sans-serif',
         locales: [{
            name: 'es',
            options: {
               months: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
               shortMonths: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
               days: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
               shortDays: ['Dom', 'Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab'],
               toolbar: {
                  exportToSVG: 'Descargar SVG',
                  exportToPNG: 'Descargar PNG',
                  exportToCSV: 'Descargar CSV',
                  selection: 'Selección',
                  selectionZoom: 'Zoom de Selección',
                  zoomIn: 'Acercar',
                  zoomOut: 'Alejar',
                  pan: 'Desplazamiento',
                  reset: 'Restablecer Zoom'
               }
            }
         }],
         defaultLocale: 'es',
         events: {
            click: (event: any, chartContext: any, config: any) => {
               // Evitar disparar el diálogo si se hace clic en la toolbar
               if (event.target?.closest('.apexcharts-toolbar')) return;
               
               if (config.dataPointIndex === -1) return;
               
               const monthIndex = config.dataPointIndex;
               const start = new Date(year.value, monthIndex, 1);
               const end = new Date(year.value, monthIndex + 1, 0); // Último día del mes
               
               const startStr = start.toISOString().split('T')[0];
               const endStr = end.toISOString().split('T')[0];
               
               const monthName = start.toLocaleDateString('es-AR', { month: 'long', year: 'numeric' });
               openVesselsDialog(monthIndex, monthName);
            }
         }
      },
      plotOptions: {
         bar: {
            borderRadius: 4,
            columnWidth: '50%',
            distributed: false,
            dataLabels: { position: 'top' }
         }
      },
      colors: [isDark ? '#38bdf8' : '#0284c7'],
      xaxis: {
         type: 'datetime',
         min: timeRange.value.min,
         max: timeRange.value.max,
         labels: { 
            style: { 
               colors: isDark ? '#94a3b8' : '#64748b',
               fontSize: '10px'
            }
         },
         axisBorder: { show: false },
         axisTicks: { show: false },
         tooltip: { enabled: false }
      },
      yaxis: {
         tickAmount: 3,
         labels: {
            minWidth: 150,
            maxWidth: 150,
            style: { 
               fontSize: '10px', 
               fontWeight: 600, 
               colors: isDark ? '#94a3b8' : '#64748b' 
            }
         }
      },
      grid: {
         borderColor: 'var(--color-border)',
         opacity: 0.1,
         padding: { top: 10, bottom: 0, left: 10, right: 10 }
      },
      theme: { mode: isDark ? 'dark' : 'light' },
      tooltip: {
         enabled: true,
         theme: isDark ? 'dark' : 'light',
         x: { format: 'MMMM yyyy' },
         custom: function({ series, seriesIndex, dataPointIndex, w }: any) {
            const val = series[seriesIndex][dataPointIndex];
            const timestamp = w.globals.seriesX[seriesIndex][dataPointIndex];
            const dateObj = new Date(timestamp);
            const dateLabel = dateObj.toLocaleDateString('es-AR', {
               month: 'long',
               year: 'numeric'
            });

            // Calcular desglose por flota para este mes
            const m = dateObj.getMonth();
            const monthStart = new Date(year.value, m, 1).getTime();
            const monthEnd = new Date(year.value, m + 1, 0, 23, 59, 59, 999).getTime();

            const fleetCounts: Record<string, Set<string>> = {};
            
            let filtered = distributionData.value;
            if (selectedDistributionFishery.value !== 'ALL') {
               filtered = filtered.filter(item => item.pesqueria === selectedDistributionFishery.value);
            }

            filtered.forEach(item => {
               const start = new Date(item.fechaZarpada).getTime();
               const end = item.fechaArribo ? new Date(item.fechaArribo).getTime() : Date.now();
               
               if (start <= monthEnd && end >= monthStart) {
                  const fleet = item.flota || 'Desconocida';
                  if (!fleetCounts[fleet]) fleetCounts[fleet] = new Set();
                  fleetCounts[fleet].add(item.buque);
               }
            });

            const fleetEntries = Object.entries(fleetCounts)
               .map(([name, set]) => ({ name, count: set.size }))
               .sort((a, b) => b.count - a.count);

            const fleetHtml = `
               <div class="mt-3 pt-3 border-t border-border/50 flex flex-col gap-2">
                  ${fleetEntries.map(f => `
                     <div class="flex items-center justify-between gap-4">
                        <div class="flex items-center gap-2">
                           <span class="w-1.5 h-1.5 rounded-full" style="background: ${getFleetColor(f.name)}"></span>
                           <span class="text-[9px] font-bold text-text-muted uppercase tracking-wider">${f.name}</span>
                        </div>
                        <span class="text-[10px] font-black text-text tabular-nums">${f.count}</span>
                     </div>
                  `).join('')}
               </div>
            `;

            return `
               <div class="px-4 py-3 bg-surface/90 backdrop-blur-md text-text border border-border shadow-2xl rounded-2xl min-w-[200px] animate-in fade-in zoom-in-95 duration-200">
                  <div class="flex items-center justify-between mb-2 pb-2 border-b border-border/50">
                     <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">${dateLabel}</span>
                     <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" class="text-primary-light"><rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>
                  </div>
                  <div class="flex items-baseline gap-2">
                     <span class="text-2xl font-black text-sky-400 tabular-nums">${val}</span>
                     <span class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Barcos Únicos</span>
                  </div>
                  ${fleetHtml}
               </div>
            `;
         }
      },
      dataLabels: {
         enabled: true,
         formatter: (val: number) => val,
         offsetY: -20,
         style: {
            fontSize: '10px',
            colors: [isDark ? '#e2e8f0' : '#1e293b']
         }
      }
   };
});



const dynamicChartHeight = computed(() => {
   let filtered = distributionData.value;
   if (selectedDistributionFishery.value !== 'ALL') {
      filtered = filtered.filter(item => item.pesqueria === selectedDistributionFishery.value);
   }
   const uniqueVessels = new Set(filtered.map(item => item.buque)).size;
   // Base 100px para ejes + 20px por buque. Mínimo 500px.
   return Math.max(500, uniqueVessels * 20 + 100);
});

// --- Fetch Data ---
const dialogOpen = ref(false);
const dialogLoading = ref(false);
const dialogItems = ref<StatsDetailItem[]>([]);
const searchTerm = ref('');

// Quick Detail State (Managed by openMareaDetail)

const sortKey = ref<string>('id_marea');
const sortOrder = ref<'asc' | 'desc'>('asc');

const handleSort = (key: string) => {
   if (sortKey.value === key) {
      sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
   } else {
      sortKey.value = key;
      sortOrder.value = 'asc';
   }
};

const getSortIcon = (key: string) => {
   if (sortKey.value !== key) return ChevronDownIcon;
   return sortOrder.value === 'asc' ? ChevronUpIcon : ChevronDownIcon;
};

const filteredDialogItems = computed(() => {
   let items = [...dialogItems.value];

   // Filtering
   if (searchTerm.value) {
      const s = searchTerm.value.toLowerCase();
      items = items.filter(m =>
         m.id_marea.toLowerCase().includes(s) ||
         m.buque.toLowerCase().includes(s) ||
         m.flota.toLowerCase().includes(s) ||
         m.observador.toLowerCase().includes(s) ||
         m.pesqueria.toLowerCase().includes(s)
      );
   }

   // Sorting
   items.sort((a: StatsDetailItem, b: StatsDetailItem) => {
      // Special case for marea code: sort by year then number numerically
      if (sortKey.value === 'id_marea') {
         if (a.anioMarea !== b.anioMarea) {
            return sortOrder.value === 'asc'
               ? a.anioMarea - b.anioMarea
               : b.anioMarea - a.anioMarea;
         }
         return sortOrder.value === 'asc'
            ? a.nroMarea - b.nroMarea
            : b.nroMarea - a.nroMarea;
      }

      const valA = (a as any)[sortKey.value];
      const valB = (b as any)[sortKey.value];

      if (typeof valA === 'string') {
         return sortOrder.value === 'asc'
            ? valA.localeCompare(valB)
            : valB.localeCompare(valA);
      }

      return sortOrder.value === 'asc' ? (valA as number) - (valB as number) : (valB as number) - (valA as number);
   });

   return items;
});
const dialogTitle = ref('');

// Ranking Full View State
const rankingModalOpen = ref(false);
const rankingSearch = ref('');
const fullObserverRanking = computed(() => {
   if (!stats.value) return [];
   let items = [...stats.value.observers];
   if (rankingSearch.value) {
      const s = rankingSearch.value.toLowerCase();
      items = items.filter(o => o.name.toLowerCase().includes(s));
   }
   return items;
});

const openObserverDetail = (obs: any) => {
   rankingModalOpen.value = false;
   openDialog('OBSERVER', obs.id, obs.name);
};

// --- Criteria Logic ---
// ... (previous criteria logic) ...
const isCriteriaOpen = ref(false);
const criteriaList = computed(() => {
   // ... (existing computed body) ...
   const list: string[] = [];
   const yearText = `<span class="font-bold text-text">${year.value}</span>`;
   if (mode.value === 'CALENDAR') {
      list.push(`Periodo Analizado: <strong>Calendario ${yearText}</strong> (01/Ene - 31/Dic). Solo se contabilizan los días de navegación ocurridos estrictamente dentro de este rango.`);
   } else {
      list.push(`Periodo Analizado: <strong>Total Marea ${yearText}</strong>. Se incluyen mareas completas que hayan tenido actividad durante el año, sumando la totalidad de sus días.`);
   }
   if (daysCalculationMode.value === 'SHIP') {
      list.push(`Métrica: <strong>Días de Buque</strong>. Días únicos que la embarcación estuvo operando, sin multiplicar por observadores embarcados.`);
   } else {
      list.push(`Métrica: <strong>Días de Observador</strong>. Suma del esfuerzo individual (Observador Principal recibe el total de la marea; adicionales reciben los días de sus etapas).`);
   }
   if (protocolizedOnly.value) {
      let text = `Estado: <strong>Solo Protocolizadas</strong>.`;
      if (includeOutOfPeriod.value) {
         text += ` Se incluyen además mareas protocolizadas en ${yearText} aunque hayan finalizado antes (Fuera de Periodo).`;
      }
      list.push(text);
   } else {
      list.push(`Estado: <strong>Todas las mareas</strong> (Protocolizadas y En Proceso).`);
   }
   if (includeCampaigns.value) {
      list.push(`Tipo: Incluye mareas comerciales y <strong>Campañas Institucionales</strong>.`);
   } else {
      list.push(`Tipo: <strong>Excluye</strong> Campañas Institucionales.`);
   }
   if (filterType.value && filterValue.value) {
      let typeLabel = '';
      if (filterType.value === 'FISHERY') typeLabel = 'Pesquería';
      if (filterType.value === 'FLEET') typeLabel = 'Flota';
      if (filterType.value === 'OBSERVER') typeLabel = 'Observador';
      list.push(`Filtro Activo: <strong>${typeLabel}</strong> ${dialogTitle.value ? `(${dialogTitle.value.replace('Detalle: ', '')})` : ''}.`);
   }
   if (startDate.value || endDate.value) {
      const start = startDate.value ? new Date(startDate.value).toLocaleDateString() : 'Inicio del año';
      const end = endDate.value ? new Date(endDate.value).toLocaleDateString() : 'Fin del año';
      list.push(`Rango de Tiempo: <strong>${start} - ${end}</strong>.`);
   }
   return list;
});

// --- Fetch Data ---
const fetchData = async () => {
   loading.value = true;
   try {
      const [newStats, distribution] = await Promise.all([
         statsService.getDashboardStats(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            daysCalculationMode.value,
            includeCampaigns.value,
            startDate.value || undefined,
            endDate.value || undefined
         ),
         statsService.getMareaDistribution(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            includeCampaigns.value,
            startDate.value || undefined,
            endDate.value || undefined
         )
      ]);
      stats.value = newStats;
      distributionData.value = distribution;
   } catch (error) {
      console.error('Error fetching stats:', error);
      toast.error('Error al cargar estadísticas');
   } finally {
      loading.value = false;
   }
};

// --- Gantt Chart Logic ---
const fisheryColors: Record<string, string> = {
   'CALAMAR': '#3B82F6',       // Blue 500
   'LANGOSTINO': '#EF4444',    // Red 500
   'MERLUZA': '#10B981',       // Emerald 500
   'VIEIRA': '#F59E0B',        // Amber 500
   'CENTOLLA': '#8B5CF6',      // Violet 500
   'VARIADO COSTERO': '#EC4899', // Pink 500
};

const getFisheryColor = (name: string) => {
   const normalized = name.toUpperCase();
   for (const key in fisheryColors) {
      if (normalized.includes(key)) return fisheryColors[key];
   }
   return '#64748B'; // Slate 500 (Default)
};

const ganttFisheries = computed(() => {
   const set = new Set(distributionData.value.map(item => item.pesqueria));
   return Array.from(set).sort();
});

const ganttSeries = computed(() => {
   let filtered = distributionData.value;
   if (selectedDistributionFishery.value !== 'ALL') {
      filtered = filtered.filter(item => item.pesqueria === selectedDistributionFishery.value);
   }

   const yearStart = new Date(Date.UTC(year.value, 0, 1, 0, 0, 0, 0)).getTime();
   const seriesData: any[] = [];

   filtered.forEach(item => {
      const start = new Date(item.fechaZarpada).getTime();
      const end = item.fechaArribo ? new Date(item.fechaArribo).getTime() : Date.now();
      const baseColor = getFisheryColor(item.pesqueria);

      // Si estamos en modo TOTAL y el segmento cruza el inicio del año
      if (mode.value === 'TOTAL' && start < yearStart && end > yearStart) {
         // Segmento Año Anterior (Desaturado)
         seriesData.push({
            x: item.buque,
            y: [start, yearStart],
            fillColor: baseColor + '40', // 25% opacidad para desaturar
            meta: { ...item, isPreviousYear: true }
         });
         // Segmento Año Actual (Normal)
         seriesData.push({
            x: item.buque,
            y: [yearStart, end],
            fillColor: baseColor,
            meta: { ...item, isPreviousYear: false }
         });
      } else {
         // Segmento único (Normal o Año Anterior Completo)
         let color = baseColor;
         if (mode.value === 'TOTAL' && end <= yearStart) {
            color = baseColor + '40';
         }

         seriesData.push({
            x: item.buque,
            y: [start, end],
            fillColor: color,
            meta: { ...item, isPreviousYear: end <= yearStart }
         });
      }
   });

   return [{ data: seriesData }];
});

const ganttChartOptions = computed(() => ({
   chart: {
      id: 'gantt-chart',
      group: 'gantt-group',
      type: 'rangeBar',
      height: 450,
      fontFamily: 'Inter, sans-serif',
      toolbar: {
         show: true,
         tools: {
            download: true
         }
      },
      events: {
         dataPointSelection: (event: any, chartContext: any, config: any) => {
            const meta = config.w.config.series[config.seriesIndex].data[config.dataPointIndex].meta;
            if (meta && meta.mareaId) {
               openMareaDetail(meta.mareaId);
            }
         }
      },
      animations: {
         enabled: true,
         easing: 'easeinout',
         speed: 800,
         animateGradually: {
            enabled: true,
            delay: 150
         },
         dynamicAnimation: {
            enabled: true,
            speed: 350
         }
      }
   },
   plotOptions: {
      bar: {
         horizontal: true,
         barHeight: '75%',
         rangeBarGroupRows: true,
         borderRadius: 4
      }
   },
   xaxis: {
      type: 'datetime',
      min: timeRange.value.min,
      max: timeRange.value.max,
      labels: {
         datetimeUTC: false,
         style: {
            fontSize: '10px',
            fontWeight: 600,
            colors: 'var(--text-muted)'
         }
      }
   },
   yaxis: {
      labels: {
         minWidth: 150,
         maxWidth: 150,
         style: {
            fontSize: '11px',
            fontWeight: 700,
            colors: 'var(--text)'
         }
      }
   },
   tooltip: {
      custom: function ({ series, seriesIndex, dataPointIndex, w }: any) {
         const meta = w.config.series[seriesIndex].data[dataPointIndex].meta;
         const start = new Date(meta.fechaZarpada).toLocaleDateString();
         const end = meta.fechaArribo ? new Date(meta.fechaArribo).toLocaleDateString() : 'En curso';

         return `
                <div class="tooltip-gantt p-3 bg-surface border border-border rounded-lg shadow-xl min-w-[220px]">
                    <div class="flex items-center gap-2 mb-2 pb-2 border-b border-border/50">
                        <span class="font-black text-primary tabular-nums text-sm">${meta.id_marea}</span>
                        <div class="flex flex-col items-end ml-auto">
                           <span class="text-[9px] font-bold text-text-muted uppercase tracking-widest bg-surface-muted px-2 py-0.5 rounded border border-border">Etapa ${meta.nroEtapa}</span>
                           ${meta.isPreviousYear ? '<span class="text-[7px] font-black text-amber-500 uppercase mt-1">Días Año Anterior</span>' : ''}
                        </div>
                    </div>
                    <div class="space-y-2 text-[11px]">
                        <div class="flex justify-between items-center bg-surface-muted/30 p-1.5 rounded">
                            <span class="text-text-muted font-bold uppercase text-[9px]">Pesquería</span>
                            <span class="font-bold text-text">${meta.pesqueria}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-text-muted">Observador:</span>
                            <span class="font-bold text-text">${meta.observador}</span>
                        </div>
                        <div class="mt-2 pt-2 border-t border-border/30 grid grid-cols-2 gap-4">
                             <div>
                                <span class="block text-[8px] uppercase tracking-tighter text-text-muted mb-0.5 font-black opacity-60">Zarpada</span>
                                <span class="font-bold text-text">${start}</span>
                             </div>
                             <div class="text-right">
                                <span class="block text-[8px] uppercase tracking-tighter text-text-muted mb-0.5 font-black opacity-60">Arribo</span>
                                <span class="font-bold ${meta.fechaArribo ? 'text-text' : 'text-primary animate-pulse'}">${end}</span>
                             </div>
                        </div>
                    </div>
                </div>
            `;
      }
   },
   grid: {
      borderColor: 'var(--border)',
      opacity: 0.1,
      xaxis: {
         lines: {
            show: true
         }
      },
      padding: { left: 10, right: 10 }
   },
   noData: {
      text: 'No hay datos de distribución para el periodo',
      style: {
         color: 'var(--text-muted)',
         fontSize: '14px',
         fontFamily: 'Inter'
      }
   }
}));

// --- Watchers ---
watch([year, mode, protocolizedOnly, includeOutOfPeriod, daysCalculationMode, includeCampaigns, startDate, endDate], () => {
   fetchData();
});

const handleTimeFilter = (filter: { startDate: string | null, endDate: string | null }) => {
   startDate.value = filter.startDate;
   endDate.value = filter.endDate;
};

// --- Dialog Logic ---
const openDialog = async (type?: 'FISHERY' | 'FLEET' | 'OBSERVER', value?: string, titleName?: string, filterStart?: string, filterEnd?: string) => {
   filterType.value = type || null;
   filterValue.value = value || null; // NOW value is correct: Name for Fishery/Fleet, UUID for Observer

   dialogTitle.value = titleName || ''; // Use provided name for title or "Detalle: ${titleName}" 
   if (!filterStart && titleName) dialogTitle.value = `Detalle: ${titleName}`;
   
   dialogOpen.value = true;
   dialogLoading.value = true;

   try {
      dialogItems.value = await statsService.getDashboardStatsDetail(
         year.value,
         mode.value,
         !protocolizedOnly.value,
         includeOutOfPeriod.value,
         daysCalculationMode.value,
         includeCampaigns.value,
         type,
         value,
         startDate.value || undefined, // Use dashboard period for effort calculation
         endDate.value || undefined,
         filterStart,                 // Use optional drill-down for list filtering
         filterEnd
      );
   } catch (error) {
      console.error('Error loading detail:', error);
      toast.error('No se pudo cargar el detalle.');
   } finally {
      dialogLoading.value = false;
   }
};
const closeDialog = () => {
   dialogOpen.value = false;
   filterType.value = null;
   filterValue.value = null;
   searchTerm.value = '';
};


// --- Click Handlers ---
const handleFisheryClick = ({ seriesIndex, dataPointIndex, w }: any) => {
   // En el Donut (Participación), usamos dataPointIndex (serie única).
   // En el Scatter (Perfil Operativo), usamos seriesIndex (una serie por pesquería).
   const isScatter = w?.config?.chart?.type === 'scatter';
   const index = isScatter ? seriesIndex : dataPointIndex;

   const item = stats.value?.fisheries[index];
   if (item) openDialog('FISHERY', item.name, item.name);
};

const handleFleetClick = ({ dataPointIndex }: any) => {
   const item = stats.value?.fleets[dataPointIndex];
   if (item) openDialog('FLEET', item.name, item.name);
};

const handleObserverClick = ({ dataPointIndex }: any) => {
   const item = stats.value?.observers[dataPointIndex];
   if (item) openDialog('OBSERVER', item.id, item.name);
}

// --- Vessels by Month Logic ---
const openVesselsDialog = async (monthIndex: number, label: string) => {
   selectedMonthLabel.value = label;
   vesselsDialogOpen.value = true;
   vesselsLoading.value = true;

   const type = selectedDistributionFishery.value === 'ALL' ? undefined : ('FISHERY' as const);
   const value = selectedDistributionFishery.value === 'ALL' ? undefined : selectedDistributionFishery.value;

   try {
      monthlyVessels.value = await statsService.getVesselsByMonth(
         Number(year.value),
         Number(monthIndex),
         Boolean(!protocolizedOnly.value),
         Boolean(includeOutOfPeriod.value),
         Boolean(includeCampaigns.value),
         type,
         value
      );
   } catch (error) {
      console.error('Error loading monthly vessels:', error);
      toast.error('No se pudo cargar el detalle de buques.');
   } finally {
      vesselsLoading.value = false;
   }
};

// --- Download Handler ---
const handleDownload = async (titlePrefix: string, fType?: 'FISHERY' | 'FLEET' | 'OBSERVER') => {
   const fValue = filterValue.value || undefined;
   const fTypeParam = fType || filterType.value || undefined;

   let finalTitle = titlePrefix;
   if (dialogOpen.value && dialogTitle.value) {
      // Sanitize dialog title for filename: remove special characters and replace spaces with underscores
      const sanitizedDataName = dialogTitle.value
         .normalize("NFD").replace(/[\u0300-\u036f]/g, "") // remove accents
         .replace(/\s+/g, '_')
         .replace(/[^a-zA-Z0-9_]/g, '');
      finalTitle = sanitizedDataName;
   } else if (fValue) {
      finalTitle = `${titlePrefix}_${fValue.substring(0, 8)}`;
   }

   try {
      await statsService.downloadExport(
         year.value,
         mode.value,
         !protocolizedOnly.value,
         includeOutOfPeriod.value,
         daysCalculationMode.value,
         includeCampaigns.value,
         fTypeParam,
         fValue, // PASSING UNDEFINED IF NULL
         `${finalTitle}_${mode.value === 'CALENDAR' ? year.value : 'TOTAL'}`,
         startDate.value || undefined,
         endDate.value || undefined
      );
      const prettyTitle = (dialogOpen.value && dialogTitle.value) ? dialogTitle.value : 'Estadísticas Generales';
      toast.success(`Exportación iniciada: ${prettyTitle}`);
   } catch (error) {
      console.error('Download error:', error);
      toast.error('Error al exportar archivo');
   }
}

const getFleetColor = (name: string) => {
   if (name.toUpperCase().includes('FRESQUERO')) return 'var(--color-info)';
   if (name.toUpperCase().includes('CONGELADOR')) return 'var(--color-warning)';
   return 'var(--color-primary)';
}

onMounted(() => {
   fetchData()
})

// --- CHART COMPUTED PROPS ---

// 1. Monthly Trends (Mixed Chart)
const monthlySeries = computed(() => {
   if (!stats.value) return []
   return [
      { name: 'Mareas Iniciadas', type: 'column', data: stats.value.monthly.mareas },
      { name: 'Días Navegados', type: 'line', data: stats.value.monthly.days }
   ]
})
const monthlyChartOptions = computed(() => ({
   labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
   colors: ['#0ea5e9', '#f59e0b'],
   stroke: { width: [0, 3] },
   plotOptions: { bar: { borderRadius: 4, columnWidth: '50%' } },
   yaxis: [
      { title: { text: 'Mareas' } },
      { opposite: true, title: { text: 'Días' } }
   ]
}))

// 2. Fleet Distribution (Donut)
const fleetSort = computed(() => stats.value?.fleets.slice(0, 5) || []) // Top 5
const fleetSeries = computed(() => fleetSort.value.map(f => f.days))
const fleetChartOptions = computed(() => ({
   labels: fleetSort.value.map(f => f.name),
   dataLabels: { enabled: false },
   plotOptions: { pie: { donut: { size: '65%' } } }
}))

// 3. Fishery Distribution (Pie)
const fisherySort = computed(() => stats.value?.fisheries.slice(0, 7) || []) // Top 7
const fisherySeries = computed(() => fisherySort.value.map(f => f.days))
const fisheryChartOptions = computed(() => ({
   labels: fisherySort.value.map(f => f.name),
   tooltip: {
      custom: ({ series, seriesIndex, w }: any) => {
         const val = series[seriesIndex];
         const label = w.globals.labels[seriesIndex];
         const item = fisherySort.value[seriesIndex];
         const colors = w.globals.colors;
         const accent = colors[seriesIndex] || 'var(--color-primary)';

         return `
            <div class="px-4 py-3 bg-surface/95 backdrop-blur-md text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/5 min-w-[180px]">
               <div class="flex items-center gap-2 border-b border-border/30 pb-2">
                  <span class="w-1.5 h-3 rounded-full" style="background:${accent}"></span>
                  <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
               </div>
               
               ${item.stats && Object.keys(item.stats).length > 1 ? `
                  <div class="flex flex-col gap-2">
                     ${Object.entries(item.stats).map(([_, stat]: any) => `
                        <div class="flex items-center justify-between gap-4">
                           <div class="flex items-center gap-1.5">
                              <div class="w-1.5 h-1.5 rounded-full" style="background:${getFleetColor(stat.nombre)}"></div>
                              <span class="text-[9px] font-bold text-text-muted uppercase">${stat.nombre}</span>
                           </div>
                           <span class="text-[10px] font-black text-text">${stat.count} <span class="text-[8px] opacity-60">buques</span></span>
                        </div>
                     `).join('')}
                  </div>
               ` : ''}

               <div class="flex items-center justify-between pt-1 ${item.stats && Object.keys(item.stats).length > 1 ? 'border-t border-border/30' : ''}">
                  <span class="text-[9px] font-black text-primary uppercase">Total Esfuerzo</span>
                  <div class="flex items-baseline gap-1">
                     <span class="text-xs font-black text-text">${val}</span>
                     <span class="text-[9px] font-bold text-text-muted">días</span>
                  </div>
               </div>
            </div>
         `;
      }
   }
}))

// 4. Observer Ranking (Bar Horizontal)
const observerSort = computed(() => stats.value?.observers.slice(0, 10) || []) // Top 10
const observerSeries = computed(() => ([{
   name: 'Días Navegados',
   data: observerSort.value.map(o => o.days)
}]))
const observerChartOptions = computed(() => ({
   plotOptions: {
      bar: { horizontal: true, borderRadius: 4, barHeight: '60%' }
   },
   xaxis: { categories: observerSort.value.map(o => o.name) },
   colors: ['#8b5cf6']
}))

// 5. Dual Axis Fishery Chart (Mareas vs Days) - Shows ALL (or Top 20) for detail
const fisheryDetailData = computed(() => stats.value?.fisheries || []);

const fisheryDualAxisSeries = computed(() => {
   const data = fisheryDetailData.value;
   return [
      {
         name: 'Mareas Iniciadas',
         type: 'column',
         data: data.map(f => f.mareas)
      },
      {
         name: 'Días Navegados',
         type: 'column',
         data: data.map(f => f.days)
      }
   ];
});

const fisheryDualAxisOptions = computed(() => ({
   chart: {
      type: 'bar', // Combined chart type
      stacked: false,
      toolbar: { show: true }, // Allow zoom/pan for many items
      zoom: { enabled: true }
   },
   stroke: {
      width: [0, 0], // No stroke for bars
      curve: 'smooth'
   },
   plotOptions: {
      bar: {
         columnWidth: '70%', // Thicker bars
         borderRadius: 2 // Less rounded
      }
   },
   dataLabels: {
      enabled: false, // Clean look
   },
   xaxis: {
      categories: fisheryDetailData.value.map(f => f.name),
   },
   yaxis: [
      {
         seriesName: 'Mareas Iniciadas',
         axisTicks: { show: true },
         axisBorder: { show: true, color: '#0ea5e9' },
         labels: { style: { colors: '#0ea5e9', fontWeight: 700 } },
         title: { text: 'Cantidad de Mareas', style: { color: '#0ea5e9', fontWeight: 800 } }
      },
      {
         opposite: true,
         seriesName: 'Días Navegados',
         axisTicks: { show: true },
         axisBorder: { show: true, color: '#f59e0b' },
         labels: { style: { colors: '#f59e0b', fontWeight: 700 } },
         title: { text: 'Días Totales', style: { color: '#f59e0b', fontWeight: 800 } }
      }
   ],
   colors: ['#0ea5e9', '#f59e0b'], // Primary Blue, Secondary Orange
   tooltip: {
      shared: true,
      intersect: false,
      theme: 'dark', // Force dark for contrast
      x: { show: true },
      y: {
         formatter: (val: number, opts: any) => {
            const unit = opts.seriesIndex === 0 ? 'mareas' : 'días';
            return `${val} ${unit}`;
         }
      },
      custom: undefined
   }
}));

// 6. Operational Profile Chart (Scatter: Mareas vs Days)
const fisheryProfileSeries = computed(() => {
   // One series per fishery to enable distinct colors and legends automatically
   return fisheryDetailData.value.map(f => ({
      name: f.name,
      data: [{
         x: f.mareas,
         y: f.days
      }]
   }));
});

const fisheryProfileOptions = computed(() => ({
   chart: {
      type: 'scatter',
      zoom: { enabled: true, type: 'xy' },
      toolbar: { show: true }
   },
   legend: {
      show: true,
      position: 'bottom',
      horizontalAlign: 'center',
      fontSize: '10px',
      fontFamily: 'Inter, sans-serif',
      fontWeight: 600,
      labels: { colors: 'var(--color-text-muted)' },
      markers: { radius: 12, size: 6 },
      itemMargin: { horizontal: 10, vertical: 5 }
   },
   xaxis: {
      title: {
         text: 'CANTIDAD DE MAREAS (FRECUENCIA)',
         style: { color: 'var(--color-text-muted)', fontSize: '10px', fontWeight: 800 }
      },
      tickAmount: 5,
      labels: {
         style: { colors: 'var(--color-text-muted)', fontWeight: 600 },
         formatter: (val: number) => Math.floor(val)
      }
   },
   yaxis: {
      title: {
         text: 'DÍAS NAVEGADOS (ESFUERZO)',
         style: { color: 'var(--color-text-muted)', fontSize: '10px', fontWeight: 800 }
      },
      labels: {
         style: { colors: 'var(--color-text-muted)', fontWeight: 600 },
         formatter: (val: number) => Math.floor(val)
      }
   },
   markers: {
      size: 9,
      strokeWidth: 2,
      strokeOpacity: 0.8,
      fillOpacity: 0.7,
      hover: { size: 11 }
   },
   // Diverse premium color palette
   colors: ['#0ea5e9', '#8b5cf6', '#10b981', '#f59e0b', '#ef4444', '#ec4899', '#6366f1', '#14b8a6', '#f43f5e', '#84cc16', '#22c55e', '#a855f7'],
   grid: {
      borderColor: 'var(--color-border)',
      opacity: 0.1,
      strokeDashArray: 4,
      xaxis: { lines: { show: true } },
      yaxis: { lines: { show: true } }
   },
   tooltip: {
      custom: ({ series, seriesIndex, dataPointIndex, w }: any) => {
         const data = w.config.series[seriesIndex].data[dataPointIndex];
         const name = w.config.series[seriesIndex].name;
         const color = w.globals.colors[seriesIndex];

         return `
           <div class="px-4 py-3 bg-surface text-text border border-border rounded-xl flex flex-col gap-1 shadow-2xl min-w-[200px]">
             <div class="flex items-center gap-2 border-b border-border pb-1.5 mb-1.5">
               <span class="w-2.5 h-2.5 rounded-full" style="background:${color}"></span>
               <span class="text-[10px] font-black text-text uppercase tracking-widest">${name}</span>
             </div>
             <div class="flex justify-between items-center gap-4">
               <span class="text-text-muted text-[10px] font-bold uppercase tracking-tighter">Frecuencia:</span>
               <span class="text-text font-black text-xs tabular-nums">${data.x} Mareas</span>
             </div>
             <div class="flex justify-between items-center gap-4">
               <span class="text-text-muted text-[10px] font-bold uppercase tracking-tighter">Esfuerzo:</span>
               <span class="text-text font-black text-xs tabular-nums">${data.y} Días</span>
             </div>
             <div class="mt-2 pt-1.5 border-t border-border/50 flex justify-between items-center">
                <span class="text-text-muted text-[9px] font-black italic uppercase">Intensidad:</span>
                <span class="text-primary font-black text-[11px] tabular-nums">${(data.y / data.x).toFixed(1)} días/marea</span>
             </div>
           </div>
         `;
      }
   }
}));

</script>

<style scoped>
.animate-in {
   animation-duration: 0.7s;
   animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}

.fade-in {
   animation-name: fade-in;
}

@keyframes fade-in {
   from {
      opacity: 0;
      transform: translateY(10px);
   }

   to {
      opacity: 1;
      transform: translateY(0);
   }
}
</style>
