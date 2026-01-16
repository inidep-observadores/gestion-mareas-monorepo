<template>
  <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4 xl:gap-6">
    <div
      v-for="kpi in kpis"
      :key="kpi.title"
            class="group relative overflow-hidden rounded-2xl border border-border bg-surface p-5 shadow-sm transition-all hover:shadow-xl hover:-translate-y-1"
      >
      <!-- Background Decorative Gradient -->
      <div
        class="absolute -right-4 -top-4 h-24 w-24 rounded-full opacity-5 blur-3xl transition-opacity group-hover:opacity-10"
        :class="kpi.bgClass"
      ></div>

      <div class="flex items-center justify-between gap-4">
        <div class="z-10">
          <p class="text-[10px] font-black uppercase tracking-widest text-text-muted">
            {{ kpi.title }}
          </p>
          <div class="flex items-baseline gap-2">
            <h3 class="mt-1 text-3xl font-black text-text leading-none">
              {{ kpi.value }}
            </h3>
            <span v-if="kpi.trend" class="text-[10px] font-bold px-1.5 py-0.5 rounded-md" :class="kpi.trendClass">
              {{ kpi.trend }}
            </span>
          </div>
          <p v-if="kpi.subtext" class="mt-2 text-[11px] font-bold text-text-muted">
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
           <span class="text-[9px] font-black text-text-muted uppercase tracking-tighter">Progreso Objetivo</span>
           <span class="text-[9px] font-black text-primary">{{ kpi.progress }}%</span>
        </div>
        <div class="h-1.5 w-full rounded-full bg-surface-muted overflow-hidden">
          <div
            class="h-full rounded-full bg-primary transition-all duration-1000 ease-out"
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
    bgClass: 'bg-text-muted',
    iconContainerClass: 'bg-surface-muted',
    iconClass: 'text-text-muted',
    link: { name: 'MareasDashboard', query: { estado: 'DESIGNADA' } },
  },
  {
    key: 'flotaActiva',
    title: 'Navegando',
    subtext: 'Observadores en operación',
    icon: ShipIcon,
    bgClass: 'bg-info',
    iconContainerClass: 'bg-info/10',
    iconClass: 'text-info',
    link: { name: 'MareasDashboard', query: { estado: 'EN_EJECUCION' } },
  },
  {
    key: 'enRevision',
    title: 'En revisión',
    subtext: 'Procesos de informe',
    icon: UserGroupIcon,
    bgClass: 'bg-warning',
    iconContainerClass: 'bg-warning/10',
    iconClass: 'text-warning',
    link: { name: 'MareasDashboard', query: { estado: 'ENTREGADA_RECIBIDA,VERIFICACION_INICIAL,EN_CORRECCION,PENDIENTE_DE_INFORME,ESPERANDO_REVISION' } },
  },
  {
    key: 'listasParaProtocolizar',
    title: 'Listas para protocolizar',
    subtext: 'Informes aprobados',
    icon: CheckIcon,
    bgClass: 'bg-primary',
    iconContainerClass: 'bg-primary/10',
    iconClass: 'text-primary',
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
