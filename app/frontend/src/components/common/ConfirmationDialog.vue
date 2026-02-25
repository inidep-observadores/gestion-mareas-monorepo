<template>
  <Teleport to="body">
    <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4 transition-all duration-300 ease-in-out"
      :class="[
        isSidebarAware ? (isExpanded || isHovered ? 'lg:pl-[18.125rem]' : 'lg:pl-[5.625rem]') : ''
      ]"
    >
      <div class="absolute inset-0 bg-surface-muted/40 backdrop-blur-sm" @click="$emit('close')"></div>      <!-- Ventana de Diálogo -->
      <div 
        class="bg-surface relative w-full max-w-md mx-4 rounded-2xl shadow-2xl border border-border flex flex-col overflow-hidden animate-in zoom-in-95 fade-in duration-200"
        :class="{ 'md:ml-20': isSidebarAware }"
      >
        <div class="p-6">
          <h3 class="text-xl font-bold text-text mb-2">{{ title }}</h3>
          <p class="text-sm text-text-muted leading-relaxed font-medium mb-6">{{ message }}</p>
          
          <div v-if="$slots.default" class="mb-6">
            <slot />
          </div>

          <div v-if="$slots.footer">
            <slot name="footer" />
          </div>
          <div v-else class="grid grid-cols-2 gap-3">
            <button 
              @click="$emit('close')"
              class="px-4 py-2.5 bg-surface border border-border rounded-lg text-sm font-semibold text-text hover:bg-surface-muted transition-all active:scale-95"
            >
              {{ cancelText }}
            </button>
            <button 
              @click="$emit('confirm')"
              class="px-4 py-2.5 rounded-lg text-sm font-semibold text-white transition-all active:scale-95 shadow-lg flex items-center justify-center gap-2"
              :class="confirmButtonClass"
            >
              {{ confirmText }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { useSidebar } from '@/composables/useSidebar'

defineProps({
    show: { type: Boolean, required: true },
    title: { type: String, default: 'Confirmación' },
    message: { type: String, default: '¿Está seguro de continuar?' },
    confirmText: { type: String, default: 'Confirmar' },
    cancelText: { type: String, default: 'Volver' },
    confirmButtonClass: { type: String, default: 'bg-primary hover:bg-primary/90 shadow-primary/20' },
    isSidebarAware: { type: Boolean, default: true }
})

const { isExpanded, isHovered } = useSidebar()

defineEmits(['close', 'confirm'])
</script>
