<template>
  <div class="space-y-4">
    <div class="flex items-center justify-between">
      <h4 class="text-xs font-black uppercase tracking-widest text-gray-400 flex items-center gap-2">
        <MapPinIcon class="w-3 h-3" /> Etapas del Viaje
      </h4>
      <button 
        v-if="!readOnly"
        @click="addStage"
        :disabled="!canAddStage"
        class="px-3 py-1.5 bg-brand-100 text-brand-700 dark:bg-brand-500/10 dark:text-brand-400 rounded-lg text-[10px] font-black uppercase tracking-widest hover:bg-brand-200 dark:hover:bg-brand-500/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-1.5"
      >
        <span>+ Agregar Etapa</span>
      </button>
    </div>

    <div v-if="modelValue.length === 0" class="text-center py-12 bg-gray-50 dark:bg-gray-800/50 rounded-2xl border-2 border-dashed border-gray-200 dark:border-gray-800">
      <MapPinIcon class="w-12 h-12 text-gray-300 mx-auto mb-4" />
      <p class="text-gray-500 font-medium">No hay etapas registradas.</p>
    </div>

    <div v-else class="space-y-4">
      <div v-for="(stage, index) in modelValue" :key="index"
           :id="`stage-card-${index}`"
           class="bg-white dark:bg-gray-950 border border-gray-100 dark:border-gray-800 rounded-2xl p-4 relative group transition-all shadow-sm hover:shadow-md"
           :class="{
             'border-red-200 bg-red-50/10': hasOverlap(index),
             'border-amber-200 bg-amber-50/10': isInternalInconsistent(index)
           }">

        <!-- Header: Simple & Clean -->
        <div class="flex items-center justify-between mb-4">
          <div class="flex items-center gap-2">
             <div class="w-6 h-6 rounded-lg bg-brand-500/10 flex items-center justify-center text-brand-600">
                <span class="text-[10px] font-black">#{{ index + 1 }}</span>
             </div>
             <h4 class="text-xs font-bold text-gray-800 dark:text-white">Etapa de Navegación</h4>
          </div>

          <button
            v-if="!readOnly && index === modelValue.length - 1 && modelValue.length > (minStages || 0)"
            @click="removeStage(index)"
            class="p-1.5 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-500/10 rounded-lg transition-all opacity-0 group-hover:opacity-100"
            title="Eliminar etapa"
          >
            <TrashIcon class="w-3.5 h-3.5" />
          </button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
          <!-- Departure Details -->
          <div class="space-y-3">
            <div class="flex items-center gap-2">
              <div class="w-1.5 h-1.5 rounded-full bg-brand-500"></div>
              <h5 class="text-[9px] font-black uppercase tracking-widest text-gray-400">Zarpada</h5>
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-gray-400 tracking-tighter">Fecha</label>
                <DatePicker 
                  ref="zarpadaDates"
                  v-model="stage.fechaZarpada" 
                  :show-time="false" 
                  :disabled="readOnly" 
                />
              </div>
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-gray-400 tracking-tighter">Puerto</label>
                <SearchableSelect
                  v-model="stage.puertoZarpadaId"
                  :options="puertoOptions"
                  placeholder="Origen..."
                  :disabled="readOnly"
                />
              </div>
            </div>
          </div>

          <!-- Arrival Details -->
          <div class="space-y-3">
            <div class="flex items-center gap-2">
              <div class="w-1.5 h-1.5 rounded-full bg-amber-500"></div>
              <h5 class="text-[9px] font-black uppercase tracking-widest text-gray-400">Arribo</h5>
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-gray-400 tracking-tighter">Fecha</label>
                <DatePicker v-model="stage.fechaArribo" :show-time="false" :disabled="readOnly" />
              </div>
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-gray-400 tracking-tighter">Puerto</label>
                <SearchableSelect
                  v-model="stage.puertoArriboId"
                  :options="puertoOptions"
                  placeholder="Destino..."
                  :disabled="readOnly"
                />
              </div>
            </div>
          </div>

          <!-- Meta Info: Compact Row -->
          <div class="md:col-span-2 grid grid-cols-1 sm:grid-cols-12 gap-4 pt-3 border-t border-gray-50 dark:border-gray-800/50">
            <div class="sm:col-span-4 space-y-1">
              <label class="text-[8px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1.5">
                <FlagIcon class="w-2.5 h-2.5" /> Pesquería
              </label>
              <SearchableSelect
                v-model="stage.pesqueriaId"
                :options="pesqueriaOptions"
                placeholder="Seleccione..."
                :disabled="readOnly"
              />
            </div>
            <div class="sm:col-span-3 space-y-1">
              <label class="text-[8px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1.5">
                <SettingsIcon class="w-2.5 h-2.5" /> Propósito
              </label>
              <select v-model="stage.tipoEtapa" :disabled="readOnly" class="form-input-premium py-2 font-bold text-xs h-[38px] w-full">
                <option value="COMERCIAL">COMERCIAL</option>
                <option value="INSTITUCIONAL">INSTITUCIONAL</option>
              </select>
            </div>
            <div class="sm:col-span-5 space-y-1">
              <label class="text-[8px] font-black uppercase text-gray-400 tracking-widest flex items-center gap-1.5">
                <EditIcon class="w-2.5 h-2.5" /> Notas
              </label>
              <input
                v-model="stage.observaciones"
                type="text"
                :disabled="readOnly"
                class="form-input-premium py-2 text-xs h-[38px] w-full"
                placeholder="Obs. adicionales..."
              />
            </div>
          </div>
        </div>

        <!-- Overlap Warning (Inter-stage) -->
        <div v-if="hasOverlap(index)" class="mt-3 p-1.5 bg-red-50 dark:bg-red-500/10 rounded-lg text-[9px] text-red-600 font-black flex items-center gap-1.5 animate-in slide-in-from-top-1">
           <WarningIcon class="w-3 h-3" />
           LA FECHA DE ZARPADA ES ANTERIOR AL ARRIBO PREVIO
        </div>

        <!-- Inconsistency Warning (Internal) -->
        <div v-if="isInternalInconsistent(index)" class="mt-3 p-1.5 bg-amber-50 dark:bg-amber-500/10 rounded-lg text-[9px] text-amber-600 font-black flex items-center gap-1.5 animate-in slide-in-from-top-1">
           <WarningIcon class="w-3 h-3" />
           LA FECHA DE ARRIBO ES ANTERIOR A LA ZARPADA
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, nextTick } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import { 
  MapPinIcon, 
  TrashIcon, 
  ChevronRightIcon, 
  FlagIcon, 
  SettingsIcon, 
  EditIcon,
  WarningIcon
} from '@/icons';

