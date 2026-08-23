<template>
  <div class="space-y-4">
    <div class="flex items-center justify-between">
      <h4 class="text-xs font-black uppercase tracking-widest text-text-muted flex items-center gap-2">
        <MapPinIcon class="w-3 h-3" /> Etapas del Viaje
      </h4>
      <button 
        v-if="!readOnly"
        @click="addStage"
        :disabled="!canAddStage"
        class="px-3 py-1.5 bg-primary/10 text-primary rounded-lg text-[10px] font-black uppercase tracking-widest hover:bg-primary/20 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-1.5"
      >
        <span>+ Agregar Etapa</span>
      </button>
    </div>

    <div v-if="modelValue.length === 0" class="text-center py-12 bg-surface-muted/50 rounded-2xl border-2 border-dashed border-border">
      <MapPinIcon class="w-12 h-12 text-text-muted mx-auto mb-4" />
      <p class="text-text-muted font-medium">No hay etapas registradas.</p>
    </div>

    <div v-else class="space-y-4">
      <div v-for="(stage, index) in modelValue" :key="index"
           :id="`stage-card-${index}`"
           class="bg-surface border border-border rounded-2xl p-4 relative group transition-all shadow-sm hover:shadow-md"
           :class="{
             'border-error/30 bg-error/5': hasOverlap(index),
             'border-warning/30 bg-warning/5': isInternalInconsistent(index)
           }">

        <!-- Header: Título, Pestañas Internas y Botón Eliminar Etapa -->
        <div class="flex flex-wrap items-center justify-between gap-2 mb-3 border-b border-border/40 pb-2.5">
          <div class="flex items-center gap-2">
             <div class="w-6 h-6 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                <span class="text-[10px] font-black">#{{ index + 1 }}</span>
             </div>
             <h4 class="text-xs font-bold text-text uppercase tracking-tight">Etapa de Navegación</h4>
          </div>

          <!-- Switcher de Pestañas Internas (Navegación / Observadores) -->
          <div class="flex items-center gap-1 bg-surface-muted p-0.5 rounded-xl border border-border">
            <button
              type="button"
              @click="setStageTab(index, 'navegacion')"
              class="px-2.5 py-1 text-[10px] font-black uppercase tracking-wider rounded-lg transition-all flex items-center gap-1.5"
              :class="getStageTab(index) === 'navegacion'
                ? 'bg-surface text-primary shadow-xs font-bold'
                : 'text-text-muted hover:text-text'"
            >
              <MapPinIcon class="w-3 h-3" />
              <span>Navegación</span>
            </button>

            <button
              type="button"
              @click="setStageTab(index, 'observadores')"
              class="px-2.5 py-1 text-[10px] font-black uppercase tracking-wider rounded-lg transition-all flex items-center gap-1.5"
              :class="getStageTab(index) === 'observadores'
                ? 'bg-surface text-primary shadow-xs font-bold'
                : 'text-text-muted hover:text-text'"
            >
              <UserGroupIcon class="w-3 h-3" />
              <span>Observadores</span>
              <span
                v-if="getTotalObserversCount(stage) > 0"
                class="px-1.5 py-0.2 text-[9px] rounded-full font-black transition-colors"
                :class="getTotalObserversCount(stage) > 1
                  ? 'bg-primary text-surface shadow-xs font-bold'
                  : 'bg-surface-muted text-text-muted border border-border'"
              >
                {{ getTotalObserversCount(stage) }}
              </span>
            </button>
          </div>

          <!-- Botón Eliminar Etapa -->
          <button
            v-if="!readOnly && index === modelValue.length - 1 && modelValue.length > (minStages || 0)"
            @click="removeStage(index)"
            class="p-1.5 text-text-muted/40 hover:text-error hover:bg-error/10 rounded-lg transition-all opacity-0 group-hover:opacity-100"
            title="Eliminar etapa"
          >
            <TrashIcon class="w-3.5 h-3.5" />
          </button>
        </div>

        <!-- TAB 1: DATOS DE NAVEGACIÓN -->
        <div v-if="getStageTab(index) === 'navegacion'" class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-5">
          <!-- Departure Details -->
          <div class="space-y-3">
            <div class="flex items-center gap-2">
              <div class="w-1.5 h-1.5 rounded-full bg-primary"></div>
              <h5 class="text-[9px] font-black uppercase tracking-widest text-text-muted">Zarpada</h5>
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-text-muted tracking-tighter">Fecha</label>
                <DatePicker 
                  ref="zarpadaDates"
                  v-model="stage.fechaZarpada" 
                  :show-time="false" 
                  :disabled="readOnly" 
                  :error="errors?.[`etapa_${index}_fechaZarpada`]"
                />
              </div>
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-text-muted tracking-tighter">Puerto</label>
                <SearchableSelect
                  v-model="stage.puertoZarpadaId"
                  :options="puertoOptions"
                  placeholder="Origen..."
                  :disabled="readOnly"
                  :error="errors?.[`etapa_${index}_puertoZarpadaId`]"
                />
              </div>
            </div>
          </div>

          <!-- Arrival Details -->
          <div class="space-y-3">
            <div class="flex items-center gap-2">
              <div class="w-1.5 h-1.5 rounded-full bg-warning"></div>
              <h5 class="text-[9px] font-black uppercase tracking-widest text-text-muted">Arribo</h5>
            </div>
            <div class="grid grid-cols-2 gap-3">
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-text-muted tracking-tighter">Fecha</label>
                <DatePicker v-model="stage.fechaArribo" :show-time="false" :disabled="readOnly" />
              </div>
              <div class="space-y-1">
                <label class="text-[8px] font-black uppercase text-text-muted tracking-tighter">Puerto</label>
                <SearchableSelect
                  v-model="stage.puertoArriboId"
                  :options="puertoOptions"
                  placeholder="Destino..."
                  :disabled="readOnly"
                />
              </div>
            </div>
          </div>

          <!-- Meta Info: Compact Row -->
          <div class="md:col-span-2 grid grid-cols-1 sm:grid-cols-12 gap-4 pt-3 border-t border-border items-end">
            <div class="sm:col-span-4 space-y-1">
              <label class="text-[8px] font-black uppercase text-text-muted tracking-widest flex items-center gap-1.5">
                <FlagIcon class="w-2.5 h-2.5" /> Pesquería
              </label>
              <SearchableSelect
                v-model="stage.pesqueriaId"
                :options="pesqueriaOptions"
                placeholder="Seleccione..."
                :disabled="readOnly"
              />
            </div>
            <div class="sm:col-span-3 space-y-1">
              <label class="text-[8px] font-black uppercase text-text-muted tracking-widest flex items-center gap-1.5">
                <SettingsIcon class="w-2.5 h-2.5" /> Propósito
              </label>
              <select v-model="stage.tipoEtapa" :disabled="readOnly" class="w-full bg-surface border border-border rounded-lg py-2 text-xs h-[38px] focus:ring-1 focus:ring-primary outline-none px-3">
                <option v-for="opt in getEtapaOptions()" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
              </select>
            </div>
            <div class="sm:col-span-5 space-y-1">
              <label class="text-[8px] font-black uppercase text-text-muted tracking-widest flex items-center gap-1.5">
                <EditIcon class="w-2.5 h-2.5" /> Notas
              </label>
              <input
                v-model="stage.observaciones"
                type="text"
                :disabled="readOnly"
                class="w-full bg-surface border border-border rounded-lg py-2 text-xs h-[38px] focus:ring-1 focus:ring-primary outline-none px-3"
                placeholder="Obs. adicionales..."
              />
            </div>
          </div>

          <!-- Intención de Cierre (Solo visible en la última etapa si no está readonly) -->
          <div v-if="!readOnly && index === modelValue.length - 1 && isEtapaEnCurso(stage)" class="md:col-span-2 pt-3 border-t border-border mt-1">
            <div class="flex items-center justify-between bg-primary/5 border border-primary/20 rounded-xl p-3">
              <div>
                <h5 class="text-xs font-bold text-primary flex items-center gap-1.5 mb-0.5">
                  FINALIZAR MAREA AL PRÓXIMO ARRIBO
                </h5>
                <p class="text-[10px] text-text-muted leading-tight">
                  Active esta opción si el buque descargará y la marea debe darse por concluida al llegar a puerto.
                </p>
              </div>
              <BaseSwitch
                v-model="stageIntencionCierre[index]"
                @update:modelValue="(val: boolean) => onToggleIntencionCierre(index, stage, val)"
                :disabled="readOnly"
              />
            </div>
          </div>
        </div>

        <!-- TAB 2: OBSERVADORES DE LA ETAPA -->
        <div v-else-if="getStageTab(index) === 'observadores'" class="space-y-3 py-1">
          <!-- 1. Observador Principal (Solo Lectura - Asignado a toda la marea) -->
          <div
            v-if="principalObservadorObj"
            class="flex flex-wrap items-center justify-between gap-3 p-3 bg-surface border border-border/80 rounded-xl transition-all shadow-xs"
          >
            <div class="flex items-center gap-3">
              <div class="w-8 h-8 rounded-full bg-primary/10 text-primary font-extrabold text-xs flex items-center justify-center border border-primary/20">
                {{ principalObservadorObj.initials }}
              </div>
              <div>
                <div class="flex items-center gap-2">
                  <span class="text-xs font-bold text-text">
                    {{ principalObservadorObj.fullName }}
                  </span>
                  <span class="px-2 py-0.5 text-[9px] font-black uppercase rounded-full bg-primary/10 text-primary border border-primary/20">
                    Principal
                  </span>
                  <span class="px-1.5 py-0.5 text-[9px] font-bold bg-success/10 text-success rounded border border-success/20">
                    Designado
                  </span>
                </div>
                <p class="text-[10px] text-text-muted mt-0.5 flex items-center gap-1 font-medium">
                  <span>•</span>
                  <span>Asignado a toda la marea</span>
                </p>
              </div>
            </div>
          </div>

          <!-- 2. Listado de Observadores Secundarios en esta Etapa -->
          <div v-if="stage.observadores && stage.observadores.length > 0" class="space-y-2">
            <div
              v-for="(obs, obsIdx) in stage.observadores"
              :key="obs.id || obs.observadorId || obsIdx"
              class="flex flex-wrap items-center justify-between gap-3 p-3 bg-surface-muted/60 border border-border rounded-xl transition-all"
              :class="{ 'ring-2 ring-primary/30 border-primary': isEditingObservador(index, obs) }"
            >
              <!-- Modo Normal / Visualización -->
              <div v-if="!isEditingObservador(index, obs)" class="flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-surface-muted text-text-muted font-extrabold text-xs flex items-center justify-center border border-border">
                  {{ getObserverInitials(obs) }}
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <span class="text-xs font-bold text-text">
                      {{ getObserverFullName(obs) }}
                    </span>
                    <span
                      class="px-2 py-0.5 text-[9px] font-black uppercase rounded-full"
                      :class="obs.rol === 'PRINCIPAL' ? 'bg-primary/10 text-primary border border-primary/20' : 'bg-surface text-text-muted border border-border'"
                    >
                      {{ obs.rol === 'PRINCIPAL' ? 'Principal' : 'Secundario' }}
                    </span>
                    <span
                      v-if="obs.esDesignado"
                      class="px-1.5 py-0.5 text-[9px] font-bold bg-success/10 text-success rounded border border-success/20"
                    >
                      Designado
                    </span>
                  </div>
                  <p v-if="obs.observaciones" class="text-[11px] text-text-muted italic mt-0.5">
                    "{{ obs.observaciones }}"
                  </p>
                </div>
              </div>

              <!-- Modo Edición Inline del Observador -->
              <div v-else class="flex-1 grid grid-cols-1 sm:grid-cols-12 gap-3 items-center">
                <div class="sm:col-span-8">
                  <SearchableSelect
                    v-model="editObsId"
                    :options="getAvailableObserversForStage(stage, obs.observadorId)"
                    placeholder="Seleccione el nuevo observador..."
                    :icon="BeakerIcon"
                  />
                </div>
                <div class="sm:col-span-4 flex items-center gap-2 justify-end">
                  <button
                    type="button"
                    @click="confirmEditObservador(index, stage, obs)"
                    :disabled="!editObsId || editObsId === obs.observadorId || savingObs"
                    class="px-3 py-1.5 bg-primary text-surface rounded-lg text-xs font-bold hover:bg-primary/90 disabled:opacity-50 transition-colors"
                  >
                    Guardar
                  </button>
                  <button
                    type="button"
                    @click="cancelEditObservador"
                    class="px-2.5 py-1.5 bg-surface border border-border text-text-muted hover:text-text rounded-lg text-xs font-bold transition-colors"
                  >
                    Cancelar
                  </button>
                </div>
              </div>

              <!-- Acciones sobre el observador (si no es principal) -->
              <div v-if="!readOnly && obs.rol !== 'PRINCIPAL' && !isEditingObservador(index, obs)" class="flex items-center gap-1">
                <button
                  type="button"
                  @click="startEditObservador(index, obs)"
                  class="p-1.5 text-text-muted/60 hover:text-primary hover:bg-primary/10 rounded-lg transition-colors"
                  title="Cambiar observador de esta etapa"
                >
                  <EditIcon class="w-3.5 h-3.5" />
                </button>
                <button
                  type="button"
                  @click="removeObservadorFromStage(stage, obs)"
                  class="p-1.5 text-text-muted/60 hover:text-error hover:bg-error/10 rounded-lg transition-colors"
                  title="Quitar de esta etapa"
                >
                  <TrashIcon class="w-3.5 h-3.5" />
                </button>
              </div>
            </div>
          </div>

          <!-- Estado vacío si no hay ningún observador en absoluto -->
          <div v-if="!principalObservadorObj && (!stage.observadores || stage.observadores.length === 0)" class="p-4 bg-surface-muted/40 rounded-xl border border-dashed border-border text-center">
            <p class="text-xs text-text-muted font-medium">No hay observadores asignados en esta etapa.</p>
          </div>

          <!-- Formulario Inline para Asignar Nuevo Observador Secundario -->
          <div v-if="!readOnly">
            <div v-if="addingStageIndex === index" class="p-3 bg-primary/5 border border-primary/20 rounded-xl space-y-3 animate-in fade-in duration-200">
              <h6 class="text-[11px] font-bold text-primary uppercase tracking-wider">
                Asignar Observador Secundario a la Etapa #{{ index + 1 }}
              </h6>

              <div class="space-y-2">
                <div class="space-y-1">
                  <label class="text-[9px] font-black uppercase text-text-muted">Observador</label>
                  <SearchableSelect
                    v-model="newObsId"
                    :options="getAvailableObserversForStage(stage)"
                    placeholder="Seleccione el observador a incorporar..."
                    :icon="BeakerIcon"
                  />
                </div>

                <div v-if="props.mareaId && stage.id" class="flex items-center gap-2 pt-1">
                  <input
                    type="checkbox"
                    :id="`aplicar-siguientes-${index}`"
                    v-model="newObsAplicarSiguientes"
                    class="rounded border-border text-primary focus:ring-primary/20 cursor-pointer"
                  />
                  <label :for="`aplicar-siguientes-${index}`" class="text-xs text-text-muted font-medium cursor-pointer">
                    Mantener también en las siguientes etapas que se generen (planificar en borrador)
                  </label>
                </div>
              </div>

              <div class="flex items-center justify-end gap-2 pt-1">
                <button
                  type="button"
                  @click="cancelAddObservador"
                  class="px-3 py-1.5 bg-surface border border-border text-text-muted hover:text-text rounded-lg text-xs font-bold transition-colors"
                >
                  Cancelar
                </button>
                <button
                  type="button"
                  @click="confirmAddObservador(index, stage)"
                  :disabled="!newObsId || savingObs"
                  class="px-3 py-1.5 bg-primary text-surface rounded-lg text-xs font-bold hover:bg-primary/90 disabled:opacity-50 transition-colors flex items-center gap-1.5"
                >
                  <span>{{ savingObs ? 'Asignando...' : 'Asignar a Etapa' }}</span>
                </button>
              </div>
            </div>

            <button
              v-else
              type="button"
              @click="startAddObservador(index)"
              class="w-full py-2 border border-dashed border-primary/30 hover:border-primary bg-primary/5 hover:bg-primary/10 rounded-xl text-xs font-bold text-primary transition-all flex items-center justify-center gap-1.5"
            >
              <PlusIcon class="w-3.5 h-3.5" />
              <span>Asignar Observador Adicional</span>
            </button>
          </div>
        </div>

        <!-- Overlap Warning (Inter-stage) -->
        <div v-if="hasOverlap(index)" class="mt-3 p-1.5 bg-error/10 border border-error/20 rounded-lg text-[9px] text-error font-black flex items-center gap-1.5 animate-in slide-in-from-top-1">
           <WarningIcon class="w-3 h-3" />
           LA FECHA DE ZARPADA ES ANTERIOR AL ARRIBO PREVIO
        </div>

        <!-- Inconsistency Warning (Internal) -->
        <div v-if="isInternalInconsistent(index)" class="mt-3 p-1.5 bg-warning/10 border border-warning/20 rounded-lg text-[9px] text-warning font-black flex items-center gap-1.5 animate-in slide-in-from-top-1">
           <WarningIcon class="w-3 h-3" />
           LA FECHA DE ARRIBO ES ANTERIOR A LA ZARPADA
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, nextTick, watch, onMounted } from 'vue';
import DatePicker from '@/components/common/DatePicker.vue';
import SearchableSelect from '@/components/common/SearchableSelect.vue';
import { 
  MapPinIcon, 
  TrashIcon, 
  ChevronRightIcon, 
  FlagIcon, 
  SettingsIcon, 
  EditIcon,
  WarningIcon,
  UserGroupIcon,
  BeakerIcon,
  PlusIcon,
  CheckIcon
} from '@/icons';
import BaseSwitch from '@/components/ui/BaseSwitch.vue';
import { TipoEtapa, TipoMarea, TIPO_ETAPA_DESC } from '../types/enums';
import type { MareaEtapaMetadata } from '../types/marea.types';
import mareasService from '../services/mareas.service';
import catalogosService, { type Observador } from '../services/catalogos.service';

