<template>
  <AdminLayout
    :title="`Marea ${marea.nro_marea}/${marea.anio_marea}`"
    description="Detalles técnicos y operativos de la marea."
  >
    <div class="max-w-6xl mx-auto pb-12 px-4 sm:px-6 lg:px-8">
      <!-- Header Actions & Meta -->
      <div class="mb-8 flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
        <div class="flex flex-wrap items-center gap-4">
          <button
            @click="goBack"
            class="group flex items-center gap-2 text-sm font-semibold text-brand-500 hover:text-brand-600 transition-all bg-brand-50 dark:bg-brand-500/10 px-3 py-1.5 rounded-lg"
          >
            <ArrowLeftIcon class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
            Volver
          </button>

          <div
            class="flex items-center gap-2 px-3 py-1.5 bg-brand-50 dark:bg-brand-500/10 text-brand-700 dark:text-brand-400 text-xs font-bold uppercase tracking-wider rounded-full border border-brand-100 dark:border-brand-500/20"
          >
            <div class="w-1.5 h-1.5 rounded-full bg-brand-500 animate-pulse"></div>
            {{ marea.estado_nombre }}
          </div>

          <div
            v-if="marea.estado_codigo === 'EN_EJECUCION' && (!etapas[etapas.length - 1] || etapas[etapas.length - 1].fechaArribo)"
            class="flex items-center gap-2 px-3 py-1.5 bg-blue-50 dark:bg-blue-500/10 text-blue-700 dark:text-blue-400 text-xs font-bold uppercase tracking-wider rounded-full border border-blue-100 dark:border-blue-500/20"
          >
            En Tierra
          </div>
        </div>

        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
          <button
            class="px-5 py-2.5 text-sm font-semibold text-gray-700 dark:text-gray-200 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-700 transition-all shadow-sm active:scale-95 text-center"
            @click="goBack"
          >
            Descartar
          </button>
          <button
            class="px-5 py-2.5 text-sm font-semibold text-white bg-brand-500 border border-transparent rounded-xl hover:bg-brand-600 transition-all shadow-md shadow-brand-500/20 active:scale-95 flex items-center justify-center gap-2"
            @click="saveChanges"
          >
            <CheckIcon class="w-4 h-4" />
            Guardar Cambios
          </button>
        </div>
      </div>

      <!-- Correction/Locked Banner -->
      <div
        v-if="marea.estado_codigo === 'EN_CORRECCION'"
        class="mb-8 p-4 bg-error-50 dark:bg-error-500/10 border border-error-100 dark:border-error-500/20 rounded-2xl flex flex-col sm:flex-row items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500"
      >
        <div
          class="w-12 h-12 rounded-xl bg-error-500 flex items-center justify-center text-white shrink-0 shadow-lg shadow-error-500/20"
        >
          <LockIcon class="w-6 h-6" />
        </div>
        <div class="flex-1 text-center sm:text-left">
          <h3
            class="text-sm font-black text-error-700 dark:text-error-400 uppercase tracking-wider"
          >
            Marea Bloqueada para Extracción
          </h3>
          <p class="text-xs text-error-600 dark:text-error-500 mt-0.5">
            En proceso de corrección por:
            <span class="font-bold underline">{{ marea.responsable_correccion }}</span
            >. Los datos finales no estarán disponibles hasta la nueva carga.
          </p>
        </div>
        <div
          class="px-4 py-2 bg-white dark:bg-gray-900 rounded-lg border border-error-100 dark:border-error-800 text-[10px] font-bold text-error-600 dark:text-error-400 uppercase tracking-widest whitespace-nowrap"
        >
          Estado: En Revisión
        </div>
      </div>

      <!-- Main Navigation Tabs -->
      <div
        class="mb-8 border-b border-gray-200 dark:border-gray-800 overflow-x-auto custom-scrollbar"
      >
        <div class="flex gap-8 min-w-max">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            class="pb-4 text-sm font-bold transition-all relative"
            :class="
              activeTab === tab.id
                ? 'text-brand-500'
                : 'text-gray-400 hover:text-gray-600 dark:hover:text-gray-200'
            "
          >
            <div class="flex items-center gap-2">
              <component :is="tab.icon" class="w-4 h-4" />
              {{ tab.label }}
            </div>
            <div
              v-if="activeTab === tab.id"
              class="absolute bottom-0 left-0 right-0 h-0.5 bg-brand-500 rounded-full"
            ></div>
          </button>
        </div>
      </div>

      <!-- Tab Content Area -->
      <div class="grid grid-cols-1 gap-8">
        <!-- 1. General Tab -->
        <div v-if="activeTab === 'general'" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <div class="lg:col-span-2 space-y-8">
            <!-- Identification Card -->
            <div
              class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2"
              >
                <DocsIcon class="w-5 h-5 text-brand-500" />
                Identificación de la Marea
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Año Marea</label
                  >
                  <input
                    v-model="marea.anio_marea"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="2023"
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Nro. Marea</label
                  >
                  <input
                    v-model="marea.nro_marea"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="000"
                  />
                </div>
              </div>
            </div>

            <!-- Ship & Fishery Card -->
            <div
              class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2"
              >
                <ShipIcon class="w-5 h-5 text-blue-500" />
                Buque y Pesquería
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Buque Seleccionado</label
                  >
                  <SearchableSelect
                    v-model="marea.id_buque"
                    :options="buqueOptions"
                    placeholder="Seleccione buque..."
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Pesquería</label
                  >
                  <SearchableSelect
                    v-model="marea.id_pesqueria"
                    :options="pesqueriaOptions"
                    placeholder="Seleccione pesquería..."
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Arte Principal</label
                  >
                  <SearchableSelect
                    v-model="marea.id_arte_principal"
                    :options="arteOptions"
                    placeholder="Seleccione arte..."
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Fecha Zarpada Est.</label
                  >
                  <DatePicker
                    v-model="marea.fecha_zarpada_estimada"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Tipo de Marea</label
                  >
                  <select
                    v-model="marea.tipo_marea"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                  >
                    <option value="MC">Comercial (MC)</option>
                    <option value="CI">Institucional (CI)</option>
                  </select>
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Días Estimados</label
                  >
                  <input
                    v-model="marea.dias_estimados"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="0"
                  />
                </div>
              </div>
            </div>



            <!-- Observer Dates & Zona Austral -->
            <div
              class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2"
              >
                <CalenderIcon class="w-5 h-5 text-brand-500" />
                Fechas del Observador y Zona Austral
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Inicio Observador</label
                  >
                  <DatePicker
                    v-model="marea.fecha_inicio_observador"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Fin Observador</label
                  >
                  <DatePicker
                    v-model="marea.fecha_fin_observador"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Días Zona Austral</label
                  >
                  <input
                    v-model="marea.dias_zona_austral"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="0"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Cálculo Zona Austral</label
                  >
                  <select
                    v-model="marea.tipo_calculo_zona_austral"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                  >
                    <option value="AUTOMATICO">Automático</option>
                    <option value="MANUAL">Manual</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <!-- Sidebar on General Tab -->
          <div class="space-y-8">
            <!-- Metadata Card -->
            <div
              class="bg-gray-50 dark:bg-gray-800/50 border border-gray-200 dark:border-gray-800 rounded-2xl p-6"
            >
              <h4 class="text-xs font-bold uppercase tracking-wider text-gray-400 mb-4">
                Metadatos de Seguimiento
              </h4>
              <div class="space-y-4">
                <div class="flex justify-between text-sm">
                  <span class="text-gray-500">Fecha Creación</span>
                  <span class="font-medium dark:text-gray-300">{{ formatDate(marea.fecha_creacion) }}</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-gray-500">Últ. Actualización</span>
                  <span class="font-medium dark:text-gray-300">{{ formatDate(marea.fecha_ultima_actualizacion) }}</span>
                </div>
                <div class="pt-4 border-t border-gray-200 dark:border-gray-700">
                  <div class="flex items-center gap-2">
                    <input
                      type="checkbox"
                      v-model="marea.activo"
                      class="rounded border-gray-300 text-brand-500"
                    />
                    <span class="text-sm font-medium text-gray-700 dark:text-gray-300"
                      >Marea Activa</span
                    >
                  </div>
                </div>
              </div>
            </div>

            <!-- Notes Quick Access -->
            <div
              class="bg-amber-50 dark:bg-amber-500/10 border border-amber-100 dark:border-amber-500/20 rounded-2xl p-6"
            >
              <h4
                class="text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400 mb-3 flex items-center gap-2"
              >
                <InfoIcon class="w-4 h-4" />
                Observaciones Importantes
              </h4>
              <textarea
                v-model="marea.observaciones"
                rows="4"
                class="w-full bg-transparent border-none text-sm text-amber-800 dark:text-amber-300 focus:ring-0 placeholder:text-amber-300 resize-none"
                placeholder="Añada notas que otros usuarios verán inmediatamente..."
              ></textarea>
            </div>
          </div>
        </div>

        <!-- 2. Etapas Tab -->
        <div v-if="activeTab === 'etapas'" class="space-y-6">
          <div class="flex items-center justify-between mb-2">
            <div>
                <h3 class="text-lg font-bold text-gray-800 dark:text-white">Etapas de Navegación</h3>
                <p class="text-xs text-gray-500 mt-1">Gestione los tramos del viaje, puertos y fechas reales.</p>
            </div>
          </div>

          <NavigationStagesEditor
            v-model="etapas"
            :puertoOptions="puertoOptions"
            :pesqueriaOptions="pesqueriaOptions"
            :puertoBaseId="marea.puertoBaseId"
            :defaultPesqueriaId="marea.id_pesqueria"
          />
        </div>

        <!-- 3. Observadores Tab -->
        <div
          v-if="activeTab === 'observadores'"
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6"
        >
          <div
            v-for="obs in observadores"
            :key="obs.id"
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm flex items-start gap-4"
          >
            <div
              class="w-16 h-16 rounded-full bg-gradient-to-br from-brand-100 to-blue-200 dark:from-brand-500/20 dark:to-blue-500/20 flex items-center justify-center text-brand-600 dark:text-brand-400 font-extrabold text-xl border-2 border-brand-50 dark:border-brand-500/20"
            >
              {{ obs.iniciales }}
            </div>
            <div class="flex-1">
              <div class="flex justify-between items-start mb-1">
                <h4 class="font-bold text-gray-800 dark:text-white">
                  {{ obs.nombre }} {{ obs.apellido }}
                </h4>
                <div
                  class="text-[10px] font-black tracking-tighter px-1.5 py-0.5 bg-gray-100 dark:bg-gray-800 rounded text-gray-500"
                >
                  ID {{ obs.codigo }}
                </div>
              </div>
              <p class="text-xs text-brand-500 font-bold mb-3">{{ obs.rol }}</p>
              <div class="space-y-1 text-[11px] text-gray-500">
                <div class="flex items-center gap-2">
                  <CalenderIcon class="w-3 h-3" /> Inicio: {{ obs.inicio }}
                </div>
                <div class="flex items-center gap-2">
                  <CalenderIcon class="w-3 h-3" /> Fin: {{ obs.fin || 'Activo' }}
                </div>
                <div class="flex items-center gap-2">
                  <CheckIcon class="w-3 h-3" />
                  Designado: {{ obs.es_designado ? 'Sí' : 'No' }}
                </div>
              </div>
            </div>
          </div>
          <button
            class="border-2 border-dashed border-gray-200 dark:border-gray-800 rounded-2xl p-6 flex flex-col items-center justify-center text-gray-400 hover:text-brand-500 hover:border-brand-200 transition-all gap-2 group"
          >
            <div
              class="p-2 rounded-full group-hover:bg-brand-50 dark:group-hover:bg-brand-500/10 transition-colors"
            >
              <PlusIcon class="w-6 h-6" />
            </div>
            <span class="text-sm font-bold">Asignar Observador</span>
          </button>
        </div>

        <!-- 4. Flujo Tab -->
        <div v-if="activeTab === 'workflow'" class="max-w-3xl mx-auto w-full">
          <div
            class="relative pl-8 space-y-10 border-l-2 border-gray-100 dark:border-gray-800 ml-4"
          >
            <div v-for="mov in movimientos" :key="mov.id" class="relative">
              <div
                class="absolute -left-[41px] top-0 w-5 h-5 rounded-full bg-white dark:bg-gray-900 border-4"
                :class="mov.evento === 'CAMBIO_ESTADO' ? 'border-brand-500' : 'border-gray-300'"
              ></div>
              <div class="space-y-2">
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-2">
                    <span class="text-xs font-bold text-brand-500 uppercase">{{ mov.evento }}</span>
                    <span class="text-xs text-gray-400">•</span>
                    <span
                      class="text-xs font-semibold text-gray-600 dark:text-gray-400 flex items-center gap-1"
                    >
                      <UserCircleIcon class="w-3.5 h-3.5" />
                      {{ mov.usuario }}
                    </span>
                  </div>
                  <span class="text-[11px] text-gray-400">{{ mov.fecha }}</span>
                </div>
                <div
                  v-if="mov.detalle || mov.comentarios || mov.estado_desde || mov.estado_hasta || mov.cantidad_muestras_otolitos"
                  class="bg-gray-50 dark:bg-gray-800/40 border border-gray-100 dark:border-gray-800 p-4 rounded-xl"
                >
                  <p v-if="mov.detalle" class="text-sm text-gray-700 dark:text-gray-300 font-medium mb-3">{{ mov.detalle }}</p>
                  
                  <!-- User Comments -->
                  <div v-if="mov.comentarios" class="mb-4 p-3 bg-brand-500/5 dark:bg-brand-500/10 border-l-2 border-l-brand-500 rounded-r-lg">
                    <p class="text-xs text-brand-600 dark:text-brand-400 font-bold uppercase tracking-wider mb-1 flex items-center gap-1">
                      <ChatIcon class="w-3 h-3" />
                      Comentario del usuario
                    </p>
                    <p class="text-sm text-gray-600 dark:text-gray-400 whitespace-pre-wrap italic">"{{ mov.comentarios }}"</p>
                  </div>

                  <div v-if="mov.estado_desde || mov.estado_hasta || mov.cantidad_muestras_otolitos" class="flex flex-wrap gap-2 pt-2 border-t border-gray-100 dark:border-gray-800">
                    <span
                      v-if="mov.estado_desde"
                      class="text-[10px] px-2 py-0.5 bg-white dark:bg-gray-900 rounded border border-gray-200 dark:border-gray-700 text-gray-500"
                      >Estado desde: {{ mov.estado_desde }}</span
                    >
                    <span
                      v-if="mov.estado_hasta"
                      class="text-[10px] px-2 py-0.5 bg-white dark:bg-gray-900 rounded border border-gray-200 dark:border-gray-700 text-gray-500"
                      >Estado hasta: {{ mov.estado_hasta }}</span
                    >
                    <span
                      v-if="mov.cantidad_muestras_otolitos"
                      class="text-[10px] px-2 py-0.5 bg-white dark:bg-gray-900 rounded border border-gray-200 dark:border-gray-700 text-gray-500"
                      >Muestras: {{ mov.cantidad_muestras_otolitos }}</span
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 5. Documentación Tab -->
        <div v-if="activeTab === 'docs'" class="space-y-16">
          <div v-for="cat in docCategories" :key="cat.id" class="space-y-6">
            <div class="flex items-center justify-between px-2">
              <h3
                class="text-xs font-black uppercase tracking-[0.25em] text-gray-400 dark:text-gray-500 flex items-center gap-4"
              >
                <div class="w-10 h-[2px] bg-gradient-to-r from-brand-500 to-transparent rounded-full"></div>
                {{ cat.label }}
              </h3>
              <span class="text-[10px] font-bold bg-gray-100 dark:bg-gray-800 text-gray-500 px-2 py-0.5 rounded-full"
                >{{ getFilesByCategory(cat.id).length }} archivos</span
              >
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Extraction Blocked Warning for DATOS Category -->
              <div
                v-if="cat.id === 'DATOS' && marea.estado_codigo === 'EN_CORRECCION'"
                class="md:col-span-2 lg:col-span-3 bg-amber-50 dark:bg-amber-500/5 border border-dashed border-amber-200 dark:border-amber-500/20 rounded-3xl p-6 flex items-center gap-5"
              >
                <div
                  class="w-12 h-12 rounded-2xl bg-amber-100 dark:bg-amber-500/10 flex items-center justify-center text-amber-600 dark:text-amber-400 shrink-0 shadow-sm"
                >
                  <LockIcon class="w-6 h-6" />
                </div>
                <div>
                  <h4
                    class="text-sm font-black text-amber-800 dark:text-amber-400 uppercase tracking-wider"
                  >
                    Extracción de datos bloqueada temporalmente
                  </h4>
                  <p class="text-xs text-amber-700 dark:text-amber-500 mt-1 opacity-80">
                    La descarga de archivos de datos está restringida mientras se procesan las
                    correcciones enviadas. Los archivos volverán a estar disponibles tras la validación final.
                  </p>
                </div>
              </div>

              <!-- File Cards -->
              <div
                v-for="file in getFilesByCategory(cat.id)"
                :key="file.id"
                class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-3xl p-6 shadow-sm hover:shadow-xl hover:scale-[1.02] hover:border-brand-200/50 dark:hover:border-brand-500/30 transition-all duration-300 group flex items-center gap-5 relative overflow-hidden"
              >
                <!-- Format Icon -->
                <div
                  class="w-14 h-14 rounded-2xl flex items-center justify-center shrink-0 shadow-inner group-hover:scale-110 transition-transform duration-300"
                  :class="getFormatColor(file.formato)"
                >
                  <FileTextIcon v-if="['PDF', 'DOCX'].includes(file.formato)" class="w-7 h-7" />
                  <RefreshIcon v-else class="w-7 h-7 rotate-45" />
                </div>

                <div class="flex-1 min-w-0">
                  <h4 class="text-sm font-bold text-gray-800 dark:text-gray-100 truncate group-hover:text-brand-600 dark:group-hover:text-brand-400 transition-colors">
                    {{ file.nombre }}
                  </h4>
                  <div class="flex items-center flex-wrap gap-2 mt-1.5 opacity-70">
                    <span class="text-[10px] font-black uppercase tracking-tight">{{ file.formato }}</span>
                    <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-600"></span>
                    <span class="text-[10px] font-medium">{{ file.fecha }}</span>
                    <template v-if="file.tipo_archivo">
                      <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-600"></span>
                      <span class="text-[10px] font-medium">{{ file.tipo_archivo }}</span>
                    </template>
                    <template v-if="file.version">
                      <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-600"></span>
                      <span class="text-[10px] font-bold text-brand-500">v{{ file.version }}</span>
                    </template>
                  </div>
                </div>

                <div class="flex items-center gap-1">
                  <button
                    class="p-2.5 text-gray-400 hover:text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-xl transition-all active:scale-95"
                    title="Descargar Archivo"
                  >
                    <DownloadIcon class="w-5 h-5" />
                  </button>
                </div>
              </div>

              <!-- Upload Placeholder for Category -->
              <button
                class="border-2 border-dashed border-gray-100 dark:border-gray-800/50 rounded-3xl p-6 flex items-center justify-center gap-4 text-gray-400 hover:border-brand-300 hover:text-brand-600 dark:hover:text-brand-400 hover:bg-brand-50/30 dark:hover:bg-brand-500/5 transition-all duration-300 group shadow-sm active:scale-95"
              >
                <div class="w-10 h-10 rounded-full bg-gray-50 dark:bg-gray-800 flex items-center justify-center group-hover:bg-brand-100 dark:group-hover:bg-brand-500/20 transition-colors">
                  <CloudUploadIcon class="w-5 h-5 group-hover:scale-110 transition-transform" />
                </div>
                <span class="text-xs font-black uppercase tracking-widest"
                  >Adjuntar {{ cat.shortLabel }}</span
                >
              </button>
            </div>
          </div>
        </div>

        <!-- 6. Administrativo Tab -->
        <div v-if="activeTab === 'admin'" class="max-w-3xl">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-[2.5rem] p-12 shadow-2xl relative overflow-hidden"
          >
            <!-- Decorative Elements -->
            <div
              class="absolute -top-16 -right-16 w-64 h-64 bg-brand-500/10 rounded-full blur-3xl animate-pulse"
            ></div>
            <div
              class="absolute -bottom-16 -left-16 w-48 h-48 bg-blue-500/5 rounded-full blur-3xl"
            ></div>

            <div class="relative">
              <div class="flex items-center gap-4 mb-10">
                <div class="w-12 h-12 rounded-2xl bg-brand-500 flex items-center justify-center text-white shadow-lg shadow-brand-500/30">
                  <ShieldIcon class="w-6 h-6" />
                </div>
                <div>
                  <h3 class="text-2xl font-black text-gray-900 dark:text-white leading-tight font-outfit">
                    Protocolización Oficial
                  </h3>
                  <p class="text-sm text-gray-500 dark:text-gray-400 font-medium opacity-80 mt-0.5 font-outfit">
                    Gestione el registro legal y el cierre administrativo de la marea.
                  </p>
                </div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                <div class="space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 ml-1"
                    >Nro. Protocolización</label
                  >
                  <input
                    v-model="marea.nro_protocolizacion"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="0000"
                  />
                </div>
                <div class="space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 ml-1"
                    >Año Protocolización</label
                  >
                  <input
                    v-model="marea.anio_protocolizacion"
                    type="number"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="2024"
                  />
                </div>
                <div class="sm:col-span-2 space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 ml-1"
                    >Fecha de Registro</label
                  >
                  <DatePicker
                    v-model="marea.fecha_protocolizacion"
                    :show-time="false"
                  />
                </div>
              </div>

              <div
                class="mt-12 p-6 bg-blue-50/50 dark:bg-blue-500/5 rounded-3xl border border-blue-100/50 dark:border-blue-500/10 flex gap-5 items-start"
              >
                <div class="w-10 h-10 rounded-xl bg-blue-100 dark:bg-blue-500/20 flex items-center justify-center text-blue-600 dark:text-blue-400 shrink-0">
                  <InfoCircleIcon class="w-6 h-6" />
                </div>
                <p class="text-xs text-blue-800 dark:text-blue-300 leading-relaxed font-medium">
                  <span class="font-black uppercase tracking-tighter block mb-1">Aviso Importante</span>
                  Al asignar un número de protocolización, la marea pasará automáticamente al estado
                  <strong class="text-blue-900 dark:text-blue-100">PROTOCOLIZADA</strong>. Esto bloqueará permanentemente la edición de los datos operativos y de captura para asegurar la integridad legal.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- 7. Historial Alertas Tab -->
        <div v-if="activeTab === 'historial_alertas'" class="max-w-4xl mx-auto">
            <div class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
                <h3 class="text-lg font-bold text-gray-800 dark:text-white mb-6 flex items-center gap-2">
                    <BellIcon class="w-5 h-5 text-brand-500" />
                    Registro de Incidentes y Alertas
                </h3>
                <AlertHistoryTab :referenceId="marea.id" />
            </div>
        </div>
      </div>
    </div>
    <!-- Finalize Dialog -->
    <GestionEtapasMareaDialog
        :show="showFinalizarDialog"
        :mode="'FINALIZAR'"
        :marea="marea"
        :currentStages="etapas"
        :initialPortId="marea.puertoBaseId"
        @close="showFinalizarDialog = false"
        @confirm="handleFinalizeMarea"
    />


  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue'
