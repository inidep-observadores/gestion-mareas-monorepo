<template>
  <div
    class="rounded-full overflow-hidden flex items-center justify-center shrink-0 bg-surface-muted text-text-muted border border-border group-hover:border-primary/40 transition-colors"
    :class="sizeClass" :title="nombre || 'Sin observador asignado'">
    <img v-if="fotoUrl && !imageFailed" :src="getFullImageUrl(fotoUrl)" :alt="nombre || 'Observador'"
      class="w-full h-full object-cover" @error="imageFailed = true" />
    <span v-else-if="initials" class="font-black uppercase leading-none" :class="textClass">{{ initials }}</span>
    <UserCircleIcon v-else class="w-3/4 h-3/4" />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { getFullImageUrl } from '@/helpers/image.helper'
import { UserCircleIcon } from '@/icons'

const props = withDefaults(defineProps<{
  fotoUrl?: string | null
  nombre?: string | null
  size?: 'sm' | 'md' | 'lg' | 'xl'
}>(), { size: 'md' })

const imageFailed = ref(false)

watch(() => props.fotoUrl, () => { imageFailed.value = false })

const sizeClass = computed(() => {
  switch (props.size) {
    case 'sm': return 'w-6 h-6'
    case 'md': return 'w-8 h-8'
    case 'lg': return 'w-[31px] h-[31px]'
    case 'xl': return 'w-[42px] h-[42px]'
    default: return 'w-8 h-8'
  }
})

const textClass = computed(() => {
  switch (props.size) {
    case 'sm': return 'text-[9px]'
    case 'md': return 'text-[11px]'
    case 'lg': return 'text-[11px]'
    case 'xl': return 'text-xs'
    default: return 'text-[11px]'
  }
})

const initials = computed(() => {
  const name = (props.nombre || '').trim()
  if (!name || name === 'Sin asignar' || name === 'No asignado') return ''
  const parts = name.split(/\s+/)
  return `${parts[0][0] ?? ''}${parts.length > 1 ? parts[parts.length - 1][0] : ''}`
})
</script>
