<template>
  <AdminLayout 
    title="Bandeja de Entrada" 
    description="Gestión centralizada de tareas, alertas críticas y flujos administrativos."
  >
    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10">
      
      <!-- 1. HEADER: ALERTAS CRÍTICAS (Solo si hay) -->
      <section v-if="alertas.length > 0" class="mb-8 space-y-4">
        <div class="flex items-center justify-between px-2">
          <h2 class="text-[10px] font-black uppercase tracking-[0.2em] text-red-500 flex items-center gap-2">
            <span class="flex h-2 w-2 relative">
              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
              <span class="relative inline-flex rounded-full h-2 w-2 bg-red-500"></span>
            </span>
            Atención Inmediata
          </h2>
          <span class="text-[10px] font-bold text-gray-400 underline cursor-pointer hover:text-gray-600 transition-colors">Marcar todo como visto</span>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <InboxAlertCard 
            v-for="alerta in alertas" 
            :key="alerta.id"
            :titulo="alerta.titulo"
            :descripcion="alerta.descripcion"
            :fecha="alerta.fecha"
            @action="(type) => handleAlertAction(alerta.id, type)"
          />
        </div>
      </section>

      <!-- 2. TABS & FILTERS -->
      <div class="sticky top-0 z-20 bg-gray-50/80 dark:bg-gray-950/80 backdrop-blur-md py-4 mb-6 -mx-2 px-2 border-b border-gray-200/50 dark:border-gray-800/50">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
          <!-- Premium Tabs -->
          <div class="flex p-1 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl w-fit shadow-sm">
            <button 
              v-for="tab in tabs" 
              :key="tab.id"
              @click="activeTab = tab.id"
              class="relative px-6 py-2 text-xs font-black uppercase tracking-tight transition-all duration-300 rounded-xl overflow-hidden"
              :class="activeTab === tab.id ? 'text-white' : 'text-gray-400 hover:text-gray-600 dark:hover:text-gray-200'"
            >
              <div 
                v-if="activeTab === tab.id"
                class="absolute inset-0 bg-brand-500 transition-all duration-300"
              ></div>
              <span class="relative z-10 flex items-center gap-2">
                 {{ tab.label }}
                 <span 
                   class="px-1.5 py-0.5 rounded-md text-[9px]"
                   :class="activeTab === tab.id ? 'bg-white/20' : 'bg-gray-100 dark:bg-gray-800 text-gray-400'"
                 >
                   {{ tab.count }}
                 </span>
              </span>
            </button>
          </div>

          <!-- Search & Sort -->
          <div class="flex items-center gap-3">
             <div class="relative flex-1 md:flex-none">
                <SearchIcon class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input 
                  type="text" 
                  placeholder="Buscar por buque o marea..."
                  class="pl-10 pr-4 py-2 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl text-xs outline-none focus:ring-2 focus:ring-brand-500/20 w-full md:w-64 transition-all"
                />
             </div>
             <button class="p-2.5 bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-xl text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-all shadow-sm">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m3 16 4 4 4-4"/><path d="M7 20V4"/><path d="m21 8-4-4-4 4"/><path d="M17 4v16"/></svg>
             </button>
          </div>
        </div>
      </div>

      <!-- 3. TASK GRID -->
      <div v-if="loading" class="flex items-center justify-center py-20">
        <span class="loading loading-spinner loading-lg text-brand-500"></span>
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

      <!-- EMPTY STATE -->
      <div v-if="filteredTasks.length === 0" class="flex flex-col items-center justify-center py-20 px-4 text-center">
        <div class="w-24 h-24 bg-gray-50 dark:bg-gray-900 rounded-full flex items-center justify-center mb-6">
           <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10 text-gray-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/><polyline points="14 2 14 8 20 8"/></svg>
        </div>
        <h3 class="text-xl font-black text-gray-900 dark:text-white uppercase tracking-tight">Nada por aquí</h3>
        <p class="text-gray-500 dark:text-gray-400 mt-2 max-w-sm">
          No hay tareas en la sección de <b>{{ activeTabLabel }}</b> que coincidan con los filtros actuales.
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
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import TaskCard from '../components/TaskCard.vue'
import InboxAlertCard from '../components/InboxAlertCard.vue'
import MareaContextSidebar from '../components/MareaContextSidebar.vue'
import mareasService from '../services/mareas.service'
import { SearchIcon, EditIcon, CheckIcon, DocsIcon, SuccessIcon } from '@/icons'
import { useMareas } from '../composables/useMareas'

const router = useRouter()
const { fetchMareaContext, selectedMareaContext, executeAction } = useMareas()

// Data State
const loading = ref(true)
const alertas = ref<any[]>([])
const tasks = ref<any[]>([])
const activeTab = ref('urgentes')

const loadInbox = async () => {
  try {
    loading.value = true
    const data = await mareasService.getInbox()
    alertas.value = data.alerts
    tasks.value = data.tasks.map(t => ({
      ...t,
      actions: resolveActions(t)
    }))
  } catch (error) {
    console.error('Error loading inbox:', error)
  } finally {
    loading.value = false
  }
}

const resolveActions = (task: any) => {
  if (task.tab === 'urgentes') {
    return [
      { label: 'Corregir', key: 'edit', icon: EditIcon, primary: true },
      { label: 'Revisar', key: 'review', icon: DocsIcon }
    ]
  }
  if (task.tab === 'proceso') {
     return [
      { label: 'Gestionar', key: 'manage', icon: CheckIcon, primary: true }
    ]
  }
  return [
    { label: 'Ver Detalle', key: 'view', icon: DocsIcon }
  ]
}

onMounted(loadInbox)

// Tabs Configuration
const tabs = computed(() => [
  { id: 'urgentes', label: 'Acciones Urgentes', count: tasks.value.filter(t => t.tab === 'urgentes').length },
  { id: 'proceso', label: 'En Proceso', count: tasks.value.filter(t => t.tab === 'proceso').length },
  { id: 'historial', label: 'Historial', count: tasks.value.filter(t => t.tab === 'historial').length },
])

const activeTabLabel = computed(() => tabs.value.find(t => t.id === activeTab.value)?.label)

const filteredTasks = computed(() => {
  return tasks.value.filter(t => t.tab === activeTab.value)
})

// UI Actions
const isSidebarOpen = ref(false)
const selectedMarea = ref<any>(null)

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
  if (type === 'dismiss') {
    alertas.value = alertas.value.filter(a => a.id !== alertId)
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
