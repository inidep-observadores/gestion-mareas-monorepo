<template>
  <FullScreenLayout>
    <div class="relative p-6 bg-surface z-1 sm:p-0">
      <div
        class="relative flex flex-col justify-center w-full h-screen lg:flex-row bg-surface"
      >
        <div class="flex flex-col flex-1 w-full lg:w-1/2">
          
          <div class="flex flex-col justify-center flex-1 w-full max-w-md mx-auto">
            
            <!-- Validating State -->
            <div v-if="isValidating" class="text-center">
                <div class="flex justify-center mb-4">
                     <svg class="animate-spin h-10 w-10 text-primary" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                </div>
                <p class="text-text-muted">Verificando enlace...</p>
            </div>

            <!-- Form State (Valid Token) -->
            <div v-else-if="isValidToken">
                <div class="mb-5 sm:mb-8">
                    <h1
                    class="mb-2 font-semibold text-text text-title-sm sm:text-title-md"
                    >
                    Restablecer Contraseña
                    </h1>
                    <p class="text-sm text-text-muted">
                    Ingrese su nueva contraseña para la cuenta <strong>{{ userEmail }}</strong>.
                    </p>
                </div>

                <div v-if="errorMessage" class="mb-4 p-4 text-sm text-error bg-error/10 border border-error/20 rounded-lg" role="alert">
                    <span class="font-medium">Error:</span> {{ errorMessage }}
                </div>

                <form @submit.prevent="handleResetPassword">
                    <div class="space-y-5">
                    <!-- New Password -->
                    <div>
                        <label
                        for="password"
                        class="mb-1.5 block text-sm font-medium text-text-muted"
                        >
                        Nueva Contraseña<span class="text-error">*</span>
                        </label>
                        <div class="relative">
                            <input
                            v-model="newPassword"
                            :type="showPassword ? 'text' : 'password'"
                            id="password"
                            required
                            placeholder="mínimo 6 caracteres"
                            class="h-11 w-full rounded-lg border border-border bg-surface py-2.5 pl-4 pr-11 text-sm text-text transition-all placeholder:text-text-muted/50 focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                            />
                            <span
                            @click="showPassword = !showPassword"
                            class="absolute z-30 text-text-muted -translate-y-1/2 cursor-pointer right-4 top-1/2"
                            >
                             <svg v-if="!showPassword" class="fill-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M10.0002 13.8619C7.23361 13.8619 4.86803 12.1372 3.92328 9.70241C4.86804 7.26761 7.23361 5.54297 10.0002 5.54297C12.7667 5.54297 15.1323 7.26762 16.0771 9.70243C15.1323 12.1372 12.7667 13.8619 10.0002 13.8619ZM10.0002 4.04297C6.48191 4.04297 3.49489 6.30917 2.4155 9.4593C2.3615 9.61687 2.3615 9.78794 2.41549 9.94552C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C13.5184 15.3619 16.5055 13.0957 17.5849 9.94555C17.6389 9.78797 17.6389 9.6169 17.5849 9.45932C16.5055 6.30919 13.5184 4.04297 10.0002 4.04297ZM9.99151 7.84413C8.96527 7.84413 8.13333 8.67606 8.13333 9.70231C8.13333 10.7286 8.96527 11.5605 9.99151 11.5605H10.0064C11.0326 11.5605 11.8646 10.7286 11.8646 9.70231C11.8646 8.67606 11.0326 7.84413 10.0064 7.84413H9.99151Z" /></svg>
                             <svg v-else class="fill-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.63803 3.57709C4.34513 3.2842 3.87026 3.2842 3.57737 3.57709C3.28447 3.86999 3.28447 4.34486 3.57737 4.63775L4.85323 5.91362C3.74609 6.84199 2.89363 8.06395 2.4155 9.45936C2.3615 9.61694 2.3615 9.78801 2.41549 9.94558C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C11.255 15.3619 12.4422 15.0737 13.4994 14.5598L15.3625 16.4229C15.6554 16.7158 16.1302 16.7158 16.4231 16.4229C16.716 16.13 16.716 15.6551 16.4231 15.3622L4.63803 3.57709ZM12.3608 13.4212L10.4475 11.5079C10.3061 11.5423 10.1584 11.5606 10.0064 11.5606H9.99151C8.96527 11.5606 8.13333 10.7286 8.13333 9.70237C8.13333 9.5461 8.15262 9.39434 8.18895 9.24933L5.91885 6.97923C5.03505 7.69015 4.34057 8.62704 3.92328 9.70247C4.86803 12.1373 7.23361 13.8619 10.0002 13.8619C10.8326 13.8619 11.6287 13.7058 12.3608 13.4212ZM16.0771 9.70249C15.7843 10.4569 15.3552 11.1432 14.8199 11.7311L15.8813 12.7925C16.6329 11.9813 17.2187 11.0143 17.5849 9.94561C17.6389 9.78803 17.6389 9.61696 17.5849 9.45938C16.5055 6.30925 13.5184 4.04303 10.0002 4.04303C9.13525 4.04303 8.30244 4.17999 7.52218 4.43338L8.75139 5.66259C9.1556 5.58413 9.57311 5.54303 10.0002 5.54303C12.7667 5.54303 15.1323 7.26768 16.0771 9.70249Z" /></svg>
                            </span>
                        </div>
                        <!-- Password Requirements -->
                        <div v-if="newPassword" class="mt-3 flex flex-wrap gap-2">
                           <span
                             v-for="(req, index) in passwordRequirements"
                             :key="index"
                             :class="[
                               'px-2 py-1 text-xs rounded-md border transition-colors',
                               req.met
                                 ? 'bg-success/10 text-success border-success/20'
                                 : 'bg-error/10 text-error border-error/20'
                             ]"
                           >
                             {{ req.label }}
                           </span>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label
                        for="confirmPassword"
                        class="mb-1.5 block text-sm font-medium text-text-muted"
                        >
                        Confirmar Contraseña<span class="text-error">*</span>
                        </label>
                        <div class="relative">
                            <input
                            v-model="confirmPassword"
                            :type="showConfirmPassword ? 'text' : 'password'"
                            id="confirmPassword"
                            required
                            placeholder="repita su contraseña"
                            class="h-11 w-full rounded-lg border border-border bg-surface py-2.5 pl-4 pr-11 text-sm text-text transition-all placeholder:text-text-muted/50 focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                            />
                            <span
                            @click="showConfirmPassword = !showConfirmPassword"
                            class="absolute z-30 text-text-muted -translate-y-1/2 cursor-pointer right-4 top-1/2"
                            >
                                <svg v-if="!showConfirmPassword" class="fill-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M10.0002 13.8619C7.23361 13.8619 4.86803 12.1372 3.92328 9.70241C4.86804 7.26761 7.23361 5.54297 10.0002 5.54297C12.7667 5.54297 15.1323 7.26762 16.0771 9.70243C15.1323 12.1372 12.7667 13.8619 10.0002 13.8619ZM10.0002 4.04297C6.48191 4.04297 3.49489 6.30917 2.4155 9.4593C2.3615 9.61687 2.3615 9.78794 2.41549 9.94552C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C13.5184 15.3619 16.5055 13.0957 17.5849 9.94555C17.6389 9.78797 17.6389 9.6169 17.5849 9.45932C16.5055 6.30919 13.5184 4.04297 10.0002 4.04297ZM9.99151 7.84413C8.96527 7.84413 8.13333 8.67606 8.13333 9.70231C8.13333 10.7286 8.96527 11.5605 9.99151 11.5605H10.0064C11.0326 11.5605 11.8646 10.7286 11.8646 9.70231C11.8646 8.67606 11.0326 7.84413 10.0064 7.84413H9.99151Z" /></svg>
                                <svg v-else class="fill-current" width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.63803 3.57709C4.34513 3.2842 3.87026 3.2842 3.57737 3.57709C3.28447 3.86999 3.28447 4.34486 3.57737 4.63775L4.85323 5.91362C3.74609 6.84199 2.89363 8.06395 2.4155 9.45936C2.3615 9.61694 2.3615 9.78801 2.41549 9.94558C3.49488 13.0957 6.48191 15.3619 10.0002 15.3619C11.255 15.3619 12.4422 15.0737 13.4994 14.5598L15.3625 16.4229C15.6554 16.7158 16.1302 16.7158 16.4231 16.4229C16.716 16.13 16.716 15.6551 16.4231 15.3622L4.63803 3.57709ZM12.3608 13.4212L10.4475 11.5079C10.3061 11.5423 10.1584 11.5606 10.0064 11.5606H9.99151C8.96527 11.5606 8.13333 10.7286 8.13333 9.70237C8.13333 9.5461 8.15262 9.39434 8.18895 9.24933L5.91885 6.97923C5.03505 7.69015 4.34057 8.62704 3.92328 9.70247C4.86803 12.1373 7.23361 13.8619 10.0002 13.8619C10.8326 13.8619 11.6287 13.7058 12.3608 13.4212ZM16.0771 9.70249C15.7843 10.4569 15.3552 11.1432 14.8199 11.7311L15.8813 12.7925C16.6329 11.9813 17.2187 11.0143 17.5849 9.94561C17.6389 9.78803 17.6389 9.61696 17.5849 9.45938C16.5055 6.30925 13.5184 4.04303 10.0002 4.04303C9.13525 4.04303 8.30244 4.17999 7.52218 4.43338L8.75139 5.66259C9.1556 5.58413 9.57311 5.54303 10.0002 5.54303C12.7667 5.54303 15.1323 7.26768 16.0771 9.70249Z" /></svg>
                            </span>
                        </div>
                    </div>
                   
                    <div>
                        <button
                        type="submit"
                        :disabled="isLoading || newPassword !== confirmPassword"
                        class="flex items-center justify-center w-full px-4 py-3 text-sm font-bold text-primary-fg transition-all rounded-lg bg-primary shadow-lg shadow-primary/20 hover:bg-primary-hover hover:shadow-xl hover:shadow-primary/30 active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed uppercase tracking-wider"
                        >
                        <span v-if="!isLoading">Restablecer Contraseña</span>
                        <span v-else class="flex items-center gap-2">
                           <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                             <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                             <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                           </svg>
                           Guardando...
                        </span>
                        </button>
                    </div>
                    </div>
                </form>
            </div>

             <!-- Invalid Token State -->
             <div v-else class="text-center">
                <div class="mx-auto flex h-20 w-20 items-center justify-center rounded-full bg-error/10">
                    <svg class="h-10 w-10 text-error" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </div>
                <h2 class="mt-4 text-xl font-bold text-text">Enlace Inválido</h2>
                <p class="mt-2 text-text-muted">
                    El enlace ha expirado o es incorrecto.
                </p>
                <router-link
                    :to="{ name: 'ForgotPassword' }"
                    class="mt-6 inline-flex text-primary hover:text-primary-hover font-bold text-sm transition-colors"
                >
                    Solicitar nuevo enlace
                </router-link>
            </div>

          </div>
        </div>
        <div
          class="relative items-center hidden w-full h-full lg:w-1/2 bg-surface-muted border-l border-border lg:grid"
        >
          <div class="flex items-center justify-center z-1">
            <common-grid-shape />
            <div class="flex flex-col items-center max-w-xs">
              <router-link
                :to="{ name: 'Dashboard' }"
                class="flex items-center gap-3 mb-4"
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
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import CommonGridShape from '@/components/common/CommonGridShape.vue'
import FullScreenLayout from '@/components/layout/FullScreenLayout.vue'
import { WaveIcon } from '@/icons'
import authApi from '../services/auth.service'

