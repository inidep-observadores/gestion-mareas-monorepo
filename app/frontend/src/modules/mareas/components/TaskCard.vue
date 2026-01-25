<template>
  <div 
    class="group relative bg-surface border border-border rounded-3xl p-5 hover:shadow-2xl hover:shadow-primary/10 transition-all duration-300 hover:-translate-y-1 cursor-pointer overflow-hidden"
    @click="$emit('click')"
  >
    <!-- Background Gradient Decoration -->
    <div class="absolute -right-10 -top-10 w-32 h-32 bg-primary/5 rounded-full blur-3xl group-hover:bg-primary/10 transition-colors"></div>

    <div class="flex flex-col h-full space-y-4">
      <!-- Header: Vessel & Meta -->
      <div class="flex items-start justify-between">
        <div class="flex items-center gap-3">
          <div class="p-2.5 bg-surface-muted rounded-2xl group-hover:bg-primary/10 transition-colors">
            <ShipIcon class="w-5 h-5 text-text-muted group-hover:text-primary transition-colors" />
          </div>
          <div>
            <h3 class="font-black text-text leading-tight lg:text-lg">
              {{ buque }}
            </h3>
            <p class="text-[10px] font-mono text-text-muted uppercase tracking-widest mt-0.5">
              {{ idMarea }}
              <span v-if="showObserver && observador" class="font-sans font-semibold normal-case tracking-normal">
                · {{ observador }}
              </span>
            </p>
          </div>
        </div>
        
        <div 
          class="px-3 py-1 rounded-full text-[10px] font-black uppercase tracking-tighter"
          :class="priorityClasses"
        >
          {{ priorityLabel }}
        </div>
      </div>

      <!-- Content: Current Status & Progress -->
      <div v-if="!compact" class="flex-1 space-y-3">
        <div class="flex items-center justify-between">
          <span class="text-[10px] uppercase font-bold text-text-muted tracking-wider">Estado Actual</span>
          <span class="text-xs font-bold text-text">{{ hito }}</span>
        </div>
        
        <!-- Action Preview / Summary -->
        <p class="text-xs text-text-muted leading-relaxed line-clamp-2 italic">
          "{{ descripcion }}"
        </p>
      </div>

      <!-- Footer: Actions & Date -->
      <div class="pt-4 border-t border-border flex items-center justify-between">
        <div v-if="!compact" class="flex items-center gap-2">
          <div class="w-1.5 h-1.5 rounded-full bg-primary"></div>
          <span class="text-[10px] font-bold text-text-muted">Actualizado {{ fecha }}</span>
        </div>
        
        <div class="flex gap-2">
           <button 
             v-for="action in actions" 
             :key="action.label"
             @click.stop="$emit('action', action.key)"
             class="px-3 py-1.5 h-8 flex items-center gap-2 rounded-xl text-[10px] font-black uppercase tracking-tight transition-all active:scale-95"
             :class="action.primary 
               ? 'bg-primary text-primary-fg hover:bg-primary-hover shadow-lg shadow-primary/20' 
               : 'bg-surface-muted text-text-muted hover:bg-surface/50'"
           >
             <component :is="action.icon" v-if="action.icon" class="w-3 h-3" />
             {{ action.label }}
           </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { ShipIcon } from '@/icons'

interface Action {
  label: string
  key: string
  icon?: any
  primary?: boolean
}

interface Props {
  buque: string
  idMarea: string
  observador?: string
  hito: string
  descripcion: string
  fecha: string
  prioridad: 'baja' | 'media' | 'alta'
  actions: Action[]
  showObserver?: boolean
  compact?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  showObserver: false,
  compact: false
})
defineEmits(['click', 'action'])

const priorityLabel = computed(() => {
  if (props.prioridad === 'alta') return 'Urgente'
  if (props.prioridad === 'media') return 'Prioritario'
  return 'Normal'
})

const priorityClasses = computed(() => {
  if (props.prioridad === 'alta') return 'bg-error/10 text-error'
  if (props.prioridad === 'media') return 'bg-warning/10 text-warning'
  return 'bg-info/10 text-info'
})
</script>
