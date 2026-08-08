<template>
  <div class="flex flex-col xl:flex-row gap-6 h-[calc(100vh-14rem)] min-h-[600px]">
    <!-- Columna Izquierda: Lista de Observadores -->
    <div class="w-full xl:w-72 shrink-0 flex flex-col bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
      <div class="p-4 border-b border-border bg-surface-muted/30">
        <SearchInput
          v-model="searchQuery"
          placeholder="Buscar observador..."
        />
      </div>
      
      <div class="flex-1 overflow-y-auto p-2">
        <div v-if="isLoadingObservadores" class="flex justify-center p-8">
          <div class="w-6 h-6 border-2 border-primary border-t-transparent rounded-full animate-spin"></div>
        </div>
        <div v-else-if="filteredObservadores.length === 0" class="text-center p-8 text-sm text-text-muted">
          No se encontraron observadores.
        </div>
        <div v-else class="space-y-1">
          <button
            v-for="obs in filteredObservadores"
            :key="obs.id"
            @click="selectedObservador = obs.id"
            class="w-full flex items-center gap-3 p-3 rounded-xl transition-all text-left"
            :class="selectedObservador === obs.id 
              ? 'bg-primary/10 text-primary font-bold' 
              : 'hover:bg-surface-muted/50 text-text'"
          >
            <div class="flex-1 min-w-0">
              <div class="truncate">{{ obs.apellido }}, {{ obs.nombre }}</div>
              <div class="text-[10px] opacity-70 truncate">{{ obs.codigoInterno }}</div>
            </div>
          </button>
        </div>
      </div>
    </div>

    <!-- Columna Derecha: Calendario -->
    <div class="flex-1 min-w-0 bg-surface border border-border rounded-2xl shadow-sm p-4 xl:p-6 overflow-y-auto flex flex-col">
      <ObservadorCalendar
        :observador-id="selectedObservador"
        :novedades="props.novedades"
        :detail-mode="'emit'"
        @event-click="handleEventClick"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue';
import type { Novedad } from '../interfaces/novedad.interface';
import SearchInput from '@/components/ui/SearchInput.vue';
import observadorService from '../services/observadores.service';
import type { Observador } from '../interfaces/observador.interface';
import ObservadorCalendar from './ObservadorCalendar.vue';

const props = defineProps<{
  novedades: Novedad[];
}>();

const emit = defineEmits<{
  (e: 'eventClick', novedad: Novedad): void;
  (e: 'observerChanged', observadorId: string): void;
}>();

const observadores = ref<Observador[]>([]);
const isLoadingObservadores = ref(false);
const searchQuery = ref('');
const selectedObservador = ref<string | null>(null);

const fetchObservadores = async () => {
  isLoadingObservadores.value = true;
  try {
    const data = await observadorService.getObservadores();
    observadores.value = data.sort((a: Observador, b: Observador) => a.apellido.localeCompare(b.apellido));
  } catch (error) {
    console.error('Error fetching observadores', error);
  } finally {
    isLoadingObservadores.value = false;
  }
};

onMounted(() => {
  fetchObservadores();
});

watch(selectedObservador, (newVal) => {
  if (newVal) {
    emit('observerChanged', newVal);
  }
});

const filteredObservadores = computed(() => {
  if (!searchQuery.value) return observadores.value;
  const q = searchQuery.value.toLowerCase();
  return observadores.value.filter((o: Observador) => 
    o.nombre.toLowerCase().includes(q) || 
    o.apellido.toLowerCase().includes(q) ||
    o.codigoInterno?.toString().includes(q)
  );
});

const handleEventClick = (novedad: Novedad) => {
  emit('eventClick', novedad);
};
</script>
