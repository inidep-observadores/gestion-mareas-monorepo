<template>
  <div v-if="show" class="relative z-50" aria-labelledby="modal-title" role="dialog" aria-modal="true">
    <!-- Backdrop -->
    <div 
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
        @click="emit('close')"
    ></div>

    <div class="fixed inset-0 z-10 w-screen overflow-y-auto">
      <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
        <div
          :class="[
              'relative transform overflow-hidden rounded-xl bg-white text-left shadow-xl transition-all w-full sm:my-8 dark:bg-gray-800',
              maxWidthClass
          ]"
          @click.stop
        >
          <div class="bg-white px-4 pb-4 pt-5 sm:p-6 dark:bg-gray-800">
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

const props = defineProps<{
  show: boolean;
  title?: string;
  maxWidth?: 'sm' | 'md' | 'lg' | 'xl' | '2xl' | '3xl' | '4xl' | '5xl' | '6xl' | '7xl' | 'full';
}>();

const emit = defineEmits(['close']);

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
