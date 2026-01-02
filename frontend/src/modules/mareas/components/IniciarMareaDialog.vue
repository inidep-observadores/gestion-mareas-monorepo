<template>
  <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-gray-950/40 backdrop-blur-sm" @click="$emit('close')"></div>
    <div class="bg-white dark:bg-gray-900 rounded-2xl p-8 max-w-md w-full shadow-2xl relative animate-in fade-in zoom-in-95 duration-300">
      
      <div class="border-b border-gray-100 dark:border-gray-800 pb-4 mb-6">
        <h3 class="text-xl font-bold text-gray-800 dark:text-white">Registrar Inicio de Marea</h3>
        <p class="text-gray-500 text-xs mt-1">Indique la fecha real de inicio del observador (zarpada) y el puerto de salida.</p>
      </div>

      <div class="space-y-6">
          <div class="space-y-1.5">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Fecha de Inicio Real</label>
            <DatePicker 
              v-model="form.fechaInicio"
            />
          </div>

          <div class="space-y-1.5">
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-400">Puerto de Zarpada</label>
            <SearchableSelect 
               v-model="form.puertoId"
               :options="puertoOptions"
               placeholder="Seleccione puerto..."
            />
          </div>
      </div>

      <div class="mt-8 grid grid-cols-2 gap-4">
        <button 
          @click="$emit('close')"
          class="px-6 py-3.5 bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-xl text-sm font-bold uppercase tracking-wider transition-all"
        >
          Cancelar
        </button>
        <button 
          @click="handleConfirm"
          :disabled="!isValid"
          class="px-6 py-3.5 bg-brand-500 hover:bg-brand-600 text-white rounded-xl text-sm font-bold uppercase tracking-wider shadow-lg shadow-brand-500/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
        >
          Confirmar Inicio
        </button>
      </div>

    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import catalogosService from '../services/catalogos.service';

const props = defineProps({
    show: Boolean,
    initialDate: String,
    initialPortId: String
});

const emit = defineEmits(['close', 'confirm']);

const form = ref({
    fechaInicio: '',
    puertoId: ''
});

const puertos = ref<any[]>([]);

// Load catalogs
onMounted(async () => {
    try {
        puertos.value = await catalogosService.getPuertos();
    } catch (e) { console.error(e); }
});

// Watch show to reset/init form
watch(() => props.show, (val) => {
    if (val) {
        form.value.fechaInicio = props.initialDate || new Date().toISOString();
        form.value.puertoId = props.initialPortId || '';
        
        // If not explicit initial date, default to NOW
        if (!props.initialDate) {
             form.value.fechaInicio = new Date().toISOString();
        }
    }
});

const puertoOptions = computed(() => puertos.value.map(p => ({ value: p.id, label: p.nombre })));

const isValid = computed(() => !!form.value.fechaInicio && !!form.value.puertoId);

function handleConfirm() {
    emit('confirm', { ...form.value });
}
</script>
