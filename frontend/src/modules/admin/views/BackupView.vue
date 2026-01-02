<template>
  <AdminDashboardLayout
    title="Copia de Seguridad"
    description="Gestiona las copias de seguridad del sistema y restaura datos históricos"
  >
    <div class="space-y-6">
      <!-- Card: Generar Backup -->
      <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 p-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <h2 class="text-xl font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
              <BoxCubeIcon class="w-6 h-6 text-blue-500" />
              Nueva Copia de Seguridad
            </h2>
            <p class="text-sm text-gray-500 mt-1">Crea un punto de restauración actual de toda la base de datos.</p>
          </div>
          <button
            @click="showCreateConfirmModal = true"
            :disabled="isProcessing || !backendStatus.isConfigured"
            class="flex items-center justify-center gap-2 rounded-xl bg-brand-500 px-5 py-3 text-sm font-bold text-white shadow-lg shadow-brand-500/20 hover:bg-brand-600 active:scale-95 disabled:opacity-50 transition-all"
          >
            <RefreshIcon v-if="isCreating" class="w-5 h-5 animate-spin" />
            <PlusIcon v-else class="w-5 h-5" />
            {{ isCreating ? 'Generando copia...' : 'Crear nueva copia de seguridad' }}
          </button>
        </div>
      </div>

      <!-- Lista de Backups -->
      <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-sm border border-gray-200 dark:border-gray-800 overflow-hidden">
        <div class="p-6 border-b border-gray-100 dark:border-gray-800 flex justify-between items-center">
            <h3 class="font-bold text-gray-900 dark:text-gray-100 flex items-center gap-2">
                <ListIcon class="w-5 h-5 text-blue-500" />
                Copias Disponibles
            </h3>
            <button @click="fetchBackups" title="Actualizar lista" class="p-2 text-gray-400 hover:text-blue-500 hover:rotate-180 transition-all duration-500 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800">
                <RefreshIcon class="w-5 h-5" />
            </button>
        </div>

        <div v-if="isLoading || isCheckingStatus" class="p-12 flex justify-center">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
        </div>

        <div v-else-if="!backendStatus.isConfigured" class="p-12 text-center text-amber-600 bg-amber-50/50 dark:bg-amber-950/20">
            <WarningIcon class="mx-auto w-12 h-12 mb-4 opacity-50" />
            <h4 class="font-bold text-lg mb-2">Sistema no Inicializado</h4>
            <p class="max-w-md mx-auto text-sm opacity-80">
                El motor de copias de seguridad requiere una configuración técnica adicional en el servidor para ser habilitado. 
                Por motivos de seguridad, las funciones de gestión han sido suspendidas temporalmente.
            </p>
        </div>

        <div v-else-if="backups.length === 0" class="p-12 text-center text-gray-400">
            <InfoCircleIcon class="mx-auto w-12 h-12 mb-4 opacity-20" />
            <p>No se encontraron copias de seguridad guardadas.</p>
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
            <tr v-for="bkp in backups" :key="bkp.filename" class="hover:bg-gray-50/30 dark:hover:bg-gray-800/20 transition-colors">
              <td class="px-6 py-4 font-mono text-sm text-gray-700 dark:text-gray-300">{{ bkp.filename }}</td>
              <td class="px-6 py-4 text-sm text-gray-500">{{ formatDate(bkp.createdAt) }}</td>
              <td class="px-6 py-4 text-sm text-gray-500 text-right">{{ formatSize(bkp.size) }}</td>
              <td class="px-6 py-4">
                <div class="flex justify-center gap-3">
                    <button 
                        @click="confirmRestore(bkp)"
                        class="p-2 text-amber-600 bg-amber-50 dark:bg-amber-900/10 rounded-lg hover:bg-amber-100 dark:hover:bg-amber-900/20 transition-colors"
                        title="Restaurar"
                    >
                        <HistoryIcon class="w-5 h-5" />
                    </button>
                    <button 
                        @click="confirmDelete(bkp)"
                        class="p-2 text-red-600 bg-red-50 dark:bg-red-900/10 rounded-lg hover:bg-red-100 dark:hover:bg-red-900/20 transition-colors"
                        title="Eliminar"
                    >
                        <TrashIcon class="w-5 h-5" />
                    </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Modal de Restauración (Crítico) -->
    <BaseModal 
      :show="showRestoreModal" 
      title="Restauración Crítica de Datos"
      variant="danger"
      @close="closeRestoreModal"
    >
      <div class="p-6">
        <div class="bg-red-50 dark:bg-red-950/30 p-4 rounded-xl border border-red-100 dark:border-red-900/50 mb-6">
            <div class="flex gap-3 text-red-800 dark:text-red-400">
                <WarningIcon class="w-6 h-6 flex-shrink-0" />
                <div>
                    <h4 class="font-bold underline">¡ADVERTENCIA DE SEGURIDAD!</h4>
                    <p class="text-xs mt-1 leading-relaxed">
                        Este proceso es **IRREVERSIBLE**. Al confirmar, la base de datos actual será borrada por completo y reemplazada por el archivo seleccionado: 
                        <span class="font-mono font-bold">{{ selectedBackup?.filename }}</span>.
                    </p>
                </div>
            </div>
        </div>

        <div class="space-y-4">
            <p class="text-sm text-gray-600 dark:text-gray-400">
                Para proceder, escriba la siguiente frase exactamente como aparece:
            </p>
            <div class="p-4 bg-gray-50 dark:bg-gray-950/40 border border-gray-200 dark:border-gray-800 rounded-xl text-center font-black tracking-widest text-gray-800 dark:text-brand-400 select-none shadow-inner">
                {{ currentPhrase }}
            </div>
            
            <div>
                <input 
                    type="text" 
                    v-model="confirmationPhrase"
                    placeholder="Escriba la frase de confirmación aquí..."
                    class="w-full px-4 py-3 rounded-xl border-2 border-gray-100 dark:border-gray-900 bg-white dark:bg-gray-950/20 focus:border-red-500 focus:ring-0 transition-all text-center font-bold text-gray-900 dark:text-white"
                    @paste.prevent
                >
                <p class="text-[10px] text-gray-500 mt-2 text-center italic">
                    Sin avisos visuales de corrección. Asegúrese de escribir cada letra correctamente.
                </p>
            </div>

            <div class="flex gap-4 pt-4">
                <button @click="closeRestoreModal" class="flex-1 h-12 rounded-xl border border-gray-200 dark:border-gray-700 text-gray-500 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-gray-800 font-bold transition-all active:scale-95">
                    Cancelar
                </button>
                <button 
                    @click="handleRestore" 
                    :disabled="isProcessing"
                    class="flex-[1.5] h-12 rounded-xl bg-gradient-to-r from-red-600 to-red-500 hover:from-red-700 hover:to-red-600 active:scale-95 disabled:opacity-50 text-white font-bold flex items-center justify-center gap-2 transition-all shadow-lg shadow-red-500/25"
                >
                    <RefreshIcon v-if="isRestoring" class="w-5 h-5 animate-spin" />
                    <HistoryIcon v-else class="w-5 h-5" />
                    RESTAURAR AHORA
                </button>
            </div>
        </div>
      </div>
    </BaseModal>

    <!-- Modal de Confirmación de Borrado -->
    <ConfirmationDialog
        :show="showDeleteModal"
        title="Eliminar Copia de Seguridad"
        :message="`¿Está seguro que desea eliminar el archivo ${selectedBackup?.filename}? Esta acción no se puede deshacer.`"
        confirm-text="Eliminar"
        variant="danger"
        @close="showDeleteModal = false"
        @confirm="handleDelete"
    />

    <!-- Modal de Confirmación de Creación -->
    <ConfirmationDialog
        :show="showCreateConfirmModal"
        title="Crear Nueva Copia"
        message="¿Desea iniciar un proceso de respaldo de la base de datos ahora? El proceso puede demorar unos segundos dependiendo del volumen de datos."
        confirm-text="Iniciar Respaldo"
        confirm-button-class="bg-brand-500 hover:bg-brand-600 shadow-brand-500/20"
        @close="showCreateConfirmModal = false"
        @confirm="handleCreateBackup"
    />

    <!-- Overlay de Procesamiento (Backup o Restauración en curso) -->
    <ProcessingOverlay 
        :show="isCreating || isRestoring"
        :title="isCreating ? 'Generando Respaldo' : 'Restaurando Base de Datos'"
        :message="isCreating ? 'Por favor espera un momento...' : 'Este proceso es crítico, no cierres la ventana.'"
    />

  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import BaseModal from '@/components/common/BaseModal.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import ProcessingOverlay from '@/components/common/ProcessingOverlay.vue';
