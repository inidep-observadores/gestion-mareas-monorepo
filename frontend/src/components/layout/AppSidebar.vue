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
      <router-link to="/" class="flex items-center gap-3">
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
    <div class="flex flex-col overflow-y-auto duration-300 ease-linear no-scrollbar">
      <nav class="mb-6">
        <div class="flex flex-col gap-4">
          <div v-for="(menuGroup, groupIndex) in menuGroups" :key="groupIndex">
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
                  :to="item.path"
                  :class="[
                    'menu-item group',
                    {
                      'menu-item-active': isActive(item.path),
                      'menu-item-inactive': !isActive(item.path),
                    },
                  ]"
                >
                  <span
                    :class="[
                      isActive(item.path) ? 'menu-item-icon-active' : 'menu-item-icon-inactive',
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
  </aside>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router'
import {
  HomeIcon,
  LogoutIcon,
  HorizontalDots,
  MailBox,
  LayoutDashboardIcon,
  TableIcon,
  BarChartIcon,
  CalenderIcon,
  GridIcon,
  WaveIcon,
} from '../../icons'
import { useSidebar } from '@/composables/useSidebar'

const route = useRoute()

const { isExpanded, isMobileOpen, isHovered } = useSidebar()

const menuGroups = [
  {
    title: 'Menú Principal',
    items: [
      {
        icon: HomeIcon,
        name: 'Inicio',
        path: '/',
      },
    ],
  },
  {
    title: 'Gestión de Mareas',
    items: [
      {
        icon: MailBox,
        name: 'Bandeja de Entrada',
        path: '/mareas/inbox',
      },
      {
        icon: LayoutDashboardIcon,
        name: 'Panel Operativo',
        path: '/mareas/dashboard',
      },
      {
        icon: GridIcon,
        name: 'Flujo de Trabajo',
        path: '/mareas/workflow',
      },
      {
        icon: CalenderIcon,
        name: 'Calendario',
        path: '/mareas/calendar',
      },
      {
        icon: BarChartIcon,
        name: 'Estadísticas',
        path: '/mareas/stats',
      },
    ],
  },
  {
    title: 'Sistema',
    items: [
      {
        icon: LogoutIcon,
        name: 'Cerrar Sesión',
        path: '/signin',
      },
    ],
  },
]

const isActive = (path: string) => route.path === path
</script>