const props = defineProps<{
  modelValue: any[];
  puertoOptions: any[];
  pesqueriaOptions: any[];
  puertoBaseId?: string;
  defaultPesqueriaId?: string;
  readOnly?: boolean;
  minStages?: number;
}>();

const emit = defineEmits(['update:modelValue', 'remove-stage']);

// Refs for focus/scroll
const zarpadaDates = ref<any[]>([]);

const canAddStage = computed(() => {
  if (props.readOnly) return false;
  if (props.modelValue.length === 0) return true;
  const last = props.modelValue[props.modelValue.length - 1];
  return !!last.fechaArribo; // Only allow adding if last stage finished
});

async function addStage() {
  if (!canAddStage.value) return;

  const currentStages = [...props.modelValue];
  const lastStage = currentStages[currentStages.length - 1];
  
  let defaultPesqueria = props.defaultPesqueriaId || '';
  let defaultPuertoZarpada = props.puertoBaseId || '';

  if (lastStage) {
    if (lastStage.pesqueriaId) defaultPesqueria = lastStage.pesqueriaId;
    if (lastStage.puertoArriboId) defaultPuertoZarpada = lastStage.puertoArriboId;
  }

  currentStages.push({
    id: null,
    nroEtapa: currentStages.length + 1,
    puertoZarpadaId: defaultPuertoZarpada,
    fechaZarpada: '',
    puertoArriboId: '',
    fechaArribo: '',
    pesqueriaId: defaultPesqueria,
    tipoEtapa: 'COMERCIAL',
    observaciones: ''
  });

  emit('update:modelValue', currentStages);

  // Focus and scroll to new stage
  await nextTick();
  const lastIdx = currentStages.length - 1;
  const targetDate = zarpadaDates.value[lastIdx];
  
  if (targetDate) {
    targetDate.focus();
    const card = document.getElementById(`stage-card-${lastIdx}`);
    if (card) {
      card.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }
}

function removeStage(index: number) {
  const currentStages = [...props.modelValue];
  currentStages.splice(index, 1);
  emit('update:modelValue', currentStages);
  emit('remove-stage', index);
}

function hasOverlap(index: number) {
  if (index === 0) return false;
  const current = props.modelValue[index];
  const previous = props.modelValue[index - 1];
  
  if (!current.fechaZarpada || !previous.fechaArribo) return false;
  
  const currentStart = new Date(current.fechaZarpada).getTime();
  const previousEnd = new Date(previous.fechaArribo).getTime();
  
  return currentStart < previousEnd; 
}

function isInternalInconsistent(index: number) {
  const stage = props.modelValue[index];
  if (!stage.fechaZarpada || !stage.fechaArribo) return false;
  
  const zarpada = new Date(stage.fechaZarpada).getTime();
  const arribo = new Date(stage.fechaArribo).getTime();
  
  return arribo < zarpada;
}
</script>
