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
import { statsService, type DashboardStats, type StatsDetailItem } from '@/modules/stats/services/stats.service'
import { TipoMarea } from '@/modules/mareas/types/enums'
import { toast } from 'vue-sonner'

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

const filterType = ref<'FISHERY' | 'FLEET' | 'OBSERVER' | null>(null);
const filterValue = ref<string | null>(null);

const stats = ref<DashboardStats | null>(null);
const loading = ref(false);
const dialogOpen = ref(false);
const dialogLoading = ref(false);
const dialogItems = ref<StatsDetailItem[]>([]);
const searchTerm = ref('');

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

const filteredDialogItems = computed(() => {
   let items = [...dialogItems.value];

   // Filtering
   if (searchTerm.value) {
      const s = searchTerm.value.toLowerCase();
      items = items.filter(m =>
         m.id_marea.toLowerCase().includes(s) ||
         m.buque.toLowerCase().includes(s) ||
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
      stats.value = await statsService.getDashboardStats(
         year.value,
         mode.value,
         !protocolizedOnly.value,
         includeOutOfPeriod.value,
         daysCalculationMode.value,
         includeCampaigns.value,
         startDate.value || undefined,
         endDate.value || undefined
      );
   } catch (error) {
      console.error('Error fetching stats:', error);
      toast.error('Error al cargar estadísticas');
   } finally {
      loading.value = false;
   }
};

// --- Watchers ---
watch([year, mode, protocolizedOnly, includeOutOfPeriod, daysCalculationMode, includeCampaigns, startDate, endDate], () => {
   fetchData();
});

const handleTimeFilter = (filter: { startDate: string | null, endDate: string | null }) => {
   startDate.value = filter.startDate;
   endDate.value = filter.endDate;
};

// --- Dialog Logic ---
const openDialog = async (type: 'FISHERY' | 'FLEET' | 'OBSERVER', value: string, titleName: string) => {
   filterType.value = type;
   filterValue.value = value; // NOW value is correct: Name for Fishery/Fleet, UUID for Observer

   dialogTitle.value = `Detalle: ${titleName}`; // Use pretty name for title
   dialogOpen.value = true;
   dialogLoading.value = true;

   try {
      dialogItems.value = await statsService.getDashboardStatsDetail(
         year.value,
         mode.value,
         !protocolizedOnly.value,
         includeOutOfPeriod.value,
         type,
         value,
         daysCalculationMode.value,
         includeCampaigns.value,
         startDate.value || undefined,
         endDate.value || undefined
      );
   } catch (error) {
      console.error('Error fetching details:', error);
      toast.error('Error al cargar detalle');
      dialogOpen.value = false;
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

const openQuickDetail = (mareaId: string) => {
   selectedMareaId.value = mareaId;
   quickDetailOpen.value = true;
};

// --- Click Handlers ---
const handleFisheryClick = ({ dataPointIndex }: any) => {
   const item = stats.value?.fisheries[dataPointIndex];
   if (item) openDialog('FISHERY', item.name, item.name);
};

const handleFleetClick = ({ dataPointIndex }: any) => {
   const item = stats.value?.fleets[dataPointIndex];
   if (item) openDialog('FLEET', item.name, item.name);
};

const handleObserverClick = ({ dataPointIndex }: any) => {
   const item = stats.value?.observers[dataPointIndex];
   // Now we pass the ID to the API filter logic, but Name to the Dialog Title
   if (item) openDialog('OBSERVER', item.id, item.name);
}

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
