<template>
    <div :class="containerClass">
        <button @click="handleClick" class="inline-flex items-center gap-2 text-sm font-bold text-text-muted hover:text-primary transition-colors">
            <ArrowLeftIcon class="w-4 h-4" />
            {{ label }}
        </button>
    </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { ArrowLeftIcon } from '@/icons'

const props = defineProps({
    routeName: {
        type: String,
        required: true
    },
    label: {
        type: String,
        default: 'Regresar'
    },
    containerClass: {
        type: String,
        default: 'mb-4'
    }
})

const router = useRouter()

const handleClick = () => {
    router.push({ name: props.routeName })
}
</script>
