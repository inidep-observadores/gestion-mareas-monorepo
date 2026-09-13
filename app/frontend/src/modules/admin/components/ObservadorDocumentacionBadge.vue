<template>
  <div 
    ref="triggerRef"
    class="relative inline-flex items-center group"
    @mouseenter="showTooltip"
    @mouseleave="hideTooltip"
  >
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

    <!-- Tooltip Flotante renderizado en body mediante Teleport para nunca recortarse por overflow ni z-index -->
    <Teleport to="body">
      <Transition
        enter-active-class="transition duration-150 ease-out"
        enter-from-class="opacity-0 scale-95"
        enter-to-class="opacity-100 scale-100"
        leave-active-class="transition duration-100 ease-in"
        leave-from-class="opacity-100 scale-100"
        leave-to-class="opacity-0 scale-95"
      >
        <div 
          v-if="isVisible"
          ref="tooltipRef"
          class="fixed z-[200060] w-[260px] p-2.5 bg-gray-900/95 dark:bg-gray-950/95 backdrop-blur-sm text-white text-xs rounded-xl shadow-2xl border border-gray-700/60 pointer-events-none"
          :class="actualPlacement === 'top' ? '-translate-y-full origin-bottom' : 'origin-top'"
          :style="tooltipFloatingStyle"
        >
          <!-- Cabecera Tooltip -->
          <div class="flex items-center gap-1.5 pb-1.5 mb-1.5 border-b border-gray-700/60 font-black tracking-tight text-[11px]" :class="colorClasses.headerText">
            <span class="w-2 h-2 rounded-full shrink-0" :class="colorClasses.bullet"></span>
            <span class="truncate">{{ headerTitle }}</span>
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

          <!-- Flechita del tooltip alineada con precisión al icono trigger -->
          <div 
            class="absolute w-0 h-0 border-x-4 border-x-transparent -translate-x-1/2"
            :class="actualPlacement === 'bottom' ? 'bottom-full border-b-4 border-b-gray-900/95 dark:border-b-gray-950/95' : 'top-full border-t-4 border-t-gray-900/95 dark:border-t-gray-950/95'"
            :style="{ left: `${arrowOffset}px` }"
          ></div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onBeforeUnmount } from 'vue';
import type { Observador } from '../interfaces/observador.interface';
import { calcularEstadoDocumentacion } from '../utils/observador-documentacion';

const props = withDefaults(defineProps<{
  observador?: Partial<Observador> | null;
  placement?: 'auto' | 'top' | 'bottom';
  align?: 'center' | 'left' | 'right';
}>(), {
  placement: 'auto',
  align: 'center'
});

const triggerRef = ref<HTMLElement | null>(null);
const tooltipRef = ref<HTMLElement | null>(null);
const isVisible = ref(false);

const coords = ref({ top: 0, left: 0 });
const actualPlacement = ref<'top' | 'bottom'>('top');
const arrowOffset = ref(130);

const TOOLTIP_WIDTH = 260;
const TOOLTIP_ESTIMATED_HEIGHT = 160;

const updatePosition = () => {
  if (!triggerRef.value) return;

  const rect = triggerRef.value.getBoundingClientRect();
  const triggerCenterX = rect.left + rect.width / 2;

  // 1. Determinar colocación vertical
  if (props.placement === 'bottom') {
    actualPlacement.value = 'bottom';
  } else if (props.placement === 'top') {
    actualPlacement.value = 'top';
  } else {
    // Modo 'auto': Si no hay espacio suficiente arriba (menos de la altura del tooltip + margen), colocar abajo
    actualPlacement.value = rect.top < TOOLTIP_ESTIMATED_HEIGHT + 16 ? 'bottom' : 'top';
  }

  // 2. Coordenada Y (top)
  if (actualPlacement.value === 'bottom') {
    coords.value.top = rect.bottom + 8;
  } else {
    // Al usar -translate-y-full en CSS, la base del tooltip se apoya en esta coordenada
    coords.value.top = rect.top - 8;
  }

  // 3. Coordenada X (left) y Flecha
  let targetLeft = triggerCenterX - TOOLTIP_WIDTH / 2;

  if (props.align === 'right') {
    targetLeft = rect.right - TOOLTIP_WIDTH;
  } else if (props.align === 'left') {
    targetLeft = rect.left;
  }

  // Evitar que se desborde fuera de la ventana del navegador
  const minLeft = 12;
  const maxLeft = window.innerWidth - TOOLTIP_WIDTH - 12;
  const clampedLeft = Math.max(minLeft, Math.min(targetLeft, maxLeft));

  coords.value.left = clampedLeft;

  // Flecha apuntando al centro del trigger
  const relativeArrowX = triggerCenterX - clampedLeft;
  arrowOffset.value = Math.max(16, Math.min(relativeArrowX, TOOLTIP_WIDTH - 16));
};

const handleScroll = () => {
  if (isVisible.value) {
    // Ocultar al hacer scroll para evitar desfasajes con contenedores con scroll interno
    hideTooltip();
  }
};

const showTooltip = () => {
  updatePosition();
  isVisible.value = true;
  window.addEventListener('scroll', handleScroll, true);
  window.addEventListener('resize', handleScroll);
};

const hideTooltip = () => {
  isVisible.value = false;
  window.removeEventListener('scroll', handleScroll, true);
  window.removeEventListener('resize', handleScroll);
};

onBeforeUnmount(() => {
  window.removeEventListener('scroll', handleScroll, true);
  window.removeEventListener('resize', handleScroll);
});

const tooltipFloatingStyle = computed(() => ({
  top: `${coords.value.top}px`,
  left: `${coords.value.left}px`
}));

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