const props = defineProps<{
  modelValue: any[];
  puertoOptions: any[];
  pesqueriaOptions: any[];
  observadorOptions?: any[];
  observadorPrincipalId?: string | null;
  observadorPrincipalNombre?: string | null;
  puertoBaseId?: string;
  defaultPesqueriaId?: string;
  readOnly?: boolean;
  minStages?: number;
  errors?: Record<string, string>;
  defaultFechaZarpada?: string;
  mareaId?: string;
  tipoMarea?: TipoMarea;
}>();

const emit = defineEmits([
  'update:modelValue', 
  'remove-stage', 
  'action-warning',
  'action-success',
  'action-error'
]);

// Tabs internas por etapa: 'navegacion' | 'observadores'
const activeStageTabs = ref<Record<number, 'navegacion' | 'observadores'>>({});

function getStageTab(index: number): 'navegacion' | 'observadores' {
  return activeStageTabs.value[index] || 'navegacion';
}

function setStageTab(index: number, tab: 'navegacion' | 'observadores') {
  activeStageTabs.value[index] = tab;
}

// Catálogo de observadores (prop o fallback de API)
const internalObservadores = ref<Observador[]>([]);

onMounted(async () => {
  if (!props.observadorOptions || props.observadorOptions.length === 0) {
    try {
      internalObservadores.value = await catalogosService.getObservadores();
    } catch (e) {
      console.error('Error al cargar observadores para NavigationStagesEditor:', e);
    }
  }
});

