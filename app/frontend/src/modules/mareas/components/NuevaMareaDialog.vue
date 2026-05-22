<template>
  <BaseModal :show="show" @close="close" maxWidth="5xl" title="Registrar Nueva Marea">
    <div class="pb-2">
      <!-- Wizard Progress Stepper -->
      <div class="mb-8">
        <div class="flex items-center justify-between relative">
          <!-- Connection Line -->
          <div class="absolute top-1/2 left-0 w-full h-0.5 bg-surface-muted -z-10 -translate-y-1/2"></div>
          <div class="absolute top-1/2 left-0 h-0.5 bg-primary transition-all duration-500 -z-10 -translate-y-1/2"
            :style="{ width: progressLineWidth }"></div>

          <!-- Step Indicators -->
          <div v-for="step in steps" :key="step.id" class="flex flex-col items-center gap-2">
            <div class="w-8 h-8 rounded-full flex items-center justify-center border-2 transition-all duration-300"
              :class="[
                currentStep >= step.id
                  ? 'bg-primary border-primary/50 text-primary-fg shadow-theme-xs shadow-primary/20 scale-110'
                  : 'bg-surface border-border text-text-muted'
              ]">
              <CheckIcon v-if="currentStep > step.id" class="w-5 h-5" />
              <component v-else :is="step.icon" class="w-5 h-5" />
            </div>
            <span class="text-[10px] font-bold uppercase tracking-widest transition-colors duration-300"
              :class="currentStep >= step.id ? 'text-primary' : 'text-text-muted'">
              {{ step.name }}
            </span>
          </div>
        </div>
      </div>

      <!-- Step Content -->
      <div
        v-form-nav
        class="bg-surface border border-border shadow-theme-xs min-h-[380px] flex flex-col rounded-2xl overflow-hidden p-6">

        <!-- Loading State for Catalogs -->
        <div v-if="loadingCatalogs" class="flex-1 flex flex-col items-center justify-center py-20">
          <LoadingSpinner size="xl" class="text-primary" />
          <p class="mt-4 text-text-muted font-black uppercase tracking-widest text-[10px]">Cargando catálogos
            oficiales...</p>
        </div>

        <template v-else>
          <!-- Step 1: Identificación -->
          <div v-if="currentStep === 1" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4">
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Identificación de la Marea</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Seleccione el buque y defina la numeración oficial
                para el ciclo actual.</p>
            </div>

            <div class="space-y-10">
              <!-- Compact & Balanced Tide Type Selector -->
              <div class="flex flex-col items-center gap-4">
                <label class="block text-xs font-black uppercase tracking-widest text-text-muted">Tipo de
                  Designación</label>
                <div class="inline-flex p-1 bg-surface-muted border-border">
                <div class="grid grid-cols-2 gap-4 w-full max-w-lg">
                  <button type="button" @click="form.tipoMarea = TipoMarea.MC"
                    class="relative flex flex-col p-4 w-full rounded-2xl border-2 transition-all duration-200 text-left overflow-hidden group"
                    :class="form.tipoMarea === TipoMarea.MC ? 'bg-surface text-primary shadow-theme-xs ring-1 ring-border border-primary' : 'text-text-muted hover:text-text border-transparent bg-surface-muted'">
                    <div class="flex items-center justify-between mb-1.5">
                      <span class="w-4 h-4 rounded-full flex items-center justify-center border-2 transition-colors duration-200 shrink-0"
                      :class="form.tipoMarea === TipoMarea.MC ? 'bg-primary border-primary' : 'bg-transparent border-border'">
                        <div v-if="form.tipoMarea === TipoMarea.MC" class="w-1.5 h-1.5 bg-surface rounded-full"></div>
                      </span>
                      <span class="text-xs font-black uppercase tracking-wider ml-3">{{ TIPO_MAREA_DESC[TipoMarea.MC] }}</span>
                    </div>
                  </button>
                  <button type="button" @click="form.tipoMarea = TipoMarea.CI"
                    class="relative flex flex-col p-4 w-full rounded-2xl border-2 transition-all duration-200 text-left overflow-hidden group"
                    :class="form.tipoMarea === TipoMarea.CI ? 'bg-surface text-primary shadow-theme-xs ring-1 ring-border border-primary' : 'text-text-muted hover:text-text border-transparent bg-surface-muted'">
                    <div class="flex items-center justify-between mb-1.5">
                      <span class="w-4 h-4 rounded-full flex items-center justify-center border-2 transition-colors duration-200 shrink-0"
                      :class="form.tipoMarea === TipoMarea.CI ? 'bg-primary border-primary' : 'bg-transparent border-border'">
                        <div v-if="form.tipoMarea === TipoMarea.CI" class="w-1.5 h-1.5 bg-surface rounded-full"></div>
                      </span>
                      <span class="text-xs font-black uppercase tracking-wider ml-3">{{ TIPO_MAREA_DESC[TipoMarea.CI] }}</span>
                    </div>
                  </button>
                </div>
              </div>
            </div>

              <!-- Symmetrical Grid -->
              <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-end">
                <div class="md:col-span-7 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-text-muted mb-1.5">Buque Seleccionado</label>
                    <SearchableSelect ref="buqueSelect" v-model="form.buqueId" :options="buqueOptions" :icon="ShipIcon"
                      :error="fieldErrors.buqueId" placeholder="Seleccione el buque..." @change="handleBuqueChange" />
                  </div>
                </div>

                <div class="md:col-span-5 grid grid-cols-2 gap-4">
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-text-muted">Año</label>
                    <input v-model="form.anioMarea" type="number"
                      class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
                      :class="fieldErrors.anioMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                  </div>
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-text-muted">Nro. Marea</label>
                    <input ref="nroMareaInput" v-model="form.nroMarea" type="number" placeholder="000"
                      class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
                      :class="fieldErrors.nroMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                    <p v-if="fieldErrors.nroMarea" class="text-[10px] text-error font-bold uppercase mt-1">{{
                      fieldErrors.nroMarea }}</p>
                  </div>
                </div>
              </div>

              <!-- Real-time Code Preview Badge -->
              <div class="flex justify-center pt-2">
                <div
                  class="px-6 py-3 bg-primary/5 rounded-xl border border-dashed border-primary/20 flex flex-col items-center gap-0.5 group transition-all hover:bg-primary/10">
                  <span class="text-[8px] font-bold text-primary/40 uppercase tracking-[0.2em]">Código Identificador
                    Generado</span>
                  <span
                    class="text-2xl font-bold text-primary font-mono tracking-tighter transition-transform group-hover:scale-105">{{
                      generatedCode }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Step 2: Operación -->
          <div v-if="currentStep === 2" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4">
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Configuración Operativa</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Defina la pesquería y asigne el observador principal
                para el viaje.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Arte de Pesca</label>
                <SearchableSelect ref="arteSelect" v-model="form.arteId" :options="arteOptions" :icon="SettingsIcon"
                  placeholder="Seleccione el arte..." :error="fieldErrors.arteId" />
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Observador Asignado</label>
                <SearchableSelect ref="observadorSelect" v-model="form.observadorId" :options="observadorOptions"
                  :icon="BeakerIcon" :error="fieldErrors.observadorId" placeholder="Seleccione el observador..." />
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Pesquería</label>
                <SearchableSelect v-model="form.pesqueriaId" :options="pesqueriaOptions" :icon="WaveIcon"
                  :error="fieldErrors.pesqueriaId" placeholder="Seleccione la pesquería..." />
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Fecha Zarpada Estimada</label>
                <DatePicker v-model="form.fechaZarpadaEstimada" :icon="CalenderIcon" :show-time="false"
                  :error="fieldErrors.fechaZarpadaEstimada" />
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Días Estimados</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <HistoryIcon class="h-5 w-5 text-text-muted" />
                  </div>
                  <input v-model.number="form.diasEstimados" type="number" min="1" placeholder="Días"
                    class="block w-full pl-10 pr-3 py-2.5 bg-surface border border-border rounded-lg font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all placeholder:text-text-muted/40 text-sm shadow-theme-xs" />
                </div>
              </div>
            </div>
          </div>

          <!-- Step 3: Etapas Iniciales -->
          <div v-if="currentStep === 3" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4 flex justify-between items-end">
              <div>
                <h2 class="text-xl font-black uppercase tracking-tight text-text">Etapas del Viaje</h2>
                <p class="text-text-muted text-xs font-medium mt-1">Defina las etapas de navegación iniciales si ya son
                  conocidas.</p>
              </div>
              <div v-if="form.tipoMarea === TipoMarea.MC" class="flex items-center gap-2 px-4 py-2 bg-primary/5 rounded-xl border border-primary/20">
                <input id="iniciaEnProspeccion" type="checkbox" v-model="form.iniciaEnProspeccion" class="w-4 h-4 text-primary bg-surface border-border rounded focus:ring-primary focus:ring-2 cursor-pointer transition-colors">
                <label for="iniciaEnProspeccion" class="text-[10px] font-black uppercase tracking-wider text-primary cursor-pointer select-none">Inicia en prospección</label>
              </div>
            </div>

            <div v-if="form.etapas.length > 0" class="p-4 bg-primary/5 border border-primary/20 rounded-xl mb-6">
              <label class="block text-xs font-black uppercase tracking-widest text-primary mb-3">Inicio de Actividad
                del Observador</label>
              <div class="max-w-xs">
                <DatePicker v-model="form.fechaInicioObservador" :icon="CalenderIcon" :show-time="false"
                  :error="fieldErrors.fechaInicioObservador" placeholder="Fecha de inicio..." />
              </div>
              <p class="text-[10px] text-text-muted mt-2 italic">* Requerido al definir etapas manuales.</p>
            </div>

            <NavigationStagesEditor v-model="form.etapas" :puerto-options="puertoOptions"
              :pesqueria-options="pesqueriaOptions" :default-pesqueria-id="form.pesqueriaId" :errors="fieldErrors"
              :default-fecha-zarpada="form.fechaZarpadaEstimada" :puerto-base-id="form.puertoBaseId" :tipoMarea="form.tipoMarea" />
          </div>

          <!-- Step 4: Confirmación -->
          <div v-if="currentStep === 4" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4 text-center">
              <div class="w-12 h-12 bg-success/10 rounded-full flex items-center justify-center mx-auto mb-3">
                <CheckIcon class="w-6 h-6 text-success" />
              </div>
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Verificar y Registrar</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Revise los datos antes de persistir la nueva marea en
                el sistema.</p>
            </div>

            <div v-if="error"
              class="p-4 bg-error/5 border border-error/20 rounded-xl text-error text-[10px] font-black uppercase tracking-widest text-center">
              {{ error }}
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="p-6 bg-surface-muted rounded-xl border border-border/50">
                <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-2">Identificación</p>
                <p class="text-sm font-black uppercase text-text">{{ getBuqueName(form.buqueId) }}</p>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-xs font-mono text-primary uppercase font-bold tracking-tighter">{{ generatedCode
                  }}</span>
                  <span
                    class="px-1.5 py-0.5 rounded bg-surface text-[9px] font-black text-text-muted uppercase border border-border">{{
                      form.tipoMarea }}</span>
                </div>
              </div>
              <div class="p-6 bg-surface-muted rounded-xl border border-border/50">
                <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-2">Operación</p>
                <p class="text-sm font-black uppercase text-text">{{ getPesqueriaName(form.pesqueriaId) }}</p>
                <p class="text-xs text-text-muted font-medium mt-0.5">Obs: {{ getObserverName(form.observadorId) }}</p>
                <p v-if="form.diasEstimados" class="text-xs text-text-muted font-medium mt-0.5">Est: {{
                  form.diasEstimados }} días</p>
              </div>
            </div>

            <div v-if="form.etapas.length > 0" class="p-6 bg-surface-muted rounded-xl border border-border/50">
              <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-2">Etapas Definidas</p>
              <div v-if="form.fechaInicioObservador"
                class="mb-3 pb-3 border-b border-border/50 flex items-center justify-between">
                <span class="text-[10px] font-bold text-text-muted uppercase tracking-tight">Inicio Observador:</span>
                <span class="text-xs font-black text-primary">{{ formatDate(form.fechaInicioObservador, true) }}</span>
              </div>
              <ul class="space-y-2">
                <li v-for="(etapa, idx) in form.etapas" :key="idx"
                  class="text-xs text-text-muted flex items-center gap-2">
                  <div class="w-1.5 h-1.5 rounded-full bg-primary/40"></div>
                  Etapa {{ etapa.nroEtapa || (idx + 1) }}: Zarpada {{ formatDate(etapa.fechaZarpada) }}
                </li>
              </ul>
            </div>

            <div class="p-4 bg-warning/5 border border-warning/20 rounded-xl flex gap-4">
              <InfoIcon class="w-5 h-5 text-warning shrink-0" />
              <p class="text-[11px] text-warning/80 leading-relaxed font-medium italic">
                Al confirmar, la marea quedará en estado **DESIGNADA** disponible en el Panel Operativo.
              </p>
            </div>
          </div>
        </template>

        <!-- Actions -->
        <div class="mt-auto pt-6 flex items-center justify-between border-t border-border">
          <button @click="prevStep" v-if="currentStep > 1"
            class="px-6 py-3 text-sm font-bold text-text-muted hover:text-text transition-all flex items-center gap-2">
            Anterior
          </button>
          <div v-else></div>

          <div class="flex gap-3">
            <button @click="cancel"
              class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">
              Cancelar
            </button>
            <button @click="nextStep" :disabled="loading"
              :data-allow-enter="currentStep === 4"
              class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 flex items-center gap-2 disabled:opacity-50">
              <div v-if="loading" class="flex items-center justify-center">
                <LoadingSpinner size="xs" class="text-primary-fg" />
              </div>
              <template v-else>
                {{ currentStep === 4 ? 'Finalizar Registro' : 'Siguiente Paso' }}
                <ChevronRightIcon v-if="currentStep < 4" class="w-4 h-4" />
              </template>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Year Conflict Confirmation Modal -->
    <ConfirmationDialog :show="showYearConfirm" title="Año de Marea Diferente"
      :message="`El año seleccionado (${form.anioMarea}) no coincide con el Año Operativo del sistema (${configStore.selectedYear}). ¿Desea continuar con esta designación?`"
      confirm-text="Sí, Continuar" cancel-text="Corregir Año" @close="showYearConfirm = false"
      @confirm="confirmYearAndNext" />

    <!-- Cancel Confirmation Modal -->
    <ConfirmationDialog :show="showCancelConfirm" title="¿Cancelar Registro?"
      message="Si cancela ahora, perderá todos los datos ingresados en el formulario. ¿Está seguro de que desea continuar?"
      confirm-text="Si, Cancelar" cancel-text="Volver" @close="showCancelConfirm = false" @confirm="confirmCancel" />
    <!-- Confirmation Ports Missing -->
    <ConfirmationDialog :show="showPortsConfirm" title="Puertos No Especificados" type="warning"
      message="Ha dejado etapas sin puerto de zarpada o arribo especificado. Esto se registrará como una etapa administrativa en alta mar. ¿Desea continuar?"
      confirm-text="Sí, continuar" cancel-text="Revisar etapas" @confirm="confirmPortsAndNext" @cancel="showPortsConfirm = false" />

  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue'
