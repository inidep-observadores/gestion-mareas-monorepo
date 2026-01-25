<template>
  <AdminLayout title="Mi Perfil">
    <div class="p-6 space-y-6">
      <div class="flex justify-end">
        <div class="flex gap-3">
            <button 
                @click="goBack"
                class="px-4 py-2 text-sm font-bold text-text-muted bg-surface border border-border rounded-lg hover:bg-surface-muted transition-all uppercase tracking-wider"
                :disabled="isUpdatingProfile"
            >
                Descartar cambios
            </button>
            <button 
                @click="saveAll"
                class="px-4 py-2 text-sm font-bold text-primary-fg bg-primary rounded-lg hover:bg-primary-hover shadow-lg shadow-primary/20 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2 uppercase tracking-wider"
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
          <div class="p-6 bg-surface border border-border rounded-xl shadow-sm">
            <div class="flex flex-col items-center text-center">
              <div class="relative group">
                <div class="w-32 h-32 mb-4 overflow-hidden rounded-full ring-4 ring-border/50">
                  <img
                    :src="getFullImageUrl(previewUrl || user?.avatarUrl)"
                    alt="Avatar"
                    class="object-cover w-full h-full"
                  />
                </div>
                <label
                  class="absolute bottom-4 right-0 p-2 bg-primary rounded-full cursor-pointer hover:bg-primary-hover transition-all shadow-lg shadow-primary/20 active:scale-90"
                  title="Cambiar foto de perfil"
                >
                  <input type="file" class="hidden" accept="image/*" @change="handleFileChange" />
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 text-primary-fg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </label>
              </div>
              
              <h2 class="text-xl font-bold text-text">{{ user?.fullName || 'Usuario' }}</h2>
              <p class="text-text-muted text-sm">{{ user?.email }}</p>
            </div>
          </div>
        </div>

        <!-- Right Column: Edit Forms -->
        <div class="space-y-6 lg:col-span-2">
          
          <!-- Personal Information -->
          <div class="p-6 bg-surface border border-border rounded-xl shadow-sm">
            <h3 class="mb-5 text-lg font-bold text-text uppercase tracking-tight">Información Personal</h3>
            <form @submit.prevent="saveAll">
              <div class="grid grid-cols-1 gap-6">
                <div>
                  <label class="block mb-2 text-sm font-medium text-text-muted">
                    Nombre Completo
                  </label>
                  <input
                    v-model="profileForm.fullName"
                    type="text"
                    class="w-full px-4 py-2 text-text bg-surface border border-border rounded-lg transition-all focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                    placeholder="Ingrese su nombre completo"
                  />
                </div>
              </div>
            </form>
          </div>

          <!-- Security -->
          <div class="p-6 bg-surface border border-border rounded-xl shadow-sm">
            <h3 class="mb-5 text-lg font-bold text-text uppercase tracking-tight">Seguridad</h3>
            <form @submit.prevent="changePassword">
              <div class="space-y-4">
                <!-- Current Password -->
                <div>
                  <label class="block mb-2 text-sm font-medium text-text-muted">
                    Contraseña Actual
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.currentPassword"
                      :type="showCurrentPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-text bg-surface border border-border rounded-lg transition-all focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                      placeholder="********"
                    />
                    <button type="button" @click="showCurrentPassword = !showCurrentPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text transition-colors">
                        <EyeIcon v-if="!showCurrentPassword" class="w-5 h-5" />
                        <EyeSlashIcon v-else class="w-5 h-5" />
                    </button>
                  </div>
                </div>

                <!-- New Password -->
                <div>
                  <label class="block mb-2 text-sm font-medium text-text-muted">
                    Nueva Contraseña
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.newPassword"
                      :type="showNewPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-text bg-surface border border-border rounded-lg transition-all focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                      placeholder="Use al menos 6 caracteres"
                    />
                    <button type="button" @click="showNewPassword = !showNewPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text transition-colors">
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
                            'px-2 py-1 text-[10px] font-bold rounded-md border transition-all uppercase tracking-tighter',
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
                  <label class="block mb-2 text-sm font-medium text-text-muted">
                    Confirmar Contraseña
                  </label>
                  <div class="relative">
                    <input
                      v-model="passwordForm.confirmPassword"
                      :type="showConfirmPassword ? 'text' : 'password'"
                      class="w-full px-4 py-2 text-text bg-surface border border-border rounded-lg transition-all focus:border-primary focus:ring-2 focus:ring-primary/10 outline-none shadow-sm"
                      placeholder="********"
                    />
                    <button type="button" @click="showConfirmPassword = !showConfirmPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-text transition-colors">
                        <EyeIcon v-if="!showConfirmPassword" class="w-5 h-5" />
                        <EyeSlashIcon v-else class="w-5 h-5" />
                    </button>
                  </div>
                  <!-- Match Error -->
                  <p v-if="showMatchError" class="mt-2 text-xs font-bold text-error uppercase tracking-tight">
                    Las contraseñas no coinciden
                  </p>
                 </div>
               </div>
               <div class="mt-6 flex justify-end">
                 <button
                   type="submit"
                   :disabled="isChangingPassword || !isPasswordFormValid"
                   class="px-6 py-2 text-sm font-bold text-primary-fg bg-primary rounded-lg hover:bg-primary-hover shadow-lg shadow-primary/20 transition-all active:scale-95 disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2 uppercase tracking-wider"
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
