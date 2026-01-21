<template>
  <div class="fixed right-0 top-16 bottom-0 z-[2000] flex pointer-events-none">
    <!-- Trigger Button (Integrated in edge) -->
    <div class="flex items-center">
      <button 
        @click="isOpen = !isOpen"
        class="pointer-events-auto w-10 h-20 bg-surface/80 backdrop-blur-xl border border-border/20 border-r-0 rounded-l-2xl flex flex-col items-center justify-center gap-2 text-text-muted hover:text-primary transition-all group overflow-hidden shadow-2xl"
        :class="{ 'translate-x-full opacity-0': isOpen }"
      >
        <div class="w-1 h-8 bg-border/40 rounded-full group-hover:bg-primary/40 transition-colors"></div>
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 -rotate-90 group-hover:scale-110 transition-transform" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M19 9l-7 7-7-7"/>
        </svg>
      </button>
    </div>

    <!-- Sidebar Panel -->
    <div 
      class="pointer-events-auto h-full bg-surface/60 backdrop-blur-2xl border-l border-border/20 shadow-[-20px_0_50px_-20px_rgba(0,0,0,0.5)] transition-all duration-500 ease-spring"
      :style="{ width: isOpen ? '320px' : '0px' }"
      :class="{ 'invisible': !isOpen }"
    >
      <div class="flex flex-col h-full w-[320px] overflow-hidden">
        <!-- Header -->
        <div class="p-6 flex items-center justify-between border-b border-border/10">
          <div>
            <h2 class="text-sm font-black text-text uppercase tracking-widest">Panel de Control</h2>
            <p class="text-[10px] text-text-muted font-bold uppercase tracking-tight">VMS Configuration</p>
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

        <!-- Content -->
        <div class="flex-1 overflow-y-auto p-6 space-y-8 custom-scrollbar">
          <!-- Quick Actions -->
          <section>
            <h3 class="text-[10px] font-black text-primary uppercase tracking-widest mb-4">Acciones Rápidas</h3>
            <button 
              @click="$emit('open-upload')"
              class="w-full group relative p-4 rounded-2xl bg-primary/10 border border-primary/20 hover:bg-primary/20 hover:border-primary/40 transition-all flex items-center gap-4 active:scale-95"
            >
              <div class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center text-on-primary shadow-lg shadow-primary/40 group-hover:scale-110 transition-transform">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>
                </svg>
              </div>
              <div class="text-left">
                <div class="text-xs font-black text-text uppercase tracking-tight">Importar Seguimiento</div>
                <div class="text-[9px] text-text-muted uppercase font-bold">CSV Multi-procesamiento</div>
              </div>
            </button>
          </section>

          <!-- Layer Visibility (Moved from VesselInfoCard) -->
          <section>
            <h3 class="text-[10px] font-black text-primary uppercase tracking-widest mb-4">Capas de Información</h3>
            <div class="space-y-2">
              <label 
                v-for="(val, key) in mapLayers" 
                :key="key"
                class="flex items-center justify-between p-3 rounded-xl bg-surface-muted/50 border border-border/10 hover:border-border/30 transition-all cursor-pointer group"
              >
                <div class="flex items-center gap-3">
                   <div class="w-2 h-2 rounded-full" :class="val ? 'bg-primary animate-pulse' : 'bg-text-muted/20'"></div>
                   <span class="text-[10px] font-bold text-text/80 uppercase tracking-wider group-hover:text-text transition-colors">{{ formatKey(key) }}</span>
                </div>
                <div class="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" :checked="val" @change="$emit('update:layer', key, !val)" class="sr-only peer">
                  <div class="w-8 h-4 bg-surface rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-text-muted peer-checked:after:bg-on-primary after:rounded-full after:h-3 after:w-3 after:transition-all peer-checked:bg-primary border border-border/20"></div>
                </div>
              </label>
            </div>
          </section>
        </div>

        <!-- Footer -->
        <div class="p-4 bg-surface-muted/30 border-t border-border/10">
           <div class="flex items-center justify-between px-2">
              <span class="text-[9px] font-black text-text-muted uppercase tracking-tighter">VMS Engine v2.0</span>
              <div class="flex gap-1">
                <div class="w-1 h-1 bg-success rounded-full"></div>
                <div class="w-1 h-1 bg-success rounded-full animate-pulse"></div>
              </div>
           </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const props = defineProps<{
  mapLayers: Record<string, boolean>
}>()

const emit = defineEmits<{
  (e: 'update:layer', key: string, val: boolean): void
  (e: 'open-upload'): void
}>()

const isOpen = ref(false)

const formatKey = (key: string) => {
  const labels: any = {
    veda: 'Zonas de Veda',
    isobatas: 'Isobátas (200m)',
    totalPoints: 'Puntos de Reporte',
    totalTrack: 'Trayectoria Completa'
  }
  return labels[key] || key
}

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
</style>
