<template>
  <AdminLayout 
    :title="`Marea ${marea.nro_marea}/${marea.anio_marea}`"
    :description="marea.titulo || 'Detalles técnicos y operativos de la marea.'"
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
        v-if="marea.estado_id === 'CORRECCION'"
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
                <div class="md:col-span-2 space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Título de la Marea</label
                  >
                  <input
                    v-model="marea.titulo"
                    type="text"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                    placeholder="Ej. Campaña Global de Calamar 2024"
                  />
                </div>
                <div class="md:col-span-2 space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400"
                    >Descripción / Objetivo</label
                  >
                  <textarea
                    v-model="marea.descripcion"
                    rows="3"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium appearance-none outline-none"
                  ></textarea>
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
                  <input
                    v-model="marea.fecha_zarpada_estimada"
                    type="datetime-local"
                    class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                  />
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
                  <span class="font-medium dark:text-gray-300">10/12/2023</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-gray-500">Últ. Actualización</span>
                  <span class="font-medium dark:text-gray-300">22/12/2023</span>
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
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl overflow-hidden shadow-sm"
          >
            <div
              class="px-6 py-4 md:px-8 md:py-6 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between bg-gray-50/50 dark:bg-gray-800/30"
            >
              <h3 class="text-base md:text-lg font-bold text-gray-800 dark:text-white">
                Etapas de Navegación
              </h3>
              <button
                class="px-3 py-1.5 text-xs font-bold text-brand-500 bg-brand-50 dark:bg-brand-500/10 rounded-lg border border-brand-100 dark:border-brand-500/20 hover:bg-brand-100 transition-colors"
              >
                + <span class="hidden sm:inline">Añadir Etapa</span
                ><span class="sm:hidden">Etapa</span>
              </button>
            </div>

            <!-- Mobile Stages View (Cards) -->
            <div class="block md:hidden divide-y divide-gray-50 dark:divide-gray-800">
              <div v-for="etapa in etapas" :key="etapa.id" class="p-6 space-y-4">
                <div class="flex justify-between items-start">
                  <div>
                    <span class="text-xs font-black text-brand-500 uppercase tracking-widest"
                      >Etapa #{{ etapa.nro_etapa }}</span
                    >
                    <h4 class="text-sm font-bold text-gray-800 dark:text-gray-200">
                      {{ etapa.puerto_zarpada }} → {{ etapa.puerto_arribo }}
                    </h4>
                  </div>
                  <span
                    class="px-2 py-0.5 rounded text-[9px] font-black"
                    :class="
                      etapa.tipo === 'COMERCIAL'
                        ? 'bg-blue-100 text-blue-600'
                        : 'bg-green-100 text-green-600'
                    "
                  >
                    {{ etapa.tipo }}
                  </span>
                </div>
                <div class="grid grid-cols-2 gap-4 text-[11px]">
                  <div>
                    <p class="text-gray-400 font-bold uppercase tracking-tighter">Zarpada</p>
                    <p class="text-gray-600 dark:text-gray-400">{{ etapa.fecha_zarpada }}</p>
                  </div>
                  <div>
                    <p class="text-gray-400 font-bold uppercase tracking-tighter">Arribo</p>
                    <p class="text-gray-600 dark:text-gray-400">{{ etapa.fecha_arribo }}</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Desktop Stages View (Table) -->
            <div class="hidden md:block overflow-x-auto">
              <table class="w-full text-left">
                <thead>
                  <tr
                    class="text-[10px] font-bold uppercase tracking-wider text-gray-400 border-b border-gray-50 dark:border-gray-800"
                  >
                    <th class="px-8 py-4">Nro</th>
                    <th class="px-4 py-4">Puerto Zarpada</th>
                    <th class="px-4 py-4">Puerto Arribo</th>
                    <th class="px-4 py-4">Zarpada Real</th>
                    <th class="px-4 py-4">Arribo Real</th>
                    <th class="px-4 py-4">Tipo</th>
                    <th class="px-8 py-4 text-right">Acciones</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-50 dark:divide-gray-800">
                  <tr
                    v-for="etapa in etapas"
                    :key="etapa.id"
                    class="text-sm hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-colors"
                  >
                    <td class="px-8 py-5 font-bold text-brand-500">#{{ etapa.nro_etapa }}</td>
                    <td class="px-4 py-5 font-medium text-gray-700 dark:text-gray-300">
                      {{ etapa.puerto_zarpada }}
                    </td>
                    <td class="px-4 py-5 font-medium text-gray-700 dark:text-gray-300">
                      {{ etapa.puerto_arribo }}
                    </td>
                    <td class="px-4 py-5 text-gray-500">{{ etapa.fecha_zarpada }}</td>
                    <td class="px-4 py-5 text-gray-500">{{ etapa.fecha_arribo }}</td>
                    <td class="px-4 py-5">
                      <span
                        class="px-2 py-1 rounded text-[10px] font-bold"
                        :class="
                          etapa.tipo === 'COMERCIAL'
                            ? 'bg-blue-100 text-blue-600'
                            : 'bg-green-100 text-green-600'
                        "
                      >
                        {{ etapa.tipo }}
                      </span>
                    </td>
                    <td class="px-8 py-5 text-right">
                      <button class="text-gray-400 hover:text-brand-500 transition-colors p-1">
                        <SettingsIcon class="w-4 h-4" />
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
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
                  class="bg-gray-50 dark:bg-gray-800/40 border border-gray-100 dark:border-gray-800 p-4 rounded-xl"
                >
                  <p class="text-sm text-gray-700 dark:text-gray-300">{{ mov.detalle }}</p>
                  <div v-if="mov.estado_hasta" class="mt-3">
                    <span
                      class="text-[10px] px-2 py-0.5 bg-white dark:bg-gray-900 rounded border border-gray-200 dark:border-gray-700 text-gray-500"
                      >Estado: {{ mov.estado_hasta }}</span
                    >
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 5. Documentación Tab -->
        <div v-if="activeTab === 'docs'" class="space-y-12">
          <div v-for="cat in docCategories" :key="cat.id" class="space-y-4">
            <div class="flex items-center justify-between">
              <h3
                class="text-sm font-black uppercase tracking-[0.2em] text-gray-400 dark:text-gray-500 flex items-center gap-3"
              >
                <span class="w-8 h-[1px] bg-gray-200 dark:bg-gray-800"></span>
                {{ cat.label }}
              </h3>
              <span class="text-[10px] font-bold text-gray-400"
                >{{ getFilesByCategory(cat.id).length }} archivos</span
              >
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Extraction Blocked Warning for DATOS Category -->
              <div
                v-if="cat.id === 'DATOS' && marea.estado_id === 'CORRECCION'"
                class="md:col-span-2 lg:col-span-3 bg-amber-50 dark:bg-amber-500/5 border border-dashed border-amber-200 dark:border-amber-500/20 rounded-2xl p-4 flex items-center gap-4"
              >
                <div
                  class="w-10 h-10 rounded-full bg-amber-100 dark:bg-amber-500/10 flex items-center justify-center text-amber-600 dark:text-amber-400 shrink-0"
                >
                  <LockIcon class="w-5 h-5" />
                </div>
                <div>
                  <h4
                    class="text-xs font-bold text-amber-800 dark:text-amber-400 uppercase tracking-wider"
                  >
                    Extracción de datos bloqueada temporalmente
                  </h4>
                  <p class="text-[11px] text-amber-700 dark:text-amber-500 mt-0.5">
                    La descarga de archivos de datos está restringida mientras se procesan las
                    correcciones enviadas.
                  </p>
                </div>
              </div>

              <!-- File Cards -->
              <div
                v-for="file in getFilesByCategory(cat.id)"
                :key="file.id"
                class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-5 shadow-sm hover:shadow-md transition-all group flex items-center gap-4 relative overflow-hidden"
              >
                <!-- Format Icon -->
                <div
                  class="w-12 h-12 rounded-xl flex items-center justify-center shrink-0"
                  :class="getFormatColor(file.formato)"
                >
                  <FileTextIcon v-if="['PDF', 'DOCX'].includes(file.formato)" class="w-6 h-6" />
                  <RefreshIcon v-else class="w-6 h-6 rotate-45" />
                  <!-- Generic for data -->
                </div>

                <div class="flex-1 min-w-0">
                  <h4 class="text-sm font-bold text-gray-800 dark:text-gray-200 truncate">
                    {{ file.nombre }}
                  </h4>
                  <div class="flex items-center gap-2 mt-1">
                    <span class="text-[10px] font-black text-gray-400">{{ file.formato }}</span>
                    <span class="w-1 h-1 rounded-full bg-gray-300"></span>
                    <span class="text-[10px] text-gray-400">{{ file.fecha }}</span>
                  </div>
                </div>

                <div class="flex items-center gap-1">
                  <button
                    class="p-2 text-gray-400 hover:text-brand-500 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-lg transition-colors"
                    title="Descargar"
                  >
                    <DownloadIcon class="w-4 h-4" />
                  </button>
                </div>
              </div>

              <!-- Upload Placeholder for Category -->
              <button
                class="border-2 border-dashed border-gray-100 dark:border-gray-800/50 rounded-2xl p-5 flex items-center justify-center gap-3 text-gray-400 hover:border-brand-200 hover:text-brand-500 transition-all group"
              >
                <CloudUploadIcon class="w-5 h-5 group-hover:scale-110 transition-transform" />
                <span class="text-xs font-bold uppercase tracking-wider"
                  >Adjuntar {{ cat.shortLabel }}</span
                >
              </button>
            </div>
          </div>
        </div>

        <!-- 6. Administrativo Tab -->
        <div v-if="activeTab === 'admin'" class="max-w-2xl">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-10 shadow-sm relative overflow-hidden"
          >
            <div
              class="absolute -top-10 -right-10 w-40 h-40 bg-brand-500/5 rounded-full blur-3xl"
            ></div>
            <h3 class="text-xl font-black text-gray-900 dark:text-white mb-8">
              Protocolización Oficial
            </h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
              <div class="space-y-1.5">
                <label class="text-xs font-bold uppercase tracking-wider text-gray-400"
                  >Nro. Protocolización</label
                >
                <input
                  v-model="marea.nro_protocolización"
                  type="number"
                  class="form-input-premium text-lg font-black"
                  placeholder="0000"
                />
              </div>
              <div class="space-y-1.5">
                <label class="text-xs font-bold uppercase tracking-wider text-gray-400"
                  >Año Protocolización</label
                >
                <input
                  v-model="marea.anio_protocolización"
                  type="number"
                  class="form-input-premium text-lg font-black"
                  placeholder="2024"
                />
              </div>
              <div class="sm:col-span-2 space-y-1.5">
                <label class="text-xs font-bold uppercase tracking-wider text-gray-400"
                  >Fecha de Protocolización</label
                >
                <input
                  v-model="marea.fecha_protocolización"
                  type="date"
                  class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-800 border-none rounded-2xl focus:ring-2 focus:ring-brand-500/20 text-gray-800 dark:text-gray-200 transition-all font-medium outline-none"
                />
              </div>
            </div>
            <div
              class="mt-10 p-4 bg-blue-50 dark:bg-blue-500/10 rounded-2xl border border-blue-100 dark:border-blue-500/20 flex gap-4"
            >
              <InfoCircleIcon class="w-5 h-5 text-blue-500 shrink-0" />
              <p class="text-xs text-blue-700 dark:text-blue-300 leading-relaxed">
                Al asignar un número de protocolización, la marea pasará automáticamente al estado
                <strong>PROTOCOLIZADA</strong> y los datos de captura quedarán bloqueados para
                edición.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
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
} from '@/icons'

