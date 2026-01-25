<template>
  <AuthGlassLayout>
    <div class="glass-card w-full max-w-[440px] p-8 sm:p-10 rounded-3xl relative animate-fade-in-up">
      <!-- Header -->
      <header class="flex items-center gap-6 mb-8">
        <SigmaBranding variant="auth" title="Bienvenido" subtitle="Ingrese para gestionar sus mareas." theme="dark" />
      </header>

      <!-- Error Message -->
      <div v-if="errorMessage" class="mb-6 p-3 bg-red-500/20 border border-red-500/30 rounded-xl flex items-start gap-3 text-sm text-red-200">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 001 1h2a1 1 0 001-1V6a1 1 0 00-1-1h-2z" clip-rule="evenodd" />
        </svg>
        <span>{{ errorMessage }}</span>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSubmit" class="flex flex-col gap-6">

        <!-- Email -->
        <div class="space-y-2">
          <label for="email" class="text-sm font-medium text-gray-300 ml-1">Correo Electrónico</label>
          <div class="relative flex items-center">
            <Mail class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
            <input
              id="email"
              v-model="email"
              type="email"
              placeholder="admin@obs.com"
              required
              :disabled="isLoading"
              class="w-full pl-12 pr-4 py-3 rounded-xl bg-black/20 border border-white/10 text-white placeholder:text-gray-500 focus:outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all duration-300 backdrop-blur-sm hover:border-white/20"
            />
          </div>
        </div>

        <!-- Password -->
        <div class="space-y-2">
          <label for="password" class="text-sm font-medium text-gray-300 ml-1">Contraseña</label>
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
              title="Mostrar/Ocultar contraseña"
            >
              <Eye v-if="!showPassword" :size="20" />
              <EyeOff v-else :size="20" />
            </button>
          </div>
          <div class="flex justify-end p-1">
            <router-link :to="{ name: 'ForgotPassword' }" class="text-xs font-semibold text-[#00f2ff] hover:text-white transition-all">
              ¿Olvidó su contraseña?
            </router-link>
          </div>
        </div>

        <!-- Checkbox: Maintain Session -->
         <label class="flex items-center gap-3 cursor-pointer group">
            <div class="relative flex items-center">
              <input type="checkbox" v-model="keepLoggedIn" class="peer sr-only" />
              <div class="w-5 h-5 border-2 border-white/20 rounded-md bg-black/20 peer-checked:bg-primary peer-checked:border-primary transition-all duration-200"></div>
              <svg class="absolute w-3.5 h-3.5 text-white left-1 top-1 opacity-0 peer-checked:opacity-100 transition-all duration-200 pointer-events-none" viewBox="0 0 12 12" fill="none">
                 <path d="M10 3L4.5 8.5L2 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <span class="text-sm text-gray-300 group-hover:text-white transition-colors select-none">Mantener sesión iniciada</span>
         </label>

        <!-- Submit Button -->
        <button
          type="submit"
          :disabled="isLoading"
          class="relative w-full py-3.5 rounded-xl bg-gradient-to-r from-[#00f2ff] to-[#0078ff] text-white font-bold tracking-wide shadow-lg shadow-cyan-500/25 hover:shadow-cyan-500/40 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-300 disabled:opacity-70 disabled:cursor-not-allowed disabled:transform-none overflow-hidden"
        >
          <div v-if="isLoading" class="flex items-center justify-center gap-2">
            <Loader2 class="animate-spin" :size="20" />
            <span>INGRESANDO...</span>
          </div>
          <span v-else>INICIAR SESIÓN</span>

          <!-- Shine Effect Overlay -->
          <div class="absolute inset-0 -translate-x-full group-hover:animate-shine bg-gradient-to-r from-transparent via-white/20 to-transparent z-10"></div>
        </button>

        <!-- Footer -->
        <div class="text-center mt-2 text-sm text-gray-400">
          <p>
            ¿No tiene una cuenta?
            <router-link :to="{ name: 'Signup' }" class="text-[#00f2ff] font-bold hover:text-white transition-all">
              Regístrese aquí
            </router-link>
          </p>
        </div>
      </form>

      <!-- Version Tag -->
       <div class="mt-8 text-center">
        <p class="text-[10px] text-white/20 font-mono tracking-widest uppercase">
          SIGMA v0.0.1
        </p>
      </div>

    </div>
  </AuthGlassLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth.store';
import AuthGlassLayout from '@/components/layout/AuthGlassLayout.vue';
import SigmaBranding from '@/components/brand/SigmaBranding.vue';
import { Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next';

// Logic
const router = useRouter();
const authStore = useAuthStore();

const email = ref('');
const password = ref('');
const showPassword = ref(false);
const keepLoggedIn = ref(false);
const isLoading = ref(false);
const errorMessage = ref('');

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value;
};

const handleSubmit = async () => {
  isLoading.value = true;
  errorMessage.value = '';

  try {
    const result = await authStore.login({
      email: email.value,
      password: password.value,
      remember: keepLoggedIn.value
    });

    if (result.ok) {
      const redirect = router.currentRoute.value.query.redirect as string;
      router.push(redirect || { name: 'Dashboard' });
    } else {
      errorMessage.value = result.error?.message || 'Ocurrió un error al iniciar sesión';
    }
  } catch (error: any) {
    errorMessage.value = 'Ocurrió un error inesperado al iniciar sesión';
  } finally {
    isLoading.value = false;
  }
};
</script>

<style scoped>
.glass-card {
  /* Fondo traslúcido oscuro adaptado para auth glass dark */
  background: rgba(15, 23, 42, 0.4); /* Slate 900 con 60% opacidad */
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.1); /* Borde sutil blanco */
  box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4);
}

/* Animación de entrada */
.animate-fade-in-up {
  animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.98);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
</style>

