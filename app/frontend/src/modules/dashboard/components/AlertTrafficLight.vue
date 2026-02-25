<template>
  <div class="flex flex-col h-full gap-6">
    <!-- Header de Columna -->
    <div class="flex items-center justify-between px-2">
      <div class="flex items-center gap-3">
        <div class="p-2 bg-error/10 rounded-xl relative">
          <div class="w-2 h-2 rounded-full bg-error animate-ping absolute top-0 right-0"></div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-error" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z" />
            <line x1="12" y1="9" x2="12" y2="13" />
            <line x1="12" y1="17" x2="12.01" y2="17" />
          </svg>
        </div>
        <div>
          <h2 class="text-lg font-black text-text uppercase tracking-tight leading-none">
            Central de alertas
          </h2>
          <p class="text-xs font-medium text-text-muted mt-1">Gestión por excepción</p>
        </div>
      </div>
      <div>
        <span class="text-xs font-black px-3 py-1.5 rounded-xl bg-error text-white shadow-lg shadow-error/20">
          {{ totalAlerts }} ACTIVAS
        </span>
      </div>
    </div>

    <!-- Container Scrollable -->
    <div class="flex flex-col gap-4 flex-1 overflow-y-auto custom-scrollbar pr-2 pb-4">

      <!-- CARD 1: Retrasos Críticos (Red) -->
      <div v-if="showDelays"
        class="rounded-3xl border border-border bg-surface shadow-sm relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'delays' ? 'border-l-error' : 'border-l-error/30']">
        <!-- Header Ficha -->
        <button @click="toggleSection('delays')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-border bg-surface-muted': expandedSection === 'delays' }">
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'delays' ? 'bg-error text-white' : 'bg-error/10 text-error']">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path
                  d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-text tracking-wide flex items-center gap-2">
                Entregas Retrasadas
                <span class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors" :class="[
                  revisionDelays.length > 0
                    ? 'bg-error/20 text-error'
                    : 'bg-surface-muted text-text-muted'
                ]">
                  {{ revisionDelays.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Documentación pendiente</p>
            </div>
          </div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-text-muted transition-transform duration-300"
            :class="{ 'rotate-180': expandedSection === 'delays' }" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </button>

        <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100" leave-to-class="max-h-0 opacity-0">
          <div v-if="expandedSection === 'delays'" class="p-5 pt-2">
            <div v-if="revisionDelays.length" class="grid gap-3">
              <div v-for="item in revisionDelays" :key="item.id" @click="openMareaDetail(item.id)"
                class="flex items-center justify-between rounded-xl border border-border bg-surface-muted/50 p-3 transition-colors hover:bg-error/5 hover:border-error/20 cursor-pointer group/item">
                <div class="flex-1 min-w-0 pr-4">
                  <div class="flex items-center gap-2 mb-1">
                    <span class="text-xs font-black text-text group-hover/item:text-error transition-colors">{{
                      item.mareaId }}</span>
                    <span
                      class="text-[10px] font-bold px-1.5 py-0.5 rounded-md bg-surface border border-border text-text-muted uppercase tracking-tight">{{
                        item.vesselName }}</span>
                  </div>
                  <div class="flex items-center gap-1.5 text-text-muted">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                      <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span class="text-[10px] font-bold uppercase">{{ item.obs }}</span>
                  </div>
                </div>

                <div class="flex items-center gap-3">
                  <div class="text-right">
                    <span class="block text-sm font-black text-error leading-none">{{ item.days }}</span>
                    <span class="text-[8px] font-bold text-error uppercase tracking-tighter">Días</span>
                  </div>
                  <button v-if="showActions" @click.stop="openReclamo(item)"
                    class="w-8 h-8 rounded-lg bg-surface shadow-sm border border-border flex items-center justify-center text-text-muted hover:text-error hover:border-error transition-all"
                    title="Reclamar documentación">
                    <MailIcon v-if="item.email" class="w-4 h-4" />
                    <PhoneIcon v-else class="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-surface-muted/50 rounded-2xl border border-dashed border-border">
              <p class="text-xs font-medium text-text-muted">Sin entregas pendientes fuera de término.</p>
            </div>
          </div>
        </Transition>
      </div>

      <!-- CARD 2: Informes Demorados (Orange) -->
      <div v-if="showReports"
        class="rounded-3xl border border-border bg-surface shadow-sm relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'reports' ? 'border-l-warning' : 'border-l-warning/30']">
        <!-- Header Ficha -->
        <button @click="toggleSection('reports')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-border bg-surface-muted': expandedSection === 'reports' }">
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'reports' ? 'bg-warning text-white' : 'bg-warning/10 text-warning']">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                <polyline points="14 2 14 8 20 8" />
                <line x1="16" y1="13" x2="8" y2="13" />
                <line x1="16" y1="17" x2="8" y2="17" />
                <polyline points="10 9 9 9 8 9" />
              </svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-text tracking-wide flex items-center gap-2">
                Informes Demorados
                <span class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors" :class="[
                  reportDelays.length > 0
                    ? 'bg-warning/20 text-warning'
                    : 'bg-surface-muted text-text-muted'
                ]">
                  {{ reportDelays.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Procesamiento de datos</p>
            </div>
          </div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-text-muted transition-transform duration-300"
            :class="{ 'rotate-180': expandedSection === 'reports' }" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </button>

        <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100" leave-to-class="max-h-0 opacity-0">
          <div v-if="expandedSection === 'reports'" class="p-5 pt-2">
            <div v-if="reportDelays.length" class="grid gap-3">
              <div v-for="item in reportDelays" :key="item.id" @click="openMareaDetail(item.id)"
                class="flex items-center justify-between rounded-xl border border-border bg-surface-muted/50 p-3 transition-colors hover:bg-warning/5 hover:border-warning/20 cursor-pointer group/item">
                <div class="flex-1 min-w-0 pr-4">
                  <div class="flex items-center gap-2 mb-1">
                    <span class="text-xs font-black text-text group-hover/item:text-warning transition-colors">{{
                      item.mareaId }}</span>
                    <span
                      class="text-[10px] font-bold px-1.5 py-0.5 rounded-md bg-surface border border-border text-text-muted uppercase tracking-tight">{{
                        item.vesselName }}</span>
                  </div>
                  <div class="flex items-center gap-1.5 text-text-muted">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
                      <circle cx="12" cy="7" r="4" />
                    </svg>
                    <span class="text-[10px] font-bold uppercase">{{ item.obs }}</span>
                  </div>
                </div>

                <div class="flex items-center gap-3">
                  <div class="text-right">
                    <span class="block text-sm font-black text-warning leading-none">{{ item.days }}</span>
                    <span class="text-[8px] font-bold text-warning uppercase tracking-tighter">Días</span>
                  </div>
                  <router-link v-if="showActions" :to="`/mareas/workflow/${item.id}`" @click.stop
                    class="w-8 h-8 rounded-lg bg-surface shadow-sm border border-border flex items-center justify-center text-text-muted hover:text-warning hover:border-warning transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                      stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                      <polyline points="9 18 15 12 9 6" />
                    </svg>
                  </router-link>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-surface-muted/50 rounded-2xl border border-dashed border-border">
              <p class="text-xs font-medium text-text-muted">Sin informes pendientes.</p>
            </div>
          </div>
        </Transition>
      </div>

      <!-- CARD 3: Zarpadas y Arribos (Green) -->
      <div v-if="showMovements"
        class="rounded-3xl border border-border bg-surface shadow-sm relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'movements' ? 'border-l-success' : 'border-l-success/30']">
        <!-- Header Ficha -->
        <button @click="toggleSection('movements')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-border bg-surface-muted': expandedSection === 'movements' }">
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'movements' ? 'bg-success text-white' : 'bg-success/10 text-success']">
              <ShipIcon class="w-4 h-4" />
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-text tracking-wide flex items-center gap-2">
                Zarpadas y Arribos
                <span class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors" :class="[
                  movementAlerts.length > 0
                    ? 'bg-success/20 text-success'
                    : 'bg-surface-muted text-text-muted'
                ]">
                  {{ movementAlerts.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Eventos sin procesar</p>
            </div>
          </div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-text-muted transition-transform duration-300"
            :class="{ 'rotate-180': expandedSection === 'movements' }" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </button>

        <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100" leave-to-class="max-h-0 opacity-0">
          <div v-if="expandedSection === 'movements'" class="p-5 pt-2">
            <div v-if="movementAlerts.length" class="grid gap-3">
              <div v-for="item in movementAlerts" :key="item.id" @click="openMareaDetail(item.metadata.mareaId)"
                class="flex items-center justify-between rounded-xl border border-border bg-surface-muted/50 p-3 transition-colors hover:bg-success/5 hover:border-success/20 cursor-pointer group/item">
                <div class="flex-1 min-w-0">
                  <div class="flex items-center gap-2 mb-1">
                    <span class="text-[10px] font-semibold px-1.5 py-0.5 rounded-md uppercase tracking-tighter border"
                      :class="[
                        item.metadata.type === 'ZARPADA' ? 'bg-cyan-100 text-cyan-700 border-cyan-200 dark:bg-cyan-500/10 dark:text-cyan-400 dark:border-cyan-500/20' :
                          item.metadata.type === 'ARRIBO' ? 'bg-indigo-100 text-indigo-700 border-indigo-200 dark:bg-indigo-500/10 dark:text-indigo-400 dark:border-indigo-500/20' :
                            'bg-success/20 text-success border-success/30'
                      ]">
                      {{ item.metadata.type }}
                    </span>
                    <span class="text-xs font-black text-text truncate">{{ item.metadata.vesselName }}</span>
                    <span class="text-[10px] font-bold text-text-muted whitespace-nowrap">({{ item.metadata.mareaCode
                    }})</span>
                  </div>
                  <div class="flex items-center gap-3">
                    <div class="flex items-center gap-1 text-text-muted min-w-0">
                      <UserCircleIcon class="w-3 h-3 flex-shrink-0" />
                      <span class="text-[9px] font-bold uppercase truncate">{{ getObserverName(item) }}</span>
                    </div>

                    <div class="flex items-center gap-1 text-text-muted border-l border-border pl-3">
                      <svg xmlns="http://www.w3.org/2000/svg" class="w-3 h-3" viewBox="0 0 24 24" fill="none"
                        stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                        <circle cx="12" cy="10" r="3" />
                      </svg>
                      <span class="text-[9px] font-bold uppercase">{{ item.metadata.portName }}</span>
                    </div>
                  </div>

                  <div class="flex items-center gap-2 mt-2">
                    <span class="text-[8px] font-bold text-text-muted uppercase tracking-tight">Fuente:</span>
                    <div class="flex gap-1.5">
                      <template v-for="source in item.metadata.sources" :key="source.name">
                        <TrajectorySourceBadge
                          v-if="source.name === 'TRACKING_CSV' || source.name === 'API_PNA' || source.name === 'PNA'"
                          :source="source.name" :vesselId="item.metadata.vesselId || item.metadata.buqueId"
                          :vesselName="item.metadata.vesselName"
                          :referenceDate="TrajectoryRangeUtils.resolveAlertDates(item).referenceDate"
                          :endDate="TrajectoryRangeUtils.resolveAlertDates(item).endDate"
                          :mareaCode="item.metadata.mareaCode" :abbreviated="true" size="sm" />
                        <div v-else
                          class="flex items-center gap-1 px-1.5 py-0.5 rounded-full border text-[8px] font-black uppercase tracking-tighter transition-colors"
                          :class="[
                            'bg-surface-muted border-border text-text-muted'
                          ]">
                          <span class="w-1.5 h-1.5 rounded-full bg-success"></span>
                          {{ source.name.replace('_CSV', '').replace('API_', '') }}
                        </div>
                      </template>
                    </div>
                  </div>
                </div>

                <div class="text-right ml-4">
                  <div class="text-xs font-black text-text leading-none mb-1">
                    {{ formatDate(item.metadata.eventDate) }}
                  </div>
                  <div class="text-[10px] font-bold text-text-muted">
                    {{ formatTime(item.metadata.eventDate) }}h
                  </div>
                </div>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-surface-muted/50 rounded-2xl border border-dashed border-border">
              <p class="text-xs font-medium text-text-muted">Sin movimientos recientes.</p>
            </div>
          </div>
        </Transition>
      </div>

      <!-- CARD 4: Fatigue (Blue/Brand) -->
      <div v-if="showFatigue"
        class="rounded-3xl border border-border bg-surface shadow-sm relative overflow-hidden group hover:shadow-md transition-all border-l-4"
        :class="[expandedSection === 'fatigue' ? 'border-l-primary' : 'border-l-primary/30']">
        <!-- Header Ficha -->
        <button @click="toggleSection('fatigue')"
          class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
          :class="{ 'border-border bg-surface-muted': expandedSection === 'fatigue' }">
          <div class="flex items-center gap-3">
            <span class="w-8 h-8 rounded-full flex items-center justify-center transition-colors"
              :class="[expandedSection === 'fatigue' ? 'bg-primary text-white' : 'bg-primary/10 text-primary']">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" />
                <circle cx="8.5" cy="7" r="4" />
                <line x1="23" y1="11" x2="17" y2="11" />
              </svg>
            </span>
            <div>
              <h3 class="text-sm font-black uppercase text-text tracking-wide flex items-center gap-2">
                Fatiga / Personal
                <span class="text-[10px] px-1.5 py-0.5 rounded-lg ml-1 font-black transition-colors" :class="[
                  fatigueAlerts.length > 0
                    ? 'bg-primary/20 text-primary'
                    : 'bg-surface-muted text-text-muted'
                ]">
                  {{ fatigueAlerts.length }}
                </span>
              </h3>
              <p class="text-[10px] font-bold text-text-muted uppercase tracking-tighter">Gestión de esfuerzo</p>
            </div>
          </div>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-text-muted transition-transform duration-300"
            :class="{ 'rotate-180': expandedSection === 'fatigue' }" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="6 9 12 15 18 9" />
          </svg>
        </button>

        <Transition enter-active-class="transition-all duration-300 ease-out" enter-from-class="max-h-0 opacity-0"
          enter-to-class="max-h-[1000px] opacity-100" leave-active-class="transition-all duration-200 ease-in"
          leave-from-class="max-h-[1000px] opacity-100" leave-to-class="max-h-0 opacity-0">
          <div v-if="expandedSection === 'fatigue'" class="p-5 pt-2">
            <div v-if="fatigueAlerts.length" class="grid gap-2">
              <div v-for="item in fatigueAlerts" :key="item.id" class="flex flex-col overflow-hidden">
                <!-- Header/Toggle Individual -->
                <div @click="toggleExpandIndividual(item.id)"
                  class="group flex items-center justify-between rounded-xl border border-border bg-surface-muted/50 p-3 transition-all hover:bg-surface hover:shadow-sm cursor-pointer relative"
                  :class="{ 'border-primary/30 bg-surface shadow-sm': expandedIndividualId === item.id }">
                  <div class="flex items-center gap-3">
                    <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center relative shrink-0">
                      <span class="text-[10px] font-black text-primary">{{ item.initials }}</span>
                      <div v-if="expandedIndividualId === item.id"
                        class="absolute -bottom-1 -right-1 bg-primary text-white rounded-full p-0.5 shadow-sm">
                        <svg xmlns="http://www.w3.org/2000/svg" class="w-2 h-2" viewBox="0 0 24 24" fill="none"
                          stroke="currentColor" stroke-width="4" stroke-linecap="round" stroke-linejoin="round">
                          <path d="m18 15-6-6-6 6" />
                        </svg>
                      </div>
                    </div>
                    <div class="flex flex-col min-w-0">
                      <span
                        class="text-xs font-black text-text truncate hover:text-primary transition-colors hover:underline decoration-primary/30 underline-offset-2"
                        @click.stop="openTimeline(item.id, item.name)">
                        {{ item.name }}
                      </span>
                      <span class="text-[9px] font-bold text-text-muted uppercase tracking-tighter">{{ item.reason
                      }}</span>
                    </div>
                  </div>
                  <div class="text-right flex flex-col items-end gap-0.5 shrink-0">
                    <span class="text-xs font-black bg-surface-muted px-2 py-0.5 rounded-lg transition-colors"
                      :class="[item.isOver ? 'text-error' : 'text-success', expandedIndividualId === item.id ? 'bg-primary/10' : '']">
                      {{ item.value }} d
                    </span>
                    <span class="text-[8px] font-bold text-text-muted uppercase tracking-tight">
                      {{ item.percent }}%
                    </span>
                  </div>
                </div>

                <!-- Accordion Content Individual -->
                <Transition enter-active-class="transition-all duration-300 ease-out"
                  enter-from-class="max-h-0 opacity-0" enter-to-class="max-h-[500px] opacity-100"
                  leave-active-class="transition-all duration-200 ease-in" leave-from-class="max-h-[500px] opacity-100"
                  leave-to-class="max-h-0 opacity-0">
                  <div v-if="expandedIndividualId === item.id" class="px-2 pb-2 pt-1">
                    <div class="rounded-xl bg-surface-muted/30 border border-border overflow-hidden">
                      <div class="px-3 py-2 border-b border-border bg-surface/20 flex justify-between items-center">
                        <span class="text-[9px] font-black uppercase text-text-muted tracking-widest">Historial</span>
                        <span class="text-[9px] font-bold text-primary">{{ item.trips?.length || 0 }} viajes</span>
                      </div>
                      <div class="px-2 pb-2 pt-2 space-y-1">
                        <div v-for="(trip, idx) in item.trips" :key="idx"
                          class="p-2 rounded-lg bg-surface border border-border flex justify-between items-center group/trip">
                          <div class="flex flex-col min-w-0 pr-2">
                            <span class="text-[10px] font-bold text-text">{{ trip.mareaCode }}</span>
                            <span class="text-[9px] text-text-muted font-medium truncate">{{ trip.vessel }}</span>
                          </div>
                          <span class="text-[10px] font-bold text-primary whitespace-nowrap">{{ trip.navigatedDays
                          }}d</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </Transition>
              </div>
            </div>
            <div v-else class="text-center py-6 bg-surface-muted/50 rounded-2xl border border-dashed border-border">
              <p class="text-xs font-medium text-text-muted">Sin alertas de fatiga.</p>
            </div>
          </div>
        </Transition>
      </div>
    </div>
    <ReclamoEntregaDialog :show="showReclamoDialog" :id="selectedReclamoItem?.id || ''"
      :marea-id="selectedReclamoItem?.mareaId || ''" :vessel-name="selectedReclamoItem?.vesselName || ''"
      :obs-name="selectedReclamoItem?.obs || ''" :email="selectedReclamoItem?.email"
      :delay-days="selectedReclamoItem?.days || 0"
      :arrival-date="selectedReclamoItem?.arrivalDate ? new Date(selectedReclamoItem.arrivalDate).toLocaleDateString() : ''"
      @close="showReclamoDialog = false" @confirm="handleReclamoConfirm" />
    <ObservadorTimelineDialog :show="showTimelineDialog" :observador-id="selectedObserver?.id"
      :observador-name="selectedObserver?.name" :year="selectedYear" @close="showTimelineDialog = false" />

    <MareaQuickDetailModal :is-open="showMareaModal" :marea-id="selectedMareaId" @close="showMareaModal = false" />
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { storeToRefs } from 'pinia'
import { MailIcon, PhoneIcon, ShipIcon, UserCircleIcon } from '@/icons'
import { useBusinessRulesStore } from '@/modules/shared/stores/business-rules.store'
import dashboardService, { type FatigueAlert, type FatigueTrip, type MovementAlert } from '@/modules/dashboard/services/dashboard.service'
import ReclamoEntregaDialog from './ReclamoEntregaDialog.vue'
import ObservadorTimelineDialog from '@/modules/admin/components/ObservadorTimelineDialog.vue'
import MareaQuickDetailModal from '@/modules/stats/components/MareaQuickDetailModal.vue'
import TrajectorySourceBadge from '@/modules/alerts/components/TrajectorySourceBadge.vue'
import { TrajectoryRangeUtils } from '@/modules/alerts/utils/trajectory-range.utils'
import { useConfigStore } from '@/modules/shared/stores/config.store'

const showReclamoDialog = ref(false)
const selectedReclamoItem = ref<any>(null)
const showTimelineDialog = ref(false)
const selectedObserver = ref<{ id: string, name: string } | null>(null)
const configStore = useConfigStore()
const { selectedYear } = storeToRefs(configStore)
const businessRulesStore = useBusinessRulesStore()

const showMareaModal = ref(false)
const selectedMareaId = ref<string | null>(null)
const { rules } = storeToRefs(businessRulesStore)
const diasNavegadosAnuales = computed(() => rules.value.DIAS_NAVEGADOS_ANUALES || 0)

const openReclamo = (item: any) => {
  selectedReclamoItem.value = item
  showReclamoDialog.value = true
}

const openTimeline = (id: string, name: string) => {
  selectedObserver.value = { id, name }
  showTimelineDialog.value = true
}

const openMareaDetail = (mareaId: string) => {
  if (!mareaId) return
  selectedMareaId.value = mareaId
  showMareaModal.value = true
}

const handleReclamoConfirm = async (payload: any) => {
  try {
    await dashboardService.sendClaim(payload)
    toast.success(`Reclamo enviado correctamente a ${payload.to}`)
  } catch (error) {
    console.error('Error enviando reclamo:', error)
    toast.error('Error al enviar el correo de reclamo')
  } finally {
    showReclamoDialog.value = false
    selectedReclamoItem.value = null
  }
}

const revisionDelays = ref<any[]>([])
const reportDelays = ref<any[]>([])
const movementAlerts = ref<MovementAlert[]>([])
const fatigueAlerts = ref<{
  id: string;
  name: string;
  initials: string;
  value: number;
  percent: number;
  reason: string;
  isOver: boolean;
  daysSinceLast: number | null;
  trips: FatigueTrip[];
}[]>([])

const props = withDefaults(defineProps<{
  showActions?: boolean
  showDelays?: boolean
  showReports?: boolean
  showMovements?: boolean
  showFatigue?: boolean
}>(), {
  showActions: true,
  showDelays: true,
  showReports: true,
  showMovements: true,
  showFatigue: true
})

const expandedSection = ref<'delays' | 'reports' | 'movements' | 'fatigue' | null>(null)
const expandedIndividualId = ref<string | null>(null)

const toggleSection = (section: 'delays' | 'reports' | 'movements' | 'fatigue') => {
  expandedSection.value = expandedSection.value === section ? null : section
}

const toggleExpandIndividual = (id: string) => {
  expandedIndividualId.value = expandedIndividualId.value === id ? null : id
}

const totalAlerts = computed(
  () => revisionDelays.value.length + reportDelays.value.length + movementAlerts.value.length + fatigueAlerts.value.length
)

const getObserverName = (item: any) => item.metadata?.observerName || 'Sin Observador'

const formatDate = (dateInput: any) => {
  if (!dateInput) return '-'

  // Extraer valor si es un objeto de fecha serializado
  const dateStr = typeof dateInput === 'object' && dateInput?.value
    ? dateInput.value
    : dateInput

  const date = new Date(dateStr)
  if (isNaN(date.getTime())) return '-'

  return date.toLocaleDateString(undefined, { day: '2-digit', month: '2-digit' })
}

const formatTime = (dateInput: any) => {
  if (!dateInput) return ''

  // Extraer valor si es un objeto de fecha serializado
  const dateStr = typeof dateInput === 'object' && dateInput?.value
    ? dateInput.value
    : dateInput

  const date = new Date(dateStr)
  if (isNaN(date.getTime())) return ''

  return date.toLocaleTimeString(undefined, { hour: '2-digit', minute: '2-digit', hour12: false })
}

const buildInitials = (name: string) =>
  name
    .split(' ')
    .filter(Boolean)
    .map((n) => n[0])
    .join('')
    .slice(0, 2)

const calculateDaysSince = (dateStr: string | null) => {
  if (!dateStr) return null
  const arrival = new Date(dateStr)
  const now = new Date()

  arrival.setHours(0, 0, 0, 0)
  now.setHours(0, 0, 0, 0)

  const diffTime = now.getTime() - arrival.getTime()
  return Math.max(0, Math.floor(diffTime / (1000 * 60 * 60 * 24)))
}

const loadCriticalDelays = async () => {
  try {
    const data = await dashboardService.getCriticalDelays()
    revisionDelays.value = data
  } catch {
    revisionDelays.value = []
  }
}

const loadFatigueAlerts = async () => {
  try {
    const data: FatigueAlert[] = await dashboardService.getFatigueAlerts()
    fatigueAlerts.value = data
      .map((item) => ({
        id: item.id,
        name: item.name,
        initials: buildInitials(item.name),
        value: item.days,
        percent: Math.round((item.days / (diasNavegadosAnuales.value || 1)) * 100),
        reason: 'Acumulado anual',
        isOver: item.days > diasNavegadosAnuales.value,
        daysSinceLast: calculateDaysSince(item.lastArrival),
        trips: item.trips || []
      }))
      .sort((a, b) => b.value - a.value)
  } catch (error) {
    fatigueAlerts.value = []
  }
}

const loadReportDelays = async () => {
  try {
    const data = await dashboardService.getReportDelays()
    reportDelays.value = data
  } catch {
    reportDelays.value = []
  }
}

const loadMovementAlerts = async () => {
  try {
    const data = await dashboardService.getMovementAlerts()
    movementAlerts.value = data
  } catch {
    movementAlerts.value = []
  }
}

onMounted(() => {
  loadFatigueAlerts()
  loadCriticalDelays()
  loadReportDelays()
  loadMovementAlerts()
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-surface-muted);
  border-radius: 10px;
}

/* Forzar que las alturas de las transiciones funcionen correctamente */
.transition-all {
  backface-visibility: hidden;
}
</style>
