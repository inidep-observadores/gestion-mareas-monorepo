<template>
  <BaseModal
    :show="show"
    :title="actionData?.label || 'Confirmar Acción'"
    @close="handleClose"
    max-width="md"
  >
    <div v-form-nav class="space-y-6">
      <!-- Info Contextual -->
      <div class="bg-surface-muted/50 border border-border rounded-2xl p-4 space-y-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center gap-3">
            <div class="p-2 bg-primary/10 rounded-xl text-primary shrink-0">
              <ShipIcon class="w-4 h-4" />
            </div>
            <div>
              <p class="text-[10px] font-black uppercase tracking-widest text-text-muted mb-0.5">Marea & Buque</p>
              <h4 class="text-sm font-black text-text leading-tight">
                {{ marea?.id_marea }} <span class="mx-1 text-text-muted/40 font-normal">|</span> {{ marea?.buque_nombre || marea?.buque?.nombre }}
              </h4>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-4 pt-2 border-t border-border/50">
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Observador</p>
            <p class="text-xs font-black text-text truncate">{{ marea?.observador || 'No asignado' }}</p>
          </div>
          <div>
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-1">Estado Actual</p>
            <span class="px-2 py-0.5 bg-surface rounded text-[9px] font-black uppercase tracking-tighter text-text border border-border">
              {{ marea?.estado }}
            </span>
          </div>
        </div>
      </div>

      <!-- Transición de Estado -->
      <div class="flex items-center gap-4 py-2">
        <div class="flex-1 text-center">
            <p class="text-[9px] font-bold text-text-muted uppercase tracking-widest mb-2">Estado Origen</p>
            <div class="p-3 bg-surface-muted rounded-xl border border-border text-xs font-bold text-text-muted">
                {{ marea?.estado }}
            </div>
        </div>
        <div class="shrink-0 pt-6">
            <div class="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-primary">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
            </div>
        </div>
        <div class="flex-1 text-center">
            <p class="text-[9px] font-bold text-primary uppercase tracking-widest mb-2">Nuevo Estado</p>
            <div class="p-3 bg-primary/5 border border-primary/20 rounded-xl text-xs font-black text-primary">
                {{ actionData?.toStateName || 'Siguiente Paso' }}
            </div>
        </div>
      </div>

      <!-- Notas / Observaciones -->
      <div v-if="requiresNotes" class="space-y-3">
        <label class="text-[10px] font-black uppercase tracking-widest text-text-muted flex items-center justify-between">
          <span>Notas / Observaciones</span>
          <span class="text-error text-[8px] italic">* Obligatorio</span>
        </label>
        <textarea
          v-model="comentarios"
          rows="4"
          :placeholder="desestimada
            ? 'Es obligatorio ingresar el motivo por el cual se desestima la marea...'
            : 'Es obligatorio ingresar un motivo o nota para esta acción...'"
          class="w-full bg-surface border border-border rounded-xl p-4 text-sm focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all resize-none outline-none"
          :class="{ 'border-error ring-1 ring-error/10': showError }"
        ></textarea>
        <p v-if="showError" class="text-[10px] font-bold text-error uppercase tracking-tight flex items-center gap-1">
          <WarningIcon class="w-3 h-3" />
          {{ desestimada
            ? 'Debe ingresar el motivo de la desestimación para continuar.'
            : 'Debe completar las notas para confirmar esta acción.' }}
        </p>
      </div>

      <!-- ── Sección Desestimada ────────────────────────────────────────────
           Se muestra dinámicamente cuando el estado destino es
           PENDIENTE_DE_INFORME. Cubre automáticamente todas las acciones
           que lleven a ese estado: FINALIZAR_CORRECCION, PASAR_A_INFORME,
           DEVOLUCION_EXTERNA, etc.
      ─────────────────────────────────────────────────────────────────────── -->
      <template v-if="showDesestimadaOption">
        <div class="border-t border-border/60"></div>

        <div class="space-y-3">
          <!-- Checkbox interactivo -->
          <label
            class="flex items-start gap-3 cursor-pointer group rounded-xl p-3.5 transition-all select-none border"
            :class="desestimada
              ? 'bg-error/5 border-error/30 ring-1 ring-error/20 shadow-sm'
              : 'bg-surface-muted/30 border-border/60 hover:border-border hover:bg-surface-muted/50'"
          >
            <div class="relative flex-shrink-0 mt-0.5">
              <input
                ref="checkboxRef"
                type="checkbox"
                v-model="desestimada"
                class="sr-only peer"
                @keydown.enter.prevent="focusNextElement"
              />
              <div
                class="w-5 h-5 rounded-md border-2 transition-all duration-150 flex items-center justify-center peer-focus:ring-2 peer-focus:ring-offset-1"
                :class="desestimada
                  ? 'bg-error border-error text-white peer-focus:ring-error/30 shadow-sm'
                  : 'bg-surface border-border group-hover:border-primary/50 peer-focus:ring-primary/30'"
              >
                <CheckIcon v-if="desestimada" class="w-3.5 h-3.5 stroke-[3] text-white" />
              </div>
            </div>
            <div class="flex-1 min-w-0">
              <div class="flex items-center justify-between gap-2">
                <p class="text-sm font-bold transition-colors" :class="desestimada ? 'text-error' : 'text-text'">
                  Marcar como Desestimada
                </p>
                <span
                  v-if="desestimada"
                  class="px-2 py-0.5 bg-error/15 text-error text-[10px] font-black uppercase tracking-wider rounded-md border border-error/30 animate-in fade-in"
                >
                  Marcada
                </span>
              </div>
              <p class="text-xs mt-1 leading-relaxed transition-colors" :class="desestimada ? 'text-error/80' : 'text-text-muted'">
                Los datos de esta marea no cumplieron los requisitos mínimos de calidad y serán descartados del análisis científico. La marea continuará el circuito administrativo con normalidad.
              </p>
            </div>
          </label>

          <!-- Tarjeta de advertencia visible cuando está marcada -->
          <Transition
            enter-active-class="transition duration-200 ease-out"
            enter-from-class="opacity-0 -translate-y-2"
            enter-to-class="opacity-100 translate-y-0"
            leave-active-class="transition duration-150 ease-in"
            leave-from-class="opacity-100 translate-y-0"
            leave-to-class="opacity-0 -translate-y-2"
          >
            <div v-if="desestimada" class="bg-error/10 border border-error/30 rounded-xl p-3.5 flex items-start gap-3">
              <div class="p-1.5 bg-error/20 rounded-lg text-error shrink-0 mt-0.5">
                <WarningIcon class="w-4 h-4" />
              </div>
              <div class="flex-1 min-w-0">
                <div class="flex items-center justify-between gap-2">
                  <h5 class="text-xs font-black text-error uppercase tracking-wider">
                    ¡Atención! Acción irreversible
                  </h5>
                  <button
                    type="button"
                    @click.stop="desestimada = false"
                    class="text-[11px] font-bold text-error hover:underline hover:text-error/90 cursor-pointer"
                  >
                    Deshacer
                  </button>
                </div>
                <p class="text-xs text-error/90 mt-1 leading-relaxed">
                  Está a punto de desestimar la marea <strong>{{ marea?.id_marea }}</strong>. Al presionar el botón de confirmación inferior, los datos quedarán formalmente descartados para investigación.
                </p>
              </div>
            </div>
          </Transition>
        </div>
      </template>

      <!-- Footer Buttons -->
      <div class="flex flex-col sm:flex-row gap-3 pt-2">
        <button
          @click="handleClose"
          class="flex-1 px-6 py-3 bg-surface border border-border hover:bg-surface-muted text-text-muted hover:text-text rounded-xl text-xs font-black uppercase tracking-widest transition-all"
        >
          Cancelar
        </button>
        <button
          @click="handleConfirm"
          :disabled="loading"
          data-allow-enter
          class="flex-1 px-6 py-3 rounded-xl text-xs font-black uppercase tracking-widest shadow-lg transition-all flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
          :class="desestimada
            ? 'bg-error text-white hover:bg-error/90 shadow-error/20 active:scale-95'
            : 'bg-primary text-primary-fg hover:opacity-90 shadow-primary/20 active:scale-95'"
        >
          <LoadingSpinner v-if="loading" size="xs" />
          <template v-else>
            <WarningIcon v-if="desestimada" class="w-4 h-4 text-white" />
            <span>{{ desestimada ? 'Confirmar y Desestimar' : 'Confirmar Acción' }}</span>
          </template>
        </button>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import { ShipIcon, WarningIcon, CheckIcon } from '@/icons'

