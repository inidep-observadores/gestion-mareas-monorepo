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
              <p class="text-xs font-black text-text">Notificación de mareas enviadas a protocolizar</p>
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
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="marea in mareas" :key="marea.id">
                    <td class="px-3 py-2 border border-border font-mono font-bold">{{ formatMareaCode(marea) }}</td>
                    <td class="px-3 py-2 border border-border">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</td>
                  </tr>
                </tbody>
              </table>

              <p class="text-xs text-text mt-4">Se adjuntan los documentos correspondientes.</p>
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
          @click="emit('confirm')"
          class="flex items-center gap-2 px-8 py-2.5 bg-primary text-primary-fg rounded-xl text-[11px] font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 transition-all disabled:opacity-50"
          :disabled="sending"
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
import BaseModal from '@/components/common/BaseModal.vue'
import { MailIcon, PaperclipIcon, SendIcon, InfoCircleIcon } from '@/icons'

const props = defineProps<{
  show: boolean;
  mareas: any[];
  files: Record<string, File>;
  sending: boolean;
}>();

const emit = defineEmits(['close', 'confirm']);

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}
</script>
