<template>
  <AdminLayout :title="pageTitle" :description="pageSubtitle">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-12 space-y-6">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4 sticky top-0 bg-gray-50/70 dark:bg-gray-900/70 backdrop-blur-md py-4 z-20">
        <div class="flex items-center gap-3">
          <button @click="handleBack" class="inline-flex items-center gap-2 px-3 py-2 text-sm font-semibold text-brand-500 bg-brand-50 dark:bg-brand-500/10 rounded-lg border border-brand-100 dark:border-brand-500/20 hover:text-brand-600">
            <ArrowLeftIcon class="w-4 h-4" />
            Volver
          </button>
          <div v-if="estadoActual" class="flex items-center gap-2 px-3 py-1.5 rounded-full text-[11px] font-black uppercase tracking-widest" :class="getStatusClasses(estadoActual.codigo)">
            <span class="w-1.5 h-1.5 rounded-full bg-current"></span>
            {{ estadoActual.nombre }}
          </div>
        </div>
        <div class="flex items-center gap-2">
          <button @click="handleCancel" class="px-4 py-2 text-sm font-semibold text-gray-600 dark:text-gray-300 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-lg hover:bg-gray-50 dark:hover:bg-gray-700">
            Descartar
          </button>
          <button @click="handleSave" :disabled="saving || loading" class="inline-flex items-center gap-2 px-4 py-2 text-sm font-semibold rounded-lg bg-brand-500 text-white hover:bg-brand-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed shadow-sm shadow-brand-500/20">
            <span v-if="saving" class="loading loading-spinner loading-sm"></span>
            <CheckIcon v-else class="w-4 h-4" />
            <span>Guardar todo</span>
          </button>
        </div>
      </div>

      <div v-if="loading" class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-8 shadow-sm flex items-center gap-3">
        <div class="loading loading-spinner loading-lg text-brand-500"></div>
        <div>
          <p class="text-sm font-bold text-gray-800 dark:text-gray-100">Cargando marea...</p>
          <p class="text-xs text-gray-500">Espere un momento mientras obtenemos los datos.</p>
        </div>
      </div>

      <div v-else-if="error" class="bg-error-50 dark:bg-error-500/10 border border-error-100 dark:border-error-500/20 rounded-2xl p-6 shadow-sm">
        <h3 class="text-sm font-black text-error-700 dark:text-error-400 uppercase tracking-[0.2em]">No se pudo cargar la marea</h3>
        <p class="text-sm text-error-600 dark:text-error-400 mt-1">{{ error }}</p>
        <button @click="loadData" class="mt-3 px-4 py-2 text-sm font-semibold bg-error-600 text-white rounded-lg hover:bg-error-700 transition-colors">
          Reintentar
        </button>
      </div>

      <template v-else-if="detalle">
        <div class="border-b border-gray-200 dark:border-gray-800 overflow-x-auto custom-scrollbar">
          <div class="flex gap-6 min-w-max">
            <button
              v-for="tab in tabs"
              :key="tab.id"
              @click="currentTab = tab.id"
              class="pb-4 text-sm font-bold transition-all relative"
              :class="currentTab === tab.id ? 'text-brand-500' : 'text-gray-400 hover:text-gray-600 dark:hover:text-gray-200'"
            >
              <div class="flex items-center gap-2">
                <component :is="tab.icon" class="w-4 h-4" />
                {{ tab.label }}
              </div>
              <div v-if="currentTab === tab.id" class="absolute bottom-0 left-0 right-0 h-0.5 bg-brand-500 rounded-full"></div>
            </button>
          </div>
        </div>

        <section class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-4">
            <div>
              <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-2">Codigo de marea</p>
              <div class="flex items-center gap-3">
                <span class="text-xl font-black text-gray-900 dark:text-white">{{ codigoMarea }}</span>
                <span class="text-xs font-semibold text-gray-500">{{ detalle.tipoMarea || 'Operativa' }}</span>
              </div>
              <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">{{ detalle.descripcion || 'Sin descripcion registrada.' }}</p>
            </div>
            <div class="flex flex-wrap gap-3">
              <Badge icon="ShipIcon" :text="detalle.buque?.nombreBuque || 'Buque sin especificar'" />
              <Badge v-if="primerEtapa?.pesqueria" icon="BeakerIcon" :text="primerEtapa?.pesqueria?.nombre" tone="indigo" />
              <Badge icon="CalenderIcon" :text="`Ultima actualizacion: ${formatDate(detalle.fechaUltimaActualizacion)}`" tone="emerald" />
            </div>
          </div>
        </section>

        <div v-if="currentTab === 'general'" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
          <section class="lg:col-span-2 bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500 mb-4">Datos generales</h3>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <FormField label="Anio" v-model="form.anioMarea" type="number" />
              <FormField label="Numero de marea" v-model="form.nroMarea" type="number" />
              <FormField label="Titulo" v-model="form.titulo" />
              <FormField label="Tipo de marea" v-model="form.tipoMarea" />
              <FormField label="Fecha estimada de zarpada" v-model="form.fechaZarpadaEstimada" type="datetime-local" />
              <FormField label="Fecha inicio observador" v-model="form.fechaInicioObservador" type="datetime-local" />
              <FormField label="Fecha fin observador" v-model="form.fechaFinObservador" type="datetime-local" />
              <FormField label="Dias estimados" v-model="form.diasEstimados" type="number" />
            </div>
            <div class="mt-4">
              <label class="text-[11px] font-black uppercase tracking-widest text-gray-400 block mb-2">Descripcion</label>
              <textarea
                v-model="form.descripcion"
                rows="3"
                class="w-full rounded-lg border border-gray-100 dark:border-gray-800 bg-gray-50 dark:bg-gray-900 text-sm text-gray-800 dark:text-gray-100 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-brand-500/20"
              ></textarea>
            </div>
            <div class="mt-4 flex items-center gap-2">
              <input id="activo" v-model="form.activo" type="checkbox" class="checkbox checkbox-sm checkbox-brand" />
              <label for="activo" class="text-sm font-semibold text-gray-700 dark:text-gray-200">Marea activa</label>
            </div>
          </section>

          <section class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm space-y-3">
            <div class="flex items-center justify-between">
              <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Tiempos</h3>
              <HistoryIcon class="w-4 h-4 text-gray-400" />
            </div>
            <MetricCard label="Dias de marea" :value="contexto?.marea.dias_marea ?? 'N/D'" />
            <MetricCard label="Dias navegados" :value="contexto?.marea.dias_navegados ?? 'N/D'" />
            <p class="text-xs text-gray-500 dark:text-gray-400">Creada: {{ formatDate(detalle.fechaCreacion) }} Â· Actualizada: {{ formatDate(detalle.fechaUltimaActualizacion) }}</p>
          </section>
        </div>

        <div v-else-if="currentTab === 'etapas'" class="space-y-4">
          <div class="flex items-center justify-between">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Etapas</h3>
            <button @click="openEtapaModal()" class="px-4 py-2 text-sm font-semibold rounded-lg bg-brand-500 text-white hover:bg-brand-600 shadow-sm">
              Agregar etapa
            </button>
          </div>
          <div v-if="etapas.length" class="grid grid-cols-1 md:grid-cols-2 gap-3">
            <div
              v-for="etapa in etapas"
              :key="etapa._localId"
              class="p-4 rounded-xl border border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm space-y-2"
            >
              <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                  <span class="w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-900/30 text-brand-600 dark:text-brand-300 font-black flex items-center justify-center border border-brand-100 dark:border-brand-800">#{{ etapa.nroEtapa }}</span>
                  <div>
                    <p class="text-sm font-bold text-gray-800 dark:text-white">{{ etapa.puertoZarpada || 'Sin puerto' }}</p>
                    <p class="text-[11px] text-gray-500">-> {{ etapa.puertoArribo || 'En curso' }}</p>
                  </div>
                </div>
                <div class="flex items-center gap-1">
                  <button @click="openEtapaModal(etapa)" class="p-2 text-gray-400 hover:text-brand-500 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
                    <EditIcon class="w-4 h-4" />
                  </button>
                  <button @click="removeEtapa(etapa._localId)" class="p-2 text-gray-400 hover:text-error-500 rounded-lg hover:bg-error-50 dark:hover:bg-error-500/10">
                    <TrashIcon class="w-4 h-4" />
                  </button>
                </div>
              </div>
              <div class="text-[11px] text-gray-500 space-y-1">
                <p>Zarpada: {{ formatDateTime(etapa.fechaZarpada) }}</p>
                <p>Arribo: {{ formatDateTime(etapa.fechaArribo) }}</p>
                <p>Pesqueria: {{ etapa.pesqueria || 'N/D' }}</p>
                <p>Tipo: {{ etapa.tipoEtapa || 'N/D' }}</p>
              </div>
            </div>
          </div>
          <div v-else class="bg-white dark:bg-gray-900 border border-dashed border-gray-200 dark:border-gray-800 rounded-2xl p-8 text-center text-sm text-gray-500">
            Sin etapas registradas.
          </div>
        </div>

        <div v-else-if="currentTab === 'observadores'" class="space-y-4">
          <div class="flex items-center justify-between">
            <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Observadores</h3>
            <button @click="openObsModal()" class="px-4 py-2 text-sm font-semibold rounded-lg bg-brand-500 text-white hover:bg-brand-600 shadow-sm">
              Asignar observador
            </button>
          </div>
          <div v-if="observadores.length" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="obs in observadores" :key="obs._localId" class="p-4 rounded-xl border border-gray-100 dark:border-gray-800 bg-white dark:bg-gray-900 shadow-sm">
              <div class="flex items-center justify-between mb-2">
                <div>
                  <p class="font-bold text-gray-800 dark:text-white">{{ obs.nombreCompleto }}</p>
                  <p class="text-[11px] text-brand-500 font-black uppercase tracking-widest">{{ obs.rol }}</p>
                </div>
                <div class="inline-flex items-center gap-1">
                  <button @click="openObsModal(obs)" class="p-2 text-gray-400 hover:text-brand-500 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
                    <EditIcon class="w-4 h-4" />
                  </button>
                  <button @click="removeObs(obs._localId)" class="p-2 text-gray-400 hover:text-error-500 rounded-lg hover:bg-error-50 dark:hover:bg-error-500/10">
                    <TrashIcon class="w-4 h-4" />
                  </button>
                </div>
              </div>
              <div class="text-[11px] text-gray-500 space-y-1">
                <p>Inicio: {{ formatDate(obs.inicio) }}</p>
                <p>Fin: {{ formatDate(obs.fin) }}</p>
              </div>
            </div>
          </div>
          <div v-else class="bg-white dark:bg-gray-900 border border-dashed border-gray-200 dark:border-gray-800 rounded-2xl p-8 text-center text-sm text-gray-500">
            Sin observadores asignados.
          </div>
        </div>

        <div v-else-if="currentTab === 'docs'" class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm">
          <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500 mb-3">Documentos</h3>
          <p class="text-sm text-gray-500 dark:text-gray-400">Integracion pendiente con archivos de marea.</p>
        </div>

        <div v-else-if="currentTab === 'admin'" class="bg-white dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl p-6 shadow-sm space-y-4 max-w-3xl">
          <h3 class="text-sm font-black uppercase tracking-[0.2em] text-gray-500">Administrativo</h3>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <FormField label="Numero de protocolizacion" v-model="form.nroProtocolizacion" type="number" />
            <FormField label="Anio protocolizacion" v-model="form.anioProtocolizacion" type="number" />
            <FormField label="Fecha de protocolizacion" v-model="form.fechaProtocolizacion" type="date" />
          </div>
          <div class="p-4 bg-blue-50 dark:bg-blue-500/10 border border-blue-100 dark:border-blue-500/20 rounded-xl text-xs text-blue-700 dark:text-blue-300">
            Al completar estos datos la marea quedara marcada como PROTOCOLIZADA.
          </div>
        </div>
      </template>
    </div>

    <BaseModal :show="showEtapaModal" title="Etapa" @close="closeEtapaModal">
      <div class="space-y-3">
        <FormField label="Numero de etapa" v-model="etapaForm.nroEtapa" type="number" />
        <FormField label="Puerto zarpada" v-model="etapaForm.puertoZarpada" />
        <FormField label="Puerto arribo" v-model="etapaForm.puertoArribo" />
        <FormField label="Pesqueria" v-model="etapaForm.pesqueria" />
        <FormField label="Fecha zarpada" v-model="etapaForm.fechaZarpada" type="datetime-local" />
        <FormField label="Fecha arribo" v-model="etapaForm.fechaArribo" type="datetime-local" />
        <FormField label="Tipo de etapa" v-model="etapaForm.tipoEtapa" />
      </div>
      <template #footer>
        <div class="grid grid-cols-2 gap-3">
          <button @click="closeEtapaModal" class="px-4 py-2 text-sm font-semibold text-gray-600 dark:text-gray-300 bg-gray-100 dark:bg-gray-800 rounded-lg">Cancelar</button>
          <button @click="saveEtapa" class="px-4 py-2 text-sm font-semibold text-white bg-brand-500 hover:bg-brand-600 rounded-lg">Guardar</button>
        </div>
      </template>
    </BaseModal>

    <BaseModal :show="showObsModal" title="Observador" @close="closeObsModal">
      <div class="space-y-3">
        <FormField label="Nombre completo" v-model="obsForm.nombreCompleto" />
        <FormField label="Rol" v-model="obsForm.rol" />
        <FormField label="Codigo interno" v-model="obsForm.codigo" />
        <FormField label="Fecha inicio" v-model="obsForm.inicio" type="date" />
        <FormField label="Fecha fin" v-model="obsForm.fin" type="date" />
      </div>
      <template #footer>
        <div class="grid grid-cols-2 gap-3">
          <button @click="closeObsModal" class="px-4 py-2 text-sm font-semibold text-gray-600 dark:text-gray-300 bg-gray-100 dark:bg-gray-800 rounded-lg">Cancelar</button>
          <button @click="saveObs" class="px-4 py-2 text-sm font-semibold text-white bg-brand-500 hover:bg-brand-600 rounded-lg">Guardar</button>
        </div>
      </template>
    </BaseModal>
  </AdminLayout>