const route = useRoute()
const router = useRouter()
const activeTab = ref('general')

const tabs = [
  { id: 'general', label: 'Datos Generales', icon: DocsIcon },
  { id: 'etapas', label: 'Etapas y Puertos', icon: MapPinIcon },
  { id: 'observadores', label: 'Observadores', icon: BeakerIcon },
  { id: 'workflow', label: 'Movimientos', icon: HistoryIcon },
  { id: 'docs', label: 'Documentación', icon: FileTextIcon },
  { id: 'admin', label: 'Administrativo', icon: SettingsIcon },
]

const docCategories = [
  { id: 'DATOS', label: 'Datos de a Bordo', shortLabel: 'Datos (DBF/ZIP)' },
  { id: 'INFORME_OBS', label: 'Informe del Observador', shortLabel: 'Informe OBS' },
  { id: 'PLANILLAS', label: 'Planillas Escaneadas', shortLabel: 'Planillas' },
  { id: 'INFORME_OFI', label: 'Informe de Oficina', shortLabel: 'Informe Oficina' },
  { id: 'PROTOCOLO', label: 'Informe Protocolizado', shortLabel: 'Protocolo' },
  { id: 'VARIOS', label: 'Otros Archivos', shortLabel: 'Archivo' },
]

const buqueOptions = [
  { value: '1', label: 'BP ARGENTINO I' },
  { value: '2', label: 'BP UNION' },
]

