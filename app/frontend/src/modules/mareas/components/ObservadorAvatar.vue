<template>
  <div
    class="rounded-full overflow-hidden flex items-center justify-center shrink-0 bg-surface-muted text-text-muted border border-border transition-all"
    :class="[
      sizeClass,
      isClickable
        ? 'cursor-pointer hover:ring-2 hover:ring-primary/40 hover:scale-105 active:scale-95 shadow-xs'
        : 'group-hover:border-primary/40'
    ]"
    :title="avatarTitle"
    @click="handleClick"
  >
    <img
      v-if="fotoUrl && !imageFailed"
      :src="getFullImageUrl(fotoUrl)"
      :alt="nombre || 'Observador'"
      class="w-full h-full object-cover"
      @error="imageFailed = true"
    />
    <span v-else-if="initials" class="font-black uppercase leading-none" :class="textClass">{{ initials }}</span>
    <UserCircleIcon v-else class="w-3/4 h-3/4" />
  </div>

  <!-- Modal Emergente con Ficha del Observador -->
  <ObservadorQuickModal
    v-if="showModal"
    :show="showModal"
    :observador-id="targetObservadorId"
    :observador="observador"
    :nombre-fallback="nombre"
    :foto-url-fallback="fotoUrl"
    @close="showModal = false"
  />
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { getFullImageUrl } from '@/helpers/image.helper'
import { UserCircleIcon } from '@/icons'
import ObservadorQuickModal from '@/modules/admin/components/ObservadorQuickModal.vue'
import type { Observador } from '@/modules/admin/interfaces/observador.interface'

const props = withDefaults(defineProps<{
  fotoUrl?: string | null
  nombre?: string | null
  size?: 'sm' | 'md' | 'lg' | 'xl'
  observadorId?: string | null
  observador?: Partial<Observador> | null
  clickable?: boolean
}>(), {
  size: 'md',
  clickable: true
})

const imageFailed = ref(false)
const showModal = ref(false)

watch(() => props.fotoUrl, () => { imageFailed.value = false })

const targetObservadorId = computed(() => {
  return props.observadorId || props.observador?.id || null
})

const isClickable = computed(() => {
  if (props.clickable === false) return false
  const name = (props.nombre || '').trim().toLowerCase()
  if (name === 'sin asignar' || name === 'no asignado') return false
  return Boolean(targetObservadorId.value || props.observador)
})

const avatarTitle = computed(() => {
  const baseName = props.nombre || 'Sin observador asignado'
  if (isClickable.value) {
    return `${baseName} (Clic para ver ficha)`
  }
  return baseName
})

const handleClick = (e: MouseEvent) => {
  if (!isClickable.value) return
  e.stopPropagation()
  showModal.value = true
}

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
