<template>
  <BaseModal :show="show" @close="close" title="Detalle de Novedad" maxWidth="3xl">
    <div v-if="novedad" class="flex flex-col gap-6 max-h-[75vh] overflow-y-auto custom-scrollbar pr-1">
      
      <!-- Encabezado / Badges de Estado -->
      <div class="flex flex-wrap items-center justify-between gap-3 p-4 bg-surface-muted/50 rounded-2xl border border-border">
        <div class="flex items-center gap-2.5">
          <span 
            class="px-3 py-1 rounded-full text-xs font-black uppercase tracking-wider border shadow-xs"
            :class="isDisponible 
              ? 'bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 border-emerald-500/30' 
              : 'bg-amber-500/10 text-amber-600 dark:text-amber-400 border-amber-500/30'"
          >
            {{ novedad.tipoNovedad?.descripcion || (isDisponible ? 'Disponible' : 'No disponible') }}
          </span>
          <span class="px-2.5 py-0.5 rounded-md text-[10px] font-black uppercase tracking-widest bg-success/10 text-success border border-success/20">
            {{ novedad.estadoAprobacion || 'APROBADA' }}
          </span>
        </div>

        <div class="flex items-center gap-2 text-[11px] text-text-muted">
          <span class="font-bold uppercase tracking-wider">Origen:</span>
          <span class="font-mono font-bold text-text bg-surface px-2 py-0.5 rounded border border-border">
            {{ novedad.origen || 'MANUAL' }}
          </span>
        </div>
      </div>

      <!-- Datos Principales en Tarjetas -->
      <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        <!-- Período -->
        <div class="p-4 bg-surface border border-border rounded-xl">
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Período de Disponibilidad</span>
          <p class="text-sm font-black text-text mt-1">
            {{ formatPeriodoTexto }}
          </p>
          <div class="flex items-center gap-4 mt-2 text-[11px] text-text-muted">
            <div>
              <span class="font-bold">Inicio:</span> {{ novedad.fechaInicio ? formatDate(novedad.fechaInicio) : '-' }}
            </div>
            <div>
              <span class="font-bold">Fin:</span> {{ novedad.fechaFin ? formatDate(novedad.fechaFin) : 'Indefinido' }}
            </div>
          </div>
        </div>

        <!-- Registro y Trazabilidad -->
        <div class="p-4 bg-surface border border-border rounded-xl">
          <span class="text-[10px] font-black uppercase tracking-widest text-text-muted">Registro y Responsable</span>
          <p class="text-sm font-black text-text mt-1">
            Registrada el {{ formatDate(novedad.fechaRegistro || novedad.fechaCreacion) }}
          </p>
          <p class="text-[11px] text-text-muted mt-2">
            <span class="font-bold">Registrado por:</span> 
            <span class="text-primary font-bold ml-1 uppercase">
              {{ novedad.creadoPor?.fullName || novedad.creadoPor?.email || 'ADMINISTRADOR SISTEMA' }}
            </span>
          </p>
        </div>
      </div>

      <!-- Urgencia Operativa -->
      <div class="flex items-center gap-3 p-3.5 bg-surface border border-border rounded-xl">
        <div 
          class="w-2.5 h-2.5 rounded-full"
          :class="novedad.permiteUrgencia ? 'bg-info' : 'bg-text-muted/40'"
        ></div>
        <p class="text-xs text-text">
          <span class="font-bold">Convocatoria anticipada por urgencia:</span>
          <span class="ml-1 font-bold" :class="novedad.permiteUrgencia ? 'text-info' : 'text-text-muted'">
            {{ novedad.permiteUrgencia ? 'Permitida' : 'No permitida' }}
          </span>
        </p>
      </div>

      <!-- Motivo / Observaciones -->
      <div v-if="novedad.motivo" class="space-y-1.5">
        <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Motivo / Observaciones</h4>
        <div class="p-4 bg-surface border border-border rounded-xl text-xs text-text leading-relaxed whitespace-pre-line shadow-xs">
          {{ novedad.motivo }}
        </div>
      </div>

      <!-- Mensaje Original de Email -->
      <div v-if="novedad.metadata?.body" class="space-y-1.5">
        <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Cuerpo del Mensaje Original (Email)</h4>
        <div class="p-4 bg-surface-muted/60 border border-border rounded-xl text-xs font-mono text-text leading-relaxed whitespace-pre-wrap max-h-48 overflow-y-auto custom-scrollbar shadow-inner">
          {{ novedad.metadata.body }}
        </div>
      </div>

      <!-- Archivos Adjuntos -->
      <div v-if="novedad.archivos && novedad.archivos.length > 0" class="space-y-2">
        <AttachmentViewer 
          :archivos="novedad.archivos" 
          title="Archivos Adjuntos" 
        />
      </div>

      <!-- Historial de Movimientos / Actividad Reciente -->
      <section v-if="novedad.movimientos && novedad.movimientos.length > 0" class="space-y-4 pt-2">
        <div class="flex items-center justify-between border-b border-border pb-2">
          <h4 class="text-[10px] font-black uppercase tracking-[0.2em] text-text-muted">Actividad Reciente</h4>
          <HistoryIcon class="w-4 h-4 text-text-muted/40" />
        </div>
        
        <div class="relative pl-6 space-y-6">
          <div class="absolute left-[7px] top-2 bottom-2 w-[1px] bg-border"></div>
          
          <div v-for="mov in sortedMovimientos" :key="mov.id" class="relative group">
            <div
              class="absolute -left-[23px] top-1.5 w-2 h-2 rounded-full border-2 border-surface bg-primary z-10 transition-transform group-hover:scale-125">
            </div>
            <div>
              <p class="text-[11px] font-bold text-text">{{ formatTipoEvento(mov.tipoEvento) }}</p>
              <div class="flex items-center gap-2 mt-0.5">
                <span class="text-[10px] text-text-muted font-mono">{{ formatDateEvent(mov.fechaHora) }}</span>
                <span class="w-1 h-1 rounded-full bg-border"></span>
                <span class="text-[10px] text-primary font-bold uppercase tracking-tighter">
                  {{ getUsuarioName(mov) }}
                </span>
              </div>
              <div v-if="mov.comentarios" class="mt-1.5 p-2 bg-surface-muted/40 border-l-2 border-primary/40 rounded-r-lg">
                <p class="text-[10px] text-text-muted leading-relaxed italic">
                  {{ mov.comentarios }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

    </div>

    <!-- Acciones Footer -->
    <div class="mt-6 pt-4 flex justify-end border-t border-border">
      <button 
        @click="close"
        class="px-6 py-2.5 bg-surface text-text-muted text-[10px] font-black uppercase tracking-widest rounded-xl border border-border hover:bg-surface-muted transition-all active:scale-95"
      >
        Cerrar
      </button>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import AttachmentViewer from '@/components/common/AttachmentViewer.vue'
import { HistoryIcon } from '@/icons'
import { formatDateUI, formatDateTimeUI } from '@/utils/date.utils'

const props = defineProps<{
  show: boolean
  novedad: any | null
}>()

const emit = defineEmits<{
  (e: 'close'): void
}>()

const close = () => {
  emit('close')
}

const formatDate = (dateStr?: string | Date | null) => {
  if (!dateStr) return '-'
  return formatDateUI(dateStr as string)
}

const formatDateEvent = (isoStr: string) => formatDateTimeUI(isoStr)

const isDisponible = computed(() => {
  const codigo = props.novedad?.codigo || props.novedad?.tipoNovedad?.codigo
  return codigo === 'DISPONIBLE'
})

const formatPeriodoTexto = computed(() => {
  if (!props.novedad) return '-'
  const hasInicio = !!props.novedad.fechaInicio
  const hasFin = !!props.novedad.fechaFin
  const prefix = isDisponible.value ? 'Disponible' : 'No disponible'

  if (hasInicio && hasFin) {
    return `${prefix} entre ${formatDate(props.novedad.fechaInicio)} y ${formatDate(props.novedad.fechaFin)}`
  }
  if (hasInicio) {
    return `${prefix} a partir del ${formatDate(props.novedad.fechaInicio)}`
  }
  if (hasFin) {
    return `${prefix} hasta el ${formatDate(props.novedad.fechaFin)}`
  }
  return `${prefix} sin fechas definidas`
})

const sortedMovimientos = computed(() => {
  if (!props.novedad?.movimientos) return []
  return [...props.novedad.movimientos].sort(
    (a, b) => new Date(b.fechaHora).getTime() - new Date(a.fechaHora).getTime()
  )
})

const getUsuarioName = (mov: any) => {
  if (mov.usuario) {
    return mov.usuario.fullName || mov.usuario.name || mov.usuario.email || 'SISTEMA'
  }
  return 'ADMINISTRADOR SISTEMA'
}

const formatTipoEvento = (tipo: string) => {
  const map: Record<string, string> = {
    'CREACION': 'Novedad Creada',
    'CREACION_EMAIL': 'Ingresada por Email',
    'CREACION_CORRECCION': 'Solicitud de Rectificación',
    'CREACION_AJUSTE_PERIODO': 'Solicitud con Ajuste de Período',
    'EDICION': 'Novedad Editada',
    'APROBACION': 'Novedad Aprobada',
    'APROBACION_ACTUALIZACION_CEDULA': 'Actualización de Cédula Aprobada',
    'APROBACION_CORRECCION': 'Rectificación Aprobada',
    'APROBACION_AJUSTE_PERIODO': 'Aprobación con Ajuste de Período',
    'RECHAZO': 'Novedad Rechazada',
    'RECHAZO_CORRECCION': 'Rectificación Rechazada',
    'RECHAZO_AJUSTE_PERIODO': 'Ajuste de Período Rechazado',
    'REEMPLAZADA_POR_EMAIL': 'Reemplazada por nuevo correo',
    'REEMPLAZADA_POR_CORRECCION': 'Reemplazada por rectificación',
    'REEMPLAZADA_POR_DISPONIBILIDAD': 'Reemplazada por nueva disponibilidad',
    'AJUSTE_POR_DISPONIBILIDAD': 'Período acotado por disponibilidad',
    'AJUSTE_POR_NO_DISPONIBILIDAD': 'Período acotado por no disponibilidad',
    'ELIMINACION': 'Novedad Eliminada',
    'BORRADO_LOGICO': 'Novedad Eliminada',
    'REVISION_AI': 'Revisión por IA',
  }
  return map[tipo] || (tipo || 'MOVIMIENTO DESCONOCIDO').replace(/_/g, ' ')
}
</script>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: var(--color-border);
  border-radius: 10px;
}
</style>

