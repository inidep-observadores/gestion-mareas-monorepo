<template>
  <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-gray-950/40 backdrop-blur-sm" @click="handleCancel"></div>
    <div
      class="bg-white dark:bg-gray-900 rounded-2xl p-8 max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl relative animate-in fade-in zoom-in-95 duration-300">

      <div class="border-b border-gray-100 dark:border-gray-800 pb-4 mb-6">
        <h3 class="text-xl font-bold text-gray-800 dark:text-white">{{ config.title }}</h3>
        <p class="text-gray-500 text-xs mt-1">{{ config.description }}</p>
      </div>

      <!-- Observer Dates -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div class="space-y-1.5">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Fecha Inicio Observador</label>
          <DatePicker 
            ref="firstInput"
            v-model="form.fechaInicio" 
            :error="validationErrors.fechaInicio"
          />
        </div>
        <div v-if="mode === 'FINALIZAR'" class="space-y-1.5 animate-in fade-in duration-300">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Fecha Fin Observador</label>
          <DatePicker 
            v-model="form.fechaFin" 
            :error="validationErrors.fechaFin"
          />
        </div>
      </div>

      <!-- Stages List -->
      <div class="space-y-4">
        <div class="flex items-center justify-between">
          <h4 class="text-lg font-bold text-gray-800 dark:text-white">Etapas del Viaje</h4>
          <button @click="addStage"
            :disabled="!canAddStage"
            class="px-3 py-1.5 bg-brand-100 text-brand-700 rounded-lg text-xs font-bold uppercase tracking-wider hover:bg-brand-200 transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
            + Agregar Etapa
          </button>
        </div>

        <div v-if="form.stages.length === 0" class="text-center py-8 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-dashed border-gray-300 dark:border-gray-700">
           <p class="text-gray-500 text-sm">No hay etapas registradas.</p>
        </div>

        <div v-else class="space-y-4">
          <div v-for="(stage, index) in form.stages" :key="index"
            class="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-4 border border-gray-200 dark:border-gray-700 relative group transition-all"
            :class="{'border-red-500 bg-red-50 dark:bg-red-900/10': hasOverlap(index) || stageErrors(index)}">
            
            <div class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity" v-if="form.stages.length > 1">
                <button @click="removeStage(index)" class="p-1.5 text-red-500 hover:bg-red-100 rounded-lg transition-colors">
                    <TrashIcon class="w-5 h-5" />
                </button>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Departure -->
                <div class="space-y-3">
                    <h5 class="text-xs font-bold text-gray-500 uppercase tracking-wider border-b border-gray-200 pb-1">Zarpada (Etapa {{ index + 1 }})</h5>
                    <div class="grid grid-cols-2 gap-2">
                         <div class="space-y-1">
                            <label class="text-[10px] uppercase text-gray-400 font-bold">Fecha</label>
                            <DatePicker v-model="stage.fechaZarpada" />
                         </div>
                         <div class="space-y-1">
                            <label class="text-[10px] uppercase text-gray-400 font-bold">Puerto</label>
                            <SearchableSelect 
                                v-model="stage.puertoZarpadaId"
                                :options="puertoOptions"
                                placeholder="Seleccione..."
                                class="text-sm"
                            />
                         </div>
                    </div>
                </div>

                <!-- Arrival -->
                <div class="space-y-3">
                    <h5 class="text-xs font-bold text-gray-500 uppercase tracking-wider border-b border-gray-200 pb-1">Arribo</h5>
                    <div class="grid grid-cols-2 gap-2">
                         <div class="space-y-1">
                            <label class="text-[10px] uppercase text-gray-400 font-bold">Fecha</label>
                            <DatePicker v-model="stage.fechaArribo" />
                         </div>
                         <div class="space-y-1">
                            <label class="text-[10px] uppercase text-gray-400 font-bold">Puerto</label>
                            <SearchableSelect 
                                v-model="stage.puertoArriboId"
                                :options="puertoOptions"
                                placeholder="Seleccione..."
                                class="text-sm"
                            />
                         </div>
                    </div>
                </div>

                <!-- Fishery -->
                <div class="md:col-span-2 space-y-1">
                     <label class="text-[10px] uppercase text-gray-400 font-bold">Pesquería Objetivo</label>
                     <SearchableSelect 
                        v-model="stage.pesqueriaId"
                        :options="pesqueriaOptions"
                        placeholder="Seleccione pesquería..."
                     />
                </div>
            </div>

             <div v-if="hasOverlap(index)" class="mt-3 text-xs text-red-600 font-medium flex items-center gap-1">
                <WarningIcon class="w-4 h-4" />
                La fecha de zarpada no puede ser anterior al arribo de la etapa previa.
            </div>
          </div>
        </div>
      </div>

      <!-- Footer Actions -->
      <div class="mt-8 grid grid-cols-2 gap-4">
        <button @click="handleCancel"
          class="px-6 py-3.5 bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-xl text-sm font-bold uppercase tracking-wider transition-all">
          Cancelar
        </button>
        <button @click="handleConfirm" :disabled="!isValid"
          class="px-6 py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-xl text-sm font-bold uppercase tracking-wider shadow-lg shadow-brand-500/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed">
          {{ config.buttonText }}
        </button>
      </div>

    </div>

    <!-- Confirmation Overlay -->
    <ConfirmationDialog
        :show="showConfirmation"
        :title="confirmationTitle"
        :message="confirmationMessage"
        @close="showConfirmation = false"
        @confirm="executeConfirmation"
        :isSidebarAware="false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import catalogosService from '../services/catalogos.service';
