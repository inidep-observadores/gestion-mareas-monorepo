<script setup lang="ts">
import { ref, computed } from 'vue';
import { useThemeStore } from '@/modules/shared/stores/theme.store';

const props = defineProps({
  width: {
    type: String,
    default: '140px'
  },
  animated: {
    type: Boolean,
    default: true
  },
  theme: {
    type: String, // 'light' | 'dark' | 'auto'
    default: 'auto',
  }
});

const themeStore = useThemeStore();
const activeTheme = computed(() => {
  if (props.theme !== 'auto') return props.theme;
  return themeStore.darkMode ? 'dark' : 'light';
});

const logoEl = ref(null);
defineExpose({ logoEl });
</script>

<template>
  <div ref="logoEl" class="logo-wrapper" :style="{ '--logo-size': width }">
    <svg viewBox="0 0 160 160" class="sigma-svg" :class="[`is-${activeTheme}`]">
      <defs>
        <!-- Los gradientes ahora usan variables CSS que inyectamos en el componente o globales -->
        <linearGradient id="sigmaGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="var(--sigma-primary)" />
          <stop offset="100%" stop-color="var(--sigma-secondary)" />
        </linearGradient>
        
        <filter id="glow" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="4" result="coloredBlur" />
          <feMerge>
            <feMergeNode in="coloredBlur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>
      
      <path
        d="M 140 25 L 80 25 A 55 55 0 0 0 80 135 L 90 135"
        class="sigma-path-arm"
        :class="{ 'animate': animated }"
        stroke="url(#sigmaGradient)"
      />

      <circle 
        cx="80" 
        cy="80" 
        r="28" 
        class="sigma-circle-core"
        :class="{ 'animate': animated }"
        stroke="url(#sigmaGradient)"
      />
      
      <circle 
        cx="80" 
        cy="80" 
        r="6" 
        fill="var(--sigma-primary)" 
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
  width: var(--logo-size);
  height: var(--logo-size);
  
  /* Definición de colores premium vía variables CSS */
  /* El modo default/oscuro (Sigma Identity) */
  --sigma-primary: #00f2ff;
  --sigma-secondary: #0078ff;
  --sigma-glow: rgba(0, 242, 255, 0.4);
}

/* Ajuste para modo claro (se activa mediante clase .is-light o .dark:is-light) */
.is-light {
  --sigma-primary: #2563eb;
  --sigma-secondary: #4f46e5;
  --sigma-glow: rgba(37, 99, 235, 0.2);
}

.sigma-svg {
  width: 100%;
  height: 100%;
  filter: url(#glow);
  overflow: visible;
  transition: all 0.5s ease;
}

.is-light.sigma-svg {
  filter: drop-shadow(0 0 8px var(--sigma-glow));
}

.sigma-path-arm,
.sigma-circle-core {
  fill: none;
  stroke-linecap: round;
  stroke-linejoin: round;
}

.sigma-path-arm {
  stroke-width: 9;
  stroke-dasharray: 380;
  stroke-dashoffset: 0;
}

.sigma-path-arm.animate {
  stroke-dashoffset: 380;
  animation: drawArm 2.2s cubic-bezier(0.22, 1, 0.36, 1) forwards 0.2s, float 6s ease-in-out infinite 3s;
}

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

.sigma-dot {
  opacity: 0.8;
}
.sigma-dot.animate {
  opacity: 0;
  animation: fadeIn 1s ease-out forwards 1.5s, pulse 3s infinite 3s;
}

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
