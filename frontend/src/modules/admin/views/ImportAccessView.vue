<template>
  <AdminDashboardLayout
    title="Importación de Novedades (Access)"
    description="Suba el archivo .accdb del sistema externo para detectar zarpadas y arribos."
  >
    <div class="space-y-6 text-text">
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">
          <div 
            class="bg-surface border-2 border-dashed border-border rounded-2xl p-12 transition-all duration-300 flex flex-col items-center justify-center text-center space-y-4"
            :class="{ 'border-primary bg-primary/5': isDragging, 'opacity-50 pointer-events-none': isUploading }"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="handleDrop"
          >
            <div class="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center text-primary mb-2">
              <CloudUploadIcon v-if="!isUploading" class="w-8 h-8" />
              <LoadingSpinner v-else class="w-8 h-8" />
            </div>
            
            <div v-if="!isUploading">
              <h3 class="text-lg font-semibold">Arrastre el archivo .accdb aquí</h3>
              <p class="text-text-muted mt-1">O haga clic para seleccionar desde su ordenador</p>
              <input 
                type="file" 
                class="hidden" 
                ref="fileInputRef" 
                accept=".accdb,.mdb" 
                @change="handleFileSelect"
              />
              <button 
                @click="fileInputRef?.click()"
                class="mt-6 px-6 py-2.5 bg-primary text-primary-fg rounded-xl font-medium hover:bg-primary-hover transition-all shadow-sm active:scale-95"
              >
                Seleccionar Archivo
              </button>
            </div>
            
            <div v-else class="space-y-2">
              <h3 class="text-lg font-semibold">Procesando archivo...</h3>
              <p class="text-text-muted italic">Analizando registros y comparando con el historial...</p>
            </div>
          </div>

          <div class="bg-surface rounded-2xl p-6 border border-border shadow-sm space-y-4">
            <h3 class="font-semibold flex items-center gap-2">
              <InfoIcon class="w-5 h-5 text-info" />
              Información Importante
            </h3>
            <ul class="space-y-3 text-sm text-text-muted">
              <li class="flex gap-2">
                <span class="w-1.5 h-1.5 rounded-full bg-primary mt-1.5 flex-shrink-0"></span>
                El sistema utiliza <strong>snapshots</strong> para detectar cambios en el archivo Access sin depender de marcas temporales externas.
              </li>
              <li class="flex gap-2">
                <span class="w-1.5 h-1.5 rounded-full bg-primary mt-1.5 flex-shrink-0"></span>
                Se generarán alertas de <strong>ZARPADA</strong> para nuevos registros con fecha de salida.
              </li>
              <li class="flex gap-2">
                <span class="w-1.5 h-1.5 rounded-full bg-primary mt-1.5 flex-shrink-0"></span>
                Se generarán alertas de <strong>ARRIBO</strong> al detectar la fecha de entrada en registros previamente procesados.
              </li>
              <li class="flex gap-2">
                <span class="w-1.5 h-1.5 rounded-full bg-primary mt-1.5 flex-shrink-0"></span>
                La vinculación de <strong>Buque</strong> y <strong>Observador</strong> se realiza automáticamente mediante nombre y código interno respectivamente.
              </li>
            </ul>
          </div>
        </div>

        <div class="space-y-6">
          <div class="bg-surface rounded-2xl p-6 border border-border shadow-sm">
            <h3 class="font-semibold mb-4">Resultado de la Importación</h3>
            
            <div v-if="results" class="space-y-4">
              <div class="flex items-center justify-between p-3 rounded-xl bg-background border border-border">
                <span class="text-sm text-text-muted">Procesados</span>
                <span class="font-bold">{{ results.total }}</span>
              </div>
              <div class="flex items-center justify-between p-3 rounded-xl bg-success/5 border border-success/10">
                <span class="text-sm text-success font-medium">Nuevos/Base</span>
                <span class="font-bold text-success">{{ results.nuevos }}</span>
              </div>
              <div class="flex items-center justify-between p-3 rounded-xl bg-info/5 border border-info/10">
                <span class="text-sm text-info font-medium">Actualizaciones</span>
                <span class="font-bold text-info">{{ results.actualizados }}</span>
              </div>
              <div class="flex items-center justify-between p-3 rounded-xl bg-primary/5 border border-primary/10">
                <span class="text-sm text-primary font-medium">Alertas Creadas</span>
                <span class="font-bold text-primary text-xl">{{ results.alertasGeneradas }}</span>
              </div>

              <div v-if="results.alertasGeneradas > 0" class="mt-6 pt-4 border-t border-border">
                <router-link 
                  to="/mareas/inbox"
                  class="w-full py-3 bg-primary text-primary-fg rounded-xl font-medium hover:brightness-110 transition-all flex items-center justify-center gap-2 shadow-sm"
                >
                  Ver Alertas
                  <ChevronRightIcon class="w-4 h-4" />
                </router-link>
              </div>
            </div>

            <div v-else class="flex flex-col items-center justify-center py-10 text-center space-y-3 opacity-60">
              <ArchiveIcon class="w-12 h-12 text-text-muted" />
              <p class="text-sm text-text-muted px-4">Suba un archivo para ver los resultados del procesamiento.</p>
            </div>
          </div>

          <div class="bg-primary/5 rounded-2xl p-6 border border-primary/10">
            <h4 class="text-xs font-bold text-primary uppercase tracking-widest mb-2">Trazabilidad</h4>
            <p class="text-xs text-text-muted leading-relaxed">
              Cada alerta posee un código de origen único que evita la duplicidad, incluso si se sube el mismo archivo múltiples veces.
            </p>
          </div>
        </div>
      </div>
    </div>
  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import axios from 'axios';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import { 
  CloudUploadIcon, 
  InfoIcon, 
  ArchiveIcon, 
  ChevronRightIcon 
} from '@/icons';
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue';

const isDragging = ref(false);
const isUploading = ref(false);
const results = ref<any>(null);
const fileInputRef = ref<HTMLInputElement | null>(null);

const handleDrop = (e: DragEvent) => {
  isDragging.value = false;
  const files = e.dataTransfer?.files;
  if (files && files.length > 0) {
    uploadFile(files[0]);
  }
};

const handleFileSelect = (e: Event) => {
  const target = e.target as HTMLInputElement;
  const files = target.files;
  if (files && files.length > 0) {
    uploadFile(files[0]);
  }
};

const uploadFile = async (file: File) => {
  if (isUploading.value) return;
  
  const ext = file.name.split('.').pop()?.toLowerCase();
  if (ext !== 'accdb' && ext !== 'mdb') {
    alert('Formato no soportado. Use .accdb o .mdb');
    return;
  }

  isUploading.value = true;
  results.value = null;

  const formData = new FormData();
  formData.append('file', file);

  try {
    const response = await axios.post('/access-import/upload', formData, {
      headers: {
        'Content-Type': 'multipart/form-data',
      },
    });
    
    results.value = response.data.summary;
  } catch (error: any) {
    console.error('Error:', error);
    alert('Error al procesar: ' + (error.response?.data?.message || error.message));
  } finally {
    isUploading.value = false;
    if (fileInputRef.value) fileInputRef.value.value = '';
  }
};
</script>
