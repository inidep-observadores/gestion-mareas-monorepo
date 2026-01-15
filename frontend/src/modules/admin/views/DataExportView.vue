<template>
  <AdminDashboardLayout
    title="Portabilidad de Datos"
    description="Exporta e importa datos en formato JSONL para migración y resguardo"
  >
    <div class="space-y-6">
      <!-- Card: Generar Exportación -->
      <div class="bg-surface rounded-2xl shadow-sm border border-border p-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <h2 class="text-xl font-bold text-text flex items-center gap-2">
              <ArchiveIcon class="w-6 h-6 text-primary" />
              Exportar Datos (JSONL)
            </h2>
            <p class="text-sm text-text-muted mt-1">Genera un archivo ZIP con todos los datos del sistema en formato portable (JSON Lines).</p>
          </div>
          <button
            @click="handleCreateExport"
            :disabled="isProcessing"
            class="flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-primary-fg shadow-lg shadow-primary/20 hover:bg-primary/90 active:scale-95 disabled:opacity-50 transition-all"
          >
            <DownloadIcon v-if="!isCreating" class="w-5 h-5" />
            <RefreshIcon v-else class="w-5 h-5 animate-spin" />
            {{ isCreating ? 'Generando...' : 'Generar Exportación' }}
          </button>
        </div>
      </div>

     <!-- Card: Importar Datos -->
      <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 p-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <h2 class="text-xl font-bold text-text flex items-center gap-2">
              <CloudUploadIcon class="w-6 h-6 text-info" />
              Importar Datos
            </h2>
            <p class="text-sm text-text-muted mt-1">Restaura datos desde un archivo ZIP generado previamente. <span class="text-warning font-bold">¡Cuidado! Esto podría sobrescribir datos.</span></p>
          </div>
          
           <!-- File Input Hidden -->
           <input 
              type="file" 
              ref="fileInput" 
              accept=".zip" 
              class="hidden" 
              @change="handleFileUpload"
           />
           
           <button
            @click="triggerFileInput"
            :disabled="isProcessing"
            class="flex items-center justify-center gap-2 rounded-xl bg-info px-5 py-3 text-sm font-bold text-info-fg shadow-lg shadow-info/20 hover:bg-info/90 active:scale-95 disabled:opacity-50 transition-all"
          >
            <CloudUploadIcon v-if="!isRestoring" class="w-5 h-5" />
            <RefreshIcon v-else class="w-5 h-5 animate-spin" />
            {{ isRestoring ? 'Procesando...' : 'Subir e Importar' }}
          </button>
        </div>
      </div>

      <!-- Lista de Exportaciones -->
      <div class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
        <div class="p-6 border-b border-border flex justify-between items-center">
            <h3 class="font-bold text-text flex items-center gap-2">
                <ListIcon class="w-5 h-5 text-text-muted" />
                Exportaciones Disponibles
            </h3>
            <button @click="fetchExports" title="Actualizar lista" class="p-2 text-text-muted hover:text-primary hover:rotate-180 transition-all duration-500 rounded-lg hover:bg-surface-muted">
                <RefreshIcon class="w-5 h-5" />
            </button>
        </div>

        <div v-if="isLoading" class="p-12 flex justify-center">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-green-600"></div>
        </div>

        <div v-else-if="files.length === 0" class="p-12 text-center text-gray-400">
            <InfoCircleIcon class="mx-auto w-12 h-12 mb-4 opacity-20" />
            <p>No se encontraron exportaciones guardadas.</p>
        </div>

        <table v-else class="w-full text-left border-collapse">
          <thead>
            <tr class="bg-surface-muted text-[11px] uppercase tracking-widest text-text-muted font-black">
              <th class="px-6 py-4">Archivo</th>
              <th class="px-6 py-4">Fecha</th>
              <th class="px-6 py-4">Comentario</th>
              <th class="px-6 py-4 text-right">Tamaño</th>
              <th class="px-6 py-4 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-for="file in files" :key="file.filename" class="hover:bg-surface-muted transition-colors">
              <td class="px-6 py-4 font-mono text-sm text-text">{{ file.filename }}</td>
              <td class="px-6 py-4 text-sm text-text-muted">{{ formatDate(file.createdAt) }}</td>
              <td class="px-6 py-4 text-sm text-text-muted italic max-w-xs truncate" :title="file.comment">{{ file.comment || '-' }}</td>
              <td class="px-6 py-4 text-sm text-text-muted text-right">{{ formatSize(file.size) }}</td>
              <td class="px-6 py-4 text-center">
                 <button 
                    @click="handleDownload(file.filename)"
                    class="inline-flex items-center justify-center p-2 text-green-600 bg-green-50 dark:bg-green-900/10 rounded-lg hover:bg-green-100 dark:hover:bg-green-900/20 transition-colors"
                    title="Descargar ZIP"
                >
                     <DownloadIcon class="w-5 h-5" />
                 </button>
                 <button 
                    @click="confirmDelete(file)"
                    class="inline-flex items-center justify-center p-2 text-red-600 bg-red-50 dark:bg-red-900/10 rounded-lg hover:bg-red-100 dark:hover:bg-red-900/20 transition-colors"
                    title="Eliminar Archivo"
                >
                    <TrashIcon class="w-5 h-5" />
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <SecurityConfirmationDialog
      :show="showImportModal"
      title="Confirmar Importación Masiva"
      confirm-button-text="IMPORTAR DATOS"
      :phrases="importPhrases"
      :loading="isRestoring"
      @close="showImportModal = false"
      @confirm="handleImportConfirm"
    >
        <template #warning>
            Estás a punto de importar datos desde el archivo <span class="font-mono font-bold">{{ selectedFile?.name }}</span>.
            <br/><br/>
            Este proceso <strong>sobrescribirá o fusionará</strong> información existente (Buques, Mareas, etc.).
            Asegúrese de que el archivo proviene de una fuente confiable. Los cambios son irreversibles.
        </template>
    </SecurityConfirmationDialog>

    <!-- Diálogo de Confirmación para Exportación -->
    <ConfirmationDialog
      :show="showExportModal"
      title="Generar Nueva Exportación"
      message="¿Está seguro de que desea generar una nueva exportación oficial? Este proceso incluirá todos los Buques, Mareas y transiciones registradas hasta el momento."
      confirm-text="GENERAR AHORA"
      confirm-button-class="bg-primary hover:bg-primary/90 shadow-primary/20"
      @close="showExportModal = false"
      @confirm="confirmCreateExport"
    >
      <div class="mt-6 space-y-2">
        <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-text-muted ml-1">
          <ChatIcon class="w-3.5 h-3.5" />
          Comentario descriptivo
        </label>
        <textarea 
          v-model="newExportComment" 
          rows="3" 
          class="w-full px-4 py-3 rounded-2xl border-2 border-border bg-surface-muted focus:bg-surface focus:border-primary/50 focus:ring-4 focus:ring-primary/10 transition-all duration-300 outline-none text-sm placeholder:text-text-muted/40 resize-none"
          placeholder="Ej: Exportación final temporada Centolla 2024..."
        ></textarea>
      </div>
    </ConfirmationDialog>

    <!-- Modal de Confirmación de Borrado -->
    <ConfirmationDialog
        :show="showDeleteModal"
        title="Eliminar Archivo de Exportación"
        :message="`¿Está seguro que desea eliminar el archivo ${selectedExport?.filename}? Esta acción no se puede deshacer.`"
        confirm-text="Eliminar"
        confirm-button-class="bg-error hover:bg-error/90 shadow-error/20"
        @close="showDeleteModal = false"
        @confirm="handleDelete"
    />

    <!-- Overlay de Procesamiento -->
    <ProcessingOverlay 
        :show="isCreating || isRestoring"
        :title="isCreating ? 'Generando Exportación' : 'Importando Datos'"
        :message="isCreating ? 'Esto puede tomar unos segundos...' : 'Procesando archivo y restaurando datos. Por favor espere.'"
    />

  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import ProcessingOverlay from '@/components/common/ProcessingOverlay.vue';
