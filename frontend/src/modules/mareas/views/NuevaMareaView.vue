<template>
  <AdminLayout 
    title="Registrar Nueva Marea" 
    description="Complete los pasos para dar de alta una nueva designación de marea."
  >
    <div class="max-w-4xl mx-auto pb-6">
      <!-- Wizard Progress Stepper -->
      <div class="mb-8">
        <div class="flex items-center justify-between relative">
          <!-- Connection Line -->
          <div class="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 dark:bg-gray-800 -z-10 -translate-y-1/2"></div>
          <div 
            class="absolute top-1/2 left-0 h-0.5 bg-brand-500 transition-all duration-500 -z-10 -translate-y-1/2"
            :style="{ width: progressLineWidth }"
          ></div>

          <!-- Step Indicators -->
          <div 
            v-for="step in steps" 
            :key="step.id"
            class="flex flex-col items-center gap-2"
          >
            <div 
              class="w-8 h-8 rounded-full flex items-center justify-center border-2 transition-all duration-300"
              :class="[
                currentStep >= step.id 
                  ? 'bg-brand-500 border-brand-100 dark:border-brand-900/50 text-white shadow-lg shadow-brand-500/20 scale-110' 
                  : 'bg-white dark:bg-gray-900 border-gray-100 dark:border-gray-800 text-gray-400'
              ]"
            >
              <CheckIcon v-if="currentStep > step.id" class="w-5 h-5" />
              <component v-else :is="step.icon" class="w-5 h-5" />
            </div>
            <span 
              class="text-[10px] font-bold uppercase tracking-widest transition-colors duration-300"
              :class="currentStep >= step.id ? 'text-brand-500' : 'text-gray-400'"
            >
              {{ step.name }}
            </span>
          </div>
        </div>
      </div>

      <!-- Step Content -->
      <div class="bg-white dark:bg-gray-950 border border-gray-200 dark:border-gray-800 rounded-3xl p-6 sm:p-8 shadow-xl shadow-gray-200/50 dark:shadow-none min-h-[380px] flex flex-col">
        
        <!-- Loading State for Catalogs -->
        <div v-if="loadingCatalogs" class="flex-1 flex flex-col items-center justify-center py-20">
          <div class="loading loading-spinner loading-lg text-brand-500"></div>
          <p class="mt-4 text-gray-500 font-bold uppercase tracking-widest text-[10px]">Cargando catálogos oficiales...</p>
        </div>

        <template v-else>
          <!-- Step 1: Identificación -->
          <div v-if="currentStep === 1" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
              <h2 class="text-xl font-bold text-gray-800 dark:text-white">Identificación de la Marea</h2>
              <p class="text-gray-500 text-xs mt-1">Seleccione el buque y defina la numeración oficial para el ciclo actual.</p>
            </div>

            <div class="space-y-10">
              <!-- Compact & Balanced Tide Type Selector -->
              <div class="flex flex-col items-center gap-4">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Tipo de Designación</label>
                <div class="inline-flex p-1 bg-gray-100 dark:bg-gray-900 rounded-xl border border-gray-200 dark:border-gray-800">
                  <button 
                    type="button"
                    @click="form.tipoMarea = 'COMERCIAL'"
                    class="px-6 py-2.5 rounded-lg text-xs font-bold uppercase tracking-wider transition-all flex items-center gap-2"
                    :class="form.tipoMarea === 'COMERCIAL' ? 'bg-white dark:bg-gray-800 text-brand-600 shadow-sm ring-1 ring-black/5' : 'text-gray-500 hover:text-gray-700'"
                  >
                    <div class="w-1.5 h-1.5 rounded-full" :class="form.tipoMarea === 'COMERCIAL' ? 'bg-brand-500' : 'bg-transparent border border-gray-300'"></div>
                    Comercial (MC)
                  </button>
                  <button 
                    type="button"
                    @click="form.tipoMarea = 'INSTITUCIONAL'"
                    class="px-6 py-2.5 rounded-lg text-xs font-bold uppercase tracking-wider transition-all flex items-center gap-2"
                    :class="form.tipoMarea === 'INSTITUCIONAL' ? 'bg-white dark:bg-gray-800 text-blue-600 shadow-sm ring-1 ring-black/5' : 'text-gray-500 hover:text-gray-700'"
                  >
                    <div class="w-1.5 h-1.5 rounded-full" :class="form.tipoMarea === 'INSTITUCIONAL' ? 'bg-blue-500' : 'bg-transparent border border-gray-300'"></div>
                    Institucional (CI)
                  </button>
                </div>
              </div>

              <!-- Symmetrical Grid -->
              <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-end">
                <div class="md:col-span-7 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-400 mb-1.5">Buque Seleccionado</label>
                    <SearchableSelect 
                      ref="buqueSelect"
                      v-model="form.buqueId"
                      :options="buqueOptions"
                      :icon="ShipIcon"
                      :error="fieldErrors.buqueId"
                      placeholder="Seleccione el buque..."
                      @change="handleBuqueChange"
                    />
                    <p v-if="fieldErrors.buqueId" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.buqueId }}</p>
                  </div>
                </div>

                <div class="md:col-span-5 grid grid-cols-2 gap-4">
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Año</label>
                    <input 
                      v-model="form.anioMarea"
                      type="number"
                      class="w-full px-4 py-2.5 bg-gray-50/50 dark:bg-gray-900 border rounded-lg text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all"
                      :class="fieldErrors.anioMarea ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800'"
                    />
                  </div>
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Nro. Marea</label>
                    <input 
                      v-model="form.nroMarea"
                      type="number"
                      placeholder="000"
                      class="w-full px-4 py-2.5 bg-gray-50/50 dark:bg-gray-900 border rounded-lg text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all"
                      :class="fieldErrors.nroMarea ? 'border-red-500 bg-red-50/30' : 'border-gray-100 dark:border-gray-800'"
                    />
                  </div>
                </div>
              </div>

              <!-- Real-time Code Preview Badge -->
              <div class="flex justify-center pt-2">
                <div class="px-6 py-3 bg-brand-50 dark:bg-brand-500/5 rounded-xl border border-dashed border-brand-200 dark:border-brand-500/20 flex flex-col items-center gap-0.5 group transition-all hover:bg-brand-100/50">
                  <span class="text-[8px] font-bold text-brand-400 uppercase tracking-[0.2em]">Código Identificador Generado</span>
                  <span class="text-2xl font-bold text-brand-600 dark:text-brand-400 font-mono tracking-tighter transition-transform group-hover:scale-105">{{ generatedCode }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Step 2: Operación -->
          <div v-if="currentStep === 2" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-4">
              <h2 class="text-xl font-bold text-gray-800 dark:text-white">Configuración Operativa</h2>
              <p class="text-gray-500 text-xs mt-1">Defina la pesquería y asigne el observador principal para el viaje.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Pesquería</label>
                <SearchableSelect 
                  v-model="form.pesqueriaId"
                  :options="pesqueriaOptions"
                  :icon="WaveIcon"
                  :error="fieldErrors.pesqueriaId"
                  placeholder="Seleccione la pesquería..."
                />
                <p v-if="fieldErrors.pesqueriaId" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.pesqueriaId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Arte de Pesca</label>
                <SearchableSelect 
                  v-model="form.arteId"
                  :options="arteOptions"
                  :icon="SettingsIcon"
                  placeholder="Seleccione el arte..."
                />
                <p v-if="fieldErrors.arteId" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.arteId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Observador Asignado</label>
                <SearchableSelect 
                  ref="observadorSelect"
                  v-model="form.observadorId"
                  :options="observadorOptions"
                  :icon="BeakerIcon"
                  :error="fieldErrors.observadorId"
                  placeholder="Seleccione el observador..."
                />
                <p v-if="fieldErrors.observadorId" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.observadorId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Fecha Zarpada Estimada</label>
                <DatePicker 
                  v-model="form.fechaZarpadaEstimada"
                  :icon="CalenderIcon"
                  :show-time="false"
                  :error="fieldErrors.fechaZarpadaEstimada"
                />
                <p v-if="fieldErrors.fechaZarpadaEstimada" class="text-[10px] text-red-500 font-bold uppercase mt-1">{{ fieldErrors.fechaZarpadaEstimada }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Días Estimados</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <HistoryIcon class="h-5 w-5 text-gray-400" />
                  </div>
                  <input 
                    v-model.number="form.diasEstimados"
                    type="number"
                    min="1"
                    placeholder="Días"
                    class="block w-full pl-10 pr-3 py-2.5 bg-gray-50/50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl font-bold text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all placeholder:text-gray-400/50 text-sm"
                  />
                </div>
              </div>
            </div>
          </div>

          <!-- Step 3: Confirmación -->
          <div v-if="currentStep === 3" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-4 text-center">
              <div class="w-12 h-12 bg-brand-50 dark:bg-brand-500/10 rounded-full flex items-center justify-center mx-auto mb-3">
                <CheckIcon class="w-6 h-6 text-brand-500" />
              </div>
              <h2 class="text-xl font-bold text-gray-800 dark:text-white">Verificar y Registrar</h2>
              <p class="text-gray-500 text-xs mt-1">Revise los datos antes de persistir la nueva marea en el sistema.</p>
            </div>

            <div v-if="error" class="p-4 bg-red-50 dark:bg-red-500/10 border border-red-100 dark:border-red-500/20 rounded-2xl text-red-600 text-sm font-bold text-center">
              {{ error }}
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="p-6 bg-gray-50/50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-xl">
                <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-2">Identificación</p>
                <p class="text-sm font-bold text-gray-800 dark:text-gray-200">{{ getBuqueName(form.buqueId) }}</p>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-xs font-mono text-brand-500 uppercase font-bold tracking-tighter">{{ generatedCode }}</span>
                  <span class="px-1.5 py-0.5 rounded bg-gray-100 dark:bg-gray-800 text-[9px] font-bold text-gray-500 uppercase">{{ form.tipoMarea }}</span>
                </div>
              </div>
              <div class="p-6 bg-gray-50/50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-xl">
                <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mb-2">Operación</p>
                <p class="text-sm font-bold text-gray-800 dark:text-gray-200">{{ getPesqueriaName(form.pesqueriaId) }}</p>
                <p class="text-xs text-gray-500 mt-0.5">Obs: {{ getObserverName(form.observadorId) }}</p>
                <p v-if="form.diasEstimados" class="text-xs text-gray-400 mt-0.5">Est: {{ form.diasEstimados }} días</p>
              </div>
            </div>

            <div class="p-4 bg-amber-50 dark:bg-amber-500/5 border border-amber-100 dark:border-amber-500/20 rounded-2xl flex gap-4">
              <InfoIcon class="w-5 h-5 text-amber-500 shrink-0" />
              <p class="text-[11px] text-amber-800/80 dark:text-amber-300/80 leading-relaxed italic">
                Al confirmar, se enviará una notificación al observador y la marea quedará en estado **DESIGNADA** disponible en el Panel Operativo.
              </p>
            </div>
          </div>
        </template>

        <!-- Actions -->
        <div class="mt-auto pt-6 flex items-center justify-between border-t border-gray-100 dark:border-gray-800">
          <button 
            @click="prevStep"
            v-if="currentStep > 1"
            class="px-6 py-3 text-sm font-bold text-gray-500 hover:text-gray-800 dark:hover:text-gray-200 transition-all flex items-center gap-2"
          >
            Anterior
          </button>
          <div v-else></div>

          <div class="flex gap-3">
            <button 
              @click="cancel"
              class="px-6 py-3 text-sm font-bold text-gray-400 hover:text-red-500 transition-all"
            >
              Cancelar
            </button>
            <button 
              @click="nextStep"
              :disabled="loading"
              class="px-8 py-3 bg-brand-500 hover:bg-brand-600 text-white rounded-2xl text-sm font-bold shadow-xl shadow-brand-500/20 transition-all active:scale-[0.98] flex items-center gap-2 active:shadow-inner disabled:opacity-50"
            >
              <div v-if="loading" class="loading loading-spinner loading-xs"></div>
              <template v-else>
                {{ currentStep === 3 ? 'Finalizar Registro' : 'Siguiente Paso' }}
                <ChevronRightIcon v-if="currentStep < 3" class="w-4 h-4" />
              </template>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Cancel Confirmation Modal -->
    <ConfirmationDialog
      :show="showCancelConfirm"
      title="¿Cancelar Registro?"
      message="Si cancela ahora, perderá todos los datos ingresados en el formulario. ¿Está seguro de que desea continuar?"
      confirm-text="Si, Cancelar"
      cancel-text="Volver"
      @close="showCancelConfirm = false"
      @confirm="confirmCancel"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue'
import { useMareas } from '../composables/useMareas'
import catalogosService from '../services/catalogos.service'
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
} from '@/icons'

const router = useRouter()
const { createMarea, loading, error } = useMareas()

// Steps
const steps = [
  { id: 1, name: 'Identificación', icon: DocsIcon },
  { id: 2, name: 'Operación', icon: RefreshIcon },
  { id: 3, name: 'Confirmación', icon: CheckIcon },
]
const currentStep = ref(1)

// Form
const form = ref({
  buqueId: '',
  anioMarea: new Date().getFullYear(),
  nroMarea: null as number | null,
  tipoMarea: 'COMERCIAL' as 'COMERCIAL' | 'INSTITUCIONAL',
  pesqueriaId: '',
  observadorId: '',
  arteId: '',
  fechaZarpadaEstimada: '',
  diasEstimados: null as number | null,
})

const fieldErrors = ref<Record<string, string>>({})
const showCancelConfirm = ref(false)

// Refs for focus
const buqueSelect = ref<any>(null)
const observadorSelect = ref<any>(null)

// Catalogs
const loadingCatalogs = ref(true)
const buques = ref<any[]>([])
const pesquerias = ref<any[]>([])
const observadores = ref<any[]>([])
const artes = ref<any[]>([])

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
  return observadores.value.map(o => ({
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

onMounted(async () => {
  try {
    const [b, p, o, a] = await Promise.all([
      catalogosService.getBuques(),
      catalogosService.getPesquerias(),
      catalogosService.getObservadores(),
      catalogosService.getArtesPesca()
    ])
    buques.value = b
    pesquerias.value = p
    observadores.value = o
    artes.value = a
  } catch (err) {
    console.error('Error loading catalogs:', err)
  } finally {
    loadingCatalogs.value = false
    // Focus first field once catalogs are loaded
    nextTick(() => {
      buqueSelect.value?.focus()
    })
  }
})

// Auto-focus logic when step changes
watch(currentStep, (newStep) => {
  nextTick(() => {
    if (newStep === 1) {
      buqueSelect.value?.focus()
    } else if (newStep === 2) {
      observadorSelect.value?.focus()
    }
  })
})

const generatedCode = computed(() => {
  if (!form.value.nroMarea) return '---'
  const prefix = form.value.tipoMarea === 'INSTITUCIONAL' ? 'CI' : 'MC'
  const shortYear = form.value.anioMarea.toString().slice(-2)
  return `${prefix}-${form.value.nroMarea}-${shortYear}`
})

const handleBuqueChange = () => {
  const buque = buques.value.find(b => b.id === form.value.buqueId)
  if (buque) {
    if (buque.pesqueriaHabitualId) form.value.pesqueriaId = buque.pesqueriaHabitualId
    if (buque.arteHabitualId) form.value.arteId = buque.arteHabitualId
    if (buque.diasMareaEstimada) form.value.diasEstimados = buque.diasMareaEstimada
  }
}

const progressLineWidth = computed(() => {
  return `${((currentStep.value - 1) / (steps.length - 1)) * 100}%`
})

const validateStep = (step: number) => {
  fieldErrors.value = {}
  
  if (step === 1) {
    if (!form.value.buqueId) fieldErrors.value.buqueId = 'El buque es obligatorio'
    if (!form.value.anioMarea) fieldErrors.value.anioMarea = 'El año es obligatorio'
    if (!form.value.nroMarea) fieldErrors.value.nroMarea = 'El número de marea es obligatorio'
    if (form.value.nroMarea && form.value.nroMarea <= 0) fieldErrors.value.nroMarea = 'Número inválido'
  }
  
  if (step === 2) {
    if (!form.value.pesqueriaId) fieldErrors.value.pesqueriaId = 'La pesquería es obligatoria'
    if (!form.value.observadorId) fieldErrors.value.observadorId = 'Debe asignar un observador'
    if (!form.value.arteId) fieldErrors.value.arteId = 'El arte de pesca es obligatorio'
    if (!form.value.fechaZarpadaEstimada) fieldErrors.value.fechaZarpadaEstimada = 'La fecha de zarpada es obligatoria'
  }
  
  return Object.keys(fieldErrors.value).length === 0
}

const nextStep = async () => {
  if (currentStep.value < 3) {
    if (!validateStep(currentStep.value)) return
    currentStep.value++
  } else {
    try {
      await createMarea(form.value)
      router.push('/mareas/dashboard')
    } catch (err) {
      console.error('Error creating marea:', err)
    }
  }
}

const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
    fieldErrors.value = {}
  }
}

const cancel = () => {
  showCancelConfirm.value = true
}

const confirmCancel = () => {
  router.push('/mareas/dashboard')
}

// Helpers for summary
const getBuqueName = (id: string) => buques.value.find(b => b.id === id)?.nombreBuque || '---'
const getPesqueriaName = (id: string) => pesquerias.value.find(p => p.id === id)?.nombre || '---'
const getObserverName = (id: string) => {
  const o = observadores.value.find(obs => obs.id === id)
  return o ? `${o.apellido}, ${o.nombre}` : '---'
}
</script>