import AlertHistoryTab from '../../alerts/components/AlertHistoryTab.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import mareasService from '../services/mareas.service';
import NavigationStagesEditor from '../components/NavigationStagesEditor.vue'
import catalogosService from '../services/catalogos.service'
import { toast } from 'vue-sonner'
import {
  ArrowLeftIcon,
  ShipIcon,
  BeakerIcon,
  DocsIcon,
  CheckIcon,
  CalenderIcon,
  PlusIcon,
  SettingsIcon,
  UserCircleIcon,
  HistoryIcon,
  MapPinIcon,
  FileTextIcon,
  InfoIcon,
  RefreshIcon,
  InfoCircleIcon,
  DownloadIcon,
  CloudUploadIcon,
  LockIcon,
  ShieldIcon,
  BellIcon,
  TrashIcon,
  WarningIcon,
  ChevronRightIcon,
  FlagIcon,
  EditIcon
} from '@/icons'
const router = useRouter()
const activeTab = ref('general')

const route = useRoute()

const tabs = [
  { id: 'general', label: 'Datos Generales', icon: DocsIcon },
  { id: 'etapas', label: 'Etapas y Puertos', icon: MapPinIcon },
  { id: 'observadores', label: 'Observadores', icon: BeakerIcon },
  { id: 'workflow', label: 'Movimientos', icon: HistoryIcon },
  { id: 'docs', label: 'Documentación', icon: FileTextIcon },
  { id: 'admin', label: 'Administrativo', icon: SettingsIcon },
  { id: 'historial_alertas', label: 'Historial Alertas', icon: BellIcon },
]

