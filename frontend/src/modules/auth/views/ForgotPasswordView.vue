<template>
  <FullScreenLayout>
    <div class="relative p-6 bg-surface z-1 sm:p-0">
      <div
        class="relative flex flex-col justify-center w-full h-screen lg:flex-row bg-surface"
      >
        <div class="flex flex-col flex-1 w-full lg:w-1/2">
          <div class="w-full max-w-md pt-10 mx-auto">
            <router-link
              :to="{ name: 'Signin' }"
              class="inline-flex items-center text-sm text-text-muted transition-colors hover:text-text"
            >
              <svg
                class="stroke-current mr-2"
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                viewBox="0 0 20 20"
                fill="none"
              >
                <path
                  d="M12.7083 5L7.5 10.2083L12.7083 15.4167"
                  stroke=""
                  stroke-width="1.5"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
              Volver al inicio de sesión
            </router-link>
          </div>
          <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
            <div v-if="!isSent">
              <div class="mb-5 sm:mb-8">
                <h1
                  class="mb-2 font-black text-text text-title-sm sm:text-title-md uppercase tracking-tight"
                >
                  Recuperar Contraseña
                </h1>
                <p class="text-sm text-text-muted">
                  Ingrese su correo electrónico para recibir un enlace de recuperación.
                </p>
              </div>
              <div v-if="errorMessage" class="mb-4 p-4 text-sm text-error bg-error/10 border border-error/20 rounded-xl" role="alert">
                <span class="font-bold uppercase tracking-tight mr-1">Error:</span> {{ errorMessage }}
              </div>
              <div>
                <form @submit.prevent="handleSubmit">
                  <div class="space-y-5">
                    <!-- Email -->
                    <div>
                      <label
                        for="email"
                        class="mb-1.5 block text-sm font-bold text-text-muted uppercase tracking-widest text-[10px]"
                      >
                        Correo electrónico<span class="text-error">*</span>
                      </label>
                      <input
                        v-model="email"
                        type="email"
                        id="email"
                        name="email"
                        placeholder="ejemplo@inidep.edu.ar"
                        required
                        class="h-11 w-full rounded-xl border border-border bg-surface-muted px-4 py-2.5 text-sm text-text shadow-theme-xs placeholder:text-text-muted/40 focus:border-primary focus:outline-hidden focus:ring-4 focus:ring-primary/10 transition-all font-medium"
                      />
                    </div>
                    
                    <!-- Button -->
                    <div>
                      <button
                        type="submit"
                        :disabled="isLoading"
                        class="flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-primary-fg transition rounded-xl bg-primary shadow-lg shadow-primary/20 hover:bg-primary/90 disabled:opacity-50 disabled:cursor-not-allowed uppercase tracking-widest"
                      >
                        <span v-if="!isLoading">Enviar Enlace de Recuperación</span>
                        <span v-else class="flex items-center gap-2">
                           <div class="w-4 h-4 border-2 border-primary-fg/30 border-t-primary-fg rounded-full animate-spin"></div>
                           Enviando...
                        </span>
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>

            <!-- Success State -->
            <div v-else class="text-center">
                <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-success/10 border border-success/20">
                    <svg class="h-10 w-10 text-success" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                </div>
                <h2 class="mt-4 text-xl font-black text-text uppercase tracking-tight">¡Correo Enviado!</h2>
                <p class="mt-2 text-text-muted">
                    Si el correo <strong>{{ email }}</strong> está registrado, recibirá el enlace en unos minutos.
                </p>
                <button 
                  @click="isSent = false" 
                  class="mt-6 text-primary hover:text-primary/80 font-bold text-sm uppercase tracking-widest"
                >
                    Probar con otro correo
                </button>
            </div>

          </div>
        </div>
        <div
          class="relative items-center hidden w-full h-full lg:w-1/2 bg-surface-muted lg:grid border-l border-border"
        >
          <div class="flex items-center justify-center z-1">
            <common-grid-shape />
            <div class="flex flex-col items-center max-w-xs">
              <router-link
                :to="{ name: 'Dashboard' }"
                class="flex items-center gap-3 mb-4 text-white"
              >
                <div
                  class="w-12 h-12 rounded-2xl bg-gradient-to-br from-primary to-primary/60 flex items-center justify-center flex-shrink-0 shadow-lg shadow-primary/20"
                >
                  <WaveIcon class="w-7 h-7 text-primary-fg" />
                </div>
                <div class="flex flex-col leading-tight">
                  <span class="text-lg font-black text-text uppercase tracking-tight">Gestión de</span>
                  <span class="text-lg font-black text-primary uppercase tracking-tight">Mareas</span>
                </div>
              </router-link>
              <p class="text-center text-text-muted font-bold tracking-widest uppercase text-[10px]">INIDEP</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </FullScreenLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import CommonGridShape from '@/components/common/CommonGridShape.vue'
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue'
import { WaveIcon } from '@/icons'
import authApi  from '../services/auth.service'

const email = ref('')
const isLoading = ref(false)
const isSent = ref(false)
const errorMessage = ref('')

const handleSubmit = async () => {
  isLoading.value = true
  errorMessage.value = ''
  
  try {
    await authApi.forgotPassword(email.value)
    isSent.value = true
  } catch (error: any) {
    errorMessage.value = error.message || 'Error al enviar el enlace'
    // Usually for security we might not want to show if email exists or not, but depends on requirement.
    // The previous implementation showed error toast.
  } finally {
    isLoading.value = false
  }
}
</script>
