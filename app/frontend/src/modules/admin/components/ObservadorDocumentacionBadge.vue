<template>
  <div class="relative inline-flex items-center group">
    <!-- Icono condicional: Check circular si está al día, Triángulo de advertencia para alertas o sin datos -->
    <div 
      class="inline-flex items-center justify-center p-1 rounded-full transition-transform group-hover:scale-110 cursor-help"
      :class="colorClasses.container"
    >
      <!-- Tilde / Check circular cuando la documentación está al día -->
      <svg 
        v-if="docStatus.estado === 'al_dia'"
        xmlns="http://www.w3.org/2000/svg" 
        viewBox="0 0 24 24" 
        fill="currentColor" 
        class="w-4 h-4"
        :class="colorClasses.icon"
      >
        <path fill-rule="evenodd" d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12zm13.36-1.814a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.74-5.25z" clip-rule="evenodd" />
      </svg>
      <!-- Triángulo de advertencia para casos de vencimiento o sin registrar -->
      <svg 
        v-else
        xmlns="http://www.w3.org/2000/svg" 
        viewBox="0 0 24 24" 
        fill="currentColor" 
        class="w-4 h-4"
        :class="colorClasses.icon"
      >
        <path fill-rule="evenodd" d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.4 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z" clip-rule="evenodd" />
      </svg>
    </div>

    <!-- Tooltip Flotante Mejorado -->
    <div 
      class="absolute left-1/2 -translate-x-1/2 bottom-full mb-2 hidden group-hover:flex flex-col z-[100] w-64 p-2.5 bg-gray-900/95 dark:bg-gray-950/95 backdrop-blur-sm text-white text-xs rounded-xl shadow-xl border border-gray-700/50 pointer-events-none transition-opacity duration-200"
    >
      <!-- Cabecera Tooltip -->
      <div class="flex items-center gap-1.5 pb-1.5 mb-1.5 border-b border-gray-700/60 font-black tracking-tight text-[11px]" :class="colorClasses.headerText">
        <span class="w-2 h-2 rounded-full" :class="colorClasses.bullet"></span>
        {{ headerTitle }}
      </div>

      <!-- Detalle Cédula -->
      <div class="space-y-1 text-[11px] leading-relaxed">
        <div class="flex flex-col">
          <span class="text-gray-400 font-medium">Cédula de Embarque:</span>
          <span class="font-bold text-gray-200">
            {{ docStatus.detalles.cedula.numero ? `Nº ${docStatus.detalles.cedula.numero}` : 'Sin número' }}
            <template v-if="docStatus.detalles.cedula.vencimiento">
              - Vto: {{ docStatus.detalles.cedula.vencimiento }}
              <span v-if="docStatus.detalles.cedula.vencido" class="text-error font-extrabold ml-1">
                (Vencida)
              </span>
              <span v-else-if="docStatus.detalles.cedula.dias !== null && docStatus.detalles.cedula.dias < 60" class="text-warning font-extrabold ml-1">
                ({{ docStatus.detalles.cedula.dias }}d)
              </span>
            </template>
            <template v-else>
              <span class="text-gray-500 italic ml-1">(Sin fecha)</span>
            </template>
          </span>
        </div>

        <!-- Detalle Apto Médico -->
        <div class="flex flex-col pt-1 border-t border-gray-800/80">
          <span class="text-gray-400 font-medium">Apto Médico:</span>
          <span class="font-bold text-gray-200">
            <template v-if="docStatus.detalles.aptoMedico.vencimiento">
              Vto: {{ docStatus.detalles.aptoMedico.vencimiento }}
              <span v-if="docStatus.detalles.aptoMedico.vencido" class="text-error font-extrabold ml-1">
                (Vencido)
              </span>
              <span v-else-if="docStatus.detalles.aptoMedico.dias !== null && docStatus.detalles.aptoMedico.dias < 60" class="text-warning font-extrabold ml-1">
                ({{ docStatus.detalles.aptoMedico.dias }}d)
              </span>
            </template>
            <template v-else>
              <span class="text-gray-500 italic">Sin registrar</span>
            </template>
          </span>
        </div>

        <!-- Fecha Actualización -->
        <div v-if="docStatus.detalles.ultimaActualizacion" class="pt-1.5 mt-1 border-t border-gray-800/80 text-[10px] text-gray-400 flex items-center justify-between">
          <span>Actualizado:</span>
          <span class="font-semibold text-gray-300">{{ docStatus.detalles.ultimaActualizacion }}</span>
        </div>
      </div>

      <!-- Flechita del tooltip -->
      <div class="absolute left-1/2 -translate-x-1/2 top-full w-0 h-0 border-x-4 border-x-transparent border-t-4 border-t-gray-900/95 dark:border-t-gray-950/95"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import type { Observador } from '../interfaces/observador.interface';
import { calcularEstadoDocumentacion } from '../utils/observador-documentacion';

const props = defineProps<{
  observador?: Partial<Observador> | null;
}>();

const docStatus = computed(() => calcularEstadoDocumentacion(props.observador));

const colorClasses = computed(() => {
  switch (docStatus.value.color) {
    case 'red':
      return {
        container: 'bg-error/10 hover:bg-error/20',
        icon: 'text-error',
        headerText: 'text-error',
        bullet: 'bg-error'
      };
    case 'yellow':
      return {
        container: 'bg-warning/15 hover:bg-warning/25',
        icon: 'text-amber-500 dark:text-warning',
        headerText: 'text-amber-400 dark:text-warning',
        bullet: 'bg-warning'
      };
    case 'green':
      return {
        container: 'bg-success/10 hover:bg-success/20',
        icon: 'text-success',
        headerText: 'text-success',
        bullet: 'bg-success'
      };
    case 'gray':
    default:
      return {
        container: 'bg-gray-500/10 hover:bg-gray-500/20',
        icon: 'text-gray-400 dark:text-gray-500',
        headerText: 'text-gray-300',
        bullet: 'bg-gray-400'
      };
  }
});

const headerTitle = computed(() => {
  switch (docStatus.value.estado) {
    case 'vencido':
      return docStatus.value.diasMinimos !== null && docStatus.value.diasMinimos < 0
        ? 'DOCUMENTACIÓN VENCIDA'
        : 'VENCIMIENTO CRÍTICO (<30 DÍAS)';
    case 'por_vencer':
      return 'PRÓXIMO A VENCER (<2 MESES)';
    case 'al_dia':
      return 'DOCUMENTACIÓN AL DÍA';
    case 'sin_datos':
    default:
      return 'DOCUMENTACIÓN SIN REGISTRAR';
  }
});
</script>
