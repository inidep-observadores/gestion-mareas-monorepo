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
                  <ChartWidget title="Tendencia Mensual" subtitle="Evolución de Días Navegados por mes" type="area"
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

            <!-- ROW 5: TEMPORAL DISTRIBUTION (GANTT) -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12">
                  <ChartWidget title="Cronograma de Distribución de Mareas"
                     subtitle="Distribución temporal de mareas y etapas por buque" type="rangeBar" :series="ganttSeries"
                     :options="ganttChartOptions" :chart-height="dynamicChartHeight"
                     chart-container-class="max-h-[700px] overflow-y-auto custom-scrollbar" allow-download
                     @dataPointClick="handleGanttClick" @download="handleDownload('Distribucion_Temporal_Gantt')">
                     <template #header-action>
                        <div class="flex items-center gap-2">
                           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Filtrar
                              Pesquería:</span>
                           <select v-model="selectedDistributionFishery"
                              class="bg-surface border border-border rounded-lg px-3 py-1 text-xs font-bold text-text focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none">
                              <option value="ALL">Todas las Pesquerías</option>
                              <option v-for="f in ganttFisheries" :key="f" :value="f">{{ f }}</option>
                           </select>
                        </div>
                     </template>
                  </ChartWidget>
               </div>
            </section>

            <!-- ROW 6: MONTHLY COVERAGE (UNIQUE VESSELS) -->
            <section class="grid grid-cols-12 gap-8">
               <div class="col-span-12">
                  <ChartWidget title="Cobertura de Buques" subtitle="Cantidad de buques únicos cubiertos por mes"
                     type="bar" :series="coverageSeries" :options="coverageChartOptions" :chart-height="450"
                     allow-download @download="handleDownload('Cobertura_Buques_Mensual')">
                     <template #header-action>
                        <div class="flex items-center gap-2">
                           <span class="text-[10px] font-black text-text-muted uppercase tracking-widest">Filtrar
                              Pesquería:</span>
                           <select v-model="selectedCoverageFishery"
                              class="bg-surface border border-border rounded-lg px-3 py-1 text-xs font-bold text-text focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none">
                              <option value="ALL">Todas las Pesquerías</option>
                              <option v-for="f in ganttFisheries" :key="f" :value="f">{{ f }}</option>
                           </select>
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
                  <div v-if="loadingDetail" class="flex justify-center items-center h-full">
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
                        <div v-for="marea in filteredDialogItems" :key="marea.id" @click="openQuickDetail(marea.id)"
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
                                       Date(marea.fechaInicio).toLocaleDateString('es-AR', { timeZone: 'UTC' }) : '-'
                                    }}</span>
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
                                    @click="handleSort(dialogPeriodLabel ? 'diasPeriodo' : (mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales'))">
                                    <div class="flex items-center justify-end gap-2">
                                       Días {{ dialogPeriodLabel || (mode === 'CALENDAR' ? year : 'Tot.') }}
                                       <component
                                          :is="getSortIcon(dialogPeriodLabel ? 'diasPeriodo' : (mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales'))"
                                          class="w-3 h-3 text-primary opacity-0 group-hover:opacity-100"
                                          :class="{ 'opacity-100': sortKey === (dialogPeriodLabel ? 'diasPeriodo' : (mode === 'CALENDAR' ? 'diasCalendario' : 'diasTotales')) }" />
                                    </div>
                                 </th>
                                 <th v-if="mode === 'CALENDAR' && !dialogPeriodLabel"
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
                                 @click="openQuickDetail(marea.id)"
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
                                       :class="['font-black text-sm tabular-nums', (mode === 'CALENDAR' || dialogPeriodLabel) ? 'text-primary' : 'text-text']">
                                       {{ dialogPeriodLabel ? marea.diasPeriodo : (mode === 'CALENDAR' ?
                                          marea.diasCalendario :
                                          marea.diasTotales) }}
                                    </span>
                                 </td>
                                 <td v-if="mode === 'CALENDAR' && !dialogPeriodLabel" class="px-4 py-2 text-right">
                                    <span class="font-bold text-xs text-text-muted tabular-nums opacity-80">{{
                                       marea.diasTotales
                                       }}</span>
                                 </td>
                              </tr>
                           </tbody>
                           <!-- Footer Totales -->
                           <tfoot v-if="filteredDialogItems.length > 0" class="sticky bottom-0 z-10">
                              <tr
                                 class="bg-background/95 backdrop-blur-md border-t-2 border-primary/20 shadow-[0_-4px_12px_rgba(0,0,0,0.1)]">
                                 <td :colspan="filterType !== 'OBSERVER' ? 5 : 4"
                                    class="px-4 py-3 text-right text-[10px] font-black text-text-muted uppercase tracking-widest">
                                    Totales Seleccionados
                                 </td>
                                 <td class="px-4 py-3 text-right bg-primary/5">
                                    <span class="font-black text-sm tabular-nums text-primary">
                                       {{ dialogPeriodLabel ? totalDiasPeriodo : (mode === 'CALENDAR' ?
                                          totalDiasCalendario :
                                          totalDiasTotales) }}
                                    </span>
                                 </td>
                                 <td v-if="mode === 'CALENDAR' && !dialogPeriodLabel"
                                    class="px-4 py-3 text-right bg-text/5">
                                    <span class="font-black text-xs text-text-muted tabular-nums opacity-80">
                                       {{ totalDiasTotales }}
                                    </span>
                                 </td>
                              </tr>
                           </tfoot>
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

         <!-- Individual Marea Quick Detail -->
         <MareaQuickDetailModal :is-open="quickDetailOpen" :marea-id="selectedMareaId"
            @close="quickDetailOpen = false" />

         <!-- FULL OBSERVER RANKING DIALOG -->
         <BaseModal :show="rankingModalOpen" maxWidth="4xl" @close="rankingModalOpen = false">
            <template #title>
               <div class="flex items-center gap-3">
                  <div class="p-2 bg-primary/10 rounded-lg text-primary">
                     <TrendingUpIcon class="w-5 h-5" />
                  </div>
                  <div>
                     <span
                        class="text-sm font-black text-text uppercase tracking-tight leading-none block mb-0.5">Ranking
                        Completo de Observadores</span>
                     <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">{{ year }} • {{
                        mode === 'CALENDAR' ? 'Periodo' : 'Total' }}</p>
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
import { planificacionService } from '@/modules/planificacion/services/planificacion.service'
import type { RequerimientoCobertura } from '@/modules/planificacion/interfaces/planificacion.interfaces'
import { TipoMarea } from '@/modules/mareas/types/enums'
import { toast } from 'vue-sonner'

