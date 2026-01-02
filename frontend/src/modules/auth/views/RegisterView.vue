<template>
  <FullScreenLayout>
    <div class="relative p-6 bg-white z-1 dark:bg-gray-900 sm:p-0">
      <div
        class="relative flex flex-col justify-center w-full h-screen lg:flex-row dark:bg-gray-900"
      >
        <div class="flex flex-col flex-1 w-full lg:w-1/2">
          <div class="w-full max-w-md pt-10 mx-auto">
            <router-link
              :to="{ name: 'Dashboard' }"
              class="inline-flex items-center text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300"
            >
              <svg
                class="stroke-current"
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
              Volver al inicio
            </router-link>
          </div>
          <!-- Form -->
          <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
            <div class="mb-5 sm:mb-8">
              <h1
                class="mb-2 font-semibold text-gray-800 text-title-sm dark:text-white/90 sm:text-title-md"
              >
                Registrarse
              </h1>
              <p class="text-sm text-gray-500 dark:text-gray-400">
                Ingrese sus datos para crear una cuenta.
              </p>
            </div>

            <div v-if="errorMessage" class="mb-4 p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800" role="alert">
                <span class="font-medium">Error:</span> {{ errorMessage }}
            </div>

            <div>
              <form @submit.prevent="handleSubmit">
                <div class="space-y-5">
                  <div class="grid grid-cols-1 gap-5 sm:grid-cols-2">
                    <!-- First Name -->
                    <div class="sm:col-span-1">
                      <label
                        for="fname"
                        class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"
                      >
                        Nombre<span class="text-error-500">*</span>
                      </label>
                      <input
                        v-model="firstName"
                        type="text"
                        id="fname"
                        name="fname"
                        required
                        placeholder="Ingrese su nombre"
                        class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                      />
                    </div>
                    <!-- Last Name -->
                    <div class="sm:col-span-1">
                      <label
                        for="lname"
                        class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"
                      >
                        Apellido<span class="text-error-500">*</span>
                      </label>
                      <input
                        v-model="lastName"
                        type="text"
                        id="lname"
                        name="lname"
                        required
                        placeholder="Ingrese su apellido"
                        class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                      />
                    </div>
                  </div>
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
                      required
                      placeholder="Ingrese su correo electrónico"
                      class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent px-4 py-2.5 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                    />
                  </div>
                  <!-- Password -->
                  <div>
                    <label
                      for="password"
                      class="mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400"
                    >
                      Contraseña<span class="text-error-500">*</span>
                    </label>
                    <div class="relative">
                      <input
                        v-model="password"
                        :type="showPassword ? 'text' : 'password'"
                        id="password"
                        required
                        placeholder="Ingrese su contraseña"
                        class="dark:bg-dark-900 h-11 w-full rounded-lg border border-gray-300 bg-transparent py-2.5 pl-4 pr-11 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90 dark:placeholder:text-white/30 dark:focus:border-brand-800"
                      />
                      <span
                        @click="togglePasswordVisibility"
                        class="absolute z-30 text-gray-500 -translate-y-1/2 cursor-pointer right-4 top-1/2 dark:text-gray-400"
                      >
                        <svg
                          v-if="!showPassword"
                          class="fill-current"
                          width="20"
                          height="20"
                          viewBox="0 0 20 20"
                          fill="none"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M10.0002 13.8619C7.23361 13.8619 4.86803 12.1372 3.92328 9.70241C4.86804 7.26761 7.23361 5.54297 10.0002 5.54297C12.7667 5.54297 15.1323 7.26762 16.0771 9.70243C15.1323 12.1372 12.7667 13.8619 10.0002 13.8619ZM10.0002 4.04297C6.48191 4.04297 3.49489 6.30917 2.4155 9.4593C2.3615 9.61687 2.3615 9.78794 2.41549 9.94552C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C13.5184 15.3619 16.5055 13.0957 17.5849 9.94555C17.6389 9.78797 17.6389 9.6169 17.5849 9.45932C16.5055 6.30919 13.5184 4.04297 10.0002 4.04297ZM9.99151 7.84413C8.96527 7.84413 8.13333 8.67606 8.13333 9.70231C8.13333 10.7286 8.96527 11.5605 9.99151 11.5605H10.0064C11.0326 11.5605 11.8646 10.7286 11.8646 9.70231C11.8646 8.67606 11.0326 7.84413 10.0064 7.84413H9.99151Z"
                            fill="#98A2B3"
                          />
                        </svg>
                        <svg
                          v-else
                          class="fill-current"
                          width="20"
                          height="20"
                          viewBox="0 0 20 20"
                          fill="none"
                          xmlns="http://www.w3.org/2000/svg"
                        >
                          <path
                            fill-rule="evenodd"
                            clip-rule="evenodd"
                            d="M4.63803 3.57709C4.34513 3.2842 3.87026 3.2842 3.57737 3.57709C3.28447 3.86999 3.28447 4.34486 3.57737 4.63775L4.85323 5.91362C3.74609 6.84199 2.89363 8.06395 2.4155 9.45936C2.3615 9.61694 2.3615 9.78801 2.41549 9.94558C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C11.255 15.3619 12.4422 15.0737 13.4994 14.5598L15.3625 16.4229C15.6554 16.7158 16.1302 16.7158 16.4231 16.4229C16.716 16.13 16.716 15.6551 16.4231 15.3622L4.63803 3.57709ZM12.3608 13.4212L10.4475 11.5079C10.3061 11.5423 10.1584 11.5606 10.0064 11.5606H9.99151C8.96527 11.5606 8.13333 10.7286 8.13333 9.70237C8.13333 9.5461 8.15262 9.39434 8.18895 9.24933L5.91885 6.97923C5.03505 7.69015 4.34057 8.62704 3.92328 9.70247C4.86803 12.1373 7.23361 13.8619 10.0002 13.8619C10.8326 13.8619 11.6287 13.7058 12.3608 13.4212ZM16.0771 9.70249C15.7843 10.4569 15.3552 11.1432 14.8199 11.7311L15.8813 12.7925C16.6329 11.9813 17.2187 11.0143 17.5849 9.94561C17.6389 9.78803 17.6389 9.61696 17.5849 9.45938C16.5055 6.30925 13.5184 4.04303 10.0002 4.04303C9.13525 4.04303 8.30244 4.17999 7.52218 4.43338L8.75139 5.66259C9.1556 5.58413 9.57311 5.54303 10.0002 5.54303C12.7667 5.54303 15.1323 7.26768 16.0771 9.70249Z"
                            fill="#98A2B3"
                          />
                        </svg>
                      </span>
                    </div>

                     <!-- Password Requirements -->
                    <div v-if="password" class="mt-3 flex flex-wrap gap-2">
                           <span
                             v-for="(req, index) in passwordRequirements"
                             :key="index"
                             :class="[
                               'px-2 py-1 text-xs rounded-md border transition-colors',
                               req.met
                                 ? 'bg-green-50 text-green-700 border-green-200 dark:bg-green-900/20 dark:text-green-400 dark:border-green-800'
                                 : 'bg-red-50 text-red-700 border-red-200 dark:bg-red-900/20 dark:text-red-400 dark:border-red-800'
                             ]"
                           >
                             {{ req.label }}
                           </span>
                    </div>
                  </div>
                  <!-- Checkbox -->
                  <div>
                    <div>
                      <label
                        for="checkboxLabelOne"
                        class="flex items-start text-sm font-normal text-gray-700 cursor-pointer select-none dark:text-gray-400"
                      >
                        <div class="relative">
                          <input
                            v-model="agreeToTerms"
                            type="checkbox"
                            id="checkboxLabelOne"
                            class="sr-only"
                          />
                          <div
                            :class="
                              agreeToTerms
                                ? 'border-brand-500 bg-brand-500'
                                : 'bg-transparent border-gray-300 dark:border-gray-700'
                            "
                            class="mr-3 flex h-5 w-5 items-center justify-center rounded-md border-[1.25px]"
                          >
                            <span :class="agreeToTerms ? '' : 'opacity-0'">
                              <svg
                                width="14"
                                height="14"
                                viewBox="0 0 14 14"
                                fill="none"
                                xmlns="http://www.w3.org/2000/svg"
                              >
                                <path
                                  d="M11.6666 3.5L5.24992 9.91667L2.33325 7"
                                  stroke="white"
                                  stroke-width="1.94437"
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                />
                              </svg>
                            </span>
                          </div>
                        </div>
                        <p class="inline-block font-normal text-gray-500 dark:text-gray-400">
                          Al crear una cuenta, acepta los
                          <router-link 
                            :to="{ name: 'Terms' }" 
                            target="_blank" 
                            class="text-gray-800 dark:text-white/90 border-b border-gray-300 hover:text-brand-500 hover:border-brand-500 transition-colors"
                          >
                            Términos y Condiciones
                          </router-link>
                          y nuestra
                          <router-link 
                            :to="{ name: 'Privacy' }" 
                            target="_blank" 
                            class="text-gray-800 dark:text-white border-b border-gray-300 hover:text-brand-500 hover:border-brand-500 transition-colors"
                          >
                            Política de Privacidad
                          </router-link>
                        </p>
                      </label>
                    </div>
                  </div>
                  <!-- Button -->
                  <div>
                    <button
                      type="submit"
                      :disabled="isLoading"
                      class="flex items-center justify-center w-full px-4 py-3 text-sm font-medium text-white transition rounded-lg bg-brand-500 shadow-theme-xs hover:bg-brand-600 disabled:opacity-50 disabled:cursor-not-allowed"
                    >
                      <span v-if="!isLoading">Registrarse</span>
                      <span v-else>Cargando...</span>
                    </button>
                  </div>
                </div>
              </form>
              <div class="mt-5">
                <p
                  class="text-sm font-normal text-center text-gray-700 dark:text-gray-400 sm:text-start"
                >
                  ¿Ya tiene una cuenta?
                  <router-link
                    :to="{ name: 'Signin' }"
                    class="text-brand-500 hover:text-brand-600 dark:text-brand-400"
                    >Inicie sesión</router-link
                  >
                </p>
              </div>
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
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import CommonGridShape from '@/components/common/CommonGridShape.vue'
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue'
import { WaveIcon } from '@/icons'
import { useAuthStore } from '../stores/auth.store'

