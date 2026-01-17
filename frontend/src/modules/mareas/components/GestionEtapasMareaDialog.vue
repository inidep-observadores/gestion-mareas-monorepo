<template>
  <div v-if="show" class="fixed inset-0 z-[100000] flex items-center justify-center p-4">
    <div class="absolute inset-x-0 inset-y-0 bg-black/40 backdrop-blur-sm" @click="handleCancel"></div>
    <div
      class="bg-surface rounded-2xl p-8 max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl relative animate-in fade-in zoom-in-95 duration-300 border border-border">

      <div class="border-b border-border pb-5 mb-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
          <h3 class="text-xl font-black text-text uppercase tracking-tight">{{ config.title }}</h3>
          <div v-if="marea" class="flex items-center gap-2 px-3 py-1.5 bg-primary/5 rounded-xl border border-primary/10">
            <span class="text-[10px] font-mono font-black text-primary uppercase tracking-widest">
              {{ marea.id_marea }}
            </span>
            <span class="w-1 h-1 rounded-full bg-primary/20"></span>
            <span class="text-[10px] font-bold text-text-muted uppercase truncate max-w-[200px]">
              {{ marea.buque_nombre || marea.buque?.nombre }}
            </span>
          </div>
        </div>
        <p class="text-text-muted text-xs mt-2 font-medium">{{ config.description }}</p>
      </div>

      <!-- Observer Dates -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <div class="space-y-1.5">
          <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">Fecha Inicio Observador</label>
          <DatePicker 
            ref="firstInput"
            v-model="form.fechaInicio" 
            :error="validationErrors.fechaInicio"
          />
        </div>
        <div v-if="mode === 'FINALIZAR'" class="space-y-1.5 animate-in fade-in duration-300">
          <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">Fecha Fin Observador</label>
          <DatePicker 
            v-model="form.fechaFin" 
            :error="validationErrors.fechaFin"
          />
        </div>
      </div>

      <!-- Stages List -->
      <NavigationStagesEditor
        v-model="form.stages"
        :puertoOptions="puertoOptions"
        :pesqueriaOptions="pesqueriaOptions"
        :puertoBaseId="initialPortId || marea?.puertoBaseId"
        :defaultPesqueriaId="marea?.id_pesqueria"
        :minStages="mode === 'INICIAR' ? 1 : 0"
      />

      <!-- Footer Actions -->
      <div class="mt-8 grid grid-cols-2 gap-4">
        <button @click="handleCancel"
          class="px-6 py-3.5 bg-surface-muted hover:bg-surface border border-border text-text rounded-xl text-sm font-bold uppercase tracking-wider transition-all">
          Cancelar
        </button>
        <button @click="handleConfirm" :disabled="!isValid"
          class="px-6 py-3.5 bg-primary hover:bg-primary/90 text-primary-fg rounded-xl text-sm font-bold uppercase tracking-wider shadow-lg shadow-primary/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed">
          {{ config.buttonText }}
        </button>
      </div>

    </div>

    <!-- Confirmation Overlay -->
    <ConfirmationDialog
        :show="showConfirmation"
        :title="confirmationTitle"
        :message="confirmationMessage"
        :confirmText="confirmationConfirmText"
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
import NavigationStagesEditor from './NavigationStagesEditor.vue';
import catalogosService from '../services/catalogos.service';
import { TrashIcon, WarningIcon } from '@/icons';
import { isDateBefore, isDateAfter, isDateSameOrBefore, isDateSameOrAfter } from '@/utils/date.utils';

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
const confirmationConfirmText = ref('Confirmar');

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

// Initial stage creation logic
const addInitialStage = () => {
  if (form.value.stages.length > 0) return;
  
  form.value.stages.push({
    id: null,
    nroEtapa: 1,
    puertoZarpadaId: props.initialPortId || props.marea?.puertoBaseId || '',
    fechaZarpada: form.value.fechaInicio,
    puertoArriboId: '',
    fechaArribo: '',
    pesqueriaId: props.marea?.id_pesqueria || '',
    tipoEtapa: 'COMERCIAL',
    observaciones: ''
  });
};

