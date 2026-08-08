<template>
  <div class="flex h-full flex-col bg-surface">
    <!-- Encabezado -->
    <div class="px-4 py-4 sm:px-5 bg-surface-muted border-b border-border flex items-center justify-between">
      <h2 class="text-sm font-black text-text uppercase tracking-wide">
        Detalles de la Novedad
      </h2>
      <button type="button" class="rounded-md text-text-muted hover:text-text focus:outline-none focus:ring-2 focus:ring-primary p-1 transition-colors" @click="closePanel">
        <span class="sr-only">Cerrar panel</span>
        <XIcon class="h-4 w-4" aria-hidden="true" />
      </button>
    </div>

    <!-- Contenido -->
    <div class="relative flex-1 px-4 py-5 overflow-y-auto custom-scrollbar">
      <div v-if="novedad" class="flex flex-col gap-5">
        
        <!-- Resumen de Novedad -->
        <div class="flex flex-col gap-4">
          <div>
            <p class="text-[10px] uppercase font-black text-text-muted mb-1">Observador</p>
            <p class="text-sm font-bold text-text">{{ novedad.observador?.apellido }}, {{ novedad.observador?.nombre }}</p>
          </div>
          
          <div class="grid grid-cols-2 gap-4">
            <div>
              <p class="text-[10px] uppercase font-black text-text-muted mb-1">Tipo / Origen</p>
              <div class="flex flex-col gap-1 items-start">
                <span class="bg-info/10 text-info text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">
                  {{ novedad.tipoNovedad?.descripcion || 'Desconocido' }}
                </span>
                <span class="bg-surface-muted text-text-muted text-[10px] font-bold px-2 py-0.5 rounded-full border border-border uppercase">
                  {{ novedad.origen || 'MANUAL' }}
                </span>
              </div>
            </div>
            
            <div>
              <p class="text-[10px] uppercase font-black text-text-muted mb-1">Estado</p>
              <span v-if="novedad.activo === false" class="bg-error/10 text-error text-xs font-black px-2 py-1 rounded-md uppercase border border-error/20">ELIMINADA</span>
              <span v-else-if="novedad.estadoAprobacion === 'PENDIENTE'" class="bg-warning/10 text-warning text-xs font-black px-2 py-1 rounded-md uppercase border border-warning/20">PENDIENTE</span>
              <span v-else-if="novedad.estadoAprobacion === 'RECHAZADA'" class="bg-error/10 text-error text-xs font-black px-2 py-1 rounded-md uppercase border border-error/20">RECHAZADA</span>
              <span v-else class="bg-success/10 text-success text-xs font-black px-2 py-1 rounded-md uppercase border border-success/20">APROBADA</span>
            </div>
          </div>
          
          <div>
            <p class="text-[10px] uppercase font-black text-text-muted mb-1">Período</p>
            <p class="text-sm font-mono font-bold text-text">
              {{ formatDate(novedad.fechaInicio) }} - {{ novedad.fechaFin ? formatDate(novedad.fechaFin) : '...' }}
            </p>
          </div>
          
          <div v-if="novedad.motivo">
            <p class="text-[10px] uppercase font-black text-text-muted mb-1">Motivo / Descripción</p>
            <p class="text-xs text-text bg-surface-muted p-2.5 rounded border border-border leading-relaxed">{{ novedad.motivo }}</p>
          </div>
        </div>

        <!-- Metadatos de IA (si existen) -->
        <div v-if="novedad.metadata" class="bg-primary/5 p-3 rounded-lg border border-primary/20 mt-2">
          <p class="text-[10px] font-black text-primary uppercase mb-2 flex items-center gap-1">
            <SparklesIcon class="w-3 h-3" v-if="SparklesIcon" /> Datos Extraídos desde Documento
          </p>
          <ul class="text-xs space-y-1.5 text-text">
            <li v-if="novedad.metadata.numeroGde"><span class="font-bold">GDE:</span> {{ novedad.metadata.numeroGde }}</li>
            <li v-if="novedad.metadata.certezaAi"><span class="font-bold">Certeza de Observador:</span> {{ novedad.metadata.certezaAi }}</li>
            <li v-if="novedad.metadata.requiereRevision !== undefined">
              <span class="font-bold" :class="novedad.metadata.requiereRevision ? 'text-warning' : 'text-success'">
                Requiere Revisión: {{ novedad.metadata.requiereRevision ? 'Sí' : 'No' }}
              </span>
            </li>
          </ul>
        </div>

        <!-- Previsualización del Archivo -->
        <AttachmentViewer 
          v-if="hasFile" 
          :archivos="novedad.archivos || []" 
          title="Archivo Adjunto" 
          class="mt-2" 
        />

        <!-- Historial de Movimientos -->
        <section v-if="novedad.movimientos && novedad.movimientos.length > 0" class="space-y-4 pb-4 mt-2">
          <div class="flex items-center justify-between">
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
                <div v-if="mov.comentarios" class="mt-1.5 p-2 bg-surface-muted/30 border-l-2 border-primary/30 rounded-r-lg">
                  <p class="text-[10px] text-text-muted leading-relaxed italic">
                    {{ mov.comentarios }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>

      </div>
      <div v-else class="flex flex-col items-center justify-center h-full text-center p-6">
        <div class="w-12 h-12 bg-surface-muted rounded-full flex items-center justify-center mb-3">
          <FileTextIcon class="w-6 h-6 text-text-muted/40" />
        </div>
        <p class="text-text-muted font-bold text-sm">Seleccione una novedad</p>
        <p class="text-text-muted/70 text-xs mt-1">Haga clic en una fila para ver sus detalles</p>
      </div>
    </div>

    <!-- Pie / Acciones -->
    <div v-if="!readonly && novedad && novedad.activo !== false" class="border-t border-border bg-surface-muted/50 p-4 flex flex-col gap-2">
      <template v-if="novedad.estadoAprobacion === 'PENDIENTE'">
        <button type="button" @click="$emit('approve', novedad)" class="w-full flex justify-center items-center gap-2 rounded-lg bg-success px-3 py-2 text-sm font-bold text-white shadow-sm hover:bg-success-hover transition-colors active:scale-[0.98]">
          <CheckIcon class="w-4 h-4" /> Aprobar
        </button>
        <div class="flex gap-2">
          <button type="button" @click="$emit('reject', novedad)" class="flex-1 flex justify-center items-center gap-1 rounded-lg bg-error/10 px-3 py-2 text-sm font-bold text-error shadow-sm hover:bg-error/20 transition-colors active:scale-[0.98] border border-error/20">
            Rechazar
          </button>
          <button type="button" @click="$emit('edit', novedad)" class="flex-1 flex justify-center items-center gap-1 rounded-lg bg-surface px-3 py-2 text-sm font-bold text-text shadow-sm ring-1 ring-inset ring-border hover:bg-surface-muted transition-colors active:scale-[0.98]">
            <EditIcon class="w-4 h-4" /> Editar
          </button>
          <button type="button" @click="$emit('delete', novedad)" class="flex-1 flex justify-center items-center gap-1 rounded-lg bg-surface px-3 py-2 text-sm font-bold text-error shadow-sm ring-1 ring-inset ring-border hover:bg-surface-muted transition-colors active:scale-[0.98]">
            <TrashIcon class="w-4 h-4" /> Borrar
          </button>
        </div>
      </template>
      <template v-else-if="novedad.estadoAprobacion !== 'RECHAZADA'">
        <div class="flex gap-2">
          <button type="button" @click="$emit('edit', novedad)" class="flex-1 flex justify-center items-center gap-1 rounded-lg bg-surface px-3 py-2 text-sm font-bold text-text shadow-sm ring-1 ring-inset ring-border hover:bg-surface-muted transition-colors active:scale-[0.98]">
            <EditIcon class="w-4 h-4" /> Editar
          </button>
          <button type="button" @click="$emit('delete', novedad)" class="flex-1 flex justify-center items-center gap-1 rounded-lg bg-surface px-3 py-2 text-sm font-bold text-error shadow-sm ring-1 ring-inset ring-border hover:bg-surface-muted transition-colors active:scale-[0.98]">
            <TrashIcon class="w-4 h-4" /> Borrar
          </button>
        </div>
      </template>
      <template v-else>
        <button type="button" @click="$emit('delete', novedad)" class="w-full flex justify-center items-center gap-1 rounded-lg bg-surface px-3 py-2 text-sm font-bold text-error shadow-sm ring-1 ring-inset ring-border hover:bg-surface-muted transition-colors active:scale-[0.98]">
          <TrashIcon class="w-4 h-4" /> Borrar
        </button>
      </template>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Novedad } from '../interfaces/novedad.interface';

