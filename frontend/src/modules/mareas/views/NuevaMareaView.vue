<template>
  <AdminLayout 
    title="Registrar Nueva Marea" 
    description="Complete los pasos para dar de alta una nueva designación de marea."
  >
    <div class="max-w-4xl mx-auto pb-12">
      <!-- Wizard Progress Stepper -->
      <div class="mb-12">
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
            class="flex flex-col items-center gap-3"
          >
            <div 
              class="w-10 h-10 rounded-full flex items-center justify-center border-4 transition-all duration-300"
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
              class="text-[10px] font-black uppercase tracking-widest transition-colors duration-300"
              :class="currentStep >= step.id ? 'text-brand-500' : 'text-gray-400'"
            >
              {{ step.name }}
            </span>
          </div>
        </div>
      </div>

      <!-- Step Content -->
      <div class="bg-white dark:bg-gray-950 border border-gray-200 dark:border-gray-800 rounded-3xl p-8 sm:p-12 shadow-xl shadow-gray-200/50 dark:shadow-none min-h-[400px] flex flex-col">
        
        <!-- Loading State for Catalogs -->
        <div v-if="loadingCatalogs" class="flex-1 flex flex-col items-center justify-center py-20">
          <div class="loading loading-spinner loading-lg text-brand-500"></div>
          <p class="mt-4 text-gray-500 font-bold uppercase tracking-widest text-[10px]">Cargando catálogos oficiales...</p>
        </div>

        <template v-else>
          <!-- Step 1: Identificación -->
          <div v-if="currentStep === 1" class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-6">
              <h2 class="text-2xl font-black text-gray-800 dark:text-white">Identificación de la Marea</h2>
              <p class="text-gray-500 text-sm mt-1">Seleccione el buque y defina la numeración oficial para el ciclo actual.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Buque</label>
                <div class="relative">
                  <select 
                    v-model="form.buqueId"
                    class="w-full pl-12 pr-4 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-800 rounded-2xl focus:border-brand-500 focus:ring-4 focus:ring-brand-500/10 outline-none transition-all appearance-none font-bold text-gray-800 dark:text-white group-hover:border-gray-200"
                  >
                    <option disabled value="">Seleccionar buque...</option>
                    <option v-for="b in buques" :key="b.id" :value="b.id">{{ b.nombreBuque }} ({{ b.matricula }})</option>
                  </select>
                  <div class="absolute inset-y-0 left-0 flex items-center pl-4 text-gray-400">
                    <ShipIcon class="w-5 h-5" />
                  </div>
                </div>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div class="space-y-2">
                  <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Año</label>
                  <input 
                    v-model="form.anioMarea"
                    type="number"
                    class="w-full px-4 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-800 rounded-2xl font-black text-gray-800 dark:text-white text-center text-lg outline-none focus:border-brand-500 transition-all"
                  />
                </div>
                <div class="space-y-2">
                  <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Nro. Marea</label>
                  <input 
                    v-model="form.nroMarea"
                    type="number"
                    placeholder="000"
                    class="w-full px-4 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-800 rounded-2xl font-black text-gray-800 dark:text-white text-center text-lg outline-none focus:border-brand-500 transition-all"
                  />
                </div>
              </div>
            </div>
          </div>

          <!-- Step 2: Operación -->
          <div v-if="currentStep === 2" class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-6">
              <h2 class="text-2xl font-black text-gray-800 dark:text-white">Configuración Operativa</h2>
              <p class="text-gray-500 text-sm mt-1">Defina la pesquería y asigne el observador principal para el viaje.</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Pesquería</label>
                <select 
                  v-model="form.pesqueriaId"
                  class="form-wizard-select"
                >
                  <option disabled value="">Seleccionar pesquería...</option>
                  <option v-for="p in pesquerias" :key="p.id" :value="p.id">{{ p.nombre }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Observador Principal</label>
                <select 
                  v-model="form.observadorId"
                  class="form-wizard-select"
                >
                  <option disabled value="">Seleccionar observador...</option>
                  <option v-for="o in observadores" :key="o.id" :value="o.id">{{ o.apellido }}, {{ o.nombre }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Arte Principal</label>
                <select 
                  v-model="form.arteId"
                  class="form-wizard-select"
                >
                  <option disabled value="">Seleccionar arte...</option>
                  <option v-for="a in artes" :key="a.id" :value="a.id">{{ a.nombre }}</option>
                </select>
              </div>

              <div class="space-y-2">
                <label class="text-[10px] font-black uppercase tracking-widest text-gray-400">Fecha Est. Zarpada</label>
                <input 
                  v-model="form.fechaZarpadaEstimada"
                  type="datetime-local"
                  class="w-full px-6 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-800 rounded-2xl font-bold text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all"
                />
              </div>
            </div>
          </div>

          <!-- Step 3: Confirmación -->
          <div v-if="currentStep === 3" class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div class="border-b border-gray-100 dark:border-gray-800 pb-6 text-center">
              <div class="w-16 h-16 bg-brand-50 dark:bg-brand-500/10 rounded-full flex items-center justify-center mx-auto mb-4">
                <CheckIcon class="w-8 h-8 text-brand-500" />
              </div>
              <h2 class="text-2xl font-black text-gray-800 dark:text-white">Verificar y Registrar</h2>
              <p class="text-gray-500 text-sm mt-1">Revise los datos antes de persistir la nueva marea en el sistema.</p>
            </div>

            <div v-if="error" class="p-4 bg-red-50 dark:bg-red-500/10 border border-red-100 dark:border-red-500/20 rounded-2xl text-red-600 text-sm font-bold text-center">
              {{ error }}
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div class="p-6 bg-gray-50/50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl">
                <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-2">Identificación</p>
                <p class="text-sm font-bold text-gray-800 dark:text-gray-200">{{ getBuqueName(form.buqueId) }}</p>
                <p class="text-xs font-mono text-brand-500 uppercase mt-0.5">MA-{{ form.anioMarea }}-{{ form.nroMarea }}</p>
              </div>
              <div class="p-6 bg-gray-50/50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl">
                <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-2">Operación</p>
                <p class="text-sm font-bold text-gray-800 dark:text-gray-200">{{ getPesqueriaName(form.pesqueriaId) }}</p>
                <p class="text-xs text-gray-500 mt-0.5">Obs: {{ getObserverName(form.observadorId) }}</p>
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
        <div class="mt-auto pt-10 flex items-center justify-between border-t border-gray-100 dark:border-gray-800 mt-12">
          <button 
            @click="prevStep"
            v-if="currentStep > 1"
            class="px-8 py-3.5 text-sm font-bold text-gray-500 hover:text-gray-800 dark:hover:text-gray-200 transition-all flex items-center gap-2"
          >
            Anterior
          </button>
          <div v-else></div>

          <div class="flex gap-4">
            <button 
              @click="cancel"
              class="px-8 py-3.5 text-sm font-bold text-gray-400 hover:text-red-500 transition-all"
            >
              Cancelar
            </button>
            <button 
              @click="nextStep"
              :disabled="loading"
              class="px-10 py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-2xl text-sm font-bold shadow-xl shadow-brand-500/20 transition-all active:scale-[0.98] flex items-center gap-2 active:shadow-inner disabled:opacity-50"
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
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import { useMareas } from '../composables/useMareas'
import catalogosService from '../services/catalogos.service'
import { 
  ShipIcon, 
  DocsIcon, 
  RefreshIcon, 
  CheckIcon, 
  ChevronRightIcon,
  InfoIcon,
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
  pesqueriaId: '',
  observadorId: '',
  arteId: '',
  fechaZarpadaEstimada: '',
})

// Catalogs
const loadingCatalogs = ref(true)
const buques = ref<any[]>([])
const pesquerias = ref<any[]>([])
const observadores = ref<any[]>([])
const artes = ref<any[]>([])

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
  }
})

const progressLineWidth = computed(() => {
  return `${((currentStep.value - 1) / (steps.length - 1)) * 100}%`
})

const nextStep = async () => {
  if (currentStep.value < 3) {
    // Basic validation per step
    if (currentStep.value === 1 && (!form.value.buqueId || !form.value.nroMarea)) return
    if (currentStep.value === 2 && !form.value.pesqueriaId) return
    
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
  }
}

const cancel = () => {
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

<style scoped>
@reference "../../../assets/main.css";

.form-wizard-select {
  @apply w-full px-6 py-4 bg-gray-50/50 dark:bg-gray-900 border-2 border-gray-100 dark:border-gray-800 rounded-2xl font-bold text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all appearance-none;
}
</style>
