<template>
  <div
    class="relative rounded-3xl border border-border bg-surface p-5 shadow-sm border-l-4 border-l-primary flex flex-col overflow-hidden">
    <!-- Total Badge -->
    <div v-if="filteredStats"
      class="absolute top-0 right-0 px-4 py-1.5 bg-primary/10 text-primary border-b border-l border-primary/20 rounded-bl-2xl font-black text-[10px] tracking-widest uppercase shadow-sm">
      {{ filteredStats.total }} TOTAL
    </div>

    <div class="flex items-center gap-3 mb-6 mt-4">
      <UserGroupIcon class="w-6 h-6 text-primary" />
      <div>
        <h2 class="text-sm font-black text-text uppercase tracking-widest leading-tight">
          Estado del Personal
        </h2>
        <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Distribución operativa de
          observadores</p>
      </div>
      <!-- Export Action -->
      <ExportExcelButton 
        :loading="isExporting"
        title="Exportar dotación completa a Excel"
        @click="handleExport"
        class="ml-auto"
      />
    </div>

    <div class="grid grid-cols-2 lg:grid-cols-4 gap-4" :class="[selectedStatus ? 'mb-8' : '']">
      <WorkforceStatusCard
        v-for="status in distributions"
        :key="status.label"
        :status="status"
        :is-selected="selectedStatus === status.label"
        :show-chart="['Navegando', 'Descanso', 'Disponibles'].includes(status.label) && !!props.data"
        :chart-observers="getFilteredList(
          status.label === 'Navegando' ? (props.data?.listNavegando || []) :
          (status.label === 'Descanso' ? (props.data?.listDescanso || []) : (props.data?.listDisponibles || []))
        )"
        @select-status="selectStatus"
        @select-category="(category) => {
          if (selectedCategory === category && selectedStatus === status.label) {
            selectedCategory = null;
            selectedStatus = 'Disponibles';
          } else {
            selectedCategory = category;
            selectedStatus = status.label;
          }
        }"
      />
    </div>

    <!-- Detailed List Section -->
    <div v-if="selectedStatus" class="animate-fadeIn flex-grow flex flex-col min-h-0">
      <div class="rounded-2xl border border-border overflow-hidden flex flex-col flex-grow">
        <div class="bg-surface-muted px-6 py-3 border-b border-border flex justify-between items-center shrink-0">
          <h3 class="text-xs font-black text-text-muted uppercase tracking-widest flex items-center gap-2">
            Detalle: {{ selectedStatus }}
            <span v-if="selectedCategory" class="px-2 py-0.5 bg-primary text-white text-[9px] rounded-full flex items-center gap-1 animate-fadeIn">
              {{ selectedCategory }}
              <button @click="selectedCategory = null" class="hover:text-white/80">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-2.5 w-2.5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </span>
          </h3>
          <div class="flex items-center gap-3">
            <button @click="isExpanded = true" 
              class="p-1.5 hover:bg-primary/10 text-primary rounded-lg transition-all active:scale-95 group/expand"
              title="Expandir vista">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 transition-transform group-hover/expand:scale-110" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="15 3 21 3 21 9"></polyline>
                <polyline points="9 21 3 21 3 15"></polyline>
                <line x1="21" y1="3" x2="14" y2="10"></line>
                <line x1="3" y1="21" x2="10" y2="14"></line>
              </svg>
            </button>
            <button @click="selectedStatus = null" class="text-text-muted hover:text-text transition-colors">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" fill="none" viewBox="0 0 24 24"
                stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        </div>

        <!-- Filtros y Búsqueda -->
        <div
          class="px-6 py-2.5 bg-surface border-b border-border flex flex-col sm:flex-row sm:items-center gap-4 shrink-0 transition-all">
          <SearchInput v-model="searchQuery" placeholder="Buscar observador, buque o marea..."
            class="!w-full sm:!w-80" />

          <div class="flex gap-2">
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
        </div>

        <div class="flex-grow overflow-y-auto custom-scrollbar min-h-0 max-h-[400px]">
          <table class="w-full text-left border-collapse">
            <thead class="bg-surface sticky top-0 z-10 shadow-sm">
              <tr>
                <th @click="toggleSort('name')"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-1">
                    Observador
                    <ChevronDownIcon v-if="sortBy === 'name'" class="w-3 h-3 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
                <th v-if="selectedStatus === 'Impedidos'"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">Motivo</th>
                <th v-else class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider">
                  {{ selectedStatus === 'Navegando' ? 'Marea Actual / Buque' : 'Último Arribo' }}
                </th>
                <th v-if="selectedStatus !== 'Impedidos'" @click="toggleSort('days')"
                  class="px-6 py-3 text-[10px] font-black uppercase text-text-muted tracking-wider text-right cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center justify-end gap-1">
                    {{ selectedStatus === 'Navegando' ? 'Días' : 'Inactividad' }}
                    <ChevronDownIcon v-if="sortBy === 'days'" class="w-3 h-3 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border bg-surface">
              <tr v-for="item in currentList" :key="item.id" class="transition-all duration-200 group" :class="[
                // Prioridad 1: Designados (Celeste suave)
                (item as any).tieneDesignacionActiva
                  ? 'bg-sky-50 dark:bg-sky-950/20 border-l-4 border-l-sky-400'
                  : item.eventual && (item as any).sexo === 'Femenino'
                    ? 'bg-rose-100/40 dark:bg-rose-900/10 border-l-4 border-l-gray-400'
                    : item.eventual
                      ? 'bg-slate-100 dark:bg-slate-800/60 border-l-4 border-l-slate-400 opacity-90'
                      : (item as any).sexo === 'Femenino'
                        ? 'bg-rose-50 dark:bg-rose-950/20 border-l-4 border-l-rose-300'
                        : 'hover:bg-surface-muted/80',

                // Efecto de brillo en hover para todos los que tienen color
                ((item as any).tieneDesignacionActiva || item.eventual || (item as any).sexo === 'Femenino')
                  ? 'hover:brightness-95 dark:hover:brightness-110' : ''
              ]">
                <td class="px-6 py-3 text-xs font-bold text-text">
                  <div class="flex items-center gap-2">
                    <span
                      class="hover:text-primary transition-colors cursor-pointer hover:underline decoration-primary/30 underline-offset-2"
                      @click="$emit('view-timeline', item.id, item.name)">
                      {{ item.name }}
                    </span>
                    
                    <!-- Botón Editar Inline -->
                    <button v-if="canManageObservations && editingObsId !== item.id" 
                      @click="startEditing(item.id, (item as any).observaciones)"
                      class="opacity-0 group-hover:opacity-100 p-1 hover:bg-primary/10 text-primary rounded transition-all"
                      title="Editar observaciones">
                      <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                          <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                          <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                      </svg>
                    </button>
                  </div>

                  <!-- Modo Edición Inline -->
                  <div v-if="editingObsId === item.id" class="mt-2 flex flex-col gap-1.5 max-w-[180px]">
                    <textarea v-model="tempObservaciones"
                      class="w-full bg-surface border border-primary/30 rounded-lg p-2 text-[9px] font-medium text-text focus:outline-none focus:ring-2 focus:ring-primary/10 min-h-[60px]"
                      placeholder="Observaciones..."></textarea>
                    <div class="flex justify-end gap-2">
                      <button @click="cancelEditing" :disabled="savingInline"
                        class="text-[8px] font-black uppercase text-text-muted hover:text-text">
                        X
                      </button>
                      <button @click="saveInline" :disabled="savingInline"
                        class="text-[8px] font-black uppercase text-primary hover:text-primary-hover">
                        {{ savingInline ? '...' : 'OK' }}
                      </button>
                    </div>
                  </div>

                  <!-- Modo Vista -->
                  <template v-else>
                    <div v-if="canManageObservations && (item as any).observaciones" 
                      class="mt-1 pl-2 border-l-2 border-primary/20 text-[9px] font-medium text-text-muted italic leading-relaxed">
                      {{ (item as any).observaciones }}
                    </div>
                    <span v-else class="block text-[9px] font-normal text-text-muted/40 uppercase tracking-tighter mt-0.5">
                      {{ item.tipoObservador }}
                    </span>
                  </template>
                </td>

                <!-- Impedidos Columns -->
                <td v-if="selectedStatus === 'Impedidos'" class="relative px-6 py-3 text-xs text-text-muted">
                  <div v-if="(item as any).tieneDesignacionActiva"
                    class="absolute top-0 right-0 px-1.5 py-0.5 bg-sky-500 text-white text-[8px] font-black uppercase rounded-bl-lg shadow-sm z-20">
                    Designado
                  </div>
                  {{ (item as any).motivo }}
                </td>

                <!-- Details (Navegando / Disponibles / Descanso) -->
                <td v-else class="px-6 py-3">
                  <div class="flex flex-col gap-0.5">
                    <span class="text-[10px] font-bold tabular-nums" :class="[
                      selectedStatus === 'Navegando'
                        ? ((item as any).enTierra ? 'text-success' : 'text-info')
                        : 'text-text'
                    ]">
                      <template v-if="selectedStatus === 'Navegando'">
                        {{ (item as any).enTierra ? 'En tierra' : 'En navegación' }}
                      </template>
                      <template v-else>
                        {{ formatDate((item as any).lastArrival) }}
                      </template>
                    </span>
                    <div class="flex items-center gap-1.5">
                      <span class="text-[9px] font-bold text-text-muted/60 uppercase tracking-tighter">
                        {{ (item as any).mareaCode || 'S/M' }}
                      </span>
                      <div v-if="(item as any).stageCount > 1" class="relative group/stage">
                        <span
                          class="px-1 py-0.5 bg-primary/10 text-primary text-[7px] font-black rounded border border-primary/20 leading-none cursor-help">
                          E{{ (item as any).stageCount }}
                        </span>
                        <!-- Custom Tooltip -->
                        <div
                          class="absolute bottom-full left-1/2 -translate-x-1/2 mb-2 px-2 py-1 bg-surface border border-border text-text text-[9px] rounded-lg opacity-0 group-hover/stage:opacity-100 transition-all pointer-events-none shadow-theme-lg z-50 whitespace-nowrap font-bold">
                          Etapa {{ (item as any).stageCount }}
                          <div
                            class="absolute top-full left-1/2 -translate-x-1/2 border-4 border-transparent border-t-border">
                          </div>
                          <div
                            class="absolute top-full left-1/2 -translate-x-1/2 border-[3px] border-transparent border-t-surface mt-[-1px]">
                          </div>
                        </div>
                      </div>
                      <span class="text-[9px] font-bold text-text-muted/60 uppercase tracking-tighter">
                        • {{ (item as any).vessel || (item as any).vesselName || 'Desconocido' }}
                      </span>
                    </div>
                    <span class="text-[8px] font-medium text-primary uppercase tracking-widest italic">
                      {{ (item as any).fishery || 'Pesquería N/D' }}
                    </span>
                  </div>
                </td>

                <!-- Metric Column -->
                <td v-if="selectedStatus !== 'Impedidos'"
                  class="relative px-6 py-3 text-xs font-black text-text text-right tabular-nums">
                  <div v-if="(item as any).tieneDesignacionActiva"
                    class="absolute top-0 right-0 px-1.5 py-0.5 bg-sky-500 text-white text-[8px] font-black uppercase rounded-bl-lg shadow-sm z-20">
                    Designado
                  </div>
                  <span :class="selectedStatus === 'Navegando' ? 'text-info' : 'text-text-muted'">{{ (item as any).days
                    }}
                    d</span>
                </td>
              </tr>
              <tr v-if="currentList.length === 0">
                <td colspan="3" class="px-6 py-8 text-center text-xs text-text-muted">No hay observadores en este estado
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal de Vista Expandida -->
    <BaseModal :show="isExpanded" :title="`Detalle: ${selectedStatus}`" @close="isExpanded = false" maxWidth="4xl">
      <div v-if="currentStatusInfo" class="flex flex-col h-[85vh]">
        <!-- Header Estilo Ficha -->
        <div class="px-8 py-6 bg-surface-muted/30 border-b border-border flex items-center justify-between gap-8 shrink-0 relative overflow-hidden">
          <!-- Decoración de fondo -->
          <div class="absolute top-0 right-0 w-64 h-64 bg-primary/5 rounded-full blur-3xl -mr-32 -mt-32 pointer-events-none"></div>
          
          <div class="flex items-center gap-6 relative z-10">
            <div class="w-16 h-16 rounded-2xl flex items-center justify-center shadow-xl transition-transform hover:scale-105" 
              :class="[currentStatusInfo.bgClass]">
              <component :is="currentStatusInfo.icon" class="w-8 h-8" :class="currentStatusInfo.colorClass" />
            </div>
            <div>
              <h2 class="text-2xl font-black text-text uppercase tracking-tighter leading-none mb-1">
                {{ selectedStatus }}
              </h2>
              <div class="flex items-center gap-3">
                <span class="text-4xl font-black tabular-nums tracking-tighter" :class="currentStatusInfo.colorClass">
                  {{ currentStatusInfo.count }}
                </span>
                <div class="flex flex-col">
                  <span class="text-[10px] font-black text-text-muted uppercase tracking-widest leading-none">Personal Activo</span>
                  <span class="text-[12px] font-bold text-text-muted">({{ currentStatusInfo.value }}%)</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Mini Dona y Progreso (Si no es Impedidos) -->
          <div v-if="selectedStatus !== 'Impedidos'" class="flex items-center gap-8">
            <WorkforceDonutChart 
              :observers="getFilteredList(currentStatusObservers)"
              class="!w-24 !h-24 scale-110"
              @select-category="(category) => selectedCategory = category"
            />
            <div class="w-48 hidden md:block">
              <div class="flex justify-between mb-1.5 flex-wrap gap-1">
                <span class="text-[9px] font-black text-text-muted uppercase tracking-widest">Porcentaje de la Dotación</span>
                <span class="text-[10px] font-black" :class="currentStatusInfo.colorClass">{{ currentStatusInfo.value }}%</span>
              </div>
              <div class="h-2 w-full bg-surface-muted rounded-full overflow-hidden shadow-inner border border-border/50">
                <div class="h-full rounded-full transition-all duration-1000 ease-out shadow-sm" :class="currentStatusInfo.bgClass"
                  :style="{ width: currentStatusInfo.value + '%' }"></div>
              </div>
            </div>
          </div>
        </div>

        <!-- Filtros y Búsqueda (Replicados para el Modal) -->
        <div class="px-8 py-4 bg-surface border-b border-border flex items-center gap-6 shrink-0">
          <div class="flex-1 max-w-md">
            <SearchInput v-model="searchQuery" placeholder="Buscar observador, buque o marea..." class="!w-full" />
          </div>
          <div class="flex gap-2 p-1 bg-surface-muted rounded-xl border border-border">
            <button
              v-for="type in [{ key: 'OBSERVADOR', label: 'Observadores' }, { key: 'TECNICO', label: 'Técnicos' }]"
              :key="type.key" @click="toggleType(type.key)"
              class="px-5 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all duration-200"
              :class="[
                selectedTypes.includes(type.key)
                  ? 'bg-primary text-white shadow-md'
                  : 'text-text-muted hover:text-text'
              ]">
              {{ type.label }}
            </button>
          </div>
          
          <div v-if="selectedCategory" class="animate-fadeIn">
            <span class="px-3 py-1.5 bg-primary text-white text-[10px] font-black uppercase rounded-lg flex items-center gap-2 shadow-sm ring-2 ring-primary/20">
              Filtro: {{ selectedCategory }}
              <button @click="selectedCategory = null" class="hover:bg-white/20 p-0.5 rounded transition-colors">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </span>
          </div>
        </div>

        <!-- Tabla (Replicada con scroll del modal) -->
        <div class="flex-grow overflow-y-auto custom-scrollbar px-2">
          <table class="w-full text-left border-collapse">
            <thead class="bg-surface sticky top-0 z-10 shadow-sm">
              <tr>
                <th @click="toggleSort('name')"
                  class="px-8 py-4 text-[10px] font-black uppercase text-text-muted tracking-widest cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center gap-2">
                    Observador
                    <ChevronDownIcon v-if="sortBy === 'name'" class="w-3.5 h-3.5 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
                <th v-if="selectedStatus === 'Impedidos'"
                  class="px-8 py-4 text-[10px] font-black uppercase text-text-muted tracking-widest">Motivo</th>
                <th v-else class="px-8 py-4 text-[10px] font-black uppercase text-text-muted tracking-widest">
                  {{ selectedStatus === 'Navegando' ? 'Marea Actual / Buque' : 'Último Arribo' }}
                </th>
                <th v-if="selectedStatus !== 'Impedidos'" @click="toggleSort('days')"
                  class="px-8 py-4 text-[10px] font-black uppercase text-text-muted tracking-widest text-right cursor-pointer hover:text-primary transition-colors group">
                  <div class="flex items-center justify-end gap-2">
                    {{ selectedStatus === 'Navegando' ? 'Días' : 'Inactividad' }}
                    <ChevronDownIcon v-if="sortBy === 'days'" class="w-3.5 h-3.5 transition-transform duration-300"
                      :class="{ 'rotate-180': sortOrder === 'asc' }" />
                  </div>
                </th>
              </tr>
            </thead>
            <tbody class="divide-y divide-border/50">
              <tr v-for="item in currentList" :key="item.id" 
                class="transition-all duration-200 group" 
                :class="[
                  // Prioridad 1: Designados (Celeste suave)
                  (item as any).tieneDesignacionActiva
                    ? 'bg-sky-50 dark:bg-sky-950/20 border-l-4 border-l-sky-400'
                    : item.eventual && (item as any).sexo === 'Femenino'
                      ? 'bg-rose-100/40 dark:bg-rose-900/10 border-l-4 border-l-gray-400'
                      : item.eventual
                        ? 'bg-slate-100 dark:bg-slate-800/60 border-l-4 border-l-slate-400 opacity-90'
                        : (item as any).sexo === 'Femenino'
                          ? 'bg-rose-50 dark:bg-rose-950/20 border-l-4 border-l-rose-300'
                          : 'hover:bg-surface-muted/80',

                  // Efecto de brillo en hover para todos los que tienen color
                  ((item as any).tieneDesignacionActiva || item.eventual || (item as any).sexo === 'Femenino')
                    ? 'hover:brightness-95 dark:hover:brightness-110' : ''
                ]">
                <td class="px-8 py-4 text-sm font-bold text-text">
                  <div class="flex items-center gap-3">
                    <span
                      class="hover:text-primary transition-colors cursor-pointer hover:underline decoration-primary/30 underline-offset-4"
                      @click="$emit('view-timeline', item.id, item.name)">
                      {{ item.name }}
                    </span>
                    <button v-if="canManageObservations && editingObsId !== item.id" 
                      @click="startEditing(item.id, (item as any).observaciones)"
                      class="opacity-0 group-hover:opacity-100 p-1.5 hover:bg-primary/10 text-primary rounded-lg transition-all">
                      <svg xmlns="http://www.w3.org/2000/svg" class="w-3.5 h-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" /><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                      </svg>
                    </button>
                  </div>

                  <div v-if="editingObsId === item.id" class="mt-3 flex flex-col gap-2 max-w-sm">
                    <textarea v-model="tempObservaciones"
                      class="w-full bg-surface border border-primary/30 rounded-xl p-3 text-xs font-medium text-text focus:outline-none focus:ring-4 focus:ring-primary/5 min-h-[80px]"
                      placeholder="Escriba observaciones..."></textarea>
                    <div class="flex justify-end gap-3">
                      <button @click="cancelEditing" class="text-[10px] font-black uppercase text-text-muted hover:text-text">Cancelar</button>
                      <button @click="saveInline" class="px-4 py-1.5 bg-primary text-white text-[10px] font-black uppercase rounded-lg">Guardar</button>
                    </div>
                  </div>
                  <template v-else>
                    <div v-if="canManageObservations && (item as any).observaciones" 
                      class="mt-2 pl-3 border-l-2 border-primary/30 text-[11px] font-medium text-text-muted italic leading-relaxed">
                      {{ (item as any).observaciones }}
                    </div>
                  </template>
                </td>
                
                <td v-if="selectedStatus === 'Impedidos'" class="px-8 py-4 text-xs font-medium text-text-muted">
                    {{ (item as any).motivo }}
                </td>
                <td v-else class="px-8 py-4">
                  <div class="flex flex-col gap-1">
                    <span class="text-xs font-bold" :class="selectedStatus === 'Navegando' ? 'text-info' : 'text-text'">
                      {{ selectedStatus === 'Navegando' ? ((item as any).enTierra ? 'En tierra' : 'En navegación') : formatDate((item as any).lastArrival) }}
                    </span>
                    <span class="text-[10px] font-bold text-text-muted/60 uppercase tracking-tighter">
                      {{ (item as any).mareaCode || 'S/M' }} • {{ (item as any).vessel || (item as any).vesselName }}
                    </span>
                  </div>
                </td>
                <td v-if="selectedStatus !== 'Impedidos'" class="px-8 py-4 text-right">
                  <span class="text-sm font-black tabular-nums" :class="selectedStatus === 'Navegando' ? 'text-info' : 'text-text-muted'">
                    {{ (item as any).days }} d
                  </span>
                </td>
              </tr>
              <tr v-if="currentList.length === 0">
                <td colspan="3" class="px-8 py-12 text-center text-xs font-medium text-text-muted">
                  No hay observadores que coincidan con los criterios
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </BaseModal>
  </div>