import NavigationStagesEditor from './NavigationStagesEditor.vue'
import { TipoMarea, TIPO_MAREA_DESC } from '../types/enums';
import { useMareas } from '../composables/useMareas'
import { useWorkflowStore } from '../../shared/stores/workflow.store'
import { useConfigStore } from '../../shared/stores/config.store'
import { alertsService } from '@/modules/alerts/services/alerts.service'
import catalogosService from '../services/catalogos.service'
import mareasService from '../services/mareas.service'
import {
  ShipIcon,
  DocsIcon,
  RefreshIcon,
  CheckIcon,
  ChevronRightIcon,
  InfoIcon,
  WaveIcon,
  SettingsIcon,
  BeakerIcon,
  CalenderIcon,
  HistoryIcon,
  MapPinIcon
} from '@/icons'

const props = defineProps<{
  show: boolean
  initFromAlert?: boolean
}>()

const emit = defineEmits(['close', 'success'])
const router = useRouter()
const workflowStore = useWorkflowStore()
const configStore = useConfigStore()
const { createMarea, loading, error } = useMareas()

// Steps
const steps = [
  { id: 1, name: 'Identificación', icon: DocsIcon },
  { id: 2, name: 'Operación', icon: RefreshIcon },
  { id: 3, name: 'Etapas del Viaje', icon: MapPinIcon },
  { id: 4, name: 'Confirmación', icon: CheckIcon },
]
const currentStep = ref(1)

