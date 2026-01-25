<script setup lang="ts">
import { ref, inject } from 'vue';
import { toast } from 'vue-sonner';
import { authService } from '@/services/auth.service';
import Constellations from '../../shared/components/Constellations.vue';
import Clouds from '../../shared/components/Clouds.vue';
import Waves from '../../shared/components/Waves.vue';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import { Mail, ArrowLeft, Loader2 } from 'lucide-vue-next';

const email = ref('');
const isLoading = ref(false);
const isSent = ref(false);
const { activeTheme } = inject('theme') as any;

const handleForgotPassword = async () => {
  if (!email.value) {
    toast.error('Por favor, ingrese su correo electrónico');
    return;
  }

  isLoading.value = true;
  try {
    await authService.forgotPassword(email.value);
    toast.success('Enlace de recuperación enviado con éxito');
    isSent.value = true;
  } catch (error: any) {
    toast.error(error.message || 'Error al enviar el enlace');
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <div :class="['auth-container', `theme-${activeTheme}`]">
    <Constellations v-if="activeTheme === 'dark'" />
    <Clouds v-else />
    
    <div class="background-blobs">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
      <div class="blob blob-3"></div>
    </div>

    <div class="glass-card">
      <div v-if="!isSent" class="form-section">
        <header class="header-horizontal">
          <SigmaBranding variant="auth" title="Recuperar Acceso" subtitle="Ingrese su correo para recibir el enlace." :theme="activeTheme" />
        </header>

        <form @submit.prevent="handleForgotPassword" class="form">
          <div class="input-group">
            <label for="email">Correo Electrónico</label>
            <div class="input-wrapper">
              <Mail class="input-icon" :size="20" />
              <input 
                id="email"
                v-model="email" 
                type="email" 
                placeholder="usuario@ejemplo.com"
                required
                :disabled="isLoading"
              />
            </div>
          </div>

          <button type="submit" class="btn-primary" :disabled="isLoading">
            <template v-if="isLoading">
              <Loader2 class="animate-spin" :size="20" />
              <span>Enviando...</span>
            </template>
            <span v-else>Enviar Enlace</span>
          </button>
        </form>
      </div>

      <div v-else class="success-section-horizontal bounce-in">
        <div class="success-icon-wrapper">
          <Mail :size="48" :class="activeTheme === 'dark' ? 'text-blue-400' : 'text-blue-600'" />
        </div>
        <div class="success-text-wrapper">
          <h2 class="title">¡Correo Enviado!</h2>
          <p class="description">
            Si el correo <strong>{{ email }}</strong> está registrado, recibirá el enlace en unos minutos.
          </p>
        </div>
      </div>

      <div class="footer">
        <router-link :to="{ name: 'Login' }" class="back-link">
          <ArrowLeft :size="16" />
          <span>Volver al inicio de sesión</span>
        </router-link>
      </div>
    </div>

    <Waves />
  </div>
</template>

<style scoped>
/* --- ESTRUCTURA --- */
.auth-container {
  width: 100%;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  padding: 24px;
  transition: background-color 0.8s ease;
}

.auth-container.theme-dark {
  background-color: #0f172a;
  color: white;
}

.auth-container.theme-light {
  background-color: #f0f9ff;
  color: #0f172a;
}

/* Background Blobs */
.background-blobs {
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  z-index: 0;
}
.blob {
  position: absolute;
  filter: blur(80px);
  opacity: 0.35;
  border-radius: 50%;
  animation: move 20s infinite alternate;
}
.theme-light .blob {
  opacity: 0.15;
}

.blob-1 {
  width: 400px; height: 400px;
  background: linear-gradient(135deg, #38bdf8 0%, #1d4ed8 100%);
  top: -100px; left: -100px;
}
.blob-2 {
  width: 350px; height: 350px;
  background: linear-gradient(135deg, #818cf8 0%, #4338ca 100%);
  bottom: -50px; right: -50px;
  animation-delay: -5s;
}
.blob-3 {
  width: 300px; height: 300px;
  background: linear-gradient(135deg, #2dd4bf 0%, #0d9488 100%);
  top: 40%; left: 60%;
  animation-delay: -10s;
}

@keyframes move {
  from { transform: translate(0, 0) scale(1); }
  to { transform: translate(60px, 30px) scale(1.1); }
}

/* Glass Card */
.glass-card {
  position: relative;
  z-index: 10;
  backdrop-filter: blur(16px);
  border-radius: 24px;
  padding: 2.5rem;
  width: 100%;
  max-width: 440px;
  animation: fadeIn 0.6s ease-out;
  transition: all 0.5s ease;
}

.theme-dark .glass-card {
  background: rgba(255, 255, 255, 0.03);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.theme-light .glass-card {
  background: rgba(255, 255, 255, 0.7);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.05);
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.header-horizontal {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

/* Form Styles */
.form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  text-align: left;
}

.input-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.input-group label {
  font-size: 0.875rem;
  font-weight: 500;
}

.theme-dark label { color: #e2e8f0; }
.theme-light label { color: #64748b; }

.input-wrapper {
  position: relative;
  display: flex;
  align-items: center;
}

.input-icon {
  position: absolute;
  left: 1rem;
  color: #64748b;
  pointer-events: none;
}

.input-wrapper input {
  width: 100%;
  border-radius: 12px;
  padding: 0.75rem 1rem 0.75rem 3rem;
  font-size: 1rem;
  transition: all 0.2s;
}

.theme-dark input {
  background: rgba(15, 23, 42, 0.5);
  border: 1px solid rgba(255, 255, 255, 0.1);
  color: white;
}

.theme-light input {
  background: white;
  border: 1px solid #e2e8f0;
  color: #0f172a;
}

.input-wrapper input:focus {
  outline: none;
  border-color: #38bdf8;
  box-shadow: 0 0 0 3px rgba(56, 189, 248, 0.15);
}

.theme-dark input:focus {
  background: rgba(15, 23, 42, 0.8);
}

.btn-primary {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  padding: 0.875rem;
  border-radius: 12px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
  width: 100%;
  border: none;
}

.btn-primary:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 20px 25px -5px rgba(37, 99, 235, 0.4);
  filter: brightness(1.1);
}

.btn-primary:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

/* Success State (Horizontal) */
.success-section-horizontal {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  text-align: left;
}

.success-icon-wrapper {
  width: 80px;
  height: 80px;
  flex-shrink: 0;
  background: rgba(56, 189, 248, 0.1);
  border-radius: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(56, 189, 248, 0.2);
}

.success-text-wrapper {
  flex: 1;
}

.success-text-wrapper .title {
  margin-bottom: 0.5rem;
  font-size: 1.5rem;
  font-weight: 700;
}

.theme-dark .success-text-wrapper .title {
  background: linear-gradient(to right, #f8fafc, #cbd5e1);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.description {
  font-size: 0.85rem;
  line-height: 1.4;
}

.theme-dark .description { color: #94a3b8; }
.theme-light .description { color: #64748b; }

.bounce-in {
  animation: bounceIn 0.8s cubic-bezier(0.215, 0.61, 0.355, 1);
}

@keyframes bounceIn {
  from { opacity: 0; transform: scale3d(0.3, 0.3, 0.3); }
  20% { transform: scale3d(1.1, 1.1, 1.1); }
  40% { transform: scale3d(0.9, 0.9, 0.9); }
  60% { opacity: 1; transform: scale3d(1.03, 1.03, 1.03); }
  80% { transform: scale3d(0.97, 0.97, 0.97); }
  to { opacity: 1; transform: scale3d(1, 1, 1); }
}

/* Footer */
.footer {
  margin-top: 2rem;
  display: flex;
  justify-content: center;
}

.back-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: #94a3b8;
  text-decoration: none;
  font-size: 0.9rem;
  transition: color 0.2s;
}

.back-link:hover {
  color: #38bdf8;
}
</style>
