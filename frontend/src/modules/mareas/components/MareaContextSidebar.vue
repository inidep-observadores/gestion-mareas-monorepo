<template>
  <Transition
    enter-active-class="transition duration-300 ease-out"
    enter-from-class="translate-x-full opacity-0"
    enter-to-class="translate-x-0 opacity-100"
    leave-active-class="transition duration-200 ease-in"
    leave-from-class="translate-x-0 opacity-100"
    leave-to-class="translate-x-full opacity-0"
  >
    <div
      v-if="isOpen && marea"
      class="fixed inset-y-0 right-0 w-[400px] bg-white dark:bg-gray-950 shadow-2xl z-[100000] border-l border-gray-200 dark:border-gray-800 flex flex-col"
    >
      <MareaContextDetailContent 
        :marea="marea"
        :context="context"
        :read-only="readOnly"
        @close="$emit('close')"
        @open-detalle="$emit('open-detalle')"
        @action="(key) => $emit('action', key)"
        @manage-alert="(alert) => $emit('manage-alert', alert)"
      />
    </div>
  </Transition>
  
  <!-- Backdrop -->
  <Transition
    enter-active-class="transition-opacity duration-300 ease-linear"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition-opacity duration-200 ease-linear"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div 
      v-if="isOpen" 
      @click="$emit('close')"
      class="fixed inset-0 bg-gray-900/40 dark:bg-black/60 backdrop-blur-sm z-[99999]"
    ></div>
  </Transition>
</template>

<script setup lang="ts">
import MareaContextDetailContent from './MareaContextDetailContent.vue'
import type { MareaContext } from '../services/mareas.service'

interface Props {
  isOpen: boolean
  marea: any | null
  context: MareaContext | null
  readOnly?: boolean
}

withDefaults(defineProps<Props>(), {
  readOnly: false
})

defineEmits(['close', 'open-detalle', 'action', 'manage-alert'])
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #e2e8f0;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #1e293b;
}
</style>
