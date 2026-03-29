<template>
   <div v-if="loading" class="flex items-center justify-center py-20">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
   </div>

   <div v-else-if="stats" class="space-y-6 animate-in fade-in duration-500">
      <!-- =========================================================== -->
      <!-- TOOLBAR / ACTIONS                                           -->
      <!-- =========================================================== -->
      <div class="flex items-center justify-between bg-surface p-5 rounded-2xl border border-border shadow-theme-xs">
         <div class="flex items-center gap-4">
             <div class="w-12 h-12 rounded-2xl bg-primary/10 flex items-center justify-center">
                <FileBarChart2Icon class="w-6 h-6 text-primary" />
             </div>
            <div>
               <h2 class="text-lg font-black text-text tracking-tight uppercase leading-none">Informe de Auditoría</h2>
               <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-1.5 flex items-center gap-1.5">
                  <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                  Datos consolidados del período {{ year }}
               </p>
            </div>
         </div>
         <div class="flex items-center gap-2">
            <ExportWordButton 
               :loading="exportingWord"
               label="GENERAR INFORME"
               title="Generar informe narrativo completo en formato Word (.docx)"
               class="px-4 py-2.5 rounded-xl border border-blue-500/20 bg-surface shadow-theme-xs"
               @click="handleExportWord"
            />
            <ExportExcelButton 
               :loading="exporting"
               label="DATOS EXCEL"
               title="Exportar análisis completo para auditoría (3 hojas)"
               class="px-4 py-2.5 rounded-xl border border-primary/20 bg-surface shadow-theme-xs"
               @click="handleExportAudit"
            />
         </div>
      </div>

      <!-- =========================================================== -->
      <!-- SECTION 1: ESTADÍSTICAS DE PERSONAL                        -->
      <!-- =========================================================== -->
      <section class="bg-surface rounded-2xl border border-border shadow-theme-xs overflow-hidden">
         <!-- Section Header -->
         <button @click="personalOpen = !personalOpen"
            class="w-full flex items-center justify-between p-5 hover:bg-surface-muted/30 transition-colors group">
            <div class="flex items-center gap-3">
               <div class="w-10 h-10 rounded-xl bg-violet-500/10 flex items-center justify-center group-hover:bg-violet-500 group-hover:text-white transition-colors">
                  <UsersIcon class="w-5 h-5 text-violet-500 group-hover:text-white transition-colors" />
               </div>
               <div class="text-left">
                  <h3 class="text-sm font-black text-text uppercase tracking-tight">Estadísticas de Personal</h3>
                  <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">
                     Dotación y días navegados por observador
                  </p>
               </div>
            </div>
            <component :is="personalOpen ? ChevronUpIcon : ChevronDownIcon"
               class="w-5 h-5 text-text-muted group-hover:text-text transition-colors" />
         </button>

         <!-- Section Content -->
         <div v-if="personalOpen" class="border-t border-border animate-in fade-in duration-300">
            <!-- KPIs Row -->
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 p-5">
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Observadores Afectados</p>
                  <p class="text-2xl font-black text-text tabular-nums">{{ personalData.observadoresAfectados }}</p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50 relative group/dot">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">
                     Dotación Referencia
                     <span class="inline-block w-3 h-3 rounded-full bg-primary/10 text-primary text-[8px] font-black text-center leading-3 ml-1 cursor-help">?</span>
                  </p>
                  <p class="text-2xl font-black text-text tabular-nums">
                     <span v-if="dotacionLoading" class="text-sm text-text-muted">...</span>
                     <span v-else>{{ dotacionReferencia }}</span>
                  </p>
                  <!-- Tooltip -->
                  <div class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-3 py-2 bg-surface border border-border rounded-xl text-[9px] font-medium text-text-muted opacity-0 group-hover/dot:opacity-100 transition-all pointer-events-none shadow-theme-lg z-50 whitespace-nowrap">
                     Máximo entre dotación activa ({{ dotacionTotal }}) y observadores afectados ({{ personalData.observadoresAfectados }})
                  </div>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">% sobre Dotación</p>
                  <p class="text-2xl font-black tabular-nums" :class="coberturaPct >= 90 ? 'text-emerald-500' : coberturaPct >= 70 ? 'text-amber-500' : 'text-red-500'">
                     {{ coberturaPct }}%
                  </p>
               </div>
               <div class="bg-surface-muted/30 rounded-xl p-4 border border-border/50">
                  <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Días Navegados</p>
                  <p class="text-2xl font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</p>
               </div>
            </div>

            <!-- Stats Summary Banner -->
            <div class="mx-5 mb-5 bg-primary/5 border border-primary/10 rounded-xl px-4 py-3 flex flex-wrap items-center gap-x-6 gap-y-2 text-[11px]">
               <div class="flex items-center gap-2">
                  <span class="text-text-muted font-bold">Promedio:</span>
                  <span class="font-black text-text tabular-nums">{{ personalData.promedioDias }} días/obs.</span>
               </div>
               <div class="w-px h-4 bg-border"></div>
               <div class="flex items-center gap-2">
                  <span class="text-text-muted font-bold">Máximo:</span>
                  <span class="font-black text-primary tabular-nums">{{ personalData.maxDias }} días</span>
                  <span class="text-text-muted font-medium">({{ personalData.maxNombre }})</span>
               </div>
               <div class="w-px h-4 bg-border"></div>
               <div class="flex items-center gap-2">
                  <span class="text-text-muted font-bold">Mínimo:</span>
                  <span class="font-black text-text tabular-nums">{{ personalData.minDias }} días</span>
                  <span class="text-text-muted font-medium">({{ personalData.minNombre }})</span>
               </div>
            </div>

            <!-- Chart: Top 15 Observers -->
            <div class="px-5 pb-5">
               <ChartWidget title="Ranking de Observadores"
                  subtitle="Días navegados por observador (todos)" type="bar"
                  :series="personalChartSeries" :options="personalChartOptions"
                  :chart-height="Math.max(400, personalData.ranking.length * 28)" />
            </div>

            <!-- Full Table -->
            <div class="border-t border-border">
               <div class="overflow-x-auto">
                  <table class="w-full text-left border-collapse">
                     <thead>
                        <tr class="bg-surface-muted/50">
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted w-12">#</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Observador
                           </th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-28">
                              Cant. Mareas</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-right w-36">
                              Días Navegados {{ year }}</th>
                        </tr>
                     </thead>
                     <tbody class="divide-y divide-border">
                        <tr v-for="(obs, index) in personalData.ranking" :key="obs.id"
                           class="hover:bg-primary/5 transition-colors">
                           <td class="px-5 py-2.5 text-xs font-bold text-text-muted tabular-nums">{{ index + 1 }}</td>
                           <td class="px-5 py-2.5">
                              <span class="text-xs font-bold text-text">{{ obs.name }}</span>
                              <span v-if="!obs.active"
                                 class="ml-2 text-[8px] font-black text-error uppercase tracking-wider">Inactivo</span>
                           </td>
                           <td class="px-5 py-2.5 text-xs font-bold text-text text-center tabular-nums">{{ obs.mareas }}
                           </td>
                           <td class="px-5 py-2.5 text-right">
                              <div class="flex items-center justify-end gap-3">
                                 <div class="flex-1 max-w-[80px] h-1.5 bg-surface-muted rounded-full overflow-hidden hidden sm:block">
                                    <div class="h-full bg-violet-500 rounded-full transition-all" :style="{
                                       width: `${personalData.ranking[0]?.days ? (obs.days / personalData.ranking[0].days) * 100 : 0}%`
                                    }"></div>
                                 </div>
                                 <span class="text-sm font-black text-text tabular-nums">{{ obs.days }}</span>
                              </div>
                           </td>
                        </tr>
                     </tbody>
                     <!-- Footer Totals -->
                     <tfoot class="sticky bottom-0 z-10">
                        <tr class="bg-background/95 backdrop-blur-md border-t-2 border-primary/20 shadow-[0_-4px_12px_rgba(0,0,0,0.08)]">
                           <td class="px-5 py-3"></td>
                           <td class="px-5 py-3 text-[10px] font-black text-text uppercase tracking-widest">
                              TOTAL ({{ personalData.observadoresAfectados }} observadores)
                           </td>
                           <td class="px-5 py-3 text-xs font-black text-text text-center tabular-nums">
                              {{ stats.totalMareas }}
                           </td>
                           <td class="px-5 py-3 text-right">
                              <span class="text-sm font-black text-primary tabular-nums">{{
                                 stats.totalDaysNavigated.toLocaleString() }}</span>
                           </td>
                        </tr>
                     </tfoot>
                  </table>
               </div>
            </div>
         </div>
      </section>

      <!-- =========================================================== -->
      <!-- SECTION 2: ESTADÍSTICAS DE NAVEGACIÓN                       -->
      <!-- =========================================================== -->
      <section class="bg-surface rounded-2xl border border-border shadow-theme-xs overflow-hidden">
         <!-- Section Header -->
         <button @click="navegacionOpen = !navegacionOpen"
            class="w-full flex items-center justify-between p-5 hover:bg-surface-muted/30 transition-colors group">
            <div class="flex items-center gap-3">
               <div class="w-10 h-10 rounded-xl bg-sky-500/10 flex items-center justify-center group-hover:bg-sky-500 group-hover:text-white transition-colors">
                  <ShipIcon class="w-5 h-5 text-sky-500 group-hover:text-white transition-colors" />
               </div>
               <div class="text-left">
                  <h3 class="text-sm font-black text-text uppercase tracking-tight">Estadísticas de Navegación</h3>
                  <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">
                     Detalle completo de mareas por pesquería
                  </p>
               </div>
            </div>
            <component :is="navegacionOpen ? ChevronUpIcon : ChevronDownIcon"
               class="w-5 h-5 text-text-muted group-hover:text-text transition-colors" />
         </button>

         <!-- Section Content -->
         <div v-if="navegacionOpen" class="border-t border-border animate-in fade-in duration-300">
            <div class="grid grid-cols-1 lg:grid-cols-12 divide-y lg:divide-y-0 lg:divide-x divide-border">
               <!-- Left Column: KPIs -->
               <div class="lg:col-span-3 p-5 flex flex-col gap-4 bg-surface-muted/10">
                  <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
                     <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Mareas</p>
                     <p class="text-2xl font-black text-text tabular-nums">{{ stats.totalMareas }}</p>
                  </div>
                  <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
                     <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Finalizadas</p>
                     <p class="text-2xl font-black text-emerald-500 tabular-nums">{{ navegacionData.finalizadas }}</p>
                  </div>
                  <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
                     <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">En Ejecución</p>
                     <p class="text-2xl font-black text-sky-500 tabular-nums">{{ navegacionData.enEjecucion }}</p>
                  </div>
                  <div class="bg-surface rounded-xl p-4 border border-border/50 shadow-sm">
                     <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Total Etapas</p>
                     <p class="text-2xl font-black text-text tabular-nums">{{ navegacionData.totalEtapas }}</p>
                  </div>
               </div>

               <!-- Right Column: Full Detail Table -->
               <div class="lg:col-span-9 overflow-x-auto scrollbar-thin scrollbar-thumb-border">
                  <table class="w-full text-left border-collapse min-w-[700px]">
                     <thead class="sticky top-0 z-20">
                        <tr class="bg-surface-muted/50 border-b border-border">
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Pesquería</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted">Buque</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted w-28">N° Marea</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-20">Estado</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-center w-20">Etapas</th>
                           <th class="px-5 py-3 text-[10px] font-black uppercase tracking-widest text-text-muted text-right w-36">Días {{ year }}</th>
                        </tr>
                     </thead>
                     <tbody class="divide-y divide-border">
                        <template v-for="(group, gIdx) in navegacionData.grouped" :key="group.pesqueria">
                           <tr v-for="(marea, mIdx) in group.mareas" :key="marea.id_marea"
                              class="hover:bg-primary/5 transition-colors border-b border-border/50"
                              :class="{ 'border-t-2 border-t-border': mIdx === 0 && gIdx > 0 }">
                              <!-- Pesquería (solo en primera fila del grupo) -->
                              <td class="px-5 py-2" :class="{ 'border-l-4 border-l-primary/30': mIdx > 0 }">
                                 <span v-if="mIdx === 0"
                                    class="text-[10px] font-black text-primary uppercase tracking-tight">
                                    {{ group.pesqueria }}
                                 </span>
                              </td>
                              <td class="px-5 py-2 text-xs font-bold text-text">{{ marea.buque }}</td>
                              <td class="px-5 py-2 text-xs font-black text-text tabular-nums">{{ marea.id_marea }}</td>
                              <td class="px-5 py-2 text-center">
                                 <span class="px-2 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider"
                                    :class="marea.estado === 'Finalizada'
                                       ? 'bg-emerald-500/10 text-emerald-600 border border-emerald-500/20'
                                       : 'bg-sky-500/10 text-sky-600 border border-sky-500/20'">
                                    {{ marea.estado === 'Finalizada' ? 'Fin.' : 'Ejec.' }}
                                 </span>
                              </td>
                              <td class="px-5 py-2 text-xs font-bold text-text text-center tabular-nums">{{ marea.etapas }}</td>
                              <td class="px-5 py-2 text-right">
                                 <span class="text-sm font-black text-text tabular-nums">{{ marea.dias }}</span>
                              </td>
                           </tr>
                        </template>
                     </tbody>
                     <tfoot class="sticky bottom-0 z-20">
                        <tr class="bg-background/95 backdrop-blur-md border-t-2 border-primary/20 shadow-md">
                           <td class="px-5 py-3 text-[10px] font-black text-text uppercase tracking-widest">TOTAL</td>
                           <td class="px-5 py-3 text-[10px] font-bold text-text-muted">{{ stats.totalMareas }} mareas</td>
                           <td class="px-5 py-3"></td>
                           <td class="px-5 py-3"></td>
                           <td class="px-5 py-3 text-xs font-black text-text text-center tabular-nums">{{ navegacionData.totalEtapas }}</td>
                           <td class="px-5 py-3 text-right">
                              <span class="text-sm font-black text-primary tabular-nums">{{ stats.totalDaysNavigated.toLocaleString() }}</span>
                           </td>
                        </tr>
                     </tfoot>
                  </table>
               </div>
            </div>
         </div>
      </section>

      <!-- =========================================================== -->
      <!-- SECTION 3: ESTADÍSTICAS POR PESQUERÍA                       -->
      <!-- =========================================================== -->
      <section class="bg-surface rounded-2xl border border-border shadow-theme-xs overflow-hidden">
         <!-- Section Header -->
         <button @click="pesqueriaOpen = !pesqueriaOpen"
            class="w-full flex items-center justify-between p-5 hover:bg-surface-muted/30 transition-colors group">
            <div class="flex items-center gap-3">
               <div class="w-10 h-10 rounded-xl bg-emerald-500/10 flex items-center justify-center group-hover:bg-emerald-500 group-hover:text-white transition-colors">
                  <BarChart3Icon class="w-5 h-5 text-emerald-500 group-hover:text-white transition-colors" />
               </div>
               <div class="text-left">
                  <h3 class="text-sm font-black text-text uppercase tracking-tight">Estadísticas por Pesquería</h3>
                  <p class="text-[10px] font-bold text-text-muted uppercase tracking-widest mt-0.5">
                     Resumen agregado por pesquería y tipo de flota
                  </p>
               </div>
            </div>
            <component :is="pesqueriaOpen ? ChevronUpIcon : ChevronDownIcon"
               class="w-5 h-5 text-text-muted group-hover:text-text transition-colors" />
         </button>

         <!-- Section Content -->
         <div v-if="pesqueriaOpen" class="border-t border-border animate-in fade-in duration-300">
            <div class="grid grid-cols-1 lg:grid-cols-12 divide-y lg:divide-y-0 lg:divide-x divide-border">
               <!-- 3.1 Resumen por Flota -->
               <div class="lg:col-span-5 p-5">
                  <div class="flex items-center gap-2 mb-4">
                     <span class="w-1.5 h-1.5 rounded-full bg-primary/40"></span>
                     <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                        3.1 Resumen por Flota y Pesquería
                     </h4>
                  </div>
                  <div class="overflow-x-auto">
                     <table class="w-full text-left border-collapse">
                        <thead>
                           <tr class="bg-surface-muted/30">
                              <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">
                                 Flota / Pesquería</th>
                              <th class="px-2 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-16">
                                 Mar.</th>
                              <th class="px-2 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-16">
                                 Etap.</th>
                              <th class="px-4 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-right w-20">
                                 Días</th>
                           </tr>
                        </thead>
                        <tbody class="divide-y divide-border/50">
                           <tr v-for="row in pesqueriaData.resumen" :key="row.key"
                              class="hover:bg-primary/5 transition-colors">
                              <td class="px-4 py-2">
                                 <div class="flex flex-col">
                                    <span class="text-[10px] font-black text-text uppercase tracking-tight">{{ row.flota
                                          }}</span>
                                    <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">{{
                                       row.pesqueria }}</span>
                                 </div>
                              </td>
                              <td class="px-2 py-2 text-[11px] font-bold text-center tabular-nums text-text">{{
                                 row.mareas }}</td>
                              <td class="px-2 py-2 text-[11px] font-bold text-center tabular-nums text-text-muted">{{
                                 row.etapas }}</td>
                              <td class="px-4 py-2 text-right">
                                 <span class="text-[11px] font-black text-primary tabular-nums">{{ row.dias }}</span>
                              </td>
                           </tr>
                        </tbody>
                        <tfoot class="border-t border-border">
                           <tr class="bg-surface-muted/20">
                              <td class="px-4 py-2 text-[9px] font-black text-text uppercase tracking-widest">TOTALES
                              </td>
                              <td class="px-2 py-2 text-[10px] font-black text-center tabular-nums text-text">{{
                                 stats.totalMareas }}</td>
                              <td class="px-2 py-2 text-[10px] font-black text-center tabular-nums text-text-muted">{{
                                 navegacionData.totalEtapas }}</td>
                              <td class="px-4 py-2 text-right">
                                 <span class="text-[10px] font-black text-primary tabular-nums">{{
                                    stats.totalDaysNavigated }}</span>
                              </td>
                           </tr>
                        </tfoot>
                     </table>
                  </div>
               </div>

               <!-- 3.2 Distribución (Chart) -->
               <div class="lg:col-span-7 p-5 bg-surface-muted/5">
                  <div class="flex items-center gap-2 mb-4">
                     <span class="w-1.5 h-1.5 rounded-full bg-primary/40"></span>
                     <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                        3.2 Distribución de Días por Pesquería y Flota
                     </h4>
                  </div>
                  <div class="h-[300px]">
                     <ChartWidget title="Distribución de Días" type="bar" :series="pesqueriaChartSeries" :options="pesqueriaChartOptions" height="100%" />
                  </div>
               </div>
            </div>

            <!-- Detalle Expandible -->
            <div class="border-t border-border">
               <div class="p-5 pb-2 bg-surface-muted/10">
                  <h4 class="text-[10px] font-black text-text-muted uppercase tracking-widest">
                     3.3 Detalle de Mareas por Pesquería
                  </h4>
               </div>

               <div class="divide-y divide-border">
                  <div v-for="fishery in pesqueriaData.detalle" :key="fishery.name"
                     class="overflow-hidden">
                     <!-- Fishery Accordion Header -->
                     <button @click="toggleFisheryDetail(fishery.name)"
                        class="w-full flex items-center justify-between px-5 py-3 hover:bg-surface-muted/30 transition-colors group">
                        <div class="flex items-center gap-3">
                           <component :is="expandedFisheries.has(fishery.name) ? ChevronDownIcon : ChevronRightIcon"
                              class="w-4 h-4 text-text-muted group-hover:text-primary transition-colors" />
                           <span class="text-xs font-black text-text uppercase tracking-tight">{{ fishery.name }}</span>
                        </div>
                        <div class="flex items-center gap-4 text-[10px] font-bold text-text-muted">
                           <span class="tabular-nums">{{ fishery.mareas }} mareas</span>
                           <span class="w-px h-3 bg-border"></span>
                           <span class="tabular-nums font-black text-primary">{{ fishery.dias }} días</span>
                        </div>
                     </button>

                     <!-- Fishery Detail Table -->
                     <div v-if="expandedFisheries.has(fishery.name)"
                        class="bg-surface-muted/10 animate-in fade-in duration-200">
                        <table class="w-full text-left border-collapse">
                           <thead>
                              <tr class="bg-surface-muted/30">
                                 <th class="px-8 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Flota
                                 </th>
                                 <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Marea
                                 </th>
                                 <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted">Buque
                                 </th>
                                 <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-20">
                                    Etapas</th>
                                 <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-right w-28">
                                    Días</th>
                                 <th class="px-5 py-2 text-[9px] font-black uppercase tracking-widest text-text-muted text-center w-24">
                                    Estado</th>
                              </tr>
                           </thead>
                           <tbody class="divide-y divide-border/30">
                              <tr v-for="m in fishery.items" :key="m.id_marea"
                                 class="hover:bg-primary/5 transition-colors">
                                 <td class="px-8 py-2 text-[11px] font-bold text-text-muted">{{ m.flota }}</td>
                                 <td class="px-5 py-2 text-[11px] font-black text-text tabular-nums">{{ m.id_marea }}</td>
                                 <td class="px-5 py-2 text-[11px] font-bold text-text">{{ m.buque }}</td>
                                 <td class="px-5 py-2 text-[11px] font-bold text-text text-center tabular-nums">{{ m.etapas }}
                                 </td>
                                 <td class="px-5 py-2 text-right">
                                    <span class="text-xs font-black text-text tabular-nums">{{ m.dias }}</span>
                                 </td>
                                 <td class="px-5 py-2 text-center">
                                    <span class="px-2 py-0.5 rounded text-[8px] font-bold uppercase tracking-wider"
                                       :class="m.estado === 'Finalizada'
                                          ? 'bg-emerald-500/10 text-emerald-600'
                                          : 'bg-sky-500/10 text-sky-600'">
                                       {{ m.estado }}
                                    </span>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </section>
   </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import {
   UsersIcon,
   ShipIcon,
   BarChart3Icon,
   ChevronDownIcon,
   ChevronUpIcon,
   ChevronRightIcon,
   DownloadIcon,
   FileBarChart2Icon
} from 'lucide-vue-next'
import ChartWidget from './ChartWidget.vue'
import type { DashboardStats, MareaDistributionItem, StatsDetailItem } from '../services/stats.service'
import { statsService } from '../services/stats.service'
import dashboardService from '@/modules/dashboard/services/dashboard.service'
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue'
import ExportWordButton from '@/modules/shared/components/ExportWordButton.vue'

