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
            {{ mareaCode }}
          </h3>
          <p class="text-[10px] font-bold text-text-muted uppercase tracking-wider">
            Detalle Operativo Rápido
          </p>
        </div>
        <div v-else class="h-10 w-32 bg-surface-muted animate-pulse rounded-lg"></div>
      </div>
    </template>

    <div class="space-y-6 py-2">
      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-20 gap-4">
        <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-primary"></div>
        <p class="text-xs font-bold text-text-muted animate-pulse uppercase tracking-widest">Cargando detalles...</p>
      </div>

      <!-- Content -->
      <div v-else-if="marea" class="space-y-6">
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
            <div class="flex flex-col leading-tight">
               <span class="text-xs font-bold text-text">
                 {{ formatDate(marea.fechaInicioObservador || marea.fechaZarpadaEstimada) }}
               </span>
               <span class="text-[9px] font-bold text-text-muted">
                 al {{ marea.fechaFinObservador ? formatDate(marea.fechaFinObservador) : 'En ejecución' }}
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

        <!-- Actions -->
        <div class="flex items-center justify-between pt-4 border-t border-border mt-2">
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
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { useRouter } from 'vue-router'
import BaseModal from '@/components/common/BaseModal.vue'
import Button from '@/components/ui/Button.vue'
import Badge from '@/components/ui/Badge.vue'
import { FileTextIcon, ExternalLinkIcon } from 'lucide-vue-next'
import mareasService from '@/modules/mareas/services/mareas.service'
import { toast } from 'vue-sonner'

const props = defineProps<{
  isOpen: boolean
  mareaId: string | null
}>()

const emit = defineEmits(['close'])
const router = useRouter()

const loading = ref(false)
const marea = ref<any>(null)

const mareaCode = computed(() => {
  if (!marea.value) return ''
  const prefix = marea.value.tipoMarea === 'CI' ? 'CI' : 'MC'
  const shortYear = String(marea.value.anioMarea).slice(-2)
  return `${prefix}-${marea.value.nroMarea}-${shortYear}`
})

const totalDays = computed(() => {
  if (!marea.value?.etapas) return 0
  return marea.value.etapas.reduce((acc: number, e: any) => acc + calculateStageDays(e), 0)
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
  if (newVal) fetchDetail()
  else marea.value = null
})

const formatDate = (date: string | Date | null, withTime = false) => {
  if (!date) return '-'
  const d = new Date(date)
  if (isNaN(d.getTime())) return '-'
  
  const day = String(d.getDate()).padStart(2, '0')
  const month = String(d.getMonth() + 1).padStart(2, '0')
  const year = d.getFullYear()
  
  if (withTime) {
    const hours = String(d.getHours()).padStart(2, '0')
    const minutes = String(d.getMinutes()).padStart(2, '0')
    return `${day}/${month}/${year} ${hours}:${minutes}`
  }
  
  return `${day}/${month}/${year}`
}

const calculateStageDays = (etapa: any) => {
  if (!etapa.fechaZarpada) return 0
  const start = new Date(etapa.fechaZarpada)
  const end = etapa.fechaArribo ? new Date(etapa.fechaArribo) : new Date()
  
  const diffTime = Math.abs(end.getTime() - start.getTime())
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24))
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
  router.push(`/mareas/${props.mareaId}`)
}
</script>
