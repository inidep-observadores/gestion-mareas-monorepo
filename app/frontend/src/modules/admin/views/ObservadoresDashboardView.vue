<template>
  <ObservadoresDashboardLayout
    title="Dashboard de Observadores"
    description="Centro de control para la gestión de observadores y sus actividades"
  >
    <div class="space-y-10">
      <!-- Sección: Gestión de Observadores -->
      <section>
        <div class="flex items-center gap-3 mb-6">
          <div class="p-2 rounded-xl bg-primary/10 text-primary">
            <UserCircleIcon class="w-5 h-5" />
          </div>
          <h2 class="text-xl font-bold text-text">Administración General</h2>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <ObservadoresDashboardCard
            title="Lista de Observadores"
            description="Gestiona el padrón de observadores, altas, bajas y modificaciones de datos personales."
            :to="{ name: 'SistemaObservadoresLista' }"
            :icon="UserGroupIcon"
            color="primary"
          />
          <ObservadoresDashboardCard
            title="Presentismo"
            description="Control de inasistencias, licencias, francos compensatorios y vacaciones."
            :to="{ name: 'SistemaObservadoresPresentismo' }"
            :icon="CalenderIcon"
            color="warning"
          />
          <ObservadoresDashboardCard
            title="Feriados nacionales y locales"
            description="Administración de feriados y días no laborables usados en la planificación."
            :to="{ name: 'SistemaObservadoresFeriados' }"
            :icon="CalenderIcon"
            color="error"
          />
          <ObservadoresDashboardCard
            title="Gestión de Novedades"
            description="Registro y ABM de licencias, francos compensatorios y otras novedades de los observadores."
            :to="{ name: 'SistemaObservadoresNovedades' }"
            :icon="DocsIcon"
            color="success"
          />
        </div>
      </section>

      <!-- Sección Informativa / Futuro -->
      <section class="opacity-60 text-center py-10 border-2 border-dashed border-border rounded-3xl">
        <CalenderIcon class="w-10 h-10 text-text-muted mx-auto mb-4" />
        <h3 class="text-lg font-bold text-text">Próximas herramientas</h3>
        <p class="text-sm text-text-muted max-w-sm mx-auto mt-2">
          Estamos trabajando en nuevos módulos para liquidación de viáticos y gestión de capacitaciones.
        </p>
      </section>
    </div>
  </ObservadoresDashboardLayout>
</template>

<script setup lang="ts">
import ObservadoresDashboardLayout from '../layouts/ObservadoresDashboardLayout.vue';
import ObservadoresDashboardCard from '../components/ObservadoresDashboardCard.vue';
import { CalenderIcon, UserCircleIcon, UserGroupIcon, DocsIcon } from '@/icons';
</script>