const principalObservadorObj = computed(() => {
  if (!props.observadorPrincipalId && !props.observadorPrincipalNombre) return null;
  if (props.observadorPrincipalNombre === 'No asignado') return null;

  if (props.observadorPrincipalId) {
    const match = internalObservadores.value.find(o => o.id === props.observadorPrincipalId);
    if (match) {
      return {
        id: match.id,
        observadorId: match.id,
        nombre: match.nombre,
        apellido: match.apellido,
        fullName: `${match.apellido}, ${match.nombre}`,
        initials: `${(match.apellido || '')[0] || ''}${(match.nombre || '')[0] || ''}`.toUpperCase(),
        rol: 'PRINCIPAL',
        esDesignado: true
      };
    }
  }

  if (props.observadorPrincipalNombre && props.observadorPrincipalNombre !== 'No asignado') {
    const parts = props.observadorPrincipalNombre.split(' ').filter(Boolean);
    return {
      id: props.observadorPrincipalId || 'principal',
      observadorId: props.observadorPrincipalId || 'principal',
      fullName: props.observadorPrincipalNombre,
      initials: parts.length >= 2 ? `${parts[0][0]}${parts[1][0]}`.toUpperCase() : (props.observadorPrincipalNombre[0] || 'O').toUpperCase(),
      rol: 'PRINCIPAL',
      esDesignado: true
    };
  }

  return null;
});

