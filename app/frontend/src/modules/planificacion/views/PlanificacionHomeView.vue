<template>
  <PlanificacionDashboardLayout
    title="Dashboard de Planificación"
    description="Centro de control para la planificación de mareas y observadores"
  >
    <div class="space-y-10">
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-info/10 text-info">
            <CalenderIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Resumen de Planificación</h2>
        </div>
        
        <div class="p-8 text-center bg-surface border border-border rounded-2xl shadow-sm">
          <h3 class="text-lg font-semibold text-text mb-2">¡Bienvenido al Módulo de Planificación!</h3>
          <p class="text-text-muted max-w-lg mx-auto">
            Este es un espacio en construcción. Pronto encontrarás aquí las herramientas para planificar
            la asignación de observadores, gestión de solicitudes de embarque y la programación de mareas.
          </p>
        </div>
      </section>
    </div>
  </PlanificacionDashboardLayout>
</template>

<script setup lang="ts">
import PlanificacionDashboardLayout from '../layouts/PlanificacionDashboardLayout.vue';
import { CalenderIcon } from '@/icons';
</script>