</template>

<script setup lang="ts">
import { computed, defineComponent, h, onMounted, ref } from 'vue'
import { useRoute, useRouter, onBeforeRouteLeave } from 'vue-router'
import { toast } from 'vue-sonner'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import BaseModal from '@/components/common/BaseModal.vue'
import { ArrowLeftIcon, CheckIcon, EditIcon, TrashIcon, ShipIcon, BeakerIcon, CalenderIcon, HistoryIcon, MapPinIcon } from '@/icons'
import mareasService, { type MareaDetalle, type MareaContext } from '../services/mareas.service'

type EtapaEditable = {
  _localId: string
  id?: string
  nroEtapa: number | null
  puertoZarpada?: string | null
  puertoArribo?: string | null
  pesqueria?: string | null
  fechaZarpada?: string | null
  fechaArribo?: string | null
  tipoEtapa?: string | null
}

type ObsEditable = {
  _localId: string
  id?: string
  nombreCompleto: string
  rol: string
  codigo?: string | null
  inicio?: string | null
  fin?: string | null
}

const route = useRoute()
const router = useRouter()

const loading = ref(true)
const saving = ref(false)
const error = ref<string | null>(null)
const detalle = ref<MareaDetalle | null>(null)
const contexto = ref<MareaContext | null>(null)