// Data Refs
const marea = ref<any>({
    etapas: [],
    observadores: []
});
const etapas = ref<any[]>([]);
const observadores = ref<any[]>([]);
const movimientos = ref<any[]>([]);
const archivos = ref<any[]>([]);

const buqueOptions = ref<{ value: string; label: string }[]>([])
const pesqueriaOptions = ref<{ value: string; label: string }[]>([])
const arteOptions = ref<{ value: string; label: string }[]>([])
const puertos = ref<any[]>([])

const puertoOptions = computed(() => puertos.value.map(p => ({ value: p.id, label: p.nombre })))
const pesqueriaOptionsList = computed(() => pesqueriaOptions.value) // Alias for consistency if needed, but pesqueriaOptions is already used.

const docCategories = [
  { id: 'DATOS', label: 'Datos de a Bordo', shortLabel: 'Datos (DBF/ZIP)' },
  { id: 'INFORME_OBS', label: 'Informe del Observador', shortLabel: 'Informe OBS' },
  { id: 'PLANILLAS', label: 'Planillas Escaneadas', shortLabel: 'Planillas' },
  { id: 'INFORME_OFI', label: 'Informe de Oficina', shortLabel: 'Informe Oficina' },
  { id: 'PROTOCOLO', label: 'Informe Protocolizado', shortLabel: 'Protocolo' },
  { id: 'VARIOS', label: 'Otros Archivos', shortLabel: 'Archivo' },
]

