<template>
  <div class="space-y-3">
    <!-- Encabezado / Botón Toggle o Agregar -->
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-2">
        <label class="text-xs font-black uppercase tracking-wider text-text-muted">
          Observadores Secundarios Planificados
        </label>
        <span
          v-if="modelValue && modelValue.length > 0"
          class="px-2 py-0.5 text-[10px] font-bold rounded-full bg-primary/10 text-primary border border-primary/20"
        >
          {{ modelValue.length }}
        </span>
      </div>

      <button
        v-if="!readOnly && !showAddForm"
        type="button"
        @click="openAddForm"
        class="inline-flex items-center gap-1.5 px-2.5 py-1 text-xs font-bold text-primary hover:bg-primary/10 border border-primary/20 rounded-lg transition-colors cursor-pointer"
      >
        <PlusIcon class="w-3.5 h-3.5" />
        <span>Agregar Secundario</span>
      </button>
    </div>

    <!-- Lista de observadores ya agregados al borrador -->
    <div v-if="modelValue && modelValue.length > 0" class="space-y-2">
      <div
        v-for="(item, index) in modelValue"
        :key="item.observadorId || index"
        class="flex items-center justify-between p-3 bg-surface border border-border rounded-xl hover:border-primary/30 transition-all text-xs group"
        :class="{ 'ring-2 ring-primary/40 border-primary': showAddForm && editingIndex === index }"
      >
        <div class="flex items-center gap-3">
          <div class="w-7 h-7 rounded-lg bg-primary/10 text-primary flex items-center justify-center font-bold text-[11px] shrink-0">
            {{ index + 1 }}
          </div>
          <div>
            <p class="font-bold text-text text-xs">
              {{ getObservadorLabel(item.observadorId) }}
            </p>
            <div class="flex items-center gap-2 mt-0.5">
              <span class="px-1.5 py-0.5 rounded text-[10px] font-semibold bg-surface-muted text-text-muted border border-border">
                {{ formatEtapasCoverage(item) }}
              </span>
              <span v-if="item.notas" class="text-[10px] text-text-muted italic max-w-xs truncate">
                "{{ item.notas }}"
              </span>
            </div>
          </div>
        </div>

        <div v-if="!readOnly" class="flex items-center gap-1">
          <button
            type="button"
            @click="editObservador(index)"
            class="p-1.5 text-text-muted hover:text-primary hover:bg-primary/10 rounded-lg transition-colors"
            title="Editar observador planificado"
          >
            <PencilIcon class="w-3.5 h-3.5" />
          </button>
          <button
            type="button"
            @click="removeObservador(index)"
            class="p-1.5 text-text-muted hover:text-error hover:bg-error/10 rounded-lg transition-colors"
            title="Eliminar observador planificado"
          >
            <Trash2Icon class="w-4 h-4" />
          </button>
        </div>
      </div>
    </div>

    <!-- Estado vacío cuando no hay observadores planificados y no se está editando -->
    <div
      v-else-if="!showAddForm"
      class="p-4 bg-surface-muted/50 border border-dashed border-border rounded-xl text-center"
    >
      <p class="text-xs text-text-muted">
        No se han asignado observadores secundarios previstos.
      </p>
    </div>

    <!-- Formulario Inline para Agregar / Editar Observador -->
    <div
      v-if="showAddForm && !readOnly"
      class="p-4 bg-primary/5 border border-primary/20 rounded-xl space-y-3 animate-in fade-in zoom-in-95 duration-200"
    >
      <div class="flex items-center justify-between pb-2 border-b border-primary/10">
        <span class="text-xs font-black uppercase tracking-wider text-primary">
          {{ editingIndex !== null ? 'Editar Observador Secundario' : 'Nuevo Observador Secundario' }}
        </span>
        <button
          type="button"
          @click="closeAddForm"
          class="p-1 text-text-muted hover:text-text rounded-md"
        >
          <XIcon class="w-4 h-4" />
        </button>
      </div>

      <!-- Selector de Observador -->
      <div class="space-y-1">
        <label class="block text-xs font-bold text-text-muted">Observador</label>
        <SearchableSelect
          v-model="newEntry.observadorId"
          :options="availableObserverOptions"
          :icon="UserIcon"
          placeholder="Seleccionar observador secundario..."
        />
        <p v-if="formError" class="text-[11px] text-error font-medium">{{ formError }}</p>
      </div>

      <!-- Modo de Cobertura de Etapas -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-3 pt-1">
        <div class="space-y-1">
          <label class="block text-xs font-bold text-text-muted">Etapa Inicial</label>
          <input
            v-model.number="newEntry.etapaDesde"
            type="number"
            min="1"
            class="w-full px-3 py-2 bg-surface border border-border rounded-lg text-xs font-bold text-text outline-none focus:border-primary transition-all"
            placeholder="Desde etapa (ej: 1)"
          />
        </div>

        <div class="space-y-1">
          <div class="flex items-center justify-between">
            <label class="block text-xs font-bold text-text-muted">Etapa Final</label>
            <label class="flex items-center gap-1 cursor-pointer text-[10px] text-text-muted">
              <input
                type="checkbox"
                v-model="hastaFinDeMarea"
                class="rounded border-border text-primary focus:ring-primary/20 w-3 h-3"
              />
              <span>Toda la marea</span>
            </label>
          </div>
          <input
            v-if="!hastaFinDeMarea"
            v-model.number="newEntry.etapaHasta"
            type="number"
            :min="newEntry.etapaDesde || 1"
            class="w-full px-3 py-2 bg-surface border border-border rounded-lg text-xs font-bold text-text outline-none focus:border-primary transition-all"
            placeholder="Hasta etapa (ej: 1)"
          />
          <div
            v-else
            class="px-3 py-2 bg-surface-muted border border-border rounded-lg text-xs font-medium text-text-muted italic"
          >
            Sin límite (continúa)
          </div>
        </div>
      </div>

      <!-- Notas opcionales -->
      <div class="space-y-1">
        <label class="block text-xs font-bold text-text-muted">Observaciones / Notas (Opcional)</label>
        <input
          v-model="newEntry.notas"
          type="text"
          class="w-full px-3 py-2 bg-surface border border-border rounded-lg text-xs text-text outline-none focus:border-primary transition-all"
          placeholder="Ej: Sólo participa en la prospección"
        />
      </div>

      <!-- Botones de Acción del Formulario -->
      <div class="flex items-center justify-end gap-2 pt-2">
        <button
          type="button"
          @click="closeAddForm"
          class="px-3 py-1.5 text-xs font-bold text-text-muted hover:text-text rounded-lg transition-colors"
        >
          Cancelar
        </button>
        <button
          type="button"
          @click="saveObservador"
          class="px-4 py-1.5 text-xs font-black uppercase tracking-wider bg-primary text-primary-fg hover:bg-primary-hover rounded-lg transition-all active:scale-95 shadow-sm"
        >
          {{ editingIndex !== null ? 'Guardar Cambios' : 'Agregar al Borrador' }}
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import type { ObservadorSecundarioPlanificado } from '../types/marea-metadata.types';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import { PlusIcon, Trash2Icon, PencilIcon, XIcon, UserIcon } from 'lucide-vue-next';
import catalogosService, { type Observador } from '../services/catalogos.service';

