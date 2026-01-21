<template>
  <div class="absolute left-0 top-0 bottom-0 z-[2000] flex pointer-events-none">
    <!-- Sidebar Panel -->
    <div
      class="pointer-events-auto h-full bg-surface shadow-[20px_0_50px_-20px_rgba(0,0,0,0.3)] transition-all duration-500 ease-spring border-r border-border/10"
      :style="{ width: isOpen ? '320px' : '0px' }"
      :class="{ 'invisible': !isOpen }"
    >
      <div class="flex flex-col h-full w-[320px] overflow-hidden">
        <!-- Header -->
        <div class="p-6 flex items-center justify-between border-b border-border/10 bg-surface/5">
          <div class="flex items-center gap-3">
            <div class="p-2.5 bg-primary/10 rounded-2xl">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-primary" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
              </svg>
            </div>
            <div>
              <h2 class="text-xs font-black text-text uppercase tracking-widest">Flota Activa</h2>
              <p class="text-[9px] text-text-muted font-bold uppercase tracking-tight opacity-60">
                {{ vessels.length }} Buques Detectados
              </p>
            </div>
          </div>
          <button
            @click="isOpen = false"
            class="p-2 hover:bg-surface-muted rounded-xl transition-colors text-text-muted hover:text-primary"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M18 6L6 18M6 6l12 12"/>
            </svg>
          </button>
        </div>

        <!-- Quick Actions -->
        <div class="p-5 border-b border-border/5 flex gap-2">
          <Button 
            variant="soft" 
            size="xs" 
            class="flex-1 !text-[10px] !font-black uppercase tracking-tighter !rounded-xl"
            @click="$emit('select-all')"
          >
            Todos
          </Button>
          <Button 
            variant="ghost" 
            size="xs" 
            class="flex-1 !text-[10px] !font-black uppercase tracking-tighter !rounded-xl border border-border/10"
            @click="$emit('deselect-all')"
          >
            Ninguno
          </Button>
        </div>

        <!-- Vessel List -->
        <div class="flex-1 overflow-y-auto custom-scrollbar p-3 space-y-2">
          <div 
            v-for="vessel in vessels" 
            :key="vessel.id"
            class="group relative flex items-center gap-3 p-3 rounded-2xl border transition-all cursor-pointer"
            :class="[
              selectedId === vessel.id 
                ? 'bg-primary/5 border-primary/20 shadow-theme-sm' 
                : 'bg-surface-muted/30 border-border/5 hover:border-border/20'
            ]"
            @click="$emit('select', vessel.id)"
          >
            <!-- Visibility Toggle -->
            <div class="shrink-0" @click.stop>
              <BaseSwitch 
                :modelValue="vessel.visible" 
                @update:modelValue="$emit('toggle-visibility', vessel.id)"
                scale="0.75"
              />
            </div>

            <!-- Vessel Info -->
            <div class="flex-1 min-w-0">
              <div class="flex items-center gap-2 mb-0.5">
                <div 
                  class="w-2 h-2 rounded-full shrink-0" 
                  :style="{ backgroundColor: vessel.color }"
                ></div>
                <span class="text-[10.5px] font-black text-text uppercase truncate tracking-tight">
                  {{ vessel.name }}
                </span>
              </div>
              <div class="flex items-center gap-2 text-[9px] font-bold text-text-muted uppercase tracking-tighter">
                <span>{{ vessel.matricula }}</span>
                <span class="opacity-30">|</span>
                <span :class="vessel.status === 'OK' ? 'text-success' : 'text-warning'">
                  {{ vessel.status }}
                </span>
              </div>
            </div>

            <!-- Active Indicator Icon -->
            <div v-if="selectedId === vessel.id" class="shrink-0 text-primary">
              <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                <path d="M5 12l5 5L20 7"/>
              </svg>
            </div>
          </div>

          <div v-if="vessels.length === 0" class="flex flex-col items-center justify-center py-10 opacity-30">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 mb-2" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
              <path d="M22 12h-4l-3 9L9 3l-3 9H2"/>
            </svg>
            <p class="text-[10px] font-black uppercase tracking-widest text-center">Sin buques activos</p>
          </div>
        </div>

        <!-- Footer -->
        <div class="p-4 bg-surface-muted/20 border-t border-border/10">
           <div class="flex items-center justify-between px-2">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-tighter italic">Fleet Manager v1.0</span>
              <div class="flex gap-1.5 Items-center">
                <div class="w-1 h-1 bg-success rounded-full"></div>
                <div class="w-1.5 h-1.5 bg-success rounded-full animate-pulse opacity-80"></div>
              </div>
           </div>
        </div>
      </div>
    </div>

    <!-- Trigger Button (Integrated in edge) -->
    <div class="flex items-center">
      <button
        @click="isOpen = !isOpen"
        class="pointer-events-auto w-10 h-20 bg-surface/80 backdrop-blur-xl border border-border/20 border-l-0 rounded-r-2xl flex flex-col items-center justify-center gap-2 text-text-muted hover:text-primary transition-all group overflow-hidden shadow-2xl"
        :class="{ '-translate-x-full opacity-0': isOpen }"
      >
        <div class="w-1 h-8 bg-border/40 rounded-full group-hover:bg-primary/40 transition-colors"></div>
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 rotate-90 group-hover:scale-110 transition-transform" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M19 9l-7 7-7-7"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Button from '@/components/ui/Button.vue'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'

export interface MonitorVessel {
  id: string
  name: string
  matricula: string
  status: string
  color: string
  visible: boolean
  voyageStart: string | null
  voyageEnd: string | null
}

defineProps<{
  vessels: MonitorVessel[]
  selectedId: string | null
}>()

defineEmits(['select', 'toggle-visibility', 'select-all', 'deselect-all'])

const isOpen = ref(true)

defineExpose({
  open: () => isOpen.value = true,
  close: () => isOpen.value = false
})
</script>

<style scoped>
.ease-spring {
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: var(--color-primary);
}
</style>
