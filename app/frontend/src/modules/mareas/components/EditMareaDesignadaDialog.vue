<template>
  <BaseModal :show="show" @close="close" maxWidth="5xl" title="Editar Datos Básicos de Marea">
    <div class="pb-2">
      <!-- Marea Info Header -->
      <div class="mb-8 p-4 bg-primary/5 border border-primary/20 rounded-xl flex items-center justify-between">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary font-bold">
            <ShipIcon class="w-5 h-5" />
          </div>
          <div>
            <h3 class="text-sm font-black uppercase text-text">{{ initialData.buque_nombre }}</h3>
            <p class="text-xs font-semibold text-text-muted">Marea {{ initialData.tipo_marea }}-{{ initialData.nro_marea }}-{{ initialData.anio_marea.toString().slice(-2) }}</p>
          </div>
        </div>
        <div class="px-3 py-1 bg-surface rounded-lg border border-border text-xs font-bold uppercase tracking-wider text-text-muted">
          {{ initialData.estado_nombre || 'DESIGNADA' }}
        </div>
      </div>

      <div class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        
        <div v-if="loadingCatalogs" class="flex-1 flex flex-col items-center justify-center py-20">
          <LoadingSpinner size="xl" class="text-primary" />
          <p class="mt-4 text-text-muted font-black uppercase tracking-widest text-[10px]">Cargando catálogos oficiales...</p>
        </div>

        <template v-else>
          <div class="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            
            <!-- Identificación -->
            <div>
              <div class="border-b border-border pb-3 mb-5">
                <h3 class="text-sm font-black uppercase tracking-tight text-text flex items-center gap-2">
                  <DocsIcon class="w-4 h-4 text-primary" />
                  Identificación
                </h3>
              </div>

              <!-- Banner informativo si no es editable -->
              <div v-if="!canEditDesignationFields" class="mb-6 p-4 bg-info/5 border border-info/20 rounded-xl flex items-start gap-3">
                <InfoIcon class="w-5 h-5 text-info shrink-0 mt-0.5" />
                <p class="text-xs font-medium text-info leading-relaxed">
                  Los datos de <strong>identidad, buque, observador, pesquería y arte de pesca</strong> solo pueden modificarse cuando la marea está en estado <strong>DESIGNADA</strong> o <strong>A_REASIGNAR</strong>.
                </p>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Año</label>
                  <input v-model.number="form.anioMarea" type="number" :disabled="!canEditDesignationFields"
                    class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs disabled:opacity-60 disabled:bg-surface-muted"
                    :class="fieldErrors.anioMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                </div>
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Nro. Marea</label>
                  <input v-model.number="form.nroMarea" type="number" placeholder="000" :disabled="!canEditDesignationFields"
                    class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs disabled:opacity-60 disabled:bg-surface-muted"
                    :class="fieldErrors.nroMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                </div>
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Buque</label>
                  <SearchableSelect v-model="form.buqueId" :options="buqueOptions" :icon="ShipIcon"
                    :error="fieldErrors.buqueId" placeholder="Seleccione el buque..." @update:modelValue="onBuqueChange"
                    :disabled="!canEditDesignationFields" />
                </div>
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Observador Designado</label>
                  <SearchableSelect ref="observadorSelect" v-model="form.observadorPrincipalId" :options="observadorOptions"
                    :icon="BeakerIcon" :error="fieldErrors.observadorPrincipalId" placeholder="Seleccione el observador..."
                    :disabled="!canEditDesignationFields" />
                </div>
              </div>
            </div>

            <!-- Operación -->
            <div>
              <div class="border-b border-border pb-3 mb-5">
                <h3 class="text-sm font-black uppercase tracking-tight text-text flex items-center gap-2">
                  <RefreshIcon class="w-4 h-4 text-primary" />
                  Operación
                </h3>
              </div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Pesquería</label>
                  <SearchableSelect v-model="form.pesqueriaId" :options="pesqueriaOptions" :icon="WaveIcon"
                    :error="fieldErrors.pesqueriaId" placeholder="Seleccione la pesquería..."
                    :disabled="!canEditDesignationFields" />
                </div>

                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Arte de Pesca Principal</label>
                  <SearchableSelect v-model="form.artePrincipalId" :options="arteOptions" :icon="SettingsIcon"
                    placeholder="Seleccione el arte..." :error="fieldErrors.artePrincipalId"
                    :disabled="!canEditDesignationFields" />
                </div>

                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Fecha Zarpada Estimada</label>
                  <DatePicker v-model="form.fechaZarpadaEstimada" :icon="CalenderIcon" :show-time="false"
                    :error="fieldErrors.fechaZarpadaEstimada" />
                </div>

                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Días Estimados</label>
                  <div class="relative">
                    <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <HistoryIcon class="h-5 w-5 text-text-muted" />
                    </div>
                    <input v-model.number="form.diasEstimados" type="number" min="1" placeholder="Días"
                      class="block w-full pl-10 pr-3 py-2.5 bg-surface border border-border rounded-lg font-bold text-text outline-none focus:border-primary focus:ring-3 focus:ring-primary/10 transition-all placeholder:text-text-muted/40 text-sm shadow-theme-xs" />
                  </div>
                </div>
              </div>
            </div>

          </div>
        </template>

        <!-- Error Banner -->
        <div v-if="error" class="mt-6 p-4 bg-error/5 border border-error/20 rounded-xl text-error text-[10px] font-black uppercase tracking-widest text-center">
          {{ error }}
        </div>

        <!-- Actions -->
        <div class="mt-8 pt-6 flex items-center justify-end border-t border-border gap-3">
          <button @click="close"
            class="px-6 py-3 text-xs font-black uppercase tracking-widest text-text-muted hover:text-error transition-all">
            Cancelar
          </button>
          <button @click="submit" :disabled="loading || loadingCatalogs"
            class="px-8 py-3 bg-primary hover:bg-primary-hover text-primary-fg rounded-lg text-xs font-black uppercase tracking-widest shadow-theme-xs shadow-primary/20 transition-all active:scale-95 flex items-center gap-2 disabled:opacity-50">
            <div v-if="loading" class="flex items-center justify-center">
              <LoadingSpinner size="xs" class="text-primary-fg" />
            </div>
            <template v-else>
              <CheckIcon class="w-4 h-4" />
              Guardar Cambios
            </template>
          </button>
        </div>
      </div>
    </div>
  </BaseModal>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, computed } from 'vue'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import catalogosService from '../services/catalogos.service'