function getTotalObserversCount(stage: any): number {
  const hasPrincipal = !!principalObservadorObj.value;
  const secondaryCount = (stage.observadores || []).length;
  return (hasPrincipal ? 1 : 0) + secondaryCount;
}

const allAvailableObservadorOptions = computed(() => {
  if (props.observadorOptions && props.observadorOptions.length > 0) {
    return props.observadorOptions;
  }
  return internalObservadores.value
    .filter(o => !o.conImpedimento)
    .sort((a, b) => a.apellido.localeCompare(b.apellido))
    .map(o => ({
      value: o.id,
      label: `${o.apellido}, ${o.nombre}`
    }));
});

function getAvailableObserversForStage(stage: any, currentEditingId?: string) {
  const currentAssignedIds = new Set(
    (stage.observadores || [])
      .map((o: any) => o.observadorId || o.observador?.id)
      .filter((id: string) => id && id !== currentEditingId)
  );

  if (props.observadorPrincipalId) {
    currentAssignedIds.add(props.observadorPrincipalId);
  }

  return allAvailableObservadorOptions.value.filter(opt => !currentAssignedIds.has(opt.value));
}

function getObserverFullName(obs: any): string {
  if (obs.observador?.apellido && obs.observador?.nombre) {
    return `${obs.observador.apellido}, ${obs.observador.nombre}`;
  }
  if (obs.observador?.nombre) return obs.observador.nombre;
  const obsId = obs.observadorId || obs.observador?.id || obs.id;
  const match = allAvailableObservadorOptions.value.find(o => o.value === obsId);
  if (match) return match.label;
  const internalMatch = internalObservadores.value.find(o => o.id === obsId);
  if (internalMatch) return `${internalMatch.apellido}, ${internalMatch.nombre}`;
  return obsId || 'Observador';
}

