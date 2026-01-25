<template>
  <AdminLayout
    :title="`Detalle Operativo: ${selectedMarea?.buque_nombre || 'Marea'}`"
    :description="selectedMarea ? `Marea ${selectedMarea.id_marea}` : 'Cargando información...'"
  >
    <template #header-actions>
      <Button 
        variant="soft"
        size="sm"
        @click="router.back()"
      >
        <ArrowLeftIcon class="w-4 h-4 mr-2" />
        Volver
      </Button>
    </template>

    <div class="max-w-2xl mx-auto py-6 px-4">
      <div v-if="loading" class="flex flex-col items-center justify-center py-20">
        <LoadingSpinner size="xl" class="text-primary" />
        <span class="mt-4 text-text-muted font-bold">Cargando contexto operativo...</span>
      </div>

      <div 
        v-else-if="selectedMarea"
        class="bg-surface border border-border rounded-2xl shadow-sm overflow-hidden"
      >
        <MareaContextDetailContent 
          :marea="selectedMarea"
          :context="selectedMareaContext"
          :read-only="isReadOnly"
          @close="router.back()"
          @open-detalle="goToDetalle"
          @action="executeActionFromView"
          @manage-alert="handleManageAlert"
        />
      </div>

      <div v-else class="text-center py-20">
        <p class="text-text-muted">No se pudo cargar la información de la marea.</p>
        <button 
          @click="router.back()"
          class="mt-4 text-primary font-bold hover:underline"
        >
          Regresar al panel
        </button>
      </div>
    </div>

    <!-- Reutilizamos los diálogos necesarios -->
    <GestionEtapasMareaDialog
       :show="showGestionDialog"
       :mode="gestionMode"
       :marea="mareaToManage"
       :currentStages="mareaToManage?.etapas || []"
       :initialPortId="mareaToManage?.puertoBaseId"
       @close="showGestionDialog = false"
       @confirm="handleGestionConfirm"
    />

    <RecibirArchivosDialog
       :show="showRecibirDialog"
       :marea="mareaToManage"
       @close="showRecibirDialog = false"
       @confirm="handleRecibirConfirm"
    />

    <AlertManagementDialog
      :is-open="isAlertDialogOpen"
      :alert="selectedAlert"
      @close="isAlertDialogOpen = false"
      @refresh="loadContext"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import MareaContextDetailContent from '../components/MareaContextDetailContent.vue'
import GestionEtapasMareaDialog from '../components/GestionEtapasMareaDialog.vue'
import RecibirArchivosDialog from '../components/RecibirArchivosDialog.vue'
// @ts-ignore
import AlertManagementDialog from '../../alerts/components/AlertManagementDialog.vue'
import { useMareas } from '../composables/useMareas'
import { useAuthStore } from '@/modules/auth/stores/auth.store'
import { ValidRoles } from '@/modules/auth/interfaces/roles.enum'
import { ArrowLeftIcon } from '@/icons'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import Button from '@/components/ui/Button.vue'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()
const {
  loading,
  fetchMareaContext,
  selectedMareaContext,
  executeAction
} = useMareas()

const isReadOnly = computed(() => {
  const roles = authStore.user?.roles || []
  return !roles.includes(ValidRoles.admin) && !roles.includes(ValidRoles.tecnico)
})

const selectedMarea = computed(() => selectedMareaContext.value?.marea)

// UI State para diálogos
const showGestionDialog = ref(false)
const showRecibirDialog = ref(false)
const gestionMode = ref<'INICIAR' | 'EDITAR' | 'FINALIZAR'>('INICIAR')
const mareaToManage = ref<any>(null)
const isAlertDialogOpen = ref(false)
const selectedAlert = ref(null)

const loadContext = async () => {
  const id = route.params.id as string
  if (id) {
    await fetchMareaContext(id)
  }
}

onMounted(loadContext)

const goToDetalle = () => {
  if (selectedMarea.value) {
    router.push({ name: 'MareaDetalle', params: { id: selectedMarea.value.id } })
  }
}

const handleManageAlert = (alert: any) => {
    selectedAlert.value = alert
    isAlertDialogOpen.value = true
}

const executeActionFromView = async (actionKey: string) => {
  if (!selectedMarea.value) return

  const mareaContext = selectedMareaContext.value?.marea || selectedMarea.value

  if (actionKey === 'REGISTRAR_INICIO') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'INICIAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'EDITAR_ETAPAS') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'EDITAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'REGISTRAR_ARRIBO') {
    mareaToManage.value = mareaContext
    gestionMode.value = 'FINALIZAR'
    showGestionDialog.value = true
    return
  }

  if (actionKey === 'RECIBIR_DATOS') {
    mareaToManage.value = mareaContext
    showRecibirDialog.value = true
    return
  }

  try {
    await executeAction(selectedMarea.value.id, actionKey)
    await loadContext()
  } catch (err) {
    console.error('Action failed:', err)
  }
}

const handleGestionConfirm = async (payload: any) => {
    try {
        const actionKey = gestionMode.value === 'INICIAR'
            ? 'REGISTRAR_INICIO'
            : gestionMode.value === 'FINALIZAR'
                ? 'REGISTRAR_ARRIBO'
                : 'EDITAR_ETAPAS';

        await executeAction(mareaToManage.value.id, actionKey, payload)
        showGestionDialog.value = false
        await loadContext()
    } catch (err) {
        console.error("Error en gestión de marea:", err)
    }
}

const handleRecibirConfirm = async (payload: any) => {
    try {
        await executeAction(mareaToManage.value.id, 'RECIBIR_DATOS', payload)
        showRecibirDialog.value = false
        await loadContext()
    } catch (err) {
        console.error("Error en recepción de archivos:", err)
    }
}
</script>