const form = ref({
  anioMarea: null as number | null,
  nroMarea: null as number | null,
  titulo: '',
  descripcion: '',
  tipoMarea: '',
  fechaZarpadaEstimada: '',
  fechaInicioObservador: '',
  fechaFinObservador: '',
  diasEstimados: null as number | null,
  activo: true,
  nroProtocolizacion: null as number | null,
  anioProtocolizacion: null as number | null,
  fechaProtocolizacion: ''
})

const initialSnapshot = ref('')
const currentTab = ref('general')
const etapas = ref<EtapaEditable[]>([])
const observadores = ref<ObsEditable[]>([])

const showEtapaModal = ref(false)
const showObsModal = ref(false)

const etapaForm = ref<EtapaEditable>({
  _localId: '',
  nroEtapa: null,
  puertoZarpada: '',
  puertoArribo: '',
  pesqueria: '',
  fechaZarpada: '',
  fechaArribo: '',
  tipoEtapa: ''
})

const obsForm = ref<ObsEditable>({
  _localId: '',
  nombreCompleto: '',
  rol: '',
  codigo: '',
  inicio: '',
  fin: ''
})

const estadoActual = computed(() => {
  if (detalle.value?.estadoActual) {
    return { codigo: detalle.value.estadoActual.codigo, nombre: detalle.value.estadoActual.nombre }
  }
  if (contexto.value?.marea) {
    return { codigo: (contexto.value.marea as any).estado_codigo, nombre: (contexto.value.marea as any).estado }
  }
  return null
})

