<template>
  <AdminLayout
    :title="detalleTitle"
    :description="detalleSubtitle"
  >
    <div class="max-w-6xl mx-auto pb-12 px-4 sm:px-6 lg:px-8 space-y-8">
      <div class="flex items-center justify-between gap-3">
        <button
          @click="goBack"
          class="group inline-flex items-center gap-2 text-sm font-semibold text-brand-500 hover:text-brand-600 transition-all bg-brand-50 dark:bg-brand-500/10 px-3 py-1.5 rounded-lg border border-brand-100 dark:border-brand-500/20"
        >
          <ArrowLeftIcon class="w-4 h-4 transition-transform group-hover:-translate-x-1" />
          Volver al flujo
        </button>
        <div class="flex items-center gap-3">
          <button
            @click="goToEdit"
            class="inline-flex items-center gap-2 px-3 py-2 text-sm font-semibold text-white bg-brand-500 hover:bg-brand-600 rounded-lg shadow-sm shadow-brand-500/20"
          >
            <EditIcon class="w-4 h-4" />
            Editar marea
          </button>
          <div
            v-if="estadoActual"
            class="flex items-center gap-2 px-3 py-1.5 rounded-full border text-xs font-black uppercase tracking-widest"
            :class="getStatusClasses(estadoActual.codigo)"
          >
            <div class="w-1.5 h-1.5 rounded-full bg-current"></div>
            {{ estadoActual.nombre }}
          </div>
        </div>
      </div>

      <div v-if="loading" class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-8 shadow-sm">
        <div class="flex items-center gap-3">
          <div class="loading loading-spinner loading-lg text-brand-500"></div>
          <div>
            <p class="text-sm font-bold text-gray-800 dark:text-gray-100">Cargando marea...</p>
            <p class="text-xs text-gray-500">Espere un momento mientras obtenemos los datos.</p>
          </div>
        </div>
      </div>

      <div v-else-if="error" class="bg-error-50 dark:bg-error-500/10 border border-error-100 dark:border-error-500/20 rounded-2xl p-6 flex items-center justify-between">
        <div>
          <h3 class="text-sm font-black text-error-700 dark:text-error-400 uppercase tracking-widest">No se pudo cargar la marea</h3>
          <p class="text-xs text-error-600 dark:text-error-400 mt-1">{{ error }}</p>
        </div>
        <button
          @click="loadData"
          class="px-4 py-2 text-sm font-semibold bg-error-600 text-white rounded-lg hover:bg-error-700 transition-colors"
        >
          Reintentar
        </button>
      </div>

      <template v-else-if="detalle">
        <!-- Resumen -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.25em] mb-2">Codigo de marea</p>
              <div class="flex items-center gap-3">
                <span class="text-xl font-black text-gray-900 dark:text-white">{{ detalleCodigo }}</span>
                <span class="text-xs font-semibold text-gray-500">{{ detalle.tipoMarea || 'Operativa' }}</span>
              </div>
              <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">{{ detalle.descripcion || 'Sin descripcion registrada.' }}</p>
            </div>
            <div class="flex flex-wrap gap-3">
              <div class="px-4 py-2 rounded-xl bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-800 text-sm font-semibold text-gray-700 dark:text-gray-200 flex items-center gap-2">
                <ShipIcon class="w-4 h-4 text-brand-500" />
                {{ detalle.buque?.nombreBuque || 'Buque sin especificar' }}
              </div>
              <div v-if="primerEtapa?.pesqueria" class="px-4 py-2 rounded-xl bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-800 text-sm font-semibold text-gray-700 dark:text-gray-200 flex items-center gap-2">
                <BeakerIcon class="w-4 h-4 text-indigo-500" />
                {{ primerEtapa?.pesqueria?.nombre }}
              </div>
              <div class="px-4 py-2 rounded-xl bg-gray-50 dark:bg-gray-800/50 border border-gray-100 dark:border-gray-800 text-sm font-semibold text-gray-700 dark:text-gray-200 flex items-center gap-2">
                <CalenderIcon class="w-4 h-4 text-emerald-500" />
                Ultima actualizacion: {{ formatDate(detalle.fechaUltimaActualizacion) }}
              </div>
            </div>
          </div>
        </div>

        <!-- Datos principales -->
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm lg:col-span-2">
            <div class="flex items-center justify-between mb-4">
              <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Datos generales</h3>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <InfoRow label="Anio" :value="detalle.anioMarea" />
              <InfoRow label="Numero de marea" :value="detalle.nroMarea" />
              <InfoRow label="Fecha estimada de zarpada" :value="formatDate(detalle.fechaZarpadaEstimada)" />
              <InfoRow label="Inicio observador" :value="formatDate(detalle.fechaInicioObservador)" />
              <InfoRow label="Fin observador" :value="formatDate(detalle.fechaFinObservador)" />
              <InfoRow label="Estado actual" :value="estadoActual?.nombre || 'Sin estado'" />
              <InfoRow label="Activo" :value="detalle.activo ? 'Si' : 'No'" />
            </div>
          </div>

          <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm space-y-4">
            <div class="flex items-center justify-between">
              <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Tiempos y progreso</h3>
              <HistoryIcon class="w-4 h-4 text-gray-400" />
            </div>
            <div class="grid grid-cols-2 gap-4">
              <MetricBadge label="Dias de marea" :value="contexto?.marea.dias_marea ?? 'N/D'" />
              <MetricBadge label="Dias navegados" :value="contexto?.marea.dias_navegados ?? 'N/D'" />
            </div>
            <div class="space-y-2 text-sm">
              <div class="flex items-center gap-2">
                <CalenderIcon class="w-4 h-4 text-indigo-500" />
                <span class="text-gray-600 dark:text-gray-300">Creada: {{ formatDate(detalle.fechaCreacion) }}</span>
              </div>
              <div class="flex items-center gap-2">
                <CalenderIcon class="w-4 h-4 text-indigo-500" />
                <span class="text-gray-600 dark:text-gray-300">Actualizada: {{ formatDate(detalle.fechaUltimaActualizacion) }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Acciones disponibles -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Acciones disponibles</h3>
            <TaskIcon class="w-4 h-4 text-gray-400" />
          </div>
          <div v-if="acciones.length" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
            <button
              v-for="accion in acciones"
              :key="accion.key"
              :disabled="!accion.enabled"
              class="group relative w-full text-left p-4 rounded-xl border transition-all duration-200"
              :class="accion.enabled ? 'bg-white dark:bg-gray-950 border-gray-100 dark:border-gray-800 hover:border-brand-500/40 hover:shadow-lg hover:shadow-brand-500/5' : 'bg-gray-50 dark:bg-gray-900/40 border-gray-100 dark:border-gray-800 text-gray-400 cursor-not-allowed'"
            >
              <div class="flex items-center gap-3">
                <div class="p-2 rounded-lg" :class="accion.enabled ? 'bg-brand-50 dark:bg-brand-500/10 text-brand-500' : 'bg-gray-100 dark:bg-gray-800 text-gray-400'">
                  <TaskIcon class="w-4 h-4" />
                </div>
                <div>
                  <p class="text-sm font-bold text-gray-800 dark:text-gray-100">{{ accion.label }}</p>
                  <p v-if="!accion.enabled && accion.blockedReason" class="text-[11px] text-gray-400 mt-0.5">{{ accion.blockedReason }}</p>
                </div>
              </div>
            </button>
          </div>
          <div v-else class="text-sm text-gray-500 dark:text-gray-400">Sin acciones habilitadas en este estado.</div>
        </div>

        <!-- Etapas -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl shadow-sm overflow-hidden">
          <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-800 flex items-center justify-between bg-gray-50/50 dark:bg-gray-900/30">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Etapas y puertos</h3>
            <MapPinIcon class="w-4 h-4 text-gray-400" />
          </div>
          <div v-if="detalle.etapas.length" class="overflow-x-auto">
            <table class="w-full text-left">
              <thead>
                <tr class="text-[10px] font-bold uppercase tracking-wider text-gray-400 border-b border-gray-50 dark:border-gray-800">
                  <th class="px-6 py-4">Nro</th>
                  <th class="px-4 py-4">Zarpada</th>
                  <th class="px-4 py-4">Arribo</th>
                  <th class="px-4 py-4">Pesqueria</th>
                  <th class="px-4 py-4">Tipo</th>
                  <th class="px-6 py-4 text-right">Observadores</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-50 dark:divide-gray-800">
                <tr v-for="etapa in detalle.etapas" :key="etapa.id" class="text-sm hover:bg-gray-50 dark:hover:bg-gray-800/30 transition-colors">
                  <td class="px-6 py-4 font-black text-brand-500">#{{ etapa.nroEtapa }}</td>
                  <td class="px-4 py-4">
                    <div class="font-semibold text-gray-800 dark:text-gray-200">{{ etapa.puertoZarpada?.nombre || 'N/D' }}</div>
                    <div class="text-xs text-gray-500">{{ formatDateTime(etapa.fechaZarpada) }}</div>
                  </td>
                  <td class="px-4 py-4">
                    <div class="font-semibold text-gray-800 dark:text-gray-200">{{ etapa.puertoArribo?.nombre || 'N/D' }}</div>
                    <div class="text-xs text-gray-500">{{ formatDateTime(etapa.fechaArribo) }}</div>
                  </td>
                  <td class="px-4 py-4 text-gray-700 dark:text-gray-300">{{ etapa.pesqueria?.nombre || 'N/D' }}</td>
                  <td class="px-4 py-4">
                    <span class="px-2 py-1 rounded text-[10px] font-bold" :class="etapa.tipoEtapa === 'COMERCIAL' ? 'bg-blue-100 text-blue-700 dark:bg-blue-500/10 dark:text-blue-300' : 'bg-emerald-100 text-emerald-700 dark:bg-emerald-500/10 dark:text-emerald-300'">
                      {{ etapa.tipoEtapa }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-right text-xs text-gray-600 dark:text-gray-300">
                    {{ etapa.observadores.length ? etapa.observadores.length + ' asignado(s)' : 'Sin asignar' }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <div v-else class="p-6 text-sm text-gray-500 dark:text-gray-400">Esta marea aun no tiene etapas registradas.</div>
        </div>

        <!-- Observadores -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Observadores</h3>
            <UserCircleIcon class="w-4 h-4 text-gray-400" />
          </div>
          <div v-if="observadores.length" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="obs in observadores" :key="obs.id" class="p-4 rounded-xl border border-gray-100 dark:border-gray-800 bg-gray-50/50 dark:bg-gray-900/40">
              <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-full bg-gradient-to-br from-brand-100 to-blue-200 dark:from-brand-500/20 dark:to-blue-500/20 flex items-center justify-center text-brand-600 dark:text-brand-300 font-extrabold text-sm border border-brand-50 dark:border-brand-500/20">
                    {{ obs.iniciales }}
                  </div>
                  <div>
                    <p class="font-bold text-gray-800 dark:text-white leading-tight">{{ obs.nombreCompleto }}</p>
                    <p class="text-[11px] text-brand-500 font-black uppercase tracking-widest">{{ obs.rol }}</p>
                  </div>
                </div>
                <span class="text-[10px] font-bold text-gray-400">ID {{ obs.codigo }}</span>
              </div>
              <div class="text-[11px] text-gray-500 space-y-1">
                <div class="flex items-center gap-2">
                  <CalenderIcon class="w-3 h-3 text-gray-300" /> Inicio: {{ obs.inicio || 'N/D' }}
                </div>
                <div class="flex items-center gap-2">
                  <CalenderIcon class="w-3 h-3 text-gray-300" /> Fin: {{ obs.fin || 'N/D' }}
                </div>
              </div>
            </div>
          </div>
          <div v-else class="text-sm text-gray-500 dark:text-gray-400">Sin observadores asignados.</div>
        </div>

        <!-- Movimientos -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Movimientos recientes</h3>
            <HistoryIcon class="w-4 h-4 text-gray-400" />
          </div>
          <div v-if="movimientos.length" class="relative pl-6 space-y-6">
            <div class="absolute left-2 top-1 bottom-1 w-[1px] bg-gray-100 dark:bg-gray-800"></div>
            <div v-for="mov in movimientos" :key="mov.id" class="relative">
              <div class="absolute -left-[10px] top-1 w-3 h-3 rounded-full bg-brand-500"></div>
              <div class="flex items-center justify-between">
                <p class="text-sm font-bold text-gray-800 dark:text-gray-100">{{ mov.titulo }}</p>
                <span class="text-[11px] text-gray-500">{{ formatDateTime(mov.fecha) }}</span>
              </div>
              <div class="flex items-center gap-2 text-[11px] text-gray-400 mt-1">
                <UserCircleIcon class="w-3 h-3" />
                {{ mov.usuario }}
              </div>
            </div>
          </div>
          <div v-else class="text-sm text-gray-500 dark:text-gray-400">No hay movimientos recientes.</div>
        </div>

        <!-- Documentos -->
        <div class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex items-center justify-between mb-3">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Documentos</h3>
            <CloudUploadIcon class="w-4 h-4 text-gray-400" />
          </div>
          <p class="text-sm text-gray-500 dark:text-gray-400">Integracion pendiente con archivos de marea. No hay documentos disponibles.</p>
        </div>
      </template>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { computed, defineComponent, h, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import {
  ArrowLeftIcon,
  ShipIcon,
  BeakerIcon,
  CalenderIcon,
  HistoryIcon,
  MapPinIcon,
  TaskIcon,
  UserCircleIcon,
  CloudUploadIcon,
  EditIcon,
} from '@/icons'
import mareasService, { type MareaDetalle, type MareaContext } from '../services/mareas.service'

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const error = ref<string | null>(null)
const detalle = ref<MareaDetalle | null>(null)
const contexto = ref<MareaContext | null>(null)

const mareaId = computed(() => route.params.id as string)

const estadoActual = computed(() => {
  if (detalle.value?.estadoActual) {
    return {
      codigo: detalle.value.estadoActual.codigo,
      nombre: detalle.value.estadoActual.nombre
    }
  }
  if (contexto.value?.marea) {
    return {
      codigo: (contexto.value.marea as any).estado_codigo,
      nombre: (contexto.value.marea as any).estado
    }
  }
  return null
})

const detalleCodigo = computed(() => {
  if (!detalle.value) return 'Marea'
  const tipo = detalle.value.tipoMarea || 'MA'
  const nro = String(detalle.value.nroMarea).padStart(3, '0')
  const anio = String(detalle.value.anioMarea).slice(-2)
  return `${tipo}-${nro}-${anio}`
})

const detalleTitle = computed(() => (detalle.value ? `Marea ${detalleCodigo.value}` : 'Marea'))
const detalleSubtitle = computed(() => detalle.value?.titulo || 'Detalles tecnicos y operativos de la marea.')

const primerEtapa = computed(() => detalle.value?.etapas?.[0])

const observadores = computed(() => {
  if (!detalle.value?.etapas) return []
  const map = new Map<string, any>()
  detalle.value.etapas.forEach((etapa) => {
    etapa.observadores.forEach((o) => {
      const obs = o.observador
      if (!map.has(obs.id)) {
        map.set(obs.id, {
          id: obs.id,
          nombreCompleto: `${obs.nombre} ${obs.apellido}`,
          rol: o.rol,
          codigo: obs.codigoInterno || 'N/D',
          inicio: formatDate(etapa.fechaZarpada),
          fin: formatDate(etapa.fechaArribo),
          iniciales: `${obs.nombre?.[0] || ''}${obs.apellido?.[0] || ''}`.toUpperCase()
        })
      }
    })
  })
  return Array.from(map.values())
})

const movimientos = computed(() => contexto.value?.lastEvents || [])

const acciones = computed(() => {
  if (!contexto.value?.actions) return []
  return Object.entries(contexto.value.actions).map(([key, value]) => ({
    key,
    ...value
  }))
})

const formatDate = (value?: string | null) => {
  if (!value) return 'N/D'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'N/D'
  return new Intl.DateTimeFormat('es-AR', { day: '2-digit', month: 'short', year: 'numeric' }).format(date)
}

const formatDateTime = (value?: string | null) => {
  if (!value) return 'N/D'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return 'N/D'
  return new Intl.DateTimeFormat('es-AR', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' }).format(date)
}

const getStatusClasses = (codigo?: string) => {
  const base = 'border px-3 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest'
  if (!codigo) return `${base} text-gray-500 bg-gray-50 border-gray-100 dark:bg-gray-900 dark:border-gray-800`
  const map: Record<string, string> = {
    DESIGNADA: 'bg-blue-50 text-blue-700 border-blue-100 dark:bg-blue-500/10 dark:text-blue-300 dark:border-blue-500/30',
    EN_EJECUCION: 'bg-indigo-50 text-indigo-700 border-indigo-100 dark:bg-indigo-500/10 dark:text-indigo-300 dark:border-indigo-500/30',
    ESPERANDO_ENTREGA: 'bg-amber-50 text-amber-700 border-amber-100 dark:bg-amber-500/10 dark:text-amber-300 dark:border-amber-500/30',
    EN_CORRECCION: 'bg-orange-50 text-orange-700 border-orange-100 dark:bg-orange-500/10 dark:text-orange-300 dark:border-orange-500/30',
    PENDIENTE_DE_INFORME: 'bg-purple-50 text-purple-700 border-purple-100 dark:bg-purple-500/10 dark:text-purple-300 dark:border-purple-500/30',
    PROTOCOLIZADA: 'bg-emerald-50 text-emerald-700 border-emerald-100 dark:bg-emerald-500/10 dark:text-emerald-300 dark:border-emerald-500/30'
  }
  return `${base} ${map[codigo] || 'bg-gray-50 text-gray-700 border-gray-100 dark:bg-gray-900 dark:text-gray-300 dark:border-gray-800'}`
}

const loadData = async () => {
  loading.value = true
  error.value = null
  try {
    detalle.value = await mareasService.getById(mareaId.value)
    try {
      contexto.value = await mareasService.getMareaContext(mareaId.value)
    } catch (ctxErr: any) {
      contexto.value = null
      toast.error('No pudimos cargar el contexto de la marea.')
      console.error(ctxErr)
    }
  } catch (err: any) {
    const message = err?.message || 'No se pudo cargar la marea.'
    error.value = message
    toast.error('No se pudo cargar la marea. Intente nuevamente.')
  } finally {
    loading.value = false
  }
}

const goBack = () => router.push({ name: 'MareasWorkflow' })
const goToEdit = () => router.push({ name: 'EditarMarea', params: { id: mareaId.value } })

onMounted(() => {
  loadData()
})

const InfoRow = defineComponent({
  name: 'InfoRow',
  props: {
    label: { type: String, required: true },
    value: { type: [String, Number], required: true }
  },
  setup(props) {
    return () =>
      h('div', { class: 'space-y-1' }, [
        h('p', { class: 'text-[11px] font-black uppercase tracking-widest text-gray-400' }, props.label),
        h('p', { class: 'text-sm font-semibold text-gray-800 dark:text-gray-100' }, props.value as any)
      ])
  }
})

const MetricBadge = defineComponent({
  name: 'MetricBadge',
  props: {
    label: { type: String, required: true },
    value: { type: [String, Number], required: true }
  },
  setup(props) {
    return () =>
      h('div', { class: 'p-4 rounded-xl bg-gray-50 dark:bg-gray-900/40 border border-gray-100 dark:border-gray-800' }, [
        h('p', { class: 'text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mb-1' }, props.label),
        h('p', { class: 'text-xl font-black text-gray-900 dark:text-white' }, props.value as any)
      ])
  }
})
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: var(--color-gray-200);
  border-radius: 9999px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: var(--color-gray-700);
}
</style>
