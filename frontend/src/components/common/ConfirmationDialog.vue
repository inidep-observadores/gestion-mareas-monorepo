<template>
    <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div class="absolute inset-0 bg-gray-950/40 backdrop-blur-sm" @click="$emit('close')"></div>
      <div class="bg-white dark:bg-gray-900 rounded-2xl p-8 max-w-md w-full shadow-2xl relative animate-in fade-in zoom-in-95 duration-300">
        <h3 class="text-xl font-bold text-gray-800 dark:text-white mb-2">{{ title }}</h3>
        <p class="text-gray-500 text-sm leading-relaxed mb-8">
          {{ message }}
        </p>
        <div class="grid grid-cols-2 gap-4">
          <button 
            @click="$emit('close')"
            class="px-6 py-3.5 bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-xl text-sm font-bold uppercase tracking-wider transition-all"
          >
            {{ cancelText }}
          </button>
          <button 
            @click="$emit('confirm')"
            :class="[
                'px-6 py-3.5 text-white rounded-xl text-sm font-bold uppercase tracking-wider shadow-lg transition-all',
                confirmButtonClass
            ]"
          >
            {{ confirmText }}
          </button>
        </div>
      </div>
    </div>
</template>

<script setup lang="ts">
defineProps({
    show: { type: Boolean, required: true },
    title: { type: String, default: 'Confirmación' },
    message: { type: String, default: '¿Está seguro de continuar?' },
    confirmText: { type: String, default: 'Confirmar' },
    cancelText: { type: String, default: 'Cancelar' },
    confirmButtonClass: { type: String, default: 'bg-red-500 hover:bg-red-600 shadow-red-500/20' }
})

defineEmits(['close', 'confirm'])
</script>
