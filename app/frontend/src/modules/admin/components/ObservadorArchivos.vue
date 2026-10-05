<template>
  <div class="flex flex-col h-full bg-surface p-6 overflow-y-auto">
    <div v-if="loading" class="flex justify-center items-center py-12">
      <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
    </div>
    
    <div v-else-if="!archivos || archivos.length === 0" class="flex flex-col items-center justify-center py-12 text-center h-full text-text-muted">
      <p class="text-sm font-bold">No hay archivos vinculados a este observador.</p>
      <p class="text-[10px]">Los archivos subidos en novedades (como pasajes de viajes) aparecerán aquí.</p>
    </div>

    <div v-else class="space-y-6">
      <AttachmentViewer
        title="Archivos de Novedades"
        :archivos="archivos"
        preview-endpoint-base="/catalogos/observadores/archivos"
      />
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import AttachmentViewer from '@/components/common/AttachmentViewer.vue';
import observadoresApi from '../services/observadores.service';
import { toast } from 'vue-sonner';

const props = defineProps<{
  observadorId: string | null;
}>();

const archivos = ref<any[]>([]);
const loading = ref(false);

const loadArchivos = async () => {
  if (!props.observadorId) return;
  loading.value = true;
  try {
    archivos.value = await observadoresApi.getArchivos(props.observadorId);
  } catch (error) {
    console.error('Error cargando archivos del observador:', error);
    toast.error('No se pudieron cargar los archivos del observador');
  } finally {
    loading.value = false;
  }
};

watch(() => props.observadorId, (newId) => {
  if (newId) {
    loadArchivos();
  } else {
    archivos.value = [];
  }
});

onMounted(() => {
  loadArchivos();
});
</script>