// Form initial state
const getInitialForm = () => ({
  buqueId: '',
  anioMarea: configStore.selectedYear,
  nroMarea: null as number | null,
  tipoMarea: TipoMarea.MC as TipoMarea,
  pesqueriaId: '',
  observadorId: '',
  arteId: '',
  fechaZarpadaEstimada: '',
  fechaInicioObservador: '',
  diasEstimados: null as number | null,
  puertoBaseId: '',
  iniciaEnProspeccion: false,
  etapas: [] as any[]
})

const form = ref(getInitialForm())

const fieldErrors = ref<Record<string, string>>({})
const showCancelConfirm = ref(false)
const showYearConfirm = ref(false)
const showPortsConfirm = ref(false)

// Refs for focus
const buqueSelect = ref<any>(null)
const nroMareaInput = ref<HTMLInputElement | null>(null)
const arteSelect = ref<any>(null)
const observadorSelect = ref<any>(null)

// Catalogs
const loadingCatalogs = ref(true)
const buques = ref<any[]>([])
const pesquerias = ref<any[]>([])
const observadores = ref<any[]>([])
const artes = ref<any[]>([])
const puertos = ref<any[]>([])

const buqueOptions = computed(() => {
  return buques.value.map(b => ({
    value: b.id,
    label: `${b.nombreBuque} (${b.matricula})`
  }))
})