const router = useRouter()
const authStore = useAuthStore()

const firstName = ref('')
const lastName = ref('')
const email = ref('')
const password = ref('')
const showPassword = ref(false)
const agreeToTerms = ref(false)

const isLoading = ref(false)
const errorMessage = ref('')

// Password Validation
const passwordRegex = /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/

const passwordRequirements = computed(() => [
  { label: 'Mínimo 6 caracteres', met: password.value.length >= 6 },
  { label: 'Una mayúscula', met: /[A-Z]/.test(password.value) },
  { label: 'Una minúscula', met: /[a-z]/.test(password.value) },
  { label: 'Un número o símbolo', met: /(?:\d|\W+)/.test(password.value) }
])

const isPasswordValid = computed(() => {
  return password.value.length >= 6 && passwordRegex.test(password.value)
})

const togglePasswordVisibility = () => {
  showPassword.value = !showPassword.value
}

const handleSubmit = async () => {
  if (!agreeToTerms.value) {
    errorMessage.value = 'Debe aceptar los términos y condiciones'
    return
  }

  if (!isPasswordValid.value) {
    errorMessage.value = 'La contraseña no cumple con los requisitos'
    return
  }

  isLoading.value = true
  errorMessage.value = ''

  try {
    const result = await authStore.register({
      email: email.value,
      password: password.value,
      fullName: `${firstName.value} ${lastName.value}`.trim()
    })

    if (result.ok) {
      router.push({ name: 'Dashboard' })
    } else {
      errorMessage.value = result.error?.message || 'Error al registrarse'
    }
  } catch (error: any) {
    errorMessage.value = error.message || 'Ocurrió un error inesperado'
  } finally {
    isLoading.value = false
  }
}
</script>