function getObserverInitials(obs: any): string {
  const name = getObserverFullName(obs);
  if (!name || name === 'Observador' || name === (obs.observadorId || obs.id)) return 'O';
  const parts = name.split(',').map(p => p.trim());
  if (parts.length >= 2) {
    return `${parts[0][0] || ''}${parts[1][0] || ''}`.toUpperCase();
  }
  const words = name.split(' ').filter(Boolean);
  if (words.length >= 2) {
    return `${words[0][0] || ''}${words[1][0] || ''}`.toUpperCase();
  }
  return (name[0] || 'O').toUpperCase();
}

// Estados de alta y edición de observadores por etapa
const addingStageIndex = ref<number | null>(null);
const newObsId = ref<string>('');
const newObsAplicarSiguientes = ref<boolean>(false);
const savingObs = ref<boolean>(false);

const editingStageObs = ref<{ stageIdx: number; observadorId: string } | null>(null);
const editObsId = ref<string>('');

function isEditingObservador(stageIdx: number, obs: any): boolean {
  return (
    editingStageObs.value?.stageIdx === stageIdx &&
    editingStageObs.value?.observadorId === (obs.observadorId || obs.id)
  );
}

function startAddObservador(stageIdx: number) {
  addingStageIndex.value = stageIdx;
  newObsId.value = '';
  newObsAplicarSiguientes.value = false;
  editingStageObs.value = null;
}

