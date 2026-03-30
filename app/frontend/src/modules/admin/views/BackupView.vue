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
            <p class="text-sm text-text-muted mt-1">Crea un punto de restauración actual de la base de datos.</p>
          </div>
          <div class="flex flex-wrap gap-3">
            <button
              @click="triggerFileUpload"
              :disabled="isProcessing || !backendStatus.isConfigured"
              class="flex items-center justify-center gap-2 rounded-xl bg-surface border-2 border-primary/20 px-5 py-3 text-sm font-bold text-primary hover:bg-primary/5 active:scale-95 disabled:opacity-50 transition-all"
            >
              <RefreshIcon v-if="isUploading" class="w-5 h-5 animate-spin" />
              <CloudUploadIcon v-else class="w-5 h-5" />
              {{ isUploading ? 'Subiendo...' : 'Cargar copia externa (.zip)' }}
            </button>
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
          <!-- Input oculto para subir archivos -->
          <input
            type="file"
            ref="fileInput"
            class="hidden"
            accept=".zip"
            @change="handleFileUpload"
          />
        </div>
      </div>

      <!-- Card: Programación Automática -->
      <div class="relative bg-surface rounded-2xl shadow-sm border border-border overflow-hidden">
        <!-- Barra de acento izquierda -->
        <div
          class="absolute left-0 top-0 bottom-0 w-1 transition-all duration-500"
          :class="autoBackupEnabled ? 'bg-gradient-to-b from-primary via-primary/70 to-primary/30' : 'bg-border'"
        ></div>

        <div class="pl-8 pr-6 py-6 grid grid-cols-1 md:grid-cols-[1fr_auto_auto] gap-6 md:gap-8 items-center">
          <!-- Zona 1: Descripción -->
          <div>
            <div class="flex items-center gap-2.5 mb-2">
              <div
                class="p-2 rounded-xl transition-all duration-300"
                :class="autoBackupEnabled ? 'bg-primary/10 text-primary' : 'bg-surface-muted text-text-muted'"
              >
                <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              </div>
              <h2 class="text-base font-bold text-text">Respaldo Automático Diario</h2>
            </div>
            <p class="text-sm text-text-muted leading-relaxed">
              Genera un respaldo del módulo de <strong class="text-text font-semibold">Datos Generales</strong>
              todos los días a la hora indicada, de manera automática y sin intervención manual.
            </p>
          </div>

          <!-- Zona 2: Toggle con estado prominente -->
          <div class="flex flex-col items-center gap-2 border-l border-border pl-8">
            <label class="relative cursor-pointer">
              <input
                type="checkbox"
                class="sr-only peer"
                v-model="autoBackupEnabled"
                @change="saveAutoBackupConfig"
              />
              <!-- Toggle grande -->
              <div class="w-14 h-7 bg-border rounded-full peer peer-checked:bg-primary transition-all duration-300 shadow-inner after:content-[''] after:absolute after:top-[3px] after:left-[3px] after:bg-white after:rounded-full after:h-[22px] after:w-[22px] after:transition-all after:shadow-sm peer-checked:after:translate-x-7 peer-checked:shadow-primary/30 peer-checked:shadow-md"></div>
            </label>
            <span
              class="text-xs font-black uppercase tracking-widest transition-colors duration-300"
              :class="autoBackupEnabled ? 'text-primary' : 'text-text-muted'"
            >
              {{ autoBackupEnabled ? 'Activo' : 'Inactivo' }}
            </span>
          </div>

          <!-- Zona 3: Selector de hora -->
          <div
            class="flex flex-col items-center gap-2 border-l border-border pl-8 transition-opacity duration-300"
            :class="autoBackupEnabled ? 'opacity-100' : 'opacity-40'"
          >
            <div class="w-32">
              <TimePicker
                v-model="autoBackupHour"
                :disabled="!autoBackupEnabled"
                @update:modelValue="debouncedSaveAutoBackupConfig"
              />
            </div>
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Hora del respaldo</span>
          </div>
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
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>

        <div v-else-if="!backendStatus.isConfigured" class="p-12 text-center text-warning bg-warning/5 dark:bg-warning/10">
            <WarningIcon class="mx-auto w-12 h-12 mb-4 opacity-50" />
            <h4 class="font-bold text-lg mb-2">Sistema no Inicializado</h4>
            <p class="max-w-md mx-auto text-sm opacity-80">
                El motor de copias de seguridad requiere una configuración técnica adicional en el servidor para ser habilitado.
                Por motivos de seguridad, las funciones de gestión han sido suspendidas temporalmente.
            </p>
        </div>

        <div v-else-if="backups.length === 0" class="p-12 text-center text-text-muted">
            <InfoCircleIcon class="mx-auto w-12 h-12 mb-4 opacity-20" />
            <p>No se encontraron copias de seguridad guardadas.</p>
        </div>

        <table v-else class="w-full text-left border-collapse">
          <thead>
            <tr class="bg-surface-muted text-[11px] uppercase tracking-widest text-text-muted font-black">
              <th class="px-6 py-4">Archivo</th>
              <th class="px-6 py-4">Fecha</th>
              <th class="px-6 py-4">Contenido</th>
              <th class="px-6 py-4">Comentario</th>
              <th class="px-6 py-4 text-right">Tamaño</th>
              <th class="px-6 py-4 text-center">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-border">
            <tr v-for="bkp in backups" :key="bkp.filename" class="hover:bg-surface-muted transition-colors">
              <td class="px-6 py-4 font-mono text-sm text-text">{{ bkp.filename }}</td>
              <td class="px-6 py-4 text-sm text-text-muted">{{ formatDate(bkp.createdAt) }}</td>
              <td class="px-6 py-4">
                <div class="flex flex-wrap gap-1">
                  <span
                    v-for="s in (bkp.schemas || ['public'] as BackupSchema[])"
                    :key="s"
                    class="inline-flex items-center px-2 py-0.5 rounded-md text-[10px] font-bold uppercase tracking-wider"
                    :class="schemaTagClass(s)"
                  >{{ schemaLabel(s) }}</span>
                </div>
              </td>
              <td class="px-6 py-4 text-sm text-text-muted italic max-w-xs truncate" :title="bkp.comment">{{ bkp.comment || '-' }}</td>
              <td class="px-6 py-4 text-sm text-text-muted text-right">{{ formatSize(bkp.size) }}</td>
              <td class="px-6 py-4">
                <div class="flex justify-center gap-3">
                    <button
                        @click="handleDownload(bkp)"
                        class="p-2 text-primary bg-primary/5 border border-primary/10 hover:bg-primary/20 transition-colors rounded-lg"
                        title="Descargar"
                    >
                        <DownloadIcon class="w-5 h-5" />
                    </button>
                    <button
                        @click="confirmRestore(bkp)"
                        class="p-2 text-warning bg-warning/5 border border-warning/10 hover:bg-warning/10 transition-colors rounded-lg"
                        title="Restaurar"
                    >
                        <HistoryIcon class="w-5 h-5" />
                    </button>
                    <button
                        @click="confirmDelete(bkp)"
                        class="p-2 text-error bg-error/5 border border-error/10 hover:bg-error/10 transition-colors rounded-lg"
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
      title="Restauración de Datos"
      confirm-button-text="RESTAURAR AHORA"
      :phrases="restorePhrases"
      :loading="isRestoring"
      :confirm-disabled="restoreSchemas.length === 0"
      @close="closeRestoreModal"
      @confirm="handleRestore"
    >
      <template #warning>
          Este proceso es <strong>IRREVERSIBLE</strong>. Los esquemas seleccionados serán vaciados y reemplazados por los datos del archivo:
          <span class="font-mono font-bold">{{ selectedBackup?.filename }}</span>.
          Los esquemas <strong>no seleccionados no serán modificados</strong>.
      </template>
      <template #extra v-if="selectedBackup">
        <div class="mt-4 space-y-2">
          <p class="text-xs font-black uppercase tracking-widest text-text-muted">Esquemas a restaurar</p>
          <div class="space-y-2">
            <label
              v-for="s in (selectedBackup.schemas || ['public'] as BackupSchema[])"
              :key="s"
              class="flex items-center gap-3 p-3 rounded-xl border cursor-pointer transition-colors"
              :class="restoreSchemas.includes(s) ? 'border-primary/40 bg-primary/5' : 'border-border bg-surface-muted hover:border-border-muted'"
            >
              <input
                type="checkbox"
                :value="s"
                v-model="restoreSchemas"
                class="w-4 h-4 rounded border-border text-primary accent-primary"
              />
              <div>
                <span class="text-sm font-semibold text-text block">{{ schemaLabel(s) }}</span>
                <span class="text-xs text-text-muted">{{ schemaDescription(s) }}</span>
              </div>
            </label>
          </div>
        </div>
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
      <div class="mt-6 space-y-4">
        <!-- Comentario -->
        <div class="space-y-2">
          <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-text-muted ml-1">
            <ChatIcon class="w-3.5 h-3.5" />
            Comentario opcional
          </label>
          <textarea
            v-model="newBackupComment"
            rows="2"
            class="w-full px-4 py-3 rounded-2xl border-2 border-border bg-surface-muted focus:bg-surface focus:border-primary/50 focus:ring-4 focus:ring-primary/10 transition-all duration-300 outline-none text-sm placeholder:text-text-muted/40 resize-none"
            placeholder="Ej: Antes de grandes cambios en la base de datos..."
          ></textarea>
        </div>

        <!-- Selección de módulos a respaldar -->
        <div class="space-y-2">
          <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-text-muted ml-1">
            <BoxCubeIcon class="w-3.5 h-3.5" />
            Módulos a incluir en la copia
          </label>
          <div class="space-y-2">
            <label
              v-for="option in schemaOptions"
              :key="option.key"
              class="flex items-start gap-3 p-3 rounded-xl border cursor-pointer transition-colors"
              :class="selectedSchemas.includes(option.key) ? 'border-primary/40 bg-primary/5 dark:bg-primary/10' : 'border-border bg-surface-muted hover:border-border'"
            >
              <input
                type="checkbox"
                :value="option.key"
                v-model="selectedSchemas"
                :disabled="option.key === 'public'"
                class="mt-0.5 w-4 h-4 rounded border-border text-primary accent-primary disabled:opacity-60"
              />
              <div class="flex-1 min-w-0">
                <div class="flex items-center gap-2">
                  <span class="text-sm font-semibold text-text">{{ option.label }}</span>
                  <span v-if="option.key === 'public'" class="text-[10px] font-bold uppercase tracking-wider text-primary/70 bg-primary/10 px-1.5 py-0.5 rounded">Requerido</span>
                  <span v-if="option.key === 'datos_api'" class="text-[10px] font-bold uppercase tracking-wider text-warning bg-warning/10 px-1.5 py-0.5 rounded">Tamaño alto</span>
                </div>
                <span class="text-xs text-text-muted leading-snug block mt-0.5">{{ option.description }}</span>
              </div>
            </label>
          </div>
        </div>
      </div>
    </ConfirmationDialog>

    <!-- Overlay de Procesamiento -->
    <ProcessingOverlay
        :show="isCreating || isRestoring || isDownloading"
        :title="isCreating ? 'Generando Respaldo' : (isRestoring ? 'Restaurando Base de Datos' : 'Preparando Descarga')"
        :message="isCreating ? 'Por favor espera un momento...' : (isRestoring ? 'Este proceso es crítico, no cierres la ventana.' : 'Estamos preparando el archivo, esto puede demorar unos segundos...')"
    />

  </AdminDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import ProcessingOverlay from '@/components/common/ProcessingOverlay.vue';