watch(() => props.show, (val) => {
  if (val) {
    // 1. Initial Dates
    form.value.fechaInicio = props.marea?.fechaInicioObservador || props.marea?.fecha_zarpada_estimada || new Date().toISOString();
    form.value.fechaFin = props.marea?.fechaFinObservador || '';

    // 2. Clone and Sort Stages
    const clonedStages = (props.currentStages || []).map(s => ({ 
        ...s,
        fechaZarpada: s.fechaZarpada || '',
        fechaArribo: s.fechaArribo || '',
        tipoEtapa: s.tipoEtapa || 'COMERCIAL',
        nroEtapa: s.nroEtapa || s.nro_etapa // Fallback for safety
    }));
    
    // Sort by nroEtapa
    form.value.stages = clonedStages.sort((a, b) => (a.nroEtapa || 0) - (b.nroEtapa || 0));

    // 3. Logic for INICIAR: Ensure at least one stage
    if (props.mode === 'INICIAR' && form.value.stages.length === 0) {
      addInitialStage();
    }

    nextTick(() => {
      firstInput.value?.focus();
    });
  }
});

// Watch initialPortId to update first stage if it arrives late
watch(() => props.initialPortId, (newPortId) => {
  if (props.show && props.mode === 'INICIAR' && form.value.stages.length > 0 && newPortId) {
    if (!form.value.stages[0].puertoZarpadaId) {
      form.value.stages[0].puertoZarpadaId = newPortId;
    }
  }
});


// Validations
function hasOverlap(index: number): boolean {
  if (index === 0) return false;
  const current = form.value.stages[index];
  const prev = form.value.stages[index - 1];
  if (!current.fechaZarpada || !prev.fechaArribo) return false;
  // current.fechaZarpada < prev.fechaArribo
  return isDateBefore(current.fechaZarpada, prev.fechaArribo);
}

function stageErrors(index: number): boolean {
  const s = form.value.stages[index];
  const basic = !s.fechaZarpada || !s.puertoZarpadaId || !s.pesqueriaId;
  
  // Internal Chronology: Arrival >= Departure
  if (s.fechaZarpada && s.fechaArribo) {
     if (isDateBefore(s.fechaArribo, s.fechaZarpada)) return true;
  }

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
  const startObs = form.value.fechaInicio;
  const firstZarpada = form.value.stages[0].fechaZarpada;
  
  // 1. Start Obs > First Stage Departure
  // "No puede ser posterior a la primera zarpada"
  // CORRECCIÓN: Si es el MISMO día, es válido. Solo falla si startObs > firstZarpada
  if (isDateAfter(startObs, firstZarpada)) {
    validationErrors.value.fechaInicio = 'No puede ser posterior a la primera zarpada';
    return false;
  }

  if (props.mode === 'FINALIZAR') {
    const endObs = form.value.fechaFin;
    const lastArribo = form.value.stages[form.value.stages.length - 1].fechaArribo;

    // 2. End Obs < Last Stage Arrival
    if (isDateBefore(endObs, lastArribo)) {
        validationErrors.value.fechaFin = 'No puede ser anterior al último arribo';
        return false;
    }

    // 3. End Obs <= Start Obs
    if (isDateSameOrBefore(endObs, startObs)) {
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
  confirmationConfirmText.value = 'Sí, descartar';
  showConfirmation.value = true;
}

function handleConfirm() {
  confirmationAction.value = 'SAVE';
  confirmationTitle.value = config.value.title;
  confirmationMessage.value = props.mode === 'FINALIZAR' 
    ? '¿Está seguro que desea finalizar la marea? Esta acción es irreversible.'
    : '¿Desea guardar los cambios en las etapas y fechas del observador?';
  confirmationConfirmText.value = 'Confirmar';
  showConfirmation.value = true;
}

function executeConfirmation() {
  showConfirmation.value = false;
  if (confirmationAction.value === 'SAVE') {
    // Clean payload to match DTO
    const cleanStages = form.value.stages.map((s: any) => ({
      id: s.id, // Keep ID for updates
      nroEtapa: s.nroEtapa,
      puertoZarpadaId: s.puertoZarpadaId,
      fechaZarpada: s.fechaZarpada,
      puertoArriboId: s.puertoArriboId || null, // Handle empty string
      fechaArribo: s.fechaArribo || null, // Handle empty string
      pesqueriaId: s.pesqueriaId,
      tipoEtapa: s.tipoEtapa,
      observaciones: s.observaciones,
      // Clean observers list if present
      observadores: s.observadores?.map((o: any) => ({
        observadorId: o.observadorId,
        rol: o.rol,
        esDesignado: o.esDesignado
      }))
    }));

    emit('confirm', {
      fechaInicioObservador: form.value.fechaInicio || null,
      fechaFinObservador: form.value.fechaFin || null, // Ensure null if empty string
      etapas: cleanStages
    });
  } else if (confirmationAction.value === 'CANCEL') {
    emit('close');
  }
}
</script>
