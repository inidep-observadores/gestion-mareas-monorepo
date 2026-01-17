<template>
  <AdminLayout 
    title="Panel Operativo" 
    description="Gestión centralizada de mareas, alertas críticas y monitoreo de flota."
  >
    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10 flex flex-col xl:flex-row gap-8 items-start">
      <div class="flex-1 min-w-0 w-full">
      
      <!-- 1. ALERTAS URGENTES (Urgente) -->
      <section v-if="alertasUrgente.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-error flex items-center gap-2">
            <span class="flex h-3 w-3 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/60 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-3 w-3 bg-error shadow-[0_0_10px_rgba(244,63,94,0.5)]"></span>
            </span>
            Atención Inmediata (Prioridad Urgente)
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasUrgente" 
            :key="alerta.id"
            v-bind="alerta"
            :fecha="formatDate(alerta.fechaDetectada)"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 2. ALERTAS CRÍTICAS (Alta) -->
      <section v-if="alertasAlta.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-warning flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="relative inline-flex rounded-full h-2 w-2 bg-warning"></span>
            </span>
            Gestión Prioritaria (Prioridad Alta)
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasAlta" 
            :key="alerta.id"
            v-bind="alerta"
            :fecha="formatDate(alerta.fechaDetectada)"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 3. ALERTAS RECOMENDADAS (Media) -->
      <section v-if="alertasMedia.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-info flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="relative inline-flex rounded-full h-2 w-2 bg-info"></span>
            </span>
            Atención Recomendada (Prioridad Media)
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasMedia" 
            :key="alerta.id"
            v-bind="alerta"
            :fecha="formatDate(alerta.fechaDetectada)"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 4. ALERTAS INFORMATIVAS (Baja) -->
      <section v-if="alertasBaja.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-purple flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="relative inline-flex rounded-full h-2 w-2 bg-purple"></span>
            </span>
            Notificaciones (Prioridad Baja)
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasBaja" 
            :key="alerta.id"
            v-bind="alerta"
            :fecha="formatDate(alerta.fechaDetectada)"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 1b. HEADER: ALERTAS EN SEGUIMIENTO -->
      <section v-if="alertasSeguimiento.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-warning flex items-center gap-2">
            <div class="p-1 bg-warning/10 rounded">
                <BellIcon class="w-3 h-3" />
            </div>
            Alertas en Seguimiento
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasSeguimiento" 
            :key="alerta.id"
            v-bind="alerta"
            :fecha="formatDate(alerta.fechaDetectada)"
            :estado="AlertaEstado.SEGUIMIENTO"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 2. TABS & FILTERS -->
      <div class="sticky top-0 z-20 bg-background/80 backdrop-blur-md py-4 mb-6 -mx-2 px-2 border-b border-border">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
          <!-- Premium Tabs -->
          <div class="flex p-1 bg-surface-muted border border-border rounded-2xl w-fit shadow-sm">
            <button 
              v-for="tab in tabs" 
              :key="tab.id"
              @click="activeTab = tab.id"
              class="relative px-6 py-2 text-xs font-black uppercase tracking-tight transition-all duration-300 rounded-xl overflow-hidden"
              :class="activeTab === tab.id ? 'text-primary-fg' : 'text-text-muted hover:text-text'"
            >
              <div 
                v-if="activeTab === tab.id"
                class="absolute inset-0 bg-primary transition-all duration-300"
              ></div>
              <span class="relative z-10 flex items-center gap-2">
                 {{ tab.label }}
                 <Badge 
                   variant="solid" 
                   size="sm"
                   class="font-extrabold h-4 px-1.5"
                   :color="activeTab === tab.id ? 'light' : 'primary'"
                   :style="activeTab === tab.id ? 'background-color: rgba(255,255,255,0.2)' : ''"
                 >
                   {{ tab.count }}
                 </Badge>
              </span>
            </button>
          </div>

          <!-- Search & Sort -->
          <div class="flex items-center gap-3">
             <SearchInput 
               v-model="searchQuery"
               placeholder="Buscar por buque, marea, observador..."
             />
             <button 
               @click="sortBy = sortBy === 'buque' ? 'observador' : 'buque'"
               class="p-2.5 bg-background border border-border rounded-xl text-text-muted hover:text-text transition-all shadow-sm flex items-center gap-2"
               :title="`Ordenar por: ${sortBy === 'buque' ? 'Buque' : 'Observador'}`"
             >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m3 16 4 4 4-4"/><path d="M7 20V4"/><path d="m21 8-4-4-4 4"/><path d="M17 4v16"/></svg>
                <span class="text-[10px] font-black uppercase tracking-tighter">{{ sortBy }}</span>
             </button>
          </div>
        </div>
      </div>

      <!-- 3. TASK GRID -->
      <div v-if="loading" class="flex items-center justify-center py-20">
        <div class="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
      </div>

      <transition-group 
        v-else
        name="list" 
        tag="div" 
        class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6"
      >
        <TaskCard 
          v-for="task in filteredTasks" 
          :key="task.id"
          v-bind="task"
          :show-observer="true"
          :compact="!!selectedMarea"
          @click="openDetails(task)"
          @action="(key) => handleTaskAction(task.id, key)"
        />
      </transition-group>

      <!-- 4. HISTORIAL DE GESTIÓN (Nueva Sección Inferior) -->
      <section class="mt-16 pt-12 border-t border-border/50 space-y-8">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 px-2">
          <div>
            <h2 class="text-sm font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
              <DocsIcon class="w-4 h-4" />
              Historial de Gestión
            </h2>
            <p class="text-[10px] font-bold text-text-muted/60 uppercase tracking-tighter mt-1">Registros de mareas concluidas y alertas resueltas</p>
          </div>
          
          <div class="w-full md:w-96">
            <SearchInput 
              v-model="historySearchQuery"
              placeholder="Buscar en el historial..."
            />
          </div>
        </div>

        <div class="space-y-6">
          <!-- Collapsible: Alertas Cerradas -->
          <div class="rounded-3xl border border-border bg-background shadow-sm overflow-hidden">
            <button
              @click="toggleHistorialSection('alertas')"
              class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
              :class="{ 'border-border bg-surface-muted/30': expandedHistorialSection === 'alertas' }"
            >
              <div class="flex items-center gap-3">
                <div class="p-2 bg-success/10 rounded-xl">
                  <BellIcon class="w-5 h-5 text-success" />
                </div>
                <div>
                  <h4 class="text-sm font-black text-text/90 uppercase tracking-tight flex items-center gap-2">
                    Alertas Cerradas
                    <Badge variant="light" size="sm" class="font-black px-1.5 h-4">
                      {{ filteredHistoryAlerts.length }}
                    </Badge>
                  </h4>
                </div>
              </div>
              <svg 
                xmlns="http://www.w3.org/2000/svg" 
                class="w-5 h-5 text-text-muted transition-transform duration-300" 
                :class="{ 'rotate-180': expandedHistorialSection === 'alertas' }"
                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              >
                <polyline points="6 9 12 15 18 9"/>
              </svg>
            </button>

            <Transition
              enter-active-class="transition-all duration-300 ease-out"
              enter-from-class="max-h-0 opacity-0"
              enter-to-class="max-h-[2000px] opacity-100"
              leave-active-class="transition-all duration-200 ease-in"
              leave-from-class="max-h-[2000px] opacity-100"
              leave-to-class="max-h-0 opacity-0"
            >
              <div v-if="expandedHistorialSection === 'alertas'" class="p-5 pt-2">
                <div v-if="filteredHistoryAlerts.length > 0" class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6">
                  <InboxAlertCard 
                    v-for="alert in filteredHistoryAlerts" 
                    :key="alert.id"
                    :titulo="alert.titulo"
                    :descripcion="alert.descripcion"
                    :fecha="formatDate(alert.fechaCierre || alert.fechaDetectada)"
                    :estado="alert.estado"
                    :notaGestion="alert.notaGestion"
                    @action="(type) => handleAlertAction(alert.id, type)"
                  />
                </div>
                <div v-else class="text-center py-6 bg-surface-muted/30 rounded-2xl border border-dashed border-border text-xs text-text-muted">
                  Sin registros que coincidan con la búsqueda.
                </div>
              </div>
            </Transition>
          </div>

          <!-- Collapsible: Historial de Mareas -->
          <div class="rounded-3xl border border-border bg-background shadow-sm overflow-hidden">
            <button
              @click="toggleHistorialSection('mareas')"
              class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
              :class="{ 'border-border bg-surface-muted/30': expandedHistorialSection === 'mareas' }"
            >
              <div class="flex items-center gap-3">
                <div class="p-2.5 bg-surface-muted rounded-2xl border border-border">
                  <DocsIcon class="w-5 h-5 text-text-muted" />
                </div>
                <div>
                  <h4 class="text-sm font-black text-text/80 uppercase tracking-tight flex items-center gap-2">
                    Historial de Mareas
                    <Badge variant="light" size="sm" class="font-black px-1.5 h-4">
                      {{ filteredHistoryTasks.length }}
                    </Badge>
                  </h4>
                </div>
              </div>
              <svg 
                xmlns="http://www.w3.org/2000/svg" 
                class="w-5 h-5 text-text-muted transition-transform duration-300" 
                :class="{ 'rotate-180': expandedHistorialSection === 'mareas' }"
                viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
              >
                <polyline points="6 9 12 15 18 9"/>
              </svg>
            </button>

            <Transition
              enter-active-class="transition-all duration-300 ease-out"
              enter-from-class="max-h-0 opacity-0"
              enter-to-class="max-h-[2000px] opacity-100"
              leave-active-class="transition-all duration-200 ease-in"
              leave-from-class="max-h-[2000px] opacity-100"
              leave-to-class="max-h-0 opacity-0"
            >
              <div v-if="expandedHistorialSection === 'mareas'" class="p-5 pt-2">
                <div v-if="filteredHistoryTasks.length > 0" class="grid grid-cols-1 md:grid-cols-2 2xl:grid-cols-3 gap-6">
                  <TaskCard 
                    v-for="task in filteredHistoryTasks" 
                    :key="task.id"
                    v-bind="task"
                    :show-observer="true"
                    :compact="!!selectedMarea"
                    @click="openDetails(task)"
                    @action="(key) => handleTaskAction(task.id, key)"
                  />
                </div>
                <div v-else class="text-center py-6 bg-surface-muted/30 rounded-2xl border border-dashed border-border text-xs text-text-muted">
                  Sin registros que coincidan con la búsqueda.
                </div>
              </div>
            </Transition>
          </div>
        </div>
      </section>

      </div>

      <!-- PANEL DE DETALLE LATERAL (Sustituye al sidebar en esta vista) -->
      <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="translate-x-4 opacity-0"
        enter-to-class="translate-x-0 opacity-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="translate-x-0 opacity-100"
        leave-to-class="translate-x-4 opacity-0"
      >
        <div 
          v-if="selectedMarea"
          class="w-full xl:w-[400px] shrink-0 sticky top-6 bg-surface border border-border rounded-[2.5rem] shadow-xl overflow-hidden self-start hidden xl:block"
        >
          <MareaContextDetailContent 
            :marea="selectedMarea"
            :context="selectedMareaContext"
            @close="selectedMarea = null"
            @open-detalle="goToDetalle"
            @action="executeSidebarAction"
          />
        </div>
      </Transition>
    </div>

    <!-- ALERT MANAGEMENT DIALOG -->
    <AlertManagementDialog 
      :is-open="isAlertDialogOpen"
      :alert="selectedAlert"
      @close="isAlertDialogOpen = false"
      @refresh="loadInbox"
    />

    <!-- RECIBIR ARCHIVOS DIALOG -->
    <RecibirArchivosDialog
       :show="showRecibirDialog"
       :marea="mareaToManage"
       @close="handleRecibirCancel"
       @confirm="handleRecibirConfirm"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, markRaw } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import TaskCard from '../components/TaskCard.vue'
