<template>
  <ObservadoresDashboardLayout
    title="Presentismo de Observadores"
    description="Control de inasistencias, licencias, francos compensatorios y vacaciones."
  >
    <div class="flex flex-col items-center justify-center min-h-[60vh] text-center space-y-6">
      <div class="p-6 bg-warning/10 rounded-full text-warning">
        <CalenderIcon class="w-16 h-16" />
      </div>
      
      <div class="space-y-2">
        <h2 class="text-2xl font-bold text-text">Módulo en Desarrollo</h2>
        <p class="text-text-muted max-w-md mx-auto">
          Esta vista es un mockup. Pronto podrás gestionar desde aquí las inasistencias, licencias, francos compensatorios y vacaciones del personal.
        </p>
      </div>

      <div class="pt-8">
        <router-link
          :to="{ name: 'SistemaObservadores' }"
          class="inline-flex items-center px-6 py-3 bg-surface border border-border rounded-xl text-sm font-semibold text-text hover:bg-surface-muted transition-colors"
        >
          Volver al Dashboard
        </router-link>
      </div>
    </div>
  </ObservadoresDashboardLayout>
</template>

<script setup lang="ts">
import ObservadoresDashboardLayout from '../layouts/ObservadoresDashboardLayout.vue';
import { CalenderIcon } from '@/icons';
</script>