import { toast } from 'vue-sonner';
import httpClient from '@/config/http/http.client';
import { 
    RefreshIcon, 
    TrashIcon, 
    HistoryIcon, 
    PlusIcon,
    WarningIcon, 
    InfoCircleIcon,
    BoxCubeIcon,
    ListIcon
} from '@/icons';

interface BackupFile {
  filename: string;
  size: number;
  createdAt: string;
}

const backups = ref<BackupFile[]>([]);
const isLoading = ref(false);
const isCreating = ref(false);
const isRestoring = ref(false);
const isProcessing = ref(false);

const showRestoreModal = ref(false);
const showDeleteModal = ref(false);
const showCreateConfirmModal = ref(false);
const selectedBackup = ref<BackupFile | null>(null);
const confirmationPhrase = ref('');
const currentPhrase = ref('');
const backendStatus = ref({ isConfigured: true, backupPath: '' });

const restorePhrases = [
    'RESTAURAR BASE DE DATOS',
    'SOBREESCRIBIR DATOS ACTUALES',
    'ELIMINAR Y REEMPLAZAR TODO',
    'CONFIRMO SOBREESCRITURA TOTAL',
    'REEMPLAZAR BASE DE DATOS',
    'PERDER DATOS ACTUALES',
    'VOLVER A PUNTO ANTERIOR',
    'REINSTALAR COPIA SEGURIDAD',
    'BORRADO TOTAL Y RESTAURACION',
    'CARGAR COPIA EXTERNA'
];
const isCheckingStatus = ref(true);