import SecurityConfirmationDialog from '@/components/common/SecurityConfirmationDialog.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import { toast } from 'vue-sonner';
import httpClient from '@/config/http/http.client';
import { 
    RefreshIcon, 
    CloudUploadIcon, 
    DownloadIcon,
    ArchiveIcon,
    ListIcon,
    InfoCircleIcon,
    TrashIcon,
    ChatIcon
} from '@/icons';

interface ExportFile {
  filename: string;
  size: number;
  createdAt: string;
  comment?: string;
}

const files = ref<ExportFile[]>([]);
const isLoading = ref(false);
const isCreating = ref(false);
const isRestoring = ref(false);
const isProcessing = ref(false);
const showExportModal = ref(false);
const showDeleteModal = ref(false);
const selectedExport = ref<ExportFile | null>(null);
const newExportComment = ref('');
const fileInput = ref<HTMLInputElement | null>(null);

const handleDownload = async (filename: string) => {
    try {
        const response = await httpClient.get(`/admin/data-export/${filename}`, {
            responseType: 'blob'
        });
        
        // Crear un link temporal para disparar la descarga
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', filename);
        document.body.appendChild(link);
        link.click();
        
        // Limpieza
        link.remove();
        window.URL.revokeObjectURL(url);
    } catch (error) {
        toast.error('Error al intentar descargar el archivo');
    }
};