const pesqueriaOptions = computed(() => {
  return pesquerias.value.map(p => ({
    value: p.id,
    label: p.nombre
  }))
})

const observadorOptions = computed(() => {
  return observadores.value
    .map(o => ({
      value: o.id,
      label: `${o.apellido}, ${o.nombre}`
    }))
})

const arteOptions = computed(() => {
  return artes.value.map(a => ({
    value: a.id,
    label: a.nombre
  }))
})

const puertoOptions = computed(() => {
  return puertos.value.map(p => ({
    value: p.id,
    label: p.nombre
  }))
})

onMounted(async () => {
  try {
    const [b, p, o, a, pu] = await Promise.all([
      catalogosService.getBuques(),
      catalogosService.getPesquerias(),
      catalogosService.getObservadores(true),
      catalogosService.getArtesPesca(),
      catalogosService.getPuertos()
    ])
    buques.value = b
    pesquerias.value = p
    observadores.value = o
    artes.value = a
    puertos.value = pu

    // Check for workflow data (pre-fill from alert)
    if (props.initFromAlert && workflowStore.activeAlertData) {
      prefillFromAlert(workflowStore.activeAlertData)
    }

  } catch (err) {
    console.error('Error loading catalogs:', err)
  } finally {
    loadingCatalogs.value = false
    nextTick(() => {
      setInitialFocus()
    })
  }
})