function cancelAddObservador() {
  addingStageIndex.value = null;
  newObsId.value = '';
  newObsAplicarSiguientes.value = false;
}

async function confirmAddObservador(stageIdx: number, stage: any) {
  if (!newObsId.value) return;

  savingObs.value = true;
  try {
    const selectedObsObj = internalObservadores.value.find(o => o.id === newObsId.value);
    const newEntry = {
      id: undefined,
      etapaId: stage.id,
      observadorId: newObsId.value,
      rol: 'SECUNDARIO',
      esDesignado: false,
      observador: selectedObsObj ? {
        id: selectedObsObj.id,
        nombre: selectedObsObj.nombre,
        apellido: selectedObsObj.apellido
      } : undefined
    };

    if (props.mareaId && stage.id) {
      await mareasService.addObservadorEtapa(
        props.mareaId,
        stage.id,
        newObsId.value,
        newObsAplicarSiguientes.value
      );
      emit('action-success', 'Observador asignado a la etapa correctamente.');
    }

    // Actualizar estado reactivo local
    const currentStages = [...props.modelValue];
    const currentStage = { ...currentStages[stageIdx] };
    const currentObsList = [...(currentStage.observadores || [])];
    currentObsList.push(newEntry);
    currentStage.observadores = currentObsList;
    currentStages[stageIdx] = currentStage;
    emit('update:modelValue', currentStages);

    cancelAddObservador();
  } catch (error: any) {
    console.error('Error agregando observador a etapa:', error);
    emit('action-error', error.response?.data?.message || 'Error al asignar observador a la etapa.');
  } finally {
    savingObs.value = false;
  }
}