interface SelectOption {
  value: string;
  label: string;
  [key: string]: any;
}

const props = withDefaults(
  defineProps<{
    modelValue?: ObservadorSecundarioPlanificado[];
    observadorOptions?: SelectOption[];
    observadorPrincipalId?: string | null;
    readOnly?: boolean;
  }>(),
  {
    modelValue: () => [],
    observadorOptions: () => [],
    observadorPrincipalId: null,
    readOnly: false
  }
);

const emit = defineEmits<{
  (e: 'update:modelValue', value: ObservadorSecundarioPlanificado[]): void;
}>();

const internalObservadores = ref<Observador[]>([]);

onMounted(async () => {
  if (!props.observadorOptions || props.observadorOptions.length === 0) {
    try {
      internalObservadores.value = await catalogosService.getObservadores();
    } catch (e) {
      console.error('Error al cargar observadores para ObservadoresSecundariosEditor:', e);
    }
  }
});

const effectiveObserverOptions = computed(() => {
  if (props.observadorOptions && props.observadorOptions.length > 0) {
    return props.observadorOptions;
  }
  return internalObservadores.value
    .sort((a, b) => (a.apellido || '').localeCompare(b.apellido || ''))
    .map(o => ({
      value: o.id,
      label: `${o.apellido}, ${o.nombre}`
    }));
});

