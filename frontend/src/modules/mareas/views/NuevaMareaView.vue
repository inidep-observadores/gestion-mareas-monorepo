<template>
  <AdminLayout 
    title="Registrar Nueva Marea" 
    description="Complete los pasos para dar de alta una nueva designación de marea."
  >
    <!-- 
      This view now acts as a container for the NuevaMareaDialog.
      It keeps the wizard logic in a single reusable component while
      preserving the direct access via URL /mareas/nueva.
    -->
    <div class="flex items-center justify-center py-20">
      <div class="text-center animate-pulse">
        <ShipIcon class="w-12 h-12 text-primary/30 mx-auto mb-4" />
        <p class="text-text-muted font-black uppercase tracking-widest text-xs">Abriendo asistente de registro...</p>
      </div>
    </div>

    <NuevaMareaDialog
      :show="showDialog"
      @close="handleClose"
      @success="handleSuccess"
    />
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import NuevaMareaDialog from '../components/NuevaMareaDialog.vue'
import { ShipIcon } from '@/icons'

const router = useRouter()
const showDialog = ref(false)

onMounted(() => {
    showDialog.value = true
})

const handleClose = () => {
    showDialog.value = false
    router.back()
}

const handleSuccess = () => {
    showDialog.value = false
    router.push('/mareas/dashboard')
}
</script>
