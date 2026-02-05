<template>
  <Teleport to="body">
    <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div class="absolute inset-x-0 inset-y-0 bg-black/40 backdrop-blur-sm" @click="handleCancel"></div>
      <div
        class="bg-surface rounded-2xl p-8 max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl relative animate-in fade-in zoom-in-95 duration-300 border border-border custom-scrollbar">

        <div class="border-b border-border pb-5 mb-6">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
            <h3 class="text-xl font-black text-text uppercase tracking-tight">{{ config.title }}</h3>
            <div v-if="marea"
              class="flex items-center gap-2 px-3 py-1.5 bg-primary/5 rounded-xl border border-primary/10">
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

        <!-- Observer Dates (Main Controls) -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
          <div class="space-y-1.5">
            <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">
              Fecha Inicio Observador
            </label>
            <DatePicker ref="firstInput" v-model="form.fechaInicio" :error="validationErrors.fechaInicio" />
          </div>
          <div v-if="mode === 'FINALIZAR'" class="space-y-1.5 animate-in fade-in duration-300">
            <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">
              Fecha Fin Observador
            </label>
            <DatePicker v-model="form.fechaFin" :error="validationErrors.fechaFin" />
          </div>
        </div>

        <div class="space-y-6">
          <!-- Section 1: Zona Austral -->
          <CollapsibleSection title="Zona Austral"
            :description="`Detección técnica: ${zonaAustralData?.totalDiasMarea || 0} días`"
            :initialOpen="shouldOpenZonaAustral">
            <template #icon>
              <HistoryIcon class="w-5 h-5 text-primary" />
            </template>
            <template #title-extra>
              <Badge v-if="form.diasZonaAustral > 0" color="primary" variant="solid" size="sm" class="ml-2">
                {{ form.diasZonaAustral }} DÍAS
              </Badge>
            </template>
            <template #actions>
              <button @click.stop="loadZonaAustralData" :disabled="loadingZonaAustral"
                class="text-[10px] font-black uppercase text-primary hover:underline flex items-center gap-1.5 px-2 py-1">
                <RefreshIcon class="w-3.5 h-3.5" :class="{ 'animate-spin': loadingZonaAustral }" />
                {{ loadingZonaAustral ? 'Calculando...' : 'Recalcular Ahora' }}
              </button>
            </template>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="space-y-2">
                <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">
                  Días Zona Austral
                </label>
                <div class="relative">
                  <input v-model="form.diasZonaAustral" type="number" @input="checkManualMode"
                    class="w-full px-4 py-3 bg-surface-muted/50 border border-border rounded-xl focus:ring-2 focus:ring-primary/20 text-text transition-all font-bold outline-none"
                    placeholder="0" />
                </div>
              </div>
              <div class="space-y-2">
                <label class="block text-[10px] font-black uppercase text-text-muted tracking-widest">
                  Cálculo Zona Austral
                </label>
                <div class="flex items-center h-[50px]">
                  <Badge
                    :color="form.tipoCalculoZonaAustral === TipoCalculoZonaAustral.AUTOMATICO ? 'success' : 'warning'"
                    variant="light"
                    class="font-black uppercase tracking-widest py-1.5 px-4 rounded-xl flex items-center gap-2">
                    <span class="w-1.5 h-1.5 rounded-full"
                      :class="form.tipoCalculoZonaAustral === TipoCalculoZonaAustral.AUTOMATICO ? 'bg-success' : 'bg-warning'"></span>
                    {{ form.tipoCalculoZonaAustral }}
                  </Badge>
                </div>
              </div>

              <!-- Detalle de cálculos (igual que en las vistas) -->
              <div class="md:col-span-2">
                <ZonaAustralDetalle v-if="form.tipoCalculoZonaAustral === TipoCalculoZonaAustral.AUTOMATICO"
                  :data="zonaAustralData" />
                <div v-else class="p-6 bg-surface-muted/30 rounded-2xl border border-dashed border-border text-center">
                  <p class="text-[10px] text-text-muted font-bold italic uppercase tracking-widest">
                    Modo manual activado. Presione recalcular para volver al desglose técnico.
                  </p>
                </div>
              </div>
            </div>
          </CollapsibleSection>

          <!-- Section 2: Etapas del Viaje -->
          <CollapsibleSection :title="`${form.stages.length} Etapas registradas`" :description="etapasRangeDescription"
            :initialOpen="false">
            <template #icon>
              <ShipIcon class="w-5 h-5 text-primary" />
            </template>
            <NavigationStagesEditor v-model="form.stages" :puertoOptions="puertoOptions"
              :pesqueriaOptions="pesqueriaOptions" :puertoBaseId="initialPortId || marea?.puertoBaseId"
              :defaultPesqueriaId="marea?.id_pesqueria || marea?.pesqueriaId" :minStages="mode === 'INICIAR' ? 1 : 0" />
          </CollapsibleSection>
        </div>

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
      <ConfirmationDialog :show="showConfirmation" :title="confirmationTitle" :message="confirmationMessage"
        :confirmText="confirmationConfirmText" @close="showConfirmation = false" @confirm="executeConfirmation"
        :isSidebarAware="false" />
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch, nextTick } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import NavigationStagesEditor from './NavigationStagesEditor.vue';
import CollapsibleSection from '@/components/common/CollapsibleSection.vue';
import ZonaAustralDetalle from './ZonaAustralDetalle.vue';
import Badge from '@/components/ui/Badge.vue';
import catalogosService from '../services/catalogos.service';
import mareasService from '../services/mareas.service';
import { RefreshIcon, HistoryIcon, ShipIcon } from '@/icons';
import { isDateBefore, isDateAfter, isDateSameOrBefore } from '@/utils/date.utils';
import { TipoEtapa } from '../types/enums';
import { TipoCalculoZonaAustral } from '../types/marea.types';
import type { Marea, ZonaAustralResponse } from '../types/marea.types';

