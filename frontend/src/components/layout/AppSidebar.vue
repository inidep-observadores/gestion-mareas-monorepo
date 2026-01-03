<template>
  <aside
    :class="[
      'fixed mt-16 flex flex-col lg:mt-0 top-0 px-5 left-0 bg-white dark:bg-gray-900 dark:border-gray-800 text-gray-900 h-screen transition-all duration-300 ease-in-out z-99999 border-r border-gray-200',
      {
        'lg:w-[290px]': isExpanded || isMobileOpen || isHovered,
        'lg:w-[90px]': !isExpanded && !isHovered,
        'translate-x-0 w-[290px]': isMobileOpen,
        '-translate-x-full': !isMobileOpen,
        'lg:translate-x-0': true,
      },
    ]"
    @mouseenter="!isExpanded && (isHovered = true)"
    @mouseleave="isHovered = false"
  >
    <div
      :class="[
        'py-8 flex items-center gap-3',
        !isExpanded && !isHovered ? 'lg:justify-center' : 'justify-start',
      ]"
    >
      <router-link :to="{ name: 'Dashboard' }" class="flex items-center gap-3">
        <div
          class="w-10 h-10 rounded-xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center flex-shrink-0"
        >
          <WaveIcon class="w-6 h-6 text-white" />
        </div>
        <div v-if="isExpanded || isHovered || isMobileOpen" class="flex flex-col">
          <span class="text-lg font-bold text-gray-800 dark:text-white leading-tight"
            >Gestión de</span
          >
          <span class="text-lg font-bold text-blue-600 dark:text-blue-400 leading-tight"
            >Mareas</span
          >
        </div>
      </router-link>
    </div>

    <!-- Year Selector -->
    <div
      :class="[
        'mb-6 px-1 transition-all duration-300',
        !isExpanded && !isHovered ? 'lg:opacity-0 lg:h-0 overflow-hidden' : 'opacity-100',
      ]"
    >
      <div
        class="flex flex-col gap-1.5 p-3 rounded-xl bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-700/50"
      >
        <label class="text-[10px] font-bold uppercase tracking-wider text-gray-400 dark:text-gray-500">
          Año Operativo
        </label>
        <div class="relative flex items-center group">
          <CalenderIcon class="absolute left-0 w-4 h-4 text-gray-400 group-hover:text-blue-500 transition-colors" />
          <select
            v-model="configStore.selectedYear"
            class="w-full bg-transparent border-none text-sm font-semibold text-gray-700 dark:text-gray-200 focus:ring-0 pl-6 pr-2 appearance-none cursor-pointer"
          >
            <option v-for="year in availableYears" :key="year" :value="year" class="dark:bg-gray-800">
              {{ year }}
            </option>
          </select>
          <span class="absolute right-0 pointer-events-none text-gray-400">
            <svg class="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </span>
        </div>
      </div>
    </div>
    <div class="flex flex-col flex-1 overflow-y-auto duration-300 ease-linear no-scrollbar">
      <nav class="mb-6">
        <div class="flex flex-col gap-4">
          <div v-for="(menuGroup, groupIndex) in navigationGroups" :key="groupIndex">
            <h2
              :class="[
                'mb-4 text-xs uppercase flex leading-[20px] text-gray-400',
                !isExpanded && !isHovered ? 'lg:justify-center' : 'justify-start',
              ]"
            >
              <template v-if="isExpanded || isHovered || isMobileOpen">
                {{ menuGroup.title }}
              </template>
              <HorizontalDots v-else />
            </h2>
            <ul class="flex flex-col gap-4">
              <li v-for="item in menuGroup.items" :key="item.name">
                <router-link
                  :to="item.to"
                  :class="[
                    'menu-item group',
                    {
                      'menu-item-active': isActive(item),
                      'menu-item-inactive': !isActive(item),
                    },
                  ]"
                >
                  <span
                    :class="[
                      isActive(item) ? 'menu-item-icon-active' : 'menu-item-icon-inactive',
                    ]"
                  >
                    <component :is="item.icon" />
                  </span>
                  <span v-if="isExpanded || isHovered || isMobileOpen" class="menu-item-text">{{
                    item.name
                  }}</span>
                </router-link>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </div>

    <!-- Sticky Footer -->
    <div class="mt-auto py-6 border-t border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900">
      <nav>
        <ul class="flex flex-col gap-4">
          <li v-for="item in systemGroups.items" :key="item.name">
            <template v-if="item.name === 'Cerrar Sesión'">
              <button
                @click="handleItemClick(item, $event)"
                :class="[
                  'menu-item group w-full text-left',
                  isActive(item) ? 'menu-item-active' : 'menu-item-inactive',
                ]"
              >
                <span
                  :class="[
                    isActive(item) ? 'menu-item-icon-active' : 'menu-item-icon-inactive',
                  ]"
                >
                  <component :is="item.icon" />
                </span>
                <span v-if="isExpanded || isHovered || isMobileOpen" class="menu-item-text">{{
                  item.name
                }}</span>
              </button>
            </template>
          </li>
        </ul>
      </nav>
    </div>
  </aside>
