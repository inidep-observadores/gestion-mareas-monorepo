<template>
  <BaseModal
    :show="show"
    title="Confirmar Envío de Informe"
    max-width="2xl"
    @close="emit('close')"
  >
    <div class="space-y-6">
      <!-- Email Header Simulation -->
      <div class="bg-surface-muted/50 rounded-xl border border-border overflow-hidden">
        <div class="px-4 py-3 border-b border-border bg-surface flex items-center gap-3">
          <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-primary">
            <MailIcon class="w-4 h-4" />
          </div>
          <div>
            <h4 class="text-[10px] font-black uppercase tracking-widest text-text-muted">Nuevo Mensaje</h4>
            <p class="text-xs font-bold text-text">Protocolización de Mareas</p>
          </div>
        </div>

        <div class="p-4 space-y-3">
          <!-- Para (Opcional mostrar, el usuario dijo que viene del env) -->
          <div class="flex items-start gap-4">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted w-12 pt-1 text-right">Para:</span>
            <div class="flex-1">
              <span class="px-2 py-1 bg-surface border border-border rounded text-[11px] font-bold text-text-muted italic">
                Destinatario configurado en el sistema
              </span>
            </div>
          </div>

          <!-- Asunto -->
          <div class="flex items-start gap-4">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted w-12 pt-1 text-right">Asunto:</span>
            <div class="flex-1">
              <p class="text-xs font-black text-text">Mareas enviadas a protocolizar</p>
            </div>
          </div>

          <!-- Cuerpo -->
          <div class="flex items-start gap-4">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted w-12 pt-1 text-right">Cuerpo:</span>
            <div class="flex-1 bg-surface border border-border rounded-lg p-4 min-h-[120px]">
              <p class="text-xs text-text mb-4">Se informa que las siguientes mareas han sido enviadas para protocolizar:</p>

              <table class="w-full text-xs border-collapse">
                <thead class="bg-surface-muted">
                  <tr>
                    <th class="px-3 py-2 text-left font-black uppercase tracking-tighter border border-border">Marea</th>
                    <th class="px-3 py-2 text-left font-black uppercase tracking-tighter border border-border">Buque</th>
                    <th class="px-3 py-2 text-left font-black uppercase tracking-tighter border border-border">Observador</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="marea in mareas" :key="marea.id">
                    <td class="px-3 py-2 border border-border font-mono font-bold">{{ formatMareaCode(marea) }}</td>
                    <td class="px-3 py-2 border border-border font-bold uppercase tracking-tight">{{ formatBuqueName(marea) }}</td>
                    <td class="px-3 py-2 border border-border">{{ formatObservadorName(marea) }}</td>
                  </tr>
                </tbody>
              </table>

              <!-- Notas previsualización -->
              <div v-if="notas.trim()" class="mt-6 pt-4 border-t border-border animate-in fade-in slide-in-from-top-2">
                <h5 class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-2">Notas o aclaraciones:</h5>
                <p class="text-xs text-text italic whitespace-pre-wrap">{{ notas }}</p>
              </div>

              <p class="text-xs text-text mt-4">Se adjuntan los documentos correspondientes.</p>
              
              <div class="mt-6 pt-4 border-t border-border">
                <p class="text-[10px] italic text-text-muted">
                  Enviado desde <strong class="font-black">SIGMA</strong> - Sistema Integral de Gestión de Mareas
                </p>
              </div>
            </div>
          </div>

          <!-- Adjuntos -->
          <div class="flex items-start gap-4">
            <span class="text-[10px] font-black uppercase tracking-widest text-text-muted w-12 pt-1 text-right">Adjuntos:</span>
            <div class="flex-1 flex flex-wrap gap-2">
              <div
                v-for="(file, mareaId) in files"
                :key="mareaId"
                class="flex items-center gap-2 px-3 py-1.5 bg-success/10 border border-success/20 rounded-lg animate-in zoom-in-95"
              >
                <PaperclipIcon class="w-3 h-3 text-success" />
                <span class="text-[10px] font-bold text-success truncate max-w-[200px]">{{ file.name }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Nuevos Campos: CCO y Notas -->
      <div class="grid gap-6 md:grid-cols-2">
        <!-- CCO -->
        <div class="space-y-2">
          <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex justify-between">
            CCO (Copia Oculta)
            <span v-if="ccoError" class="text-error normal-case font-bold">{{ ccoError }}</span>
          </label>
          <div class="relative group">
            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none text-text-muted group-focus-within:text-primary transition-colors">
              <MailIcon class="w-3.5 h-3.5" />
            </div>
            <input
              v-model="cco"
              type="text"
              placeholder="email1@ejemplo.com, email2@ejemplo.com"
              class="w-full pl-9 pr-4 py-2 bg-surface border border-border rounded-xl text-xs font-bold focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all placeholder:font-normal placeholder:text-text-muted/50"
              :class="{'border-error ring-error/10': ccoError}"
            />
          </div>
          <p class="text-[9px] text-text-muted italic">E-mails separados por comas para enviar copia oculta.</p>
        </div>

        <!-- Notas -->
        <div class="space-y-2">
          <label class="text-[10px] font-black uppercase tracking-widest text-text-muted">Notas o aclaraciones</label>
          <textarea
            v-model="notas"
            rows="2"
            placeholder="Texto adicional que se agregará antes del pie de página..."
            class="w-full px-4 py-2 bg-surface border border-border rounded-xl text-xs font-bold focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all placeholder:font-normal placeholder:text-text-muted/50 resize-none"
          ></textarea>
        </div>
      </div>

      <!-- Warning Note -->
      <div class="flex gap-3 p-4 bg-warning/5 border border-warning/20 rounded-xl">
        <div class="w-8 h-8 rounded-full bg-warning/10 flex items-center justify-center text-warning shrink-0">
          <InfoCircleIcon class="w-4 h-4" />
        </div>
        <div class="space-y-1">
          <h5 class="text-[10px] font-black uppercase tracking-widest text-warning">Aviso Importante</h5>
          <p class="text-xs text-text-muted leading-relaxed">
            Al confirmar, se enviará un correo electrónico formal con los archivos adjuntos. Esta acción queda registrada en la auditoría del sistema y modificará el estado de las mareas.
          </p>
        </div>
      </div>

      <!-- Footer Buttons -->
      <div class="flex justify-end gap-3 pt-4 border-t border-border">
        <button
          @click="emit('close')"
          class="px-6 py-2.5 rounded-xl text-[11px] font-black uppercase tracking-widest text-text-muted hover:bg-surface-muted transition-colors"
          :disabled="sending"
        >
          Cancelar
        </button>
        <button
          @click="handleConfirm"
          class="flex items-center gap-2 px-8 py-2.5 bg-primary text-primary-fg rounded-xl text-[11px] font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 transition-all disabled:opacity-50"
          :disabled="sending || !!ccoError"
        >
          <span v-if="sending" class="w-3 h-3 border-2 border-primary-fg border-t-transparent rounded-full animate-spin"></span>
          <SendIcon v-else class="w-3.5 h-3.5" />
          {{ sending ? 'Enviando...' : 'Confirmar y Enviar Email' }}
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import { MailIcon, PaperclipIcon, SendIcon, InfoCircleIcon } from '@/icons'

const props = defineProps<{
  show: boolean;
  mareas: any[];
  files: Record<string, File>;
  sending: boolean;
}>();

const emit = defineEmits(['close', 'confirm']);

const cco = ref('');
const notas = ref('');
const ccoError = ref('');

const validateEmails = (val: string) => {
  if (!val.trim()) {
    ccoError.value = '';
    return true;
  }
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  const emails = val.split(',').map(e => e.trim()).filter(e => !!e);
  
  const invalid = emails.find(e => !emailRegex.test(e));
  if (invalid) {
    ccoError.value = 'Formato inválido';
    return false;
  }
  ccoError.value = '';
  return true;
};

watch(cco, (val) => {
  validateEmails(val);
});

const handleConfirm = () => {
  if (!validateEmails(cco.value)) return;
  emit('confirm', {
    cco: cco.value,
    textoAdicional: notas.value
  });
};

const formatMareaCode = (marea: any) => {
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = marea.anio_marea || marea.anioMarea || 2026
  return `${nro}/${anio}`
}

const formatBuqueName = (marea: any) => {
  const nombre = marea.buque?.nombreBuque || marea.buque_nombre || 'N/D'
  const codigo = marea.buque?.codigoInterno
  return codigo ? `${nombre} (${codigo})` : nombre
}

const formatObservadorName = (marea: any) => {
  const obs = marea.observadorPrincipal
  if (!obs) return marea.observador || 'N/D'
  return `${obs.apellido}, ${obs.nombre} (${obs.codigoInterno})`
}
</script>
