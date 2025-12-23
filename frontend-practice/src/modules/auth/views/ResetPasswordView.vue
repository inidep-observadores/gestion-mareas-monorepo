<script setup lang="ts">
import { ref, onMounted, computed, inject } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { toast } from 'vue-sonner';
import { authService } from '@/services/auth.service';
import Constellations from '../../shared/components/Constellations.vue';
import Clouds from '../../shared/components/Clouds.vue';
import Waves from '../../shared/components/Waves.vue';
import SigmaBranding from '@/modules/shared/components/SigmaBranding.vue';
import { Lock, Eye, EyeOff, Loader2, AlertCircle, ArrowLeft } from 'lucide-vue-next';
import SigmaLogo from '../../shared/components/SigmaLogo.vue';

const route = useRoute();
const router = useRouter();
const token = route.query.token as string;

const newPassword = ref('');
const confirmPassword = ref('');
const showPassword = ref(false);
const showConfirmPassword = ref(false);
const isLoading = ref(false);
const isValidating = ref(true);
const isValidToken = ref(false);
const userEmail = ref('');
const { activeTheme } = inject('theme') as any;

// Password validation regex directly from backend ResetPasswordDto
const passwordRegex = /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/;

const isPasswordValid = computed(() => {
  return newPassword.value.length >= 6 && passwordRegex.test(newPassword.value);
});

const passwordRequirements = computed(() => [
  { label: 'Mínimo 6 caracteres', met: newPassword.value.length >= 6 },
  { label: 'Una mayúscula', met: /[A-Z]/.test(newPassword.value) },
  { label: 'Una minúscula', met: /[a-z]/.test(newPassword.value) },
  { label: 'Un número o símbolo', met: /(?:\d|\W+)/.test(newPassword.value) }
]);

onMounted(async () => {
  if (!token) {
    isValidToken.value = false;
    isValidating.value = false;
    return;
  }

  try {
    const data = await authService.validateResetToken(token);
    userEmail.value = data.email || '';
    isValidToken.value = true;
  } catch (error: any) {
    isValidToken.value = false;
  } finally {
    isValidating.value = false;
  }
});