</template>

<script setup lang="ts">
import { ref, markRaw, computed } from 'vue'
import { ShipIcon, UserGroupIcon, DocsIcon, HotelIcon, ChevronDownIcon } from '@/icons'
import type { WorkforceStatus } from '../services/dashboard.service'
import SearchInput from '@/components/ui/SearchInput.vue'
import WorkforceStatusCard from './WorkforceStatusCard.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import WorkforceDonutChart from './WorkforceDonutChart.vue'
import observadoresApi from '@/modules/admin/services/observadores.service'
import statsService from '@/modules/stats/services/stats.service'
import { toast } from 'vue-sonner';
import ExportExcelButton from '@/modules/shared/components/ExportExcelButton.vue';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum';

const props = defineProps<{
  data: WorkforceStatus | null
}>()

const emit = defineEmits(['view-timeline', 'refresh'])

const selectedStatus = ref<string | null>('Navegando')
const selectedTypes = ref<string[]>(['OBSERVADOR'])
const searchQuery = ref('')
const sortBy = ref<'name' | 'days' | null>(null)
const sortOrder = ref<'asc' | 'desc'>('desc')
const selectedCategory = ref<string | null>(null)

const authStore = useAuthStore()
const canManageObservations = computed(() => {
  return authStore.user?.roles.some(role => 
    [ValidRoles.admin, ValidRoles.coordinador].includes(role)
  ) ?? false
})

