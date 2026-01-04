<template>
  <AdminLayout
    :title="marea ? `Marea ${marea.tipoMarea}-${String(marea.nroMarea).padStart(3, '0')}-${String(marea.anioMarea).slice(-2)}` : 'Cargando...'"
    :description="marea?.buque?.nombreBuque || 'Detalle de Marea'"
  >
    <div v-if="loading" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-pulse space-y-8">
      <!-- Skeleton Header -->
      <div class="h-8 bg-gray-200 dark:bg-gray-800 rounded-lg w-1/3"></div>
      <div class="h-32 bg-gray-200 dark:bg-gray-800 rounded-2xl w-full"></div>
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="h-64 bg-gray-200 dark:bg-gray-800 rounded-2xl col-span-2"></div>
        <div class="h-64 bg-gray-200 dark:bg-gray-800 rounded-2xl"></div>
      </div>
    </div>

    <div v-else-if="marea" class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-12">
      <!-- Premium Sticky Header -->
      <div class="sticky top-0 z-20 backdrop-blur-xl bg-white/80 dark:bg-gray-950/80 border-b border-gray-200/50 dark:border-gray-800/50 -mx-6 px-6 py-4 mb-8 flex flex-col sm:flex-row items-center justify-between gap-4 transition-all duration-300">
        <div class="flex items-center gap-4">
          <button @click="router.back()" class="p-2 rounded-full hover:bg-gray-100 dark:hover:bg-gray-800 transition-colors text-gray-500">
            <ArrowLeftIcon class="w-5 h-5" />
          </button>
          <div>
            <div class="flex items-center gap-3">
              <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">
                {{ marea.buque.nombreBuque }}
              </h1>
              <span 
                class="px-2.5 py-0.5 rounded-full text-xs font-black uppercase tracking-wider border"
                :class="getStatusColor(marea.estadoActual?.nombre)"
              >
                {{ marea.estadoActual?.nombre || 'Desconocido' }}
              </span>
            </div>
            <div class="flex items-center gap-2 text-sm text-gray-500 font-medium">
              <span class="font-mono text-brand-500 bg-brand-50 dark:bg-brand-500/10 px-1.5 rounded">
                {{ marea.tipoMarea }}-{{ marea.nroMarea }}
              </span>
              <span>•</span>
              <span>{{ marea.anioMarea }}</span>
            </div>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <button class="flex items-center gap-2 px-4 py-2 text-gray-500 hover:bg-gray-100 dark:hover:bg-gray-800 font-bold rounded-xl transition-colors text-sm">
            <DownloadIcon class="w-4 h-4" />
            <span class="hidden sm:inline">Exportar</span>
          </button>
          <button class="flex items-center gap-2 px-4 py-2 bg-brand-500 hover:bg-brand-600 text-white font-bold rounded-xl transition-all shadow-lg shadow-brand-500/20 active:scale-95 text-sm">
            <SettingsIcon class="w-4 h-4" />
            <span>Gestionar</span>
          </button>
        </div>
      </div>

      <!-- Content Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        
        <!-- Left Column (Navigation & Highlights) -->
        <div class="lg:col-span-3 space-y-6 lg:sticky lg:top-32">
          <!-- Navigation Menu -->
          <nav class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden p-2">
            <button
              v-for="tab in tabs"
              :key="tab.id"
              @click="activeTab = tab.id"
              class="w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200 text-sm font-bold"
              :class="activeTab === tab.id 
                ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-600 dark:text-brand-400' 
                : 'text-gray-500 hover:bg-gray-50 dark:hover:bg-gray-800'"
            >
              <component :is="tab.icon" class="w-5 h-5" />
              {{ tab.label }}
              <div v-if="activeTab === tab.id" class="ml-auto w-1.5 h-1.5 bg-brand-500 rounded-full"></div>
            </button>
          </nav>

          <!-- Quick Stats -->
          <div class="bg-gradient-to-br from-gray-900 to-gray-800 rounded-2xl p-6 text-white shadow-xl shadow-gray-900/10">
            <h3 class="text-xs font-bold uppercase tracking-widest text-gray-400 mb-4">Resumen Operativo</h3>
            <div class="space-y-4">
              <div>
                <span class="text-gray-400 text-xs font-semibold">Días Estimados</span>
                <p class="text-2xl font-black font-mono">{{ marea.diasEstimados || '-' }}</p>
              </div>
              <div class="h-px bg-white/10"></div>
              <div>
                <span class="text-gray-400 text-xs font-semibold">Fecha Zarpada</span>
                <p class="text-lg font-bold">{{ formatDate(marea.etapas[0]?.fechaZarpada) }}</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Right Column (Main Content) -->
        <div class="lg:col-span-9 space-y-6">
          
          <!-- Tab: General Info -->
          <Transition name="fade" mode="out-in">
            <div v-if="activeTab === 'general'" class="space-y-8">
              <!-- Marea Overview Card -->
              <div class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-8 shadow-sm relative overflow-hidden">
                <div class="absolute top-0 right-0 w-64 h-64 bg-brand-500/5 rounded-full blur-3xl -translate-y-1/2 translate-x-1/2"></div>
                
                <h3 class="text-lg font-black text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                  <DocsIcon class="w-5 h-5 text-brand-500" />
                  Información Global
                </h3>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
                  <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-gray-400 mb-1.5">Título</label>
                    <p class="text-base font-medium text-gray-900 dark:text-white">{{ marea.titulo || 'Sin título asignado' }}</p>
                  </div>
                  <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-gray-400 mb-1.5">Pesquería Objetivo</label>
                    <p class="text-base font-medium text-brand-600 dark:text-brand-400 font-bold">
                       {{ marea.etapas[0]?.pesqueria?.nombre || 'No definida' }}
                    </p>
                  </div>
                  <div class="md:col-span-2">
                    <label class="block text-xs font-bold uppercase tracking-wider text-gray-400 mb-1.5">Descripción / Observaciones</label>
                    <p class="text-base font-medium text-gray-600 dark:text-gray-300 leading-relaxed">
                      {{ marea.descripcion || marea.observaciones || 'Sin descripción detallada disponible.' }}
                    </p>
                  </div>
                </div>
              </div>

              <!-- Observers Preview -->
              <div class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-8 shadow-sm">
                <h3 class="text-lg font-black text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                  <UserGroupIcon class="w-5 h-5 text-purple-500" />
                  Equipo a Bordo
                </h3>
                
                <div v-if="uniqueObservadores.length" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                  <div 
                    v-for="obs in uniqueObservadores" 
                    :key="obs.id"
                    class="flex items-center gap-4 p-4 rounded-2xl bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-800 transition-colors hover:border-brand-200 dark:hover:border-brand-500/30"
                  >
                    <div class="w-10 h-10 rounded-full bg-gradient-to-br from-brand-400 to-purple-500 text-white flex items-center justify-center font-bold text-sm shadow-lg shadow-brand-500/20">
                      {{ obs.observador.nombre.charAt(0) }}{{ obs.observador.apellido.charAt(0) }}
                    </div>
                    <div>
                      <p class="font-bold text-sm text-gray-900 dark:text-white">{{ obs.observador.nombre }} {{ obs.observador.apellido }}</p>
                      <p class="text-xs text-brand-500 font-bold uppercase tracking-wider">{{ obs.rol }}</p>
                    </div>
                  </div>
                </div>
                <div v-else class="text-center py-8 text-gray-400">
                  <p>No hay observadores asignados aún.</p>
                </div>
              </div>
            </div>

            <!-- Tab: Etapas (Stages) -->
            <div v-else-if="activeTab === 'etapas'" class="space-y-6">
              <div v-for="(etapa, index) in marea.etapas" :key="etapa.id" 
                class="group relative bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-0 overflow-hidden shadow-sm hover:shadow-lg transition-shadow duration-300"
              >
                <!-- Stage Header / Route Visualization -->
                <div class="bg-gray-50 dark:bg-gray-800/50 p-6 flex items-center justify-between border-b border-gray-100 dark:border-gray-800">
                  <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-white dark:bg-gray-800 shadow-sm flex items-center justify-center font-black text-brand-500 text-xl border border-gray-100 dark:border-gray-700">
                      {{ Number(index) + 1 }}
                    </div>
                    <div>
                      <h4 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
                        {{ etapa.puertoZarpada?.nombre || 'Origen' }}
                        <span class="text-gray-300 dark:text-gray-600">→</span>
                        {{ etapa.puertoArribo?.nombre || 'Destino' }}
                      </h4>
                      <p class="text-xs font-bold text-gray-400 uppercase tracking-wider">Etapa de Navegación</p>
                    </div>
                  </div>
                  <div class="hidden sm:block">
                     <span class="badge badge-blue">
                       {{ etapa.tipoEtapa || 'COMERCIAL' }}
                     </span>
                  </div>
                </div>

                <!-- Stage Details -->
                <div class="p-6 grid grid-cols-2 md:grid-cols-4 gap-6">
                  <div>
                    <span class="text-xs font-bold text-gray-400 uppercase">Zarpada</span>
                    <p class="text-sm font-bold text-gray-800 dark:text-gray-200 mt-1">
                      {{ formatDate(etapa.fechaZarpada) }}
                    </p>
                  </div>
                  <div>
                    <span class="text-xs font-bold text-gray-400 uppercase">Arribo</span>
                    <p class="text-sm font-bold text-gray-800 dark:text-gray-200 mt-1">
                      {{ formatDate(etapa.fechaArribo) }}
                    </p>
                  </div>
                  <div class="col-span-2">
                    <span class="text-xs font-bold text-gray-400 uppercase">Observaciones</span>
                    <p class="text-sm text-gray-600 dark:text-gray-400 mt-1 truncate">
                      {{ etapa.observaciones || 'Sin observaciones registradas.' }}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Tab: Workflow / History -->
            <div v-else-if="activeTab === 'workflow'" class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-3xl p-8 shadow-sm">
              <h3 class="text-lg font-black text-gray-900 dark:text-white mb-8">Historial de Eventos</h3>
              
              <div class="relative pl-8 border-l-2 border-gray-100 dark:border-gray-800 space-y-10 ml-4">
                <div v-if="!marea.movimientos.length" class="text-gray-500 italic">No hay movimientos registrados.</div>
                
                <div v-for="mov in marea.movimientos" :key="mov.id" class="relative group">
                  <div 
                    class="absolute -left-[43px] top-1 w-6 h-6 rounded-full border-4 border-white dark:border-gray-900 transition-colors"
                    :class="mov.tipoEvento === 'CAMBIO_ESTADO' ? 'bg-brand-500 shadow-lg shadow-brand-500/30' : 'bg-gray-300 dark:bg-gray-700'"
                  ></div>
                  
                  <div class="flex items-start justify-between gap-4">
                    <div>
                      <span class="text-xs font-black bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 px-2 py-0.5 rounded uppercase tracking-wider">
                        {{ mov.tipoEvento.replace(/_/g, ' ') }}
                      </span>
                      <p class="text-sm mt-2 text-gray-500">
                        {{ mov.detalle || 'Sin detalles adicionales.' }}
                      </p>
                      <div v-if="mov.estadoDesde && mov.estadoHasta" class="mt-2 flex items-center gap-2 text-xs font-mono bg-gray-50 dark:bg-gray-900/50 w-fit px-2 py-1 rounded border border-gray-200 dark:border-gray-800">
                         <span class="text-gray-400">{{ mov.estadoDesde.nombre }}</span>
                         <span>→</span>
                         <span class="text-gray-800 dark:text-white font-bold">{{ mov.estadoHasta.nombre }}</span>
                      </div>
                    </div>
                    <div class="text-right shrink-0">
                      <p class="text-sm font-bold text-gray-900 dark:text-white">{{ formatDate(mov.fechaHora) }}</p>
                      <p class="text-xs text-gray-400 mt-0.5">{{ mov.usuario?.firstName || 'Sistema' }}</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </Transition>

        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import mareasService from '@/modules/mareas/services/mareas.service'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import {
  ArrowLeftIcon,
  DocsIcon,
  MapPinIcon,
  UserGroupIcon,
  HistoryIcon,
  FileTextIcon,
  SettingsIcon,
  DownloadIcon,
  CheckIcon,
  CalenderIcon,
  ShipIcon
} from '@/icons'