import mareasService from '../services/mareas.service'
import { toast } from 'vue-sonner'
import {
  ShipIcon,
  DocsIcon,
  RefreshIcon,
  CheckIcon,
  WaveIcon,
  SettingsIcon,
  BeakerIcon,
  CalenderIcon,
  HistoryIcon
} from '@/icons'

const props = defineProps<{
  show: boolean
  mareaId: string
  initialData: any
}>()

const emit = defineEmits(['close', 'success'])

const loading = ref(false)
const error = ref<string | null>(null)
const loadingCatalogs = ref(false)
const fieldErrors = ref<Record<string, string>>({})

const canEditDesignationFields = computed(() => {
  return props.initialData.estado_codigo === 'DESIGNADA' || props.initialData.estado_codigo === 'A_REASIGNAR'
})

const pesquerias = ref<any[]>([])
const observadores = ref<any[]>([])
const artes = ref<any[]>([])
const buques = ref<any[]>([])

const pesqueriaOptions = computed(() => pesquerias.value.map(p => ({ value: p.id, label: p.nombre })))
const arteOptions = computed(() => artes.value.map(a => ({ value: a.id, label: a.nombre })))
const buqueOptions = computed(() => buques.value.map(b => ({ value: b.id, label: b.nombreBuque })))
const observadorOptions = computed(() => {
  return observadores.value
    .filter(o => o.activo && o.disponible || o.id === form.value.observadorPrincipalId)
    .sort((a, b) => a.apellido.localeCompare(b.apellido))
    .map(o => ({
      value: o.id,
      label: `${o.apellido}, ${o.nombre}`
    }))
})

const getInitialForm = () => ({
  buqueId: props.initialData.buqueId || '',
  anioMarea: props.initialData.anio_marea || new Date().getFullYear(),
  nroMarea: props.initialData.nro_marea || null,
  observadorPrincipalId: props.initialData.observadorPrincipalId || '',
  pesqueriaId: props.initialData.pesqueriaId || '',
  artePrincipalId: props.initialData.artePrincipalId || '',
  fechaZarpadaEstimada: props.initialData.fecha_zarpada_estimada_cruda || null,
  diasEstimados: props.initialData.dias_estimados || null,
})

const form = ref(getInitialForm())

const onBuqueChange = (newBuqueId: string | number | null) => {
  if (!newBuqueId) return
  const selectedBuque = buques.value.find(b => b.id === newBuqueId)
  if (selectedBuque) {
    if (selectedBuque.pesqueriaHabitualId) {
      form.value.pesqueriaId = selectedBuque.pesqueriaHabitualId
    }
    if (selectedBuque.arteHabitualId) {
      form.value.artePrincipalId = selectedBuque.arteHabitualId
    }
  }
}

watch(() => props.show, async (newVal) => {
  if (newVal) {
    form.value = getInitialForm()
    fieldErrors.value = {}
    error.value = null
    if (pesquerias.value.length === 0) {
      await loadCatalogs()
    }
  }
})

const loadCatalogs = async () => {
  loadingCatalogs.value = true
  try {
    const [p, o, a, b] = await Promise.all([
      catalogosService.getPesquerias(),
      catalogosService.getObservadores(),
      catalogosService.getArtesPesca(),
      catalogosService.getBuques()
    ])
    pesquerias.value = p
    observadores.value = o
    artes.value = a
    buques.value = b
  } catch (err) {
    console.error('Error loading catalogs:', err)
    toast.error('Error al cargar opciones de los selectores.')
  } finally {
    loadingCatalogs.value = false
  }
}

const validate = () => {
  fieldErrors.value = {}
  let isValid = true

  if (!form.value.anioMarea) {
    fieldErrors.value.anioMarea = 'Requerido'
    isValid = false
  }
  if (!form.value.nroMarea) {
    fieldErrors.value.nroMarea = 'Requerido'
    isValid = false
  }
  if (!form.value.buqueId) {
    fieldErrors.value.buqueId = 'Requerido'
    isValid = false
  }

  return isValid
}

const submit = async () => {
  if (!validate()) return

  loading.value = true
  error.value = null

  try {
    const updateData = {
      buqueId: form.value.buqueId || null,
      anioMarea: form.value.anioMarea,
      nroMarea: form.value.nroMarea,
      observadorPrincipalId: form.value.observadorPrincipalId || null,
      pesqueriaId: form.value.pesqueriaId || null,
      artePrincipalId: form.value.artePrincipalId || null,
      fechaZarpadaEstimada: form.value.fechaZarpadaEstimada || null,
      diasEstimados: form.value.diasEstimados || null
    }

    await mareasService.update(props.mareaId, updateData)
    toast.success('Marea actualizada exitosamente')
    emit('success')
  } catch (err: any) {
    console.error('Error updating marea:', err)
    error.value = err.response?.data?.message || 'Error al actualizar la marea'
  } finally {
    loading.value = false
  }
}

const close = () => {
  emit('close')
}
</script>