// Vista Expandida
const isExpanded = ref(false)
const currentStatusInfo = computed(() => {
  if (!selectedStatus.value) return null
  return distributions.value.find(d => d.label === selectedStatus.value)
})

const currentStatusObservers = computed(() => {
  if (!selectedStatus.value || !props.data) return []
  return selectedStatus.value === 'Navegando' ? props.data.listNavegando :
         selectedStatus.value === 'Descanso' ? props.data.listDescanso :
         selectedStatus.value === 'Disponibles' ? props.data.listDisponibles :
         props.data.listImpedidos
})

// Edición Inline
const editingObsId = ref<string | null>(null)
const tempObservaciones = ref('')
const savingInline = ref(false)

const startEditing = (id: string, currentVal: string = '') => {
  editingObsId.value = id
  tempObservaciones.value = currentVal
}

const cancelEditing = () => {
  editingObsId.value = null
  tempObservaciones.value = ''
}

const saveInline = async () => {
  if (!editingObsId.value) return
  
  savingInline.value = true
  try {
    await observadoresApi.updateObservador(editingObsId.value, {
      observaciones: tempObservaciones.value
    })
    toast.success('Observaciones actualizadas')
    cancelEditing()
    emit('refresh')
  } catch (error) {
    console.error('Error al actualizar inline:', error)
    toast.error('No se pudo actualizar')
  } finally {
    savingInline.value = false
  }
}

