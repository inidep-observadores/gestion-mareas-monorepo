<template>
  <Transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="opacity-0 scale-95"
    enter-to-class="opacity-100 scale-100"
    leave-active-class="transition duration-150 ease-in"
    leave-from-class="opacity-100 scale-100"
    leave-to-class="opacity-0 scale-95"
  >
    <div
      v-if="isOpen"
      class="fixed inset-0 z-[100] flex items-start justify-center pt-24 px-4 sm:px-6"
    >
      <!-- Backdrop -->
      <div 
        class="fixed inset-0 bg-gray-900/60 backdrop-blur-sm transition-opacity"
        @click="close"
      ></div>

      <!-- Spotlight Panel -->
      <div
        class="relative w-full max-w-2xl bg-white dark:bg-gray-950 rounded-2xl shadow-2xl border border-gray-200 dark:border-gray-800 overflow-hidden"
      >
        <!-- Search Input -->
        <div class="relative p-5 border-b border-gray-100 dark:border-gray-800 flex items-center gap-4">
          <SearchIcon class="w-6 h-6 text-gray-400" />
          <input
            ref="searchInput"
            v-model="query"
            type="text"
            placeholder="Buscar mareas, buques, observadores o acciones..."
            class="flex-1 bg-transparent border-none focus:ring-0 text-lg text-gray-800 dark:text-white placeholder:text-gray-400 outline-none"
            @keydown.esc="close"
            @keydown.down.prevent="moveDown"
            @keydown.up.prevent="moveUp"
            @keydown.enter="selectItem"
          />
          <div class="px-2 py-1 bg-gray-100 dark:bg-gray-800 rounded border border-gray-200 dark:border-gray-700 text-[10px] font-black text-gray-400">
            ESC
          </div>
        </div>

        <!-- Results -->
        <div 
          v-if="query || filteredItems.length" 
          class="max-h-[480px] overflow-y-auto custom-scrollbar p-2"
        >
          <div v-for="(group, gIndex) in groupedItems" :key="group.name" class="mb-4 last:mb-0">
            <h3 class="px-4 py-2 text-[10px] font-black text-gray-400 uppercase tracking-[0.2em]">
              {{ group.name }}
            </h3>
            <div class="space-y-1">
              <button
                v-for="(item, iIndex) in group.items"
                :key="item.id"
                :ref="el => setItemRef(el, item.globalIndex)"
                class="w-full flex items-center gap-4 px-4 py-3 rounded-xl transition-all text-left group"
                :class="[
                  selectedIndex === item.globalIndex 
                    ? 'bg-brand-500 text-white shadow-lg shadow-brand-500/20' 
                    : 'hover:bg-gray-50 dark:hover:bg-gray-900 text-gray-700 dark:text-gray-300'
                ]"
                @mouseenter="selectedIndex = item.globalIndex"
                @click="selectItem"
              >
                <div 
                  class="p-2 rounded-lg"
                  :class="[
                    selectedIndex === item.globalIndex 
                      ? 'bg-white/20 text-white' 
                      : 'bg-gray-100 dark:bg-gray-800 text-gray-500'
                  ]"
                >
                  <component :is="item.icon" class="w-4 h-4" />
                </div>
                <div class="flex-1">
                  <p class="text-sm font-bold" :class="{ 'text-white': selectedIndex === item.globalIndex }">
                    {{ item.title }}
                  </p>
                  <p 
                    class="text-[10px] mt-0.5"
                    :class="selectedIndex === item.globalIndex ? 'text-brand-100' : 'text-gray-400'"
                  >
                    {{ item.description }}
                  </p>
                </div>
                <div v-if="selectedIndex === item.globalIndex" class="text-[10px] font-black uppercase tracking-widest opacity-60">
                  Enter
                </div>
              </button>
            </div>
          </div>
        </div>

        <!-- Empty State -->
        <div v-else-if="query" class="p-12 text-center">
          <div class="w-16 h-16 bg-gray-50 dark:bg-gray-900 rounded-full flex items-center justify-center mx-auto mb-4">
            <SearchIcon class="w-8 h-8 text-gray-300" />
          </div>
          <p class="text-gray-800 dark:text-white font-bold">Sin resultados para "{{ query }}"</p>
          <p class="text-gray-500 text-sm mt-1">Intenta con términos más generales como el nombre del buque o número de marea.</p>
        </div>

        <!-- Shortcuts Hint -->
        <div class="p-4 bg-gray-50 dark:bg-gray-900/50 border-t border-gray-100 dark:border-gray-800 flex items-center gap-6 justify-center">
          <div class="flex items-center gap-2 text-[10px] font-bold text-gray-400">
            <span class="px-1.5 py-0.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded shadow-sm">↑↓</span>
            Navegar
          </div>
          <div class="flex items-center gap-2 text-[10px] font-bold text-gray-400">
            <span class="px-1.5 py-0.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded shadow-sm">Enter</span>
            Seleccionar
          </div>
          <div class="flex items-center gap-2 text-[10px] font-bold text-gray-400">
            <span class="px-1.5 py-0.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded shadow-sm">ESC</span>
            Cerrar
          </div>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import { 
  SearchIcon, 
  ShipIcon, 
  MapPinIcon, 
  DocsIcon, 
  PlusIcon,
  LayoutDashboardIcon,
  UserCircleIcon,
  SettingsIcon
} from '@/icons'

