<template>
  <BaseModal :show="show" title="Ficha del Observador" @close="emit('close')" maxWidth="md" variant="default">
    <!-- Contenedor Principal -->
    <div class="flex flex-col p-5">
      <!-- Loading State -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-10 gap-3">
        <div class="w-8 h-8 border-3 border-primary border-t-transparent rounded-full animate-spin"></div>
        <span class="text-xs font-bold text-text-muted">Cargando datos del observador...</span>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="flex flex-col items-center justify-center py-8 gap-2 text-center">
        <p class="text-xs font-bold text-error">{{ error }}</p>
        <button
          @click="fetchObservador"
          class="px-3 py-1.5 text-xs font-bold bg-surface-muted hover:bg-surface-muted/80 text-text rounded-lg border border-border transition-colors"
        >
          Reintentar
        </button>
      </div>

      <!-- Ficha de Datos -->
      <div v-else-if="observadorData" class="space-y-4">
        <!-- Cabecera con Foto (tamaño aumentado 50%: 96x96px), Nombre, Alerta y Legajo -->
        <div class="flex items-center gap-4 bg-surface-muted/40 p-3.5 rounded-2xl border border-border/60">
          <!-- Foto o Iniciales -->
          <div class="relative shrink-0">
            <div class="w-24 h-24 rounded-full overflow-hidden bg-surface-muted flex items-center justify-center border-2 border-primary/30 shadow-sm">
              <img
                v-if="fotoUrl && !imageFailed"
                :src="getFullImageUrl(fotoUrl)"
                :alt="fullName"
                class="w-full h-full object-cover"
                @error="imageFailed = true"
              />
              <span v-else-if="initials" class="text-2xl font-black text-primary leading-none uppercase">
                {{ initials }}
              </span>
              <UserCircleIcon v-else class="w-16 h-16 text-text-muted" />
            </div>
          </div>

          <!-- Nombre y Legajo -->
          <div class="min-w-0 flex-1">
            <div class="flex items-center gap-2 flex-wrap">
              <h3 class="text-base font-extrabold text-text leading-snug" :title="fullName">
                {{ fullName }}
              </h3>
              <!-- Ícono de alerta de vencimientos si corresponde -->
              <ObservadorDocumentacionBadge :observador="observadorData" only-warnings />
            </div>

            <!-- Legajo y DNI -->
            <div class="flex items-center gap-2 mt-2 text-xs flex-wrap">
              <span class="px-2 py-0.5 rounded-md font-black text-[10px] tracking-wider uppercase bg-primary/10 text-primary border border-primary/20">
                LEGAJO: {{ observadorData.codigoInterno ?? 'S/D' }}
              </span>
              <span class="text-text-muted font-medium text-[11px]">
                DNI: <strong class="text-text">{{ observadorData.dni || 'Sin registrar' }}</strong>
              </span>
            </div>
          </div>
        </div>

        <!-- Sección de Vencimientos / Documentación de Embarque -->
        <div class="space-y-2">
          <div class="flex items-center justify-between px-0.5">
            <span class="text-[10px] font-black uppercase tracking-wider text-text-muted">
              Documentación y Vencimientos
            </span>
            <span v-if="docStatus.detalles.ultimaActualizacion" class="text-[9px] text-text-muted/70 italic">
              Act: {{ docStatus.detalles.ultimaActualizacion }}
            </span>
          </div>

          <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5">
            <!-- Cédula de Embarque -->
            <div class="p-3 rounded-xl border border-border/80 bg-surface flex flex-col gap-1 shadow-2xs">
              <span class="text-[10px] font-bold uppercase tracking-wider text-text-muted">
                Cédula de Embarque
              </span>
              <div class="text-xs font-black text-text">
                {{ docStatus.detalles.cedula.numero ? `Nº ${docStatus.detalles.cedula.numero}` : 'Sin número' }}
              </div>
              <div class="text-[11px] font-medium flex items-center justify-between mt-0.5 pt-1 border-t border-border/40">
                <span class="text-text-muted">Vto:</span>
                <span v-if="docStatus.detalles.cedula.vencimiento" class="font-bold text-text">
                  {{ docStatus.detalles.cedula.vencimiento }}
                </span>
                <span v-else class="text-text-muted italic text-[10px]">Sin fecha</span>
              </div>
              <!-- Badge de estado Cédula -->
              <div class="mt-1">
                <span
                  v-if="!docStatus.detalles.cedula.vencimiento"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-bold uppercase bg-surface-muted text-text-muted border border-border/60"
                >
                  No registrada
                </span>
                <span
                  v-else-if="docStatus.detalles.cedula.vencido"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-error/15 text-error border border-error/30"
                >
                  Vencida
                </span>
                <span
                  v-else-if="docStatus.detalles.cedula.dias !== null && docStatus.detalles.cedula.dias < 60"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-warning/15 text-warning border border-warning/30"
                >
                  Vence en {{ docStatus.detalles.cedula.dias }} d
                </span>
                <span
                  v-else
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-success/15 text-success border border-success/30"
                >
                  Al día
                </span>
              </div>
            </div>

            <!-- Apto Médico -->
            <div class="p-3 rounded-xl border border-border/80 bg-surface flex flex-col gap-1 shadow-2xs">
              <span class="text-[10px] font-bold uppercase tracking-wider text-text-muted">
                Apto Médico
              </span>
              <div class="text-xs font-black text-text">
                {{ docStatus.detalles.aptoMedico.vencimiento ? 'Registrado' : 'Sin registrar' }}
              </div>
              <div class="text-[11px] font-medium flex items-center justify-between mt-0.5 pt-1 border-t border-border/40">
                <span class="text-text-muted">Vto:</span>
                <span v-if="docStatus.detalles.aptoMedico.vencimiento" class="font-bold text-text">
                  {{ docStatus.detalles.aptoMedico.vencimiento }}
                </span>
                <span v-else class="text-text-muted italic text-[10px]">Sin fecha</span>
              </div>
              <!-- Badge de estado Apto -->
              <div class="mt-1">
                <span
                  v-if="!docStatus.detalles.aptoMedico.vencimiento"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-bold uppercase bg-surface-muted text-text-muted border border-border/60"
                >
                  No registrado
                </span>
                <span
                  v-else-if="docStatus.detalles.aptoMedico.vencido"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-error/15 text-error border border-error/30"
                >
                  Vencido
                </span>
                <span
                  v-else-if="docStatus.detalles.aptoMedico.dias !== null && docStatus.detalles.aptoMedico.dias < 60"
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-warning/15 text-warning border border-warning/30"
                >
                  Vence en {{ docStatus.detalles.aptoMedico.dias }} d
                </span>
                <span
                  v-else
                  class="inline-flex px-1.5 py-0.5 rounded text-[9px] font-black uppercase bg-success/15 text-success border border-success/30"
                >
                  Al día
                </span>
              </div>
            </div>
          </div>
        </div>

        <!-- Botón de Cierre -->
        <div class="flex items-center justify-end pt-3 border-t border-border/80">
          <button
            @click="emit('close')"
            class="px-5 py-2 bg-surface text-text-muted hover:text-text hover:bg-surface-muted text-xs font-bold rounded-xl border border-border transition-colors"
          >
            Cerrar
          </button>
        </div>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import ObservadorDocumentacionBadge from './ObservadorDocumentacionBadge.vue'
