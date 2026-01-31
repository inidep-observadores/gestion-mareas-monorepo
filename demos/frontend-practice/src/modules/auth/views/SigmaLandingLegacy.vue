<script setup lang="ts">
import { onMounted, ref } from 'vue';

const isLoaded = ref(false);

onMounted(() => {
  // Un pequeño delay para asegurar que la animación de entrada se sienta fluida
  setTimeout(() => {
    isLoaded.value = true;
  }, 100);
});
</script>

<template>
  <div class="sigma-container">
    <div class="ocean">
      <div class="wave"></div>
      <div class="wave"></div>
      <div class="wave"></div>
    </div>

    <div class="content" :class="{ 'visible': isLoaded }">
      
      <div class="logo-wrapper">
        <svg viewBox="0 0 200 200" class="sigma-svg">
          <defs>
            <linearGradient id="sigmaGradient" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="#00f2ff" />
              <stop offset="100%" stop-color="#0078ff" />
            </linearGradient>
            <filter id="glow">
              <feGaussianBlur stdDeviation="3.5" result="coloredBlur"/>
              <feMerge>
                <feMergeNode in="coloredBlur"/>
                <feMergeNode in="SourceGraphic"/>
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

      <h1 class="title">SIGMA</h1>
      <p class="subtitle">SISTEMA INTEGRAL DE GESTIÓN DE MAREAS</p>
      
      <button class="cta-button">Ingresar al Sistema</button>
    </div>
  </div>
</template>

<style scoped>
/* --- 1. Estructura General --- */
.sigma-container {
  position: relative;
  width: 100%;
  height: 100vh;
  /* Fondo un poco más oscuro para resaltar el neon */
  background: radial-gradient(circle at center, #0b1421 0%, #000000 100%);
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: white;
}

/* --- 2. Animación de Fondo (CORREGIDA - AHORA CON RELLENO) --- */
.ocean {
  position: absolute;
  bottom: 0; /* Anclamos al fondo */
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  overflow: hidden;
}

.wave {
  position: absolute;
  bottom: -60%; /* Hundimos el centro de la ola para ver solo la cresta */
  left: -50%;
  width: 200%;
  height: 200%;
  border-radius: 40%;
  background: linear-gradient(to top, rgba(0, 242, 255, 0.05), rgba(0, 120, 255, 0.1));
  animation: rotate 15s linear infinite;
  transform-origin: 50% 48%; /* Eje ligeramente descentrado para crear vaivén */
}

.wave:nth-child(2) {
  bottom: -65%;
  border-radius: 45%;
  background: linear-gradient(to top, rgba(0, 100, 255, 0.05), rgba(0, 242, 255, 0.08));
  animation: rotate 20s linear infinite reverse; /* Gira al revés */
  opacity: 0.7;
}

.wave:nth-child(3) {
  bottom: -70%;
  border-radius: 42%;
  background: linear-gradient(to top, rgba(0, 50, 150, 0.1), transparent);
  animation: rotate 25s linear infinite;
}

@keyframes rotate {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

/* --- 3. Contenido Central --- */
.content {
  z-index: 10; /* Aseguramos que el texto flote SOBRE las olas */
  text-align: center;
  opacity: 0;
  transform: translateY(30px);
  transition: all 1.5s cubic-bezier(0.23, 1, 0.32, 1);
  /* Un suave fondo blur para mejorar lectura si una ola pasa por detrás */
  backdrop-filter: blur(2px); 
}

.content.visible {
  opacity: 1;
  transform: translateY(0);
}

/* --- 4. El Logo SVG Animado --- */
.sigma-svg {
  width: 150px;
  height: 150px;
  margin-bottom: 2rem;
  filter: url(#glow);
}

.sigma-circle {
  fill: none;
  stroke: url(#sigmaGradient);
  stroke-width: 8;
  stroke-linecap: round;
  stroke-dasharray: 200;
  stroke-dashoffset: 200;
  animation: drawLine 2s ease-out forwards 0.5s, float 6s ease-in-out infinite;
}

.sigma-path-base {
  fill: none;
  stroke: url(#sigmaGradient);
  stroke-width: 8;
  stroke-linecap: round;
  stroke-dasharray: 300;
  stroke-dashoffset: 300;
  animation: drawLine 2.5s ease-out forwards 1s, float 6s ease-in-out infinite;
}

@keyframes drawLine {
  to { stroke-dashoffset: 0; }
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* --- 5. Tipografía --- */
.title {
  font-size: 4rem;
  font-weight: 200;
  letter-spacing: 15px;
  margin: 0;
  background: linear-gradient(to right, #fff, #a5f3fc);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 0 30px rgba(0, 242, 255, 0.3);
}

.subtitle {
  font-size: 0.9rem;
  color: #8892b0;
  letter-spacing: 4px;
  margin-top: 1rem;
  margin-bottom: 3rem;
  text-transform: uppercase;
}

/* --- 6. Botón CTA Moderno --- */
.cta-button {
  background: rgba(0, 242, 255, 0.05); /* Leve fondo */
  color: #00f2ff;
  border: 1px solid #00f2ff;
  padding: 15px 40px;
  font-size: 1rem;
  letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  position: relative;
  overflow: hidden;
}

.cta-button:hover {
  background: rgba(0, 242, 255, 0.2);
  box-shadow: 0 0 20px rgba(0, 242, 255, 0.4);
  text-shadow: 0 0 8px rgba(0, 242, 255, 0.8);
}
</style>