const codigoMarea = computed(() => {
  if (!detalle.value) return 'Marea'
  const tipo = detalle.value.tipoMarea || 'MA'
  const nro = String(detalle.value.nroMarea).padStart(3, '0')
  const anio = String(detalle.value.anioMarea).slice(-2)
  return `${tipo}-${nro}-${anio}`
})

const primerEtapa = computed(() => detalle.value?.etapas?.[0])

const pageTitle = computed(() => (detalle.value ? `Editar ${codigoMarea.value}` : 'Editar marea'))
const pageSubtitle = computed(() => 'Edicion completa de la marea y sus registros asociados.')

const tabs = computed(() => [
  { id: 'general', label: 'General', icon: EditIcon },
  { id: 'etapas', label: 'Etapas', icon: MapPinIcon },
  { id: 'observadores', label: 'Observadores', icon: EditIcon },
  { id: 'docs', label: 'Documentos', icon: EditIcon },
  { id: 'admin', label: 'Administrativo', icon: EditIcon }
])

const loadData = async () => {
  loading.value = true
  error.value = null
  try {
    const id = route.params.id as string
    detalle.value = await mareasService.getById(id)
    try {
      contexto.value = await mareasService.getMareaContext(id)
    } catch (ctxErr: any) {
      contexto.value = null
    }
    hydrateForm()
    hydrateEtapas()
    hydrateObservadores()
    snapshotForm()
  } catch (err: any) {
    error.value = err?.message || 'No se pudo cargar la marea.'
    toast.error('No se pudo cargar la marea. Intente nuevamente.')
  } finally {
    loading.value = false
  }
}