// Sync on show
watch(() => props.show, (newVal) => {
  if (newVal) {
    form.value = getInitialForm()
    currentStep.value = 1
    fieldErrors.value = {}
    if (props.initFromAlert && workflowStore.activeAlertData) {
      prefillFromAlert(workflowStore.activeAlertData)
    }

    // Sugerir número inicial
    suggestNextNumber()

    nextTick(() => {
      setInitialFocus()
    })
  }
})

// Watchers for automatic numbering
watch([() => form.value.anioMarea, () => form.value.tipoMarea], () => {
  suggestNextNumber()
})

// Clear errors when fields change
watch(() => form.value.buqueId, (val) => {
  if (val && fieldErrors.value.buqueId) delete fieldErrors.value.buqueId
})
watch(() => form.value.nroMarea, (val) => {
  if (val && fieldErrors.value.nroMarea) delete fieldErrors.value.nroMarea
})
watch(() => form.value.pesqueriaId, (val) => {
  if (val && fieldErrors.value.pesqueriaId) delete fieldErrors.value.pesqueriaId
})
watch(() => form.value.arteId, (val) => {
  if (val && fieldErrors.value.arteId) delete fieldErrors.value.arteId
})
watch(() => form.value.observadorId, (val) => {
  if (val && fieldErrors.value.observadorId) delete fieldErrors.value.observadorId
})
watch(() => form.value.fechaZarpadaEstimada, (val) => {
  if (val && fieldErrors.value.fechaZarpadaEstimada) delete fieldErrors.value.fechaZarpadaEstimada
})
watch(() => form.value.fechaInicioObservador, (val) => {
  if (val && fieldErrors.value.fechaInicioObservador) delete fieldErrors.value.fechaInicioObservador
})