// Available Composition for Donut Chart
const availableComposition = computed(() => {
  if (!props.data || !props.data.listDisponibles) return { series: [], total: 0 }

  // IMPORTANTE: Aplicar el mismo filtro de tipos que el resto del dashboard
  const list = getFilteredList(props.data.listDisponibles)
  const stats = {
    titulares: 0, // Masc Titular
    femTitular: 0,
    femEventual: 0,
    otrosEventuales: 0, // Masc Eventual
    designados: 0
  }

  list.forEach((obs: any) => {
    if (obs.tieneDesignacionActiva) {
      stats.designados++
      return
    }

    const isFem = obs.sexo === 'Femenino'
    const isEventual = obs.eventual === true

    if (!isEventual && !isFem) stats.titulares++
    else if (!isEventual && isFem) stats.femTitular++
    else if (isEventual && isFem) stats.femEventual++
    else if (isEventual && !isFem) stats.otrosEventuales++
  })

  return {
    series: [stats.titulares, stats.femTitular, stats.femEventual, stats.otrosEventuales, stats.designados],
    total: list.length
  }
})

const isExporting = ref(false)

const handleExport = async () => {
  try {
    isExporting.value = true
    const currentYear = new Date().getFullYear()
    
    // Si el filtro de 'TECNICO' no está seleccionado, le indicamos al backend que los excluya
    const filterValue = selectedTypes.value.includes('TECNICO') ? undefined : 'ONLY_OBSERVERS'
    
    await statsService.downloadWorkforceExport(currentYear, filterValue)
    
    toast.success('Excel generado correctamente', {
      description: filterValue === 'ONLY_OBSERVERS' 
        ? `Dotación de Observadores (${currentYear})`
        : `Dotación Completa (${currentYear})`,
    })
  } catch (error) {
    console.error('Error al exportar personal:', error)
    toast.error('Error al exportar', {
      description: 'No se pudo generar el archivo Excel.',
    })
  } finally {
    isExporting.value = false
  }
}

