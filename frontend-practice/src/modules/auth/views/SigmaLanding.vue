<script setup lang="ts">
import { onMounted, ref, inject } from 'vue';
import { useRouter } from 'vue-router';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import Waves from '../../shared/components/Waves.vue';
import Constellations from '../../shared/components/Constellations.vue';
import Clouds from '../../shared/components/Clouds.vue';

const router = useRouter();
const isLoaded = ref(false);
const { activeTheme } = inject('theme') as any;

onMounted(() => {
  setTimeout(() => {
    isLoaded.value = true;
  }, 100);
});

const handleEnter = () => {
  router.push({ name: 'Login' });
};
</script>

<template>
  <div :class="['sigma-container', `theme-${activeTheme}`]">
    <Constellations v-if="activeTheme === 'dark'" />
    <Clouds v-else />
    
    <div class="background-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
    </div>

    <div class="content" :class="{ 'visible': isLoaded }">
      <div class="landing-header-horizontal">
        <SigmaBranding variant="landing" :theme="activeTheme" />
      </div>
      
      <button @click="handleEnter" class="cta-button">Ingresar</button>
    </div>

    <Waves />

  </div>
</template>

<style scoped>
/* --- ESTRUCTURA --- */
.sigma-container {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  transition: background-color 0.8s ease;
}

.sigma-container.theme-dark {
  background-color: #0f172a;
  color: white;
}

.sigma-container.theme-light {
  background-color: #bae6fd; /* Cielo azul más profundo */
  color: #0f172a;
}

/* --- BLOBS BACKGROUND --- */
.background-blobs {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 0;
}

.blob {
  position: absolute;
  filter: blur(80px);
  opacity: 0.4;
  border-radius: 50%;
  animation: move 20s infinite alternate;
}

.theme-light .blob {
  opacity: 0.15;
}

.blob-1 {
  width: 400px;
  height: 400px;
  background: linear-gradient(135deg, #38bdf8 0%, #1d4ed8 100%);
  top: -100px;
  left: -100px;
}

.blob-2 {
  width: 350px;
  height: 350px;
  background: linear-gradient(135deg, #818cf8 0%, #4338ca 100%);
  bottom: -50px;
  right: -50px;
  animation-delay: -5s;
}

.blob-3 {
  width: 300px;
  height: 300px;
  background: linear-gradient(135deg, #2dd4bf 0%, #0d9488 100%);
  top: 40%;
  left: 60%;
  animation-delay: -10s;
}

@keyframes move {
  from { transform: translate(0, 0) scale(1); }
  to { transform: translate(100px, 50px) scale(1.1); }
}

/* --- CONTENIDO --- */
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  text-align: center;
  margin-bottom: 10vh;
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 1.5s ease, transform 1.5s ease;
  width: 100%;
  padding: 0 2rem;
  box-sizing: border-box;
}

@media (min-width: 768px) {
  .content {
    margin-bottom: 5vh;
  }
}

.content.visible {
  opacity: 1;
  transform: translateY(0);
}

.landing-header-horizontal {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  margin-bottom: 3rem;
}

@media (max-width: 768px) {
  .landing-header-horizontal {
    flex-direction: column;
    text-align: center;
    gap: 1rem;
  }
}

/* --- BOTÓN --- */
.cta-button {
  background: rgba(0, 242, 255, 0.03);
  color: #00f2ff;
  border: 1px solid rgba(0, 242, 255, 0.5);
  padding: 12px 35px;
  font-size: 0.9rem;
  letter-spacing: 2px;
  cursor: pointer;
  transition: all 0.3s ease;
  text-transform: uppercase;
  border-radius: 4px;
  font-weight: 700;
}

.theme-dark .cta-button:hover {
  background: rgba(0, 242, 255, 0.15);
  border-color: #00f2ff;
  box-shadow: 0 0 15px rgba(0, 242, 255, 0.4);
}

.theme-light .cta-button {
  background: #2563eb;
  color: white;
  border: none;
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.2);
}

.theme-light .cta-button:hover {
  background: #1d4ed8;
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(37, 99, 235, 0.3);
}
</style>
