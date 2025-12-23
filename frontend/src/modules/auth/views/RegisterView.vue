<template>
  <FullScreenLayout>
    <div class="relative min-h-screen flex items-center justify-center overflow-hidden bg-linear-to-b from-[#000428] to-[#004e92] dark">
      <!-- Background Constellations -->
      <Constellations />
      
      <div class="relative z-10 w-full max-w-lg p-8 m-4 bg-white/10 backdrop-blur-md rounded-2xl border border-white/20 shadow-2xl transition-all duration-300">
        <div class="flex flex-col items-center mb-8">
          <div class="mb-4 p-3 bg-white/5 rounded-full ring-1 ring-white/20">
            <img width="160" src="/images/logo/auth-logo.svg" alt="SIGMA Logo" class="drop-shadow-lg" />
          </div>
          <h1 class="text-2xl font-bold text-white tracking-tight">SIGMA</h1>
        </div>

        <div class="mb-8 text-center text-white">
          <h2 class="text-xl font-semibold sm:text-2xl">Crear Cuenta</h2>
          <p class="text-sm text-gray-400 mt-2">Complete los datos para solicitar acceso al sistema</p>
        </div>

        <form @submit.prevent="handleSubmit" class="space-y-5">
          <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
            <!-- First Name -->
            <div>
              <label for="fname" class="block text-sm font-medium text-gray-300 mb-1.5 ml-1">
                Nombre
              </label>
              <input
                v-model="firstName"
                type="text"
                id="fname"
                placeholder="Ej: Juan"
                class="w-full h-11 rounded-xl border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
                required
              />
            </div>
            <!-- Last Name -->
            <div>
              <label for="lname" class="block text-sm font-medium text-gray-300 mb-1.5 ml-1">
                Apellido
              </label>
              <input
                v-model="lastName"
                type="text"
                id="lname"
                placeholder="Ej: Pérez"
                class="w-full h-11 rounded-xl border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
                required
              />
            </div>
          </div>

          <!-- Email -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-300 mb-1.5 ml-1">
              Correo Institucional
            </label>
            <input
              v-model="email"
              type="email"
              id="email"
              placeholder="juan.perez@inidep.edu.ar"
              class="w-full h-11 rounded-xl border border-white/10 bg-white/5 px-4 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
              required
            />
          </div>

          <!-- Password -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-300 mb-1.5 ml-1">
              Contraseña
            </label>
            <div class="relative group">
              <input
                v-model="password"
                :type="showPassword ? 'text' : 'password'"
                id="password"
                placeholder="Mínimo 8 caracteres"
                class="w-full h-11 rounded-xl border border-white/10 bg-white/5 px-4 pr-12 py-2.5 text-sm text-white placeholder:text-gray-500 focus:border-cyan-500/50 focus:outline-hidden focus:ring-4 focus:ring-cyan-500/10 transition-all duration-200"
                required
              />
              <button
                type="button"
                @click="togglePasswordVisibility"
                class="absolute right-4 top-1/2 -translate-y-1/2 text-gray-500 hover:text-cyan-400 transition-colors"
                tabindex="-1"
              >
                <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>
                <svg v-else xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.52 13.52 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" y1="2" x2="22" y2="22"/></svg>
              </button>
            </div>
          </div>

          <!-- Terms -->
          <div class="flex items-start ml-1">
            <div class="flex items-center h-5">
              <input
                v-model="agreeToTerms"
                type="checkbox"
                id="terms"
                class="h-4 w-4 rounded border-white/10 bg-white/5 text-cyan-600 focus:ring-cyan-500 focus:ring-offset-0"
                required
              />
            </div>
            <label for="terms" class="ml-2 block text-sm text-gray-400 cursor-pointer">
              Acepto los <span class="text-cyan-400 border-b border-cyan-400/30">términos de servicio</span> y las <span class="text-cyan-400 border-b border-cyan-400/30">políticas de seguridad</span> del INIDEP.
            </label>
          </div>

          <!-- Submit Button -->
          <button
            type="submit"
            class="w-full h-11 flex items-center justify-center rounded-xl bg-cyan-600 px-4 py-3 text-sm font-semibold text-white shadow-lg shadow-cyan-900/20 hover:bg-cyan-500 hover:shadow-cyan-500/40 focus:outline-hidden focus:ring-2 focus:ring-cyan-500 transition-all duration-300 active:scale-[0.98] mt-2"
          >
            Registrar Solicitud
          </button>
        </form>

        <div class="mt-8 pt-6 border-t border-white/10">
          <p class="text-sm font-normal text-center text-gray-400">
            ¿Ya tiene una cuenta habilitada?
            <router-link
              :to="{ name: 'Signin' }"
              class="font-medium text-cyan-400 hover:text-cyan-300 transition-colors ml-1"
            >
              Inicie sesión aquí
            </router-link>
          </p>
        </div>
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
const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const agreeToTerms = ref(false)

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

const handleSubmit = () => {
  console.log('Register request:', {
    firstName: firstName.value,
    lastName: lastName.value,
    email: email.value,
  })
  // Simulación de registro exitoso -> ir a login
  router.push({ name: 'Signin' })
}
</script>