// Props
const props = defineProps<{
   stats: DashboardStats | null
   distributionData: MareaDistributionItem[]
   year: number
   mode: 'CALENDAR' | 'TOTAL'
   loading: boolean
   protocolizedOnly: boolean
   includeOutOfPeriod: boolean
   daysCalculationMode: 'SHIP' | 'OBSERVER'
   includeCampaigns: boolean
   startDate: string | null
   endDate: string | null
}>()

// Accordion state (all open by default)
const personalOpen = ref(true)
const navegacionOpen = ref(true)
const pesqueriaOpen = ref(true)
const expandedFisheries = ref(new Set<string>())

const toggleFisheryDetail = (name: string) => {
   const newSet = new Set(expandedFisheries.value)
   if (newSet.has(name)) {
      newSet.delete(name)
   } else {
      newSet.add(name)
   }
   expandedFisheries.value = newSet
}

// Dotación total (observadores activos sin impedimentos)
const dotacionTotal = ref(0)
const dotacionLoading = ref(true)

const fetchDotacion = async () => {
   dotacionLoading.value = true
   try {
      const data = await dashboardService.getWorkforceStatus('OBSERVADOR')
      dotacionTotal.value = data.totalActivos
   } catch (error) {
      console.error('Error fetching dotación:', error)
      dotacionTotal.value = 0
   } finally {
      dotacionLoading.value = false
   }
}

