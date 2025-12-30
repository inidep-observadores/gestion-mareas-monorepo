<template>
  <AdminLayout>
    <div class="p-6 space-y-6">
      <div class="flex items-center justify-between">
        <h1 class="text-2xl font-semibold text-gray-800 dark:text-gray-200">
          Mi Perfil
        </h1>
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
                Guardar
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
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Contraseña Actual
                  </label>
                  <input
                    v-model="passwordForm.currentPassword"
                    type="password"
                    class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                    placeholder="********"
                  />
                </div>
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Nueva Contraseña
                  </label>
                  <input
                    v-model="passwordForm.newPassword"
                    type="password"
                    class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                    placeholder="Use al menos 6 caracteres"
                  />
                </div>
                <div>
                  <label class="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                    Confirmar Contraseña
                  </label>
                  <input
                    v-model="passwordForm.confirmPassword"
                    type="password"
                    class="w-full px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg focus:border-brand-500 focus:ring-brand-500 focus:outline-none dark:bg-gray-800 dark:text-gray-300 dark:border-gray-700"
                    placeholder="********"
                  />
                </div>
              </div>
              <div class="mt-6 flex justify-end">
                <button
                  type="submit"
                  :disabled="isChangingPassword"
                  class="px-6 py-2 text-white bg-gray-600 rounded-lg hover:bg-gray-700 focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-900 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
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
import { ref, reactive, onMounted, onUnmounted } from 'vue';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import { storeToRefs } from 'pinia';
import { toast } from 'vue-sonner';
import { useRouter } from 'vue-router';
import AdminLayout from '@/components/layout/AdminLayout.vue';
import { getFullImageUrl } from '@/helpers/image.helper';

const authStore = useAuthStore();
const router = useRouter();
const { user } = storeToRefs(authStore);

const isUpdatingProfile = ref(false);
const isChangingPassword = ref(false);

const previewUrl = ref('');
const selectedFile = ref<File | null>(null);

const profileForm = reactive({
  fullName: '',
});

const passwordForm = reactive({
  currentPassword: '',
  newPassword: '',
  confirmPassword: ''
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

    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
        toast.error('Las nuevas contraseñas no coinciden');
        return;
    }

    if (passwordForm.newPassword.length < 6) {
        toast.error('La nueva contraseña debe tener al menos 6 caracteres');
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
