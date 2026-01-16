<template>
  <div class="relative" ref="dropdownRef">
    <button
      class="flex items-center text-text"
      @click.prevent="toggleDropdown"
    >
      <span class="mr-3 overflow-hidden rounded-full h-11 w-11">
        <img :src="getFullImageUrl(user?.avatarUrl)" alt="User" class="object-cover w-full h-full"/>
      </span>

      <span class="block mr-1 font-medium text-theme-sm">{{ user?.fullName || 'Usuario' }}</span>

      <ChevronDownIcon :class="{ 'rotate-180': dropdownOpen }" />
    </button>

    <!-- Dropdown Start -->
    <div
      v-if="dropdownOpen"
      class="absolute right-0 mt-[17px] flex w-[260px] flex-col rounded-2xl border border-border bg-surface p-3 shadow-theme-lg"
    >
      <div class="px-3 py-2">
        <span class="block font-medium text-text text-theme-sm">
          {{ user?.fullName || 'Usuario' }}
        </span>
        <span class="mt-0.5 block text-theme-xs text-text-muted">
          {{ user?.email || '' }}
        </span>
      </div>

      <ul class="flex flex-col gap-1 pt-4 pb-3 border-b border-border">
        <li v-for="item in menuItems" :key="item.href">
          <router-link
            :to="item.href"
            class="flex items-center gap-3 px-3 py-2 font-medium text-text rounded-lg group text-theme-sm hover:bg-surface-muted"
          >
            <component
              :is="item.icon"
              class="text-text-muted group-hover:text-text"
            />
            {{ item.text }}
          </router-link>
        </li>
      </ul>
      <button
        @click="handleSignOut"
        class="flex w-full items-center gap-3 px-3 py-2 mt-3 font-medium text-text rounded-lg group text-theme-sm hover:bg-surface-muted text-left"
      >
        <LogoutIcon
          class="text-text-muted group-hover:text-text"
        />
        Cerrar sesión
      </button>
    </div>
    <!-- Dropdown End -->
  </div>
</template>

<script setup lang="ts">
import { UserCircleIcon, ChevronDownIcon, LogoutIcon, SettingsIcon, InfoCircleIcon } from '@/icons'
import { useRouter } from 'vue-router'
import { ref, onMounted, onUnmounted } from 'vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { storeToRefs } from 'pinia'
import { getFullImageUrl } from '@/helpers/image.helper'

const router = useRouter()
const authStore = useAuthStore()
const { user } = storeToRefs(authStore)

const dropdownOpen = ref(false)
const dropdownRef = ref<HTMLDivElement | null>(null)

const menuItems = [
  { href: '/profile', icon: UserCircleIcon, text: 'Editar perfil' },
  { href: '/preferences', icon: SettingsIcon, text: 'Preferencias' },
]

const toggleDropdown = () => {
  dropdownOpen.value = !dropdownOpen.value
}

const closeDropdown = () => {
  dropdownOpen.value = false
}

const handleSignOut = async () => {
  await authStore.logout()
  closeDropdown()
  router.push({ name: 'Signin' })
}

const handleClickOutside = (event: MouseEvent) => {
  const targetNode = event.target as Node | null
  if (dropdownRef.value && targetNode && !dropdownRef.value.contains(targetNode)) {
    closeDropdown()
  }
}

onMounted(() => {
  document.addEventListener('click', handleClickOutside)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside)
})
</script>