onMounted(() => {
   fetchDotacion()
   fetchDetailData()
})

// Detalle de mareas (con estado, etapas, días, etc.)
const detailItems = ref<StatsDetailItem[]>([])
const detailLoading = ref(false)

const fetchDetailData = async () => {
   if (!props.stats) return
   detailLoading.value = true
   try {
      detailItems.value = await statsService.getDashboardStatsDetail(
         props.year,
         props.mode,
         !props.protocolizedOnly,
         props.includeOutOfPeriod,
         null,
         null,
         props.daysCalculationMode,
         props.includeCampaigns,
         props.startDate || undefined,
         props.endDate || undefined,
         props.startDate || undefined,
         props.endDate || undefined
      )
   } catch (error) {
      console.error('Error fetching detail data:', error)
   } finally {
      detailLoading.value = false
   }
}

const exporting = ref(false)
const exportingWord = ref(false)

const handleExportAudit = async () => {
   if (!props.stats || exporting.value) return
   exporting.value = true
   try {
      await statsService.downloadExport(
         props.year,
         props.mode,
         !props.protocolizedOnly,
         props.includeOutOfPeriod,
         props.daysCalculationMode,
         props.includeCampaigns,
         'AUDIT',
         undefined,
         `Anexo_Auditoria_Mareas_${props.year}`,
         props.startDate || undefined,
         props.endDate || undefined,
         props.startDate || undefined,
         props.endDate || undefined,
         true
      )
   } catch (error) {
      console.error('Error exporting audit report:', error)
   } finally {
      exporting.value = false
   }
}