function startEditObservador(stageIdx: number, obs: any) {
  const obsId = obs.observadorId || obs.id;
  editingStageObs.value = { stageIdx, observadorId: obsId };
  editObsId.value = obsId;
  addingStageIndex.value = null;
}

function cancelEditObservador() {
  editingStageObs.value = null;
  editObsId.value = '';
}

async function confirmEditObservador(stageIdx: number, stage: any, obs: any) {
  const oldObsId = obs.observadorId || obs.id;
  if (!editObsId.value || editObsId.value === oldObsId) {
    cancelEditObservador();
    return;
  }

  savingObs.value = true;
  try {
    const selectedObsObj = internalObservadores.value.find(o => o.id === editObsId.value);

    if (props.mareaId && stage.id) {
      await mareasService.updateObservadorEtapa(
        props.mareaId,
        stage.id,
        oldObsId,
        editObsId.value
      );
      emit('action-success', 'Observador actualizado en la etapa.');
    }

    // Actualizar estado reactivo local
    const currentStages = [...props.modelValue];
    const currentStage = { ...currentStages[stageIdx] };
    const currentObsList = (currentStage.observadores || []).map((o: any) => {
      const currentId = o.observadorId || o.id;
      if (currentId === oldObsId) {
        return {
          ...o,
          observadorId: editObsId.value,
          observador: selectedObsObj ? {
            id: selectedObsObj.id,
            nombre: selectedObsObj.nombre,
            apellido: selectedObsObj.apellido
          } : o.observador
        };
      }
      return o;
    });
    currentStage.observadores = currentObsList;
    currentStages[stageIdx] = currentStage;
    emit('update:modelValue', currentStages);

    cancelEditObservador();
  } catch (error: any) {
    console.error('Error editando observador de etapa:', error);
    emit('action-error', error.response?.data?.message || 'Error al actualizar observador.');
  } finally {
    savingObs.value = false;
  }
}

async function removeObservadorFromStage(stage: any, obs: any) {
  const obsId = obs.observadorId || obs.id;
  if (!obsId) return;

  try {
    if (props.mareaId && stage.id) {
      await mareasService.removeObservadorEtapa(props.mareaId, stage.id, obsId);
      emit('action-success', 'Observador desvinculado de la etapa.');
    }

    // Actualizar estado local
    const currentStages = [...props.modelValue];
    const stageIdx = currentStages.findIndex(s => s === stage || (s.id && s.id === stage.id));
    if (stageIdx !== -1) {
      const updatedStage = { ...currentStages[stageIdx] };
      updatedStage.observadores = (updatedStage.observadores || []).filter(
        (o: any) => (o.observadorId || o.id) !== obsId
      );
      currentStages[stageIdx] = updatedStage;
      emit('update:modelValue', currentStages);
    }
  } catch (err: any) {
    console.error('Error removing observador from stage:', err);
    emit('action-error', err.response?.data?.message || 'Error al quitar observador de la etapa.');
  }
}

// Local state para tracking de los toggles de intención de cierre por index
const stageIntencionCierre = ref<Record<number, boolean>>({});
const zarpadaDates = ref<any[]>([]);

const canAddStage = computed(() => {
  if (props.readOnly) return false;
  if (props.modelValue.length === 0) return true;
  const last = props.modelValue[props.modelValue.length - 1];
  
  return !!(
    last.fechaZarpada &&
    last.fechaArribo &&
    last.pesqueriaId &&
    last.tipoEtapa
  );
});

