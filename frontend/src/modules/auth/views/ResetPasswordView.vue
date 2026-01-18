<template>
  <AuthGlassLayout>
    <div class="glass-card w-full max-w-[440px] p-8 sm:p-10 rounded-3xl relative animate-fade-in-up">
      <!-- Header -->
      <header class="flex items-center gap-6 mb-8">
        <SigmaBranding variant="auth" title="Restablecer Contraseña" subtitle="Defina sus nuevas credenciales." theme="dark" />
      </header>

      <!-- Token Validation State -->
      <div v-if="isValidatingToken" class="py-10 text-center">
         <Loader2 class="animate-spin h-10 w-10 text-primary mx-auto mb-4" />
         <p class="text-gray-300">Verificando enlace...</p>
      </div>

      <div v-else-if="tokenError" class="py-8 text-center text-red-200">
         <div class="w-16 h-16 bg-red-500/10 rounded-full flex items-center justify-center mx-auto mb-4 border-2 border-red-500/20">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
         </div>
         <h3 class="text-lg font-bold">Enlace Invalido o Expirado</h3>
         <p class="mt-2 text-sm opacity-80 mb-6">{{ tokenError }}</p>
         <router-link :to="{ name: 'ForgotPassword' }" class="text-primary font-bold hover:underline">
            Solicitar nuevo enlace
         </router-link>
      </div>

      <div v-else-if="success" class="py-8 text-center">
          <div class="w-16 h-16 bg-green-500/10 rounded-full flex items-center justify-center mx-auto mb-4 text-green-400 border-2 border-green-500/20">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
               <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
            </svg>
          </div>
          <h3 class="text-xl font-bold text-white mb-2">¡Contraseña Restablecida!</h3>
          <p class="text-gray-300 mb-6">Ya puede acceder a su cuenta con sus nuevas credenciales.</p>
          <router-link :to="{ name: 'Signin' }" class="block w-full py-3 rounded-xl bg-primary text-white font-bold text-center hover:bg-primary/90 transition-all">
             Ir al Inicio de Sesión
          </router-link>
      </div>

      <!-- Form -->
      <form v-else @submit.prevent="handleSubmit" class="flex flex-col gap-6">

        <!-- Error Message -->
         <div v-if="errorMessage" class="p-3 bg-red-500/10 border border-red-500/20 rounded-xl flex items-start gap-3 text-sm text-red-200">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
               <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 001 1h2a1 1 0 001-1V6a1 1 0 00-1-1h-2z" clip-rule="evenodd" />
            </svg>
            <span>{{ errorMessage }}</span>
         </div>

         <!-- Password -->
        <div class="space-y-2">
          <label for="password" class="text-sm font-medium text-gray-300 ml-1">Nueva Contraseña</label>
          <div class="relative flex items-center">
            <Lock class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
            <input 
              id="password"
              v-model="password"
              :type="showPassword ? 'text' : 'password'" 
              placeholder="••••••••"
              required
              :disabled="isLoading"
              class="w-full pl-12 pr-12 py-3 rounded-xl bg-black/20 border border-white/10 text-white placeholder:text-gray-500 focus:outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all duration-300 backdrop-blur-sm hover:border-white/20"
            />
             <button 
              type="button" 
              class="absolute right-4 text-gray-400 hover:text-white transition-colors" 
              @click="togglePasswordVisibility"
            >
              <Eye v-if="!showPassword" :size="20" />
              <EyeOff v-else :size="20" />
            </button>
          </div>
           <!-- Password Requirements -->
            <div v-if="password" class="mt-2 flex flex-wrap gap-2">
                   <span
                     v-for="(req, index) in passwordRequirements"
                     :key="index"
                     class="px-2 py-1 text-[10px] font-bold rounded-md border transition-all uppercase tracking-tighter"
                     :class="req.met ? 'bg-green-500/10 text-green-400 border-green-500/20' : 'bg-red-500/10 text-red-400 border-red-500/20'"
                   >
                     {{ req.label }}
                   </span>
            </div>
        </div>

        <!-- Confirm Password -->
         <div class="space-y-2">
            <label for="confirmPassword" class="text-sm font-medium text-gray-300 ml-1">Confirmar Contraseña</label>
            <div class="relative flex items-center">
               <Lock class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
               <input 
                  id="confirmPassword"
                  v-model="confirmPassword"
                  :type="showPassword ? 'text' : 'password'" 
                  placeholder="••••••••"
                  required
                  :disabled="isLoading"
                  class="w-full pl-12 pr-4 py-3 rounded-xl bg-black/20 border border-white/10 text-white placeholder:text-gray-500 focus:outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all duration-300 backdrop-blur-sm hover:border-white/20"
               />
            </div>
         </div>

        <!-- Submit Button -->
        <button 
          type="submit"
          :disabled="isLoading"
          class="relative w-full py-3.5 rounded-xl bg-gradient-to-r from-primary to-blue-600 text-white font-bold tracking-wide shadow-lg shadow-primary/25 hover:shadow-primary/40 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-300 disabled:opacity-70 disabled:cursor-not-allowed disabled:transform-none overflow-hidden"
        >
          <div v-if="isLoading" class="flex items-center justify-center gap-2">
            <Loader2 class="animate-spin" :size="20" />
            <span>ACTUALIZANDO...</span>
          </div>
          <span v-else>RESTABLECER CONTRASEÑA</span>
           <div class="absolute inset-0 -translate-x-full group-hover:animate-shine bg-gradient-to-r from-transparent via-white/20 to-transparent z-10"></div>
        </button>

      </form>
    </div>
  </AuthGlassLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import AuthGlassLayout from '@/components/layout/AuthGlassLayout.vue';