const handleExportWord = async () => {
   if (!props.stats || exportingWord.value) return
   exportingWord.value = true
   try {
      await statsService.downloadAuditReport(
         props.year,
         props.mode,
         !props.protocolizedOnly,
         props.includeOutOfPeriod,
         props.includeCampaigns,
         `Informe_Auditoria_Mareas_${props.year}`,
         props.startDate || undefined,
         props.endDate || undefined,
         props.startDate || undefined,
         props.endDate || undefined
      )
   } catch (error) {
      console.error('Error exporting word audit report:', error)
   } finally {
      exportingWord.value = false
   }
}

watch(() => props.stats, () => {
   fetchDetailData()
})

// Dotación de referencia: el mayor entre observadores que navegaron y la dotación activa actual.
// Esto cubre el caso donde personal que navegó ya no pertenece a la dotación (renuncia, jubilación, etc.)
const dotacionReferencia = computed(() => {
   const afectados = props.stats?.observers.length || 0
   return Math.max(afectados, dotacionTotal.value)
})

// Cobertura
const coberturaPct = computed(() => {
   if (!props.stats || !dotacionReferencia.value) return 0
   return Math.round((props.stats.observers.length / dotacionReferencia.value) * 100)
})

// ─────────────────────────────────────────────────────────────
// SECTION 1: PERSONAL DATA
// ─────────────────────────────────────────────────────────────
const personalData = computed(() => {
   if (!props.stats) return {
      observadoresAfectados: 0, promedioDias: 0,
      maxDias: 0, maxNombre: '', minDias: 0, minNombre: '',
      ranking: [] as {id: string, name: string, mareas: number, days: number, active: boolean}[]
   }

   const observers = [...props.stats.observers].sort((a, b) => b.days - a.days)
   const totalDays = observers.reduce((sum, o) => sum + o.days, 0)
   const count = observers.length

   return {
      observadoresAfectados: count,
      promedioDias: count > 0 ? (totalDays / count).toFixed(1) : '0',
      maxDias: observers[0]?.days || 0,
      maxNombre: observers[0]?.name || '',
      minDias: observers[count - 1]?.days || 0,
      minNombre: observers[count - 1]?.name || '',
      ranking: observers
   }
})

