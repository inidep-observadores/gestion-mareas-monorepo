<template>
    <div v-if="show" 
        class="fixed inset-0 z-[110] flex items-center justify-center p-4 transition-all duration-300 ease-in-out"
        :class="[
            isSidebarAware ? (isExpanded || isHovered ? 'lg:pl-[18.125rem]' : 'lg:pl-[5.625rem]') : ''
        ]"
    >
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-gray-950/20 backdrop-blur-[2px]" @click="$emit('close')"></div>
        
        <!-- Content -->
        <div class="bg-white dark:bg-gray-900 rounded-2xl p-8 shadow-2xl flex flex-col items-center gap-4 animate-in fade-in zoom-in-95 duration-300 border border-gray-200 dark:border-gray-800 relative">
            <div class="relative">
                <div class="w-16 h-16 border-4 border-brand-100 dark:border-brand-900/30 rounded-full"></div>
                <div class="absolute inset-0 w-16 h-16 border-4 border-brand-500 rounded-full border-t-transparent animate-spin"></div>
            </div>
            <div class="text-center">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white">{{ title }}</h3>
                <p v-if="message" class="text-sm text-gray-500 mt-1 max-w-[250px]">{{ message }}</p>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { useSidebar } from '@/composables/useSidebar'

defineProps({
    show: { type: Boolean, required: true },
    title: { type: String, default: 'Procesando...' },
    message: { type: String, default: 'Por favor espera un momento' },
    isSidebarAware: { type: Boolean, default: true }
})

const { isExpanded, isHovered } = useSidebar()

defineEmits(['close'])
</script>
