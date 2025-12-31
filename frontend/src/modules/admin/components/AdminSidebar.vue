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
      <router-link to="/admin" class="flex items-center gap-3">
        <div
          class="w-10 h-10 rounded-xl bg-gradient-to-br from-purple-600 to-indigo-600 flex items-center justify-center flex-shrink-0"
        >
          <ShieldIcon class="w-6 h-6 text-white" />
        </div>
        <div v-if="isExpanded || isHovered || isMobileOpen" class="flex flex-col">
          <span class="text-lg font-bold text-gray-800 dark:text-white leading-tight"
            >Panel de</span
          >
          <span class="text-lg font-bold text-purple-600 dark:text-purple-400 leading-tight"
            >Admin</span
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
                <template v-if="item.name === 'Volver al Sitio'">
                   <router-link
                    :to="item.path"
                    class="menu-item group menu-item-inactive"
                  >
                    <span class="menu-item-icon-inactive">
                      <component :is="item.icon" />
                    </span>
                    <span v-if="isExpanded || isHovered || isMobileOpen" class="menu-item-text">{{
                      item.name
                    }}</span>
                  </router-link>
                </template>
                <template v-else-if="item.name === 'Cerrar Sesión'">
                  <button
                    @click="handleItemClick(item, $event)"
                    :class="[
                      'menu-item group w-full text-left',
                      isActive(item.path) ? 'menu-item-active' : 'menu-item-inactive',
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
                  </button>
                </template>
                <router-link
                  v-else
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
import { useRoute, useRouter } from 'vue-router'
import {
  LogoutIcon,
  HorizontalDots,
  UserGroupIcon,
  UserCircleIcon,
  ShieldIcon,
  ArrowLeftIcon,
  ShipIcon
} from '@/icons'
import { useSidebar } from '@/composables/useSidebar'
import { useAuthStore } from '@/modules/auth/stores/auth.store'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

const { isExpanded, isMobileOpen, isHovered } = useSidebar()

const menuGroups = [
  {
    title: 'Gestión',
    items: [
      {
        icon: UserGroupIcon,
        name: 'Usuarios',
        path: '/admin/users',
      },
      {
        icon: UserCircleIcon,
        name: 'Observadores',
        path: '/admin/observadores',
      },
      {
        icon: ShipIcon,
        name: 'Buques',
        path: '/admin/buques',
      },
    ],
  },
  {
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
  },
]

const isActive = (path: string) => route.path === path

const handleItemClick = async (item: any, event: Event) => {
  if (item.name === 'Cerrar Sesión') {
    event.preventDefault()
    await authStore.logout()
    router.push({ name: 'Signin' })
  }
}
</script>
