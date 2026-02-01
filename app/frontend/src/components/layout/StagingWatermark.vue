<template>
  <div v-if="isStaging" class="staging-watermark">
    <div class="watermark-content">
      <span v-for="n in 20" :key="n" class="watermark-text">
        INSTANCIA DE PRUEBA • SIGMA
      </span>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const isStaging = computed(() => {
  // Detecta el modo staging mediante la variable de entorno de Vite
  return import.meta.env.MODE === 'staging'
})
</script>

<style scoped>
.staging-watermark {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
  pointer-events: none;
  overflow: hidden;
  user-select: none;
  opacity: 0.05;
  display: flex;
  align-items: center;
  justify-content: center;
}

.watermark-content {
  display: flex;
  flex-wrap: wrap;
  gap: 100px;
  transform: rotate(-30deg) scale(1.5);
  white-space: nowrap;
}

.watermark-text {
  font-size: 2.5rem;
  font-weight: 800;
  color: #64748b; /* Slate-500 approx */
  letter-spacing: 0.2em;
}

/* En modo oscuro, ajustamos para que se vea sutil también */
:global(.bg-slate-950) .watermark-text {
  color: #94a3b8; /* Slate-400 */
}
</style>
