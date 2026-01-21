<template>
  <div class="absolute right-0 top-0 bottom-0 z-[2000] flex pointer-events-none">
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
      class="pointer-events-auto h-full bg-surface shadow-[-20px_0_50px_-20px_rgba(0,0,0,0.3)] transition-all duration-500 ease-spring border-l border-border/10"
      :style="{ width: isOpen ? '320px' : '0px' }"
      :class="{ 'invisible': !isOpen }"
    >
      <div class="flex flex-col h-full w-[320px] overflow-hidden">
        <!-- Header -->
        <div class="p-6 flex items-center justify-between border-b border-border/10">
          <div>
            <h2 class="text-xs font-black text-text uppercase tracking-widest">Panel de Control</h2>
            <p class="text-[9px] text-text-muted font-bold uppercase tracking-tight">Configuración del Monitor</p>
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
            <Button
              variant="soft"
              className="w-full !rounded-2xl !p-4 border border-primary/20 hover:border-primary/40 active:scale-95"
              @click="$emit('open-upload')"
            >
              <div class="flex items-center gap-4 w-full">
                <div class="w-10 h-10 rounded-xl bg-primary flex items-center justify-center text-primary-fg shadow-lg shadow-primary/20 group-hover:scale-110 transition-transform">
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4M17 8l-5-5-5 5M12 3v12"/>
                  </svg>
                </div>
                <div class="text-left">
                  <div class="text-[11px] font-black text-text uppercase tracking-tight">Importar Seguimiento</div>
                  <div class="text-[9px] text-text-muted/80 uppercase font-bold">CSV de SIOP</div>
                </div>
              </div>
            </Button>
          </section>

          <!-- Layer Visibility -->
          <section>
            <h3 class="text-[10px] font-black text-primary uppercase tracking-widest mb-4">Capas de Información</h3>
            <div class="space-y-2">
              <div
                v-for="(val, key) in mapLayers"
                :key="key"
                class="flex items-center justify-between p-3 rounded-xl bg-surface-muted/30 border border-border/10 hover:border-border/30 transition-all group"
              >
                <div class="flex items-center gap-3">
                   <div class="w-2 h-2 rounded-full transition-all duration-500" :class="val ? 'bg-primary shadow-[0_0_8px_rgba(var(--color-primary-rgb),0.5)]' : 'bg-text-muted/20'"></div>
                   <span class="text-[10px] font-bold text-text-muted uppercase tracking-wider group-hover:text-text transition-colors">{{ formatKey(key) }}</span>
                </div>

                <BaseSwitch
                  :modelValue="val"
                  @update:modelValue="$emit('update:layer', key, $event)"
                />
              </div>
            </div>
          </section>
        </div>

        <!-- Footer -->
        <div class="p-4 bg-surface-muted/20 border-t border-border/10">
           <div class="flex items-center justify-between px-2">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-tighter italic">VMS Engine v2.0</span>
              <div class="flex gap-1.5 Items-center">
                <div class="w-1 h-1 bg-success rounded-full"></div>
                <div class="w-1.5 h-1.5 bg-success rounded-full animate-pulse opacity-80"></div>
              </div>
           </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import Button from '@/components/ui/Button.vue'
import BaseSwitch from '@/components/ui/BaseSwitch.vue'

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
    points: 'Puntos de Reporte',
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
