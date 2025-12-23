<script setup lang="ts">
/**
 * SigmaIntroAnimation (v6 - crisp + glow layers)
 * - Texto serif real y nítido (sin blur en la capa principal)
 * - Glow separado por duplicación de elementos (no filtramos el grupo entero)
 * - Sigma como PATH (no como glifo Σ)
 */

defineProps({
  width: { type: String, default: '100%' },
  height: { type: String, default: '260px' },
});
</script>

<template>
  <div class="intro-wrapper" :style="{ width, height }">
    <svg class="sigma-intro-svg" viewBox="0 0 900 220" role="img" aria-label="SIGMA intro">
      <defs>
        <linearGradient id="neonGradient" x1="0%" y1="0%" x2="100%" y2="0%">
          <stop offset="0%" stop-color="#00f2ff" />
          <stop offset="100%" stop-color="#0078ff" />
        </linearGradient>

        <!-- Glow SOLO para capa glow -->
        <filter id="glow" x="-80%" y="-80%" width="260%" height="260%">
          <feGaussianBlur stdDeviation="3.2" result="b" />
          <feColorMatrix
            in="b"
            type="matrix"
            values="
              1 0 0 0 0
              0 1 0 0 0
              0 0 1 0 0
              0 0 0 1.35 0"
            result="bb"
          />
          <feMerge>
            <feMergeNode in="bb" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>

        <!-- Viñeta suave -->
        <radialGradient id="vignette" cx="50%" cy="45%" r="75%">
          <stop offset="0%" stop-color="#0f1c2e" stop-opacity="0" />
          <stop offset="70%" stop-color="#0f1c2e" stop-opacity="0.35" />
          <stop offset="100%" stop-color="#0a1220" stop-opacity="0.7" />
        </radialGradient>
      </defs>

      <rect x="0" y="0" width="900" height="220" fill="url(#vignette)" />

      <!-- WORDMARK -->
      <g class="word">
        <!-- ====== CAPA GLOW (duplicados con filtro) ====== -->
        <g class="glow-layer" filter="url(#glow)">
          <!-- Sigma glow -->
          <g class="sigma-travel">
            <path class="sigma-path glow-stroke" d="M 0 -58 L 56 -58 L 16 -8 L 56 42 L 0 42" />
          </g>

          <!-- Letras glow -->
          <text class="letter s glow-text" x="260" y="140" text-anchor="middle">S</text>
          <text class="letter i glow-text" x="360" y="140" text-anchor="middle">I</text>
          <text class="letter g glow-text" x="450" y="140" text-anchor="middle">G</text>
          <text class="letter m glow-text" x="540" y="140" text-anchor="middle">M</text>
          <text class="letter a glow-text" x="650" y="140" text-anchor="middle">A</text>
        </g>

        <!-- ====== CAPA NÍTIDA (sin filtro) ====== -->
        <g class="crisp-layer">
          <!-- Sigma nítida (misma animación que la glow) -->
          <g class="sigma-travel">
            <path class="sigma-path" d="M 0 -58 L 56 -58 L 16 -8 L 56 42 L 0 42" />
          </g>

          <text class="letter s" x="260" y="140" text-anchor="middle">S</text>
          <text class="letter i" x="360" y="140" text-anchor="middle">I</text>
          <text class="letter g" x="450" y="140" text-anchor="middle">G</text>

          <!-- M real aparece cuando llega la sigma -->
          <text class="letter m" x="540" y="140" text-anchor="middle">M</text>

          <text class="letter a" x="650" y="140" text-anchor="middle">A</text>
        </g>
      </g>
    </svg>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600;700&display=swap');

.intro-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #0f1c2e;
  overflow: hidden;

  /* ayuda a que se vea más nítido en pantallas comunes */
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.sigma-intro-svg {
  width: 100%;
  height: 100%;

  /* en SVG mejora un poco el rasterizado del texto */
  text-rendering: geometricPrecision;
  shape-rendering: geometricPrecision;
}

/* Tipografía y estilo nítido */
.word text {
  font-family: "Cormorant Garamond", serif;
  font-weight: 700;
  letter-spacing: 0.08em;

  /* CLAVE: fill + stroke finito => bordes más limpios */
  fill: rgba(0, 242, 255, 0.18);
  stroke: url(#neonGradient);
  stroke-width: 2.2;
  paint-order: stroke fill;

  /* evita que parezca “borroneado” por joins raros */
  stroke-linejoin: round;
}

/* Glow layer: más fuerte, pero no afecta al crisp */
.glow-text {
  fill: rgba(0, 242, 255, 0.08);
  stroke-width: 3.2;
  opacity: 0.85;
}

/* ===== Sigma como símbolo PATH ===== */
.sigma-path {
  fill: none;
  stroke: url(#neonGradient);
  stroke-width: 7;
  stroke-linecap: round;
  stroke-linejoin: round;
}

/* Glow de sigma */
.glow-stroke {
  stroke-width: 9;
  opacity: 0.8;
}

/* Posición inicial de la sigma: centrada (cerca de la G),
   luego viaja a la M.
   Usamos un <g> con translate, así no dependés de transform-box. */
.sigma-travel {
  /* Arranca centrada aprox en (450, 120) */
  transform: translate(450px, 120px) scale(1.25);
  transform-origin: 0 0;

  animation:
    sigmaDraw 900ms cubic-bezier(0.22, 1, 0.36, 1) forwards,
    sigmaMove 1300ms cubic-bezier(0.20, 0.85, 0.15, 1) forwards 900ms,
    sigmaOut 220ms ease-out forwards 2150ms;
  opacity: 0;
}

/* Letras: entran nítidas (sin blur) */
.letter {
  font-size: 96px;
  opacity: 0;
  transform: translateY(6px);
  animation: letterIn 520ms cubic-bezier(0.22, 1, 0.36, 1) forwards;
}

/* Stagger luego de que la sigma llegue */
.s { animation-delay: 2300ms; }
.i { animation-delay: 2400ms; }
.g { animation-delay: 2500ms; }
.a { animation-delay: 2700ms; }

/* M aparece sincronizada con el fade de la sigma */
.m {
  animation: mIn 220ms ease-out forwards 2150ms;
  transform: none;
}

/* ===== Animaciones ===== */

@keyframes sigmaDraw {
  0% {
    opacity: 0;
    transform: translate(450px, 120px) scale(1.32);
    filter: none;
  }
  100% {
    opacity: 1;
    transform: translate(450px, 120px) scale(1.25);
  }
}

/* Viaje: (450,120) -> (540,140) y leve rotación */
@keyframes sigmaMove {
  0% {
    transform: translate(450px, 120px) scale(1.25) rotate(0deg);
  }
  100% {
    transform: translate(540px, 140px) scale(0.82) rotate(18deg);
  }
}

/* Crossfade out para revelar la M real */
@keyframes sigmaOut {
  to {
    opacity: 0;
    transform: translate(540px, 140px) scale(0.78) rotate(18deg);
  }
}

@keyframes mIn {
  from { opacity: 0; transform: scale(0.985); }
  to   { opacity: 1; transform: scale(1); }
}

@keyframes letterIn {
  from {
    opacity: 0;
    transform: translateY(6px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .sigma-travel, .letter { animation: none !important; opacity: 1 !important; transform: none !important; }
}
</style>
