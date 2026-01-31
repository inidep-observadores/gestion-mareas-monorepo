<template>
  <div class="waves-container">
    <svg
      class="waves"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      viewBox="0 24 150 28"
      preserveAspectRatio="none"
      shape-rendering="auto"
    >
      <defs>
        <path
          id="gentle-wave"
          d="M-160 44c30 0 58-18 88-18s 58 18 88 18 58-18 88-18 58 18 88 18 v44h-352z"
        />
      </defs>
      <g class="parallax">
        <use
          xlink:href="#gentle-wave"
          x="48"
          y="0"
          fill="rgba(0, 242, 255, 0.7)"
        />
        <use
          xlink:href="#gentle-wave"
          x="48"
          y="3"
          fill="rgba(0, 120, 255, 0.5)"
        />
        <use
          xlink:href="#gentle-wave"
          x="48"
          y="5"
          fill="rgba(0, 80, 200, 0.3)"
        />
        <use
          xlink:href="#gentle-wave"
          x="48"
          y="7"
          fill="rgba(0, 30, 100, 0.9)"
        />
      </g>
    </svg>
  </div>
</template>

<style scoped>
/* --- OLAS SVG (Waves) --- */
.waves-container {
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 25vh; /* Altura de las olas respecto a la pantalla */
  min-height: 100px;
  max-height: 250px;
  z-index: 1; /* Detrás del contenido si se superponen */
}

.waves {
  width: 100%;
  height: 100%;
}

/* Animación de movimiento horizontal */
.parallax > use {
  animation: move-forever 25s cubic-bezier(0.55, 0.5, 0.45, 0.5) infinite;
}
.parallax > use:nth-child(1) {
  animation-delay: -2s;
  animation-duration: 7s;
}
.parallax > use:nth-child(2) {
  animation-delay: -3s;
  animation-duration: 10s;
}
.parallax > use:nth-child(3) {
  animation-delay: -4s;
  animation-duration: 13s;
}
.parallax > use:nth-child(4) {
  animation-delay: -5s;
  animation-duration: 20s;
}

@keyframes move-forever {
  0% {
    transform: translate3d(-90px, 0, 0);
  }
  100% {
    transform: translate3d(85px, 0, 0);
  }
}
</style>
