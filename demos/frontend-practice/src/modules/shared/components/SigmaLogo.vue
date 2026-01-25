<script setup lang="ts">
import { ref, onMounted } from 'vue';
/**
 * Componente: SigmaLogo
 * Ubicación: src/modules/shared/components/SigmaLogo.vue
 * Descripción: Isotipo animado de SIGMA. Diseño geométrico de alta precisión
 * con trazos concéntricos y estilo futurista/neón.
 */

defineProps({
  width: {
    type: String,
    default: '140px'
  },
  animated: {
    type: Boolean,
    default: true
  },
  theme: {
    type: String,
    default: 'dark',
    validator: (value: string) => ['light', 'dark'].includes(value)
  }
});

const logoEl = ref(null);
defineExpose({ logoEl });
</script>

<template>
  <div ref="logoEl" class="logo-wrapper" :style="{ width: width, height: width }">
    <svg viewBox="0 0 160 160" class="sigma-svg" :class="[`theme-${theme}`]">
      <defs>
        <!-- Gradiante Modo Oscuro (Neón / Cyan) -->
        <linearGradient id="sigmaGradientDark" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#00f2ff" />
          <stop offset="100%" stop-color="#0078ff" />
        </linearGradient>

        <!-- Gradiante Modo Claro (Azul Profundo / Indigo) -->
        <linearGradient id="sigmaGradientLight" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#2563eb" />
          <stop offset="100%" stop-color="#4f46e5" />
        </linearGradient>
        
        <!-- Glow más intenso y difuso para efecto "halo" -->
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
         Geometría: Línea recta superior + Arco perfecto de 180 grados.
         Centro del arco: (115, 55) | Radio: 55
         Esto garantiza que sea perfectamente paralelo al círculo interior.
      -->
      <path
        d="M 140 25 L 80 25 A 55 55 0 0 0 80 135 L 90 135"
        class="sigma-path-arm"
        :class="{ 'animate': animated }"
        :stroke="theme === 'dark' ? 'url(#sigmaGradientDark)' : 'url(#sigmaGradientLight)'"
      />

      <!-- 
         ELEMENTO 2: El Núcleo (Inner Core)
         Centro: (80, 80) | Radio: 28
         Nota: Es un círculo con 'stroke-dasharray' ajustado para tener una apertura (gap)
         que le da un aspecto de "anillo de carga" o pieza mecánica.
      -->
      <circle 
        cx="80" 
        cy="80" 
        r="28" 
        class="sigma-circle-core"
        :class="{ 'animate': animated }"
        :stroke="theme === 'dark' ? 'url(#sigmaGradientDark)' : 'url(#sigmaGradientLight)'"
      />
      
      <!-- Pequeño detalle: Punto central "Data Point" (Opcional, añade densidad visual) -->
      <circle 
        cx="80" 
        cy="80" 
        r="6" 
        :fill="theme === 'dark' ? '#00f2ff' : '#2563eb'" 
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

.theme-light {
  filter: drop-shadow(0 0 4px rgba(37, 99, 235, 0.3));
}

/* --- BRAZO EXTERIOR --- */
.sigma-path-arm {
  stroke-width: 9; /* Trazo fuerte y definido */
  stroke-dasharray: 380; /* Longitud del trazo */
  stroke-dashoffset: 0;
}

.sigma-path-arm.animate {
  stroke-dashoffset: 380;
  animation: drawArm 2.2s cubic-bezier(0.22, 1, 0.36, 1) forwards 0.2s, float 6s ease-in-out infinite 3s;
}

/* --- NÚCLEO INTERIOR --- */
.sigma-circle-core {
  stroke-width: 6; /* Un poco más fino que el brazo para contraste */
  stroke-dasharray: 130 50; /* Círculo cortado (Tech look) */
  stroke-dashoffset: 0;
  transform-origin: 80px 80px;
  transform: rotate(-45deg);
}

.sigma-circle-core.animate {
  stroke-dashoffset: 180; /* Empieza "vacío" */
  animation: drawCore 2s cubic-bezier(0.22, 1, 0.36, 1) forwards 0.5s, spinSlow 15s linear infinite 3s;
}

/* --- PUNTO CENTRAL --- */
.sigma-dot {
  opacity: 0.8; /* Visible by default */
}
.sigma-dot.animate {
  opacity: 0; /* Hide it only when animation is set to run */
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

/* Rotación muy lenta y técnica para el núcleo */
@keyframes spinSlow {
  from { transform: rotate(-45deg); }
  to { transform: rotate(315deg); }
}

@keyframes pulse {
  0%, 100% { r: 6; opacity: 0.8; }
  50% { r: 8; opacity: 0.4; }
}
</style>