import InboxAlertCard from '../components/InboxAlertCard.vue'
import MareaContextDetailContent from '../components/MareaContextDetailContent.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import mareasService from '../services/mareas.service'
import { alertsService } from '@/modules/alerts/services/alerts.service'
import { EditIcon, CheckIcon, DocsIcon, BellIcon } from '@/icons'
import { useMareas } from '../composables/useMareas'
import { toast } from 'vue-sonner'
import { AlertaEstado, AlertaPrioridad } from '../../alerts/services/alerts.service'

const router = useRouter()
const { fetchMareaContext, selectedMareaContext, executeAction } = useMareas()

// Data State
const loading = ref(true)
const alertas = ref<any[]>([])
const alertasHistoricas = ref<any[]>([])
const tasks = ref<any[]>([])
const activeTab = ref('urgentes')
const searchQuery = ref('')
const historySearchQuery = ref('')
const sortBy = ref<'buque' | 'observador'>('buque')

// 1. Computed properties
const tareasUrgentes = computed(() => tasks.value.filter(t => t.tab === 'urgentes'))
const tareasPendientes = computed(() => tasks.value.filter(t => t.tab === 'pendientes'))

// Nuevas subdivisiones de alertas activas
// Nuevas subdivisiones de alertas activas por prioridad
const alertasPendientesTotal = computed(() => alertas.value.filter(a => [AlertaEstado.PENDIENTE, AlertaEstado.VENCIDA].includes(a.estado)))
const alertasUrgente = computed(() => alertasPendientesTotal.value.filter(a => a.prioridad === AlertaPrioridad.URGENTE))
const alertasAlta = computed(() => alertasPendientesTotal.value.filter(a => a.prioridad === AlertaPrioridad.ALTA))
const alertasMedia = computed(() => alertasPendientesTotal.value.filter(a => a.prioridad === AlertaPrioridad.MEDIA))
const alertasBaja = computed(() => alertasPendientesTotal.value.filter(a => a.prioridad === AlertaPrioridad.BAJA))
const alertasSeguimiento = computed(() => alertas.value.filter(a => a.estado === AlertaEstado.SEGUIMIENTO))

