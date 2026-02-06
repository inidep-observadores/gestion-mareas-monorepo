<template>
    <div
        class="rounded-3xl border border-border bg-background shadow-sm overflow-hidden mb-4 transition-all duration-300">
        <!-- Header -->
        <div @click="toggle"
            class="w-full flex items-center justify-between p-5 cursor-pointer hover:bg-surface-muted/20 select-none transition-colors"
            :class="{ 'bg-surface-muted/30 border-b border-border': isOpen }">
            <div class="flex items-center gap-3 overflow-hidden">
                <div v-if="$slots.icon" class="shrink-0">
                    <slot name="icon"></slot>
                </div>
                <div class="min-w-0">
                    <h4
                        class="text-sm font-black text-text/90 uppercase tracking-tight flex items-center gap-2 truncate">
                        {{ title }}
                        <slot name="title-extra"></slot>
                    </h4>
                    <p v-if="description"
                        class="text-[10px] font-bold text-text-muted/60 uppercase tracking-tighter mt-0.5 truncate">
                        {{ description }}
                    </p>
                </div>
            </div>

            <div class="flex items-center gap-3 shrink-0">
                <!-- Contenedor para acciones (stop propagation para evitar toggle al clickear botón) -->
                <div v-if="$slots.actions" @click.stop class="flex items-center">
                    <slot name="actions"></slot>
                </div>
                <ChevronDownIcon class="w-5 h-5 text-text-muted transition-transform duration-300"
                    :class="{ 'rotate-180': isOpen }" />
            </div>
        </div>

        <!-- Content with CSS Grid Animation -->
        <div class="collapsible-content" :class="{ 'is-open': isOpen }">
            <div class="overflow-hidden">
                <div class="p-5" :class="contentClass">
                    <slot></slot>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { ChevronDownIcon } from '@/icons'

interface Props {
    title: string
    description?: string
    initialOpen?: boolean
    contentClass?: string
    modelValue?: boolean
}

const props = withDefaults(defineProps<Props>(), {
    initialOpen: false,
    contentClass: ''
})

const emit = defineEmits(['update:modelValue', 'toggle'])

// Estado local que se sincroniza con los props
const isOpen = ref(props.modelValue !== undefined ? props.modelValue : props.initialOpen)

function toggle() {
    isOpen.value = !isOpen.value
    emit('update:modelValue', isOpen.value)
    emit('toggle', isOpen.value)
}

// Sincronizar cambios externos
watch(() => props.initialOpen, (val) => {
    if (props.modelValue === undefined) {
        isOpen.value = val
    }
})

watch(() => props.modelValue, (val) => {
    if (val !== undefined) {
        isOpen.value = val
    }
})
</script>

<style scoped>
.collapsible-content {
    display: grid;
    grid-template-rows: 0fr;
    transition: grid-template-rows 0.3s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.2s ease;
    opacity: 0;
}

.collapsible-content.is-open {
    grid-template-rows: 1fr;
    opacity: 1;
}
</style>