const fetchStatus = async () => {
    isCheckingStatus.value = true;
    try {
        const { data } = await httpClient.get('/admin/backup/status');
        backendStatus.value = data;
    } catch (error) {
        console.error('Error fetching backup status:', error);
    } finally {
        isCheckingStatus.value = false;
    }
};

const fetchBackups = async () => {
    isLoading.value = true;
    try {
        const { data } = await httpClient.get('/admin/backup');
        backups.value = data;
    } catch (error) {
        toast.error('Error al obtener la lista de backups');
    } finally {
        isLoading.value = false;
    }
};

const handleCreateBackup = async () => {
    showCreateConfirmModal.value = false;
    isCreating.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post('/admin/backup');
        toast.success('Copia de seguridad creada correctamente');
        fetchBackups();
    } catch (error) {
        toast.error('Falló la creación de la copia de seguridad');
    } finally {
        isCreating.value = false;
        isProcessing.value = false;
    }
};

const confirmRestore = (bkp: BackupFile) => {
    selectedBackup.value = bkp;
    confirmationPhrase.value = '';
    // Seleccionar frase aleatoria
    const randomIndex = Math.floor(Math.random() * restorePhrases.length);
    currentPhrase.value = restorePhrases[randomIndex];
    showRestoreModal.value = true;
};

const handleRestore = async () => {
    if (!selectedBackup.value) return;
    
    isRestoring.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post(`/admin/backup/restore/${selectedBackup.value.filename}`, {
            confirmationPhrase: confirmationPhrase.value
        });
        toast.success('Base de datos restaurada con éxito');
        showRestoreModal.value = false;
        // Forzar recarga completa ya que los datos cambiaron
        setTimeout(() => location.reload(), 2000);
    } catch (error: any) {
        const msg = error.response?.data?.message || 'Error durante la restauración';
        toast.error(msg);
    } finally {
        isRestoring.value = false;
        isProcessing.value = false;
    }
};

const confirmDelete = (bkp: BackupFile) => {
    selectedBackup.value = bkp;
    showDeleteModal.value = true;
};

const handleDelete = async () => {
    if (!selectedBackup.value) return;
    showDeleteModal.value = false;
    try {
        await httpClient.delete(`/admin/backup/${selectedBackup.value.filename}`);
        toast.success('Archivo eliminado');
        fetchBackups();
    } catch (error) {
        toast.error('No se pudo eliminar el archivo');
    }
};

const closeRestoreModal = () => {
    if (isRestoring.value) return;
    showRestoreModal.value = false;
};

const formatDate = (dateStr: string) => {
  return new Date(dateStr).toLocaleString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
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
    fetchStatus();
    fetchBackups();
});
</script>
