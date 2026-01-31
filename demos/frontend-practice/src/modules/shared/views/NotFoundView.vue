<template>
  <div class="not-found-container">
    <Constellations />
    <div class="background-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
    </div>
    
    <div class="glass-card">
      <div class="header-horizontal">
        <div class="code-side">
          <h1 class="error-code">404</h1>
        </div>
        <div class="text-side">
          <h2 class="error-title">Página no encontrada</h2>
          <p class="error-message">
            El rumbo que ha tomado no existe en nuestras cartas náuticas.
          </p>
          <router-link :to="homeRoute" class="btn-home">
            <span>Volver al inicio</span>
          </router-link>
        </div>
      </div>
    </div>

    <!-- Nautical Waves -->
    <Waves />
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { authService } from '@/services/auth.service';
import Waves from '../components/Waves.vue';
import Constellations from '../components/Constellations.vue';

const homeRoute = computed(() => {
  return authService.getToken() ? { name: 'DashboardHome' } : { name: 'Landing' };
});
</script>

<style scoped>
.not-found-container {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #0f172a;
  position: relative;
  overflow: hidden;
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  color: white;
  padding: 20px;
}

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

.glass-card {
  position: relative;
  z-index: 10;
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  border: 1px border rgba(255, 255, 255, 0.1);
  border-radius: 24px;
  padding: 3rem;
  width: 100%;
  max-width: 600px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
  animation: fadeIn 0.8s ease-out;
}

.header-horizontal {
  display: flex;
  align-items: center;
  gap: 2.5rem;
  text-align: left;
}

.code-side {
  flex-shrink: 0;
  border-right: 2px solid rgba(255, 255, 255, 0.1);
  padding-right: 2.5rem;
}

.text-side {
  flex: 1;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.error-code {
  font-size: 6rem;
  font-weight: 900;
  margin: 0;
  background: linear-gradient(to bottom, #f8fafc, #94a3b8);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  line-height: 1;
}

.error-title {
  font-size: 1.75rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  color: #f1f5f9;
}

.error-message {
  font-size: 1rem;
  color: #94a3b8;
  line-height: 1.5;
  margin-bottom: 2rem;
}

.btn-home {
  display: inline-flex;
  align-items: center;
  gap: 0.75rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  padding: 1rem 2rem;
  border-radius: 12px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
}

.btn-home:hover {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(37, 99, 235, 0.4);
  filter: brightness(1.1);
}

.btn-home:active {
  transform: translateY(0);
}

@media (max-width: 640px) {
  .glass-card {
    padding: 2rem;
  }
  .error-code {
    font-size: 5rem;
  }
  .error-title {
    font-size: 1.5rem;
  }
}
</style>