const donutOptions = computed(() => ({
  chart: {
    type: 'donut',
    sparkline: { enabled: true },
    animations: { enabled: true, easing: 'easeinout', speed: 800 },
    events: {
      dataPointSelection: (event: any, chartContext: any, config: any) => {
        const category = ['Titulares', 'Fem. Titular', 'Fem. Eventual', 'Otros Eventuales', 'Designados'][config.dataPointIndex]
        if (selectedCategory.value === category) {
            selectedCategory.value = null
        } else {
            selectedCategory.value = category
            selectedStatus.value = 'Disponibles'
        }
      }
    }
  },
  colors: ['#22c55e', '#ec4899', '#fb7185', '#94a3b8', '#38bdf8'],
  labels: ['Titulares', 'Fem. Titular', 'Fem. Eventual', 'Otros Eventuales', 'Designados'],
  stroke: { show: true, width: 2, colors: ['var(--color-surface)'] },
  plotOptions: {
    pie: {
      donut: {
        size: '55%',
        background: 'transparent',
        labels: {
          show: true,
          name: { show: false },
          value: {
            show: true,
            fontSize: '14px',
            fontFamily: 'inherit',
            fontWeight: '900',
            color: 'var(--color-text)',
            offsetY: 5,
            formatter: (val: string) => val
          },
          total: {
            show: true,
            showAlways: true,
            offsetY: 0,
            formatter: (w: any) => {
              return w.globals.seriesTotals.reduce((a: number, b: number) => a + b, 0).toString()
            }
          }
        }
      }
    }
  },
  dataLabels: { enabled: false },
  tooltip: {
    enabled: true,
    custom: function ({ series, seriesIndex, w }: any) {
      const val = series[seriesIndex];
      const label = w.globals.labels[seriesIndex];
      const colors = w.globals.colors;
      const accent = colors[seriesIndex] || 'var(--color-primary)';

      return `
        <div class="m-6 px-4 py-4 bg-surface/90 backdrop-blur-xl text-text border border-border/50 rounded-2xl flex flex-col gap-3 shadow-[0_20px_50px_rgba(0,0,0,0.5)] ring-1 ring-black/10 min-w-[200px]">
          <div class="flex items-center justify-between border-b border-border/30 pb-2 mb-1">
            <div class="flex items-center gap-2">
              <span class="w-1.5 h-3 rounded-full" style="background:${accent}"></span>
              <span class="text-[10px] text-text-muted uppercase font-black tracking-widest">${label}</span>
            </div>
            <div class="px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[9px] font-black uppercase">Estado</div>
          </div>

          <div class="flex flex-col gap-1">
            <span class="text-[9px] font-black text-primary uppercase tracking-tighter">Observadores Totales</span>
            <div class="flex items-baseline gap-1">
              <span class="text-2xl font-black tabular-nums">${val}</span>
              <span class="text-[10px] font-bold text-text-muted">obs.</span>
            </div>
          </div>

          <div class="pt-2 border-t border-border/30 flex justify-between items-center opacity-60">
              <span class="text-[8px] font-black italic uppercase">Click para filtrar lista</span>
              <span class="text-[10px]">👥</span>
          </div>
        </div>
      `;
    }
  },
  legend: { show: false }
}))

