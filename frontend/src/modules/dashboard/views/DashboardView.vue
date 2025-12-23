<template>
  <AdminLayout>
    <div class="relative min-h-[calc(100vh-100px)] z-1">
      <div class="grid grid-cols-12 gap-4 md:gap-6">
        <div class="col-span-12 space-y-6 xl:col-span-12">
          <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-800 dark:text-white/90">Panel de Control</h1>
            <p class="text-gray-500 dark:text-gray-400">
              Resumen general de las operaciones de marea.
            </p>
          </div>
        </div>

        <!-- KPIs de Mareas con Stat Component -->
        <div class="col-span-12 grid grid-cols-1 gap-4 md:grid-cols-2 xl:grid-cols-4">
          <Stat
            title="Mareas Activas"
            :value="47"
            description="+12% vs mes anterior"
            :icon="WaveIcon"
            color="primary"
            variant="bordered"
            trend="up"
          />

          <Stat
            title="Observadores en Mar"
            :value="23"
            description="Activos actualmente"
            :icon="UserGroupIcon"
            color="info"
            variant="bordered"
            trend="neutral"
          />

          <Stat
            title="Alertas Pendientes"
            :value="5"
            description="Requieren atención"
            :icon="WarningIcon"
            color="warning"
            variant="bordered"
            trend="neutral"
          />

          <Stat
            title="Mareas Finalizadas"
            :value="142"
            description="Este mes"
            :icon="CheckIcon"
            color="success"
            variant="bordered"
            trend="up"
          />
        </div>

        <!-- Mareas Recientes -->
        <div class="col-span-12 xl:col-span-8">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
          >
            <div class="mb-6 flex items-center justify-between">
              <h2 class="text-lg font-bold text-gray-800 dark:text-white">Actividad Reciente</h2>
              <button class="text-sm text-brand-500 hover:text-brand-600 font-medium">
                Ver todas
              </button>
            </div>
            <div class="space-y-4">
              <div
                v-for="item in recentActivity"
                :key="item.id"
                class="flex items-center gap-4 p-4 rounded-xl hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
              >
                <div
                  :class="[
                    'w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0',
                    item.bgColor,
                  ]"
                >
                  <component :is="item.icon" class="w-5 h-5 text-white" />
                </div>
                <div class="flex-1">
                  <h4 class="font-medium text-gray-800 dark:text-white">{{ item.title }}</h4>
                  <p class="text-sm text-gray-500">{{ item.description }}</p>
                </div>
                <span class="text-xs text-gray-400">{{ item.time }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Estado de Flota -->
        <div class="col-span-12 xl:col-span-4">
          <div
            class="bg-white dark:bg-gray-900 border border-gray-200 dark:border-gray-800 rounded-2xl p-6 shadow-sm"
          >
            <div class="mb-6">
              <h2 class="text-lg font-bold text-gray-800 dark:text-white">Estado de Flota</h2>
            </div>
            <div class="space-y-4">
              <div
                v-for="status in fleetStatus"
                :key="status.label"
                class="flex items-center justify-between"
              >
                <div class="flex items-center gap-3">
                  <div :class="['w-3 h-3 rounded-full', status.color]"></div>
                  <span class="text-sm text-gray-600 dark:text-gray-400">{{ status.label }}</span>
                </div>
                <span class="text-sm font-bold text-gray-800 dark:text-white">{{
                  status.count
                }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import Stat from '@/components/common/Stat.vue'
import { WaveIcon, UserGroupIcon, WarningIcon, CheckIcon, CalenderIcon, DocsIcon } from '@/icons'

const recentActivity = ref([
  {
    id: 1,
    icon: WaveIcon,
    bgColor: 'bg-brand-500',
    title: 'Nueva marea designada',
    description: 'BP ARGENTINO I - Observador: Juan Díaz',
    time: 'hace 2h',
  },
  {
    id: 2,
    icon: CheckIcon,
    bgColor: 'bg-green-500',
    title: 'Marea finalizada',
    description: 'BP MAR DEL SUR - Datos validados',
    time: 'hace 5h',
  },
  {
    id: 3,
    icon: WarningIcon,
    bgColor: 'bg-orange-500',
    title: 'Alerta generada',
    description: 'BP UNION - Revisión de datos requerida',
    time: 'hace 1d',
  },
  {
    id: 4,
    icon: DocsIcon,
    bgColor: 'bg-blue-500',
    title: 'Informe generado',
    description: 'Resumen mensual de actividad',
    time: 'hace 2d',
  },
])

const fleetStatus = ref([
  { label: 'Designada', color: 'bg-brand-500', count: 12 },
  { label: 'Navegando', color: 'bg-blue-500', count: 18 },
  { label: 'Arribada', color: 'bg-green-500', count: 8 },
  { label: 'En Revisión', color: 'bg-orange-500', count: 5 },
  { label: 'Finalizada', color: 'bg-gray-500', count: 4 },
])
</script>

<style scoped>
/* Estilos específicos para el dashboard de mareas */
</style>
