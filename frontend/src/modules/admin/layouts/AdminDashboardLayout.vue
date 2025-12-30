<template>
  <div class="min-h-screen xl:flex">
    <admin-sidebar />
    <Backdrop />
    <div
      class="flex-1 transition-all duration-300 ease-in-out"
      :class="[isExpanded || isHovered ? 'lg:ml-[290px]' : 'lg:ml-[90px]']"
    >
      <app-header />
      <div class="admin-layout-content p-4 mx-auto max-w-(--breakpoint-2xl) md:p-6">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script setup>
import AdminSidebar from '../components/AdminSidebar.vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import { useSidebar } from '@/composables/useSidebar'
import Backdrop from '@/components/layout/Backdrop.vue'
const { isExpanded, isHovered } = useSidebar()
</script>