const toggleSort = (key: 'name' | 'days') => {
  if (sortBy.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortOrder.value = key === 'name' ? 'asc' : 'desc'
  }
}

const toggleType = (type: string) => {
  const index = selectedTypes.value.indexOf(type)
  if (index > -1) {
    // Solo permitir deseleccionar si queda al menos un elemento
    if (selectedTypes.value.length > 1) {
      selectedTypes.value.splice(index, 1)
    }
  } else {
    selectedTypes.value.push(type)
  }
}

type DistributionItem = {
  label: string
  count: number | string
  value: number
  colorClass: string
  bgClass: string
  borderColorClass: string
  ringClass: string
  icon: any
  color?: string
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  const date = new Date(dateString)
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit'
  })
}

const getFilteredList = (list: any[]) => {
  return (list || []).filter(item => {
    const raw = (item.tipoObservador || item.tipo_observador || '').toString().toUpperCase();
    let itemType = 'OBSERVADOR';
    if (raw.includes('TECNIC')) itemType = 'TECNICO';
    return selectedTypes.value.includes(itemType);
  });
}

const filteredStats = computed(() => {
  if (!props.data) return { navegando: 0, descanso: 0, disponibles: 0, impedidos: 0, total: 0 }

  const navegando = getFilteredList(props.data.listNavegando).length
  const descanso = getFilteredList(props.data.listDescanso).length
  const disponibles = getFilteredList(props.data.listDisponibles).length
  const impedidos = getFilteredList(props.data.listImpedidos).length
  const total = navegando + descanso + disponibles + impedidos

  return { navegando, descanso, disponibles, impedidos, total }
})

