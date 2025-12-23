<template>
  <FullScreenLayout>
    <div class="relative min-h-screen flex items-center justify-center overflow-hidden bg-linear-to-b from-[#000428] to-[#004e92] dark">
      <!-- Background Constellations -->
      <Constellations />
      
      <div class="relative z-10 w-full max-w-md p-8 m-4 bg-white/10 backdrop-blur-md rounded-2xl border border-white/20 shadow-2xl transition-all duration-300 hover:shadow-cyan-500/20">
        <div class="flex flex-col items-center mb-8">
          <div class="mb-4 p-3 bg-white/5 rounded-full ring-1 ring-white/20">
            <img width="180" src="/images/logo/auth-logo.svg" alt="SIGMA Logo" class="drop-shadow-lg" />
          </div>
          <h1 class="text-3xl font-bold text-white tracking-tight">SIGMA</h1>
          <p class="text-cyan-200/70 text-sm mt-1">"Rigor científico en cada registro"</p>
        </div>

        <div class="mb-8 text-center">
          <h2 class="text-xl font-semibold text-white sm:text-2xl">Iniciar Sesión</h2>
          <p class="text-sm text-gray-400 mt-2">Ingrese sus credenciales para acceder al sistema</p>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <!-- Email -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-300 mb-1.5 ml-1">
              Correo Electrónico
            </label>
            <div class="relative group">
              <input
                v-model="email"
                type="email"
                id="email"
                placeholder="usuario@inidep.edu.ar"
                class="w-full h-12 rounded-xl border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
                required
              />
            </div>
          </div>

          <!-- Password -->
          <div>
            <div class="flex items-center justify-between mb-1.5 ml-1">
              <label for="password" class="block text-sm font-medium text-gray-300">
                Contraseña
              </label>
              <router-link
                to="/reset-password"
                class="text-xs text-cyan-400 hover:text-cyan-300 transition-colors"
              >
                ¿Olvidó su contraseña?
              </router-link>
            </div>
            <div class="relative group">
              <input
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                id="password"
                placeholder="••••••••"
                class="w-full h-12 rounded-xl border border-white/10 bg-white/5 px-4 pr-12 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
                required
              />
              <button
                type="button"
                @click="togglePasswordVisibility"
                class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-cyan-400 transition-colors"
              >
                <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.52 13.52 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" y1="2" x2="22" y2="22"/></svg>
              </button>
            </div>
          </div>

          <!-- Remember Me & Register Link -->
          <div class="flex items-center justify-between ml-1">
            <div class="flex items-center">
              <input
                v-model="keepLoggedIn"
                type="checkbox"
                id="keepLoggedIn"
                class="h-4 w-4 rounded border-white/10 bg-white/5 text-cyan-600 focus:ring-cyan-500 focus:ring-offset-0"
              />
              <label for="keepLoggedIn" class="ml-2 block text-sm text-gray-400 cursor-pointer">
                Mantener sesión iniciada
              </label>
            </div>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full h-12 flex items-center justify-center rounded-xl bg-cyan-600 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-cyan-900/20 hover:bg-cyan-500 hover:shadow-cyan-500/40 focus:outline-hidden focus:ring-2 focus:ring-cyan-500 transition-all duration-300 active:scale-[0.98]"
          >
            Ingresar al Sistema
          </button>
        </form>

        <div class="mt-8 pt-6 border-t border-white/10">
          <p class="text-sm font-normal text-center text-gray-400">
            ¿No tiene una cuenta?
            <router-link
              :to="{ name: 'Signup' }"
              class="font-medium text-cyan-400 hover:text-cyan-300 transition-colors ml-1"
            >
              Regístrese aquí
            </router-link>
          </p>
        </div>
      </div>

      <!-- Footer Info -->
      <div class="absolute bottom-6 text-center w-full px-4">
        <p class="text-xs text-white/30 uppercase tracking-widest font-medium">INIDEP - Gestión de Mareas</p>
      </div>
    </div>
  </FullScreenLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue'
import Constellations from '@/modules/shared/components/Constellations.vue'

const router = useRouter()
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const keepLoggedIn = ref(false)

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

const handleSubmit = () => {
  // Simulación de login
  console.log('Login intent:', {
    email: email.value,
    keepLoggedIn: keepLoggedIn.value,
  })
  
  // Redirigir a Home (Dashboard)
  router.push({ name: 'Dashboard' })
}
</script>

<style scoped>
/* Transiciones suaves para el fondo si fuera dinámico */
</style>
