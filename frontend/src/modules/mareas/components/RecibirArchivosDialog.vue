<template>
  <div v-if="show" class="fixed inset-0 z-[100000] flex items-center justify-center p-4">
    <div class="absolute inset-0 bg-gray-950/40 backdrop-blur-sm" @click="handleCancel"></div>
    <div
      class="bg-white dark:bg-gray-900 rounded-3xl p-8 max-w-2xl w-full max-h-[90vh] overflow-y-auto shadow-2xl relative animate-in fade-in zoom-in-95 duration-300">

      <!-- Header -->
      <div class="border-b border-gray-100 dark:border-gray-800 pb-5 mb-6">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
          <h3 class="text-xl font-black text-gray-800 dark:text-white flex items-center gap-2">
            <div class="p-2 bg-brand-500/10 rounded-xl">
              <CloudUploadIcon class="w-5 h-5 text-brand-500" />
            </div>
            Recibir Archivos de Marea
          </h3>
          <div v-if="marea" class="flex items-center gap-2 px-3 py-1.5 bg-brand-500/5 dark:bg-brand-500/10 rounded-xl border border-brand-500/10">
            <span class="text-[10px] font-mono font-black text-brand-600 dark:text-brand-400 uppercase tracking-widest">
              {{ marea.id_marea }}
            </span>
            <span class="w-1 h-1 rounded-full bg-brand-200 dark:bg-brand-800"></span>
            <span class="text-[10px] font-bold text-gray-500 dark:text-gray-400 uppercase truncate max-w-[150px]">
              {{ marea.buque_nombre }}
            </span>
          </div>
        </div>
        <p class="text-gray-500 text-xs mt-3 font-medium leading-relaxed">
          Registre la fecha de recepción, adjunte los archivos digitales y verifique la cantidad de muestras de otolitos entregadas por el observador.
        </p>
      </div>

      <!-- Form Content -->
      <form novalidate @submit.prevent class="space-y-8">
        <!-- 1. Fecha de Recepción -->
        <div class="space-y-2">
          <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500">
            <HistoryIcon class="w-3.5 h-3.5" />
            Fecha de Recepción
          </label>
          <DatePicker
            ref="firstInput"
            v-model="form.fechaRecepcion"
            :error="validationErrors.fechaRecepcion"
            class="max-w-xs"
          />
          <p v-if="!validationErrors.fechaRecepcion && marea?.fecha_fin_observador" class="text-[10px] font-bold text-gray-400 dark:text-gray-600 uppercase tracking-tight">
            No puede ser anterior a la llegada ({{ formatDate(marea.fecha_fin_observador) }})
          </p>
        </div>

        <!-- 2. Archivos Digitales -->
        <div class="space-y-3">
          <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500">
            <DocsIcon class="w-3.5 h-3.5" />
            Archivos Digitales
          </label>

          <div
            @click="triggerFileInput"
            @dragover.prevent="isDragging = true"
            @dragleave.prevent="isDragging = false"
            @drop.prevent="handleDrop"
            class="group relative border-2 border-dashed rounded-2xl p-8 transition-all duration-300 text-center cursor-pointer"
            :class="[
              isDragging
                ? 'border-brand-500 bg-brand-500/5'
                : 'border-gray-100 dark:border-gray-800 hover:border-brand-500/30 hover:bg-gray-50/50 dark:hover:bg-gray-800/20'
            ]"
          >
            <input
              type="file"
              ref="fileInput"
              multiple
              class="hidden"
              @change="handleFileChange"
            />

            <div class="flex flex-col items-center">
              <div class="w-12 h-12 mb-4 bg-gray-50 dark:bg-gray-800 rounded-full flex items-center justify-center text-gray-400 group-hover:text-brand-500 transition-colors">
                <PlusIcon class="w-6 h-6" />
              </div>
              <p class="text-sm font-bold text-gray-700 dark:text-gray-300">Haga clic o arrastre archivos aquí</p>
              <p class="text-[10px] text-gray-400 mt-1 font-medium italic">Formatos permitidos: {{ ALLOWED_EXT_STRING }}</p>
            </div>
          </div>

          <!-- File List -->
          <TransitionGroup
            v-if="form.files.length"
            name="list"
            tag="div"
            class="grid grid-cols-1 sm:grid-cols-2 gap-3"
          >
            <div
              v-for="(file, index) in form.files"
              :key="file.name + index"
              class="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-800/40 rounded-xl border border-gray-100 dark:border-gray-800 group"
            >
              <div class="flex items-center gap-3 overflow-hidden">
                <div class="p-2 bg-white dark:bg-gray-950 rounded-lg shadow-sm">
                   <DocsIcon class="w-3.5 h-3.5 text-gray-400" />
                </div>
                <div class="overflow-hidden">
                  <p class="text-[11px] font-bold text-gray-700 dark:text-gray-200 truncate">{{ file.name }}</p>
                  <p class="text-[9px] text-gray-400 font-mono">{{ formatFileSize(file.size) }}</p>
                </div>
              </div>
              <button
                @click="removeFile(index)"
                class="p-1.5 text-gray-300 hover:text-error-500 hover:bg-error-50 dark:hover:bg-error-500/10 rounded-lg transition-all"
              >
                <TrashIcon class="w-3.5 h-3.5" />
              </button>
            </div>
          </TransitionGroup>
          <p v-if="validationErrors.files" class="text-[10px] text-red-500 font-bold uppercase mt-1 animate-in fade-in slide-in-from-top-1 duration-200">
            {{ validationErrors.files }}
          </p>
        </div>

        <!-- 3. Muestras de Otolitos -->
        <div class="p-6 bg-gray-50/50 dark:bg-gray-900/40 rounded-2xl border border-gray-100 dark:border-gray-800 border-l-4 border-l-brand-500 space-y-4">
          <div class="flex items-center justify-between">
            <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-gray-500 dark:text-gray-400">
              <SearchIcon class="w-3.5 h-3.5" />
              Cantidad de Otolitos
            </label>
            <button
              v-if="form.otolitos !== null"
              @click="form.otolitos = null"
              class="text-[10px] font-black text-brand-500 hover:text-brand-600 uppercase tracking-widest px-2 py-1 hover:bg-brand-50 dark:hover:bg-brand-500/10 rounded-lg transition-all"
            >
              Limpiar campo
            </button>
          </div>

          <div class="relative max-w-[140px]">
            <input
              v-model.number="form.otolitos"
              type="number"
              min="1"
              max="30"
              placeholder="Ej: 12"
              class="w-full px-4 py-3 bg-white dark:bg-gray-950 border border-gray-100 dark:border-gray-800 rounded-xl text-sm font-bold text-gray-800 dark:text-gray-100 outline-none focus:border-brand-500 focus:ring-4 focus:ring-brand-500/10 transition-all placeholder:text-gray-300"
              :class="{ 'border-error-500 ring-4 ring-error-500/10': validationErrors.otolitos }"
            />
          </div>
          <p v-if="validationErrors.otolitos" class="text-[10px] text-red-500 font-bold uppercase mt-1 animate-in fade-in slide-in-from-top-1 duration-200">
             {{ validationErrors.otolitos }}
          </p>
          <p v-else class="text-[10px] text-gray-500 dark:text-gray-500 font-medium italic">
            Ingrese un valor entre 1 y 30 según las muestras físicas recibidas. Deje vacío si no se entregaron.
          </p>
        </div>

        <!-- 4. Comentarios Adicionales -->
        <div class="space-y-3">
          <label class="flex items-center gap-2 text-xs font-black uppercase tracking-widest text-gray-400 dark:text-gray-500">
            <ChatIcon class="w-3.5 h-3.5" />
            Comentarios sobre la recepción
          </label>
          <textarea
            v-model="form.comentarios"
            rows="3"
            placeholder="Ingrese observaciones adicionales si es necesario..."
            class="w-full px-4 py-3 bg-gray-50 dark:bg-gray-900 border border-gray-100 dark:border-gray-800 rounded-2xl text-sm text-gray-800 dark:text-white outline-none focus:border-brand-500 transition-all resize-none placeholder:text-gray-400"
          ></textarea>
        </div>
      </form>

      <!-- Footer Actions -->
      <div class="mt-10 grid grid-cols-2 gap-4">
        <button
          @click="handleCancel"
          class="px-6 py-4 bg-gray-100 dark:bg-gray-800 hover:bg-gray-200 dark:hover:bg-gray-700 text-gray-600 dark:text-gray-300 rounded-2xl text-xs font-black uppercase tracking-[0.1em] transition-all active:scale-[0.98]"
        >
          Cancelar
        </button>
        <button
          @click="handleConfirm"
          :disabled="!isValid"
          class="px-6 py-4 bg-brand-500 hover:bg-brand-600 text-white rounded-2xl text-xs font-black uppercase tracking-[0.1em] shadow-xl shadow-brand-500/20 transition-all disabled:opacity-30 disabled:cursor-not-allowed active:scale-[0.98] flex items-center justify-center gap-2"
        >
          <CheckIcon class="w-4 h-4" />
          Confirmar Recepción
        </button>
      </div>

    </div>

    <!-- Confirmation Overlay -->
    <ConfirmationDialog
        :show="showConfirmation"
        :title="confirmationTitle"
        :message="confirmationMessage"
        :confirmText="confirmationConfirmText"
        @close="showConfirmation = false"
        @confirm="executeConfirmation"
        :isSidebarAware="false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, nextTick } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import {
  CloudUploadIcon,
  PlusIcon,
  DocsIcon,
  TrashIcon,
  HistoryIcon,
  SearchIcon,
  CheckIcon,
  ChatIcon
} from '@/icons';