const distributions = computed<DistributionItem[]>(() => {
  if (!props.data) return []
  const counts = filteredStats.value
  const total = counts.total || 1

  return [
    {
      label: 'Navegando',
      count: counts.navegando,
      value: total > 0 ? Math.round((counts.navegando / total) * 100) : 0,
      icon: markRaw(ShipIcon),
      color: 'info',
      colorClass: 'text-info',
      bgClass: 'bg-info/15',
      borderColorClass: 'border-info',
      ringClass: 'ring-info',
    },
    {
      label: 'Descanso',
      count: counts.descanso,
      value: total > 0 ? Math.round((counts.descanso / total) * 100) : 0,
      icon: markRaw(HotelIcon),
      color: 'primary',
      colorClass: 'text-primary',
      bgClass: 'bg-primary/15',
      borderColorClass: 'border-primary',
      ringClass: 'ring-primary',
    },
    {
      label: 'Disponibles',
      count: counts.disponibles,
      value: total > 0 ? Math.round((counts.disponibles / total) * 100) : 0,
      icon: markRaw(UserGroupIcon),
      color: 'success',
      colorClass: 'text-success',
      bgClass: 'bg-success/15',
      borderColorClass: 'border-success',
      ringClass: 'ring-success',
    },
    {
      label: 'Impedidos',
      count: counts.impedidos,
      value: total > 0 ? Math.round((counts.impedidos / total) * 100) : 0,
      icon: markRaw(DocsIcon),
      color: 'error',
      colorClass: 'text-error',
      bgClass: 'bg-error/15',
      borderColorClass: 'border-error',
      ringClass: 'ring-error',
    },
  ]
})