import SigmaBranding from '@/components/brand/SigmaBranding.vue';
import { useAuthStore } from '../stores/auth.store';
import { Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next';

const route = useRoute();
const authStore = useAuthStore();

const token = ref('');
const password = ref('');
const confirmPassword = ref('');
const showPassword = ref(false);
const isLoading = ref(false);
const isValidatingToken = ref(true);
const tokenError = ref('');
const errorMessage = ref('');
const success = ref(false);

const passwordRegex = /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/;
const passwordRequirements = computed(() => [
  { label: 'Min 6 caracteres', met: password.value.length >= 6 },
  { label: 'Mayúscula', met: /[A-Z]/.test(password.value) },
  { label: 'Minúscula', met: /[a-z]/.test(password.value) },
  { label: '# ó Símbolo', met: /(?:\d|\W+)/.test(password.value) }
]);
const isPasswordValid = computed(() => {
  return password.value.length >= 6 && passwordRegex.test(password.value);
});

const togglePasswordVisibility = () => {
    showPassword.value = !showPassword.value;
};

// Validate token on mount
onMounted(async () => {
    token.value = route.query.token as string;
    if (!token.value) {
        tokenError.value = 'No se proporcionó un token de restablecimiento.';
        isValidatingToken.value = false;
        return;
    }

    try {
        // En un escenario real aquí validaríamos el token con el backend
        // await authStore.validateResetToken(token.value);
        isValidatingToken.value = false;
    } catch (error) {
        tokenError.value = 'El enlace ha expirado o es inválido.';
        isValidatingToken.value = false;
    }
});

const handleSubmit = async () => {
    if (password.value !== confirmPassword.value) {
        errorMessage.value = 'Las contraseñas no coinciden.';
        return;
    }

    if (!isPasswordValid.value) {
        errorMessage.value = 'La contraseña no cumple con los requisitos de seguridad.';
        return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
        const result = await authStore.resetPassword(token.value, password.value);
        if (result.ok) {
            success.value = true;
        } else {
            errorMessage.value = result.error?.message || 'Error al restablecer la contraseña.';
        }
    } catch (error: any) {
        errorMessage.value = 'Ocurrió un error inesperado al restablecer la contraseña.';
    } finally {
        isLoading.value = false;
    }
};
</script>

<style scoped>
.glass-card {
  /* Fondo traslúcido oscuro ONLY */
  background: rgba(15, 23, 42, 0.6); 
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4);
}

.animate-fade-in-up {
  animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px) scale(0.98); }
  to { opacity: 1; transform: translateY(0) scale(1); }
}
</style>