const props = defineProps<{
  show: boolean;
  marea: any;
}>();

const emit = defineEmits(['close', 'confirm']);

// Configuration Enum
const ALLOWED_EXTENSIONS = ['dbf', 'doc', 'docx', 'xls', 'xlsx', 'pdf'];
const ALLOWED_EXT_STRING = ALLOWED_EXTENSIONS.map(e => `.${e}`).join(', ');

// Form State
const form = ref({
  fechaRecepcion: new Date().toISOString(),
  files: [] as File[],
  otolitos: null as number | null,
  comentarios: ''
});

const isDragging = ref(false);
const fileInput = ref<HTMLInputElement | null>(null);
const firstInput = ref<any>(null);
const validationErrors = ref<Record<string, string>>({});

// Confirmation State
const showConfirmation = ref(false);
const confirmationAction = ref<'SAVE' | 'CANCEL' | null>(null);
const confirmationTitle = ref('');
const confirmationMessage = ref('');
const confirmationConfirmText = ref('Confirmar');

// Reset form on show
watch(() => props.show, (val) => {
  if (val) {
    form.value = {
      fechaRecepcion: new Date().toISOString(),
      files: [],
      otolitos: null,
      comentarios: ''
    };
    validationErrors.value = {};

    nextTick(() => {
      firstInput.value?.focus();
    });
  }
});

