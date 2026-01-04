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
          <div class="flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-brand-100 dark:bg-brand-900/30">
            <MailIcon class="h-6 w-6 text-brand-600 dark:text-brand-400" aria-hidden="true" />
          </div>
          <div>
            <p class="text-sm text-gray-500 dark:text-gray-400">
              Gestión de reclamo por demoras en la entrega de documentación de marea.
            </p>
          </div>
        </div>

        <!-- SCENARIO A: HAS EMAIL -->
        <div v-if="email" class="space-y-4">
          <div class="p-3 bg-gray-50 dark:bg-gray-800/50 rounded-xl border border-gray-100 dark:border-gray-800">
              <div class="flex flex-col gap-1 text-sm">
                <span class="text-gray-500">Para: <span class="font-bold text-gray-900 dark:text-white">{{ obsName }} &lt;{{ email }}&gt;</span></span>
                <span class="text-gray-500">Asunto: <span class="font-bold text-gray-900 dark:text-white">Reclamo entrega marea {{ mareaId }} ({{ vesselName }})</span></span>
              </div>
          </div>

          <div>
            <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Mensaje</label>
            <textarea
              v-model="messageBody"
              rows="6"
              class="w-full rounded-xl border-gray-300 dark:border-gray-700 bg-white dark:bg-gray-800 text-gray-900 dark:text-white shadow-sm focus:border-brand-500 focus:ring-brand-500 sm:text-sm p-3 resize-none"
            ></textarea>
            <p class="mt-2 text-xs text-gray-500">Puede editar el mensaje antes de enviarlo.</p>
          </div>
        </div>

        <!-- SCENARIO B: NO EMAIL -->
        <div v-else class="space-y-4">
          <div class="p-4 bg-orange-50 dark:bg-orange-900/20 rounded-xl border border-orange-100 dark:border-orange-800/30 flex gap-3 text-orange-700 dark:text-orange-400">
              <WarningIcon class="w-5 h-5 flex-shrink-0" />
              <div class="text-sm">
                <p class="font-black uppercase mb-1">Email no configurado</p>
                <p>El observador <strong>{{ obsName }}</strong> no tiene una dirección de email registrada en el sistema.</p>
              </div>
          </div>
          <p class="text-sm text-gray-600 dark:text-gray-400">
            Deberá comunicarse por otros medios para reclamar la entrega de la marea <strong>{{ mareaId }}</strong> del buque <strong>{{ vesselName }}</strong>, que lleva <strong>{{ delayDays }} días</strong> de retraso.
          </p>
        </div>

        <!-- Actions -->
        <div class="mt-6 flex flex-col sm:flex-row-reverse gap-3">
          <button 
            v-if="email"
            type="button" 
            class="inline-flex w-full justify-center rounded-xl bg-brand-600 px-3 py-2 text-sm font-semibold text-white shadow-sm hover:bg-brand-500 sm:w-auto items-center gap-2"
            @click="send"
            :disabled="sending"
          >
            <span v-if="sending" class="loading loading-spinner loading-xs"></span>
            <SendIcon v-else class="w-4 h-4" />
            Enviar Reclamo
          </button>
          <button 
            type="button" 
            class="inline-flex w-full justify-center rounded-xl bg-white dark:bg-gray-800 px-3 py-2 text-sm font-semibold text-gray-900 dark:text-gray-300 shadow-sm ring-1 ring-inset ring-gray-300 dark:ring-gray-700 hover:bg-gray-50 dark:hover:bg-gray-700 sm:w-auto"
            @click="close"
          >
            {{ email ? 'Cancelar' : 'Cerrar' }}
          </button>
        </div>
      </div>
    </BaseModal>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import { MailIcon, WarningIcon, SendIcon } from '@/icons'
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