watch(() => form.value.etapas, () => {
  // Limpieza reactiva de errores de etapas
  Object.keys(fieldErrors.value).forEach(key => {
    if (key.startsWith('etapa_')) {
      const parts = key.split('_');
      const idx = parseInt(parts[1]);
      const field = parts[2];
      if (form.value.etapas[idx] && form.value.etapas[idx][field]) {
        delete fieldErrors.value[key];
      }
    }
  });
}, { deep: true });

const suggestNextNumber = async () => {
  if (!form.value.anioMarea || !form.value.tipoMarea) return
  try {
    const next = await mareasService.getNextMareaNumber(form.value.anioMarea, form.value.tipoMarea)
    form.value.nroMarea = next
  } catch (err) {
    console.error('Error suggesting marea number:', err)
  }
}

const setInitialFocus = () => {
  if (form.value.buqueId) {
    nroMareaInput.value?.focus()
  } else {
    buqueSelect.value?.focus()
  }
}

const prefillFromAlert = (data: any) => {
  const meta = data.metadata || {}
  const ext = meta.externalData || {}

  if (meta.anioMarea) form.value.anioMarea = meta.anioMarea
  if (meta.nroMarea) form.value.nroMarea = meta.nroMarea
  if (meta.tipoMarea) form.value.tipoMarea = meta.tipoMarea

  // Try to find Buque by name
  if (ext.buque) {
    const match = buques.value.find(b => b.nombreBuque.toLowerCase() === ext.buque.toLowerCase())
    if (match) {
      form.value.buqueId = match.id
      handleBuqueChange()
    }
  }

  // Try to find Observer by code or name
  let obsFound = null;
  if (meta.observerCode) {
    obsFound = observadores.value.find((o: any) => o.codigoInterno == meta.observerCode || o.codigo == meta.observerCode);
    if (obsFound) form.value.observadorId = obsFound.id
  }

  if (!obsFound && meta.observerName) {
    obsFound = observadores.value.find(o =>
      `${o.apellido} ${o.nombre}`.toLowerCase().includes(meta.observerName.toLowerCase()) ||
      `${o.nombre} ${o.apellido}`.toLowerCase().includes(meta.observerName.toLowerCase())
    )
    if (obsFound) form.value.observadorId = obsFound.id
  }

  // Pre-fill fields but DO NOT create stages automatically
  if (ext.fechaZarpada) {
    form.value.fechaZarpadaEstimada = ext.fechaZarpada
  }
}

// Auto-focus logic when step changes
watch(currentStep, (newStep) => {
  nextTick(() => {
    if (newStep === 1) {
      buqueSelect.value?.focus()
    } else if (newStep === 2) {
      observadorSelect.value?.focus()
    } else if (newStep === 3) {
      if (!form.value.fechaInicioObservador && form.value.fechaZarpadaEstimada) {
        form.value.fechaInicioObservador = form.value.fechaZarpadaEstimada
      }
    }
  })
})

const generatedCode = computed(() => {
  if (!form.value.nroMarea) return '---'
  const prefix = form.value.tipoMarea === TipoMarea.CI ? 'CI' : 'MC'
  const shortYear = form.value.anioMarea.toString().slice(-2)
  return `${prefix}-${form.value.nroMarea}-${shortYear}`
})

const handleBuqueChange = () => {
  const buque = buques.value.find(b => b.id === form.value.buqueId)
  if (buque) {
    // Default fishery from ship (now saved in marea header)
    if (buque.pesqueriaHabitualId) {
      form.value.pesqueriaId = buque.pesqueriaHabitualId
    }
    if (buque.arteHabitualId) form.value.arteId = buque.arteHabitualId
    if (buque.diasMareaEstimada) form.value.diasEstimados = buque.diasMareaEstimada
    if (buque.puertoBaseId) form.value.puertoBaseId = buque.puertoBaseId
  }
}

