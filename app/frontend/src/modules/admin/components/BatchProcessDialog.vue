<script setup lang="ts">
import { computed, ref } from 'vue';
import {
  RefreshIcon,
  SuccessIcon,
  WarningIcon,
  XIcon,
  ChevronDownIcon
} from '@/icons';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';

const props = defineProps<{
  visible: boolean;
  isProcessing: boolean;
  results: {
    total: number;
    processed: number;
    details: Array<{
        id: string;
        titulo: string;
        status: 'CONFIRMED' | 'SKIPPED' | 'ERROR';
        reason?: string;
    }>;
  } | null;
}>();

const emit = defineEmits(['close']);
const detailsOpen = ref(false);

const close = () => {
  if (!props.isProcessing) {
    emit('close');
  }
};

const dialogTitle = computed(() => {
  return props.isProcessing ? 'Procesando Alertas' : 'Autoconfirmación Masiva';
});

const dialogMessage = computed(() => {
  return props.isProcessing
    ? 'El sistema está validando las fuentes y confirmando los movimientos.'
    : (props.results ? 'Proceso finalizado.' : '');
});
</script>

<template>
  <ConfirmationDialog
    :show="visible"
    :title="dialogTitle"
    :message="dialogMessage"
    :is-sidebar-aware="false"
    @close="close"
  >
    <!-- Content Area -->
    <div class="flex flex-col items-center text-center">
      <!-- Processing State -->
      <div v-if="isProcessing" class="space-y-6 animate-in fade-in duration-500 w-full py-4">
        <div class="relative mx-auto w-20 h-20">
          <div class="w-20 h-20 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
          <RefreshIcon class="w-8 h-8 text-primary absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 animate-pulse" />
        </div>
        <p class="text-sm text-text-muted">El sistema está analizando las alertas pendientes y validando fuentes...</p>
      </div>

      <!-- Result State -->
      <div v-else-if="results" class="space-y-6 animate-in slide-in-from-bottom-4 duration-300 w-full font-sans">
        <!-- Summary Stats -->
        <div class="grid grid-cols-2 gap-4">
            <div class="bg-surface-muted/50 p-4 rounded-xl border border-border text-center shadow-sm">
              <span class="text-[10px] font-bold uppercase tracking-wider text-text-muted block mb-1">Confirmadas</span>
              <span class="text-2xl font-bold text-success">{{ results.processed }}</span>
            </div>
            <div class="bg-surface-muted/50 p-4 rounded-xl border border-border text-center shadow-sm">
              <span class="text-[10px] font-bold uppercase tracking-wider text-text-muted block mb-1">Omitidas / Error</span>
              <span class="text-2xl font-bold text-warning">{{ results.total - results.processed }}</span>
            </div>
        </div>

        <!-- Collapsible Details -->
        <div class="w-full">
          <button 
            @click="detailsOpen = !detailsOpen"
            class="flex items-center justify-center gap-2 w-full py-2 text-xs font-semibold text-text-muted hover:text-primary transition-colors mb-2"
          >
            <span>{{ detailsOpen ? 'Ocultar Detalles' : 'Ver Detalles' }}</span>
            <ChevronDownIcon 
              class="w-4 h-4 transition-transform duration-300" 
              :class="{ 'rotate-180': detailsOpen }"
            />
          </button>

          <div v-show="detailsOpen" class="bg-surface-muted/30 rounded-xl border border-border p-4 max-h-[300px] overflow-y-auto text-left space-y-2 animate-in slide-in-from-top-2 duration-200 shadow-inner">
            <div v-for="detail in results.details" :key="detail.id" class="flex items-start gap-3 p-3 bg-surface rounded-lg border border-border/50 text-xs hover:bg-surface-muted/20 transition-colors">
              <div class="mt-0.5 shrink-0">
                <SuccessIcon v-if="detail.status === 'CONFIRMED'" class="w-4 h-4 text-success" />
                <WarningIcon v-else-if="detail.status === 'SKIPPED'" class="w-4 h-4 text-warning" />
                <XIcon v-else class="w-4 h-4 text-error" />
              </div>
              <div class="flex-1 min-w-0">
                <p class="font-semibold text-text truncate">{{ detail.titulo }}</p>
                <p v-if="detail.reason" class="text-[10px] text-text-muted mt-0.5 leading-tight">{{ detail.reason }}</p>
              </div>
              <span class="text-[9px] font-bold uppercase tracking-wider px-2 py-0.5 rounded-full border"
                :class="{
                  'bg-success/10 text-success border-success/20': detail.status === 'CONFIRMED',
                  'bg-warning/10 text-warning border-warning/20': detail.status === 'SKIPPED',
                  'bg-error/10 text-error border-error/20': detail.status === 'ERROR'
                }"
              >
                {{ detail.status === 'CONFIRMED' ? 'OK' : (detail.status === 'SKIPPED' ? 'OMITIDA' : 'ERROR') }}
              </span>
            </div>
              <p v-if="results.details?.length === 0" class="text-center text-text-muted italic py-4">No hay detalles disponibles.</p>
          </div>
        </div>
      </div>
    </div>

    <template #footer>
      <div v-if="!isProcessing" class="flex justify-center w-full">
        <button @click="close"
          class="px-10 py-3 bg-primary text-primary-fg rounded-xl font-bold uppercase tracking-widest hover:bg-primary/90 transition-all shadow-xl shadow-primary/20 w-full sm:w-auto">
          Entendido
        </button>
      </div>
      <div v-else class="text-center">
          <span class="text-xs font-bold text-text-muted uppercase tracking-widest animate-pulse">Procesando...</span>
      </div>
    </template>
  </ConfirmationDialog>
</template>