import { TrashIcon, WarningIcon } from '@/icons';

const props = defineProps<{
  show: boolean;
  mode: 'INICIAR' | 'EDITAR' | 'FINALIZAR';
  marea: any;
  currentStages: any[];
  initialPortId?: string;
}>();

const emit = defineEmits(['close', 'confirm']);

// Form State
const form = ref({
  fechaInicio: '',
  fechaFin: '',
  stages: [] as any[]
});

const validationErrors = ref<Record<string, string>>({});
const puertos = ref<any[]>([]);
const pesquerias = ref<any[]>([]);
const firstInput = ref<any>(null);

// Confirmation Dialog State
const showConfirmation = ref(false);
const confirmationAction = ref<'SAVE' | 'CANCEL' | null>(null);
const confirmationTitle = ref('');
const confirmationMessage = ref('');

// Config based on mode
const config = computed(() => {
  switch (props.mode) {
    case 'INICIAR':
      return {
        title: 'Registrar Inicio de Marea',
        description: 'Defina la fecha de inicio del observador y la primera etapa.',
        buttonText: 'Confirmar Inicio'
      };
    case 'EDITAR':
      return {
        title: 'Gestionar Etapas del Viaje',
        description: 'Modifique las fechas o puertos de las etapas en curso.',
        buttonText: 'Guardar Cambios'
      };
    case 'FINALIZAR':
      return {
        title: 'Registrar Finalización de Marea',
        description: 'Complete las etapas y defina la fecha de fin del observador.',
        buttonText: 'Confirmar Finalización'
      };
    default:
      return { title: '', description: '', buttonText: 'Guardar' };
  }
});

// Catalogs
onMounted(async () => {
  try {
    const [p, pesq] = await Promise.all([
      catalogosService.getPuertos(),
      catalogosService.getPesquerias()
    ]);
    puertos.value = p;
    pesquerias.value = pesq;
  } catch (e) {
    console.error(e);
  }
});

const puertoOptions = computed(() => puertos.value.map(p => ({ value: p.id, label: p.nombre })));
const pesqueriaOptions = computed(() => pesquerias.value.map(p => ({ value: p.id, label: p.nombre })));

// Watch show to init form
watch(() => props.show, (val) => {
  if (val) {
    // 1. Initial Dates
    form.value.fechaInicio = props.marea?.fechaInicioObservador || props.marea?.fecha_zarpada_estimada || new Date().toISOString();
    form.value.fechaFin = props.marea?.fechaFinObservador || '';

    // 2. Clone Stages
    form.value.stages = (props.currentStages || []).map(s => ({ ...s }));

    // 3. Logic for INICIAR: Ensure at least one stage
    if (props.mode === 'INICIAR' && form.value.stages.length === 0) {
      addStage();
      // Set initial stage departure to match observer start
      if (form.value.stages[0]) {
        form.value.stages[0].fechaZarpada = form.value.fechaInicio;
        if (props.initialPortId) form.value.stages[0].puertoZarpadaId = props.initialPortId;
      }
    }

    nextTick(() => {
      firstInput.value?.focus();
    });
  }
});