const hydrateForm = () => {
  if (!detalle.value) return
  form.value = {
    anioMarea: detalle.value.anioMarea,
    nroMarea: detalle.value.nroMarea,
    titulo: detalle.value.titulo || '',
    descripcion: detalle.value.descripcion || '',
    tipoMarea: detalle.value.tipoMarea || '',
    fechaZarpadaEstimada: toInputDate(detalle.value.fechaZarpadaEstimada),
    fechaInicioObservador: toInputDate(detalle.value.fechaInicioObservador),
    fechaFinObservador: toInputDate(detalle.value.fechaFinObservador),
    diasEstimados: (detalle.value as any).diasEstimados ?? null,
    activo: detalle.value.activo,
    nroProtocolizacion: (detalle.value as any).nroProtocolizacion ?? null,
    anioProtocolizacion: (detalle.value as any).anioProtocolizacion ?? null,
    fechaProtocolizacion: toInputDate((detalle.value as any).fechaProtocolizacion)
  }
}

const hydrateEtapas = () => {
  etapas.value = (detalle.value?.etapas || []).map((e) => ({
    _localId: crypto.randomUUID(),
    id: e.id,
    nroEtapa: e.nroEtapa,
    puertoZarpada: e.puertoZarpada?.nombre || '',
    puertoArribo: e.puertoArribo?.nombre || '',
    pesqueria: e.pesqueria?.nombre || '',
    fechaZarpada: toInputDate(e.fechaZarpada),
    fechaArribo: toInputDate(e.fechaArribo),
    tipoEtapa: e.tipoEtapa || ''
  }))
}

