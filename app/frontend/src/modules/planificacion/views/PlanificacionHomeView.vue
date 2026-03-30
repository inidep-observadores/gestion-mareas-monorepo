<template>
  <PlanificacionDashboardLayout
    title="Dashboard de Planificación"
    description="Centro de control para la planificación de mareas y observadores"
  >
    <div class="space-y-10">
      <!-- Sección: Gestión de Cobertura -->
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-info/10 text-info">
            <ShipIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Gestión de Cobertura</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <PlanificacionHomeCard
            title="Requerimientos de Cobertura"
            description="Administra la matriz anual de buques requeridos por pesquería y tipo de flota."
            to="/planificacion/requerimientos"
            :icon="ShipIcon"
            color="info"
          />
          <PlanificacionHomeCard
            title="Matriz de Experiencia"
            description="Ranking y evaluación de experiencia de observadores activos por pesquería."
            to="/planificacion/experiencia-observadores"
            :icon="UserGroupIcon"
            color="primary"
          />
        </div>
      </section>

      <!-- Sección Informativa / Futuro -->
      <section class="opacity-60 text-center py-10 border-2 border-dashed border-border rounded-3xl">
        <CalenderIcon class="w-10 h-10 text-text-muted mx-auto mb-4" />
        <h3 class="text-lg font-bold text-text">Próximas herramientas</h3>
        <p class="text-sm text-text-muted max-w-sm mx-auto mt-2">
          Estamos trabajando en módulos de Proyección de Mareas, Asignación de Observadores y Gestión de Solicitudes.
        </p>
      </section>
    </div>
  </PlanificacionDashboardLayout>
</template>

<script setup lang="ts">
import PlanificacionDashboardLayout from '../layouts/PlanificacionDashboardLayout.vue';
import PlanificacionHomeCard from '../components/PlanificacionHomeCard.vue';
import { CalenderIcon, ShipIcon, UserGroupIcon } from '@/icons';
</script>