const emit = defineEmits(['close', 'confirm']);

const props = defineProps<{
  show: boolean;
  mode: 'INICIAR' | 'EDITAR' | 'FINALIZAR';
  marea: Partial<Marea>;
  currentStages: any[];
  initialPortId?: string;
}>();

// Form State
const form = ref({
  fechaInicio: '',
  fechaFin: '',
  stages: [] as any[],
  diasZonaAustral: 0,
  tipoCalculoZonaAustral: TipoCalculoZonaAustral.AUTOMATICO
});

const validationErrors = ref<Record<string, string>>({});
const puertos = ref<any[]>([]);
const pesquerias = ref<any[]>([]);
const firstInput = ref<any>(null);

// Zona Austral State
const loadingZonaAustral = ref(false);
const zonaAustralData = ref<ZonaAustralResponse | null>(null);

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

// Computed info for CollapsibleSection title
const etapasRangeDescription = computed(() => {
  if (form.value.stages.length === 0) return 'Sin etapas registradas';
  const first = form.value.stages[0].fechaZarpada;
  const last = form.value.stages[form.value.stages.length - 1].fechaArribo;

  const formatDate = (d: string) => {
    if (!d) return '---';
    return new Date(d).toLocaleDateString();
  };

  return `Rango: ${formatDate(first)} - ${formatDate(last)}`;
});

const shouldOpenZonaAustral = computed(() => {
  return form.value.diasZonaAustral > 0;
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

// Zona Austral Logic
async function loadZonaAustralData() {
  if (!props.marea?.id) return;

  try {
    loadingZonaAustral.value = true;
    const result = await mareasService.getZonaAustralDays(props.marea.id);
    zonaAustralData.value = result;

    // Al presionar recalcular, siempre volvemos al valor técnico y modo automático
    form.value.diasZonaAustral = result.totalDiasMarea;
    form.value.tipoCalculoZonaAustral = TipoCalculoZonaAustral.AUTOMATICO;
  } catch (error) {
    console.error('Error loading zona austral data:', error);
  } finally {
    loadingZonaAustral.value = false;
  }
}

function checkManualMode() {
  const currentVal = form.value.diasZonaAustral;
  if (zonaAustralData.value) {
    const val = Number(currentVal);
    const calculated = Number(zonaAustralData.value.totalDiasMarea);

    if (val === calculated) {
      form.value.tipoCalculoZonaAustral = TipoCalculoZonaAustral.AUTOMATICO;
    } else {
      form.value.tipoCalculoZonaAustral = TipoCalculoZonaAustral.MANUAL;
    }
  } else {
    form.value.tipoCalculoZonaAustral = TipoCalculoZonaAustral.MANUAL;
  }
}

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
    pesqueriaId: props.marea?.id_pesqueria || props.marea?.pesqueriaId || '',
    tipoEtapa: TipoEtapa.MC,
    observaciones: ''
  });
};