function getEtapaOptions() {
  if (props.tipoMarea === TipoMarea.CI) {
    return [{ value: TipoEtapa.EI, label: TIPO_ETAPA_DESC[TipoEtapa.EI] }];
  }
  return [
    { value: TipoEtapa.EC, label: TIPO_ETAPA_DESC[TipoEtapa.EC] },
    { value: TipoEtapa.EP, label: TIPO_ETAPA_DESC[TipoEtapa.EP] }
  ];
}

async function addStage() {
  if (!canAddStage.value) return;

  const currentStages = [...props.modelValue];
  const lastStage = currentStages[currentStages.length - 1];
  
  let defaultPesqueria = props.defaultPesqueriaId || '';
  let defaultPuertoZarpada = props.puertoBaseId || '';
  let defaultFechaZarpada = props.defaultFechaZarpada || '';

  if (lastStage) {
    if (lastStage.pesqueriaId) defaultPesqueria = lastStage.pesqueriaId;
    if (lastStage.puertoArriboId) defaultPuertoZarpada = lastStage.puertoArriboId;
    defaultFechaZarpada = '';
  }

  currentStages.push({
    id: null,
    nroEtapa: currentStages.length + 1,
    puertoZarpadaId: defaultPuertoZarpada,
    fechaZarpada: defaultFechaZarpada,
    puertoArriboId: '',
    fechaArribo: '',
    pesqueriaId: defaultPesqueria,
    tipoEtapa: props.tipoMarea === TipoMarea.CI ? TipoEtapa.EI : TipoEtapa.EC,
    observaciones: '',
    observadores: []
  });

  emit('update:modelValue', currentStages);

  await nextTick();
  const lastIdx = currentStages.length - 1;
  const targetDate = zarpadaDates.value[lastIdx];
  
  if (targetDate) {
    targetDate.focus();
    const card = document.getElementById(`stage-card-${lastIdx}`);
    if (card) {
      card.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }
}

watch(() => props.modelValue, (newStages) => {
    newStages.forEach((stage, index) => {
      const metadata = stage.metadata as MareaEtapaMetadata;
      const tieneCierre = metadata?.opcionesCierre?.finalizarMareaAlArribo === true;
      if (stageIntencionCierre.value[index] !== tieneCierre) {
         stageIntencionCierre.value[index] = tieneCierre;
      }
    });
}, { deep: true, immediate: true });

function removeStage(index: number) {
  const currentStages = [...props.modelValue];
  currentStages.splice(index, 1);
  emit('update:modelValue', currentStages);
  emit('remove-stage', index);
}

function hasOverlap(index: number) {
  if (index === 0) return false;
  const current = props.modelValue[index];
  const previous = props.modelValue[index - 1];
  
  if (!current.fechaZarpada || !previous.fechaArribo) return false;
  
  const currentStart = new Date(current.fechaZarpada).getTime();
  const previousEnd = new Date(previous.fechaArribo).getTime();
  
  return currentStart < previousEnd; 
}

function isInternalInconsistent(index: number) {
  const stage = props.modelValue[index];
  if (!stage.fechaZarpada || !stage.fechaArribo) return false;
  
  const zarpada = new Date(stage.fechaZarpada).getTime();
  const arribo = new Date(stage.fechaArribo).getTime();
  
  return arribo < zarpada;
}

function isEtapaEnCurso(stage: any) {
  return !!stage.id && !!stage.fechaZarpada && !stage.fechaArribo;
}

async function onToggleIntencionCierre(index: number, stage: any, activar: boolean) {
  if (!props.mareaId) {
    emit('action-warning', 'No se puede modificar la intención de cierre sin una marea guardada.');
    return;
  }

  try {
    await mareasService.setIntencionCierre(props.mareaId, stage.id, activar);
    
    const currentStages = [...props.modelValue];
    const currentStage = { ...currentStages[index] };
    const currentMetadata = (currentStage.metadata as any) || {};

    if (activar) {
      currentStage.metadata = {
        ...currentMetadata,
        opcionesCierre: {
          finalizarMareaAlArribo: true,
          fechaMarca: new Date().toISOString()
        }
      };
    } else {
      currentStage.metadata = { ...currentMetadata };
      if (currentStage.metadata.opcionesCierre) {
        delete currentStage.metadata.opcionesCierre;
      }
    }

    currentStages[index] = currentStage;
    emit('update:modelValue', currentStages);
  } catch (error: any) {
    stageIntencionCierre.value[index] = !activar;
    throw error;
  }
}
</script>
