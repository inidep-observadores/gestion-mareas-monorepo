<template>
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 xl:gap-6">
    <div
      v-for="kpi in kpis"
      :key="kpi.title"
      class="group relative overflow-hidden rounded-2xl border border-gray-100 bg-white p-5 shadow-sm transition-all hover:shadow-xl hover:-translate-y-1 dark:border-gray-800 dark:bg-gray-900"
    >
      <!-- Background Decorative Gradient -->
      <div
        class="absolute -right-4 -top-4 h-24 w-24 rounded-full opacity-5 blur-3xl transition-opacity group-hover:opacity-10"
        :class="kpi.bgClass"
      ></div>

      <div class="flex items-center justify-between gap-4">
        <div class="z-10">
          <p class="text-[10px] font-black uppercase tracking-widest text-gray-400 dark:text-gray-500">
            {{ kpi.title }}
          </p>
          <div class="flex items-baseline gap-2">
            <h3 class="mt-1 text-3xl font-black text-gray-900 dark:text-white leading-none">
              {{ kpi.value }}
            </h3>
            <span v-if="kpi.trend" class="text-[10px] font-bold px-1.5 py-0.5 rounded-md" :class="kpi.trendClass">
              {{ kpi.trend }}
            </span>
          </div>
          <p v-if="kpi.subtext" class="mt-2 text-[11px] font-bold text-gray-500 dark:text-gray-400">
            {{ kpi.subtext }}
          </p>
        </div>
        <div
          :class="[
            'flex h-12 w-12 items-center justify-center rounded-2xl transition-all group-hover:rotate-12 group-hover:scale-110 shadow-sm',
            kpi.iconContainerClass,
          ]"
        >
          <component :is="kpi.icon" class="h-6 w-6" :class="kpi.iconClass" />
        </div>
      </div>
      
      <!-- Progress Bar for Monthly Target -->
      <div v-if="kpi.progress !== undefined" class="mt-4">
        <div class="flex justify-between items-center mb-1.5">
           <span class="text-[9px] font-black text-gray-400 uppercase tracking-tighter">Progreso Objetivo</span>
           <span class="text-[9px] font-black text-brand-500">{{ kpi.progress }}%</span>
        </div>
        <div class="h-1.5 w-full rounded-full bg-gray-50 dark:bg-gray-800 overflow-hidden">
          <div
            class="h-full rounded-full bg-brand-500 transition-all duration-1000 ease-out"
            :style="{ width: kpi.progress + '%' }"
          ></div>
        </div>
      </div>

      <!-- Drill-down link overlay -->
      <router-link
        :to="kpi.link"
        class="absolute inset-0 z-10"
        aria-label="Ver detalles"
      ></router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { toast } from 'vue-sonner'
import { ShipIcon, UserGroupIcon, TaskIcon, CheckIcon } from '@/icons'
import mareasService, { type DashboardKpis } from '@/modules/mareas/services/mareas.service'

type DashboardKpiKey = keyof DashboardKpis

const stats = ref<DashboardKpis | null>(null)
const kpiDefinitions: Array<
  {
    key: DashboardKpiKey
    title: string
    subtext: string
    icon: any
    bgClass: string
    iconContainerClass: string
    iconClass: string
    link: string | { name: string; query?: Record<string, string> }
    trend?: string
    trendClass?: string
    progress?: number
  }
> = [
  {
    key: 'mareasDesignadas',
    title: 'Mareas Designadas',
    subtext: 'Pendientes de inicio',
    icon: TaskIcon,
    bgClass: 'bg-gray-500',
    iconContainerClass: 'bg-gray-100 dark:bg-gray-800',
    iconClass: 'text-gray-500',
    link: { name: 'MareasDashboard', query: { estado: 'DESIGNADA' } },
  },
  {
    key: 'flotaActiva',
    title: 'Navegando',
    subtext: 'Observadores en operación',
    icon: ShipIcon,
    bgClass: 'bg-blue-500',
    iconContainerClass: 'bg-blue-50 dark:bg-blue-900/20',
    iconClass: 'text-blue-500',
    link: { name: 'MareasDashboard', query: { estado: 'EN_EJECUCION' } },
  },
  {
    key: 'enRevision',
    title: 'En revisión',
    subtext: 'Procesos de informe',
    icon: UserGroupIcon,
    bgClass: 'bg-amber-500',
    iconContainerClass: 'bg-amber-50 dark:bg-amber-900/20',
    iconClass: 'text-amber-600',
    link: '/mareas/workflow?estado=ENTREGADA_RECIBIDA,VERIFICACION_INICIAL,EN_CORRECCION,PENDIENTE_DE_INFORME,ESPERANDO_REVISION',
  },
  {
    key: 'listasParaProtocolizar',
    title: 'Listas para protocolizar',
    subtext: 'Informes aprobados',
    icon: CheckIcon,
    bgClass: 'bg-brand-500',
    iconContainerClass: 'bg-brand-50 dark:bg-brand-900/20',
    iconClass: 'text-brand-500',
    link: '/mareas/stats',
  },
]

const kpis = computed(() =>
  kpiDefinitions.map((definition) => ({
    ...definition,
    value: stats.value ? stats.value[definition.key] : '—',
  }))
)

const fetchKpis = async () => {
  try {
    stats.value = await mareasService.getDashboardKpis()
  } catch (error) {
    toast.error('No se pudieron cargar los indicadores. Por favor, intente nuevamente.')
  }
}

onMounted(() => void fetchKpis())
</script>