// Chart for personal section
const personalChartSeries = computed(() => [{
   name: 'Días Navegados',
   data: personalData.value.ranking.map(o => o.days)
}])

const personalChartOptions = computed(() => ({
   plotOptions: {
      bar: { horizontal: true, borderRadius: 3, barHeight: '65%' }
   },
   xaxis: {
      categories: personalData.value.ranking.map(o => o.name),
   },
   colors: ['#8b5cf6'],
   dataLabels: {
      enabled: true,
      textAnchor: 'start' as const,
      offsetX: 5,
      style: { fontSize: '10px', fontWeight: 900, colors: ['#8b5cf6'] },
      formatter: (val: number) => val
   }
}))

// ─────────────────────────────────────────────────────────────
// SECTION 2: NAVEGACIÓN DATA
// ─────────────────────────────────────────────────────────────
interface NavegacionMarea {
   id_marea: string
   buque: string
   pesqueria: string
   flota: string
   estado: string
   etapas: number
   dias: number
}

interface NavegacionGroup {
   pesqueria: string
   mareas: NavegacionMarea[]
}

// Calcular etapas por marea a partir de distributionData
const etapasPorMarea = computed(() => {
   const map = new Map<string, number>()
   props.distributionData.forEach(item => {
      const key = item.mareaId
      const current = map.get(key) || 0
      map.set(key, Math.max(current, item.nroEtapa))
   })
   return map
})

