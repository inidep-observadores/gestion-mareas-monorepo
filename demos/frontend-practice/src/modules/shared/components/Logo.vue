<template>
  <div class="logo-wrapper mr-10">
    <svg viewBox="0 0 200 200" class="sigma-svg">
      <defs>
        <linearGradient id="sigmaGradient" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" stop-color="#00f2ff" />
          <stop offset="100%" stop-color="#0078ff" />
        </linearGradient>
        <filter id="glow">
          <feGaussianBlur stdDeviation="4" result="coloredBlur" />
          <feMerge>
            <feMergeNode in="coloredBlur" />
            <feMergeNode in="SourceGraphic" />
          </feMerge>
        </filter>
      </defs>
      <path
        d="M 120 50 C 90 50, 70 70, 70 100 C 70 130, 90 150, 130 150 L 160 150"
        class="sigma-path-base"
      />
      <circle cx="130" cy="100" r="30" class="sigma-circle" />
    </svg>
  </div>
</template>

<style scoped>
/* --- LOGO NEON --- */
.sigma-svg {
  width: 140px;
  height: 140px;
  margin-bottom: 1rem;
  filter: url(#glow);
}

.sigma-circle {
  fill: none;
  stroke: url(#sigmaGradient);
  stroke-width: 6; /* Un poco más fino para elegancia */
  stroke-linecap: round;
  stroke-dasharray: 200;
  stroke-dashoffset: 200;
  animation: drawLine 2s ease-out forwards 0.5s, float 6s ease-in-out infinite;
}

.sigma-path-base {
  fill: none;
  stroke: url(#sigmaGradient);
  stroke-width: 6;
  stroke-linecap: round;
  stroke-dasharray: 300;
  stroke-dashoffset: 300;
  animation: drawLine 2.5s ease-out forwards 1s, float 6s ease-in-out infinite;
}

@keyframes drawLine { to { stroke-dashoffset: 0; } }
@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}
</style>
