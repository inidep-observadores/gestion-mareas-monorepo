<template>
  <aside
    :class="[
      'fixed mt-16 flex flex-col lg:mt-0 top-0 px-5 left-0 bg-surface text-text h-screen transition-all duration-300 ease-in-out z-99999 border-r border-border',
      {
        'lg:w-[18.125rem]': isExpanded || isMobileOpen || isHovered,
        'lg:w-[5.625rem]': !isExpanded && !isHovered,
        'translate-x-0 w-[18.125rem]': isMobileOpen,
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
          class="w-10 h-10 rounded-xl bg-linear-to-br from-primary to-info flex items-center justify-center flex-shrink-0"
        >
          <WaveIcon class="w-6 h-6 text-white" />
        </div>
        <div v-if="isExpanded || isHovered || isMobileOpen" class="flex flex-col">
          <span class="text-lg font-bold text-text leading-tight"
            >Gestión de</span
          >
          <span class="text-lg font-bold text-primary leading-tight"
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
        class="flex flex-col gap-1.5 p-3 rounded-xl bg-surface-muted/50 border border-border"
      >
        <label class="text-[10px] font-bold uppercase tracking-wider text-text-muted">
          Año Operativo
        </label>
        <div class="relative flex items-center group">
          <CalenderIcon class="absolute left-0 w-4 h-4 text-text-muted group-hover:text-primary transition-colors" />
          <select
            v-model="configStore.selectedYear"
            class="w-full bg-transparent border-none text-sm font-semibold text-text focus:ring-0 pl-6 pr-2 appearance-none cursor-pointer"
          >
            <option v-for="year in availableYears" :key="year" :value="year" class="bg-surface">
              {{ year }}
            </option>
          </select>
          <span class="absolute right-0 pointer-events-none text-text-muted">
            <svg class="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
            </svg>
          </span>
        </div>
      </div>
    </div>
    <div class="flex flex-col flex-1 overflow-y-auto duration-300 ease-linear no-scrollbar">
      <nav class="mb-6" @click="closeMobileSidebar">
        <div class="flex flex-col gap-4">
          <div v-for="(menuGroup, groupIndex) in navigationGroups" :key="groupIndex">
            <h2
              :class="[
                'mb-4 text-xs uppercase flex leading-5 text-text-muted',
                !isExpanded && !isHovered ? 'lg:justify-center' : 'justify-start',
              ]"
            >
              <template v-if="isExpanded || isHovered || isMobileOpen">
                {{ menuGroup.title }}
              </template>
              <HorizontalDots v-else />
            </h2>
            <ul class="flex flex-col gap-4">
              <template v-for="item in menuGroup.items" :key="item.name">
                <li v-if="item.show !== false">
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
              </template>
            </ul>
          </div>
        </div>
      </nav>
    </div>

    <div class="mt-auto py-6 border-t border-border bg-surface">
      <nav @click="closeMobileSidebar">
        <ul class="flex flex-col gap-4">
          <template v-for="item in systemGroups.items" :key="item.name">
            <li v-if="item.show !== false">
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
          </template>
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

import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const configStore = useConfigStore()

const currentYear = new Date().getFullYear()
const availableYears = Array.from({ length: 5 }, (_, i) => currentYear - 2 + i)

const { isExpanded, isMobileOpen, isHovered } = useSidebar()

const closeMobileSidebar = () => {
  if (isMobileOpen.value) {
    isMobileOpen.value = false
  }
}

const isAdmin = computed(() => authStore.user?.roles.includes(ValidRoles.admin))
const isCoordinator = computed(() => authStore.user?.roles.includes(ValidRoles.coordinador))

const navigationGroups = computed(() => {
  const groups = [
    {
      title: 'Menú Principal',
      items: [
        {
          icon: HomeIcon,
          name: 'Centro de Comando',
          to: { name: 'Dashboard' },
          show: true,
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
          show: true,
        },
        {
          icon: LayoutDashboardIcon,
          name: 'Panel Operativo',
          to: { name: 'MareasDashboard' },
          show: true,
        },
        {
          icon: GridIcon,
          name: 'Flujo de Trabajo',
          to: { name: 'MareasWorkflow' },
          show: isAdmin.value,
        },
        {
          icon: MapPinIcon,
          name: 'Mapa de Recorridos',
          to: { name: 'MareasMonitor' },
          show: isAdmin.value,
        },
        {
          icon: CalenderIcon,
          name: 'Calendario',
          to: { name: 'MareasCalendar' },
          show: true,
        },
        {
          icon: BarChartIcon,
          name: 'Estadísticas',
          to: { name: 'MareasStats' },
          show: isAdmin.value || isCoordinator.value,
        },
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
          show: true,
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
      show: true,
    },
  ],
}))


type MenuItem = { name: string; to?: { name?: string }; path?: string }

const isActive = (item: MenuItem) => {
  if (item.to && 'name' in item.to) {
    return route.name === item.to.name
  }

  if (item.path) {
    return route.path === item.path
  }

  return false
}

const handleItemClick = async (item: MenuItem, event: Event) => {
  if (item.name === 'Cerrar Sesión') {
    event.preventDefault()
    await authStore.logout()
    router.push({ name: 'Signin' })
  }
}

// Refresh current view when operating year changes so dashboards y consultas se recalculen
watch(
  () => route.fullPath,
  () => {
    if (isMobileOpen.value) {
      isMobileOpen.value = false
    }
  }
)

watch(
  () => configStore.selectedYear,
  () => {
    router.go(0)
  }
)
</script>
