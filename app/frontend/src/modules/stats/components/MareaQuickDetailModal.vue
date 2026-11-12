<template>
  <BaseModal
    :show="isOpen"
    @close="$emit('close')"
    maxWidth="4xl"
  >
    <template #title>
      <div class="flex items-center gap-3 py-1">
        <div class="p-2 bg-primary/10 rounded-xl text-primary">
          <FileTextIcon class="w-5 h-5" />
        </div>
        <div v-if="marea">
          <h3 class="text-sm font-black text-text uppercase tracking-widest">
            {{ marea.id_marea }}
          </h3>
          <p class="text-[10px] font-bold text-text-muted uppercase tracking-wider">
            Detalle Operativo Rápido
          </p>
        </div>
        <div v-else class="h-10 w-32 bg-surface-muted animate-pulse rounded-lg"></div>
      </div>
    </template>

    <div class="space-y-4 py-2">
      <!-- Tabs Header -->
      <div v-if="marea" class="flex gap-4 border-b border-border/50 px-2">
        <button
          @click="activeTab = 'detalle'"
          class="pb-2 text-xs font-black uppercase tracking-widest transition-colors relative"
          :class="activeTab === 'detalle' ? 'text-primary' : 'text-text-muted hover:text-text'"
        >
          Detalle Operativo
          <div v-if="activeTab === 'detalle'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-t-full"></div>
        </button>
        <button
          @click="activeTab === 'adjuntos' ? null : activeTab = 'adjuntos'"
          class="pb-2 text-xs font-black uppercase tracking-widest transition-colors relative flex items-center gap-1.5"
          :class="activeTab === 'adjuntos' ? 'text-primary' : 'text-text-muted hover:text-text'"
        >
          Adjuntos
          <Badge v-if="marea?.archivos?.length" size="sm" variant="light" :color="activeTab === 'adjuntos' ? 'primary' : 'dark'">
            {{ marea.archivos.length }}
          </Badge>
          <div v-if="activeTab === 'adjuntos'" class="absolute bottom-0 left-0 right-0 h-0.5 bg-primary rounded-t-full"></div>
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-20 gap-4">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary"></div>
        <p class="text-xs font-bold text-text-muted animate-pulse uppercase tracking-widest">Cargando detalles...</p>
      </div>

      <!-- Content: Detalle Operativo -->
      <div v-else-if="marea && activeTab === 'detalle'" class="space-y-6">
        <!-- Header Info Grid -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div class="p-3 bg-surface-muted/30 rounded-2xl border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Buque / Flota</p>
            <p class="text-xs font-bold text-text truncate">{{ marea.buque?.nombreBuque }}</p>
            <p class="text-[9px] font-bold text-primary uppercase">{{ marea.buque?.tipoFlota?.nombre || 'N/D' }}</p>
          </div>

          <div class="p-3 bg-surface-muted/30 rounded-2xl border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Observador Principal</p>
            <p class="text-xs font-bold text-text">
              {{ marea.observadorPrincipal ? `${marea.observadorPrincipal.nombre} ${marea.observadorPrincipal.apellido}` : 'Sin asignar' }}
            </p>
          </div>

          <div class="p-3 bg-surface-muted/30 rounded-2xl border border-border/50">
            <p class="text-[9px] font-black text-text-muted uppercase tracking-widest mb-1">Periodo Total</p>
            <div class="flex items-center gap-1.5 flex-wrap">
              <span class="text-[10px] font-bold text-text-muted">
                {{ formatDate(marea.fechaInicioObservador || marea.fechaZarpadaEstimada) }}
              </span>
              <span class="text-[9px] text-text-muted/40 font-black">→</span>
              <span class="text-[10px] font-bold text-text-muted">
                {{ marea.fechaFinObservador ? formatDate(marea.fechaFinObservador) : 'En ejecución' }}
              </span>
            </div>
          </div>

          <div class="p-3 bg-primary/5 rounded-2xl border border-primary/20 flex flex-col items-center justify-center">
            <p class="text-[9px] font-black text-primary uppercase tracking-widest mb-1">Días Navegados</p>
            <p class="text-2xl font-black text-primary tabular-nums leading-none">
              {{ totalDays }}
            </p>
          </div>
        </div>

        <!-- Stages Table -->
        <div class="space-y-3">
          <div class="flex items-center justify-between px-1">
            <h4 class="text-[10px] font-black text-text uppercase tracking-widest">Desglose de Etapas</h4>
            <Badge :color="getStatusColor(marea.estadoActual.nombre)" variant="light" size="sm" class="font-black text-[9px] uppercase">
              {{ marea.estadoActual.nombre }}
            </Badge>
          </div>

          <div class="overflow-hidden rounded-xl border border-border shadow-sm">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-surface-muted/50 border-b border-border">
                  <th class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest w-12 text-center">Etapa</th>
                  <th class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest">Zarpada</th>
                  <th class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest">Arribo</th>
                  <th class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest">Pesquería</th>
                  <th class="px-3 py-2 text-[9px] font-black text-text-muted uppercase tracking-widest text-right">Días</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border">
                <tr
                  v-for="etapa in marea.etapas"
                  :key="etapa.id"
                  class="hover:bg-primary/5 transition-colors"
                >
                  <td class="px-3 py-2 text-center">
                    <span class="text-[10px] font-black text-text tabular-nums">#{{ etapa.nroEtapa }}</span>
                  </td>
                  <td class="px-3 py-2">
                    <span class="text-[10px] font-bold text-text">{{ formatDate(etapa.fechaZarpada) }}</span>
                  </td>
                  <td class="px-3 py-2">
                    <span class="text-[10px] font-bold text-text">{{ etapa.fechaArribo ? formatDate(etapa.fechaArribo) : '-' }}</span>
                  </td>
                  <td class="px-3 py-2">
                    <span class="text-[10px] font-bold text-text-muted uppercase truncate max-w-[150px] block">
                      {{ etapa.pesqueria?.nombre || '-' }}
                    </span>
                  </td>
                  <td class="px-3 py-2 text-right">
                    <span class="text-[10px] font-black text-primary tabular-nums">
                      {{ calculateStageDays(etapa) }}
                    </span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Content: Documentos Adjuntos -->
      <div v-else-if="marea && activeTab === 'adjuntos'" class="min-h-[200px]">
        <div v-if="!marea.archivos || marea.archivos.length === 0" class="flex flex-col items-center justify-center py-10 gap-3 opacity-50">
          <FileTextIcon class="w-10 h-10 text-text-muted" />
          <p class="text-xs font-bold text-text-muted uppercase tracking-widest">No hay documentos adjuntos</p>
        </div>
        <AttachmentViewer 
          v-else
          :archivos="mappedArchivos" 
          title="Documentos Adjuntos de la Marea" 
        />
      </div>

      <!-- Actions (Always visible when loaded) -->
      <div v-if="marea" class="flex items-center justify-between pt-4 border-t border-border mt-2">
          <p class="text-[9px] font-black text-text-muted uppercase tracking-widest opacity-60">
            Última actualización: {{ formatDate(marea.updatedAt, true) }}
          </p>
          <div class="flex gap-3">
             <Button variant="ghost" size="sm" @click="$emit('close')" class="text-[10px] font-black uppercase tracking-widest h-8 px-4">
               Cerrar
             </Button>
             <Button variant="primary" size="sm" @click="goToFullMarea" class="text-[10px] font-black uppercase tracking-widest h-8 px-4 flex items-center gap-2">
               Ver Gestión Completa
               <ExternalLinkIcon class="w-3.5 h-3.5" />
             </Button>
          </div>
        </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { formatDateUI, formatDateTimeUI, formatTimeUI } from '@/utils/date.utils';