const handleResetPassword = async () => {
  if (newPassword.value !== confirmPassword.value) {
    toast.error('Las contraseñas no coinciden');
    return;
  }

  if (newPassword.value.length < 6) {
    toast.error('La contraseña debe tener al menos 6 caracteres');
    return;
  }

  isLoading.value = true;
  try {
    await authService.resetPassword(token, newPassword.value);
    toast.success('Contraseña restablecida con éxito');
    setTimeout(() => {
      router.push({ name: 'Login' });
    }, 2000);
    // Note: isLoading remains true on success to keep the button disabled during transition
  } catch (error: any) {
    toast.error(error.message || 'Error al restablecer la contraseña');
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

    <div class="glass-card" :class="{ 'error-card': !isValidating && !isValidToken }">
      <!-- Validating State -->
      <div v-if="isValidating" class="status-section">
        <SigmaLogo width="60px" class="mb-4" :theme="activeTheme" />
        <Loader2 class="animate-spin text-blue-400" :size="32" />
        <p class="status-text">Validando enlace...</p>
      </div>

      <!-- Valid Form -->
      <div v-else-if="isValidToken" class="form-section">
        <header class="header-horizontal">
          <SigmaBranding 
            variant="auth" 
            title="Nueva Contraseña" 
            :subtitle="userEmail ? `Restableciendo para ${userEmail}.` : 'Ingrese su nueva contraseña.'" 
            :theme="activeTheme"
          />
        </header>

        <form @submit.prevent="handleResetPassword" class="form">
          <div class="input-group">
            <label for="password">Nueva Contraseña</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input 
                id="password"
                v-model="newPassword" 
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
                <Eye v-if="!showPassword" :size="20" />
                <EyeOff v-else :size="20" />
              </button>
            </div>
            <div v-if="newPassword" class="password-requirements">
              <span 
                v-for="(req, index) in passwordRequirements" 
                :key="index" 
                class="requirement-tag" 
                :class="{ 'is-met': req.met }"
              >
                {{ req.label }}
              </span>
            </div>
          </div>

          <div class="input-group">
            <label for="confirm-password">Confirmar Contraseña</label>
            <div class="input-wrapper">
              <Lock class="input-icon" :size="20" />
              <input 
                id="confirm-password"
                v-model="confirmPassword" 
                :type="showConfirmPassword ? 'text' : 'password'" 
                placeholder="••••••••"
                required
                :disabled="isLoading"
              />
              <button 
                type="button" 
                class="eye-toggle" 
                @click="showConfirmPassword = !showConfirmPassword"
              >
                <Eye v-if="!showConfirmPassword" :size="20" />
                <EyeOff v-else :size="20" />
              </button>
            </div>
            <p v-if="confirmPassword && newPassword !== confirmPassword" class="error-text-small">
              Las contraseñas no coinciden
            </p>
          </div>

          <button 
            type="submit" 
            class="btn-primary" 
            :disabled="isLoading || !isPasswordValid || newPassword !== confirmPassword"
          >
            <template v-if="isLoading">
              <Loader2 class="animate-spin" :size="20" />
              <span>Guardando...</span>
            </template>
            <span v-else>Restablecer Contraseña</span>
          </button>
        </form>
      </div>

      <!-- Invalid Token State (404-like) -->
      <div v-else class="error-content-horizontal">
        <div class="error-icon-wrapper">
          <AlertCircle class="error-icon" :size="64" />
        </div>
        <div class="error-text-wrapper">
          <h2 class="error-title">Enlace Inválido</h2>
          <p class="error-message">
            El enlace ha expirado o es incorrecto.
          </p>
          <router-link :to="{ name: 'ForgotPassword' }" class="btn-primary btn-sm">
            <ArrowLeft :size="18" />
            <span>Solicitar nuevo enlace</span>
          </router-link>
        </div>
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

.error-card {
  max-width: 500px;
  padding: 3rem;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

.logo-section {
  display: none;
}

.header-horizontal {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 2rem;
  text-align: left;
}

.text-wrapper {
  flex: 1;
}

.title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
  text-align: left;
  background: linear-gradient(to right, #f8fafc, #cbd5e1);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
}

.description {
  color: #94a3b8;
  font-size: 0.85rem;
  line-height: 1.4;
  margin-bottom: 0;
  text-align: left;
}

/* Status Section */
.status-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 2rem 0;
}

.status-text {
  margin-top: 1.5rem;
  font-size: 1.1rem;
}

.theme-dark .status-text { color: #94a3b8; }
.theme-light .status-text { color: #64748b; }

/* Error Content (Styled like 404 but horizontal) */
.error-content-horizontal {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  text-align: left;
}

.error-icon-wrapper {
  flex-shrink: 0;
  background: rgba(239, 68, 68, 0.1);
  padding: 1rem;
  border-radius: 20px;
  border: 1px solid rgba(239, 68, 68, 0.2);
}

.error-icon {
  color: #ef4444;
  display: block;
}

.error-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.theme-dark .error-title { color: #f1f5f9; }
.theme-light .error-title { color: #0f172a; }

.error-message {
  font-size: 0.9rem;
  line-height: 1.5;
  margin-bottom: 1.25rem;
}

.theme-dark .error-message { color: #94a3b8; }
.theme-light .error-message { color: #64748b; }

.btn-sm {
  padding: 0.6rem 1rem;
  font-size: 0.9rem;
  width: auto;
  display: inline-flex;
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
  padding: 0.75rem 3.5rem 0.75rem 3rem;
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
  justify-content: center;
  transition: color 0.2s;
}

.eye-toggle:hover {
  color: #38bdf8;
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
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
  width: 100%;
  border: none;
  text-decoration: none;
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

.error-text-small {
  color: #f87171;
  font-size: 0.75rem;
  margin-top: 0.25rem;
  animation: shake 0.4s ease-in-out;
}

@keyframes shake {
  0%, 100% { transform: translateX(0); }
  25% { transform: translateX(5px); }
  75% { transform: translateX(-5px); }
}

.password-requirements {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 0.75rem;
}

.requirement-tag {
  font-size: 0.7rem;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  transition: all 0.3s;
}

.theme-dark .requirement-tag {
  background: rgba(239, 68, 68, 0.1);
  color: #f87171;
  border: 1px solid rgba(239, 68, 68, 0.2);
}

.theme-dark .requirement-tag.is-met {
  background: rgba(34, 197, 94, 0.1);
  color: #4ade80;
  border-color: rgba(34, 197, 94, 0.2);
}

.theme-light .requirement-tag {
  background: #fee2e2;
  color: #ef4444;
  border: 1px solid #fecaca;
}

.theme-light .requirement-tag.is-met {
  background: #dcfce7;
  color: #16a34a;
  border-color: #bbf7d0;
}

@media (max-width: 640px) {
  .glass-card {
    padding: 2rem;
  }
  .error-title {
    font-size: 1.5rem;
  }
}
</style>
