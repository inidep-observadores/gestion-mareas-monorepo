<template>
  <div v-if="archivos && archivos.length > 0" class="flex flex-col">
    <!-- Header with Toggle -->
    <div class="flex items-center justify-between mb-2">
      <p class="text-[10px] font-black text-text-muted uppercase">{{ title || 'Archivos Generados/Adjuntos:' }}</p>
      
      <!-- Toggle View Mode Button -->
      <button 
        v-if="!hideToggle"
        type="button"
        @click="toggleViewMode"
        class="flex items-center gap-1.5 px-2 py-1 bg-surface border border-border rounded hover:border-primary transition-colors text-[10px] font-bold text-text-muted hover:text-primary group"
        :title="viewMode === 'inline' ? 'Cambiar a vista de lista' : 'Cambiar a vista de previsualización'"
      >
        <span v-if="viewMode === 'inline'" class="flex items-center gap-1">
          <ListIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
          Ver como Lista
        </span>
        <span v-else class="flex items-center gap-1">
          <EyeIcon class="w-3 h-3 group-hover:text-primary transition-colors" />
          Ver Previsualización
        </span>
      </button>
    </div>

    <!-- Inline Preview Mode -->
    <div v-if="viewMode === 'inline'" class="flex flex-col gap-3">
      <div v-for="arch in sortedArchivos" :key="arch.id" class="flex flex-col flex-1 min-h-[300px] border border-border rounded-lg overflow-hidden bg-surface-muted relative shadow-inner group">
        <!-- Top bar over iframe for actions -->
        <div class="absolute top-0 inset-x-0 bg-surface-muted/90 backdrop-blur border-b border-border p-2 flex justify-between items-center z-10 opacity-0 group-hover:opacity-100 transition-opacity">
          <div class="flex items-center gap-2 truncate px-2 min-w-0">
            <span 
              v-if="arch.tipoNovedad" 
              class="inline-flex items-center px-1.5 py-0.5 rounded-full text-[9px] font-extrabold uppercase tracking-wider border truncate shrink-0"
              :class="getTipoNovedadBadgeClass(arch)"
              :title="arch.tipoNovedad"
            >
              {{ arch.tipoNovedad }}
            </span>
            <span class="text-xs font-bold text-text truncate" :title="arch.nombreOriginal">{{ arch.nombreOriginal }}</span>
          </div>
          <div class="flex items-center gap-2 shrink-0">
            <span v-if="arch.fechaRecepcion" class="text-[10px] font-mono text-text-muted" title="Fecha de recepción">
              {{ formatShortDate(arch.fechaRecepcion) }}
            </span>
            <a :href="arch.rutaArchivo" target="_blank" class="text-[10px] font-bold text-primary hover:underline flex items-center gap-1 bg-primary/10 px-2 py-0.5 rounded-full transition-colors hover:bg-primary/20 shrink-0">
              Abrir externo <ExternalLinkIcon class="w-3 h-3" />
            </a>
          </div>
        </div>
        
        
        <!-- Fallback for Office Files via Gotenberg -->
        <div v-if="isOfficeFile(arch.nombreOriginal)" class="w-full h-[400px] flex flex-col bg-surface relative overflow-hidden">
          <!-- Iframe shown only after generation -->
          <iframe 
            v-if="pdfPreviewUrls[arch.id]"
            :src="pdfPreviewUrls[arch.id]" 
            class="w-full h-[400px] border-none bg-white absolute inset-0 z-20"
            title="Previsualización de documento PDF convertido"
          ></iframe>
          
          <!-- State UI (shown when no iframe) -->
          <div v-else class="flex flex-col items-center justify-center p-6 text-center h-full">
              <div v-if="isLoadingPdf[arch.id]" class="flex flex-col items-center">
                 <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary mb-3"></div>
                 <p class="text-xs font-bold text-text-muted animate-pulse">Convirtiendo a PDF (esto tomará unos segundos)...</p>
              </div>
              <div v-else class="flex flex-col items-center">
                <FileTextIcon class="w-12 h-12 text-primary/50 mb-3" />
                <p class="text-sm font-bold text-text-muted mb-2">Archivo de Microsoft Office</p>
                <p class="text-[10px] text-text-muted/70 max-w-xs mb-4">El previsualizador en línea genera errores de renderizado. Puedes abrirlo externamente o generar una previsualización interactiva convirtiéndolo a PDF ahora mismo.</p>
                
                <div class="flex gap-3">
                    <button @click="loadPdfPreview(arch)" class="px-4 py-2 border border-primary text-primary hover:bg-primary hover:text-white rounded font-bold text-[10px] transition-colors uppercase tracking-widest flex items-center gap-2">
                        Generar Vista PDF
                    </button>
                    <a :href="arch.rutaArchivo" target="_blank" class="px-4 py-2 bg-primary text-white rounded font-bold text-[10px] hover:bg-primary/90 transition-colors uppercase tracking-widest flex items-center gap-2">
                        Abrir Externo <ExternalLinkIcon class="w-3 h-3" />
                    </a>
                </div>
              </div>
          </div>
        </div>
        
        <!-- Standard Google Drive Iframe Preview -->
        <iframe 
          v-else
          :src="getPreviewUrl(arch.rutaArchivo)" 
          class="w-full h-[400px] border-none bg-white"
          title="Previsualización de documento"
          allow="autoplay"
        ></iframe>
      </div>
    </div>

    <!-- List (Link) Mode -->
    <div v-else class="space-y-2">
      <template v-for="arch in sortedArchivos" :key="arch.id">
        <!-- Modo estructurado (cuando cuenta con Tipo de Novedad) -->
        <div 
          v-if="arch.tipoNovedad" 
          class="p-2.5 bg-surface border border-border rounded-lg hover:border-primary/50 transition-all flex flex-col gap-1.5 shadow-2xs"
        >
          <!-- Encabezado de Novedad: Tipo y Fecha de Recepción -->
          <div class="flex items-center justify-between gap-2 border-b border-border/40 pb-1.5">
            <span 
              class="inline-flex items-center px-2 py-0.5 rounded-full text-[9px] font-extrabold uppercase tracking-wider border truncate"
              :class="getTipoNovedadBadgeClass(arch)"
              :title="arch.tipoNovedad"
            >
              {{ arch.tipoNovedad }}
            </span>
            <span 
              v-if="arch.fechaRecepcion" 
              class="text-[10px] font-mono text-text-muted shrink-0 flex items-center gap-1"
              title="Fecha de recepción"
            >
              <span class="text-[9px] opacity-70">Recibido:</span>
              {{ formatShortDate(arch.fechaRecepcion) }}
            </span>
          </div>

          <!-- Enlace al Archivo -->
          <a 
            :href="arch.rutaArchivo" 
            target="_blank"
            class="flex items-center gap-2 group text-primary hover:underline mt-0.5"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-primary shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
            </svg>
            <span class="text-xs truncate font-medium group-hover:underline" :title="arch.nombreOriginal">{{ arch.nombreOriginal }}</span>
          </a>
        </div>

        <!-- Modo simple estándar (sin novedad asociada) -->
        <a 
          v-else
          :href="arch.rutaArchivo" 
          target="_blank"
          class="flex items-center gap-2 p-2 bg-surface border border-border rounded hover:border-primary transition-colors group mt-1"
        >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-primary shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.586a4 4 0 00-5.656-5.656l-6.415 6.585a6 6 0 108.486 8.486L20.5 13" />
          </svg>
          <span class="text-xs truncate text-primary hover:underline group-hover:underline" :title="arch.nombreOriginal">{{ arch.nombreOriginal }}</span>
        </a>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import httpClient from '@/config/http/http.client';
