<template>
  <AdminLayout 
    title="Bandeja de Entrada" 
    description="Gestión centralizada de tareas, alertas críticas y flujos administrativos."
  >
    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10">
      
      <!-- 1. HEADER: ALERTAS CRÍTICAS (Pendientes) -->
      <section v-if="alertasPendientes.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-error flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-error/40 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-error"></span>
            </span>
            Atención Inmediata (Pendientes)
          </h2>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasPendientes" 
            :key="alerta.id"
            :titulo="alerta.titulo"
            :descripcion="alerta.descripcion"
            :fecha="formatDate(alerta.fechaDetectada)"
            :estado="alerta.estado"
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
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertasSeguimiento" 
            :key="alerta.id"
            :titulo="alerta.titulo"
            :descripcion="alerta.descripcion"
            :fecha="formatDate(alerta.fechaDetectada)"
            :estado="'SEGUIMIENTO'"
            :notaGestion="alerta.notaGestion"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 2. TABS & FILTERS -->
      <div class="sticky top-0 z-20 bg-base-100/80 backdrop-blur-md py-4 mb-6 -mx-2 px-2 border-b border-base-content/10">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
          <!-- Premium Tabs -->
          <div class="flex p-1 bg-base-200 border border-base-content/10 rounded-2xl w-fit shadow-sm">
            <button 
              v-for="tab in tabs" 
              :key="tab.id"
              @click="activeTab = tab.id"
              class="relative px-6 py-2 text-xs font-black uppercase tracking-tight transition-all duration-300 rounded-xl overflow-hidden"
              :class="activeTab === tab.id ? 'text-white' : 'text-base-content/40 hover:text-base-content/70'"
            >
              <div 
                v-if="activeTab === tab.id"
                class="absolute inset-0 bg-brand-500 transition-all duration-300"
              ></div>
              <span class="relative z-10 flex items-center gap-2">
                 {{ tab.label }}
                 <span 
                   class="badge badge-xs border-none font-bold"
                   :class="activeTab === tab.id ? 'bg-white/20 text-white' : 'bg-base-content/10 text-base-content/70'"
                 >
                   {{ tab.count }}
                 </span>
              </span>
            </button>
          </div>

          <!-- Search & Sort -->
          <div class="flex items-center gap-3">
             <div class="relative flex-1 md:flex-none">
                <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-base-content/30" />
                <input 
                  type="text" 
                  placeholder="Buscar por buque, marea, observador o estado..."
                  v-model="searchQuery"
                   class="pl-10 pr-4 py-2 bg-base-100 border border-base-content/10 rounded-2xl text-xs outline-none focus:ring-2 focus:ring-primary/20 w-full md:w-64 transition-all"
                />
             </div>
             <button class="p-2.5 bg-base-100 border border-base-content/10 rounded-xl text-base-content/40 hover:text-base-content/70 transition-all shadow-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m3 16 4 4 4-4"/><path d="M7 20V4"/><path d="m21 8-4-4-4 4"/><path d="M17 4v16"/></svg>
             </button>
          </div>
        </div>
      </div>

      <!-- 3. TASK GRID -->
      <div v-if="loading" class="flex items-center justify-center py-20">
        <span class="loading loading-spinner loading-lg text-brand-500"></span>
      </div>

      <div 
        v-else-if="activeTab === 'historial'"
        class="space-y-6"
      >
        <!-- Collapsible: Historic Alerts -->
        <div class="rounded-3xl border border-base-content/10 bg-base-100 shadow-sm overflow-hidden">
          <button
            @click="toggleHistorialSection('alertas')"
            class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
            :class="{ 'border-base-content/10 bg-base-200/30': expandedHistorialSection === 'alertas' }"
          >
            <div class="flex items-center gap-3">
              <div class="p-2 bg-success/10 rounded-xl">
                <BellIcon class="w-5 h-5 text-success/80" />
              </div>
              <div>
                <h4 class="text-sm font-black text-base-content/90 uppercase tracking-tight flex items-center gap-2">
                  Alertas Cerradas
                  <span class="text-[10px] px-1.5 py-0.5 rounded-lg font-black bg-base-content/10 text-base-content/60">
                    {{ alertasHistoricas.length }}
                  </span>
                </h4>
                <p class="text-[10px] font-bold text-base-content/30 uppercase tracking-[0.1em]">Finalizadas o canceladas</p>
              </div>
            </div>
            <svg 
              xmlns="http://www.w3.org/2000/svg" 
              class="w-5 h-5 text-base-content/40 transition-transform duration-300" 
              :class="{ 'rotate-180': expandedHistorialSection === 'alertas' }"
              viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            >
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </button>

          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[1000px] opacity-100"
            leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[1000px] opacity-100"
            leave-to-class="max-h-0 opacity-0"
          >
            <div v-if="expandedHistorialSection === 'alertas'" class="p-5 pt-2">
              <div v-if="alertasHistoricas.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <InboxAlertCard 
                  v-for="alert in alertasHistoricas" 
                  :key="alert.id"
                  :titulo="alert.titulo"
                  :descripcion="alert.descripcion"
                  :fecha="formatDate(alert.fechaCierre || alert.fechaDetectada)"
                  :estado="alert.estado"
                  :notaGestion="alert.notaGestion"
                  @action="(type) => handleAlertAction(alert.id, type)"
                />
              </div>
              <div v-else class="text-center py-6 bg-base-200/30 rounded-2xl border border-dashed border-base-content/10">
                <p class="text-xs font-medium text-base-content/40">Sin alertas cerradas en el historial.</p>
              </div>
            </div>
          </Transition>
        </div>

        <!-- Collapsible: Historic Tasks -->
        <div class="rounded-3xl border border-base-content/10 bg-base-100 shadow-sm overflow-hidden">
          <button
            @click="toggleHistorialSection('mareas')"
            class="w-full flex items-center justify-between p-5 text-left border-b border-transparent transition-colors"
            :class="{ 'border-base-content/10 bg-base-200/30': expandedHistorialSection === 'mareas' }"
          >
            <div class="flex items-center gap-3">
              <div class="p-2.5 bg-base-300/30 rounded-2xl border border-base-content/5">
                <DocsIcon class="w-5 h-5 text-base-content/40" />
              </div>
              <div>
                <h4 class="text-sm font-black text-base-content/80 uppercase tracking-tight flex items-center gap-2">
                  Historial de Mareas
                  <span class="text-[10px] px-1.5 py-0.5 rounded-lg font-black bg-base-content/10 text-base-content/60">
                    {{ filteredTasks.length }}
                  </span>
                </h4>
                <p class="text-[10px] font-bold text-base-content/30 uppercase tracking-[0.1em]">Operaciones concluidas</p>
              </div>
            </div>
            <svg 
              xmlns="http://www.w3.org/2000/svg" 
              class="w-5 h-5 text-base-content/40 transition-transform duration-300" 
              :class="{ 'rotate-180': expandedHistorialSection === 'mareas' }"
              viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"
            >
              <polyline points="6 9 12 15 18 9"/>
            </svg>
          </button>

          <Transition
            enter-active-class="transition-all duration-300 ease-out"
            enter-from-class="max-h-0 opacity-0"
            enter-to-class="max-h-[1000px] opacity-100"
            leave-active-class="transition-all duration-200 ease-in"
            leave-from-class="max-h-[1000px] opacity-100"
            leave-to-class="max-h-0 opacity-0"
          >
            <div v-if="expandedHistorialSection === 'mareas'" class="p-5 pt-2">
              <div v-if="filteredTasks.length > 0" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                <TaskCard 
                  v-for="task in filteredTasks" 
                  :key="task.id"
                  v-bind="task"
                  :show-observer="true"
                  @click="openDetails(task)"
                  @action="(key) => handleTaskAction(task.id, key)"
                />
              </div>
              <div v-else class="text-center py-6 bg-base-200/30 rounded-2xl border border-dashed border-base-content/10">
                <p class="text-xs font-medium text-base-content/40">Sin mareas en el historial.</p>
              </div>
            </div>
          </Transition>
        </div>

        <!-- Empty State -->
        <div v-if="alertasHistoricas.length === 0 && filteredTasks.length === 0" class="flex flex-col items-center justify-center py-20 bg-base-200/30 rounded-[2.5rem] border border-dashed border-base-content/10">
          <div class="p-8 bg-base-100/50 rounded-full mb-6 shadow-sm border border-base-content/5">
            <DocsIcon class="w-12 h-12 text-base-content/10" />
          </div>
          <h3 class="text-xs font-black text-base-content/30 uppercase tracking-[0.2em] px-4 text-center">No hay registros historicos</h3>
          <p class="text-[11px] text-base-content/20 mt-3 text-center max-w-xs px-6 uppercase tracking-wider font-bold">Las tareas y alertas resueltas apareceran aqui una vez gestionadas.</p>
        </div>
      </div>
