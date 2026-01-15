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
          <div class="absolute top-1/2 left-0 w-full h-0.5 bg-surface-muted -z-10 -translate-y-1/2"></div>
          <div 
            class="absolute top-1/2 left-0 h-0.5 bg-primary transition-all duration-500 -z-10 -translate-y-1/2"
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
                  ? 'bg-primary border-primary/50 text-primary-fg shadow-theme-xs shadow-primary/20 scale-110' 
                  : 'bg-surface border-border text-text-muted'
              ]"
            >
              <CheckIcon v-if="currentStep > step.id" class="w-5 h-5" />
              <component v-else :is="step.icon" class="w-5 h-5" />
            </div>
            <span 
              class="text-[10px] font-bold uppercase tracking-widest transition-colors duration-300"
              :class="currentStep >= step.id ? 'text-primary' : 'text-text-muted'"
            >
              {{ step.name }}
            </span>
          </div>
        </div>
      </div>

      <!-- Step Content -->
      <div class="bg-surface border border-border shadow-theme-xs min-h-[380px] flex flex-col rounded-2xl overflow-hidden p-6">
        
        <!-- Loading State for Catalogs -->
        <div v-if="loadingCatalogs" class="flex-1 flex flex-col items-center justify-center py-20">
          <LoadingSpinner size="xl" class="text-primary" />
          <p class="mt-4 text-text-muted font-black uppercase tracking-widest text-[10px]">Cargando catálogos oficiales...</p>
        </div>

        <template v-else>
          <!-- Step 1: Identificación -->
          <div v-if="currentStep === 1" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4">
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Identificación de la Marea</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Seleccione el buque y defina la numeración oficial para el ciclo actual.</p>
            </div>

            <div class="space-y-10">
              <!-- Compact & Balanced Tide Type Selector -->
              <div class="flex flex-col items-center gap-4">
                <label class="block text-xs font-black uppercase tracking-widest text-text-muted">Tipo de Designación</label>
                <div class="inline-flex p-1 bg-surface-muted border-border">
                  <button 
                    type="button"
                    @click="form.tipoMarea = 'COMERCIAL'"
                    class="px-6 py-2.5 rounded-lg text-xs font-bold uppercase tracking-wider transition-all flex items-center gap-2"
                    :class="form.tipoMarea === 'COMERCIAL' ? 'bg-surface text-primary shadow-theme-xs ring-1 ring-border' : 'text-text-muted hover:text-text'"
                  >
                    <div class="w-1.5 h-1.5 rounded-full" :class="form.tipoMarea === 'COMERCIAL' ? 'bg-primary' : 'bg-transparent border border-border'"></div>
                    Comercial (MC)
                  </button>
                  <button 
                    type="button"
                    @click="form.tipoMarea = 'INSTITUCIONAL'"
                    class="px-6 py-2.5 rounded-lg text-xs font-bold uppercase tracking-wider transition-all flex items-center gap-2"
                    :class="form.tipoMarea === 'INSTITUCIONAL' ? 'bg-surface text-primary shadow-theme-xs ring-1 ring-border' : 'text-text-muted hover:text-text'"
                  >
                    <div class="w-1.5 h-1.5 rounded-full" :class="form.tipoMarea === 'INSTITUCIONAL' ? 'bg-primary' : 'bg-transparent border border-border'"></div>
                    Institucional (CI)
                  </button>
                </div>
              </div>

              <!-- Symmetrical Grid -->
              <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-end">
                <div class="md:col-span-7 space-y-4">
                  <div>
                    <label class="block text-sm font-medium text-text-muted mb-1.5">Buque Seleccionado</label>
                    <SearchableSelect 
                      ref="buqueSelect"
                      v-model="form.buqueId"
                      :options="buqueOptions"
                      :icon="ShipIcon"
                      :error="fieldErrors.buqueId"
                      placeholder="Seleccione el buque..."
                      @change="handleBuqueChange"
                    />
                    <p v-if="fieldErrors.buqueId" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.buqueId }}</p>
                  </div>
                </div>

                <div class="md:col-span-5 grid grid-cols-2 gap-4">
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-text-muted">Año</label>
                    <input 
                      v-model="form.anioMarea"
                      type="number"
                      class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
                      :class="fieldErrors.anioMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'"
                    />
                  </div>
                  <div class="space-y-1.5">
                    <label class="block text-sm font-medium text-text-muted">Nro. Marea</label>
                    <input 
                      v-model="form.nroMarea"
                      type="number"
                      placeholder="000"
                      class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs"
                      :class="fieldErrors.nroMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'"
                    />
                  </div>
                </div>
              </div>

              <!-- Real-time Code Preview Badge -->
              <div class="flex justify-center pt-2">
                <div class="px-6 py-3 bg-primary/5 rounded-xl border border-dashed border-primary/20 flex flex-col items-center gap-0.5 group transition-all hover:bg-primary/10">
                  <span class="text-[8px] font-bold text-primary/40 uppercase tracking-[0.2em]">Código Identificador Generado</span>
                  <span class="text-2xl font-bold text-primary font-mono tracking-tighter transition-transform group-hover:scale-105">{{ generatedCode }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Step 2: Operación -->
          <div v-if="currentStep === 2" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4">
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Configuración Operativa</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Defina la pesquería y asigne el observador principal para el viaje.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Pesquería</label>
                <SearchableSelect 
                  v-model="form.pesqueriaId"
                  :options="pesqueriaOptions"
                  :icon="WaveIcon"
                  :error="fieldErrors.pesqueriaId"
                  placeholder="Seleccione la pesquería..."
                />
                <p v-if="fieldErrors.pesqueriaId" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.pesqueriaId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Arte de Pesca</label>
                <SearchableSelect 
                  v-model="form.arteId"
                  :options="arteOptions"
                  :icon="SettingsIcon"
                  placeholder="Seleccione el arte..."
                />
                <p v-if="fieldErrors.arteId" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.arteId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Observador Asignado</label>
                <SearchableSelect 
                  ref="observadorSelect"
                  v-model="form.observadorId"
                  :options="observadorOptions"
                  :icon="BeakerIcon"
                  :error="fieldErrors.observadorId"
                  placeholder="Seleccione el observador..."
                />
                <p v-if="fieldErrors.observadorId" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.observadorId }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Fecha Zarpada Estimada</label>
                <DatePicker 
                  v-model="form.fechaZarpadaEstimada"
                  :icon="CalenderIcon"
                  :show-time="false"
                  :error="fieldErrors.fechaZarpadaEstimada"
                />
                <p v-if="fieldErrors.fechaZarpadaEstimada" class="text-[10px] text-error font-bold uppercase mt-1">{{ fieldErrors.fechaZarpadaEstimada }}</p>
              </div>

              <div class="space-y-1.5">
                <label class="block text-sm font-medium text-text-muted">Días Estimados</label>
                <div class="relative">
                  <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                    <HistoryIcon class="h-5 w-5 text-text-muted" />
                  </div>
                  <input 
                    v-model.number="form.diasEstimados"
                    type="number"
                    min="1"
                    placeholder="Días"
                    class="block w-full pl-10 pr-3 py-2.5 bg-surface border border-border rounded-lg font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all placeholder:text-text-muted/40 text-sm shadow-theme-xs"
                  />
                </div>
              </div>
            </div>
          </div>

          <!-- Step 3: Confirmación -->
          <div v-if="currentStep === 3" class="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-border pb-4 text-center">
              <div class="w-12 h-12 bg-success/10 rounded-full flex items-center justify-center mx-auto mb-3">
                <CheckIcon class="w-6 h-6 text-success" />
              </div>
              <h2 class="text-xl font-black uppercase tracking-tight text-text">Verificar y Registrar</h2>
              <p class="text-text-muted text-xs font-medium mt-1">Revise los datos antes de persistir la nueva marea en el sistema.</p>
            </div>

            <div v-if="error" class="p-4 bg-error/5 border border-error/20 rounded-xl text-error text-[10px] font-black uppercase tracking-widest text-center">
              {{ error }}
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="p-6 bg-surface-muted rounded-xl border border-border/50">
                <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-2">Identificación</p>
                <p class="text-sm font-black uppercase text-text">{{ getBuqueName(form.buqueId) }}</p>
                <div class="flex items-center gap-2 mt-1">
                  <span class="text-xs font-mono text-primary uppercase font-bold tracking-tighter">{{ generatedCode }}</span>
                  <span class="px-1.5 py-0.5 rounded bg-surface text-[9px] font-black text-text-muted uppercase border border-border">{{ form.tipoMarea }}</span>
                </div>
              </div>
              <div class="p-6 bg-surface-muted rounded-xl border border-border/50">
                <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-2">Operación</p>
                <p class="text-sm font-black uppercase text-text">{{ getPesqueriaName(form.pesqueriaId) }}</p>
                <p class="text-xs text-text-muted font-medium mt-0.5">Obs: {{ getObserverName(form.observadorId) }}</p>
                <p v-if="form.diasEstimados" class="text-xs text-text-muted font-medium mt-0.5">Est: {{ form.diasEstimados }} días</p>
              </div>
            </div>

            <div class="p-4 bg-warning/5 border border-warning/20 rounded-xl flex gap-4">
              <InfoIcon class="w-5 h-5 text-warning shrink-0" />
              <p class="text-[11px] text-warning/80 leading-relaxed font-medium italic">
                Al confirmar, se enviará una notificación al observador y la marea quedará en estado **DESIGNADA** disponible en el Panel Operativo.
              </p>
            </div>
          </div>
        </template>

        <!-- Actions -->
        <div class="mt-auto pt-6 flex items-center justify-between border-t border-border">
          <button 
            @click="prevStep"
            v-if="currentStep > 1"
            class="px-6 py-3 text-sm font-bold text-text-muted hover:text-text transition-all flex items-center gap-2"
          >
            Anterior
          </button>
          <div v-else></div>

          <div class="flex gap-3">
            <button 
              @click="cancel"
              class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all"
            >
              Cancelar
            </button>
            <button 
              @click="nextStep"
              :disabled="loading"
              class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 flex items-center gap-2 disabled:opacity-50"
            >
              <div v-if="loading" class="flex items-center justify-center">
                <LoadingSpinner size="xs" class="text-primary-fg" />
              </div>
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
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
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