const tabs = computed(() => [
  { id: 'urgentes', label: 'Acciones Urgentes', count: tareasUrgentes.value?.length || 0 },
  { id: 'pendientes', label: 'Pendientes', count: tareasPendientes.value?.length || 0 },
  { id: 'proceso', label: 'En Proceso', count: 0 },
])

const activeTabLabel = computed(() => tabs.value.find(t => t.id === activeTab.value)?.label)

const filteredTasks = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  let result = tasks.value.filter(t => t.tab === activeTab.value)

  if (query) {
    result = result.filter(task => {
      const values = [
        task.buque,
        task.idMarea,
        task.observador,
        task.hito,
        task.estadoDescripcion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  // Sort
  return result.sort((a, b) => {
    if (sortBy.value === 'buque') {
      return a.buque.localeCompare(b.buque)
    } else {
      return (a.observador || '').localeCompare(b.observador || '')
    }
  })
})

const filteredHistoryTasks = computed(() => {
  const query = historySearchQuery.value.trim().toLowerCase()
  let result = tasks.value.filter(t => t.tab === 'historial')

  if (query) {
    result = result.filter(task => {
      const values = [
        task.buque,
        task.idMarea,
        task.observador,
        task.hito,
        task.estadoDescripcion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  return result.sort((a, b) => a.buque.localeCompare(b.buque))
})

const filteredHistoryAlerts = computed(() => {
  const query = historySearchQuery.value.trim().toLowerCase()
  let result = alertasHistoricas.value

  if (query) {
    result = result.filter(alert => {
      const values = [
        alert.titulo,
        alert.descripcion,
        alert.notaGestion
      ]
        .filter(Boolean)
        .map((value: string) => value.toLowerCase())

      return values.some(value => value.includes(query))
    })
  }

  return result
})

const formatDate = (dateStr?: string) => {
    if (!dateStr) return 'N/A'
    return new Date(dateStr).toLocaleDateString('es-AR', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    })
}

const resolveActions = (task: any) => {
  if (task.tab === 'urgentes') {
    return [
      { label: 'Corregir', key: 'edit', icon: markRaw(EditIcon), primary: true },
      { label: 'Revisar', key: 'review', icon: markRaw(DocsIcon) }
    ]
  }
  if (task.tab === 'pendientes') {
    return [
      { label: 'Gestionar', key: 'manage', icon: markRaw(CheckIcon), primary: true },
      { label: 'Ver Detalle', key: 'view', icon: markRaw(DocsIcon) }
    ]
  }
  return [
    { label: 'Ver Detalle', key: 'view', icon: markRaw(DocsIcon) }
  ]
}

const loadInbox = async () => {
  try {
    loading.value = true
    const data = await mareasService.getInbox()
    alertas.value = data.alerts || []
    tasks.value = (data.tasks || []).map(t => ({
      ...t,
      actions: resolveActions(t)
    }))

    // Load historic alerts (resolved or dismissed)
    const allAlerts = await alertsService.getAll({}) || []
    
    alertasHistoricas.value = allAlerts
        .filter(a => a.estado === AlertaEstado.RESUELTA || a.estado === AlertaEstado.DESCARTADA)
        .sort((a, b) => {
            const dateA = new Date(a.fechaCierre || a.fechaDetectada || 0).getTime()
            const dateB = new Date(b.fechaCierre || b.fechaDetectada || 0).getTime()
            return dateB - dateA
        })

  } catch (error) {
    console.error('Error loading inbox:', error)
    toast.error('Error al actualizar la bandeja de entrada')
  } finally {
    loading.value = false
  }
}

onMounted(loadInbox)

// UI Actions
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)
const showRecibirDialog = ref(false)
const mareaToManage = ref<any>(null)

const expandedHistorialSection = ref<'alertas' | 'mareas' | null>(null)

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const openDetails = async (task: any) => {
  if (window.innerWidth < 1280) {
    router.push({ name: 'MareaOperativaDetalle', params: { id: task.id } })
    return
  }
  selectedMarea.value = { id: task.id, id_marea: task.idMarea, buque_nombre: task.buque }
  await fetchMareaContext(task.id)
}

const handleTaskAction = (taskId: string, actionKey: string) => {
  if (actionKey === 'edit' || actionKey === 'manage' || actionKey === 'view') {
    router.push({ name: 'MareaDetalle', params: { id: taskId } })
  }
}

const handleAlertAction = (alertId: string, type: string) => {
    const alert = alertas.value.find(a => a.id === alertId) || alertasHistoricas.value.find(a => a.id === alertId)
    if (alert) {
        selectedAlert.value = alert
        isAlertDialogOpen.value = true
    }
}

const executeSidebarAction = async (key: string) => {
  if (!selectedMarea.value) return
  
  if (key === 'RECIBIR_DATOS') {
    mareaToManage.value = selectedMareaContext.value?.marea || selectedMarea.value
    showRecibirDialog.value = true
    return
  }

  await executeAction(selectedMarea.value.id, key)
}

const goToDetalle = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
  }
}

const handleRecibirCancel = () => {
    showRecibirDialog.value = false
    isSidebarOpen.value = false
}

const handleRecibirConfirm = async (payload: any) => {
    try {
        await executeAction(mareaToManage.value.id, 'RECIBIR_DATOS', payload)
        showRecibirDialog.value = false
        mareaToManage.value = null
        isSidebarOpen.value = false
        await loadInbox()
    } catch (err) {
        console.error("Error en recepción de archivos:", err)
    }
}

const toggleHistorialSection = (section: 'alertas' | 'mareas') => {
  expandedHistorialSection.value = expandedHistorialSection.value === section ? null : section
}
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.5s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}
</style>