import SecurityConfirmationDialog from '@/components/common/SecurityConfirmationDialog.vue';
import TimePicker from '@/components/common/TimePicker.vue';
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
    ChatIcon,
    DownloadIcon,
    CloudUploadIcon,
} from '@/icons';

// Ícono de reloj inline
const ClockIcon = {
    template: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>`
};

type BackupSchema = 'public' | 'audit' | 'datos_api';

interface SchemaOption {
    key: BackupSchema;
    label: string;
    description: string;
}

interface BackupFile {
    filename: string;
    size: number;
    createdAt: string;
    comment?: string;
    schemas?: BackupSchema[];
}

// --- Estado principal ---
const backups = ref<BackupFile[]>([]);
const isLoading = ref(false);
const isCreating = ref(false);
const isRestoring = ref(false);
const isProcessing = ref(false);
const isUploading = ref(false);
const isDownloading = ref(false);
const isCheckingStatus = ref(true);

// --- Estado: backup automático ---
const autoBackupEnabled = ref(false);
const autoBackupHour = ref('17:00');

const showRestoreModal = ref(false);
const showDeleteModal = ref(false);
const showCreateConfirmModal = ref(false);

const newBackupComment = ref('');
const selectedBackup = ref<BackupFile | null>(null);
const backendStatus = ref({ isConfigured: true, backupPath: '', schemaOptions: [] as SchemaOption[] });
const fileInput = ref<HTMLInputElement | null>(null);

// Schemas seleccionados para el nuevo backup (public siempre marcado)
const selectedSchemas = ref<BackupSchema[]>(['public']);
// Schemas seleccionados para restaurar
const restoreSchemas = ref<BackupSchema[]>(['public']);

// Opciones de schema cargadas desde el backend
const schemaOptions = ref<SchemaOption[]>([
    { key: 'public', label: 'Datos Generales', description: 'Mareas, buques, observadores y toda la información principal del sistema.' },
    { key: 'audit', label: 'Auditoría', description: 'Registro de cambios en la base de datos y eventos de navegación.' },
    { key: 'datos_api', label: 'Datos Históricos de API', description: 'Trayectorias de buques y zarpadas/arribos registradas desde APIs externas. Aumenta significativamente el tamaño del archivo.' },
]);

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
    'CARGAR COPIA EXTERNA',
];

// --- Helpers visuales ---
const schemaLabel = (key: string): string => {
    const found = schemaOptions.value.find(o => o.key === key);
    return found?.label ?? key;
};

const schemaDescription = (key: string): string => {
    const found = schemaOptions.value.find(o => o.key === key);
    return found?.description ?? '';
};

const schemaTagClass = (key: string): string => {
    const map: Record<string, string> = {
        public: 'bg-primary/10 text-primary dark:bg-primary/20',
        audit: 'bg-info/10 text-info dark:bg-info/20',
        datos_api: 'bg-warning/10 text-warning dark:bg-warning/20',
    };
    return map[key] ?? 'bg-surface-muted text-text-muted';
};

// --- API ---
const fetchStatus = async () => {
    isCheckingStatus.value = true;
    try {
        const { data } = await httpClient.get('/admin/backup/status');
        backendStatus.value = data;
        if (data.schemaOptions?.length) {
            schemaOptions.value = data.schemaOptions;
        }
    } catch (error) {
        console.error('Error al obtener estado del backup:', error);
    } finally {
        isCheckingStatus.value = false;
    }
};

const fetchAutoBackupConfig = async () => {
    try {
        const { data } = await httpClient.get('/admin/backup/auto-config', { skipToast: true } as any);
        autoBackupEnabled.value = data.enabled ?? false;
        autoBackupHour.value = data.hour ?? '17:00';
    } catch {
        // Silenciar: si el backend no tiene la config aún, usa defaults
    }
};

const saveAutoBackupConfig = async () => {
    try {
        await httpClient.put('/admin/backup/auto-config', {
            enabled: autoBackupEnabled.value,
            hour: autoBackupHour.value,
        }, { skipToast: true } as any);
        toast.success(autoBackupEnabled.value ? `Respaldo automático habilitado a las ${autoBackupHour.value}` : 'Respaldo automático deshabilitado');
    } catch {
        toast.error('No se pudo guardar la configuración del respaldo automático');
    }
};

// Debounce de 1s para el cambio de hora (evita múltiples llamadas mientras se escribe)
let autoSaveTimer: ReturnType<typeof setTimeout> | null = null;
const debouncedSaveAutoBackupConfig = () => {
    if (autoSaveTimer) clearTimeout(autoSaveTimer);
    autoSaveTimer = setTimeout(() => saveAutoBackupConfig(), 1000);
};

const fetchBackups = async () => {
    isLoading.value = true;
    try {
        const { data } = await httpClient.get('/admin/backup');
        backups.value = data;
    } catch (error) {
        toast.error('Error al obtener la lista de copias de seguridad');
    } finally {
        isLoading.value = false;
    }
};

const handleCreateBackup = async () => {
    showCreateConfirmModal.value = false;
    isCreating.value = true;
    isProcessing.value = true;
    try {
        // El endpoint responde de inmediato; el proceso corre en background.
        await httpClient.post('/admin/backup', {
            comment: newBackupComment.value,
            schemas: selectedSchemas.value,
        });
        toast.info('Copia de seguridad en proceso. La lista se actualizará cuando esté lista...');
        newBackupComment.value = '';

        // Polling: verificar cada 4s si apareció un nuevo backup
        const knownFilenames = new Set(backups.value.map(b => b.filename));
        let attempts = 0;
        const maxAttempts = 60; // 4 minutos máximo
        const poll = setInterval(async () => {
            attempts++;
            try {
                const { data } = await httpClient.get('/admin/backup');
                const newBackup = (data as BackupFile[]).find(b => !knownFilenames.has(b.filename));
                if (newBackup || attempts >= maxAttempts) {
                    clearInterval(poll);
                    backups.value = data;
                    isCreating.value = false;
                    isProcessing.value = false;
                    if (newBackup) {
                        toast.success(`Copia de seguridad "${newBackup.filename}" creada correctamente`);
                    } else {
                        toast.warning('El proceso tardó más de lo esperado. Verificá la lista manualmente.');
                    }
                }
            } catch (_e) {
                // El servidor puede estar ocupado; ignorar errores de polling
            }
        }, 4000);
    } catch (_error) {
        isCreating.value = false;
        isProcessing.value = false;
        // Notificación automática del httpClient
    }
};


const triggerFileUpload = () => {
    fileInput.value?.click();
};

const handleFileUpload = async (event: Event) => {
    const target = event.target as HTMLInputElement;
    if (!target.files?.length) return;

    const file = target.files[0];
    if (file.type !== 'application/zip' && !file.name.endsWith('.zip')) {
        toast.error('Por favor, seleccione un archivo .zip');
        return;
    }

    const formData = new FormData();
    formData.append('file', file);

    isUploading.value = true;
    isProcessing.value = true;
    try {
        const { data } = await httpClient.post('/admin/backup/upload', formData, {
            headers: { 'Content-Type': 'multipart/form-data' },
        });
        toast.success(data.message || 'Archivo subido correctamente');
        target.value = '';
        await fetchBackups();
        const newBkp = backups.value.find(b => b.filename === data.filename);
        if (newBkp) confirmRestore(newBkp);
    } catch (error: any) {
        console.error('Error al subir backup:', error);
    } finally {
        isUploading.value = false;
        isProcessing.value = false;
    }
};

const handleDownload = async (bkp: BackupFile) => {
    isDownloading.value = true;
    isProcessing.value = true;
    try {
        const response = await httpClient.get(`/admin/backup/download/${bkp.filename}`, {
            responseType: 'blob',
            timeout: 0,
        });
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', bkp.filename);
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
        toast.success('Descarga iniciada');
    } catch (error) {
        console.error('Error al descargar:', error);
        toast.error('No se pudo descargar el archivo');
    } finally {
        isDownloading.value = false;
        isProcessing.value = false;
    }
};

const confirmRestore = (bkp: BackupFile) => {
    selectedBackup.value = bkp;
    // Por defecto solo restaurar public
    restoreSchemas.value = ['public'];
    showRestoreModal.value = true;
};

const handleRestore = async (phrase: string) => {
    if (!selectedBackup.value) return;
    if (restoreSchemas.value.length === 0) {
        toast.error('Debe seleccionar al menos un módulo para restaurar');
        return;
    }

    isRestoring.value = true;
    isProcessing.value = true;
    try {
        await httpClient.post(`/admin/backup/restore/${selectedBackup.value.filename}`, {
            confirmationPhrase: phrase,
            schemas: restoreSchemas.value,
        }, { timeout: 300000 });
        toast.success(`Base de datos restaurada con éxito (${restoreSchemas.value.map(schemaLabel).join(', ')})`);
        showRestoreModal.value = false;
        setTimeout(() => location.reload(), 2000);
    } catch (_error) {
        // Notificación automática del httpClient
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
        minute: '2-digit',
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
    fetchAutoBackupConfig();
});
</script>
