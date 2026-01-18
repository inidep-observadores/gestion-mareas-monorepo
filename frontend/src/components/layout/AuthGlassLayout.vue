<template>
  <div class="auth-layout dark min-h-screen w-full relative overflow-hidden flex items-center justify-center p-4 bg-slate-950 text-white animate-fade-in">
    
    <!-- Atmósfera Global (Original Premium) -->
    <Atmosphere />

    <!-- Contenido Principal -->
    <div class="relative z-10 w-full flex justify-center">
      <slot />
    </div>

    <!-- Footer -->
    <div class="absolute bottom-4 text-center w-full z-10 opacity-30">
      <p class="text-[10px] tracking-widest uppercase font-mono">
        &copy; 2025 INIDEP. Todos los derechos reservados.
      </p>
    </div>

  </div>
</template>

<script setup lang="ts">
import Atmosphere from '@/components/ui/Atmosphere.vue';
</script>

<style scoped>
.auth-layout {
  transition: background-color 0.5s ease;
  background-color: #020617; /* Hardcoded slate 950 for premium consistency */
}

.animate-fade-in {
  animation: fadeIn 0.8s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
</style>
