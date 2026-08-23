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
            <h3 class="text-sm font-black uppercase text-text">{{ getBuqueName() }}</h3>
            <p class="text-xs font-semibold text-text-muted">Marea {{ form.tipoMarea }}-{{ form.nroMarea }}-{{ String(form.anioMarea).slice(-2) }}</p>
          </div>
        </div>
        <div class="px-3 py-1 bg-surface rounded-lg border border-border text-xs font-bold uppercase tracking-wider text-text-muted">
          {{ mareaData?.estadoActual?.nombre || 'CARGANDO...' }}
        </div>
      </div>

      <div v-form-nav class="bg-surface border border-border shadow-theme-xs flex flex-col rounded-2xl overflow-hidden p-6">
        <template v-if="loadingData || loadingCatalogs">
          <div class="py-12 flex flex-col items-center justify-center">
            <div class="w-8 h-8 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
            <p class="text-xs font-bold text-text-muted mt-4 uppercase tracking-widest">Cargando datos...</p>
          </div>
        </template>
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
                <!-- Row 1 -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Año</label>
                  <input v-model.number="form.anioMarea" type="number" :disabled="!canEditDesignationFields"
                    ref="firstInput"
                    class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs disabled:opacity-60 disabled:bg-surface-muted"
                    :class="fieldErrors.anioMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                </div>
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Nro. Marea</label>
                  <input v-model.number="form.nroMarea" type="number" placeholder="000" :disabled="!canEditDesignationFields"
                    class="w-full px-4 py-2.5 bg-surface border rounded-lg text-sm text-text outline-none focus:border-primary transition-all shadow-theme-xs disabled:opacity-60 disabled:bg-surface-muted"
                    :class="fieldErrors.nroMarea ? 'border-error bg-error/5' : 'border-border focus:ring-3 focus:ring-primary/10'" />
                </div>
                
                <!-- Row 2 -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Buque</label>
                  <SearchableSelect v-model="form.buqueId" :options="buqueOptions" :icon="ShipIcon"
                    :error="fieldErrors.buqueId" placeholder="Seleccione el buque..." @update:modelValue="onBuqueChange"
                    :disabled="!canEditDesignationFields" />
                </div>
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Observador Principal</label>
                  <SearchableSelect ref="observadorSelect" v-model="form.observadorPrincipalId" :options="observadorOptions"
                    :icon="BeakerIcon" :error="fieldErrors.observadorPrincipalId" placeholder="Seleccione el observador principal..."
                    :disabled="!canEditDesignationFields" />
                </div>

                <!-- Observadores Secundarios Planificados (Borrador) -->
                <div class="col-span-1 md:col-span-2 pt-2 border-t border-border/50">
                  <ObservadoresSecundariosEditor
                    v-model="form.observadoresSecundariosPlanificados"
                    :observador-options="observadorOptions"
                    :observador-principal-id="form.observadorPrincipalId"
                    :read-only="!canEditDesignationFields"
                  />
                </div>

                <!-- Row 3 -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Tipo de Marea</label>
                  <select v-model="form.tipoMarea" :disabled="!canEditDesignationFields" class="w-full bg-surface border border-border rounded-lg px-4 py-2.5 text-sm font-bold text-text outline-none focus:border-primary focus:ring-1 focus:ring-primary disabled:opacity-50 transition-colors shadow-theme-xs">
                    <option value="MC">Marea comercial</option>
                    <option value="CI">Marea institucional</option>
                  </select>
                </div>
                
                <div class="flex items-end">
                  <div v-if="form.tipoMarea === 'MC'" class="flex items-center gap-2 px-4 py-2.5 h-[42px] bg-primary/5 rounded-xl border border-primary/20 w-fit mb-0.5">
                    <input type="checkbox" id="iniciaProspeccion" v-model="form.iniciaEnProspeccion" :disabled="!canEditDesignationFields"
                      class="w-4 h-4 rounded text-primary focus:ring-primary border-border cursor-pointer disabled:opacity-50" />
                    <label for="iniciaProspeccion" class="text-xs font-bold text-text-muted uppercase tracking-tight cursor-pointer select-none"
                      :class="{ 'opacity-50': !canEditDesignationFields }">
                      Inicia en prospección
                    </label>
                  </div>
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
            data-allow-enter
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
import { ref, computed, watch, nextTick } from 'vue'
import mareasService from '../services/mareas.service'
import catalogosService from '../services/catalogos.service'
import { toast } from 'vue-sonner'
import type { Marea } from '../types/marea.types'
import BaseModal from '@/components/common/BaseModal.vue'
import SearchableSelect from '@/components/common/SearchableSelect.vue'
import DatePicker from '@/components/common/DatePicker.vue'
import LoadingSpinner from '@/components/ui/LoadingSpinner.vue'
import ObservadoresSecundariosEditor from './ObservadoresSecundariosEditor.vue'
import type { ObservadorSecundarioPlanificado } from '../types/marea-metadata.types';
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
  initialData?: any
}>()

