<template>
  <div class="flex flex-wrap items-center justify-between gap-3 mb-6">
    <h2 class="text-xl font-semibold text-gray-800 dark:text-white/90">
      {{ pageTitle }}
    </h2>

    <nav v-if="items && items.length > 0">
      <div class="breadcrumbs">
        <ul>
          <template v-for="(item, index) in items" :key="index">
            <li>
              <router-link v-if="item.to" :to="item.to" class="inline-flex items-center gap-1.5">
                <component v-if="item.icon" :is="item.icon" class="w-4 h-4" />
                {{ item.label }}
              </router-link>
              <span v-else :aria-current="index === items.length - 1 ? 'page' : undefined">
                <component v-if="item.icon" :is="item.icon" class="w-4 h-4 inline-block mr-1" />
                {{ item.label }}
              </span>
            </li>
            <li v-if="index < items.length - 1" class="breadcrumbs-separator rtl:rotate-180">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M8.25 4.5l7.5 7.5-7.5 7.5"
                />
              </svg>
            </li>
          </template>
        </ul>
      </div>
    </nav>
  </div>
</template>

<script setup lang="ts">
import type { Component } from 'vue'

export interface BreadcrumbItem {
  label: string
  to?: string
  icon?: Component
}

export interface BreadcrumbProps {
  pageTitle: string
  items?: BreadcrumbItem[]
}

withDefaults(defineProps<BreadcrumbProps>(), {
  items: () => [],
})
</script>

<style scoped>
@import 'tailwindcss/theme';

.breadcrumbs {
  @apply text-sm;
}

.breadcrumbs ul {
  @apply flex items-center gap-2;
}

.breadcrumbs li {
  @apply flex items-center;
}

.breadcrumbs a {
  @apply text-text-muted transition-colors;

  &:hover {
    @apply text-primary;
  }
}

.breadcrumbs span[aria-current='page'] {
  @apply text-text font-medium;
}

.breadcrumbs-separator {
  @apply text-text-muted/40;
}
</style>
