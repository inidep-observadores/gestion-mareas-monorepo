<script setup lang="ts">
import { onMounted, ref } from 'vue';
import { useRouter } from 'vue-router';
import SigmaBranding from '@/components/brand/SigmaBranding.vue';
import Atmosphere from '@/components/ui/Atmosphere.vue';

const router = useRouter();
const isLoaded = ref(false);

onMounted(() => {
  setTimeout(() => {
    isLoaded.value = true;
  }, 100);
});

const handleEnter = () => {
  router.push({ name: 'Signin' });
};
</script>

<template>
  <div class="landing-container min-h-screen w-full relative overflow-hidden flex flex-col justify-center items-center">
    <!-- Atmósfera Premium Original -->
    <Atmosphere />

    <!-- Contenido Principal -->
    <main class="content-wrapper relative z-10 flex flex-col items-center text-center px-6"
          :class="{ 'visible': isLoaded }">

      <div class="branding-section">
        <SigmaBranding variant="landing" theme="dark" />
      </div>

      <div class="action-section">
        <button @click="handleEnter" class="cta-button">
          INGRESAR
        </button>
      </div>
    </main>

    <!-- Versión sutil en el pie -->
    <div class="version-tag absolute bottom-8 z-10">
        SIGMA V0.0.1 | INIDEP
    </div>
  </div>
</template>

<style scoped>
.landing-container {
  background-color: #020617;
  height: 100vh;
}

.content-wrapper {
  margin-bottom: 5vh;
  opacity: 0;
  transform: translateY(30px);
  transition: opacity 1.5s ease-out, transform 1.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.content-wrapper.visible {
  opacity: 1;
  transform: translateY(0);
}

.branding-section {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 4rem;
}

/* --- BOTÓN PREMIUM ORIGINAL --- */
.cta-button {
  background: rgba(0, 242, 255, 0.03);
  color: #00f2ff;
  border: 1px solid rgba(0, 242, 255, 0.5);
  padding: 14px 45px;
  font-size: 0.85rem;
  letter-spacing: 4px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
  text-transform: uppercase;
  border-radius: 4px;
  font-weight: 700;
  position: relative;
  overflow: hidden;
}

.cta-button:hover {
  background: rgba(0, 242, 255, 0.15);
  border-color: #00f2ff;
  box-shadow: 0 0 25px rgba(0, 242, 255, 0.4);
  transform: translateY(-2px);
  letter-spacing: 5px;
}

.cta-button:active {
  transform: translateY(0);
}

.version-tag {
  font-family: 'Inter', monospace;
  font-size: 10px;
  color: rgba(255, 255, 255, 0.2);
  letter-spacing: 0.3em;
  font-weight: 300;
}
</style>