const emit = defineEmits(['close', 'success'])

const loading = ref(false)
const loadingData = ref(false)
const error = ref<string | null>(null)
const loadingCatalogs = ref(false)
const fieldErrors = ref<Record<string, string>>({})
const firstInput = ref<HTMLInputElement | null>(null)

const mareaData = ref<Marea | null>(null)

const canEditDesignationFields = computed(() => {
  if (!mareaData.value || !mareaData.value.estadoActual) return false;
  const codigo = mareaData.value.estadoActual.codigo;
  return codigo === 'DESIGNADA' || codigo === 'A_REASIGNAR';
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
    .sort((a, b) => (a.apellido || '').localeCompare(b.apellido || ''))
    .map(o => ({
      value: o.id,
      label: `${o.apellido}, ${o.nombre}`
    }))
})

const getBuqueName = () => {
  if (mareaData.value?.buque?.nombreBuque) return mareaData.value.buque.nombreBuque;
  const buque = buques.value.find(b => b.id === form.value.buqueId);
  return buque ? buque.nombreBuque : 'Buque no asignado';
}

const getInitialForm = () => {
  if (!mareaData.value) return {
    tipoMarea: 'MC',
    buqueId: '',
    anioMarea: new Date().getFullYear(),
    nroMarea: null,
    observadorPrincipalId: '',
    pesqueriaId: '',
    artePrincipalId: '',

    fechaZarpadaEstimada: null,
    diasEstimados: null,
    iniciaEnProspeccion: false,
    observadoresSecundariosPlanificados: [] as ObservadorSecundarioPlanificado[],
  };

  let planificados: ObservadorSecundarioPlanificado[] = [];
  const rawMetadata: any = mareaData.value.metadata;
  if (rawMetadata) {
    try {
      const parsed = typeof rawMetadata === 'string' ? JSON.parse(rawMetadata) : rawMetadata;
      planificados = parsed.observadoresSecundariosPlanificados || [];
    } catch {
      planificados = [];
    }
  }

  return {
    tipoMarea: mareaData.value.tipoMarea || 'MC',
    buqueId: mareaData.value.buqueId || '',
    anioMarea: mareaData.value.anioMarea || new Date().getFullYear(),
    nroMarea: mareaData.value.nroMarea || null,
    observadorPrincipalId: mareaData.value.observadorPrincipalId || (mareaData.value as any).observador_principal_id || '',
    pesqueriaId: mareaData.value.pesqueriaId || (mareaData.value as any).id_pesqueria || '',
    artePrincipalId: mareaData.value.artePrincipalId || (mareaData.value as any).id_arte_principal || '',

    fechaZarpadaEstimada: mareaData.value.fechaZarpadaEstimada || (mareaData.value as any).fecha_zarpada_estimada || null,
    diasEstimados: mareaData.value.diasEstimados || (mareaData.value as any).dias_estimados || null,
    iniciaEnProspeccion: mareaData.value.iniciaEnProspeccion ?? (mareaData.value as any).inicia_en_prospeccion ?? false,
    observadoresSecundariosPlanificados: [...planificados]
  }
}


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
  if (newVal && props.mareaId) {
    fieldErrors.value = {}
    error.value = null
    
    // Si no tenemos los catalogos, los cargamos
    const catalogPromise = pesquerias.value.length === 0 ? loadCatalogs() : Promise.resolve();
    
    loadingData.value = true;
    try {
      mareaData.value = await mareasService.getById(props.mareaId)
      form.value = getInitialForm()
      await catalogPromise;
      nextTick(() => {
        firstInput.value?.focus()
      })
    } catch (err) {
      console.error('Error loading marea for edit:', err)
      toast.error('Error al cargar datos de la marea')
      error.value = 'No se pudieron cargar los datos de la marea.'
    } finally {
      loadingData.value = false;
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
      tipoMarea: form.value.tipoMarea,
      buqueId: form.value.buqueId || null,
      anioMarea: form.value.anioMarea,
      nroMarea: form.value.nroMarea,
      observadorPrincipalId: form.value.observadorPrincipalId || null,
      pesqueriaId: form.value.pesqueriaId || null,
      artePrincipalId: form.value.artePrincipalId || null,

      fechaZarpadaEstimada: form.value.fechaZarpadaEstimada || null,
      diasEstimados: form.value.diasEstimados || null,
      iniciaEnProspeccion: form.value.tipoMarea === 'MC' ? form.value.iniciaEnProspeccion : false,
      observadoresSecundariosPlanificados: form.value.observadoresSecundariosPlanificados
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