</template>

<script setup lang="ts">
import { computed, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  HomeIcon,
  LogoutIcon,
  HorizontalDots,
  MailBox,
  LayoutDashboardIcon,
  BarChartIcon,
  CalenderIcon,
  GridIcon,
  WaveIcon,
  MapPinIcon,
  ShieldIcon,
} from '../../icons'
import { useSidebar } from '@/composables/useSidebar'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useConfigStore } from '@/modules/shared/stores/config.store'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const configStore = useConfigStore()

const currentYear = new Date().getFullYear()
const availableYears = Array.from({ length: 5 }, (_, i) => currentYear - 2 + i)

const { isExpanded, isMobileOpen, isHovered } = useSidebar()

const isAdmin = computed(() => authStore.user?.roles.includes('admin'))
const isCoordinator = computed(() => authStore.user?.roles.includes('coordinador'))

const navigationGroups = computed(() => {
  const groups = [
    {
      title: 'Menú Principal',
      items: [
        {
          icon: HomeIcon,
          name: 'Inicio',
          to: { name: 'Dashboard' },
        },
      ],
    },
    {
      title: 'Gestión de Mareas',
      items: [
        {
          icon: MailBox,
          name: 'Bandeja de Entrada',
          to: { name: 'MareasInbox' },
        },
        {
          icon: LayoutDashboardIcon,
          name: 'Panel Operativo',
          to: { name: 'MareasDashboard' },
        },
        {
          icon: GridIcon,
          name: 'Flujo de Trabajo',
          to: { name: 'MareasWorkflow' },
        },
        {
          icon: MapPinIcon,
          name: 'Mapa de Recorridos',
          to: { name: 'MareasMonitor' },
        },
        {
          icon: CalenderIcon,
          name: 'Calendario',
          to: { name: 'MareasCalendar' },
        },
        ...((isAdmin.value || isCoordinator.value)
          ? [
              {
                icon: BarChartIcon,
                name: 'Estadísticas',
                to: { name: 'MareasStats' },
              },
            ]
          : []),
      ],
    },
  ]

  if (isAdmin.value) {
    groups.push({
      title: 'Sistema',
      items: [
        {
          icon: ShieldIcon,
          name: 'Administración',
          to: { name: 'AdminUsers' },
        },
      ],
    })
  }

  return groups
})

const systemGroups = computed(() => ({
  title: 'Sistema',
  items: [
    {
      icon: LogoutIcon,
      name: 'Cerrar Sesión',
      to: { name: 'Signin' },
    },
  ],
}))

const isActive = (item: { to?: { name?: string }; path?: string }) => {
  if (item.to && 'name' in item.to) {
    return route.name === item.to.name
  }

  if (item.path) {
    return route.path === item.path
  }

  return false
}

const handleItemClick = async (item: any, event: Event) => {
  if (item.name === 'Cerrar Sesión') {
    event.preventDefault()
    await authStore.logout()
    router.push({ name: 'Signin' })
  }
}

// Refresh current view when operating year changes so dashboards y consultas se recalculen
watch(
  () => configStore.selectedYear,
  () => {
    router.go(0)
  }
)
</script>