import { getFullImageUrl } from '@/helpers/image.helper'
import { UserCircleIcon } from '@/icons'
import observadoresApi from '../services/observadores.service'
import type { Observador } from '../interfaces/observador.interface'
import { calcularEstadoDocumentacion } from '../utils/observador-documentacion'

const props = defineProps<{
  show: boolean
  observadorId?: string | null
  observador?: Partial<Observador> | null
  nombreFallback?: string | null
  fotoUrlFallback?: string | null
}>()

const emit = defineEmits<{
  (e: 'close'): void
}>()

const loading = ref(false)
const error = ref<string | null>(null)
const imageFailed = ref(false)
const fetchedObservador = ref<Observador | null>(null)

// Objeto combinado: prioridad al fetch si se hizo, luego a los props pasados
const observadorData = computed<Partial<Observador> | null>(() => {
  if (fetchedObservador.value) {
    return fetchedObservador.value
  }
  if (props.observador) {
    return props.observador
  }
  if (props.observadorId) {
    return {
      id: props.observadorId,
      nombre: props.nombreFallback || '',
      apellido: '',
      fotoUrl: props.fotoUrlFallback || undefined
    }
  }
  return null
})

const fotoUrl = computed(() => {
  return observadorData.value?.fotoUrl || props.fotoUrlFallback || null
})

const fullName = computed(() => {
  const data = observadorData.value
  if (data?.apellido && data?.nombre) {
    return `${data.apellido}, ${data.nombre}`
  }
  if (data?.nombre) {
    return data.nombre
  }
  return props.nombreFallback || 'Observador'
})

const initials = computed(() => {
  const name = fullName.value.trim()
  if (!name || name === 'Sin asignar' || name === 'No asignado' || name === 'Observador') return ''
  const parts = name.replace(',', '').split(/\s+/)
  return `${parts[0]?.[0] ?? ''}${parts.length > 1 ? parts[parts.length - 1][0] : ''}`
})

const docStatus = computed(() => {
  return calcularEstadoDocumentacion(observadorData.value)
})

const fetchObservador = async () => {
  const targetId = props.observadorId || props.observador?.id
  if (!targetId) return

  // Si ya tenemos los datos clave cargados por props, evitamos la petición HTTP
  const hasCompleteData =
    props.observador &&
    (props.observador.codigoInterno !== undefined || props.observador.dni !== undefined)

  if (hasCompleteData) {
    return
  }

  loading.value = true
  error.value = null
  try {
    const data = await observadoresApi.getObservador(targetId)
    fetchedObservador.value = data
  } catch (err) {
    console.error('Error al cargar datos del observador:', err)
    error.value = 'No se pudo cargar la información del observador'
  } finally {
    loading.value = false
  }
}

watch(
  () => props.show,
  (isShowing) => {
    if (isShowing) {
      imageFailed.value = false
      fetchObservador()
    } else {
      fetchedObservador.value = null
      error.value = null
    }
  },
  { immediate: true }
)
</script>
