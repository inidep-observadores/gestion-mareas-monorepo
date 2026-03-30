<template>
  <BaseModal 
    :show="show" 
    title="Confirmar Registro Externo" 
    max-width="lg"
    @close="emit('close')"
  >
    <div class="space-y-6">
      <div class="flex items-center gap-4 p-4 bg-primary/5 border border-primary/20 rounded-2xl">
        <div class="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center text-primary shrink-0">
          <BoxCubeIcon class="w-6 h-6" />
        </div>
        <div>
          <h4 class="text-sm font-black text-text uppercase tracking-tight">Registro de Canal Externo</h4>
          <p class="text-xs text-text-muted mt-0.5">Se marcarán las mareas seleccionadas como procesadas fuera del sistema.</p>
        </div>
      </div>

      <div class="space-y-4">
        <p class="text-xs text-text font-bold">Resumen de mareas a procesar:</p>
        <div class="max-h-40 overflow-y-auto space-y-2 pr-2">
          <div 
            v-for="marea in mareas" 
            :key="marea.id"
            class="flex items-center justify-between p-3 bg-surface-muted rounded-xl border border-border"
          >
            <div class="flex items-center gap-3">
              <span class="text-[10px] font-mono font-black border border-border bg-surface px-2 py-0.5 rounded shadow-sm">
                {{ formatMareaCode(marea) }}
              </span>
              <span class="text-[11px] font-bold text-text truncate max-w-[150px]">
                {{ marea.buque?.nombreBuque || marea.buque_nombre }}
              </span>
            </div>
            <div class="flex items-center gap-1.5 text-text-muted">
              <CalenderIcon class="w-3 h-3" />
              <span class="text-[10px] font-black">{{ formatDate(fechasEnvio[marea.id]) }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="p-4 bg-warning/5 border border-warning/10 rounded-xl">
        <p class="text-[10px] text-warning font-black uppercase tracking-widest flex items-center gap-2">
          <InfoCircleIcon class="w-3.5 h-3.5" />
          Importante
        </p>
        <p class="text-[11px] text-text-muted mt-1 leading-relaxed">
          Esta acción cambiará el estado de las mareas a "Esperando Confirmación" y registrará las fechas de envío manual indicadas.
        </p>
      </div>

      <!-- Footer Buttons -->
      <div class="flex justify-end gap-3 pt-4 border-t border-border">
        <button 
          @click="emit('close')"
          class="px-5 py-2 rounded-xl text-[11px] font-black uppercase tracking-widest text-text-muted hover:bg-surface-muted transition-colors"
          :disabled="sending"
        >
          Cancelar
        </button>
        <button 
          @click="emit('confirm')"
          class="flex items-center gap-2 px-6 py-2 bg-primary text-primary-fg rounded-xl text-[11px] font-black uppercase tracking-widest shadow-lg shadow-primary/20 hover:opacity-90 transition-all disabled:opacity-50"
          :disabled="sending"
        >
          <span v-if="sending" class="w-3 h-3 border-2 border-primary-fg border-t-transparent rounded-full animate-spin"></span>
          {{ sending ? 'Procesando...' : 'Confirmar Registro' }}
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import BaseModal from '@/components/common/BaseModal.vue'
import { BoxCubeIcon, CalenderIcon, InfoCircleIcon } from '@/icons'

const props = defineProps<{
  show: boolean;
  mareas: any[];
  fechasEnvio: Record<string, string>;
  sending: boolean;
}>();

const emit = defineEmits(['close', 'confirm']);

const formatDate = (dateStr: string) => {
  if (!dateStr) return 'S/D'
  try {
    const date = new Date(dateStr)
    return date.toLocaleDateString('es-AR', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    })
  } catch {
    return dateStr
  }
}

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}
</script>