<transition-group 
        v-else
        name="list" 
        tag="div" 
        class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6"
      >
        <TaskCard 
          v-for="task in filteredTasks" 
          :key="task.id"
          v-bind="task"
          @click="openDetails(task)"
          @action="(key) => handleTaskAction(task.id, key)"
        />
      </transition-group>

      <div v-if="!loading && activeTab !== 'historial' && filteredTasks.length === 0" class="flex flex-col items-center justify-center py-20 px-4 text-center">
        <div class="w-24 h-24 bg-base-200/40 rounded-full flex items-center justify-center mb-6 border border-base-content/5">
           <CheckIcon class="w-10 h-10 text-primary/20" />
        </div>
        <h3 class="text-xl font-black text-base-content/90 uppercase tracking-tight">Todo al día</h3>
        <p class="text-base-content/40 mt-2 max-w-sm">
          No tienes tareas pendientes en la sección de <b>{{ activeTabLabel }}</b>.
        </p>
      </div>
    </div>

    <!-- SIDEBAR CONTEXTUAL -->
    <MareaContextSidebar 
      :is-open="isSidebarOpen"
      :marea="selectedMarea"
      :context="selectedMareaContext"
      @close="isSidebarOpen = false"
      @open-detalle="goToDetalle"
      @action="executeSidebarAction"
    />

    <!-- ALERT MANAGEMENT DIALOG -->
    <AlertManagementDialog 
      :is-open="isAlertDialogOpen"
      :alert="selectedAlert"
      @close="isAlertDialogOpen = false"
      @refresh="loadInbox"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, markRaw } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import TaskCard from '../components/TaskCard.vue'
