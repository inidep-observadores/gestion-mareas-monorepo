<script setup lang="ts">
import { onMounted, ref, computed, inject } from 'vue';
import { useRouter } from 'vue-router';
import { authService } from '@/services/auth.service';
import Constellations from '../../shared/components/Constellations.vue';
import Clouds from '../../shared/components/Clouds.vue';
import Waves from '../../shared/components/Waves.vue';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import { User, Mail, Lock, Loader2, Eye, EyeOff, CheckCircle2, Circle } from 'lucide-vue-next';

const router = useRouter();
const nameInput = ref<HTMLInputElement | null>(null);
const fullName = ref<string>('');
const email = ref<string>('');
const password = ref<string>('');
const confirmPassword = ref<string>('');
const showPassword = ref(false);
const errorMessage = ref<string>('');
const isLoading = ref<boolean>(false);
const { activeTheme } = inject('theme') as any;

// Lógica de foco automático
onMounted(() => {
  const isDesktop = window.innerWidth >= 768;
  if (isDesktop && nameInput.value) {
    setTimeout(() => {
      nameInput.value?.focus();
    }, 300);
  }
});

// Requerimientos de contraseña (Sincronizado con backend)
const passwordRequirements = computed(() => [
  { label: 'Mínimo 6 caracteres', met: password.value.length >= 6 },
  { label: 'Una mayúscula', met: /[A-Z]/.test(password.value) },
  { label: 'Una minúscula', met: /[a-z]/.test(password.value) },
  { label: 'Un número o símbolo', met: /(?:\d|\W+)/.test(password.value) }
]);

const isPasswordValid = computed(() => {
  return passwordRequirements.value.every(req => req.met);
});

const handleRegister = async () => {
  errorMessage.value = '';
  
  if (!isPasswordValid.value) {
    errorMessage.value = 'La contraseña no cumple con los requisitos.';
    return;
  }

  if (password.value !== confirmPassword.value) {
    errorMessage.value = 'Las contraseñas no coinciden.';
    return;
  }

  isLoading.value = true;
  try {
    await authService.register({
      email: email.value,
      password: password.value,
      fullName: fullName.value,
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
        <SigmaBranding variant="auth" title="Nueva Cuenta" subtitle="Únase al sistema SIGMA para comenzar." :theme="activeTheme" />
      </header>

      <form @submit.prevent="handleRegister" class="form">
        <div v-if="errorMessage" class="error-banner">
          {{ errorMessage }}
        </div>

        <div class="input-group">
          <label for="fullName">Nombre Completo</label>
          <div class="input-wrapper">
            <User class="input-icon" :size="20" />
            <input 
              id="fullName"
              ref="nameInput"
              v-model="fullName"
              type="text" 
              placeholder="Juan Pérez"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <div class="input-group">
          <label for="email">Correo Electrónico</label>
          <div class="input-wrapper">
            <Mail class="input-icon" :size="20" />
            <input 
              id="email"
              v-model="email"
              type="email" 
              placeholder="juan@ejemplo.com"
              required
              :disabled="isLoading"
            />
          </div>
        </div>

        <div class="grid-inputs">
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
              >
                <Eye v-if="!showPassword" :size="18" />
                <EyeOff v-else :size="18" />
              </button>
            </div>
          </div>

          <div class="input-group">
            <label for="confirmPassword">Confirmar</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input 
                id="confirmPassword"
                v-model="confirmPassword"
                :type="showPassword ? 'text' : 'password'" 
                placeholder="••••••••"
                required
                :disabled="isLoading"
              />
            </div>
          </div>
        </div>

        <!-- Requerimientos Visuales -->
        <div v-if="password" class="password-requirements">
          <div 
            v-for="(req, index) in passwordRequirements" 
            :key="index"
            class="requirement-item"
            :class="{ 'met': req.met }"
          >
            <CheckCircle2 v-if="req.met" :size="14" />
            <Circle v-else :size="14" />
            <span>{{ req.label }}</span>
          </div>
        </div>

        <button 
          type="submit"
          :disabled="isLoading || !isPasswordValid || password !== confirmPassword"
          class="btn-primary"
        >
          <template v-if="isLoading">
            <Loader2 class="animate-spin" :size="20" />
            <span>REGISTRANDO...</span>
          </template>
          <span v-else>REGISTRARSE</span>
        </button>

        <div class="footer-note">
          <p>
            ¿Ya tiene cuenta? 
            <router-link :to="{ name: 'Login' }" class="link">
              Inicie sesión
            </router-link>
          </p>
        </div>
      </form>
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
  max-width: 480px;
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
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  text-align: left;
}

.grid-inputs {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

@media (max-width: 640px) {
  .grid-inputs {
    grid-template-columns: 1fr;
  }
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

/* Requerimientos de contraseña */
.password-requirements {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 0.5rem;
  padding: 1rem;
  border-radius: 12px;
  transition: all 0.3s ease;
}

.theme-dark .password-requirements {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

.theme-light .password-requirements {
  background: white;
  border: 1px solid #e2e8f0;
}

.requirement-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  color: #64748b;
  transition: all 0.2s;
}

.requirement-item.met {
  color: #2dd4bf;
}
.theme-light .requirement-item.met {
  color: #059669; /* Verde más oscuro para legibilidad en claro */
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
  margin-top: 0.5rem;
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

@media (max-width: 640px) {
  .glass-card {
    padding: 2rem;
  }
}
</style>