import { ref, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import BaseModal from '@/components/common/BaseModal.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import { FileTextIcon, ExternalLinkIcon } from 'lucide-vue-next'
import mareasService from '@/modules/mareas/services/mareas.service'
import { toast } from 'vue-sonner'
import AttachmentViewer from '@/components/common/AttachmentViewer.vue'

const props = defineProps<{
  isOpen: boolean
  mareaId: string | null
}>()

const emit = defineEmits(['close'])
const router = useRouter()

const loading = ref(false)
const marea = ref<any>(null)
const activeTab = ref<'detalle' | 'adjuntos'>('detalle')

const mappedArchivos = computed(() => {
  if (!marea.value?.archivos) return []
  return marea.value.archivos.map((a: any) => ({
    id: a.id,
    rutaArchivo: a.rutaArchivo,
    nombreOriginal: a.metadata?.originalName || a.descripcion || `${a.tipoArchivo} Adjunto`,
  }))
})

const totalDays = computed(() => {
  if (!marea.value?.etapas) return 0
  const intervals = marea.value.etapas.map((e: any) => ({
    start: e.fechaZarpada,
    end: e.fechaArribo
  }))
  return DateUtils.calculateUniqueDays(intervals)
})

const fetchDetail = async () => {
  if (!props.isOpen || !props.mareaId) return

  loading.value = true
  try {
    marea.value = await mareasService.getById(props.mareaId)
  } catch (error) {
    console.error('Error loading quick marea detail:', error)
    toast.error('No se pudo cargar el detalle de la marea.')
    emit('close')
  } finally {
    loading.value = false
  }
}

watch(() => props.isOpen, (newVal) => {
  if (newVal) {
    activeTab.value = 'detalle'
    fetchDetail()
  } else {
    marea.value = null
  }
})

const formatDate = (date: string | Date | null, withTime = false) => formatDateUI(date)

import { DateUtils } from '@/modules/shared/utils/date.utils'

const calculateStageDays = (etapa: any) => {
  return DateUtils.calculateInclusiveDays(etapa.fechaZarpada, etapa.fechaArribo)
}

const getStatusColor = (status: string) => {
  const s = status.toUpperCase()
  if (s.includes('FINALIZADA') || s.includes('PROTOCOLIZADA')) return 'success'
  if (s.includes('EJECUCION')) return 'primary'
  if (s.includes('CANCELADA')) return 'error'
  if (s.includes('DESIGNADA')) return 'info'
  return 'warning'
}

const goToFullMarea = () => {
  if (!props.mareaId) return
  emit('close')
  router.push(`/mareas/detalle/${props.mareaId}`)
}
</script>