const router = useRouter()
const isOpen = ref(false)
const query = ref('')
const selectedIndex = ref(0)
const searchInput = ref<HTMLInputElement | null>(null)
const itemRefs = ref<any[]>([])

const setItemRef = (el: any, index: number) => {
  if (el) itemRefs.value[index] = el
}

// Mock Items Database
const items = [
  // Navigation
  { id: 'nav-dashboard', type: 'NAV', title: 'Panel de Control', description: 'Vista general del sistema', icon: LayoutDashboardIcon, path: '/' },
  { id: 'nav-operativo', type: 'NAV', title: 'Panel Operativo', description: 'Monitoreo de mareas activas', icon: ShipIcon, path: '/mareas/dashboard' },
  { id: 'nav-usuarios', type: 'NAV', title: 'Gestión de Usuarios', description: 'Administración de accesos y roles', icon: UserCircleIcon, path: '/admin/users' },
  
  // Tides (Mocked)
  { id: 'marea-1', type: 'MAREA', title: 'BP ARGENTINO II (MA-24-011)', description: 'Navegando - Merluza Hubbsi', icon: ShipIcon, path: '/mareas/detalle/1' },
  { id: 'marea-2', type: 'MAREA', title: 'BP PESCADOR I (MA-24-015)', description: 'Esperando Zarpada - Langostino', icon: ShipIcon, path: '/mareas/detalle/2' },
  { id: 'marea-3', type: 'MAREA', title: 'BP MARLIN (MA-24-018)', description: 'Bloqueada - Calamar', icon: ShipIcon, path: '/mareas/detalle/3' },

  // Actions
  { id: 'action-new', type: 'ACTION', title: 'Registrar Nueva Marea', description: 'Creación de designación y observador', icon: PlusIcon, action: () => router.push('/mareas/nueva') },
  { id: 'action-arribo', type: 'ACTION', title: 'Registrar Arribo...', description: 'Cierre de etapa operativa', icon: MapPinIcon, action: () => router.push('/mareas/dashboard') },
  { id: 'action-settings', type: 'ACTION', title: 'Ajustes del Sistema', description: 'Configuración global', icon: SettingsIcon, path: '/admin/settings' },
]

const filteredItems = computed(() => {
  if (!query.value) return items.slice(0, 5) // Show some defaults
  const q = query.value.toLowerCase()
  return items.filter(i => 
    i.title.toLowerCase().includes(q) || 
    i.description.toLowerCase().includes(q)
  )
})

const groupedItems = computed(() => {
  const result: any[] = []
  let globalIndex = 0
  
  const groups = [
    { name: 'Navegación', type: 'NAV' },
    { name: 'Mareas Recientes', type: 'MAREA' },
    { name: 'Acciones Rápidas', type: 'ACTION' }
  ]

  groups.forEach(group => {
    const groupItems = filteredItems.value.filter(i => i.type === group.type)
    if (groupItems.length > 0) {
      result.push({
        name: group.name,
        items: groupItems.map(i => ({ ...i, globalIndex: globalIndex++ }))
      })
    }
  })

  return result
})

const totalItems = computed(() => filteredItems.value.length)

const open = () => {
  isOpen.value = true
  query.value = ''
  selectedIndex.value = 0
  nextTick(() => {
    searchInput.value?.focus()
  })
}

const close = () => {
  isOpen.value = false
}

const moveDown = () => {
  selectedIndex.value = (selectedIndex.value + 1) % totalItems.value
  scrollIntoView()
}

const moveUp = () => {
  selectedIndex.value = (selectedIndex.value - 1 + totalItems.value) % totalItems.value
  scrollIntoView()
}

const scrollIntoView = () => {
  nextTick(() => {
    itemRefs.value[selectedIndex.value]?.scrollIntoView({ block: 'nearest' })
  })
}

const selectItem = () => {
  const item = filteredItems.value[selectedIndex.value]
  if (!item) return

  close()
  if (item.action) {
    item.action()
  } else if (item.path) {
    router.push(item.path)
  }
}

const handleKeydown = (e: KeyboardEvent) => {
  if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
    e.preventDefault()
    open()
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})

// Watch for query changes to reset selection
watch(query, () => {
  selectedIndex.value = 0
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
  background: #e2e8f0;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}
</style>