// File Handlers
function triggerFileInput() {
  fileInput.value?.click();
}

function handleFileChange(event: Event) {
  const target = event.target as HTMLInputElement;
  if (target.files) {
    addFiles(Array.from(target.files));
  }
}

function handleDrop(event: DragEvent) {
  isDragging.value = false;
  if (event.dataTransfer?.files) {
    addFiles(Array.from(event.dataTransfer.files));
  }
}

function addFiles(newFiles: File[]) {
  const validFiles = newFiles.filter(file => {
    const ext = file.name.split('.').pop()?.toLowerCase();
    return ext && ALLOWED_EXTENSIONS.includes(ext);
  });

  if (validFiles.length < newFiles.length) {
    validationErrors.value.files = 'Algunos archivos fueron ignorados por tener una extensión no permitida.';
    setTimeout(() => delete validationErrors.value.files, 5000);
  }

  form.value.files = [...form.value.files, ...validFiles];
}

function removeFile(index: number) {
  form.value.files.splice(index, 1);
}

function formatFileSize(bytes: number) {
  if (bytes === 0) return '0 B';
  const k = 1024;
  const sizes = ['B', 'KB', 'MB', 'GB'];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

// Global Validation
const isValid = computed(() => {
  validationErrors.value = {};
  let valid = true;

  // 1. Validar Fecha
  if (!form.value.fechaRecepcion) {
    valid = false;
  } else {
    const recv = new Date(form.value.fechaRecepcion);
    const today = new Date();
    today.setHours(23, 59, 59, 999);

    if (recv > today) {
      validationErrors.value.fechaRecepcion = 'La fecha no puede ser futura';
      valid = false;
    }

    if (props.marea?.fecha_fin_observador) {
      const arrived = new Date(props.marea.fecha_fin_observador);
      if (recv < arrived) {
        validationErrors.value.fechaRecepcion = 'No puede ser anterior a la finalización de marea (' + formatDate(props.marea.fecha_fin_observador) + ')';
        valid = false;
      }
    }
  }

  // 2. Validar Otolitos (1-30 o nulo)
  if (form.value.otolitos !== null) {
    if (form.value.otolitos < 1 || form.value.otolitos > 30) {
      validationErrors.value.otolitos = 'La cantidad de otolitos debe estar entre 1 y 30';
      valid = false;
    }
  }

  // 3. Archivos (mínimo uno para este paso operativo, según requerimiento habitual)
  if (form.value.files.length === 0) {
    // validationErrors.value.files = 'Debe adjuntar al menos un archivo digital';
    // valid = false; // El requerimiento no decía que fuera obligatorio, pero usualmente lo es.
    // Mantendremos flexible pero daremos feedback si es nulo.
  }

  return valid;
});

// Presentation formatting
function formatDate(dateStr?: string) {
  if (!dateStr) return 'N/D';
  return new Date(dateStr).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: 'long',
    year: 'numeric'
  });
}

