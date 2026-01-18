<script setup lang="ts">
/**
 * Componente: AtmosphericBackground (antiguo Atmosphere.vue)
 * Descripción: Encapsula los efectos de fondo HARDCODED para máximo impacto.
 */
import Waves from './Waves.vue';
import Constellations from '@/modules/shared/components/Constellations.vue';
</script>

<template>
  <div class="atmosphere-container">
    <!-- Capa 1: Blobs de fondo (Gradientes originales) -->
    <div class="background-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
    </div>

    <!-- Capa 2: Constelaciones -->
    <Constellations />

    <!-- Capa 3: Ondas -->
    <div class="waves-layer">
      <Waves />
    </div>
    
    <!-- Capa 4: Glow Central (Añadido para profundidad) -->
    <div class="background-glow px-4"></div>
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
  background-color: #020617; /* Slate 950 real */
}

.background-blobs {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
}

.blob {
  position: absolute;
  filter: blur(80px);
  opacity: 0.4;
  border-radius: 50%;
  animation: move 20s infinite alternate;
}

.blob-1 {
  width: 500px; height: 500px;
  background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
  top: -150px; left: -150px;
}

.blob-2 {
  width: 400px; height: 400px;
  background: linear-gradient(135deg, #3b82f6 0%, #4338ca 100%);
  bottom: -100px; right: -100px;
  animation-delay: -5s;
}

.blob-3 {
  width: 300px; height: 300px;
  background: radial-gradient(circle, #2dd4bf 0%, #0ea5e9 100%); 
  top: 40%; left: 60%;
  animation-delay: -10s;
}

.waves-layer {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  z-index: 2;
}

.background-glow {
  position: absolute;
  width: 60vw;
  height: 60vw;
  background: radial-gradient(circle, rgba(0, 242, 255, 0.08) 0%, transparent 70%);
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  z-index: 1;
}

@keyframes move {
  from { transform: translate(0, 0) scale(1); }
  to { transform: translate(60px, 30px) scale(1.1); }
}
</style>