const selectStatus = (label: string) => {
  if (selectedStatus.value === label) {
    selectedStatus.value = null
  } else {
    selectedStatus.value = label
    // Limpiar filtro de categoría si cambiamos de estado y no es Disponibles
    if (label !== 'Disponibles') {
      selectedCategory.value = null
    }
  }
}

const currentList = computed(() => {
  if (!props.data || !selectedStatus.value) return []
  let list: any[] = []
  switch (selectedStatus.value) {
    case 'Navegando': list = props.data.listNavegando; break
    case 'Descanso': list = props.data.listDescanso; break
    case 'Disponibles': list = props.data.listDisponibles; break
    case 'Impedidos': list = props.data.listImpedidos; break
    default: list = []
  }

  // 1. Filtrado por tipo (si aplica)
  list = getFilteredList(list);

  // 2. Filtrado por búsqueda
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
    list = list.filter(item => {
      const name = item.name.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const vessel = (item.vessel || item.vesselName || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const marea = (item.mareaCode || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
      const fishery = (item.fishery || '').toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

      return name.includes(q) || vessel.includes(q) || marea.includes(q) || fishery.includes(q);
    });
  }

  // 2.5 Filtrado por categoría de la dona (Aplica a cualquier estado seleccionado)
  if (selectedCategory.value) {
    list = list.filter(obs => {
      if (selectedCategory.value === 'Designados') return obs.tieneDesignacionActiva;
      if (obs.tieneDesignacionActiva) return false; // Los demás no deben ser designados

      const isFem = obs.sexo === 'Femenino';
      const isEventual = obs.eventual === true;

      if (selectedCategory.value === 'Titulares') return !isEventual && !isFem;
      if (selectedCategory.value === 'Fem. Titular') return !isEventual && isFem;
      if (selectedCategory.value === 'Fem. Eventual') return isEventual && isFem;
      if (selectedCategory.value === 'Otros Eventuales') return isEventual && !isFem;

      return true;
    });
  }

  // 3. Ordenamiento Jerárquico Unificado (Aplica a Navegando, Descanso y Disponibles)
  const hierarchicalStatuses = ['Navegando', 'Descanso', 'Disponibles']

  if (hierarchicalStatuses.includes(selectedStatus.value)) {
    list = [...list].sort((a, b) => {
      // Prioridad 1: Eventual (false < true) -> Titulares primero
      if (a.eventual !== b.eventual) return a.eventual ? 1 : -1

      // Prioridad 2: Sexo (Masculino < Femenino) -> Según orden de la torta (Titulares masculinos son la primera categoría)
      if (a.sexo !== b.sexo) return a.sexo === 'Masculino' ? -1 : 1

      // Prioridad 3: Orden dinámico (Manual o por días)
      const key = sortBy.value || 'days'
      const order = sortOrder.value || 'desc'

      const valA = a[key]
      const valB = b[key]

      if (valA < valB) return order === 'asc' ? -1 : 1
      if (valA > valB) return order === 'asc' ? 1 : -1
      return 0
    })
  } else if (selectedStatus.value === 'Impedidos' && sortBy.value) {
    // Para Impedidos, ordenamiento estándar si hay una columna seleccionada
    list = [...list].sort((a, b) => {
      const key = sortBy.value as 'name' | 'days'
      const valA = a[key]
      const valB = b[key]

      if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1
      if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1
      return 0
    })
  }

  return list
})
</script>

<style scoped>
.animate-fadeIn {
  animation: fadeIn 0.3s ease-out forwards;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>