import { toast } from 'vue-sonner';
import { ArrowRightIcon as ExternalLinkIcon } from '@/icons';
import EyeIcon from '@/icons/EyeIcon.vue';
import ListIcon from '@/icons/ListIcon.vue';
import { FileTextIcon } from 'lucide-vue-next';
import { formatDateUI } from '@/utils/date.utils';

interface Archivo {
  id: string | number;
  rutaArchivo: string;
  nombreOriginal: string;
  tipoNovedad?: string;
  tipoNovedadCodigo?: string;
  fechaRecepcion?: string | Date;
  fechaNovedad?: string | Date;
}

const props = defineProps<{
  archivos?: Archivo[];
  title?: string;
  hideToggle?: boolean;
  previewEndpointBase?: string;
}>();

import { useAttachmentViewMode } from '@/composables/useAttachmentViewMode';

const { viewMode, toggleViewMode } = useAttachmentViewMode();

const pdfPreviewUrls = ref<Record<string, string>>({});
const isLoadingPdf = ref<Record<string, boolean>>({});

const loadPdfPreview = async (arch: Archivo) => {
  if (pdfPreviewUrls.value[arch.id]) return;
  
  isLoadingPdf.value[arch.id] = true;
  try {
    const baseUrl = props.previewEndpointBase || '/mareas/archivos';
    const response = await httpClient.get(`${baseUrl}/${arch.id}/preview-pdf`, {
      responseType: 'blob'
    });
    const blobUrl = URL.createObjectURL(new Blob([response.data], { type: 'application/pdf' }));
    pdfPreviewUrls.value[arch.id] = blobUrl;
  } catch (error) {
    console.error('Error al generar PDF:', error);
    toast.error('Ocurrió un error al intentar generar el PDF para previsualización.');
  } finally {
    isLoadingPdf.value[arch.id] = false;
  }
};

// Limpieza de Object URLs para evitar memory leaks
onUnmounted(() => {
  Object.values(pdfPreviewUrls.value).forEach(url => URL.revokeObjectURL(url));
});

const getPreviewUrl = (url: string) => {
  if (!url) return '';
  // Convertimos el link 'view' de Google Drive a 'preview' para iframes
  return url.replace(/\/view\?usp=.*/, '/preview');
};

const isOfficeFile = (filename: string) => {
  if (!filename) return false;
  const ext = filename.split('.').pop()?.toLowerCase();
  return ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].includes(ext || '');
};

const sortedArchivos = computed(() => {
  if (!props.archivos) return [];
  return [...props.archivos].sort((a, b) => {
    const timeA = a.fechaRecepcion ? new Date(a.fechaRecepcion).getTime() : 0;
    const timeB = b.fechaRecepcion ? new Date(b.fechaRecepcion).getTime() : 0;
    if (timeA && timeB) {
      return timeB - timeA;
    }
    return 0;
  });
});

const formatShortDate = (dateVal?: string | Date) => {
  if (!dateVal) return '';
  return formatDateUI(dateVal);
};

const getTipoNovedadBadgeClass = (arch: Archivo) => {
  const codigo = arch.tipoNovedadCodigo?.toUpperCase() || '';
  if (codigo === 'ACTUALIZACION_CEDULA') {
    return 'bg-sky-500/10 text-sky-700 dark:text-sky-300 border-sky-500/20';
  }
  if (codigo === 'DISPONIBLE') {
    return 'bg-amber-500/10 text-amber-700 dark:text-amber-300 border-amber-500/20';
  }
  if (codigo === 'VIAJE') {
    return 'bg-indigo-500/10 text-indigo-700 dark:text-indigo-300 border-indigo-500/20';
  }
  return 'bg-info/10 text-info border-info/20';
};
</script>
