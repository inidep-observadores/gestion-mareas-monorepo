<template>
  <ErrorLayout>
    <template #icon>
      <svg class="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3v18h18M5 15l4-4 3 3 5-5" />
      </svg>
    </template>

    <template #title>Error de Servidor</template>

    <template #description>
      No se pudieron cargar las reglas de negocio del sistema. Para continuar, la configuración debe estar disponible.
      Por favor, intente nuevamente en unos minutos o contacte a soporte.
    </template>

    <template #actions>
      <button
        type="button"
        class="w-full flex items-center justify-center gap-2 px-8 py-4 bg-brand-600 hover:bg-brand-700 text-white rounded-2xl font-bold shadow-lg shadow-brand-500/25 transition-all active:scale-95"
        @click="goBack"
      >
        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
        </svg>
        Volver
      </button>
    </template>
  </ErrorLayout>
</template>

<script setup lang="ts">
import ErrorLayout from '@/components/layout/ErrorLayout.vue'
import { useRouter } from 'vue-router'

const router = useRouter()

const goBack = () => {
  router.back()
}
</script>