// Helper para ordenar mareas según criterios de auditoría:
// 1. Tipo (Descendente, e.g. MI > MC)
// 2. Año (Ascendente)
// 3. Número (Ascendente)
const sortMareas = (items: NavegacionMarea[]) => {
   return [...items].sort((a, b) => {
      const regex = /^([A-Z]+)-(\d+)-(\d+)$/
      const matchA = a.id_marea.match(regex)
      const matchB = b.id_marea.match(regex)

      if (matchA && matchB) {
         const [, typeA, numA, yearA] = matchA
         const [, typeB, numB, yearB] = matchB

         // 1. Tipo (Descendente)
         const typeComp = typeB.localeCompare(typeA)
         if (typeComp !== 0) return typeComp

         // 2. Año (Ascendente, comparamos como string o num)
         const yearComp = yearA.localeCompare(yearB)
         if (yearComp !== 0) return yearComp

         // 3. Número (Ascendente, numérico)
         return parseInt(numA) - parseInt(numB)
      }
      return a.id_marea.localeCompare(b.id_marea)
   })
}

const navegacionData = computed(() => {
   if (!detailItems.value.length) {
      return { finalizadas: 0, enEjecucion: 0, totalEtapas: 0, grouped: [] as NavegacionGroup[] }
   }

   const items = detailItems.value

   // Construir lista de mareas con etapas
   const mareasRaw: NavegacionMarea[] = items.map(item => ({
      id_marea: item.id_marea,
      buque: item.buque,
      pesqueria: item.pesqueria,
      flota: item.flota,
      estado: item.estado,
      etapas: etapasPorMarea.value.get(item.id) || 1,
      dias: props.mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales
   }))

   // Aplicar ordenamiento global antes de agrupar
   const mareasSorted = sortMareas(mareasRaw)

   // Agrupar por pesquería manteniendo el orden
   const groupMap = new Map<string, NavegacionMarea[]>()
   mareasSorted.forEach(m => {
      if (!groupMap.has(m.pesqueria)) groupMap.set(m.pesqueria, [])
      groupMap.get(m.pesqueria)!.push(m)
   })

   const grouped: NavegacionGroup[] = Array.from(groupMap.entries())
      .map(([pesqueria, items]) => ({ pesqueria, mareas: items }))

   const finalizadas = mareasSorted.filter(m => m.estado === 'Finalizada').length
   const enEjecucion = mareasSorted.filter(m => m.estado !== 'Finalizada').length
   const totalEtapas = mareasSorted.reduce((sum, m) => sum + m.etapas, 0)

   return { finalizadas, enEjecucion, totalEtapas, grouped }
})