const hydrateObservadores = () => {
  const map = new Map<string, ObsEditable>()
  detalle.value?.etapas.forEach((etapa) => {
    etapa.observadores.forEach((obs) => {
      const o = obs.observador
      if (!map.has(o.id)) {
        map.set(o.id, {
          _localId: crypto.randomUUID(),
          id: o.id,
          nombreCompleto: `${o.nombre} ${o.apellido}`,
          rol: obs.rol,
          codigo: o.codigoInterno ? String(o.codigoInterno) : '',
          inicio: toInputDate(etapa.fechaZarpada),
          fin: toInputDate(etapa.fechaArribo)
        })
      }
    })
  })
  observadores.value = Array.from(map.values())
}

const snapshotForm = () => {
  initialSnapshot.value = JSON.stringify({ form: form.value, etapas: etapas.value, observadores: observadores.value })
}

const isDirty = computed(() => JSON.stringify({ form: form.value, etapas: etapas.value, observadores: observadores.value }) !== initialSnapshot.value)

const handleBack = () => {
  if (isDirty.value) {
    if (confirm('Hay cambios sin guardar. Desea salir igualmente?')) {
      router.push({ name: 'MareasWorkflow' })
    }
    return
  }
  router.push({ name: 'MareasWorkflow' })
}

const handleCancel = () => handleBack()

const handleSave = async () => {
  if (!detalle.value) return
  saving.value = true
  try {
    const payload: any = {
      anioMarea: form.value.anioMarea,
      nroMarea: form.value.nroMarea,
      titulo: form.value.titulo,
      descripcion: form.value.descripcion,
      tipoMarea: form.value.tipoMarea,
      fechaZarpadaEstimada: toIso(form.value.fechaZarpadaEstimada),
      fechaInicioObservador: toIso(form.value.fechaInicioObservador),
      fechaFinObservador: toIso(form.value.fechaFinObservador),
      diasEstimados: form.value.diasEstimados,
      activo: form.value.activo,
      nroProtocolizacion: form.value.nroProtocolizacion,
      anioProtocolizacion: form.value.anioProtocolizacion,
      fechaProtocolizacion: toIso(form.value.fechaProtocolizacion),
      etapas: etapas.value.map(({ _localId, ...rest }) => rest),
      observadores: observadores.value.map(({ _localId, ...rest }) => rest)
    }
    await mareasService.update(detalle.value.id, payload)
    toast.success('Los cambios se guardaron correctamente.')
    await loadData()
  } catch (err: any) {
    const msg = err?.response?.data?.message || err?.message || 'No se pudo guardar la marea.'
    toast.error(Array.isArray(msg) ? msg.join(', ') : msg)
  } finally {
    saving.value = false
  }
}

const openEtapaModal = (etapa?: EtapaEditable) => {
  etapaForm.value = etapa
    ? { ...etapa }
    : { _localId: '', nroEtapa: null, puertoZarpada: '', puertoArribo: '', pesqueria: '', fechaZarpada: '', fechaArribo: '', tipoEtapa: '' }
  showEtapaModal.value = true
}

const closeEtapaModal = () => {
  showEtapaModal.value = false
}

const saveEtapa = () => {
  if (!etapaForm.value.nroEtapa) {
    toast.error('Indique el numero de etapa.')
    return
  }
  if (etapaForm.value._localId) {
    etapas.value = etapas.value.map((e) => (e._localId === etapaForm.value._localId ? { ...etapaForm.value } : e))
  } else {
    etapas.value.push({ ...etapaForm.value, _localId: crypto.randomUUID() })
  }
  closeEtapaModal()
}

const removeEtapa = (localId: string) => {
  etapas.value = etapas.value.filter((e) => e._localId !== localId)
}

