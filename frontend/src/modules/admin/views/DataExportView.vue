<template>
  <AdminDashboardLayout
    title="Portabilidad de Datos"
    description="Exporta e importa datos en formato JSONL para migración y resguardo"
  >
    <div class="space-y-6">
      <!-- Card: Generar Exportación -->
      <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 p-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <h2 class="text-xl font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
              <ArchiveIcon class="w-6 h-6 text-green-500" />
              Exportar Datos (JSONL)
            </h2>
            <p class="text-sm text-gray-500 mt-1">Genera un archivo ZIP con todos los datos del sistema en formato portable (JSON Lines).</p>
          </div>
          <button
            @click="handleCreateExport"
            :disabled="isProcessing"
            class="flex items-center justify-center gap-2 rounded-xl bg-green-600 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-green-500/20 hover:bg-green-700 active:scale-95 disabled:opacity-50 transition-all"
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
            <h2 class="text-xl font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
              <CloudUploadIcon class="w-6 h-6 text-blue-500" />
              Importar Datos
            </h2>
            <p class="text-sm text-gray-500 mt-1">Restaura datos desde un archivo ZIP generado previamente. <span class="text-amber-500 font-bold">¡Cuidado! Esto podría sobrescribir datos.</span></p>
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
            class="flex items-center justify-center gap-2 rounded-xl bg-blue-600 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-blue-500/20 hover:bg-blue-700 active:scale-95 disabled:opacity-50 transition-all"
          >
            <CloudUploadIcon v-if="!isRestoring" class="w-5 h-5" />
            <RefreshIcon v-else class="w-5 h-5 animate-spin" />
            {{ isRestoring ? 'Procesando...' : 'Subir e Importar' }}
          </button>
        </div>
      </div>

      <!-- Lista de Exportaciones -->
      <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <div class="p-6 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center">
            <h3 class="font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
                <ListIcon class="w-5 h-5 text-gray-500" />
                Exportaciones Disponibles
            </h3>
            <button @click="fetchExports" title="Actualizar lista" class="p-2 text-gray-400 hover:text-blue-500 hover:rotate-180 transition-all duration-500 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
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
            <tr class="bg-gray-50/50 dark:bg-gray-800/50 text-[11px] uppercase tracking-widest text-gray-400 font-black">
              <th class="px-6 py-4">Archivo</th>
              <th class="px-6 py-4">Fecha</th>
              <th class="px-6 py-4 text-right">Tamaño</th>
              <th class="px-6 py-4 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100 dark:divide-gray-800">
            <tr v-for="file in files" :key="file.filename" class="hover:bg-gray-50/30 dark:hover:bg-gray-800/20 transition-colors">
              <td class="px-6 py-4 font-mono text-sm text-gray-700 dark:text-gray-300">{{ file.filename }}</td>
              <td class="px-6 py-4 text-sm text-gray-500">{{ formatDate(file.createdAt) }}</td>
              <td class="px-6 py-4 text-sm text-gray-500 text-right">{{ formatSize(file.size) }}</td>
              <td class="px-6 py-4 text-center">
                 <button 
                    @click="handleDownload(file.filename)"
                    class="inline-flex items-center justify-center p-2 text-green-600 bg-green-50 dark:bg-green-900/10 rounded-lg hover:bg-green-100 dark:hover:bg-green-900/20 transition-colors"
                    title="Descargar ZIP"
                >
                    <DownloadIcon class="w-5 h-5" />
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
import { toast } from 'vue-sonner';
import httpClient from '@/config/http/http.client';
import { 
    RefreshIcon, 
    CloudUploadIcon, 
    DownloadIcon,
    ArchiveIcon,
    ListIcon,
    InfoCircleIcon
} from '@/icons';

interface ExportFile {
  filename: string;
  size: number;
  createdAt: string;
}

const files = ref<ExportFile[]>([]);
const isLoading = ref(false);
const isCreating = ref(false);
const isRestoring = ref(false);
const isProcessing = ref(false);
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

const handleCreateExport = async () => {
    isCreating.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post('/admin/data-export');
        toast.success('Exportación generada correctamente');
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
            headers: { 'Content-Type': 'multipart/form-data' }
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
