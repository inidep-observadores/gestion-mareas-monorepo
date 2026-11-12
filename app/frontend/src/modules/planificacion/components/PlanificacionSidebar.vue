<template>
  <aside :class="[
    'fixed mt-16 flex flex-col lg:mt-0 top-0 px-5 left-0 bg-surface text-text h-screen transition-all duration-300 ease-in-out z-50 border-r border-border',
    {
      'lg:w-[18.125rem]': isExpanded || isMobileOpen || isHovered,
      'lg:w-[5.625rem]': !isExpanded && !isHovered,
      'translate-x-0 w-[18.125rem]': isMobileOpen,
      '-translate-x-full': !isMobileOpen,
      'lg:translate-x-0': true,
    },
  ]" @mouseenter="!isExpanded && (isHovered = true)" @mouseleave="isHovered = false">
    <div :class="[
      'py-8 flex items-center gap-3',
      !isExpanded && !isHovered ? 'lg:justify-center' : 'justify-start',
    ]">
      <router-link to="/planificacion/dashboard" class="flex items-center gap-3">
        <div
          class="w-10 h-10 rounded-xl bg-gradient-to-br from-info to-primary flex items-center justify-center flex-shrink-0">
          <CalenderIcon class="w-6 h-6 text-primary-fg" />
        </div>
        <div v-if="isExpanded || isHovered || isMobileOpen" class="flex flex-col">
          <span class="text-lg font-bold text-text leading-tight">Módulo de</span>
          <span class="text-lg font-bold text-info leading-tight">Planificación</span>
        </div>
      </router-link>
    </div>

    <!-- Year Selector -->
    <div :class="[
      'mb-6 px-1 transition-all duration-300',
      !isExpanded && !isHovered ? 'lg:opacity-0 lg:h-0 overflow-hidden' : 'opacity-100',
    ]">
      <div class="flex flex-col gap-1.5 p-3 rounded-xl bg-surface-muted/50 border border-border">
        <label class="text-[10px] font-bold uppercase tracking-wider text-text-muted">
          Año Operativo
        </label>
        <div class="relative flex items-center group">
          <div class="absolute left-0 pl-3 flex items-center pointer-events-none text-text-muted group-hover:text-primary transition-colors">
            <CalenderIcon class="w-4 h-4" />
          </div>
          <select v-model="configStore.selectedYear"
            class="w-full pl-10 pr-10 py-2.5 bg-background border border-border rounded-lg text-sm font-semibold text-text outline-none focus:border-primary transition-all appearance-none cursor-pointer">
            <option v-for="option in availableYearsOptions" :key="option.value" :value="option.value" class="bg-surface text-text">
              {{ option.label }}
            </option>
          </select>
          <span class="absolute right-0 pr-3 flex items-center pointer-events-none text-text-muted group-hover:text-primary transition-colors">
            <svg class="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd"
                d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                clip-rule="evenodd" />
            </svg>
          </span>
        </div>
      </div>
    </div>
    
    <div class="flex flex-col flex-1 overflow-y-auto duration-300 ease-linear custom-scrollbar">
      <nav class="mb-6" @click="closeMobileSidebar">
        <div class="flex flex-col gap-4">
          <div v-for="(menuGroup, groupIndex) in navigationGroups" :key="groupIndex">
            <h2 :class="[
              'mb-4 text-xs uppercase flex leading-[20px] text-text-muted',
              !isExpanded && !isHovered ? 'lg:justify-center' : 'justify-start',
            ]">
              <template v-if="isExpanded || isHovered || isMobileOpen">
                {{ menuGroup.title }}
              </template>
              <HorizontalDots v-else />
            </h2>
            <ul class="flex flex-col gap-4">
              <li v-for="item in menuGroup.items" :key="item.name">
                <router-link :to="item.path" :class="[
                  'menu-item group',
                  {
                    'menu-item-active': isActive(item.path),
                    'menu-item-inactive': !isActive(item.path),
                  },
                ]">
                  <span :class="[
                    isActive(item.path) ? 'menu-item-icon-active' : 'menu-item-icon-inactive',
                  ]">
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
    <div class="mt-auto py-6 border-t border-border bg-surface">
      <nav @click="closeMobileSidebar">
        <ul class="flex flex-col gap-4">
          <li v-for="item in systemGroups.items" :key="item.name">
            <template v-if="item.name === 'Volver al Sitio'">
              <router-link :to="item.path" class="menu-item group menu-item-inactive">
                <span class="menu-item-icon-inactive">
                  <component :is="item.icon" />
                </span>
                <span v-if="isExpanded || isHovered || isMobileOpen" class="menu-item-text">{{
                  item.name
                  }}</span>
              </router-link>
            </template>
            <template v-else-if="item.name === 'Cerrar Sesión'">
              <button @click="handleItemClick(item, $event)" :class="[
                'menu-item group w-full text-left',
                isActive(item.path) ? 'menu-item-active' : 'menu-item-inactive',
              ]">
                <span :class="[
                  isActive(item.path) ? 'menu-item-icon-active' : 'menu-item-icon-inactive',
                ]">
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
import { useRoute, useRouter } from 'vue-router'
import { ref, watch, computed } from 'vue'
import {
  LogoutIcon,
  HorizontalDots,
  ArrowLeftIcon,
  LayoutDashboardIcon,
  CalenderIcon,
  ShipIcon,
  UserGroupIcon,
} from '@/icons'
import { useSidebar } from '@/composables/useSidebar'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { useConfigStore } from '@/modules/shared/stores/config.store'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const configStore = useConfigStore()

const { isExpanded, isMobileOpen, isHovered } = useSidebar()

const closeMobileSidebar = () => {
  if (isMobileOpen.value) {
    isMobileOpen.value = false
  }
}

const currentYear = new Date().getFullYear();
const minYear = 2024
const availableYearsOptions = computed(() => {
  const years = []
  for (let y = currentYear; y >= minYear; y--) {
    years.push({ label: y.toString(), value: y })
  }
  return years
})

const navigationGroups = [
  {
    title: 'Panel',
    items: [
      {
        icon: LayoutDashboardIcon,
        name: 'Dashboard',
        path: '/planificacion/dashboard',
      },
      {
        icon: ShipIcon,
        name: 'Req. de Cobertura',
        path: '/planificacion/requerimientos',
      },
      {
        icon: UserGroupIcon,
        name: 'Matriz Experiencia',
        path: '/planificacion/experiencia-observadores',
      },
      {
        icon: CalenderIcon,
        name: 'Simulador de Cobertura',
        path: '/planificacion/simulador',
      },
    ],
  },
]

const systemGroups = {
  title: 'Sistema',
  items: [
    {
      icon: ArrowLeftIcon,
      name: 'Volver al Sitio',
      path: '/',
    },
    {
      icon: LogoutIcon,
      name: 'Cerrar Sesión',
      path: '/signin',
    },
  ],
}

const isActive = (path: string) => route.path === path

const handleItemClick = async (item: any, event: Event) => {
  if (item.name === 'Cerrar Sesión') {
    event.preventDefault()
    await authStore.logout()
    router.push({ name: 'Signin' })
  }
}

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