const progressLineWidth = computed(() => {
  return `${((currentStep.value - 1) / (steps.length - 1)) * 100}%`
})

const validateStep = async (step: number) => {
  fieldErrors.value = {}

  if (step === 1) {
    if (!form.value.buqueId) fieldErrors.value.buqueId = 'El buque es obligatorio'
    if (!form.value.anioMarea) fieldErrors.value.anioMarea = 'El año es obligatorio'
    if (!form.value.nroMarea) fieldErrors.value.nroMarea = 'El número de marea es obligatorio'
    if (form.value.nroMarea && form.value.nroMarea <= 0) fieldErrors.value.nroMarea = 'Número inválido'

    if (form.value.buqueId && !fieldErrors.value.buqueId) {
      try {
        const { available, marea } = await mareasService.validateVesselAvailability(form.value.buqueId)
        if (!available) {
          fieldErrors.value.buqueId = `El buque ya tiene una marea designada (${marea})`
        }
      } catch (e) {
        console.error('Error validating vessel:', e)
      }
    }
  }

  if (step === 2) {
    if (!form.value.pesqueriaId) fieldErrors.value.pesqueriaId = 'La pesquería es obligatoria'
    if (!form.value.observadorId) fieldErrors.value.observadorId = 'Debe asignar un observador'
    if (!form.value.arteId) fieldErrors.value.arteId = 'El arte de pesca es obligatorio'
    if (!form.value.fechaZarpadaEstimada) fieldErrors.value.fechaZarpadaEstimada = 'La fecha de zarpada es obligatoria'

    if (form.value.observadorId && !fieldErrors.value.observadorId) {
      try {
        const { available, marea } = await mareasService.validateObserverAvailability(form.value.observadorId)
        if (!available) {
          fieldErrors.value.observadorId = `El observador ya está designado en otra marea (${marea})`
        }
      } catch (e) {
        console.error('Error validating observer:', e)
      }
    }

    if (form.value.fechaZarpadaEstimada && !fieldErrors.value.fechaZarpadaEstimada) {
      const year = new Date(form.value.fechaZarpadaEstimada).getFullYear()
      const mareaYear = form.value.anioMarea
      if (year !== mareaYear && year !== mareaYear + 1) {
        fieldErrors.value.fechaZarpadaEstimada = `El año de la fecha (${year}) debe ser ${mareaYear} o ${mareaYear + 1}`
      }
    }
  }

  if (step === 3) {
    if (form.value.etapas.length > 0) {
      if (!form.value.fechaInicioObservador) {
        fieldErrors.value.fechaInicioObservador = 'Requerido si define etapas'
      }

      const firstStage = form.value.etapas[0]
      if (form.value.fechaInicioObservador) {
        const startObs = new Date(form.value.fechaInicioObservador)
        const obsYear = startObs.getFullYear()
        const mareaYear = form.value.anioMarea
        if (obsYear !== mareaYear && obsYear !== mareaYear + 1) {
          fieldErrors.value.fechaInicioObservador = `El año (${obsYear}) debe ser ${mareaYear} o ${mareaYear + 1}`
        }
        if (firstStage.fechaZarpada) {
          const startTrip = new Date(firstStage.fechaZarpada)
          if (startObs > startTrip) {
            fieldErrors.value.fechaInicioObservador = 'No puede ser posterior a la zarpada'
          }
        }
      }

      form.value.etapas.forEach((etapa: any, idx: number) => {
        if (!etapa.fechaZarpada) {
          fieldErrors.value[`etapa_${idx}_fechaZarpada`] = 'Indique la fecha'
        } else {
          const stageYear = new Date(etapa.fechaZarpada).getFullYear()
          const mareaYear = form.value.anioMarea
          if (stageYear !== mareaYear && stageYear !== mareaYear + 1) {
            fieldErrors.value[`etapa_${idx}_fechaZarpada`] = `El año (${stageYear}) debe ser ${mareaYear} o ${mareaYear + 1}`
          }
        }
        // Removed validation requiring puertoZarpadaId to allow administrative stages
        if (!etapa.pesqueriaId) {
          // Para pesquería no tenemos :error actualmente en el template del editor pero lo agregaremos si es necesario
          // Por ahora nos concentramos en zarpada y puerto que pidió el usuario
          // fieldErrors.value[`etapa_${idx}_pesqueriaId`] = 'Falta pesquería'
        }
      })
    }
  }

  return Object.keys(fieldErrors.value).length === 0
}

