<template>
  <AdminLayout title="Mi Perfil">
    <div class="p-6 space-y-6">
      <div class="flex justify-end">
        <div class="flex gap-3">
            <button 
                @click="goBack"
                class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700 dark:hover:bg-gray-700 transition-colors"
                :disabled="isUpdatingProfile"
            >
                Descartar cambios
            </button>
            <button 
                @click="saveAll"
                class="px-4 py-2 text-sm font-medium text-white bg-brand-600 rounded-lg hover:bg-brand-700 focus:ring-4 focus:ring-brand-200 dark:focus:ring-brand-900 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                :disabled="isUpdatingProfile"
            >
                <span v-if="isUpdatingProfile" class="animate-spin h-4 w-4 border-2 border-white border-t-transparent rounded-full"></span>
                Guardar cambios
            </button>
        </div>
      </div>

      <div class="grid grid-cols-1 gap-6 lg:grid-cols-3">
        <!-- Left Column: Personal Info & Avatar -->
        <div class="space-y-6 lg:col-span-1">
          <div class="p-6 bg-white border border-gray-200 rounded-xl dark:bg-gray-900 dark:border-gray-800">
            <div class="flex flex-col items-center text-center">
              <div class="relative group">
                <div class="w-32 h-32 mb-4 overflow-hidden rounded-full ring-4 ring-gray-100 dark:ring-gray-800">
                  <img
                    :src="getFullImageUrl(previewUrl || user?.avatarUrl)"
                    alt="Avatar"
                    class="object-cover w-full h-full"
                  />
                </div>
                <label
                  class="absolute bottom-4 right-0 p-2 bg-brand-500 rounded-full cursor-pointer hover:bg-brand-600 transition-colors shadow-lg"
                  title="Cambiar foto de perfil"
                >
                  <input type="file" class="hidden" accept="image/*" @change="handleFileChange" />
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </label>
              </div>
              
              <h2 class="text-xl font-bold text-gray-800 dark:text-white">{{ user?.fullName || 'Usuario' }}</h2>
              <p class="text-gray-500 dark:text-gray-400">{{ user?.email }}</p>
            </div>
          </div>
        </div>

        <!-- Right Column: Edit Forms -->
        <div class="space-y-6 lg:col-span-2">
          
          <!-- Personal Information -->
          <div class="p-6 bg-white border border-gray-200 rounded-xl dark:bg-gray-900 dark:border-gray-800">
            <h3 class="mb-5 text-lg font-medium text-gray-800 dark:text-white">Información Personal</h3>
            <form @submit.prevent="saveAll">
              <div class="grid grid-cols-1 gap-6">
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Nombre Completo
                  </label>
                  <input
                    v-model="profileForm.fullName"
                    type="text"
                    class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                    placeholder="Ingrese su nombre completo"
                  />
                </div>
              </div>
            </form>
          </div>

          <!-- Security -->
          <div class="p-6 bg-white border border-gray-200 rounded-xl dark:bg-gray-900 dark:border-gray-800">
            <h3 class="mb-5 text-lg font-medium text-gray-800 dark:text-white">Seguridad</h3>
            <form @submit.prevent="changePassword">
              <div class="space-y-4">
                <!-- Current Password -->
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Contraseña Actual
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.currentPassword"
                      :type="showCurrentPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                      placeholder="********"
                    />
                    <button type="button" @click="showCurrentPassword = !showCurrentPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400">
                        <EyeIcon v-if="!showCurrentPassword" class="w-5 h-5" />
                        <EyeSlashIcon v-else class="w-5 h-5" />
                    </button>
                  </div>
                </div>

                <!-- New Password -->
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Nueva Contraseña
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.newPassword"
                      :type="showNewPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                      placeholder="Use al menos 6 caracteres"
                    />
                    <button type="button" @click="showNewPassword = !showNewPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400">
                        <EyeIcon v-if="!showNewPassword" class="w-5 h-5" />
                        <EyeSlashIcon v-else class="w-5 h-5" />
                    </button>
                  </div>
                  
                  <!-- Password Requirements -->
                  <div v-if="passwordForm.newPassword" class="mt-3 flex flex-wrap gap-2">
                        <span
                          v-for="(req, index) in passwordRequirements"
                          :key="index"
                          :class="[
                            'px-2 py-1 text-[10px] rounded-md border transition-colors',
                            req.met
                              ? 'bg-green-50 text-green-700 border-green-200 dark:bg-green-900/20 dark:text-green-400 dark:border-green-800'
                              : 'bg-red-50 text-red-700 border-red-200 dark:bg-red-900/20 dark:text-red-400 dark:border-red-800'
                          ]"
                        >
                          {{ req.label }}
                        </span>
                  </div>
                </div>

                <!-- Confirm Password -->
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Confirmar Contraseña
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.confirmPassword"
                      :type="showConfirmPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                      placeholder="********"
                    />
                    <button type="button" @click="showConfirmPassword = !showConfirmPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 dark:text-gray-400">
                        <EyeIcon v-if="!showConfirmPassword" class="w-5 h-5" />
                        <EyeSlashIcon v-else class="w-5 h-5" />
                    </button>
                  </div>
                  <!-- Match Error -->
                  <p v-if="showMatchError" class="mt-2 text-xs text-red-500 dark:text-red-400">
                    Las contraseñas no coinciden
                  </p>
                </div>
              </div>
              <div class="mt-6 flex justify-end">
                <button
                  type="submit"
                  :disabled="isChangingPassword || !isPasswordFormValid"
                  class="px-6 py-2 text-white bg-brand-600 rounded-lg hover:bg-brand-700 focus:ring-4 focus:ring-brand-200 dark:focus:ring-brand-900 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
                >
                   <span v-if="isChangingPassword" class="animate-spin h-4 w-4 border-2 border-white border-t-transparent rounded-full"></span>
                  Actualizar Contraseña
                </button>
              </div>
            </form>
          </div>

        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, onUnmounted, computed } from 'vue';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { storeToRefs } from 'pinia';
