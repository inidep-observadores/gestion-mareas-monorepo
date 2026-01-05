<template>
  <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-gray-950/40 backdrop-blur-sm" @click="handleCancel"></div>
    <div
      class="bg-white dark:bg-gray-900 rounded-2xl p-8 max-w-4xl w-full max-h-[90vh] overflow-y-auto shadow-2xl relative animate-in fade-in zoom-in-95 duration-300">

      <div class="border-b border-gray-100 dark:border-gray-800 pb-4 mb-6">
        <h3 class="text-xl font-bold text-gray-800 dark:text-white">Registrar Finalización de Marea</h3>
        <p class="text-gray-500 text-xs mt-1">Indique la fecha de fin del observador y complete las etapas del viaje.
        </p>
      </div>

      <!-- Observer End Date -->
      <div class="space-y-6 mb-8">
        <div class="space-y-1.5 max-w-sm">
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Fecha Fin Observador</label>
          <DatePicker v-model="fechaFinObservador" />
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

        <div v-if="stages.length === 0" class="text-center py-8 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-dashed border-gray-300 dark:border-gray-700">
           <p class="text-gray-500 text-sm">No hay etapas registradas.</p>
        </div>

        <div v-else class="space-y-4">
          <div v-for="(stage, index) in stages" :key="index"
            class="bg-gray-50 dark:bg-gray-800/50 rounded-xl p-4 border border-gray-200 dark:border-gray-700 relative group transition-all"
            :class="{'border-red-500 bg-red-50 dark:bg-red-900/10': hasOverlap(index)}">
            
            <div class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity" v-if="stages.length > 1">
                <button @click="removeStage(index)" class="p-1.5 text-red-500 hover:bg-red-100 rounded-lg transition-colors">
                    <TrashIcon class="w-5 h-5" />
                </button>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Departure -->
                <div class="space-y-3">
                    <h5 class="text-xs font-bold text-gray-500 uppercase tracking-wider border-b border-gray-200 pb-1">Zarpada</h5>
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

      <div class="mt-8 grid grid-cols-2 gap-4">
        <button @click="handleCancel"
          class="px-6 py-3.5 bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-xl text-sm font-bold uppercase tracking-wider transition-all">
          Cancelar
        </button>
        <button @click="handleConfirm" :disabled="!isValid"
          class="px-6 py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-xl text-sm font-bold uppercase tracking-wider shadow-lg shadow-brand-500/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed">
          Confirmar Finalización
        </button>
      </div>

    </div>

    <!-- Confirm Dialog Overly -->
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
import { ref, computed, onMounted, watch } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import catalogosService from '../services/catalogos.service';
import { TrashIcon, WarningIcon } from '@/icons';

const props = defineProps({
  show: Boolean,
  initialObserverEndDate: String,
  currentStages: { type: Array, default: () => [] }
});

const emit = defineEmits(['close', 'confirm']);

// Data
const fechaFinObservador = ref('');
const stages = ref<any[]>([]);
const puertos = ref<any[]>([]);
const pesquerias = ref<any[]>([]);

// Confirmation State
const showConfirmation = ref(false);
const confirmationAction = ref<'SAVE' | 'CANCEL' | null>(null);
const confirmationTitle = ref('');
const confirmationMessage = ref('');

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

// Watchers to init form
watch(() => props.show, (val) => {
    if (val) {
        fechaFinObservador.value = props.initialObserverEndDate || new Date().toISOString();
        // Clone stages to avoid direct mutation
        stages.value = props.currentStages.map((s: any) => ({ ...s }));
        
        // Ensure at least one stage if empty (rare for execution)
        if (stages.value.length === 0) {
            addStage();
        }
    }
});

const canAddStage = computed(() => {
    if (stages.value.length === 0) return true;
    const lastStage = stages.value[stages.value.length - 1];
    // Must have arrival date to allow adding next stage
    return !!lastStage.fechaArribo;
});

function addStage() {
    if (!canAddStage.value) return;

    let defaultPesqueria = '';
    let defaultPuertoZarpada = '';
    
    // Copy pesqueria and arrival port from previous stage if exists
    if (stages.value.length > 0) {
        const lastStage = stages.value[stages.value.length - 1];
        if (lastStage) {
            if (lastStage.pesqueriaId) defaultPesqueria = lastStage.pesqueriaId;
            if (lastStage.puertoArriboId) defaultPuertoZarpada = lastStage.puertoArriboId;
        }
    }

    stages.value.push({
        id: null, // New stage
        puertoZarpadaId: defaultPuertoZarpada,
        fechaZarpada: '',
        puertoArriboId: '',
        fechaArribo: '',
        pesqueriaId: defaultPesqueria
    });
}

function removeStage(index: number) {
    stages.value.splice(index, 1);
}

// Validation Logic
function hasOverlap(index: number): boolean {
    if (index === 0) return false;
    const current = stages.value[index];
    const prev = stages.value[index - 1];

    if (!current.fechaZarpada || !prev.fechaArribo) return false;

    const zarpada = new Date(current.fechaZarpada);
    const arriboPrev = new Date(prev.fechaArribo);

    // Allow same day, but strictly before is invalid? "solapamiento permitido es que la zarpada sea el mismo día que el arribo"
    // So zarpada < arriboPrev is invalid. zarpada >= arriboPrev is valid.
    
    // Reset hours to compare dates only if needed, but usually specific timestamps matter. 
    // Assuming DatePicker returns date string YYYY-MM-DD or full ISO. If full ISO, time matters.
    // If just dates (YYYY-MM-DDT00:00:00), then < is strictly before previous day. 
    // Let's assume strict time comparison.
    return zarpada.getTime() < arriboPrev.getTime(); 
}

const isValid = computed(() => {
    if (!fechaFinObservador.value) return false;
    if (stages.value.length === 0) return false;

    // Check overlaps
    for (let i = 0; i < stages.value.length; i++) {
        if (hasOverlap(i)) return false;
    }

    // Check required fields per stage
    return stages.value.every(s => 
        !!s.fechaZarpada && 
        !!s.puertoZarpadaId && 
        !!s.fechaArribo && 
        !!s.puertoArriboId &&
        !!s.pesqueriaId
    );
});

// Handlers
function handleCancel() {
    // Dirty check could be here, strict confirmation requested
    confirmationAction.value = 'CANCEL';
    confirmationTitle.value = '¿Descartar cambios?';
    confirmationMessage.value = 'Se perderá el progreso de la finalización de la marea.';
    showConfirmation.value = true;
}

function handleConfirm() {
    confirmationAction.value = 'SAVE';
    confirmationTitle.value = 'Confirmar Finalización';
    confirmationMessage.value = '¿Está seguro que desea finalizar la marea con estos datos? Esta acción registrará el fin del viaje para el observador.';
    showConfirmation.value = true;
}

function executeConfirmation() {
    showConfirmation.value = false;
    if (confirmationAction.value === 'SAVE') {
        emit('confirm', {
            fechaFinObservador: fechaFinObservador.value,
            etapas: stages.value
        });
    } else if (confirmationAction.value === 'CANCEL') {
        emit('close');
    }
}
</script>