type FilterType = 'FISHERY' | 'FLEET' | 'OBSERVER';

const configStore = useConfigStore();
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
const filterType = ref<FilterType | null>(null);
const filterValue = ref<string | null>(null);
const loading = ref(false);
const selectedCoverageFishery = ref<string>('ALL');

const stats = ref<DashboardStats | null>(null);
const distributionData = ref<MareaDistributionItem[]>([]);
const coverageData = ref<{ month: number, count: number, days: number, fleets: { name: string, count: number, days: number }[] }[]>([]);
const requerimientosData = ref<RequerimientoCobertura[]>([]);
const selectedDistributionFishery = ref<string>('ALL');

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
// (Variables moved to Dialog State)

// Quick Detail State
const quickDetailOpen = ref(false);
const selectedMareaId = ref<string | null>(null);

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

const searchTerm = ref(''); // Moved from dialog state

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

const totalDiasPeriodo = computed(() => {
   return filteredDialogItems.value.reduce((acc, item) => acc + (item.diasPeriodo || 0), 0);
});

const totalDiasCalendario = computed(() => {
   return filteredDialogItems.value.reduce((acc, item) => acc + (item.diasCalendario || 0), 0);
});

const totalDiasTotales = computed(() => {
   return filteredDialogItems.value.reduce((acc, item) => acc + (item.diasTotales || 0), 0);
});

// const dialogTitle = ref(''); // This was duplicated, removed.
const isMonthlyDetail = computed(() => {
   if (!dialogFilterType.value && dialogStartDate.value && dialogEndDate.value) {
      // If it's coverage, it usually has no filterType but has specific dates
      return true;
   }
   return false;
});

const dialogPeriodLabel = computed(() => {
   if (!dialogStartDate.value || !dialogEndDate.value) return '';

   // Parse YYYY-MM-DD strings directly as UTC to avoid local timezone shifts
   const [sYear, sMonth, sDay] = dialogStartDate.value.split('T')[0].split('-').map(Number);
   const [eYear, eMonth, eDay] = dialogEndDate.value.split('T')[0].split('-').map(Number);

   const start = new Date(Date.UTC(sYear, sMonth - 1, sDay));
   const end = new Date(Date.UTC(eYear, eMonth - 1, eDay));

   if (start.getUTCMonth() === end.getUTCMonth() && start.getUTCFullYear() === end.getUTCFullYear()) {
      return start.toLocaleDateString('es-AR', { month: 'long', timeZone: 'UTC' });
   }
   return '';
});

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
   const list: string[] = [];
   const yearText = `<span class="font-bold text-text">${year.value}</span>`;

   // Formateo dinámico del rango para la leyenda
   const formatDate = (dateStr: string | null, defaultValue: string) => {
      if (!dateStr) return defaultValue;
      const cleanDate = dateStr.split('T')[0];
      const [y, m, d] = cleanDate.split('-').map(Number);
      const date = new Date(Date.UTC(y, m - 1, d));
      if (isNaN(date.getTime())) return defaultValue;
      return date.toLocaleDateString('es-AR', { day: '2-digit', month: 'short', timeZone: 'UTC' });
   };

   const start = formatDate(startDate.value, '01/Ene');
   const end = formatDate(endDate.value, '31/Dic');
   const periodRange = `(${start} - ${end})`;

   if (mode.value === 'CALENDAR') {
      list.push(`Periodo Analizado: <strong>Calendario ${yearText} ${periodRange}</strong>. Solo se contabilizan los días de navegación ocurridos estrictamente dentro de este rango.`);
   } else {
      list.push(`Periodo Analizado: <strong>Total Marea ${yearText} ${periodRange}</strong>. Se incluyen mareas completas con actividad en este rango, sumando la totalidad de sus días.`);
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
   if (dialogFilterType.value && dialogFilterValue.value) {
      let typeLabel = '';
      if (dialogFilterType.value === 'FISHERY') typeLabel = 'Pesquería';
      if (dialogFilterType.value === 'FLEET') typeLabel = 'Flota';
      if (dialogFilterType.value === 'OBSERVER') typeLabel = 'Observador';
      list.push(`Filtro Activo: <strong>${typeLabel}</strong> ${dialogTitle.value ? `(${dialogTitle.value.replace('Detalle: ', '')})` : ''}.`);
   }
   return list;
});