// ─────────────────────────────────────────────────────────────
// SECTION 3: PESQUERÍA DATA
// ─────────────────────────────────────────────────────────────
interface PesqueriaResumenRow {
   key: string
   pesqueria: string
   flota: string
   mareas: number
   etapas: number
   dias: number
}

interface PesqueriaDetalle {
   name: string
   mareas: number
   dias: number
   items: NavegacionMarea[]
}

const pesqueriaData = computed(() => {
   if (!props.stats || !detailItems.value.length) {
      return { resumen: [] as PesqueriaResumenRow[], totalFlotas: 0, detalle: [] as PesqueriaDetalle[] }
   }

   // Construir resumen agrupado por pesquería + flota
   const resumenMap = new Map<string, PesqueriaResumenRow>()

   detailItems.value.forEach(item => {
      const key = `${item.pesqueria}||${item.flota}`
      const etapas = etapasPorMarea.value.get(item.id) || 1
      const dias = props.mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales

      if (!resumenMap.has(key)) {
         resumenMap.set(key, {
            key,
            pesqueria: item.pesqueria,
            flota: item.flota,
            mareas: 0,
            etapas: 0,
            dias: 0
         })
      }
      const row = resumenMap.get(key)!
      row.mareas++
      row.etapas += etapas
      row.dias += dias
   })

   const resumen = Array.from(resumenMap.values()).sort((a, b) => {
      const p = a.pesqueria.localeCompare(b.pesqueria)
      if (p !== 0) return p
      return a.flota.localeCompare(b.flota)
   })

   const uniqueFlotas = new Set(resumen.map(r => r.flota))

   // Detalle expandible (usando mareas ya procesadas de navegación)
   const detalleMap = new Map<string, PesqueriaDetalle>()
   navegacionData.value.grouped.forEach(group => {
      detalleMap.set(group.pesqueria, {
         name: group.pesqueria,
         mareas: group.mareas.length,
         dias: group.mareas.reduce((sum, m) => sum + m.dias, 0),
         items: sortMareas(group.mareas)
      })
   })

   const detalle = Array.from(detalleMap.values()).sort((a, b) => a.name.localeCompare(b.name))

   return { resumen, totalFlotas: uniqueFlotas.size, detalle }
})