const nextStep = async () => {
  if (currentStep.value === 1) {
    if (!(await validateStep(1))) return
    if (form.value.anioMarea !== configStore.selectedYear) {
      showYearConfirm.value = true
      return
    }
    currentStep.value++
    return
  }

  if (currentStep.value < 4) {
    if (!(await validateStep(currentStep.value))) return
    
    // Check for missing ports in step 3
    if (currentStep.value === 3) {
      const hasMissingPorts = form.value.etapas.some((e: any) => !e.puertoZarpadaId || (e.fechaArribo && !e.puertoArriboId));
      if (hasMissingPorts && !showPortsConfirm.value) {
        showPortsConfirm.value = true;
        return;
      }
      showPortsConfirm.value = false;
    }

    currentStep.value++
  } else {
    try {
      const payload = { ...form.value }
      delete (payload as any).puertoBaseId
      if (!payload.fechaZarpadaEstimada) delete (payload as any).fechaZarpadaEstimada
      if (!payload.fechaInicioObservador) delete (payload as any).fechaInicioObservador

      if (payload.etapas && payload.etapas.length > 0) {
        payload.etapas = payload.etapas.map((e: any) => {
          const cleanStage = { ...e }
          if (!cleanStage.fechaZarpada) delete cleanStage.fechaZarpada
          if (!cleanStage.fechaArribo) delete cleanStage.fechaArribo
          if (!cleanStage.puertoZarpadaId) delete cleanStage.puertoZarpadaId
          if (!cleanStage.puertoArriboId) delete cleanStage.puertoArriboId
          if (!cleanStage.pesqueriaId) delete cleanStage.pesqueriaId
          if (!cleanStage.id) delete cleanStage.id
          return cleanStage
        })
      }

      const newMarea = await createMarea(payload)

      if (workflowStore.activeAlertData?.id) {
        try {
          await alertsService.update(workflowStore.activeAlertData.id, {
            estado: 'RESUELTA',
            comment: `Marea ${newMarea.id_marea || 'creada'} registrada exitosamente. Resolución automática.`
          })
          toast.success('Alerta resuelta automáticamente')
        } catch (e) {
          console.error('Error auto-resolving alert:', e)
        }
      }

      toast.success('Marea creada exitosamente')
      emit('success')
    } catch (err: any) {
      console.error('Error creating marea:', err)
      const msg = err.message || 'Error desconocido al crear la marea.'
      error.value = msg
      toast.error('Error al crear marea', { description: msg })
    }
  }
}

const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
    fieldErrors.value = {}
  }
}

const confirmYearAndNext = () => {
  showYearConfirm.value = false
  currentStep.value++
}

const confirmPortsAndNext = () => {
  showPortsConfirm.value = false
  currentStep.value++
}

const cancel = () => {
  showCancelConfirm.value = true
}

const confirmCancel = () => {
  showCancelConfirm.value = false
  emit('close')
}

const close = () => {
  emit('close')
}

// Helpers for summary
const getBuqueName = (id: string) => buques.value.find(b => b.id === id)?.nombreBuque || '---'
const getPesqueriaName = (id: string) => pesquerias.value.find(p => p.id === id)?.nombre || '---'
const getObserverName = (id: string) => {
  const o = observadores.value.find(obs => obs.id === id)
  return o ? `${o.apellido}, ${o.nombre}` : '---'
}
const formatDate = (dateStr?: string, withTime = false) => {
  if (!dateStr) return 'N/D'
  const options: Intl.DateTimeFormatOptions = { day: '2-digit', month: '2-digit', year: 'numeric' }
  if (withTime) {
    options.hour = '2-digit'
    options.minute = '2-digit'
  }
  return new Date(dateStr).toLocaleDateString('es-AR', options)
}
</script>