// --- Fetch Data ---
const fetchData = async () => {
   loading.value = true;
   try {
      const [newStats, distribution, coverage, reqs] = await Promise.all([
         statsService.getDashboardStats(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            daysCalculationMode.value,
            includeCampaigns.value,
            startDate.value || undefined,
            endDate.value || undefined,
            startDate.value || undefined, // protocolizationStartDate
            endDate.value || undefined    // protocolizationEndDate
         ),
         statsService.getMareaDistribution(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            includeCampaigns.value,
            startDate.value || undefined,
            endDate.value || undefined,
            startDate.value || undefined, // protocolizationStartDate
            endDate.value || undefined    // protocolizationEndDate
         ),
         statsService.getUniqueVesselsCount(
            year.value,
            mode.value,
            !protocolizedOnly.value,
            includeOutOfPeriod.value,
            includeCampaigns.value,
            startDate.value || undefined,
            endDate.value || undefined,
            selectedCoverageFishery.value === 'ALL' ? undefined : selectedCoverageFishery.value, // fisheryName
            startDate.value || undefined, // protocolizationStartDate
            endDate.value || undefined    // protocolizationEndDate
         ),
         planificacionService.getRequerimientosPorAnio(year.value)
      ]);
      stats.value = newStats;
      distributionData.value = distribution;
      coverageData.value = coverage.monthly;
      requerimientosData.value = reqs;
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
      // Use UTC for Gantt milestones to avoid shifts
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
      type: 'rangeBar',
      height: 450,
      fontFamily: 'Inter, sans-serif',
      toolbar: {
         show: true,
         tools: {
            download: true
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
      }
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
watch([year, mode, protocolizedOnly, includeOutOfPeriod, daysCalculationMode, includeCampaigns, startDate, endDate, selectedCoverageFishery], () => {
   fetchData();
});

const handleTimeFilter = (filter: { startDate: string | null, endDate: string | null }) => {
   startDate.value = filter.startDate;
   endDate.value = filter.endDate;
};

// DIALOG STATE
const dialogOpen = ref(false)
const dialogItems = ref<StatsDetailItem[]>([])
const dialogTitle = ref('')
const dialogStartDate = ref<string | null>(null)
const dialogEndDate = ref<string | null>(null)
const dialogFilterType = ref<FilterType | null>(null)
const dialogFilterValue = ref<string | null>(null)
const loadingDetail = ref(false)
const dialogFilterByStart = ref(false)

const openDialog = (fType: FilterType | null, fValue: string | null, title: string, start?: string, end?: string) => {
   dialogFilterType.value = fType
   dialogFilterValue.value = fValue
   dialogTitle.value = title
   dialogStartDate.value = start || startDate.value
   dialogEndDate.value = end || endDate.value
   dialogFilterByStart.value = false
   dialogOpen.value = true
   fetchItems()
}

const fetchItems = async () => {
   loadingDetail.value = true
   try {
      dialogItems.value = await statsService.getDashboardStatsDetail(
         year.value,
         mode.value,
         !protocolizedOnly.value,
         includeOutOfPeriod.value,
         dialogFilterType.value || null,
         dialogFilterValue.value || null,
         daysCalculationMode.value,
         includeCampaigns.value,
         dialogStartDate.value || undefined,
         dialogEndDate.value || undefined,
         startDate.value || undefined, // protocolizationStartDate (use GLOBAL view filter)
         endDate.value || undefined    // protocolizationEndDate (use GLOBAL view filter)
      )
   } catch (error) {
      console.error('Error fetching detail items:', error)
      toast.error('Error al cargar detalle');
      dialogOpen.value = false;
   } finally {
      loadingDetail.value = false
   }
}

const closeDialog = () => {
   dialogOpen.value = false;
   dialogFilterType.value = null;
   dialogFilterValue.value = null;
   dialogStartDate.value = null;
   dialogEndDate.value = null;
   dialogFilterByStart.value = false;
   searchTerm.value = '';
};

const openQuickDetail = (mareaId: string) => {
   selectedMareaId.value = mareaId;
   quickDetailOpen.value = true;
};

// --- Click Handlers ---
const handleFisheryClick = ({ seriesIndex, dataPointIndex, w }: any) => {
   if (dataPointIndex === -1) return;
   // En el Donut (Participación), usamos dataPointIndex (serie única).
   // En el Scatter (Perfil Operativo), usamos seriesIndex (una serie por pesquería).
   const isScatter = w?.config?.chart?.type === 'scatter';
   const index = isScatter ? seriesIndex : dataPointIndex;

   const item = stats.value?.fisheries[index];
   if (item) openDialog('FISHERY', item.name, item.name);
};

const handleFleetClick = ({ dataPointIndex }: any) => {
   if (dataPointIndex === -1) return;
   const item = stats.value?.fleets[dataPointIndex];
   if (item) openDialog('FLEET', item.name, item.name);
};

const handleObserverClick = ({ dataPointIndex }: any) => {
   if (dataPointIndex === -1) return;
   const item = stats.value?.observers[dataPointIndex];
   // Now we pass the ID to the API filter logic, but Name to the Dialog Title
   if (item) openDialog('OBSERVER', item.id, item.name);
}

const handleCoverageClick = (event: any, _chartContext: any, { dataPointIndex }: any) => {
   const target = event?.target;
   const isLegend = target && (
      target.closest('.apexcharts-legend') ||
      target.classList.contains('apexcharts-legend-text') ||
      target.classList.contains('apexcharts-legend-marker')
   );
   if (isLegend || dataPointIndex === undefined || dataPointIndex === -1) return;
   const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
   const monthName = monthNames[dataPointIndex];

   // Calculate month range for the dialog
   const mStart = new Date(Date.UTC(year.value, dataPointIndex, 1)).toISOString().split('T')[0];
   const mEnd = new Date(Date.UTC(year.value, dataPointIndex + 1, 0)).toISOString().split('T')[0];

   // INTERSECTION: Respect the global time filter
   let finalStart = mStart;
   let finalEnd = mEnd;

   if (startDate.value && startDate.value > finalStart) finalStart = startDate.value;
   if (endDate.value && endDate.value < finalEnd) finalEnd = endDate.value;

   // Respect the global fishery filter of the chart
   const filterT = selectedCoverageFishery.value !== 'ALL' ? 'FISHERY' : null;
   const filterV = selectedCoverageFishery.value !== 'ALL' ? selectedCoverageFishery.value : null;

   openDialog(filterT, filterV, `Cobertura ${monthName} ${year.value}`, finalStart, finalEnd);
};

const handleGanttClick = ({ seriesIndex, dataPointIndex, w }: any) => {
   const data = w.config.series[seriesIndex].data[dataPointIndex];
   if (data?.meta?.mareaId) {
      openQuickDetail(data.meta.mareaId);
   }
};

// --- Download Handler ---
const handleDownload = async (titlePrefix: string, fType?: 'FISHERY' | 'FLEET' | 'OBSERVER') => {
   const fValue = dialogFilterValue.value || undefined;
   const fTypeParam = fType || dialogFilterType.value || undefined;

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
         (dialogOpen.value ? dialogStartDate.value : startDate.value) || undefined,
         (dialogOpen.value ? dialogEndDate.value : endDate.value) || undefined,
         startDate.value || undefined, // protocolizationStartDate
         endDate.value || undefined    // protocolizationEndDate
      );
      toast.success('Exportación preparada con éxito');
   } catch (error) {
      console.error('Error in handleDownload:', error);
      toast.error('No se pudo generar la exportación');
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

// 1. Monthly Trends (Area Chart)
const monthlyChartOptions = computed(() => ({
   chart: {
      type: 'area',
      toolbar: { show: false },
      events: {
         click: handleMonthlyTrendClick
      },
      sparkline: { enabled: false }
   },
   labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
   colors: ['#f59e0b'],
   stroke: {
      width: 3,
      curve: 'smooth'
   },
   fill: {
      type: 'gradient',
      gradient: {
         shadeIntensity: 1,
         opacityFrom: 0.5,
         opacityTo: 0.05,
         stops: [0, 90, 100],
         colorStops: [
            { offset: 0, color: '#f59e0b', opacity: 0.5 },
            { offset: 100, color: '#f59e0b', opacity: 0 }
         ]
      }
   },
   markers: {
      size: 5,
      colors: ['#f59e0b'],
      strokeWidth: 2,
      strokeColors: '#ffffff',
      hover: { size: 7 }
   },
   yaxis: {
      title: { text: 'Días Navegados', style: { color: '#f59e0b', fontWeight: 800 } },
      labels: { style: { colors: '#f59e0b', fontWeight: 600 } }
   },
   tooltip: {
      shared: true,
      intersect: false,
      custom: ({ series, dataPointIndex }: any) => {
         if (dataPointIndex === -1) return '';
         const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
         const label = monthNames[dataPointIndex];
         const days = series[0][dataPointIndex];

         return `
            <div class="px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/10 min-w-[220px]">
               <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
                  <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label} ${year.value}</span>
                  <div class="px-2 py-0.5 rounded-full bg-amber-500/10 text-amber-500 text-[9px] font-black uppercase">Esfuerzo</div>
               </div>
               
               <div class="flex flex-col gap-1">
                  <span class="text-[9px] font-black text-amber-500 uppercase tracking-tighter">Días Navegados Totales</span>
                  <span class="text-2xl font-black tabular-nums">${days}</span>
               </div>
            </div>
         `;
      }
   }
}))

const monthlySeries = computed(() => [
   { name: 'Días Navegados', data: stats.value?.monthly.days || [] }
])

const handleMonthlyTrendClick = (event: any, _chartContext: any, config: any) => {
   const { dataPointIndex } = config;
   const target = event?.target;
   const isLegend = target && (
      target.closest('.apexcharts-legend') ||
      target.classList.contains('apexcharts-legend-text') ||
      target.classList.contains('apexcharts-legend-marker')
   );

   // Only proceed if a valid point was clicked (index >= 0) and not on legend
   if (isLegend || dataPointIndex === undefined || dataPointIndex === -1) return;

   const monthNames = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
   const monthName = monthNames[dataPointIndex];

   const mStart = new Date(Date.UTC(year.value, dataPointIndex, 1)).toISOString().split('T')[0];
   const mEnd = new Date(Date.UTC(year.value, dataPointIndex + 1, 0)).toISOString().split('T')[0];

   // INTERSECTION: Respect the global time filter
   let finalStart = mStart;
   let finalEnd = mEnd;

   if (startDate.value && startDate.value > finalStart) finalStart = startDate.value;
   if (endDate.value && endDate.value < finalEnd) finalEnd = endDate.value;

   openDialog(null, null, `Tendencia ${monthName} ${year.value}`, finalStart, finalEnd);
};

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
      custom: ({ series, seriesIndex, dataPointIndex, w }: any) => {
         const label = w.config.xaxis.categories[dataPointIndex];
         const mareas = series[0] ? series[0][dataPointIndex] : undefined;
         const days = series[1] ? series[1][dataPointIndex] : undefined;

         const hasMareas = mareas !== undefined && mareas !== null;
         const hasDays = days !== undefined && days !== null;

         return `
            <div class="px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/10 min-w-[220px]">
               <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
                  <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
                  <div class="px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[9px] font-black uppercase">Actividad</div>
               </div>
               
               <div class="grid ${hasMareas && hasDays ? 'grid-cols-2' : 'grid-cols-1'} gap-3 pb-1">
                  ${hasMareas ? `
                  <div class="flex flex-col">
                     <span class="text-[9px] font-black text-blue-500 uppercase tracking-tighter">Mareas</span>
                     <span class="text-lg font-black tabular-nums">${mareas}</span>
                  </div>
                  ` : ''}
                  ${hasDays ? `
                  <div class="flex flex-col ${hasMareas ? 'border-l border-border/20 pl-3' : ''}">
                     <span class="text-[9px] font-black text-amber-500 uppercase tracking-tighter">Días Navegados</span>
                     <span class="text-lg font-black tabular-nums">${days}</span>
                  </div>
                  ` : ''}
               </div>

               ${hasMareas && hasDays ? `
               <div class="pt-2 border-t border-border/30 flex justify-between items-center">
                  <span class="text-text-muted text-[9px] font-black italic uppercase">Promedio:</span>
                  <span class="text-primary font-black text-[11px] tabular-nums">${mareas > 0 ? (days / mareas).toFixed(1) : 0} días/marea</span>
               </div>
               ` : ''}
            </div>
         `;
      }
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

// 7. Monthly Coverage (Unique Vessels & Effort & Requirements)

const coverageSeriesData = computed(() => {
   const fisheryFilter = selectedCoverageFishery.value;
   const isFilteredByFishery = fisheryFilter !== 'ALL';

   // Construir la matriz base
   // Si NO está filtrado por pesquería, tendremos dos series fijas (como antes)
   if (!isFilteredByFishery) {
      const reqs = new Array(12).fill(0);
      requerimientosData.value.forEach(req => {
         if (req.cantidad) {
            reqs[req.mes - 1] += req.cantidad;
         }
      });

      return {
         isSplitByFleet: false,
         fleets: [],
         series: [
            {
               name: 'Buques Requeridos',
               type: 'column',
               data: reqs,
               metaType: 'REQUIRED',
               fleetName: null
            },
            {
               name: 'Buques Únicos (Ejecutado)',
               type: 'column',
               data: coverageData.value.map(c => c.count),
               metaType: 'EXECUTED',
               fleetName: null
            },
            {
               name: 'Días de Marea',
               type: 'line',
               data: coverageData.value.map(c => c.days),
               metaType: 'EFFORT',
               fleetName: null
            }
         ]
      };
   }

   // LÓGICA DE DESGLOSE POR FLOTA CUANDO HAY FILTRO DE PESQUERÍA
   const fleetsSet = new Set<string>();

   // 1. Identificar Flotas en Requerimientos
   requerimientosData.value.forEach(req => {
      if (req.pesqueria?.nombre === fisheryFilter && req.tipoFlota?.nombre) {
         fleetsSet.add(req.tipoFlota.nombre);
      }
   });

   // 2. Identificar Flotas en Ejecución (coverageData)
   coverageData.value.forEach(month => {
      month.fleets.forEach(fleet => {
         // Ya coverageData viene filtrada del backend si selectedCoverageFishery !== 'ALL'
         // Por seguridad, agregamos a fleetsSet
         fleetsSet.add(fleet.name);
      });
   });

   const uniqueFleets = Array.from(fleetsSet).sort();
   const dynamicSeries: any[] = [];

   // Para cada flota construimos Ejecutado y Requerido
   uniqueFleets.forEach(fleetName => {
      // Data Requerida
      const reqs = new Array(12).fill(0);
      requerimientosData.value.forEach(req => {
         if (req.pesqueria?.nombre === fisheryFilter && req.tipoFlota?.nombre === fleetName && req.cantidad) {
            reqs[req.mes - 1] += req.cantidad;
         }
      });

      dynamicSeries.push({
         name: `${fleetName} (Requerido)`,
         type: 'column',
         data: reqs,
         metaType: 'REQUIRED',
         fleetName: fleetName
      });

      // Data Ejecutada
      const execs = new Array(12).fill(0);
      coverageData.value.forEach((month, idx) => {
         const fData = month.fleets.find(f => f.name === fleetName);
         if (fData) {
            execs[idx] = fData.count;
         }
      });

      dynamicSeries.push({
         name: `${fleetName} (Ejecutado)`,
         type: 'column',
         data: execs,
         metaType: 'EXECUTED',
         fleetName: fleetName
      });
   });

   // Finalmente agregamos el esfuerzo global
   dynamicSeries.push({
      name: 'Días de Marea',
      type: 'line',
      data: coverageData.value.map(c => c.days),
      metaType: 'EFFORT',
      fleetName: null
   });

   return {
      isSplitByFleet: true,
      fleets: uniqueFleets,
      series: dynamicSeries
   };
});

const coverageSeries = computed(() => coverageSeriesData.value.series);

const coverageChartOptions = computed(() => {
   const baseData = coverageSeriesData.value;
   const seriesCount = baseData.series.length;

   // Definición dinámica de colores y opacidades
   const strokes: number[] = [];
   const colors: string[] = [];
   const opacities: number[] = [];
   const dashes: number[] = [];
   const fillTypes: string[] = [];
   const fillPatterns: string[] = [];

   // Colores fijos para Días (Azul profundo)
   const EFFORT_COLOR = '#3b82f6';

   if (!baseData.isSplitByFleet) {
      // Escenario Aglomerado Clásico (3 series)
      // OJO: Restaurado orden a Requerido, Ejecutado, Esfuerzo
      strokes.push(0, 0, 3);
      colors.push('#a855f7', '#10b981', EFFORT_COLOR); // Púrpura, Verde, Azul
      opacities.push(0.85, 1, 1);
      dashes.push(0, 0, 0);
      fillTypes.push('pattern', 'solid', 'solid');
      fillPatterns.push('slantedLines', 'none', 'none');
   } else {
      // Escenario Desglose por Flota
      baseData.series.forEach(s => {
         if (s.metaType === 'EFFORT') {
            strokes.push(3);
            colors.push(EFFORT_COLOR);
            opacities.push(1);
            dashes.push(0);
            fillTypes.push('solid');
            fillPatterns.push('none');
         } else {
            strokes.push(0);
            colors.push(getFleetColor(s.fleetName as string));
            opacities.push(s.metaType === 'REQUIRED' ? 0.85 : 1);
            dashes.push(0);
            fillTypes.push(s.metaType === 'REQUIRED' ? 'pattern' : 'solid');
            fillPatterns.push(s.metaType === 'REQUIRED' ? 'slantedLines' : 'none');
         }
      });
   }

   // El único eje "Opposite" es el último (Esfuerzo). Los demás referencian al izquierdo (Buques)
   const yaxisNodes = baseData.series.map((s, idx) => {
      if (s.metaType === 'EFFORT') {
         return {
            opposite: true,
            seriesName: s.name,
            title: {
               text: 'Días de Marea',
               style: { color: EFFORT_COLOR, fontWeight: 900 }
            },
            labels: { style: { colors: EFFORT_COLOR } },
            min: 0,
            forceNiceScale: true
         };
      }

      // Primera serie de buques dibuja el eje visible
      if (idx === 0) {
         return {
            seriesName: s.name,
            title: {
               text: 'Buques',
               style: { color: colors[0], fontWeight: 900 }
            },
            labels: { style: { colors: colors[0] } },
            min: 0,
            forceNiceScale: true
         };
      }

      // Las demás series de buques se atan a la serie principal de buques (índice 0) y ocultan su título
      return {
         seriesName: baseData.series[0].name,
         show: false
      };
   });

   return {
      chart: {
         type: 'line',
         stacked: false,
         toolbar: { show: false },
         events: { dataPointSelection: handleCoverageClick }
      },
      stroke: {
         width: strokes,
         curve: 'smooth',
         dashArray: dashes
      },
      colors: colors,
      fill: {
         type: fillTypes,
         opacity: opacities,
         pattern: {
            style: fillPatterns,
            width: 5,
            height: 5,
            strokeWidth: 2
         }
      },
      plotOptions: {
         bar: {
            borderRadius: 3,
            columnWidth: baseData.isSplitByFleet ? '80%' : '60%', // Más fino si hay más barras
         }
      },
      markers: {
         size: baseData.series.map(s => s.metaType === 'EFFORT' ? 4 : 0),
         strokeWidth: 2,
         strokeColors: '#ffffff',
         hover: { size: 6 }
      },
      dataLabels: {
         enabled: true,
         enabledOnSeries: baseData.series.map((s, i) => s.metaType !== 'EFFORT' ? i : -1).filter(i => i !== -1),
         formatter: (val: number) => val > 0 ? val : '',
         offsetY: -10,
         style: { fontSize: '8px', colors: ['var(--color-text)'] }
      },
      xaxis: {
         categories: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
         position: 'bottom',
         axisBorder: { show: false },
         axisTicks: { show: false }
      },
      yaxis: yaxisNodes,
      legend: {
         show: true,
         position: 'right', // Se alínean verticalmente en el lado derecho
         offsetY: 20, // Bajar un poco para no pegarse al top de las grillas
         fontSize: '10px',
         fontFamily: 'inherit',
         fontWeight: 600,
         itemMargin: { horizontal: 0, vertical: 8 },
         markers: {
            radius: 2,
            width: 14,
            height: 14
         },
         onItemClick: { toggleDataSeries: true },
         onItemHover: { highlightDataSeries: true }
      },
      tooltip: {
         shared: true,
         intersect: false,
         custom: ({ series, seriesIndex, dataPointIndex, w }: any) => {
            const label = w.config.xaxis.categories[dataPointIndex];
            const monthData = coverageData.value[dataPointIndex];

            const baseData = coverageSeriesData.value;

            // Extraer esfuerzo
            const effortDataIndex = baseData.series.findIndex(s => s.metaType === 'EFFORT');
            const totalDays = effortDataIndex >= 0 ? series[effortDataIndex][dataPointIndex] : 0;
            const hasTotalDays = totalDays !== undefined && totalDays > 0;

            let tooltipBody = '';

            if (baseData.isSplitByFleet) {
               // Renderizado con Desglose por Flota
               let fleetGridContent = '';
               let totalReqs = 0;
               let totalExecs = 0;

               baseData.fleets.forEach((fleet, fIdx) => {
                  const reqIdx = baseData.series.findIndex(s => s.metaType === 'REQUIRED' && s.fleetName === fleet);
                  const execIdx = baseData.series.findIndex(s => s.metaType === 'EXECUTED' && s.fleetName === fleet);

                  const reqVal = reqIdx >= 0 ? series[reqIdx][dataPointIndex] ?? 0 : 0;
                  const execVal = execIdx >= 0 ? series[execIdx][dataPointIndex] ?? 0 : 0;
                  const fleetColor = getFleetColor(fleet as string);

                  // Buscar días por flota
                  const fData = monthData?.fleets?.find(f => f.name === fleet);
                  const daysVal = fData ? fData.days : 0;

                  totalReqs += reqVal;
                  totalExecs += execVal;

                  if (reqVal > 0 || execVal > 0 || daysVal > 0) {
                     fleetGridContent += `
                        <div class="flex flex-col gap-1 py-1.5 border-b border-border/10 last:border-0 pl-3">
                           <div class="flex items-center gap-1.5">
                              <div class="w-2 h-2 rounded-full shadow-sm" style="background:${fleetColor}"></div>
                              <span class="text-[9px] font-black uppercase text-text">${fleet}</span>
                           </div>
                           <div class="flex items-center gap-6 pl-3">
                              <div class="flex items-baseline gap-1">
                                 <span class="text-[9px] font-bold text-text-muted opacity-60 uppercase w-[50px]">Requerido:</span>
                                 <span class="text-[11px] font-black text-text tabular-nums opacity-60">${reqVal}</span>
                              </div>
                              <div class="flex items-baseline gap-1">
                                 <span class="text-[9px] font-bold text-text-muted uppercase w-[50px] text-emerald-500">Ejecutado:</span>
                                 <span class="text-[11px] font-black text-text tabular-nums" style="color:${fleetColor}">${execVal}</span>
                              </div>
                              <div class="flex items-baseline gap-1 ml-auto">
                                 <span class="text-[9px] font-bold text-text-muted uppercase text-blue-500">Esfuerzo:</span>
                                 <span class="text-[11px] font-black text-text tabular-nums">${daysVal}</span>
                                 <span class="text-[8px] font-bold opacity-40">D</span>
                              </div>
                           </div>
                        </div>
                     `;
                  }
               });

               // Mostrar el Resumen y luego el detalle
               tooltipBody = `
                  <div class="flex justify-between items-end gap-4 pb-2 border-b border-border/20">
                     <div class="flex flex-col">
                        <span class="text-[8px] font-black text-text-muted uppercase tracking-wider mb-0.5">Total Días</span>
                        <div class="flex items-baseline gap-1">
                           <span class="text-xl font-black tabular-nums leading-none text-blue-500">${totalDays}</span>
                           <span class="text-[9px] font-bold text-text-muted">Días</span>
                        </div>
                     </div>
                     <div class="flex gap-4">
                         <div class="text-right flex flex-col items-end">
                             <span class="text-[8px] font-black text-text-muted uppercase">Requerido</span>
                             <span class="text-xs font-black tabular-nums opacity-60">${totalReqs} B</span>
                         </div>
                         <div class="text-right flex flex-col items-end pl-4 border-l border-border/20">
                             <span class="text-[8px] font-black text-emerald-500 uppercase">Ejecutado</span>
                             <span class="text-xs font-black tabular-nums text-emerald-600 dark:text-emerald-400">${totalExecs} B</span>
                         </div>
                     </div>
                  </div>
                  
                  <div class="flex flex-col pt-1">
                     ${fleetGridContent || '<span class="text-[10px] italic opacity-50 py-2">Sin actividad planificada ni ejecutada en este mes</span>'}
                  </div>
               `;

            } else {
               // Renderizado Simple (Aglomerado)
               const execIdx = baseData.series.findIndex((s: any) => s.metaType === 'EXECUTED');
               const reqIdx = baseData.series.findIndex((s: any) => s.metaType === 'REQUIRED');

               const required = reqIdx >= 0 && series[reqIdx] ? series[reqIdx][dataPointIndex] ?? 0 : 0;
               const vessels = execIdx >= 0 && series[execIdx] ? series[execIdx][dataPointIndex] ?? 0 : 0;

               const hasVessels = vessels > 0;
               const hasRequired = required > 0;

               tooltipBody = `
                  <div class="flex justify-between items-end gap-4 pb-2 border-b border-border/20">
                     <div class="flex flex-col">
                        <span class="text-[8px] font-black text-text-muted uppercase tracking-wider mb-0.5">Total Días</span>
                        <div class="flex items-baseline gap-1">
                           <span class="text-xl font-black tabular-nums leading-none text-blue-500">${totalDays}</span>
                           <span class="text-[9px] font-bold text-text-muted">Días</span>
                        </div>
                     </div>
                     <div class="flex gap-4">
                         <div class="text-right flex flex-col items-end">
                             <span class="text-[8px] font-black text-text-muted uppercase">Requerido</span>
                             <span class="text-xs font-black tabular-nums opacity-60">${required} B</span>
                         </div>
                         <div class="text-right flex flex-col items-end pl-4 border-l border-border/20">
                             <span class="text-[8px] font-black text-emerald-500 uppercase">Ejecutado</span>
                             <span class="text-xs font-black tabular-nums text-emerald-600 dark:text-emerald-400">${vessels} B</span>
                         </div>
                     </div>
                  </div>

                  ${monthData?.fleets && monthData.fleets.length > 0 ? `
                     <div class="flex flex-col gap-1.5 pt-2">
                        <span class="text-[8px] font-black text-text-muted uppercase tracking-widest mb-1 opacity-60">Desglose Operativo por Flota</span>
                        ${monthData.fleets.map(f => `
                           <div class="flex items-center justify-between gap-4 py-0.5 pl-2">
                              <div class="flex items-center gap-2">
                                 <div class="w-1.5 h-1.5 rounded-full shadow-sm" style="background:${getFleetColor(f.name)}"></div>
                                 <span class="text-[9px] font-bold text-text-muted uppercase">${f.name}</span>
                              </div>
                              <div class="flex items-center gap-2">
                                 ${f.count > 0 ? `<div class="flex items-baseline gap-1"><span class="text-[8px] font-bold text-text-muted uppercase opacity-50">Ejec.</span><span class="text-[10px] font-black text-text tabular-nums">${f.count} <span class="text-[8px] opacity-40 font-bold">B</span></span></div>` : ''}
                                 ${f.count > 0 && f.days > 0 ? `<span class="h-2 w-px bg-border/30"></span>` : ''}
                                 ${f.days > 0 ? `<div class="flex items-baseline gap-1"><span class="text-[8px] font-bold text-text-muted uppercase opacity-50 text-blue-500">Esf.</span><span class="text-[10px] font-black text-text/80 tabular-nums">${f.days} <span class="text-[8px] opacity-40 font-bold">D</span></span></div>` : ''}
                              </div>
                           </div>
                        `).join('')}
                     </div>
                  ` : ''}
               `;
            }

            return `
               <div class="px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-2xl ring-1 ring-black/10 min-w-[240px]">
                  <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
                     <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label} ${year.value}</span>
                     <div class="px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[9px] font-black uppercase">Cobertura</div>
                  </div>
                  
                  ${tooltipBody}

                  <div class="pt-2 border-t border-border/30 flex justify-between items-center opacity-60">
                      <span class="text-[8px] font-black italic uppercase">Click para ver detalle</span>
                      <span class="text-[10px]">📊</span>
                  </div>
               </div>
            `;
         }
      }
   };
});

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
