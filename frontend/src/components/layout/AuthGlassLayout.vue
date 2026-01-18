<template>
  <!-- Force Dark Mode for Auth Layout -->
  <div class="auth-layout dark min-h-screen w-full relative overflow-hidden flex items-center justify-center p-4 bg-slate-950 text-white selection:bg-primary/30">
    
    <!-- Atmósfera Global (Fondo animado) -->
    <Atmosphere />

    <!-- Contenido Principal (Z-Index alto para estar sobre el fondo) -->
    <div class="relative z-10 w-full flex justify-center">
      <!-- Slot para el contenido (Login, Register, etc.) -->
      <slot />
    </div>

    <!-- Footer Opcional -->
    <div class="absolute bottom-4 text-center w-full z-10">
      <p class="text-xs text-text-muted/60">
        &copy; 2025 INIDEP. Todos los derechos reservados.
      </p>
    </div>

  </div>
</template>

<script setup lang="ts">
import Atmosphere from '@/components/ui/Atmosphere.vue';
</script>

<style scoped>
/* Transiciones suaves de color de fondo al cambiar temas */
.auth-layout {
  transition: background-color 0.5s ease, color 0.5s ease;
}
</style>