const showAddForm = ref(false);
const editingIndex = ref<number | null>(null);
const hastaFinDeMarea = ref(true);
const formError = ref('');

const newEntry = ref<ObservadorSecundarioPlanificado>({
  observadorId: '',
  etapaDesde: 1,
  etapaHasta: null,
  notas: ''
});

// Filtrar opciones para no permitir elegir al observador principal ni a los ya agregados (excepto el que se está editando)
const availableObserverOptions = computed(() => {
  const currentItems = props.modelValue || [];
  const selectedIds = new Set(
    currentItems
      .filter((_, idx) => editingIndex.value === null || idx !== editingIndex.value)
      .map(o => o.observadorId)
  );

  if (props.observadorPrincipalId) {
    selectedIds.add(props.observadorPrincipalId);
  }

  return effectiveObserverOptions.value.filter(opt => !selectedIds.has(opt.value));
});

const getObservadorLabel = (id: string): string => {
  const found = effectiveObserverOptions.value.find(o => o.value === id);
  return found ? found.label : (id ? 'Observador' : '');
};


const formatEtapasCoverage = (item: ObservadorSecundarioPlanificado): string => {
  const desde = item.etapaDesde || 1;
  const hasta = item.etapaHasta;
  if (!hasta) {
    return desde === 1 ? 'Toda la marea' : `Desde Etapa ${desde}`;
  }
  if (desde === hasta) {
    return `Etapa ${desde}`;
  }
  return `Etapas ${desde} a ${hasta}`;
};

const openAddForm = () => {
  formError.value = '';
  editingIndex.value = null;
  hastaFinDeMarea.value = true;
  newEntry.value = {
    observadorId: '',
    etapaDesde: 1,
    etapaHasta: null,
    notas: ''
  };
  showAddForm.value = true;
};

const editObservador = (index: number) => {
  const item = (props.modelValue || [])[index];
  if (!item) return;

  formError.value = '';
  editingIndex.value = index;
  hastaFinDeMarea.value = item.etapaHasta === null || item.etapaHasta === undefined;
  newEntry.value = {
    observadorId: item.observadorId,
    etapaDesde: item.etapaDesde || 1,
    etapaHasta: item.etapaHasta ?? null,
    notas: item.notas || ''
  };
  showAddForm.value = true;
};

const closeAddForm = () => {
  showAddForm.value = false;
  editingIndex.value = null;
  formError.value = '';
};

const saveObservador = () => {
  formError.value = '';

  if (!newEntry.value.observadorId) {
    formError.value = 'Debe seleccionar un observador.';
    return;
  }

  const desde = Number(newEntry.value.etapaDesde) || 1;
  const hasta = hastaFinDeMarea.value ? null : Number(newEntry.value.etapaHasta) || null;

  if (hasta !== null && hasta < desde) {
    formError.value = 'La etapa final no puede ser menor que la etapa inicial.';
    return;
  }

  const entryData: ObservadorSecundarioPlanificado = {
    observadorId: newEntry.value.observadorId,
    etapaDesde: desde,
    etapaHasta: hasta,
    notas: newEntry.value.notas?.trim() || undefined
  };

  const current = [...(props.modelValue || [])];

  if (editingIndex.value !== null && editingIndex.value >= 0 && editingIndex.value < current.length) {
    current[editingIndex.value] = entryData;
  } else {
    current.push(entryData);
  }

  emit('update:modelValue', current);
  closeAddForm();
};

const removeObservador = (index: number) => {
  if (editingIndex.value === index) {
    closeAddForm();
  }
  const current = [...(props.modelValue || [])];
  current.splice(index, 1);
  emit('update:modelValue', current);
};
</script>

