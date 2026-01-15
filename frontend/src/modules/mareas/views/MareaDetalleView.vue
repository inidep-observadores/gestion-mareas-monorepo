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
            class="group flex items-center gap-2 text-sm font-semibold text-primary hover:opacity-80 transition-all bg-primary/10 px-3 py-1.5 rounded-lg"
          >
            <ArrowLeftIcon class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
            Volver
          </button>

          <div
            class="flex items-center gap-2 px-3 py-1.5 bg-primary/10 text-primary text-xs font-bold uppercase tracking-wider rounded-full border border-primary/20"
          >
            <div class="w-1.5 h-1.5 rounded-full bg-primary animate-pulse"></div>
            {{ marea.estado_nombre }}
          </div>

          <div
            v-if="marea.estado_codigo === 'EN_EJECUCION' && (!etapas[etapas.length - 1] || etapas[etapas.length - 1].fechaArribo)"
            class="flex items-center gap-2 px-3 py-1.5 bg-info/10 text-info text-xs font-bold uppercase tracking-wider rounded-full border border-info/20"
          >
            En Tierra
          </div>
        </div>

        <div class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
          <button
            class="px-5 py-2.5 text-sm font-semibold text-text-muted bg-surface border border-border rounded-xl hover:bg-surface-muted transition-all shadow-sm active:scale-95 text-center"
            @click="goBack"
          >
            Descartar
          </button>
          <button
            class="px-5 py-2.5 text-sm font-semibold text-primary-fg bg-primary border border-transparent rounded-xl hover:opacity-90 transition-all shadow-md shadow-primary/20 active:scale-95 flex items-center justify-center gap-2"
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
        class="mb-8 p-4 bg-error/5 border border-error/20 rounded-2xl flex flex-col sm:flex-row items-center gap-4 animate-in fade-in slide-in-from-top-4 duration-500"
      >
        <div
          class="w-12 h-12 rounded-xl bg-error flex items-center justify-center text-error-fg shrink-0 shadow-lg shadow-error/20"
        >
          <LockIcon class="w-6 h-6" />
        </div>
        <div class="flex-1 text-center sm:text-left">
          <h3
            class="text-sm font-black text-error uppercase tracking-wider"
          >
            Marea Bloqueada para Extracción
          </h3>
          <p class="text-xs text-error/80 mt-0.5 font-medium">
            En proceso de corrección por:
            <span class="font-bold underline">{{ marea.responsable_correccion }}</span
            >. Los datos finales no estarán disponibles hasta la nueva carga.
          </p>
        </div>
        <div
          class="px-4 py-2 bg-surface rounded-lg border border-border text-[10px] font-bold text-error uppercase tracking-widest whitespace-nowrap"
        >
          Estado: En Revisión
        </div>
      </div>

      <!-- Main Navigation Tabs -->
      <div
        class="mb-8 border-b border-border overflow-x-auto custom-scrollbar"
      >
        <div class="flex gap-8 min-w-max">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            class="pb-4 text-sm font-bold transition-all relative"
            :class="
              activeTab === tab.id
                ? 'text-primary'
                : 'text-text-muted hover:text-text'
            "
          >
            <div class="flex items-center gap-2">
              <component :is="tab.icon" class="w-4 h-4" />
              {{ tab.label }}
            </div>
            <div
              v-if="activeTab === tab.id"
              class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-full"
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
              class="bg-surface border border-border rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-text mb-6 flex items-center gap-2"
              >
                <DocsIcon class="w-5 h-5 text-primary" />
                Identificación de la Marea
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Año Marea</label
                  >
                  <input
                    v-model="marea.anio_marea"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="2023"
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Nro. Marea</label
                  >
                  <input
                    v-model="marea.nro_marea"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="000"
                  />
                </div>
              </div>
            </div>

            <!-- Ship & Fishery Card -->
            <div
              class="bg-surface border border-border rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-text mb-6 flex items-center gap-2"
              >
                <ShipIcon class="w-5 h-5 text-info" />
                Buque y Pesquería
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
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
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
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
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
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
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Fecha Zarpada Est.</label
                  >
                  <DatePicker
                    v-model="marea.fecha_zarpada_estimada"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Tipo de Marea</label
                  >
                  <select
                    v-model="marea.tipo_marea"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                  >
                    <option value="MC">Comercial (MC)</option>
                    <option value="CI">Institucional (CI)</option>
                  </select>
                </div>
                <div class="space-y-1.5">
                  <label
                    class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Días Estimados</label
                  >
                  <input
                    v-model="marea.dias_estimados"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="0"
                  />
                </div>
              </div>
            </div>



            <!-- Observer Dates & Zona Austral -->
            <div
              class="bg-surface border border-border rounded-2xl p-8 shadow-sm"
            >
              <h3
                class="text-lg font-bold text-text mb-6 flex items-center gap-2"
              >
                <CalenderIcon class="w-5 h-5 text-primary" />
                Fechas del Observador y Zona Austral
              </h3>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Inicio Observador</label
                  >
                  <DatePicker
                    v-model="marea.fecha_inicio_observador"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Fin Observador</label
                  >
                  <DatePicker
                    v-model="marea.fecha_fin_observador"
                    :show-time="false"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Días Zona Austral</label
                  >
                  <input
                    v-model="marea.dias_zona_austral"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="0"
                  />
                </div>
                <div class="space-y-1.5">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted"
                    >Cálculo Zona Austral</label
                  >
                  <select
                    v-model="marea.tipo_calculo_zona_austral"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
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
              class="bg-surface-muted border border-border rounded-2xl p-6"
            >
              <h4 class="text-xs font-bold uppercase tracking-wider text-text-muted/60 mb-4">
                Metadatos de Seguimiento
              </h4>
              <div class="space-y-3">
                <div class="flex justify-between text-sm">
                  <span class="text-text-muted">Fecha Creación</span>
                  <span class="font-medium text-text">{{ formatDate(marea.fecha_creacion) }}</span>
                </div>
                <div class="flex justify-between text-sm">
                  <span class="text-text-muted">Últ. Actualización</span>
                  <span class="font-medium text-text">{{ formatDate(marea.fecha_ultima_actualizacion) }}</span>
                </div>
                <div class="pt-4 border-t border-border">
                  <div class="flex items-center gap-2">
                    <input
                      type="checkbox"
                      v-model="marea.activo"
                      class="rounded border-border text-primary focus:ring-primary/20"
                    />
                    <span class="text-sm font-medium text-text"
                      >Marea Activa</span
                    >
                  </div>
                </div>
              </div>
            </div>

            <!-- Notes Quick Access -->
            <div
              class="bg-warning/10 border border-warning/20 rounded-2xl p-6"
            >
              <h4
                class="text-xs font-bold uppercase tracking-wider text-warning mb-3 flex items-center gap-2"
              >
                <InfoIcon class="w-4 h-4" />
                Observaciones Importantes
              </h4>
              <textarea
                v-model="marea.observaciones"
                rows="4"
                class="w-full bg-transparent border-none text-sm text-warning focus:ring-0 placeholder:text-warning/40 resize-none font-medium"
                placeholder="Añada notas que otros usuarios verán inmediatamente..."
              ></textarea>
            </div>
          </div>
        </div>

        <!-- 2. Etapas Tab -->
        <div v-if="activeTab === 'etapas'" class="space-y-6">
          <div class="flex items-center justify-between mb-2">
            <div>
                <h3 class="text-lg font-bold text-text">Etapas de Navegación</h3>
                <p class="text-xs text-text-muted mt-1">Gestione los tramos del viaje, puertos y fechas reales.</p>
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
            class="bg-surface border border-border rounded-2xl p-6 shadow-sm flex items-start gap-4"
          >
            <div
              class="w-16 h-16 rounded-full bg-gradient-to-br from-primary/10 to-info/10 flex items-center justify-center text-primary font-extrabold text-xl border-2 border-primary/5"
            >
              {{ obs.iniciales }}
            </div>
            <div class="flex-1">
              <div class="flex justify-between items-start mb-1">
                <h4 class="font-bold text-text">
                  {{ obs.nombre }} {{ obs.apellido }}
                </h4>
                <div
                  class="text-[10px] font-black tracking-tighter px-1.5 py-0.5 bg-surface-muted rounded text-text-muted"
                >
                  ID {{ obs.codigo }}
                </div>
              </div>
              <p class="text-xs text-primary font-bold mb-3">{{ obs.rol }}</p>
              <div class="space-y-1 text-[11px] text-text-muted">
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
            class="border-2 border-dashed border-border rounded-2xl p-6 flex flex-col items-center justify-center text-text-muted/40 hover:text-primary hover:border-primary/40 transition-all gap-2 group"
          >
            <div
              class="p-2 rounded-full group-hover:bg-primary/10 transition-colors"
            >
              <PlusIcon class="w-6 h-6" />
            </div>
            <span class="text-sm font-bold">Asignar Observador</span>
          </button>
        </div>

        <!-- 4. Flujo Tab -->
        <div v-if="activeTab === 'workflow'" class="max-w-3xl mx-auto w-full">
          <div
            class="relative pl-8 space-y-10 border-l-2 border-border ml-4"
          >
            <div v-for="mov in movimientos" :key="mov.id" class="relative">
              <div
                class="absolute -left-[41px] top-0 w-5 h-5 rounded-full bg-surface border-4"
                :class="mov.evento === 'CAMBIO_ESTADO' ? 'border-primary' : 'border-border'"
              ></div>
              <div class="space-y-2">
                <div class="flex items-center justify-between">
                  <div class="flex items-center gap-2">
                    <span class="text-xs font-bold text-primary uppercase">{{ mov.evento }}</span>
                    <span class="text-xs text-text-muted/40">•</span>
                    <span
                      class="text-xs font-semibold text-text-muted flex items-center gap-1"
                    >
                      <UserCircleIcon class="w-3.5 h-3.5" />
                      {{ mov.usuario }}
                    </span>
                  </div>
                  <span class="text-[11px] text-text-muted/60">{{ mov.fecha }}</span>
                </div>
                <div
                  v-if="mov.detalle || mov.comentarios || mov.estado_desde || mov.estado_hasta || mov.cantidad_muestras_otolitos"
                  class="bg-surface-muted border border-border p-4 rounded-xl"
                >
                  <p v-if="mov.detalle" class="text-sm text-text font-medium mb-3">{{ mov.detalle }}</p>
                  
                  <!-- User Comments -->
                  <div v-if="mov.comentarios" class="mb-4 p-3 bg-primary/5 border-l-2 border-l-primary rounded-r-lg">
                    <p class="text-xs text-primary font-bold uppercase tracking-wider mb-1 flex items-center gap-1">
                      <ChatIcon class="w-3 h-3" />
                      Comentario del usuario
                    </p>
                    <p class="text-sm text-text-muted whitespace-pre-wrap italic">"{{ mov.comentarios }}"</p>
                  </div>

                  <div v-if="mov.estado_desde || mov.estado_hasta || mov.cantidad_muestras_otolitos" class="flex flex-wrap gap-2 pt-2 border-t border-border">
                    <span
                      v-if="mov.estado_desde"
                      class="text-[10px] px-2 py-0.5 bg-surface rounded border border-border text-text-muted"
                      >Estado desde: {{ mov.estado_desde }}</span
                    >
                    <span
                      v-if="mov.estado_hasta"
                      class="text-[10px] px-2 py-0.5 bg-surface rounded border border-border text-text-muted"
                      >Estado hasta: {{ mov.estado_hasta }}</span
                    >
                    <span
                      v-if="mov.cantidad_muestras_otolitos"
                      class="text-[10px] px-2 py-0.5 bg-surface rounded border border-border text-text-muted"
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
                class="text-xs font-black uppercase tracking-[0.25em] text-text-muted/60 flex items-center gap-4"
              >
                <div class="w-10 h-[2px] bg-gradient-to-r from-primary to-transparent rounded-full"></div>
                {{ cat.label }}
              </h3>
              <span class="text-[10px] font-bold bg-surface-muted text-text-muted px-2 py-0.5 rounded-full"
                >{{ getFilesByCategory(cat.id).length }} archivos</span
              >
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
              <!-- Extraction Blocked Warning for DATOS Category -->
              <div
                v-if="cat.id === 'DATOS' && marea.estado_codigo === 'EN_CORRECCION'"
                class="md:col-span-2 lg:col-span-3 bg-warning/5 border border-dashed border-warning/20 rounded-3xl p-6 flex items-center gap-5"
              >
                <div
                  class="w-12 h-12 rounded-2xl bg-warning/10 flex items-center justify-center text-warning shrink-0 shadow-sm"
                >
                  <LockIcon class="w-6 h-6" />
                </div>
                <div>
                  <h4
                    class="text-sm font-black text-warning uppercase tracking-wider"
                  >
                    Extracción de datos bloqueada temporalmente
                  </h4>
                  <p class="text-xs text-warning/80 mt-1 font-medium italic">
                    La descarga de archivos de datos está restringida mientras se procesan las
                    correcciones enviadas. Los archivos volverán a estar disponibles tras la validación final.
                  </p>
                </div>
              </div>

              <!-- File Cards -->
              <div
                v-for="file in getFilesByCategory(cat.id)"
                :key="file.id"
                class="bg-surface border border-border rounded-3xl p-6 shadow-sm hover:shadow-xl hover:scale-[1.02] hover:border-primary/30 transition-all duration-300 group flex items-center gap-5 relative overflow-hidden"
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
                  <h4 class="text-sm font-bold text-text truncate group-hover:text-primary transition-colors">
                    {{ file.nombre }}
                  </h4>
                  <div class="flex items-center flex-wrap gap-2 mt-1.5 text-text-muted/60">
                    <span class="text-[10px] font-black uppercase tracking-tight">{{ file.formato }}</span>
                    <span class="w-1 h-1 rounded-full bg-border"></span>
                    <span class="text-[10px] font-medium">{{ file.fecha }}</span>
                    <template v-if="file.tipo_archivo">
                      <span class="w-1 h-1 rounded-full bg-border"></span>
                      <span class="text-[10px] font-medium">{{ file.tipo_archivo }}</span>
                    </template>
                    <template v-if="file.version">
                      <span class="w-1 h-1 rounded-full bg-border"></span>
                      <span class="text-[10px] font-bold text-primary">v{{ file.version }}</span>
                    </template>
                  </div>
                </div>

                <div class="flex items-center gap-1">
                  <button
                    class="p-2.5 text-text-muted hover:text-primary hover:bg-primary/10 rounded-xl transition-all active:scale-95"
                    title="Descargar Archivo"
                  >
                    <DownloadIcon class="w-5 h-5" />
                  </button>
                </div>
              </div>

              <!-- Upload Placeholder for Category -->
              <button
                class="border-2 border-dashed border-border rounded-3xl p-6 flex items-center justify-center gap-4 text-text-muted/40 hover:border-primary/40 hover:text-primary hover:bg-primary/5 transition-all duration-300 group shadow-sm active:scale-95"
              >
                <div class="w-10 h-10 rounded-full bg-surface-muted flex items-center justify-center group-hover:bg-primary/10 transition-colors">
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
            class="bg-surface border border-border rounded-[2.5rem] p-12 shadow-2xl relative overflow-hidden"
          >
            <!-- Decorative Elements -->
            <div
              class="absolute -top-16 -right-16 w-64 h-64 bg-primary/10 rounded-full blur-3xl animate-pulse"
            ></div>
            <div
              class="absolute -bottom-16 -left-16 w-48 h-48 bg-info/5 rounded-full blur-3xl"
            ></div>

            <div class="relative">
              <div class="flex items-center gap-4 mb-10">
                <div class="w-12 h-12 rounded-2xl bg-primary flex items-center justify-center text-primary-fg shadow-lg shadow-primary/30">
                  <ShieldIcon class="w-6 h-6" />
                </div>
                <div>
                  <h3 class="text-2xl font-black text-text leading-tight font-outfit">
                    Protocolización Oficial
                  </h3>
                  <p class="text-sm text-text-muted font-medium opacity-80 mt-0.5 font-outfit">
                    Gestione el registro legal y el cierre administrativo de la marea.
                  </p>
                </div>
              </div>

              <div class="grid grid-cols-1 sm:grid-cols-2 gap-8">
                <div class="space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted ml-1"
                    >Nro. Protocolización</label
                  >
                  <input
                    v-model="marea.nro_protocolizacion"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="0000"
                  />
                </div>
                <div class="space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted ml-1"
                    >Año Protocolización</label
                  >
                  <input
                    v-model="marea.anio_protocolizacion"
                    type="number"
                    class="w-full px-4 py-3 bg-surface-muted border-none rounded-2xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-medium outline-none"
                    placeholder="2024"
                  />
                </div>
                <div class="sm:col-span-2 space-y-2">
                  <label class="text-xs font-bold uppercase tracking-wider text-text-muted ml-1"
                    >Fecha de Registro</label
                  >
                  <DatePicker
                    v-model="marea.fecha_protocolizacion"
                    :show-time="false"
                  />
                </div>
              </div>

              <div
                class="mt-12 p-6 bg-info/5 rounded-3xl border border-info/10 flex gap-5 items-start"
              >
                <div class="w-10 h-10 rounded-xl bg-info/10 flex items-center justify-center text-info shrink-0">
                  <InfoCircleIcon class="w-6 h-6" />
                </div>
                <p class="text-xs text-info leading-relaxed font-medium">
                  <span class="font-black uppercase tracking-tighter block mb-1">Aviso Importante</span>
                  Al asignar un número de protocolización, la marea pasará automáticamente al estado
                  <strong class="font-bold">PROTOCOLIZADA</strong>. Esto bloqueará permanentemente la edición de los datos operativos y de captura para asegurar la integridad legal.
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- 7. Historial Alertas Tab -->
        <div v-if="activeTab === 'historial_alertas'" class="max-w-4xl mx-auto">
            <div class="bg-surface border border-border rounded-2xl p-6 shadow-sm">
                <h3 class="text-lg font-bold text-text mb-6 flex items-center gap-2">
                    <BellIcon class="w-5 h-5 text-primary" />
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
      return 'bg-error/10 text-error'
    case 'DOCX':
      return 'bg-info/10 text-info'
    case 'ZIP':
    case 'DBF':
      return 'bg-warning/10 text-warning'
    default:
      return 'bg-surface-muted text-text-muted'
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