const pesqueriaOptions = [
  { value: '1', label: 'MERLUZA (Merluccius hubbsi)' },
  { value: '2', label: 'LANGOSTINO' },
]

const arteOptions = [
  { value: '1', label: 'Arrastre de fondo' },
  { value: '2', label: 'Tangones' },
]

// Mock data structured as per DB schema
const marea = ref({
  id: route.params.id,
  anio_marea: 2023,
  nro_marea: 45,
  id_buque: '1',
  id_pesqueria: '1',
  id_arte_principal: '1',
  id_estado_actual: 'CORRECCION',
  estado_id: 'CORRECCION',
  estado_nombre: 'En Corrección', // Join with estados_marea
  responsable_correccion: 'Lic. María González (Control de Calidad)',
  fecha_zarpada_estimada: '2023-12-25T10:00',
  titulo: 'Prospección de Merluza Hubbsi - Sector Norte',
  descripcion: 'Evaluación de rendimientos y estructuras de talla en precuarentena.',
  nro_protocolización: null,
  anio_protocolización: 2024,
  fecha_protocolización: null,
  activo: true,
  observaciones:
    'Requiere reporte diario de captura incidental. Buque tiene problemas menores en guinche de babor.',
})

const etapas = ref([
  {
    id: 1,
    nro_etapa: 1,
    puerto_zarpada: 'Mar del Plata',
    puerto_arribo: 'Puerto Madryn',
    fecha_zarpada: '15/12/2023 08:30',
    fecha_arribo: '20/12/2023 22:00',
    tipo: 'COMERCIAL',
  },
  {
    id: 2,
    nro_etapa: 2,
    puerto_zarpada: 'Puerto Madryn',
    puerto_arribo: 'Mar del Plata',
    fecha_zarpada: '22/12/2023 06:15',
    fecha_arribo: '--/--/----',
    tipo: 'INSTITUCIONAL',
  },
])