import { toast } from 'vue-sonner';
import { useRouter } from 'vue-router';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import { getFullImageUrl } from '@/helpers/image.helper';
import { EyeIcon, EyeSlashIcon } from '@/icons';

const authStore = useAuthStore();
const router = useRouter();
const { user } = storeToRefs(authStore);

const isUpdatingProfile = ref(false);
const isChangingPassword = ref(false);

const previewUrl = ref('');
const selectedFile = ref<File | null>(null);

const showCurrentPassword = ref(false);
const showNewPassword = ref(false);
const showConfirmPassword = ref(false);

const profileForm = reactive({
  fullName: '',
});

const passwordForm = reactive({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
});

// Password Validation
const passwordRegex = /(?:(?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/;

const passwordRequirements = computed(() => [
  { label: 'Mínimo 6 caracteres', met: passwordForm.newPassword.length >= 6 },
  { label: 'Una mayúscula', met: /[A-Z]/.test(passwordForm.newPassword) },
  { label: 'Una minúscula', met: /[a-z]/.test(passwordForm.newPassword) },
  { label: 'Un número o símbolo', met: /(?:\d|\W+)/.test(passwordForm.newPassword) }
]);

const isPasswordValid = computed(() => {
  return passwordForm.newPassword.length >= 6 && passwordRegex.test(passwordForm.newPassword);
});

const doPasswordsMatch = computed(() => {
    return passwordForm.newPassword === passwordForm.confirmPassword;
});

const showMatchError = computed(() => {
    return passwordForm.newPassword && passwordForm.confirmPassword && !doPasswordsMatch.value;
});

const isPasswordFormValid = computed(() => {
    return passwordForm.currentPassword && isPasswordValid.value && doPasswordsMatch.value;
});

onMounted(() => {
  if (user.value) {
    profileForm.fullName = user.value.fullName;
  }
});

onUnmounted(() => {
    if (previewUrl.value) {
        URL.revokeObjectURL(previewUrl.value);
    }
});

const goBack = () => {
    router.back();
};

const handleFileChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  if (target.files && target.files[0]) {
    const file = target.files[0];
    
    if (!file.type.startsWith('image/')) {
        toast.error('Por favor seleccione un archivo de imagen válido');
        return;
    }

    selectedFile.value = file;
    
    // Create local preview
    if (previewUrl.value) {
        URL.revokeObjectURL(previewUrl.value);
    }
    previewUrl.value = URL.createObjectURL(file);
    toast.info('Imagen seleccionada. Guarde los cambios para aplicar.');
  }
};

const saveAll = async () => {
    if (!profileForm.fullName.trim()) {
        toast.error('El nombre completo es obligatorio');
        return;
    }

    isUpdatingProfile.value = true;
    try {
        let avatarUrl = undefined;
        
        // 1. Upload if there's a selected file
        if (selectedFile.value) {
            const uploadRes = await authStore.uploadOnly(selectedFile.value);
            if (uploadRes.ok && uploadRes.url) {
                avatarUrl = uploadRes.url;
            } else {
                toast.error('Error al subir la imagen. El perfil se guardará sin la foto.');
            }
        }

        // 2. Update profile
        const res = await authStore.updateProfile({ 
            fullName: profileForm.fullName,
            ...(avatarUrl && { avatarUrl })
        });

        if (res.ok) {
            toast.success('Perfil actualizado correctamente');
            router.back();
        } else {
            toast.error('Error al actualizar el perfil');
        }
    } catch (error) {
        toast.error('Ocurrió un error inesperado');
    } finally {
        isUpdatingProfile.value = false;
    }
};

const changePassword = async () => {
    if (!passwordForm.currentPassword || !passwordForm.newPassword || !passwordForm.confirmPassword) {
        toast.error('Todos los campos de contraseña son obligatorios');
        return;
    }

    if (!doPasswordsMatch.value) {
        toast.error('Las nuevas contraseñas no coinciden');
        return;
    }

    if (!isPasswordValid.value) {
        toast.error('La nueva contraseña no cumple con los requisitos de seguridad');
        return;
    }

    isChangingPassword.value = true;
    try {
        const res = await authStore.changePassword({ 
            currentPassword: passwordForm.currentPassword,
            newPassword: passwordForm.newPassword
        });

        if (res.ok) {
            toast.success('Contraseña actualizada correctamente');
            passwordForm.currentPassword = '';
            passwordForm.newPassword = '';
            passwordForm.confirmPassword = '';
        } else { 
             const error = res.error as any;
             if (error?.response?.data?.message) {
                 toast.error(error.response.data.message);
             } else {
                 toast.error('Error al cambiar la contraseña. Verifique su contraseña actual.');
             }
        }
    } catch (error) {
        toast.error('Ocurrió un error inesperado');
    } finally {
        isChangingPassword.value = false;
    }
};
</script>
