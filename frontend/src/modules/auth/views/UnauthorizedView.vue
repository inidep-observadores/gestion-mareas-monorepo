<template>
  <ErrorLayout>
    <template #icon>
      <svg xmlns="http://www.w3.org/2000/svg" class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
      </svg>
    </template>

    <template #title>Acceso Restringido</template>

    <template #description>
      Su cuenta de <span class="font-bold text-gray-900 dark:text-white">{{ userEmail }}</span> ha sido registrada correctamente, pero aún no tiene los permisos autorizados para operar en el sistema.
      <br /><br />
      Por favor, póngase en contacto con el administrador para que asigne su rol operativo.
    </template>

    <template #actions>
      <button
        @click="handleLogout"
        class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-brand-600 hover:bg-brand-700 text-white rounded-2xl font-bold shadow-lg shadow-brand-500/25 transition-all active:scale-95"
      >
        <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
        </svg>
        Cerrar Sesión
      </button>
    </template>
  </ErrorLayout>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/modules/auth/stores/auth.store';
import ErrorLayout from '@/components/layout/ErrorLayout.vue';

const authStore = useAuthStore();
const router = useRouter();

const userEmail = computed(() => authStore.user?.email || 'su cuenta');

const handleLogout = async () => {
  await authStore.logout();
  router.replace({ name: 'Signin' });
};
</script>