const route = useRoute()
const router = useRouter()
const loading = ref(true)
const marea = ref<any>(null)
const activeTab = ref('general')

const tabs = [
  { id: 'general', label: 'Visión General', icon: DocsIcon },
  { id: 'etapas', label: 'Etapas de Navegación', icon: MapPinIcon },
  { id: 'workflow', label: 'Historia y Trazabilidad', icon: HistoryIcon },
]

onMounted(async () => {
  try {
    const id = route.params.id as string
    marea.value = await mareasService.getById(id)
  } catch (error) {
    console.error('Error loading Marea:', error)
    // Could redirect or show error toast here
  } finally {
    loading.value = false
  }
})

// --- Computed Helpers ---

const uniqueObservadores = computed(() => {
  if (!marea.value?.etapas) return []
  const obsMap = new Map()
  
  marea.value.etapas.forEach((e: any) => {
    e.observadores.forEach((rel: any) => {
      // Avoid duplicates roughly by ID
      if (!obsMap.has(rel.observador.id)) {
        obsMap.set(rel.observador.id, {
          id: rel.id,
          observador: rel.observador,
          rol: rel.rol
        })
      }
    })
  })
  
  return Array.from(obsMap.values())
})

// --- UI Helpers ---

const formatDate = (dateStr: string) => {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('es-AR', {
    day: '2-digit', month: 'short', year: 'numeric',
    hour: '2-digit', minute: '2-digit'
  })
}

const getStatusColor = (status: string) => {
  if (!status) return 'bg-gray-100 text-gray-600 border-gray-200'
  const s = status.toUpperCase()
  if (s.includes('NAVEGANDO') || s.includes('ACTIVA')) return 'bg-green-50 text-green-700 border-green-200 dark:bg-green-500/10 dark:text-green-400 dark:border-green-500/20'
  if (s.includes('CORRECCION') || s.includes('REVISIO')) return 'bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-500/10 dark:text-amber-400 dark:border-amber-500/20'
  if (s.includes('FINALIZADA') || s.includes('CERRADA')) return 'bg-blue-50 text-blue-700 border-blue-200 dark:bg-blue-500/10 dark:text-blue-400 dark:border-blue-500/20'
  if (s.includes('CANCELADA')) return 'bg-red-50 text-red-700 border-red-200 dark:bg-red-500/10 dark:text-red-400 dark:border-red-500/20'
  return 'bg-gray-100 text-gray-600 border-gray-200'
}
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
