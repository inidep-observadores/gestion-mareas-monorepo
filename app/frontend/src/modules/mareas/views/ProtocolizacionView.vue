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
          v-show="activeTab === 'pendientes'"
          :mareas="mareasPendientes"
          @refresh="loadMareas"
          @update:count="counts.pendientes = $event"
        />

        <!-- Tab Esperando Confirmación -->
        <TabEsperandoConfirmacion 
          v-show="activeTab === 'esperando'" 
          :mareas="mareasEsperando"
          @refresh="loadMareas"
          @update:count="counts.esperando = $event"
        />

        <!-- Tab Mareas Protocolizadas -->
        <TabMareasProtocolizadas
          v-show="activeTab === 'protocolizadas'"
          :mareas="mareasCompletas"
          @update:count="counts.protocolizadas = $event"
        />

        <!-- Tab Historial de Envíos -->
        <TabHistorialProtocolizacion
          v-show="activeTab === 'historial'"
          :lotes="mareasLotes"
          @refresh="loadMareas"
          @update:count="counts.historial = $event"
        />
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
import TabMareasProtocolizadas from '../components/protocolizacion/TabMareasProtocolizadas.vue'
import TabHistorialProtocolizacion from '../components/protocolizacion/TabHistorialProtocolizacion.vue'
import mareasService from '../services/mareas.service'
import { toast } from 'vue-sonner'
import { useConfigStore } from '@/modules/shared/stores/config.store'
import { watch } from 'vue'

const configStore = useConfigStore()

const loading = ref(true)
const mareasEsperando = ref<any[]>([])
const mareasPendientes = ref<any[]>([])
const mareasCompletas = ref<any[]>([])
const mareasLotes = ref<any[]>([])

const activeTab = ref('pendientes')

const counts = ref<Record<string, number>>({
  pendientes: 0,
  esperando: 0,
  protocolizadas: 0,
  historial: 0
})

const tabs = [
  { id: 'pendientes', label: 'Pendientes de Envío' },
  { id: 'esperando', label: 'Esperando Confirmación' },
  { id: 'protocolizadas', label: 'Mareas Protocolizadas' },
  { id: 'historial', label: 'Historial de Envíos' }
]

const getCount = (tabId: string) => {
  return counts.value[tabId] || 0
}

const sortMareas = (list: any[]) => {
  return [...list].sort((a, b) => {
    // 1. Tipo (desc) - MC antes que OB etc
    const tipoA = (a.tipo_marea || a.tipoMarea || '').toString().toLowerCase()
    const tipoB = (b.tipo_marea || b.tipoMarea || '').toString().toLowerCase()
    if (tipoA < tipoB) return 1
    if (tipoA > tipoB) return -1
    
    // 2. Año (desc)
    const anioA = Number(a.anio_marea || a.anioMarea || 0)
    const anioB = Number(b.anio_marea || b.anioMarea || 0)
    if (anioA < anioB) return 1
    if (anioA > anioB) return -1
    
    // 3. Número (desc)
    const nroA = Number(a.nro_marea || a.nroMarea || 0)
    const nroB = Number(b.nro_marea || b.nroMarea || 0)
    if (nroA < nroB) return 1
    if (nroA > nroB) return -1
    
    return 0
  })
}

const loadMareas = async () => {
  try {
    loading.value = true
    const [pendientes, enEspera, completas, lotes] = await Promise.all([
      mareasService.getProtocolizacionPendientes(),
      mareasService.getProtocolizacionEnEspera(),
      mareasService.getProtocolizacionCompletas(),
      mareasService.getProtocolizacionLotes()
    ])
    mareasPendientes.value = sortMareas(pendientes)
    mareasEsperando.value = sortMareas(enEspera)
    mareasCompletas.value = sortMareas(completas)
    mareasLotes.value = lotes
  } catch (error) {
    console.error('Error cargando mareas:', error)
    toast.error('Ocurrió un error al cargar las mareas.')
  } finally {
    loading.value = false
  }
}

// Observamos cambios en el año para refrescar las pestañas que dependen de él
watch(() => configStore.selectedYear, () => {
  loadMareas()
})

onMounted(() => {
  loadMareas()
})
</script>