import { XIcon, ArrowRightIcon as ExternalLinkIcon, CheckIcon, EditIcon, FileTextIcon, HistoryIcon, TrashIcon } from '@/icons';
// Si tienes un icono Sparkles, lo importas, si no usamos otro
import { SettingsIcon as SparklesIcon } from '@/icons';
import AttachmentViewer from '@/components/common/AttachmentViewer.vue';

const props = defineProps<{
  novedad: Novedad | null;
  readonly?: boolean;
}>();

const emit = defineEmits(['close', 'approve', 'reject', 'edit', 'delete']);

const closePanel = () => {
  emit('close');
};

const formatDate = (isoStr: string) => {
  if (!isoStr) return '';
  const date = new Date(isoStr);
  return date.toLocaleDateString('es-AR', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });
};

const hasFile = computed(() => {
  return props.novedad?.archivos && props.novedad.archivos.length > 0;
});

const sortedMovimientos = computed(() => {
  if (!props.novedad?.movimientos) return [];
  return [...props.novedad.movimientos].sort((a, b) => new Date(b.fechaHora).getTime() - new Date(a.fechaHora).getTime());
});

const formatDateEvent = (isoStr: string) => {
  if (!isoStr) return '';
  const date = new Date(isoStr);
  return date.toLocaleDateString('es-AR') + ' ' + date.toLocaleTimeString('es-AR', { hour: '2-digit', minute: '2-digit', hour12: false });
};

const getUsuarioName = (mov: any) => {
  if (mov.usuario) {
    return mov.usuario.fullName || mov.usuario.name || mov.usuario.email || 'SISTEMA';
  }
  return 'ADMINISTRADOR SISTEMA';
};

const formatTipoEvento = (tipo: string) => {
  const map: Record<string, string> = {
    'CREACION': 'Novedad Creada',
    'EDICION': 'Novedad Editada',
    'APROBACION': 'Novedad Aprobada',
    'RECHAZO': 'Novedad Rechazada',
    'ELIMINACION': 'Novedad Eliminada',
    'BORRADO_LOGICO': 'Novedad Eliminada',
    'REVISION_AI': 'Revisión por IA',
  };
  return map[tipo] || (tipo || 'MOVIMIENTO DESCONOCIDO').replace(/_/g, ' ');
};
</script>