const route = useRoute()
const router = useRouter()
const token = route.query.token as string

const newPassword = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)

const isLoading = ref(false)
const isValidating = ref(true)
const isValidToken = ref(false)
const errorMessage = ref('')
const userEmail = ref('')

// Password Validation
const passwordRegex = /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/

const passwordRequirements = computed(() => [
  { label: 'Mínimo 6 caracteres', met: newPassword.value.length >= 6 },
  { label: 'Una mayúscula', met: /[A-Z]/.test(newPassword.value) },
  { label: 'Una minúscula', met: /[a-z]/.test(newPassword.value) },
  { label: 'Un número o símbolo', met: /(?:\d|\W+)/.test(newPassword.value) }
])

const isPasswordValid = computed(() => {
  return newPassword.value.length >= 6 && passwordRegex.test(newPassword.value)
})

onMounted(async () => {
    if (!token) {
        isValidToken.value = false
        isValidating.value = false
        return
    }

    try {
        const data = await authApi.validateResetToken(token)
        userEmail.value = data.email || ''
        isValidToken.value = true
    } catch (error) {
        isValidToken.value = false
    } finally {
        isValidating.value = false
    }
})

const handleResetPassword = async () => {
    if (newPassword.value !== confirmPassword.value) {
        errorMessage.value = 'Las contraseñas no coinciden'
        return
    }
    
    if (!isPasswordValid.value) {
        errorMessage.value = 'La contraseña no cumple con los requisitos'
        return
    }

    isLoading.value = true
    errorMessage.value = ''

    try {
        await authApi.resetPassword({ token, newPassword: newPassword.value })
        router.push({ name: 'Signin' })
    } catch (error: any) {
        errorMessage.value = error.message || 'Error al restablecer la contraseña'
    } finally {
        isLoading.value = false
    }
}
</script>
