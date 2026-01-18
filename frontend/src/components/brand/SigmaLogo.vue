<script setup lang="ts">
import { ref } from 'vue';
/**
 * Componente: SigmaLogo
 * Ubicación: src/components/brand/SigmaLogo.vue
 * Descripción: Isotipo animado de SIGMA adaptado a tokens semánticos.
 */

defineProps({
  width: {
    type: String,
    default: '140px'
  },
  animated: {
    type: Boolean,
    default: true
  }
});

const logoEl = ref(null);
defineExpose({ logoEl });
</script>

<template>
  <div ref="logoEl" class="logo-wrapper" :style="{ width: width, height: width }">
    <svg viewBox="0 0 160 160" class="sigma-svg">
      <defs>
        <!-- Gradiante Principal (Primary -> Info) -->
        <!-- Usamos variables CSS para que reaccione al tema (Verde, Naranja, Azul, etc.) -->
        <linearGradient id="sigmaGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color: var(--color-info); stop-opacity: 1" />
          <stop offset="100%" style="stop-color: var(--color-primary); stop-opacity: 1" />
        </linearGradient>
        
        <!-- Glow adaptativo usando el color primario -->
        <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="4" result="coloredBlur" />
          <feMerge>
            <feMergeNode in="coloredBlur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>
      
      <!-- 
         ELEMENTO 1: El Brazo (Outer Shell)
      -->
      <path
        d="M 140 25 L 80 25 A 55 55 0 0 0 80 135 L 90 135"
        class="sigma-path-arm"
        :class="{ 'animate': animated }"
        stroke="url(#sigmaGradient)"
      />

      <!-- 
         ELEMENTO 2: El Núcleo (Inner Core)
      -->
      <circle 
        cx="80" 
        cy="80" 
        r="28" 
        class="sigma-circle-core"
        :class="{ 'animate': animated }"
        stroke="url(#sigmaGradient)"
      />
      
      <!-- Punto central -->
      <circle 
        cx="80" 
        cy="80" 
        r="6" 
        class="sigma-dot" 
        :class="{ 'animate': animated }" 
      />
    </svg>
  </div>
</template>

<style scoped>
.logo-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
}

.sigma-svg {
  width: 100%;
  height: 100%;
  filter: url(#glow);
  overflow: visible;
}

/* --- ESTILOS COMUNES --- */
.sigma-path-arm,
.sigma-circle-core {
  fill: none;
  stroke-linecap: round;
  stroke-linejoin: round;
}

/* --- BRAZO EXTERIOR --- */
.sigma-path-arm {
  stroke-width: 9;
  stroke-dasharray: 380;
  stroke-dashoffset: 0;
}

.sigma-path-arm.animate {
  stroke-dashoffset: 380;
  animation: drawArm 2.2s cubic-bezier(0.22, 1, 0.36, 1) forwards 0.2s, float 6s ease-in-out infinite 3s;
}

/* --- NÚCLEO INTERIOR --- */
.sigma-circle-core {
  stroke-width: 6;
  stroke-dasharray: 130 50;
  stroke-dashoffset: 0;
  transform-origin: 80px 80px;
  transform: rotate(-45deg);
}

.sigma-circle-core.animate {
  stroke-dashoffset: 180;
  animation: drawCore 2s cubic-bezier(0.22, 1, 0.36, 1) forwards 0.5s, spinSlow 15s linear infinite 3s;
}

/* --- PUNTO CENTRAL --- */
.sigma-dot {
  opacity: 0.8;
  fill: var(--color-info); /* Use theme secondary/info color */
}
.sigma-dot.animate {
  opacity: 0;
  animation: fadeIn 1s ease-out forwards 1.5s, pulse 3s infinite 3s;
}

/* --- KEYFRAMES --- */
@keyframes drawArm {
  to { stroke-dashoffset: 0; }
}

@keyframes drawCore {
  to { stroke-dashoffset: 0; }
}

@keyframes fadeIn {
  to { opacity: 0.8; }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-6px); }
}

@keyframes spinSlow {
  from { transform: rotate(-45deg); }
  to { transform: rotate(315deg); }
}

@keyframes pulse {
  0%, 100% { r: 6; opacity: 0.8; }
  50% { r: 8; opacity: 0.4; }
}
</style>
