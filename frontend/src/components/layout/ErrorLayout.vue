<template>
  <div class="min-h-screen bg-background flex items-center justify-center p-6 relative overflow-hidden">
    <!-- Sophisticated Background Elements -->
    <div class="absolute top-0 left-0 w-full h-full pointer-events-none opacity-30 dark:opacity-20">
      <div class="absolute -top-24 -left-24 w-96 h-96 bg-primary/20 rounded-full blur-3xl"></div>
      <div class="absolute -bottom-24 -right-24 w-96 h-96 bg-info/20 rounded-full blur-3xl"></div>
    </div>

    <!-- Content Container -->
    <div class="w-full max-w-lg relative z-10">
      <div class="bg-surface/80 backdrop-blur-xl border border-border rounded-[2.5rem] p-8 md:p-12 shadow-2xl shadow-border/50 text-center">
        <!-- Icon Slot -->
        <div class="mb-8 flex justify-center">
          <div class="relative">
            <div class="absolute inset-0 bg-primary/20 blur-2xl rounded-full scale-110"></div>
            <div class="relative w-20 h-20 bg-gradient-to-br from-primary to-info rounded-2xl flex items-center justify-center text-white shadow-xl rotate-3 hover:rotate-0 transition-transform duration-300">
              <slot name="icon">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
              </slot>
            </div>
          </div>
        </div>

        <!-- Title & Description -->
        <h1 class="text-3xl md:text-4xl font-black text-text mb-4 tracking-tight">
          <slot name="title">¡Oops! Algo salió mal</slot>
        </h1>
        
        <p class="text-text-muted text-lg leading-relaxed mb-10">
          <slot name="description">Lo sentimos, pero no tiene permisos para acceder a este recurso.</slot>
        </p>

        <!-- Actions -->
        <div class="flex flex-col gap-3">
          <slot name="actions"></slot>
        </div>

        <!-- Footer Info -->
        <div class="mt-12 pt-8 border-t border-border">
          <p class="text-xs text-text-muted font-medium uppercase tracking-[0.2em]">
            INIDEP - Gestión de Mareas
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// Reusable layout for 404, 403, 401 views
</script>

<style scoped>
/* Glassmorphism and premium effects */
</style>