watch(() => props.show, (val) => {
  if (val) {
    // 1. Initial Dates
    form.value.fechaInicio = props.marea?.fechaInicioObservador || props.marea?.fecha_inicio_observador || '';
    form.value.fechaFin = props.marea?.fechaFinObservador || props.marea?.fecha_fin_observador || '';

    // 2. Zona Austral Initial State
    form.value.diasZonaAustral = props.marea?.diasZonaAustral || 0;
    form.value.tipoCalculoZonaAustral = props.marea?.tipoCalculoZonaAustral || TipoCalculoZonaAustral.AUTOMATICO;

    // 3. Clone and Sort Stages
    const clonedStages = (props.currentStages || []).map(s => ({
      ...s,
      fechaZarpada: s.fechaZarpada || '',
      fechaArribo: s.fechaArribo || '',
      tipoEtapa: s.tipoEtapa || TipoEtapa.MC,
      nroEtapa: s.nroEtapa || s.nro_etapa
    }));
    form.value.stages = clonedStages.sort((a, b) => (a.nroEtapa || 0) - (b.nroEtapa || 0));

    if (props.mode === 'INICIAR' && form.value.stages.length === 0) {
      addInitialStage();
    }

    if (props.mode === 'FINALIZAR' && !form.value.fechaFin && form.value.stages.length > 0) {
      const lastStage = form.value.stages[form.value.stages.length - 1];
      if (lastStage.fechaArribo && lastStage.puertoArriboId) {
        const puertoArribo = puertos.value.find(p => p.id === lastStage.puertoArriboId);
        if (puertoArribo && puertoArribo.codigo === 'ARMDQ') {
          form.value.fechaFin = lastStage.fechaArribo;
        }
      }
    }

    // Load technical calculation details automatically
    loadZonaAustralData();

    nextTick(() => {
      firstInput.value?.focus();
    });
  }
}, { immediate: true });

// Validations
function hasOverlap(index: number): boolean {
  if (index === 0) return false;
  const current = form.value.stages[index];
  const prev = form.value.stages[index - 1];
  if (!current.fechaZarpada || !prev.fechaArribo) return false;
  return isDateBefore(current.fechaZarpada, prev.fechaArribo);
}

function stageErrors(index: number): boolean {
  const s = form.value.stages[index];
  const basic = !s.fechaZarpada || !s.puertoZarpadaId || !s.pesqueriaId;
  if (s.fechaZarpada && s.fechaArribo) {
    if (isDateBefore(s.fechaArribo, s.fechaZarpada)) return true;
  }
  const arrivalRequired = props.mode === 'FINALIZAR' || index < form.value.stages.length - 1;
  if (arrivalRequired && (!s.fechaArribo || !s.puertoArriboId)) return true;
  return basic;
}

const isValid = computed(() => {
  validationErrors.value = {};
  if (!form.value.fechaInicio) return false;
  if (form.value.stages.length === 0) return false;
  for (let i = 0; i < form.value.stages.length; i++) {
    if (stageErrors(i) || hasOverlap(i)) return false;
  }
  const startObs = form.value.fechaInicio;
  const firstZarpada = form.value.stages[0].fechaZarpada;
  if (isDateAfter(startObs, firstZarpada)) {
    validationErrors.value.fechaInicio = 'No puede ser posterior a la primera zarpada';
    return false;
  }
  if (props.mode === 'FINALIZAR' && form.value.fechaFin) {
    const endObs = form.value.fechaFin;
    const lastArribo = form.value.stages[form.value.stages.length - 1].fechaArribo;
    if (isDateBefore(endObs, lastArribo)) {
      validationErrors.value.fechaFin = 'No puede ser anterior al último arribo';
      return false;
    }
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
    const cleanStages = form.value.stages.map((s: any) => ({
      id: s.id,
      nroEtapa: s.nroEtapa,
      puertoZarpadaId: s.puertoZarpadaId,
      fechaZarpada: s.fechaZarpada,
      puertoArriboId: s.puertoArriboId || null,
      fechaArribo: s.fechaArribo || null,
      pesqueriaId: s.pesqueriaId,
      tipoEtapa: s.tipoEtapa,
      observaciones: s.observaciones,
      observadores: s.observadores?.map((o: any) => ({
        observadorId: o.observadorId,
        rol: o.rol,
        esDesignado: o.esDesignado
      }))
    }));

    emit('confirm', {
      fechaInicioObservador: form.value.fechaInicio || null,
      fechaFinObservador: form.value.fechaFin || null,
      diasZonaAustral: form.value.diasZonaAustral,
      tipoCalculoZonaAustral: form.value.tipoCalculoZonaAustral,
      etapas: cleanStages
    });
  } else if (confirmationAction.value === 'CANCEL') {
    emit('close');
  }
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
}
</style>
