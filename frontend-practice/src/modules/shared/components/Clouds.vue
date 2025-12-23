<script setup lang="ts">
/**
 * Componente: Clouds
 * Descripción: Animación de nubes flotantes para el modo claro (Cielo diurno).
 * Utiliza SVG y animaciones CSS con efecto parallax.
 */
</script>

<template>
  <div class="clouds-container overflow-hidden pointer-events-none opacity-50">
    <!-- Nube 1 - Lenta / Atrás -->
    <div class="cloud layer-1">
      <svg viewBox="0 0 100 60" width="300" height="180">
        <path d="M10 40 Q10 20 30 20 Q35 10 50 10 Q65 10 70 20 Q90 20 90 40 Q90 55 70 55 L30 55 Q10 55 10 40" fill="white" />
      </svg>
    </div>

    <!-- Nube 2 - Media -->
    <div class="cloud layer-2">
      <svg viewBox="0 0 100 60" width="200" height="120">
        <path d="M10 40 Q10 20 30 20 Q35 10 50 10 Q65 10 70 20 Q90 20 90 40 Q90 55 70 55 L30 55 Q10 55 10 40" fill="white" />
      </svg>
    </div>

    <!-- Nube 3 - Rápida / Adelante -->
    <div class="cloud layer-3">
      <svg viewBox="0 0 100 60" width="150" height="90">
        <path d="M10 40 Q10 20 30 20 Q35 10 50 10 Q65 10 70 20 Q90 20 90 40 Q90 55 70 55 L30 55 Q10 55 10 40" fill="white" />
      </svg>
    </div>

    <!-- Nube 4 - Muy lenta -->
    <div class="cloud layer-1 delay-1">
      <svg viewBox="0 0 100 60" width="250" height="150">
        <path d="M10 40 Q10 20 30 20 Q35 10 50 10 Q65 10 70 20 Q90 20 90 40 Q90 55 70 55 L30 55 Q10 55 10 40" fill="white" />
      </svg>
    </div>
  </div>
</template>

<style scoped>
.clouds-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 70%; /* Más cobertura de nubes */
  z-index: 0;
}

.cloud {
  position: absolute;
  filter: blur(6px); /* Menos blur para que se vean más nítidas */
}

.layer-1 {
  top: 55px;
  left: -300px;
  animation: move-cloud 60s linear infinite;
}

.layer-2 {
  top: 151px;
  left: -200px;
  animation: move-cloud 45s linear infinite;
}

.layer-3 {
  top: 80px;
  left: -150px;
  animation: move-cloud 30s linear infinite;
}

.delay-1 {
  top: 180px;
  animation-delay: -30s;
}

@keyframes move-cloud {
  0% {
    transform: translateX(0);
  }
  100% {
    transform: translateX(calc(100vw + 350px));
  }
}
</style>