const canAddStage = computed(() => {
  if (form.value.stages.length === 0) return true;
  const last = form.value.stages[form.value.stages.length - 1];
  return !!last.fechaArribo; // Only allow adding if last stage finished
});

function addStage() {
  if (!canAddStage.value) return;

  let defaultPesqueria = props.marea?.id_pesqueria || '';
  let defaultPuertoZarpada = '';

  if (form.value.stages.length > 0) {
    const last = form.value.stages[form.value.stages.length - 1];
    defaultPesqueria = last.pesqueriaId || defaultPesqueria;
    defaultPuertoZarpada = last.puertoArriboId || '';
  }

  form.value.stages.push({
    id: null,
    puertoZarpadaId: defaultPuertoZarpada,
    fechaZarpada: '',
    puertoArriboId: '',
    fechaArribo: '',
    pesqueriaId: defaultPesqueria
  });
}

function removeStage(index: number) {
  form.value.stages.splice(index, 1);
}

// Validations
function hasOverlap(index: number): boolean {
  if (index === 0) return false;
  const current = form.value.stages[index];
  const prev = form.value.stages[index - 1];
  if (!current.fechaZarpada || !prev.fechaArribo) return false;
  return new Date(current.fechaZarpada) < new Date(prev.fechaArribo);
}

function stageErrors(index: number): boolean {
  const s = form.value.stages[index];
  const basic = !s.fechaZarpada || !s.puertoZarpadaId || !s.pesqueriaId;
  // If not last stage, or if FINALIZAR, arrival is required
  const arrivalRequired = props.mode === 'FINALIZAR' || index < form.value.stages.length - 1;
  if (arrivalRequired && (!s.fechaArribo || !s.puertoArriboId)) return true;
  return basic;
}

const isValid = computed(() => {
  validationErrors.value = {};
  if (!form.value.fechaInicio) return false;

  // Mode FINALIZAR: require fechaFin
  if (props.mode === 'FINALIZAR' && !form.value.fechaFin) return false;

  // Stages validation
  if (form.value.stages.length === 0) return false;
  for (let i = 0; i < form.value.stages.length; i++) {
    if (stageErrors(i) || hasOverlap(i)) return false;
  }

  // Cross-date validations
  const startObs = new Date(form.value.fechaInicio);
  const firstZarpada = new Date(form.value.stages[0].fechaZarpada);
  
  // 1. Start Obs <= First Stage Departure
  if (startObs > firstZarpada) {
    validationErrors.value.fechaInicio = 'No puede ser posterior a la primera zarpada';
    return false;
  }

  if (props.mode === 'FINALIZAR') {
    const endObs = new Date(form.value.fechaFin);
    const lastArribo = new Date(form.value.stages[form.value.stages.length - 1].fechaArribo);

    // 2. End Obs >= Last Stage Arrival
    if (endObs < lastArribo) {
        validationErrors.value.fechaFin = 'No puede ser anterior al último arribo';
        return false;
    }

    // 3. End Obs > Start Obs
    if (endObs <= startObs) {
        validationErrors.value.fechaFin = 'Debe ser posterior al inicio';
        return false;
    }
  }

  return true;
});

// Handlers
function handleCancel() {
  confirmationAction.value = 'CANCEL';
  confirmationTitle.value = '¿Descartar cambios?';
  confirmationMessage.value = 'Se perderá el progreso realizado en este formulario.';
  showConfirmation.value = true;
}

function handleConfirm() {
  confirmationAction.value = 'SAVE';
  confirmationTitle.value = config.value.title;
  confirmationMessage.value = props.mode === 'FINALIZAR' 
    ? '¿Está seguro que desea finalizar la marea? Esta acción es irreversible.'
    : '¿Desea guardar los cambios en las etapas y fechas del observador?';
  showConfirmation.value = true;
}

function executeConfirmation() {
  showConfirmation.value = false;
  if (confirmationAction.value === 'SAVE') {
    emit('confirm', {
      fechaInicioObservador: form.value.fechaInicio,
      fechaFinObservador: form.value.fechaFin,
      etapas: form.value.stages
    });
  } else if (confirmationAction.value === 'CANCEL') {
    emit('close');
  }
}
</script>
