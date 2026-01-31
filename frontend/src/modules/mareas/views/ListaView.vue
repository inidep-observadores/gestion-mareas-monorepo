<template>
  <AdminLayout 
    title="Lista de Mareas por Estado" 
    description="Vista agrupada y detallada del flujo de trabajo de mareas."
  >
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="mb-6 flex justify-end">
        <div class="flex gap-3">
          <SearchInput
            v-model="searchQuery"
            placeholder="Filtrar por buque..."
          />
        </div>
      </div>

      <!-- Grouped List -->
      <div class="space-y-6">
        <div
          v-for="group in filteredGroups"
          :key="group.id"
          class="bg-surface border border-border rounded-2xl overflow-hidden shadow-sm"
        >
          <div
            class="px-6 py-4 bg-surface-muted border-b border-border flex items-center justify-between cursor-pointer"
            @click="group.expanded = !group.expanded"
          >
            <div class="flex items-center gap-3">
              <div :class="['w-2 h-2 rounded-full', group.color]"></div>
              <h2 class="font-bold text-text">{{ group.title }}</h2>
              <span
                class="px-2 py-0.5 bg-surface border border-border rounded text-xs text-text-muted"
              >
                {{ group.tasks.length }}
              </span>
            </div>
            <button
              class="text-text-muted hover:text-text transition-transform"
              :class="{ 'rotate-180': !group.expanded }"
            >
              <ChevronDownIcon class="w-5 h-5" />
            </button>
          </div>

          <div v-show="group.expanded" class="divide-y divide-border">
            <div
              v-if="group.tasks.length === 0"
              class="p-8 text-center text-text-muted text-sm italic"
            >
              No hay mareas registradas en este estado.
            </div>
            <div
              v-for="task in group.tasks"
              :key="task.id"
              class="p-6 hover:bg-surface-muted transition-colors px-4 sm:px-6"
            >
              <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div class="flex items-start gap-4">
                  <div
                    class="w-12 h-12 rounded-xl bg-surface-muted flex items-center justify-center flex-shrink-0"
                  >
                    <DocsIcon class="w-6 h-6 text-text-muted" />
                  </div>
                  <div>
                    <div class="flex items-center gap-2 mb-1">
                      <span class="text-xs font-mono font-bold text-primary">{{
                        task.code
                      }}</span>
                      <span
                        v-if="task.alert"
                        class="inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-[10px] bg-error/10 text-error"
                      >
                        <WarningIcon class="w-3 h-3" />
                        Alerta
                      </span>
                    </div>
                    <h4 class="font-bold text-text text-lg">
                      {{ task.vessel }}
                    </h4>
                    <div class="flex items-center gap-4 mt-1 text-sm text-text-muted">
                      <span class="flex items-center gap-1">
                        <CalenderIcon class="w-4 h-4" />
                        {{ task.date }}
                      </span>
                      <span class="flex items-center gap-1">
                        <UserCircleIcon class="w-4 h-4" />
                        JD (Observador)
                      </span>
                    </div>
                  </div>
                </div>
                <div class="flex items-center gap-3">
                  <button
                    class="px-4 py-2 text-sm font-medium border border-border text-text rounded-lg hover:bg-surface-muted transition-colors shadow-sm"
                  >
                    Ver Detalles
                  </button>
                  <button
                    class="px-4 py-2 text-sm font-medium bg-primary text-primary-fg rounded-lg hover:bg-primary/90 transition-all shadow-lg shadow-primary/20 active:scale-[0.98]"
                  >
                    Continuar Flujo
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchInput from '@/components/ui/SearchInput.vue'
import { ChevronDownIcon, DocsIcon, CalenderIcon, UserCircleIcon, WarningIcon } from '@/icons'

interface Task {
  id: number
  code: string
  vessel: string
  date: string
  alert: boolean
}

interface Group {
  id: string
  title: string
  color: string
  expanded: boolean
  tasks: Task[]
}

const groups = ref<Group[]>([
  {
    id: 'designada',
    title: 'Designada',
    color: 'bg-primary',
    expanded: true,
    tasks: [
      { id: 1, code: 'MA-001', vessel: 'BP ARGENTINO I', date: '20 Dic 2023', alert: false },
      { id: 2, code: 'MA-002', vessel: 'BP MAR DEL SUR', date: '21 Dic 2023', alert: true },
    ],
  },
  {
    id: 'navegando',
    title: 'Navegando',
    color: 'bg-info',
    expanded: true,
    tasks: [{ id: 3, code: 'MA-003', vessel: 'BP UNION', date: '15 Dic 2023', alert: false }],
  },
  {
    id: 'arribada',
    title: 'Arribada',
    color: 'bg-success',
    expanded: false,
    tasks: [
      { id: 4, code: 'MA-004', vessel: 'BP ESTRELLA', date: '22 Dic 2023', alert: false },
      { id: 5, code: 'MA-005', vessel: 'BP VICTORIA', date: '23 Dic 2023', alert: false },
    ],
  },
  {
    id: 'revision',
    title: 'En Revisión',
    color: 'bg-warning',
    expanded: false,
    tasks: [{ id: 6, code: 'MA-006', vessel: 'BP ATLANTICO', date: '18 Dic 2023', alert: true }],
  },
  {
    id: 'finalizada',
    title: 'Finalizada',
    color: 'bg-surface-muted border border-border',
    expanded: false,
    tasks: [{ id: 7, code: 'MA-007', vessel: 'BP PACIFICO', date: '10 Dic 2023', alert: false }],
  },
])
const searchQuery = ref('')

const filteredGroups = computed(() => {
  if (!searchQuery.value) return groups.value

  const query = searchQuery.value.toLowerCase().trim()
  
  return groups.value.map(group => ({
    ...group,
    tasks: group.tasks.filter(task => 
      task.vessel.toLowerCase().includes(query) || 
      task.code.toLowerCase().includes(query)
    ),
    // Expand groups that have matches
    expanded: group.tasks.some(task => 
      task.vessel.toLowerCase().includes(query) || 
      task.code.toLowerCase().includes(query)
    ) ? true : group.expanded
  })).filter(group => group.tasks.length > 0)
})
</script>