const formatDate = (value?: string | Date | null) => {
  if (!value) return 'N/D'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'N/D'
  return date.toLocaleDateString('es-AR')
}

const formatDateTime = (value?: string | Date | null) => {
  if (!value) return 'N/D'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'N/D'
  return date.toLocaleString('es-AR')
}


const getFileName = (ruta?: string) => {
  if (!ruta) return 'Archivo'
  const parts = ruta.split(/[\\/]/)
  return parts[parts.length - 1] || 'Archivo'
}

const getFileExtension = (ruta?: string) => {
  if (!ruta) return 'N/D'
  const name = getFileName(ruta)
  const parts = name.split('.')
  return parts.length > 1 ? parts[parts.length - 1].toUpperCase() : 'N/D'
}

const resolveArchivoCategoria = (tipoArchivo?: string) => {
  if (!tipoArchivo) return 'VARIOS'
  if (tipoArchivo.startsWith('DATOS_')) return 'DATOS'
  if (tipoArchivo === 'INFORME_PROTOCOLIZADO') return 'PROTOCOLO'
  if (tipoArchivo === 'CARPETA_ESCANEADA' || tipoArchivo === 'DOCUMENTACION_ADICIONAL') return 'PLANILLAS'
  if (tipoArchivo.startsWith('INFORME_TECNICO')) return 'INFORME_OFI'
  return 'VARIOS'
}

