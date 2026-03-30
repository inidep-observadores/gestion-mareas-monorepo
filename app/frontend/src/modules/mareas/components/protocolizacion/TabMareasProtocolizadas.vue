<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between mb-4">
      <div>
        <h2 class="text-sm font-black uppercase tracking-widest text-text">Historial de Mareas Protocolizadas</h2>
        <p class="text-xs text-text-muted">Mareas que han finalizado correctamente su ciclo de protocolización.</p>
      </div>
    </div>

    <!-- Data Grid -->
    <div v-if="mareas.length > 0" class="grid gap-4 lg:grid-cols-2 2xl:grid-cols-3">
      <div 
        v-for="marea in mareas" 
        :key="marea.id"
        class="bg-surface border border-border rounded-2xl p-5 shadow-sm space-y-4 hover:shadow-md transition-shadow"
      >
        <div class="flex flex-col h-full">
          <!-- Top Row -->
          <div class="flex justify-between items-start mb-3">
            <span class="text-xs font-mono font-black text-text border border-border bg-surface-muted px-2.5 py-1 rounded-lg tracking-widest shadow-sm">
              {{ formatMareaCode(marea) }}
            </span>
            <div class="flex flex-col items-end gap-1">
              <div class="px-2 py-0.5 bg-success/10 border border-success/20 rounded-full text-[9px] font-black text-success uppercase tracking-tighter flex items-center gap-1">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-2.5 h-2.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                Protocolizada
              </div>
            </div>
          </div>

          <!-- Main Info -->
          <div class="mb-3 flex-1">
            <div class="flex items-center gap-2 mb-1">
              <ShipIcon class="w-3.5 h-3.5 text-primary shrink-0" />
              <h4 class="text-sm font-black text-text">{{ marea.buque?.nombreBuque || marea.buque_nombre }}</h4>
            </div>
            <div class="flex flex-col gap-0.5 ml-5">
              <p class="text-[10px] font-black text-text-muted uppercase tracking-tight">
                {{ marea.pesqueria?.nombre || 'General' }}
              </p>
              <p class="text-[9px] font-bold text-text-muted/70 italic leading-none">
                {{ marea.buque?.tipoFlota?.nombre || marea.buque?.tipoBuque || 'Flota desconocida' }}
              </p>
            </div>
            <p class="text-xs font-bold text-text-muted truncate mt-1 ml-5">
              {{ marea.observadorPrincipal ? (marea.observadorPrincipal.nombre + ' ' + marea.observadorPrincipal.apellido) : (marea.observador || 'Sin Observador') }}
            </p>
          </div>

          <!-- Divider -->
          <div class="my-4 border-t border-border/50"></div>

          <!-- Footer (Protocolización Data) -->
          <div class="flex items-center justify-between">
            <div class="flex flex-col">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-widest">Nro Protocolo</span>
              <span class="text-[11px] font-black text-text">
                {{ marea.nroProtocolizacion || marea.nro_protocolizacion }}-{{ marea.anioProtocolizacion || marea.anio_protocolizacion }}
              </span>
            </div>
            <div class="text-right flex flex-col">
              <span class="text-[9px] font-black text-text-muted/60 uppercase tracking-widest">Efectivizada en</span>
              <span class="text-[10px] font-bold text-primary">
                {{ formatDate(marea.fechaProtocolizacion || marea.fecha_protocolizacion) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Empty State -->
    <div v-else class="text-center py-20 bg-surface border border-dashed border-border rounded-2xl">
      <div class="w-16 h-16 rounded-full bg-surface-muted border border-border flex items-center justify-center mx-auto mb-4">
         <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8 text-text-muted" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
            <polyline points="22 4 12 14.01 9 11.01" />
         </svg>
      </div>
      <h3 class="text-sm font-black text-text uppercase tracking-widest">No hay historial disponible</h3>
      <p class="text-xs text-text-muted max-w-sm mx-auto mt-2">Las mareas aparecerán aquí una vez que completen el proceso de protocolización.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ShipIcon } from '@/icons'

const props = defineProps<{
  mareas: any[]
}>()

const formatMareaCode = (marea: any) => {
  const tipo = marea.tipo_marea || marea.tipoMarea || 'MC'
  const nro = marea.nro_marea || marea.nroMarea || '0'
  const anio = (marea.anio_marea || marea.anioMarea || 2026).toString().slice(-2)
  return `${tipo}-${nro}-${anio}`
}

const formatDate = (dateString: string) => {
  if (!dateString) return '-'
  return new Date(dateString).toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  })
}
</script>