// Pesquería chart (stacked bar with fleet breakdown)
const pesqueriaChartSeries = computed(() => {
   if (!pesqueriaData.value.resumen.length) return []

   // Agrupar por pesquería, con una serie por flota
   const flotaSet = new Set<string>()
   pesqueriaData.value.resumen.forEach(r => flotaSet.add(r.flota))
   const flotas = Array.from(flotaSet).sort()

   const pesquerias = [...new Set(pesqueriaData.value.resumen.map(r => r.pesqueria))].sort()

   return flotas.map(flota => ({
      name: flota,
      data: pesquerias.map(pesq => {
         const row = pesqueriaData.value.resumen.find(r => r.pesqueria === pesq && r.flota === flota)
         return row?.dias || 0
      })
   }))
})

const pesqueriaChartOptions = computed(() => ({
   chart: {
      type: 'bar',
      stacked: true,
      toolbar: { show: false }
   },
   plotOptions: {
      bar: { horizontal: false, borderRadius: 4, columnWidth: '65%' }
   },
   xaxis: {
      categories: [...new Set(pesqueriaData.value.resumen.map(r => r.pesqueria))].sort(),
      labels: {
         style: { fontSize: '10px', fontWeight: 700 },
         rotate: -45,
         rotateAlways: false,
         trim: true,
         maxHeight: 80
      }
   },
   yaxis: {
      title: { text: 'Días Navegados', style: { fontWeight: 800 } }
   },
   legend: { position: 'top' as const, fontSize: '10px', fontWeight: 700 },
   colors: ['#0ea5e9', '#f59e0b', '#10b981', '#8b5cf6', '#ef4444', '#ec4899'],
   dataLabels: { enabled: false },
   tooltip: {
      shared: true,
      intersect: false
   }
}))
</script>

<style scoped>
.animate-in {
   animation-duration: 0.3s;
   animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
}

.fade-in {
   animation-name: fadeIn;
}

@keyframes fadeIn {
   from {
      opacity: 0;
      transform: translateY(5px);
   }

   to {
      opacity: 1;
      transform: translateY(0);
   }
}
</style>