async function loadMarea() {
    try {
        const id = route.params.id as string
        const [data, buques, pesquerias, artes] = await Promise.all([
            mareasService.getById(id),
            catalogosService.getBuques(),
            catalogosService.getPesquerias(),
            catalogosService.getArtesPesca()
        ])

        buqueOptions.value = buques.map(b => ({ value: b.id, label: b.nombreBuque }))
        pesqueriaOptions.value = pesquerias.map(p => ({ value: p.id, label: p.nombre }))
        arteOptions.value = artes.map(a => ({ value: a.id, label: a.nombre }))

        const etapaPrincipal = data.etapas?.find((e: any) => e.nroEtapa === 1) || data.etapas?.[0]

        marea.value = {
            id: data.id,
            anio_marea: data.anioMarea,
            nro_marea: data.nroMarea,
            id_buque: data.buqueId,
            id_pesqueria: etapaPrincipal?.pesqueriaId || '',
            puertoBaseId: data.buque?.puertoBaseId,
            id_arte_principal: data.artePrincipalId || '',
            fecha_zarpada_estimada: data.fechaZarpadaEstimada,
            observaciones: data.observaciones || '',
            activo: data.activo ?? true,
            tipo_marea: data.tipoMarea || 'MC',
            dias_estimados: data.diasEstimados ?? null,
            dias_zona_austral: data.diasZonaAustral ?? null,
            tipo_calculo_zona_austral: data.tipoCalculoZonaAustral || 'AUTOMATICO',
            estado_nombre: data.estadoActual?.nombre || '',
            estado_codigo: data.estadoActual?.codigo || '',
            estado_id: data.estadoActual?.codigo || '',
            fecha_creacion: data.fechaCreacion,
            fecha_ultima_actualizacion: data.fechaUltimaActualizacion,
            fecha_inicio_observador: data.fechaInicioObservador,
            fecha_fin_observador: data.fechaFinObservador,
            nro_protocolizacion: data.nroProtocolizacion ?? null,
            anio_protocolizacion: data.anioProtocolizacion ?? null,
            fecha_protocolizacion: data.fechaProtocolizacion,
            responsable_correccion: 'N/D'
        }

        const p = await catalogosService.getPuertos()
        puertos.value = p

        etapas.value = data.etapas?.map((e: any) => ({
             id: e.id,
             nroEtapa: e.nroEtapa,
             puertoZarpadaId: e.puertoZarpadaId,
             puertoArriboId: e.puertoArriboId,
             fechaZarpada: e.fechaZarpada,
             fechaArribo: e.fechaArribo,
             tipoEtapa: e.tipoEtapa,
             observaciones: e.observaciones || '',
             pesqueriaId: e.pesqueriaId,
             observadores: e.observadores?.map((rel: any) => ({
                observadorId: rel.observadorId || rel.observador?.id,
                rol: rel.rol,
                esDesignado: rel.esDesignado
             })) || []
        })) || []

        const observadoresMap = new Map<string, any>()
        data.etapas?.forEach((etapa: any) => {
            etapa.observadores?.forEach((rel: any) => {
                const observador = rel.observador
                if (!observador) return
                const key = `${observador.id}-${rel.rol}`
                if (observadoresMap.has(key)) return
                const nombre = observador.nombre || ''
                const apellido = observador.apellido || ''
                observadoresMap.set(key, {
                    id: observador.id,
                    nombre,
                    apellido,
                    iniciales: `${nombre[0] || ''}${apellido[0] || ''}`.toUpperCase(),
                    rol: rel.rol,
                    codigo: observador.codigoInterno,
                    inicio: formatDate(marea.value.fecha_inicio_observador),
                    fin: formatDate(marea.value.fecha_fin_observador),
                    es_designado: rel.esDesignado ?? true
                })
            })
        })
        observadores.value = Array.from(observadoresMap.values())

        movimientos.value = data.movimientos?.map((mov: any) => ({
            id: mov.id,
            evento: mov.tipoEvento,
            usuario: mov.usuario?.fullName || 'Sistema',
            fecha: formatDateTime(mov.fechaHora),
            detalle: mov.detalle,
            comentarios: mov.comentarios,
            estado_desde: mov.estadoDesde?.nombre || null,
            estado_hasta: mov.estadoHasta?.nombre || null,
            cantidad_muestras_otolitos: mov.cantidadMuestrasOtolitos || null
        })) || []

        archivos.value = data.archivos?.map((file: any) => ({
            id: file.id,
            categoria: resolveArchivoCategoria(file.tipoArchivo),
            nombre: file.descripcion || getFileName(file.rutaArchivo),
            formato: file.formato || getFileExtension(file.rutaArchivo),
            fecha: formatDate(file.fechaSubida),
            tipo_archivo: file.tipoArchivo,
            version: file.version
        })) || []

    } catch (e) {
        console.error('Error loading Marea', e)
    }
}