import InboxAlertCard from '../components/InboxAlertCard.vue'
import MareaContextSidebar from '../components/MareaContextSidebar.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import mareasService from '../services/mareas.service'
import { alertsService } from '@/modules/alerts/services/alerts.service'
import { SearchIcon, EditIcon, CheckIcon, DocsIcon, BellIcon } from '@/icons'
import { useMareas } from '../composables/useMareas'
import { toast } from 'vue-sonner'

const router = useRouter()
const { fetchMareaContext, selectedMareaContext, executeAction } = useMareas()

// Data State
const loading = ref(true)
const alertas = ref<any[]>([])
const alertasHistoricas = ref<any[]>([])
const tasks = ref<any[]>([])
const activeTab = ref('urgentes')
const searchQuery = ref('')

// 1. Computed properties
const tareasUrgentes = computed(() => tasks.value.filter(t => t.tab === 'urgentes'))
const tareasPendientes = computed(() => tasks.value.filter(t => t.tab === 'pendientes'))

// Nuevas subdivisiones de alertas activas
const alertasPendientes = computed(() => alertas.value.filter(a => ['PENDIENTE', 'VENCIDA'].includes(a.estado)))
const alertasSeguimiento = computed(() => alertas.value.filter(a => a.estado === 'SEGUIMIENTO'))

const tabs = computed(() => [
  { id: 'urgentes', label: 'Acciones Urgentes', count: tareasUrgentes.value?.length || 0 },
  { id: 'pendientes', label: 'Pendientes', count: tareasPendientes.value?.length || 0 },
  { id: 'proceso', label: 'En Proceso', count: 0 },
  { id: 'historial', label: 'Historial', count: (tasks.value.filter(t => t.tab === 'historial')?.length || 0) + (alertasHistoricas.value?.length || 0) },
])

const activeTabLabel = computed(() => tabs.value.find(t => t.id === activeTab.value)?.label)

const filteredTasks = computed(() => {
  const query = searchQuery.value.trim().toLowerCase()
  const filteredByTab = tasks.value.filter(t => t.tab === activeTab.value)

  if (!query) return filteredByTab

  return filteredByTab.filter(task => {
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
        .filter(a => a.estado === 'RESUELTA' || a.estado === 'DESCARTADA')
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

const expandedHistorialSection = ref<'alertas' | 'mareas' | null>(null)

// Alerts UI State
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const openDetails = async (task: any) => {
  selectedMarea.value = { id: task.id, id_marea: task.idMarea, buque_nombre: task.buque }
  isSidebarOpen.value = true
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
  await executeAction(selectedMarea.value.id, key)
}

const goToDetalle = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
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
