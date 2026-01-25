<template>
  <Teleport to="body">
    <BaseModal 
      :show="show" 
      title="RECLAMO DE DOCUMENTACIÓN" 
      max-width="lg"
      variant="glass"
      @close="close"
    >
      <div class="mt-2">
        <div class="flex items-center gap-4 mb-6">
          <div class="flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-primary/10">
            <MailIcon class="h-6 w-6 text-primary" aria-hidden="true" />
          </div>
          <div>
            <p class="text-sm text-text-muted">
              Gestión de reclamo por demoras en la entrega de documentación de marea.
            </p>
          </div>
        </div>

        <!-- SCENARIO A: HAS EMAIL -->
        <div v-if="email" class="space-y-4">
          <div class="p-3 bg-surface-muted rounded-xl border border-border">
              <div class="flex flex-col gap-1 text-sm">
                <span class="text-text-muted">Para: <span class="font-bold text-text">{{ obsName }} &lt;{{ email }}&gt;</span></span>
                <span class="text-text-muted">Asunto: <span class="font-bold text-text">Reclamo entrega marea {{ mareaId }} ({{ vesselName }})</span></span>
              </div>
          </div>

          <div>
            <label class="block text-xs font-bold text-text-muted mb-2 uppercase tracking-wide">Mensaje</label>
            <textarea
              v-model="messageBody"
              rows="6"
              class="w-full rounded-xl border-border bg-surface text-text shadow-sm focus:border-primary focus:ring-primary sm:text-sm p-3 resize-none"
            ></textarea>
            <p class="mt-2 text-xs text-text-muted">Puede editar el mensaje antes de enviarlo.</p>
          </div>
        </div>

        <!-- SCENARIO B: NO EMAIL -->
        <div v-else class="space-y-4">
          <div class="p-4 bg-warning/10 rounded-xl border border-warning/30 flex gap-3 text-warning">
              <WarningIcon class="w-5 h-5 flex-shrink-0" />
              <div class="text-sm">
                <p class="font-black uppercase mb-1">Email no configurado</p>
                <p>El observador <strong>{{ obsName }}</strong> no tiene una dirección de email registrada en el sistema.</p>
              </div>
          </div>
          <p class="text-sm text-text-muted">
            Deberá comunicarse por otros medios para reclamar la entrega de la marea <strong>{{ mareaId }}</strong> del buque <strong>{{ vesselName }}</strong>, que lleva <strong>{{ delayDays }} días</strong> de retraso.
          </p>
        </div>

        <!-- Actions -->
        <div class="mt-6 flex flex-col sm:flex-row-reverse gap-3">
          <Button 
            v-if="email"
            @click="send"
            :disabled="sending"
            class="w-full sm:w-auto"
          >
            <LoadingSpinner v-if="sending" size="xs" class="text-white" />
            <SendIcon v-else class="w-4 h-4" />
            {{ sending ? 'Enviando...' : 'Enviar Reclamo' }}
          </Button>
          <Button 
            variant="outline"
            @click="close"
            class="w-full sm:w-auto"
          >
            {{ email ? 'Cancelar' : 'Cerrar' }}
          </Button>
        </div>
      </div>
    </BaseModal>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import { MailIcon, WarningIcon, SendIcon } from '@/icons'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import Button from '@/components/ui/Button.vue'
import { useAuthStore } from '@/modules/auth/stores/auth.store'

const props = defineProps<{
  show: boolean
  id: string
  mareaId: string
  vesselName: string
  obsName: string
  email?: string | null
  delayDays: number
  arrivalDate?: string
}>()

const emit = defineEmits(['close', 'confirm'])

const authStore = useAuthStore()
const messageBody = ref('')
const sending = ref(false)

const generateTemplate = () => {
  const signature = authStore.user?.fullName || 'Gestión de Mareas'
  return `Estimado/a ${props.obsName},

Se solicita la entrega de la documentación correspondiente a la marea ${props.mareaId} realizada en el buque ${props.vesselName}.
Según nuestros registros, el arribo fue el ${props.arrivalDate || 'N/D'} y la entrega presenta un retraso de ${props.delayDays} días.

Por favor, regularice esta situación a la brevedad.

Atte.
${signature}`
}

watch(() => props.show, (newVal) => {
  if (newVal && props.email) {
    messageBody.value = generateTemplate()
  }
})

const close = () => {
  emit('close')
}

const send = async () => {
  sending.value = true
  // Simulate network delay
  await new Promise(resolve => setTimeout(resolve, 1000))
  sending.value = false
  emit('confirm', {
    to: props.email,
    body: messageBody.value,
    mareaId: props.mareaId,
    id: props.id
  })
}
</script>
