<template>
  <AuthGlassLayout>
    <div class="glass-card w-full max-w-[440px] p-8 sm:p-10 rounded-3xl relative animate-fade-in-up">
      <!-- Header -->
      <header class="flex items-center gap-6 mb-8">
        <SigmaBranding variant="auth" title="Recuperar Cuenta" subtitle="Le enviaremos un código de acceso." theme="dark" />
      </header>
      
      <!-- Content -->
      <div v-if="!emailSent">
         <div class="mb-6 text-sm text-gray-300">
             Ingrese la dirección de correo electrónico asociada a su cuenta y le enviaremos un enlace para restablecer su contraseña.
         </div>

         <!-- Error Message -->
         <div v-if="errorMessage" class="mb-6 p-3 bg-red-500/20 border border-red-500/30 rounded-xl flex items-start gap-3 text-sm text-red-200">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 flex-shrink-0" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 001 1h2a1 1 0 001-1V6a1 1 0 00-1-1h-2z" clip-rule="evenodd" />
            </svg>
            <span>{{ errorMessage }}</span>
         </div>

         <!-- Form -->
         <form @submit.prevent="handleSubmit" class="flex flex-col gap-6">
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

            <button 
              type="submit"
              :disabled="isLoading"
              class="relative w-full py-3.5 rounded-xl bg-gradient-to-r from-[#00f2ff] to-[#0078ff] text-white font-bold tracking-wide shadow-lg shadow-cyan-500/25 hover:shadow-cyan-500/40 hover:-translate-y-0.5 active:translate-y-0 transition-all duration-300 disabled:opacity-70 disabled:cursor-not-allowed disabled:transform-none overflow-hidden"
            >
              <div v-if="isLoading" class="flex items-center justify-center gap-2">
                <Loader2 class="animate-spin" :size="20" />
                <span>ENVIANDO...</span>
              </div>
              <span v-else>ENVIAR ENLACE</span>
              <div class="absolute inset-0 -translate-x-full group-hover:animate-shine bg-gradient-to-r from-transparent via-white/20 to-transparent z-10"></div>
            </button>
         </form>
      </div>

      <!-- Success State -->
      <div v-else class="text-center animate-fade-in-up">
        <div class="w-16 h-16 bg-green-500/10 rounded-full flex items-center justify-center mx-auto mb-4 text-green-400 border-2 border-green-500/20">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
          </svg>
        </div>
        <h3 class="text-xl font-bold text-white mb-2">¡Correo enviado!</h3>
        <p class="text-gray-300 mb-6">
          Si existe una cuenta asociada a <strong>{{ email }}</strong>, recibirá un correo con instrucciones para restablecer su contraseña.
        </p>
        <router-link :to="{ name: 'Signin' }" class="text-[#00f2ff] font-bold hover:text-white transition-all">
          Volver al inicio de sesión
        </router-link>
      </div>

      <!-- Footer -->
      <div class="text-center mt-8 text-sm">
        <router-link :to="{ name: 'Signin' }" class="flex items-center justify-center gap-2 text-gray-400 hover:text-white transition-colors font-medium">
          <ArrowLeft :size="16" />
          Volver al inicio de sesión
        </router-link>
      </div>

    </div>
  </AuthGlassLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import AuthGlassLayout from '@/components/layout/AuthGlassLayout.vue';
import SigmaBranding from '@/components/brand/SigmaBranding.vue';
import { useAuthStore } from '../stores/auth.store';
import { Mail, Loader2, ArrowLeft } from 'lucide-vue-next';

const authStore = useAuthStore();
const email = ref('');
const isLoading = ref(false);
const errorMessage = ref('');
const emailSent = ref(false);

const handleSubmit = async () => {
  isLoading.value = true;
  errorMessage.value = '';

  try {
     const result = await authStore.forgotPassword(email.value);
     if (result.ok) {
        emailSent.value = true;
     } else {
        errorMessage.value = result.error?.message || 'Ocurrió un error al procesar su solicitud.';
     }
  } catch (error: any) {
    errorMessage.value = 'Ocurrió un error inesperado al procesar su solicitud.';
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

