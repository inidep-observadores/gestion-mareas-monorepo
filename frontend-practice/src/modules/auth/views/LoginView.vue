<script setup lang="ts">
import { onMounted, ref, inject } from 'vue';
import { useRouter } from 'vue-router';
import { authService } from '@/services/auth.service';
import Constellations from '../../shared/components/Constellations.vue';
import Clouds from '../../shared/components/Clouds.vue';
import Waves from '../../shared/components/Waves.vue';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import { Mail, Lock, Loader2, Eye, EyeOff } from 'lucide-vue-next';

const router = useRouter();
const emailInput = ref<HTMLInputElement | null>(null);
const email = ref<string>('');
const password = ref<string>('');
const showPassword = ref(false);
const errorMessage = ref<string>('');
const isLoading = ref<boolean>(false);
const { activeTheme } = inject('theme') as any;

onMounted(() => {
  const isDesktop = window.innerWidth >= 768;
  if (isDesktop && emailInput.value) {
    setTimeout(() => {
      emailInput.value?.focus();
    }, 300);
  }
});

const handleLogin = async () => {
  isLoading.value = true;
  errorMessage.value = '';
  try {
    await authService.login({
      email: email.value,
      password: password.value,
    });
    router.push({ name: 'DashboardHome' });
  } catch (error) {
    errorMessage.value = error instanceof Error ? error.message : 'Error desconocido';
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
      <header class="header-horizontal">
        <SigmaBranding variant="auth" title="Bienvenido" subtitle="Ingrese para gestionar sus mareas." :theme="activeTheme" />
      </header>

      <form @submit.prevent="handleLogin" class="form">
        <div v-if="errorMessage" class="error-banner">
          {{ errorMessage }}
        </div>

        <div class="input-group">
          <label for="email">Correo Electrónico</label>
          <div class="input-wrapper">
            <Mail class="input-icon" :size="20" />
            <input 
              id="email"
              ref="emailInput"
              v-model="email"
              type="email" 
              placeholder="admin@obs.com"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <div class="input-group">
          <label for="password">Contraseña</label>
          <div class="input-wrapper">
            <Lock class="input-icon" :size="20" />
            <input 
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'" 
              placeholder="••••••••"
              required
              :disabled="isLoading"
            />
            <button 
              type="button" 
              class="eye-toggle" 
              @click="showPassword = !showPassword"
              title="Mostrar/Ocultar contraseña"
            >
              <Eye v-if="!showPassword" :size="20" />
              <EyeOff v-else :size="20" />
            </button>
          </div>
          <div class="flex-end-mobile">
            <router-link :to="{ name: 'ForgotPassword' }" class="forgot-link">
              ¿Olvidó su contraseña?
            </router-link>
          </div>
        </div>

        <button 
          type="submit"
          :disabled="isLoading"
          class="btn-primary"
        >
          <template v-if="isLoading">
            <Loader2 class="animate-spin" :size="20" />
            <span>INGRESANDO...</span>
          </template>
          <span v-else>INICIAR SESIÓN</span>
        </button>

        <div class="footer-note">
          <p>
            ¿No tiene una cuenta? 
            <router-link :to="{ name: 'Register' }" class="link">
              Regístrese aquí
            </router-link>
          </p>
        </div>
      </form>

      <div class="version-tag">
        &copy; 2025 SIGMA Systems. Versión 1.0
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

.form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  text-align: left;
}

.error-banner {
  background: rgba(239, 68, 68, 0.1);
  border: 1px solid rgba(239, 68, 68, 0.2);
  color: #f87171;
  padding: 0.75rem;
  border-radius: 12px;
  font-size: 0.875rem;
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

.eye-toggle {
  position: absolute;
  right: 1rem;
  background: none;
  border: none;
  color: #64748b;
  cursor: pointer;
  display: flex;
  align-items: center;
}

.eye-toggle:hover {
  color: #38bdf8;
}

.flex-end-mobile {
  display: flex;
  justify-content: flex-end;
}

.forgot-link {
  font-size: 0.75rem;
  color: #38bdf8;
  text-decoration: none;
  transition: opacity 0.2s;
}

.forgot-link:hover {
  opacity: 0.8;
  text-decoration: underline;
}

.btn-primary {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
  color: white;
  padding: 0.875rem 1.5rem;
  border-radius: 12px;
  font-weight: 600;
  border: none;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
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

.footer-note {
  font-size: 0.875rem;
  color: #94a3b8;
  text-align: center;
}

.footer-note .link {
  color: #38bdf8;
  font-weight: 600;
  text-decoration: none;
}

.footer-note .link:hover {
  text-decoration: underline;
}

.version-tag {
  margin-top: 2rem;
  font-size: 0.75rem;
  color: #64748b;
  text-align: center;
}

@media (max-width: 640px) {
  .glass-card {
    padding: 2rem;
  }
}
</style>