const observadores = ref([
  {
    id: 1,
    nombre: 'Juan',
    apellido: 'Díaz',
    iniciales: 'JD',
    rol: 'PRINCIPAL',
    codigo: '4521',
    inicio: '15/12/2023',
    fin: null,
  },
  {
    id: 2,
    nombre: 'Ana',
    apellido: 'Martínez',
    iniciales: 'AM',
    rol: 'ACOMPAÑANTE',
    codigo: '8832',
    inicio: '15/12/2023',
    fin: '20/12/2023',
  },
])

const movimientos = ref([
  {
    id: 1,
    fecha: '12/12/2023 14:20',
    evento: 'CAMBIO_ESTADO',
    detalle: 'La marea ha sido creada y designada al BP ARGENTINO I.',
    estado_hasta: 'Designada',
    usuario: 'Daniel (Admin)',
  },
  {
    id: 2,
    fecha: '15/12/2023 09:00',
    evento: 'ZARPADA_REAL',
    detalle: 'Zarpada confirmada desde Mar del Plata por el observador.',
    estado_hasta: 'Navegando',
    usuario: 'Juan Díaz',
  },
  {
    id: 3,
    fecha: '20/12/2023 18:45',
    evento: 'ALERTA_OPERATIVA',
    detalle: 'Se reporta falla en sensor de temperatura de red.',
    estado_hasta: null,
    usuario: 'Juan Díaz',
  },
])

const archivos = ref([
  { id: 1, nombre: 'Muestra_Cal_2023.zip', categoria: 'DATOS', formato: 'ZIP', fecha: '20/12/23' },
  {
    id: 2,
    nombre: 'Informe_Final_OBS.docx',
    categoria: 'INFORME_OBS',
    formato: 'DOCX',
    fecha: '22/12/23',
  },
  {
    id: 3,
    nombre: 'Planillas_Escaneadas_M45.pdf',
    categoria: 'PLANILLAS',
    formato: 'PDF',
    fecha: '23/12/23',
  },
  {
    id: 4,
    nombre: 'Analisis_Cientifico_Ofi.docx',
    categoria: 'INFORME_OFI',
    formato: 'DOCX',
    fecha: '24/12/23',
  },
])

const getFilesByCategory = (catId: string) => {
  return archivos.value.filter((f) => f.categoria === catId)
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

const goBack = () => router.push({ name: 'MareasWorkflow' })
const saveChanges = () => {
  alert('Se han guardado los cambios correctamente (Mockup)')
  goBack()
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
