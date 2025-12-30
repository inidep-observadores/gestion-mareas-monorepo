<template>
  <FullScreenLayout>
    <div class="relative p-6 bg-white z-1 dark:bg-gray-900 sm:p-0">
      <div
        class="relative flex flex-col justify-center w-full h-screen lg:flex-row dark:bg-gray-900"
      >
        <div class="flex flex-col flex-1 w-full lg:w-1/2">
          <div class="w-full max-w-md pt-10 mx-auto">
            <router-link
              :to="{ name: 'Signin' }"
              class="inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
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
                  class="mb-2 font-semibold text-gray-800 text-title-sm dark:text-white/90 sm:text-title-md"
                >
                  Recuperar Contraseña
                </h1>
                <p class="text-sm text-gray-500 dark:text-gray-400">
                  Ingrese su correo electrónico para recibir un enlace de recuperación.
                </p>
              </div>
              <div v-if="errorMessage" class="mb-4 p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800" role="alert">
                <span class="font-medium">Error:</span> {{ errorMessage }}
              </div>
              <div>
                <form @submit.prevent="handleSubmit">
                  <div class="space-y-5">
                    <!-- Email -->
                    <div>
                      <label
                        for="email"
                        class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"
                      >
                        Correo electrónico<span class="text-error-500">*</span>
                      </label>
                      <input
                        v-model="email"
                        type="email"
                        id="email"
                        name="email"
                        placeholder="info@gmail.com"
                        required
                        class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                      />
                    </div>
                    
                    <!-- Button -->
                    <div>
                      <button
                        type="submit"
                        :disabled="isLoading"
                        class="flex items-center justify-center w-full px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        <span v-if="!isLoading">Enviar Enlace</span>
                        <span v-else>Enviando...</span>
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>

            <!-- Success State -->
            <div v-else class="text-center">
                <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-green-100 dark:bg-green-900/30">
                    <svg class="h-10 w-10 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                </div>
                <h2 class="mt-4 text-xl font-bold text-gray-800 dark:text-white">¡Correo Enviado!</h2>
                <p class="mt-2 text-gray-500 dark:text-gray-400">
                    Si el correo <strong>{{ email }}</strong> está registrado, recibirá el enlace en unos minutos.
                </p>
                <button 
                  @click="isSent = false" 
                  class="mt-6 text-brand-500 hover:text-brand-600 font-medium text-sm"
                >
                    Probar con otro correo
                </button>
            </div>

          </div>
        </div>
        <div
          class="relative items-center hidden w-full h-full lg:w-1/2 bg-brand-950 dark:bg-white/5 lg:grid"
        >
          <div class="flex items-center justify-center z-1">
            <common-grid-shape />
            <div class="flex flex-col items-center max-w-xs">
              <router-link
                :to="{ name: 'Dashboard' }"
                class="flex items-center gap-3 mb-4 text-white"
              >
                <div
                  class="w-12 h-12 rounded-2xl bg-gradient-to-br from-blue-500 to-cyan-500 flex items-center justify-center flex-shrink-0"
                >
                  <WaveIcon class="w-7 h-7 text-white" />
                </div>
                <div class="flex flex-col leading-tight">
                  <span class="text-lg font-bold text-white">Gestión de</span>
                  <span class="text-lg font-bold text-blue-200">Mareas</span>
                </div>
              </router-link>
              <p class="text-center text-gray-400 dark:text-white/60">INIDEP</p>
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
