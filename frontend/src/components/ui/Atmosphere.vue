<script setup lang="ts">
/**
 * Componente: AtmosphericBackground (antiguo Atmosphere.vue)
 * Descripción: Encapsula los efectos de fondo (Blobs, Ondas, Estrellas/Nubes si se desea)
 * para el layout de autenticación.
 */
import Waves from './Waves.vue';
</script>

<template>
  <div class="atmosphere-container">
    <!-- Blobs de fondo (Gradientes difusos) -->
    <div class="background-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
    </div>

    <!-- Ondas en la parte inferior -->
    <Waves />
    
    <!-- Pattern de ruido opcional o grid para textura -->
    <!-- <div class="noise-overlay"></div> -->
  </div>
</template>

<style scoped>
.atmosphere-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
  z-index: 0;
}

.background-blobs {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  /* z-index: -1; Implícito al estar en el contenedor */
}

/* Blobs semánticos usando el color primario y secundario (Info) */
.blob {
  position: absolute;
  filter: blur(80px); /* Desenfoque fuerte para suavidad */
  opacity: 0.4; /* Opacidad base para modo oscuro */
  border-radius: 50%;
  animation: move 20s infinite alternate;
}

/* Ajuste de opacidad para modo claro (light mode) automático vía dark: prefix si se usara tailwind,
   pero aquí usamos CSS variables */
:root:not(.dark) .blob {
  opacity: 0.25; /* Un poco más sutil en claro */
}

.blob-1 {
  width: 500px; height: 500px;
  /* Gradiente usando variables CSS rgb para transparencia */
  background: linear-gradient(135deg, rgba(var(--color-info-rgb), 0.8) 0%, rgba(var(--color-primary-rgb), 0.8) 100%);
  top: -150px; left: -150px;
}

.blob-2 {
  width: 400px; height: 400px;
  background: linear-gradient(135deg, rgba(var(--color-primary-rgb), 0.8) 0%, rgba(var(--color-purple-rgb), 0.5) 100%); /* Purple if defined, else generic fallback */
  bottom: -100px; right: -100px;
  animation-delay: -5s;
}

/* Fallback si purple-rgb no existe */
.blob-2 {
   background: linear-gradient(135deg, rgba(var(--color-primary-rgb), 0.8) 0%, rgba(var(--color-primary-rgb), 0.4) 100%);
}

.blob-3 {
  width: 300px; height: 300px;
  background: radial-gradient(circle, rgba(var(--color-success-rgb), 0.4) 0%, rgba(var(--color-info-rgb), 0.4) 100%); 
  top: 40%; left: 60%;
  animation-delay: -10s;
}

@keyframes move {
  from { transform: translate(0, 0) scale(1); }
  to { transform: translate(60px, 30px) scale(1.1); }
}
</style>
