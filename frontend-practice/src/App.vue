<script setup lang="ts">
import { useRoute } from 'vue-router';
import { computed, provide } from 'vue';
import { Toaster } from 'vue-sonner';
import { useTheme } from './composables/useTheme';

const route = useRoute();
const { activeTheme, themePreference, setTheme } = useTheme();

// Proveer el estado del tema a toda la aplicación
provide('theme', { activeTheme, themePreference, setTheme });

const backgroundClass = computed(() => {
  // El dashboard siempre usa fondo claro/gris suave independientemente del tema global por ahora?
  // O el dashboard también debería ser oscuro? 
  // El usuario pidió "funcionalidad de temas seleccionable por el usuario".
  // Ajustaremos el fondo principal según el tema activo.
  return activeTheme.value === 'dark' ? 'bg-slate-950' : 'bg-slate-50';
});
</script>

<template>
  <main 
    class="relative w-full h-screen overflow-hidden transition-colors duration-500"
    :class="backgroundClass"
  >
    <router-view v-slot="{ Component }">
      <Transition name="fade" mode="out-in">
        <component :is="Component" />
      </Transition>
    </router-view>
    <Toaster position="top-right" expand richColors closeButton />
  </main>
</template>

<style>
/* We need a global style for the fade transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