const openObsModal = (obs?: ObsEditable) => {
  obsForm.value = obs ? { ...obs } : { _localId: '', nombreCompleto: '', rol: '', codigo: '', inicio: '', fin: '' }
  showObsModal.value = true
}

const closeObsModal = () => {
  showObsModal.value = false
}

const saveObs = () => {
  if (!obsForm.value.nombreCompleto) {
    toast.error('Indique el nombre del observador.')
    return
  }
  if (obsForm.value._localId) {
    observadores.value = observadores.value.map((o) => (o._localId === obsForm.value._localId ? { ...obsForm.value } : o))
  } else {
    observadores.value.push({ ...obsForm.value, _localId: crypto.randomUUID() })
  }
  closeObsModal()
}

const removeObs = (localId: string) => {
  observadores.value = observadores.value.filter((o) => o._localId !== localId)
}

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

const toInputDate = (value?: string | null) => {
  if (!value) return ''
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return ''
  return d.toISOString().slice(0, 16)
}

const toIso = (value?: string | null) => {
  if (!value) return null
  const d = new Date(value)
  if (Number.isNaN(d.getTime())) return null
  return d.toISOString()
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

onMounted(() => {
  loadData()
})

onBeforeRouteLeave((to, from, next) => {
  if (isDirty.value) {
    if (confirm('Hay cambios sin guardar. Desea salir igualmente?')) {
      return next()
    }
    return next(false)
  }
  return next()
})

const Badge = defineComponent({
  name: 'Badge',
  props: { icon: { type: String, required: true }, text: { type: String, required: true }, tone: { type: String, default: 'gray' } },
  setup(props) {
    const tones: Record<string, string> = {
      gray: 'bg-gray-50 dark:bg-gray-800/50 text-gray-700 dark:text-gray-200 border-gray-100 dark:border-gray-800',
      indigo: 'bg-indigo-50 dark:bg-indigo-500/10 text-indigo-700 dark:text-indigo-300 border-indigo-100 dark:border-indigo-500/20',
      emerald: 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-700 dark:text-emerald-300 border-emerald-100 dark:border-emerald-500/20'
    }
    return () =>
      h('div', { class: `px-4 py-2 rounded-xl border text-sm font-semibold flex items-center gap-2 ${tones[props.tone] || tones.gray}` }, [
        h((icons as any)[props.icon], { class: 'w-4 h-4' }),
        h('span', null, props.text)
      ])
  }
})

const FormField = defineComponent({
  name: 'FormField',
  props: { label: { type: String, required: true }, modelValue: { type: [String, Number, Boolean, null] as any, default: '' }, type: { type: String, default: 'text' }, placeholder: { type: String, default: '' } },
  emits: ['update:modelValue'],
  setup(props, { emit }) {
    const onInput = (e: Event) => emit('update:modelValue', (e.target as HTMLInputElement).value)
    return () =>
      h('div', { class: 'space-y-1.5' }, [
        h('label', { class: 'text-[11px] font-black uppercase tracking-widest text-gray-400 block' }, props.label),
        h('input', {
          class: 'w-full rounded-lg border border-gray-100 dark:border-gray-800 bg-gray-50 dark:bg-gray-900 text-sm text-gray-800 dark:text-gray-100 px-3 py-2 focus:outline-none focus:ring-2 focus:ring-brand-500/20',
          type: props.type,
          value: props.modelValue as any,
          placeholder: props.placeholder,
          onInput
        })
      ])
  }
})

const MetricCard = defineComponent({
  name: 'MetricCard',
  props: { label: { type: String, required: true }, value: { type: [String, Number], required: true } },
  setup(props) {
    return () =>
      h('div', { class: 'p-4 rounded-xl bg-gray-50 dark:bg-gray-900/40 border border-gray-100 dark:border-gray-800' }, [
        h('p', { class: 'text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mb-1' }, props.label),
        h('p', { class: 'text-xl font-black text-gray-900 dark:text-white' }, props.value as any)
      ])
  }
})

const icons = { ShipIcon, BeakerIcon, CalenderIcon }
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  height: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #e5e7eb;
  border-radius: 9999px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #1f2937;
}
</style>