const fetchExports = async () => {
    isLoading.value = true;
    try {
        const { data } = await httpClient.get('/admin/data-export');
        files.value = data;
    } catch (error) {
        toast.error('Error al obtener lista de exportaciones');
    } finally {
        isLoading.value = false;
    }
};

const handleCreateExport = () => {
    showExportModal.value = true;
};

const confirmCreateExport = async () => {
    showExportModal.value = false;
    isCreating.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post('/admin/data-export', {
            comment: newExportComment.value
        }, {
            timeout: 300000 // 5 minutos
        });
        toast.success('Exportación generada correctamente');
        newExportComment.value = '';
        fetchExports();
    } catch (error) {
        toast.error('Error al generar la exportación');
    } finally {
        isCreating.value = false;
        isProcessing.value = false;
    }
};

const showImportModal = ref(false);
const selectedFile = ref<File | null>(null);

const importPhrases = [
    'IMPORTAR DATOS AHORA',
    'SOBREESCRIBIR BASE DE DATOS',
    'CONFIRMO IMPORTACION MASIVA',
    'REEMPLAZAR DATOS EXISTENTES',
    'CARGAR RESPALDO EXTERNO'
];

const triggerFileInput = () => {
    fileInput.value?.click();
};

const handleFileUpload = (event: Event) => {
    const target = event.target as HTMLInputElement;
    if (!target.files || target.files.length === 0) return;
    
    selectedFile.value = target.files[0];
    showImportModal.value = true;
    
    // Reset input to allow re-selecting same file if cancelled
    target.value = ''; 
};

const handleImportConfirm = async () => {
    if (!selectedFile.value) return;

    showImportModal.value = false;
    isRestoring.value = true;
    isProcessing.value = true;
    
    const formData = new FormData();
    formData.append('file', selectedFile.value);
    
    try {
        await httpClient.post('/admin/data-export/import', formData, {
            headers: { 'Content-Type': 'multipart/form-data' },
            timeout: 600000 // 10 minutos para importaciones masivas
        });
        toast.success('Datos importados correctamente');
        // Reload to show changes? Or just finish.
    } catch (error: any) {
        const msg = error.response?.data?.message || 'Error en la importación';
        toast.error(msg);
    } finally {
        isRestoring.value = false;
        isProcessing.value = false;
        selectedFile.value = null;
    }
};

const confirmDelete = (file: ExportFile) => {
    selectedExport.value = file;
    showDeleteModal.value = true;
};

const handleDelete = async () => {
    if (!selectedExport.value) return;
    showDeleteModal.value = false;
    try {
        await httpClient.delete(`/admin/data-export/${selectedExport.value.filename}`);
        toast.success('Archivo de exportación eliminado');
        fetchExports();
    } catch (error) {
        toast.error('No se pudo eliminar el archivo');
    } finally {
        selectedExport.value = null;
    }
};

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString('es-AR', {
    day: '2-digit', month: '2-digit', year: '2-digit',
    hour: '2-digit', minute: '2-digit'
  });
};

const formatSize = (bytes: number) => {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
};

onMounted(() => {
    fetchExports();
});
</script>