const props = defineProps<{
  show: boolean
  marea: any
  actionKey: string | null
  actionData: any
  loading?: boolean
}>()

const emit = defineEmits(['close', 'confirm'])

// ── Estado del formulario ──────────────────────────────────────────────────
const comentarios = ref('')
const showError = ref(false)
const desestimada = ref(false)
const checkboxRef = ref<HTMLInputElement | null>(null)

// ── Computed ───────────────────────────────────────────────────────────────
const requiresNotes = computed(() => Boolean(props.actionData?.requiresNotes) || desestimada.value)

/**
 * La sección de desestimada se activa dinámicamente cuando el estado destino
 * de la transición es PENDIENTE_DE_INFORME, sin importar la acción de origen.
 */
const showDesestimadaOption = computed(() =>
  props.actionData?.toStateCodigo === 'PENDIENTE_DE_INFORME'
)

// ── Watchers ───────────────────────────────────────────────────────────────
watch(() => props.show, (newVal) => {
  if (newVal) {
    comentarios.value = ''
    showError.value = false
    desestimada.value = false
  }
})

watch(desestimada, (val) => {
  if (!val && !props.actionData?.requiresNotes) {
    showError.value = false
  }
})

// ── Handlers ───────────────────────────────────────────────────────────────
const handleClose = () => {
  if (props.loading) return
  emit('close')
}

/**
 * Enter-as-Tab: mueve el foco al siguiente elemento focusable
 * en lugar de hacer toggle del checkbox.
 */
const focusNextElement = () => {
  const focusable = document.querySelectorAll<HTMLElement>(
    'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
  )
  const list = Array.from(focusable)
  const idx = list.indexOf(checkboxRef.value as HTMLElement)
  if (idx !== -1 && idx < list.length - 1) {
    list[idx + 1].focus()
  }
}

const handleConfirm = () => {
  if (requiresNotes.value && !comentarios.value.trim()) {
    showError.value = true
    return
  }

  const payload: Record<string, any> = {
    comentarios: comentarios.value.trim() || undefined
  }

  // Incluir flag de desestimada solo cuando la sección es visible
  if (showDesestimadaOption.value) {
    payload.desestimada = desestimada.value
  }

  emit('confirm', payload)
}
</script>
