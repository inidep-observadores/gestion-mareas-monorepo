<template>
  <AdminLayout 
    title="Gestión de Protocolización" 
    description="Centro de control para el envío y confirmación de protocolización de mareas."
  >
    <div class="relative min-h-[calc(100vh-120px)] z-1 pb-10 flex flex-col gap-8">
      
      <!-- TABS -->
      <div class="sticky top-0 z-20 bg-background/80 backdrop-blur-md py-4 mb-2 -mx-2 px-2 border-b border-border">
        <div class="flex p-1 bg-surface-muted border border-border rounded-2xl w-fit shadow-sm">
          <button 
            v-for="tab in tabs" 
            :key="tab.id" 
            @click="activeTab = tab.id"
            class="relative px-6 py-2 text-xs font-black uppercase tracking-tight transition-all duration-300 rounded-xl overflow-hidden"
            :class="activeTab === tab.id ? 'text-primary-fg' : 'text-text-muted hover:text-text'"
          >
            <div v-if="activeTab === tab.id" class="absolute inset-0 bg-primary transition-all duration-300"></div>
            <span class="relative z-10 flex items-center gap-2">
              {{ tab.label }}
              <Badge 
                variant="solid" 
                size="sm" 
                class="font-extrabold h-4 px-1.5"
                :color="activeTab === tab.id ? 'light' : 'primary'"
                :style="activeTab === tab.id ? 'background-color: rgba(255,255,255,0.2)' : ''"
              >
                {{ getCount(tab.id) }}
              </Badge>
            </span>
          </button>
        </div>
      </div>

      <!-- CONTENT -->
      <div v-if="loading" class="flex items-center justify-center py-20">
        <div class="w-12 h-12 border-4 border-primary border-t-transparent rounded-full animate-spin"></div>
      </div>

      <div v-else>
        <!-- Tab Pendientes Envío -->
        <TabPendientesEnvio
          v-if="activeTab === 'pendientes'"
          :mareas="mareasPendientes"
          @refresh="loadMareas"
        />

        <!-- Tab Esperando Confirmación -->
        <TabEsperandoConfirmacion 
          v-if="activeTab === 'esperando'" 
          :mareas="mareasEsperando"
          @refresh="loadMareas"
        />

        <!-- Tab Completadas (Futuro paso) -->
        <div v-if="activeTab === 'protocolizadas'">
           <div class="py-12 text-center text-text-muted text-sm font-bold border border-dashed border-border rounded-xl">
              Historial de mareas protocolizadas próximamente.
           </div>
        </div>
      </div>

    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import AdminLayout from '@/components/layout/AdminLayout.vue'
import Badge from '@/components/ui/Badge.vue'
import TabEsperandoConfirmacion from '../components/protocolizacion/TabEsperandoConfirmacion.vue'
import TabPendientesEnvio from '../components/protocolizacion/TabPendientesEnvio.vue'
import mareasService from '../services/mareas.service'
import { toast } from 'vue-sonner'

const loading = ref(true)
const mareasEsperando = ref<any[]>([])
const mareasPendientes = ref<any[]>([])

const activeTab = ref('pendientes')

const tabs = [
  { id: 'pendientes', label: 'Pendientes de Envío' },
  { id: 'esperando', label: 'Esperando Confirmación' },
  { id: 'protocolizadas', label: 'Mareas Protocolizadas' }
]

const getCount = (tabId: string) => {
  if (tabId === 'esperando') return mareasEsperando.value.length
  if (tabId === 'pendientes') return mareasPendientes.value.length
  return 0
}

const loadMareas = async () => {
  try {
    loading.value = true
    const [pendientes, enEspera] = await Promise.all([
      mareasService.getProtocolizacionPendientes(),
      mareasService.getProtocolizacionEnEspera()
    ])
    mareasPendientes.value = pendientes
    mareasEsperando.value = enEspera
  } catch (error) {
    console.error('Error cargando mareas:', error)
    toast.error('Ocurrió un error al cargar las mareas.')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadMareas()
})
</script>
