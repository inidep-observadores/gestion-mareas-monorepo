<template>
  <AdminDashboardLayout
    title="Copia de Seguridad"
    description="Gestiona las copias de seguridad del sistema y restaura datos históricos"
  >
    <div class="space-y-6">
      <!-- Card: Generar Backup -->
      <div class="bg-surface rounded-2xl shadow-sm border border-border p-6">
        <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
          <div>
            <h2 class="text-xl font-bold text-text flex items-center gap-2">
              <BoxCubeIcon class="w-6 h-6 text-primary" />
              Nueva Copia de Seguridad
            </h2>
            <p class="text-sm text-text-muted mt-1">Crea un punto de restauración actual de toda la base de datos.</p>
          </div>
          <button
            @click="showCreateConfirmModal = true"
            :disabled="isProcessing || !backendStatus.isConfigured"
            class="flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-primary-fg shadow-lg shadow-primary/20 hover:bg-primary/90 active:scale-95 disabled:opacity-50 transition-all"
          >
            <RefreshIcon v-if="isCreating" class="w-5 h-5 animate-spin" />
            <PlusIcon v-else class="w-5 h-5" />
            {{ isCreating ? 'Generando copia...' : 'Crear nueva copia de seguridad' }}
          </button>
        </div>
      </div>

      <!-- Lista de Backups -->
      <div class="bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
        <div class="p-6 border-b border-border flex justify-between items-center">
            <h3 class="font-bold text-text flex items-center gap-2">
                <ListIcon class="w-5 h-5 text-primary" />
                Copias Disponibles
            </h3>
            <button @click="fetchBackups" title="Actualizar lista" class="p-2 text-text-muted hover:text-primary hover:rotate-180 transition-all duration-500 rounded-lg hover:bg-surface-muted">
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
            <tr class="bg-surface-muted text-[11px] uppercase tracking-widest text-text-muted font-black">
              <th class="px-6 py-4">Archivo</th>
              <th class="px-6 py-4">Fecha</th>
              <th class="px-6 py-4">Comentario</th>
              <th class="px-6 py-4 text-right">Tamaño</th>
              <th class="px-6 py-4 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-for="bkp in backups" :key="bkp.filename" class="hover:bg-surface-muted transition-colors">
              <td class="px-6 py-4 font-mono text-sm text-text">{{ bkp.filename }}</td>
              <td class="px-6 py-4 text-sm text-text-muted">{{ formatDate(bkp.createdAt) }}</td>
              <td class="px-6 py-4 text-sm text-text-muted italic max-w-xs truncate" :title="bkp.comment">{{ bkp.comment || '-' }}</td>
              <td class="px-6 py-4 text-sm text-text-muted text-right">{{ formatSize(bkp.size) }}</td>
              <td class="px-6 py-4">
                <div class="flex justify-center gap-3">
                    <button 
                        @click="confirmRestore(bkp)"
                        class="p-2 text-warning bg-warning/10 rounded-lg hover:bg-warning/20 transition-colors"
                        title="Restaurar"
                    >
                        <HistoryIcon class="w-5 h-5" />
                    </button>
                    <button 
                        @click="confirmDelete(bkp)"
                        class="p-2 text-error bg-error/10 rounded-lg hover:bg-error/20 transition-colors"
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
    <SecurityConfirmationDialog
      :show="showRestoreModal"
      title="Restauración Crítica de Datos"
      confirm-button-text="RESTAURAR AHORA"
      :phrases="restorePhrases"
      :loading="isRestoring"
      @close="closeRestoreModal"
      @confirm="handleRestore"
    >
      <template #warning>
          Este proceso es **IRREVERSIBLE**. Al confirmar, la base de datos actual será borrada por completo y reemplazada por el archivo seleccionado: 
          <span class="font-mono font-bold">{{ selectedBackup?.filename }}</span>.
      </template>
    </SecurityConfirmationDialog>

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
        confirm-button-class="bg-primary hover:bg-primary/90 shadow-primary/20"
        @close="showCreateConfirmModal = false"
        @confirm="handleCreateBackup"
    >
      <div class="mt-6 space-y-2">
        <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-text-muted ml-1">
          <ChatIcon class="w-3.5 h-3.5" />
          Comentario opcional
        </label>
        <textarea 
          v-model="newBackupComment" 
          rows="3" 
          class="w-full px-4 py-3 rounded-2xl border-2 border-border bg-surface-muted focus:bg-surface focus:border-primary/50 focus:ring-4 focus:ring-primary/10 transition-all duration-300 outline-none text-sm placeholder:text-text-muted/40 resize-none"
          placeholder="Ej: Antes de grandes cambios en la base de datos..."
        ></textarea>
      </div>
    </ConfirmationDialog>

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
import SecurityConfirmationDialog from '@/components/common/SecurityConfirmationDialog.vue';
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
    ListIcon,
    ChatIcon
} from '@/icons';

interface BackupFile {
  filename: string;
  size: number;
  createdAt: string;
  comment?: string;
}

const backups = ref<BackupFile[]>([]);
const isLoading = ref(false);
const isCreating = ref(false);
const isRestoring = ref(false);
const isProcessing = ref(false);

const showRestoreModal = ref(false);
const showDeleteModal = ref(false);
const showCreateConfirmModal = ref(false);
const newBackupComment = ref('');
const selectedBackup = ref<BackupFile | null>(null);
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
        await httpClient.post('/admin/backup', {
            comment: newBackupComment.value
        });
        toast.success('Copia de seguridad creada correctamente');
        newBackupComment.value = '';
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
    showRestoreModal.value = true;
};

const handleRestore = async (phrase: string) => {
    if (!selectedBackup.value) return;
    
    isRestoring.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post(`/admin/backup/restore/${selectedBackup.value.filename}`, {
            confirmationPhrase: phrase
        }, {
            timeout: 300000 // 5 minutos para restauraciones grandes
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