onMounted(() => {
    loadMarea();
});

const getFilesByCategory = (catId: string) => {
  return archivos.value.filter((f) => f.categoria === catId)
}

const showFinalizarDialog = ref(false);

function openFinalizeDialog() {
  showFinalizarDialog.value = true;
}

async function handleFinalizeMarea(payload: any) {
  try {
     await mareasService.executeAction(marea.value.id, 'REGISTRAR_ARRIBO', payload);
     showFinalizarDialog.value = false;
     // Refresh marea context
     await loadMarea();
  } catch (e) {
     console.error(e);
     // Handle error notification
  }
}


const getFormatColor = (formato: string) => {
  switch (formato) {
    case 'PDF':
      return 'bg-red-50 text-red-500 dark:bg-red-500/10'
    case 'DOCX':
      return 'bg-blue-50 text-blue-500 dark:bg-blue-500/10'
    case 'ZIP':
    case 'DBF':
      return 'bg-amber-50 text-amber-600 dark:bg-amber-500/10'
    default:
      return 'bg-gray-50 text-gray-500 dark:bg-gray-500/10'
  }
}

const goBack = () => router.back()
const toNumberOrUndefined = (value: any) => {
  if (value === null || value === undefined || value === '') return undefined
  const parsed = Number(value)
  return Number.isNaN(parsed) ? undefined : parsed
}

