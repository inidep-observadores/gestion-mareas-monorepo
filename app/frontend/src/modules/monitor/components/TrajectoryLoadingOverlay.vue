<template>
  <Transition
    enter-active-class="transition duration-300 ease-out"
    enter-from-class="translate-y-4 opacity-0"
    enter-to-class="translate-y-0 opacity-100"
    leave-active-class="transition duration-200 ease-in"
    leave-from-class="translate-y-0 opacity-100"
    leave-to-class="translate-y-4 opacity-0"
  >
    <div v-if="show" class="pointer-events-auto">
      <div class="bg-surface/80 backdrop-blur-xl border border-border/20 rounded-2xl p-4 shadow-2xl flex items-center gap-4 min-w-[240px]">
        <!-- Animated Loader -->
        <div class="relative flex items-center justify-center">
          <div class="w-10 h-10 border-2 border-primary/20 rounded-full"></div>
          <div class="absolute inset-0 border-t-2 border-primary rounded-full animate-spin"></div>
          <div class="absolute inset-2 bg-primary/10 rounded-full flex items-center justify-center">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 text-primary animate-pulse" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
              <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
        </div>

        <!-- Text Content -->
        <div class="flex flex-col gap-0.5">
          <h3 class="font-black uppercase tracking-widest text-[10px] text-primary/80">Procesando Datos</h3>
          <p class="text-xs font-bold text-text tabular-nums">
            Restan {{ count }} {{ count === 1 ? 'trayectoria' : 'trayectorias' }}...
          </p>
          <p class="text-[9px] text-text-muted/60 font-medium uppercase italic tracking-tighter">
            Optimizando visualización de flota
          </p>
        </div>
      </div>
    </div>
  </Transition>
</template>

<script setup lang="ts">
defineProps<{
  show: boolean
  count: number
}>()
</script>

<style scoped>
.backdrop-blur-xl {
  backdrop-filter: blur(24px);
  -webkit-backdrop-filter: blur(24px);
}
</style>