// Handlers
function handleCancel() {
  confirmationAction.value = 'CANCEL';
  confirmationTitle.value = '¿Descartar cambios?';
  confirmationMessage.value = 'Se perderá la información cargada en el formulario de recepción.';
  confirmationConfirmText.value = 'Sí, descartar';
  showConfirmation.value = true;
}

function handleConfirm() {
  if (isValid.value) {
    confirmationAction.value = 'SAVE';
    confirmationTitle.value = '¿Confirmar recepción de datos?';
    confirmationMessage.value = 'Se registrará el arribo y los archivos adjuntos. Esta acción es irreversible y cambiará el estado de la marea.';
    confirmationConfirmText.value = 'Sí, confirmar';
    showConfirmation.value = true;
  }
}

function executeConfirmation() {
  showConfirmation.value = false;
  if (confirmationAction.value === 'SAVE') {
    emit('confirm', {
      fechaRecepcion: form.value.fechaRecepcion,
      cantidadOtolitos: form.value.otolitos,
      comentarios: form.value.comentarios,
      // Los archivos se mockean por ahora como nombres para el payload
      archivosSnapshot: form.value.files.map(f => ({ name: f.name, size: f.size }))
    });
  } else {
    emit('close');
  }
}
</script>

<style scoped>
.list-enter-active,
.list-leave-active {
  transition: all 0.3s ease;
}
.list-enter-from,
.list-leave-to {
  opacity: 0;
  transform: translateX(-10px);
}
</style>