const toIsoStringOrUndefined = (value: any) => {
  if (!value) return undefined
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return undefined
  return date.toISOString()
}

const saveChanges = async () => {
  try {
    const etapasPayload = etapas.value.map((etapa, index) => ({
        id: etapa.id,
        nroEtapa: etapa.nroEtapa,
        pesqueriaId: (index === 0 && marea.value.id_pesqueria) ? marea.value.id_pesqueria : (etapa.pesqueriaId || undefined),
        puertoZarpadaId: etapa.puertoZarpadaId || undefined,
        puertoArriboId: etapa.puertoArriboId || undefined,
        fechaZarpada: toIsoStringOrUndefined(etapa.fechaZarpada),
        fechaArribo: toIsoStringOrUndefined(etapa.fechaArribo),
        tipoEtapa: etapa.tipoEtapa || 'COMERCIAL',
        observaciones: etapa.observaciones || undefined,
        observadores: etapa.observadores?.map((obs: any) => ({
          observadorId: obs.observadorId,
          rol: obs.rol,
          esDesignado: obs.esDesignado
        })) || []
      }))

    const payload = {
      anioMarea: toNumberOrUndefined(marea.value.anio_marea),
      nroMarea: toNumberOrUndefined(marea.value.nro_marea),
      buqueId: marea.value.id_buque || undefined,
      artePrincipalId: marea.value.id_arte_principal || undefined,
      fechaZarpadaEstimada: toIsoStringOrUndefined(marea.value.fecha_zarpada_estimada),
      fechaInicioObservador: toIsoStringOrUndefined(marea.value.fecha_inicio_observador),
      fechaFinObservador: toIsoStringOrUndefined(marea.value.fecha_fin_observador),
      diasZonaAustral: toNumberOrUndefined(marea.value.dias_zona_austral),
      tipoCalculoZonaAustral: marea.value.tipo_calculo_zona_austral || undefined,
      nroProtocolizacion: toNumberOrUndefined(marea.value.nro_protocolizacion),
      anioProtocolizacion: toNumberOrUndefined(marea.value.anio_protocolizacion),
      fechaProtocolizacion: toIsoStringOrUndefined(marea.value.fecha_protocolizacion),
      observaciones: marea.value.observaciones || undefined,
      tipoMarea: marea.value.tipo_marea || undefined,
      diasEstimados: toNumberOrUndefined(marea.value.dias_estimados),
      activo: marea.value.activo,
      etapas: etapasPayload
    }

    await mareasService.update(marea.value.id, payload)
    toast.success('Los cambios se guardaron correctamente.')
    await loadMarea()
  } catch (error) {
    console.error(error)
    toast.error('No se pudieron guardar los cambios de la marea.')
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: var(--color-gray-200);
  border-radius: 9999px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: var(--color-gray-700);
}
</style>
