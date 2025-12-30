<template>
  <div class="flex flex-col gap-6">
    <!-- Header -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div>
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">{{ title }}</h1>
        <p v-if="description" class="text-gray-500 dark:text-gray-400">{{ description }}</p>
      </div>
      <div class="flex items-center gap-2">
        <slot name="header-actions"></slot>
        <button
          v-if="buttonText"
          @click="$emit('create')"
          class="flex items-center justify-center gap-2 rounded-lg bg-brand-500 px-4 py-2.5 text-sm font-medium text-white shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 transition-colors w-full sm:w-auto"
        >
          <PlusIcon class="w-4 h-4" />
          {{ buttonText }}
        </button>
      </div>
    </div>

    <!-- Filters & Search -->
    <div class="p-4 sm:p-6 bg-white border border-gray-200 rounded-xl dark:bg-gray-800 dark:border-gray-700 shadow-sm">
      <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
        <div class="relative w-full max-w-sm">
          <div class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none">
            <SearchIcon class="w-5 h-5 text-gray-400" />
          </div>
          <input
            :value="search"
            @input="$emit('update:search', ($event.target as HTMLInputElement).value)"
            type="text"
            :placeholder="searchPlaceholder"
            class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent py-2 pl-10 pr-3 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
          />
        </div>
        <slot name="filters"></slot>
      </div>

      <!-- Desktop Table View -->
      <div class="hidden lg:block relative overflow-x-auto border border-gray-100 dark:border-gray-700 rounded-xl overflow-hidden">
        <table class="w-full text-sm text-left text-gray-500 dark:text-gray-400">
          <thead class="text-xs text-gray-700 uppercase bg-gray-50/50 dark:bg-gray-700/50 dark:text-gray-400 border-b border-gray-100 dark:border-gray-700">
            <tr>
              <slot name="table-header"></slot>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100 dark:divide-gray-700">
            <tr v-if="isLoading">
              <td :colspan="10" class="px-6 py-10 text-center">
                <div class="flex flex-col items-center gap-2">
                  <div class="w-6 h-6 border-2 border-brand-500 border-t-transparent rounded-full animate-spin"></div>
                  <span class="text-gray-500 dark:text-gray-400 font-medium">Cargando datos...</span>
                </div>
              </td>
            </tr>
            <tr v-else-if="items.length === 0">
              <td :colspan="10" class="px-6 py-10 text-center text-gray-500 dark:text-gray-400">
                No se encontraron registros.
              </td>
            </tr>
            <tr
              v-for="(item, index) in items"
              :key="index"
              class="bg-white dark:bg-gray-800 hover:bg-gray-50 dark:hover:bg-gray-700/30 transition-colors"
            >
              <slot name="table-row" :item="item"></slot>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Mobile/Tablet Card View -->
      <div class="lg:hidden space-y-4">
        <div v-if="isLoading" class="text-center py-10">
          <div class="flex flex-col items-center gap-2">
            <div class="w-6 h-6 border-2 border-brand-500 border-t-transparent rounded-full animate-spin"></div>
            <span class="text-gray-500 dark:text-gray-400 font-medium">Cargando...</span>
          </div>
        </div>
        <div v-else-if="items.length === 0" class="text-center py-10 text-gray-400">
          No se encontraron registros.
        </div>
        <div
          v-for="(item, index) in items"
          :key="index"
          class="bg-white dark:bg-gray-800 border border-gray-100 dark:border-gray-700 rounded-xl p-4 shadow-sm hover:shadow-md transition-shadow"
        >
          <slot name="card-item" :item="item"></slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { SearchIcon, PlusIcon } from '@/icons'

defineProps<{
  title: string
  description?: string
  items: any[]
  isLoading: boolean
  search: string
  searchPlaceholder?: string
  buttonText?: string
}>()

defineEmits(['update:search', 'create'])
</script>
