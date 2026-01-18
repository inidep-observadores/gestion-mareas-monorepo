<template>
  <AuthGlassLayout>
    <div class="glass-card w-full max-w-[500px] p-8 rounded-3xl relative animate-fade-in-up">
      <!-- Header -->
      <header class="flex items-center gap-6 mb-8">
        <SigmaBranding variant="auth" title="Nueva Cuenta" subtitle="Únase al sistema SIGMA." theme="dark" />
      </header>

      <!-- Error Message -->
      <div v-if="errorMessage" class="mb-6 p-3 bg-red-500/20 border border-red-500/30 rounded-xl flex items-start gap-3 text-sm text-red-200">
         <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 001 1h2a1 1 0 001-1V6a1 1 0 00-1-1h-2z" clip-rule="evenodd" />
        </svg>
        <span>{{ errorMessage }}</span>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSubmit" class="flex flex-col gap-5">
        
        <!-- Nombre Completo (2 cols en sm) -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div class="space-y-2">
            <label for="fname" class="text-sm font-medium text-gray-300 ml-1">Nombre</label>
            <div class="relative flex items-center">
              <User class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
              <input 
                id="fname"
                v-model="firstName"
                type="text"
                placeholder="Juan"
                required
                :disabled="isLoading"
                class="w-full pl-12 pr-4 py-3 rounded-xl bg-black/20 border border-white/10 text-white placeholder:text-gray-500 focus:outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all duration-300 backdrop-blur-sm hover:border-white/20"
              />
            </div>
          </div>
          <div class="space-y-2">
            <label for="lname" class="text-sm font-medium text-gray-300 ml-1">Apellido</label>
            <div class="relative flex items-center">
              <!-- No icon strictly needed for last name if handled by grid context, or reuse User -->
               <User class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
              <input 
                id="lname"
                v-model="lastName"
                type="text"
                placeholder="Pérez"
                required
                :disabled="isLoading"
                class="w-full pl-12 pr-4 py-3 rounded-xl bg-black/20 border border-white/10 text-white placeholder:text-gray-500 focus:outline-none focus:border-primary focus:ring-4 focus:ring-primary/10 transition-all duration-300 backdrop-blur-sm hover:border-white/20"
              />
            </div>
          </div>
        </div>

        <!-- Email -->
        <div class="space-y-2">
          <label for="email" class="text-sm font-medium text-gray-300 ml-1">Correo Electrónico</label>
          <div class="relative flex items-center">
            <Mail class="absolute left-4 text-gray-400 pointer-events-none" :size="20" />
            <input 
              id="email"
              v-model="email"
              type="email" 
              placeholder="juan@ejemplo.com"
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

        <!-- Checkbox: Terms -->
        <label class="flex items-start gap-3 cursor-pointer group mt-2">
            <div class="relative flex items-center mt-0.5">
              <input type="checkbox" v-model="agreeToTerms" class="peer sr-only" />
              <div class="w-5 h-5 border-2 border-white/20 rounded-md bg-black/20 peer-checked:bg-primary peer-checked:border-primary transition-all duration-200"></div>
              <svg class="absolute w-3.5 h-3.5 text-white left-1 top-1 opacity-0 peer-checked:opacity-100 transition-all duration-200 pointer-events-none" viewBox="0 0 12 12" fill="none">
                 <path d="M10 3L4.5 8.5L2 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            </div>
            <div class="text-sm text-gray-400 leading-tight select-none group-hover:text-gray-200 transition-colors">
              Al crear una cuenta, acepta los
              <router-link :to="{ name: 'Terms' }" target="_blank" class="text-primary font-semibold hover:underline">Términos y Condiciones</router-link>
              y nuestra
              <router-link :to="{ name: 'Privacy' }" target="_blank" class="text-primary font-semibold hover:underline">Política de Privacidad</router-link>.
            </div>
        </label>

        <!-- Submit Button -->
        <button 
          type="submit"
          :disabled="isLoading"
          class="relative w-full py-3.5 mt-2 rounded-xl bg-gradient-to-r from-primary to-blue-600 text-white font-bold tracking-wide shadow-lg shadow-primary/25 hover:shadow-primary/40 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-300 disabled:opacity-70 disabled:cursor-not-allowed disabled:transform-none overflow-hidden"
        >
          <div v-if="isLoading" class="flex items-center justify-center gap-2">
            <Loader2 class="animate-spin" :size="20" />
            <span>REGISTRANDO...</span>
          </div>
          <span v-else>REGISTRARSE</span>
           <div class="absolute inset-0 -translate-x-full group-hover:animate-shine bg-gradient-to-r from-transparent via-white/20 to-transparent z-10"></div>
        </button>

        <!-- Footer -->
        <div class="text-center mt-2 text-sm text-gray-400">
          <p>
            ¿Ya tiene una cuenta? 
            <router-link :to="{ name: 'Signin' }" class="text-primary font-bold hover:text-primary-hover hover:underline transition-all">
              Inicie sesión
            </router-link>
          </p>
        </div>
      </form>

    </div>
  </AuthGlassLayout>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { useRouter } from 'vue-router';
import AuthGlassLayout from '@/components/layout/AuthGlassLayout.vue';
import SigmaBranding from '@/components/brand/SigmaBranding.vue';
import { useAuthStore } from '../stores/auth.store';
import { User, Mail, Lock, Eye, EyeOff, Loader2 } from 'lucide-vue-next';

const router = useRouter();
const authStore = useAuthStore();

const firstName = ref('');
const lastName = ref('');
const email = ref('');
const password = ref('');
const showPassword = ref(false);
const agreeToTerms = ref(false);
const isLoading = ref(false);
const errorMessage = ref('');

// Password Validation
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

const handleSubmit = async () => {
  if (!agreeToTerms.value) {
    errorMessage.value = 'Debe aceptar los términos y condiciones';
    return;
  }

  if (!isPasswordValid.value) {
    errorMessage.value = 'La contraseña no cumple con los requisitos';
    return;
  }

  isLoading.value = true;
  errorMessage.value = '';

  try {
    const result = await authStore.register({
      email: email.value,
      password: password.value,
      fullName: `${firstName.value} ${lastName.value}`.trim()
    });

    if (result.ok) {
      router.push({ name: 'Dashboard' });
    } else {
      errorMessage.value = result.error?.message || 'Error al registrarse';
    }
  } catch (error: any) {
    errorMessage.value = error.message || 'Ocurrió un error inesperado';
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

