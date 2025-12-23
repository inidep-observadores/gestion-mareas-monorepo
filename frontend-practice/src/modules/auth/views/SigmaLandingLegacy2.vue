<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import SigmaLogo from '../../shared/components/SigmaLogo.vue';
import Waves from '../../shared/components/Waves.vue';

const router = useRouter();
const isLoaded = ref(false);

onMounted(() => {
  setTimeout(() => {
    isLoaded.value = true;
  }, 100);
});

const handleEnter = () => {
  router.push('/auth/login');
};
</script>

<template>
  <div class="sigma-container">
    
    <div class="content" :class="{ 'visible': isLoaded }">
      <SigmaLogo class="mr-16" />

      <h1 class="title">SIGMA</h1>
      <p class="subtitle">SISTEMA INTEGRAL DE GESTIÓN DE MAREAS</p>
      
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
  background: linear-gradient(180deg, #02060b 0%, #0f1c2e 100%);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  justify-content: center; /* Centra el contenido verticalmente */
  align-items: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  color: white;
}

/* --- CONTENIDO --- */
.content {
  display: flex;
  flex-direction: column;
  align-items: center;
  z-index: 10;
  text-align: center;
  margin-bottom: 10vh; /* Subimos un poco el texto para alejarlo de las olas */
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 1.5s ease, transform 1.5s ease;
  width: 100%;             /* Asegura que tome el ancho de la pantalla */
  padding: 0 2rem;         /* Agrega "aire" (aprox 32px) a izquierda y derecha */
  box-sizing: border-box;  /* Evita que el padding sume al ancho total y genere scroll horizontal */
}

.content.visible {
  opacity: 1;
  transform: translateY(0);
}

/* --- TIPOGRAFÍA --- */
.title {
  /* TAMAÑO MÓVIL (Por defecto) */
  font-size: 3rem;           /* Mucho más pequeño para que quepa */
  letter-spacing: 0.5rem;    /* Menos espacio entre letras */
  font-weight: 100;
  margin: 0;
  background: linear-gradient(to bottom, #ffffff, #85e8ff);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 0 0 20px rgba(0, 242, 255, 0.4);
  
  /* Asegura que si la palabra es muy larga, no rompa el layout */
  max-width: 100%;
  word-wrap: break-word;
}

/* TAMAÑO ESCRITORIO (Media Query) */
@media (min-width: 768px) {
  .title {
    font-size: 5rem;         /* Volvemos al tamaño gigante en PC */
    letter-spacing: 1.5rem;
  }
}

.subtitle {
  /* TAMAÑO MÓVIL */
  font-size: 0.7rem;        /* Letra más pequeña */
  letter-spacing: 0.15rem;  /* Menos aire */
  line-height: 1.5;         /* Mejor lectura si ocupa 2 líneas */
  
  color: #a0aec0;
  margin-top: 0.5rem;
  margin-bottom: 2.5rem;
  text-transform: uppercase;
  font-weight: 500;
  
  /* Asegura que el texto respete el padding del contenedor */
  max-width: 100%; 
}

@media (min-width: 768px) {
  .subtitle {
    font-size: 0.85rem;
    letter-spacing: 0.3rem;
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
  border-radius: 2px;
}

.cta-button:hover {
  background: rgba(0, 242, 255, 0.15);
  border-color: #00f2ff;
  box-shadow: 0 0 15px rgba(0, 242, 255, 0.4);
}
</style>
