<template>
  <div v-if="show" class="relative z-50" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <!-- Backdrop -->
    <div 
        :class="[
          'fixed inset-0 transition-opacity',
          variant === 'danger' 
            ? 'bg-red-950/40 backdrop-blur-md' 
            : variant === 'glass'
              ? 'bg-gray-950/40 backdrop-blur-sm'
              : 'bg-gray-500 bg-opacity-75'
        ]" 
        @click="emit('close')"
    ></div>

    <div 
      class="fixed inset-0 z-10 w-screen overflow-y-auto transition-all duration-300 ease-in-out"
      :class="[
        isSidebarAware ? (isExpanded || isHovered ? 'lg:pl-[290px]' : 'lg:pl-[90px]') : ''
      ]"
    >
      <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
        <div
          :class="[
              'relative transform overflow-hidden rounded-xl bg-white text-left shadow-xl transition-all w-full sm:my-8 dark:bg-gray-800',
              variant === 'danger' ? 'border border-red-200/50 dark:border-red-900/50' : '',
              maxWidthClass
          ]"
          @click.stop
        >
          <div 
            :class="[
              'px-4 pb-4 pt-5 sm:p-6',
              variant === 'danger' ? 'bg-red-50/30 dark:bg-red-950/20' : 'bg-white dark:bg-gray-800'
            ]"
          >
            <!-- Header -->
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-lg font-medium leading-6 text-gray-900 dark:text-white" id="modal-title">
                <slot name="title">{{ title }}</slot>
              </h3>
              <button
                @click="emit('close')"
                class="text-gray-400 hover:text-gray-500 focus:outline-none"
              >
                <span class="sr-only">Cerrar</span>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            <!-- Content -->
            <slot></slot>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useSidebar } from '@/composables/useSidebar'

const props = withDefaults(defineProps<{
  show: boolean;
  title?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl' | '5xl' | '6xl' | '7xl' | 'full';
  isSidebarAware?: boolean;
  variant?: 'default' | 'danger' | 'glass';
}>(), {
  isSidebarAware: true,
  maxWidth: 'lg',
  variant: 'default'
});

const emit = defineEmits(['close']);

const { isExpanded, isHovered } = useSidebar()

const maxWidthClass = computed(() => {
    switch (props.maxWidth) {
        case 'sm': return 'sm:max-w-sm';
        case 'md': return 'sm:max-w-md';
        case 'lg': return 'sm:max-w-lg';
        case 'xl': return 'sm:max-w-xl';
        case '2xl': return 'sm:max-w-2xl';
        case '3xl': return 'sm:max-w-3xl';
        case '4xl': return 'sm:max-w-4xl';
        case '5xl': return 'sm:max-w-5xl';
        case '6xl': return 'sm:max-w-6xl';
        case '7xl': return 'sm:max-w-7xl';
        case 'full': return 'sm:max-w-full';
        default: return 'sm:max-w-lg';
    }
});
</script>
