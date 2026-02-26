<template>
  <PlanificacionDashboardLayout title="Matriz de Experiencia"
    description="Administración de la experiencia de los observadores por pesquería y tipo de flota.">
    <div class="space-y-6 pb-10">
      <!-- Header actions and modes -->
      <div class="flex flex-col gap-3 p-4 lg:p-5 bg-surface rounded-2xl border border-border mt-6">
        <div class="flex flex-col sm:flex-row sm:items-center gap-3">
          <div class="shrink-0">
            <h2 class="text-xl font-bold text-text">Experiencia por Pesquería y Flota</h2>
            <p class="text-text-muted text-sm mt-0.5">Mareas (0+) y Calificación (0 -No apto- a 5)</p>
          </div>

          <!-- Filtros -->
          <div class="flex flex-wrap gap-2 flex-1">
            <SearchInput v-model="filterSearch" placeholder="Buscar por nombre o código..."
              class="flex-1 min-w-[160px]" />
            <select v-model="filterContrato"
              class="text-sm border border-border rounded-lg px-3 py-1.5 bg-surface focus:ring-2 focus:ring-primary/20 outline-none flex-1 min-w-[150px]">
              <option value="">Todos los Contratos</option>
              <option v-for="c in contratos" :key="c" :value="c">{{ c }}</option>
            </select>
            <select v-model="filterTipo"
              class="text-sm border border-border rounded-lg px-3 py-1.5 bg-surface focus:ring-2 focus:ring-primary/20 outline-none flex-1 min-w-[150px]">
              <option value="">Todos los Tipos</option>
              <option v-for="t in tipos" :key="t" :value="t">{{ t }}</option>
            </select>
          </div>
        </div>

        <!-- Filtros de Pesquería -->
        <div class="flex flex-col gap-3 py-3 border-t border-border/50">
          <div class="flex items-center justify-between gap-4">
            <h3 class="text-xs font-bold text-text-muted uppercase tracking-wider">Filtrar por Pesquería</h3>
            <div class="flex gap-2">
              <button @click="selectAllPesquerias"
                class="text-[10px] font-bold text-primary hover:underline transition-all">
                Marcar todo
              </button>
              <span class="text-border text-[10px]">|</span>
              <button @click="deselectAllPesquerias"
                class="text-[10px] font-bold text-text-muted hover:text-danger hover:underline transition-all">
                Desmarcar todo
              </button>
            </div>
          </div>

          <div class="flex flex-wrap gap-x-4 gap-y-2">
            <label v-for="p in activePesquerias" :key="p.id"
              class="flex items-center gap-2 cursor-pointer group select-none">
              <div class="relative flex items-center">
                <input type="checkbox" :value="p.id" v-model="selectedPesqueriasIds"
                  class="peer appearance-none w-4 h-4 border border-border rounded bg-surface checked:bg-primary checked:border-primary transition-all cursor-pointer" />
                <CheckIcon
                  class="absolute w-3 h-3 text-primary-fg opacity-0 peer-checked:opacity-100 left-0.5 pointer-events-none transition-opacity" />
              </div>
              <span class="text-xs text-text-muted group-hover:text-text transition-colors"
                :class="{ 'text-text font-medium': selectedPesqueriasIds.includes(p.id) }">
                {{ p.nombre }}
              </span>
            </label>
          </div>
        </div>

        <div class="flex items-center justify-end gap-3 border-t border-border/50 pt-3">
          <div class="flex items-center gap-2 px-3 py-1.5 bg-surface-muted rounded-lg border border-border">
            <span
              :class="['text-sm font-medium transition-colors', !isEditMode ? 'text-text' : 'text-text-muted']">Lectura</span>
            <BaseSwitch v-model="isEditMode" />
            <span
              :class="['text-sm font-medium transition-colors', isEditMode ? 'text-primary' : 'text-text-muted']">Edición</span>
          </div>

          <button v-if="isEditMode" @click="saveChanges" :disabled="!isDirty || isSaving"
            class="flex items-center justify-center gap-2 px-6 py-2 bg-primary hover:opacity-90 text-primary-fg rounded-xl text-sm font-bold transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-md shadow-primary/20 active:scale-95">
            <template v-if="isSaving">
              <div class="w-4 h-4 border-2 border-primary-fg/30 border-t-primary-fg rounded-full animate-spin"></div>
              <span>Guardando...</span>
            </template>
            <template v-else>
              <CheckIcon class="w-4 h-4" />
              <span>Guardar Configuración</span>
            </template>
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading"
        class="flex flex-col items-center justify-center p-12 bg-surface rounded-2xl border border-border">
        <span class="button-spinner w-8 h-8 border-primary mb-4"></span>
        <p class="text-text-muted font-medium">Cargando catálogo y matriz de experiencia...</p>
      </div>

      <!-- Main Content (Loaded) -->
      <template v-else>
        <!-- Desktop / Tablet View -->
        <div
          class="hidden md:block bg-surface border border-border rounded-2xl shadow-sm relative overflow-x-auto overflow-y-auto custom-scrollbar"
          style="max-height: calc(100vh - 300px); scroll-behavior: smooth;">
          <table class="w-full text-left border-separate border-spacing-0 min-w-max relative">
            <thead class="sticky top-0 z-20 shadow-sm border-b border-border">
              <!-- Nivel 1: Pesquerías -->
              <tr class="bg-surface-muted">
                <th rowspan="2"
                  class="p-4 font-bold text-text text-sm min-w-[280px] sticky left-0 z-30 bg-surface-muted custom-shadow-right align-bottom border-r border-border">
                  <div class="flex items-center justify-between">
                    <span>Observador</span>
                    <span class="text-xs font-normal text-text-muted">Total: {{ visibleObservadores.length }}</span>
                  </div>
                </th>
                <template v-for="pesq in visiblePesquerias" :key="pesq.id">
                  <th :colspan="getVisibleFlotasForPesqueria(pesq.id).length"
                    class="px-2 py-2 text-center font-bold text-text text-xs uppercase tracking-wider border-r border-b border-border bg-surface-muted/90 max-w-[300px] truncate"
                    :title="pesq.nombre">
                    {{ pesq.nombre }}
                  </th>
                </template>
              </tr>
              <!-- Nivel 2: Tipos de Flota -->
              <tr class="bg-surface">
                <template v-for="pesq in visiblePesquerias" :key="pesq.id">
                  <th v-for="(flota, fIdx) in getVisibleFlotasForPesqueria(pesq.id)" :key="flota.id"
                    class="px-2 py-1.5 text-center font-semibold text-text-muted text-[10px] uppercase tracking-wider min-w-[110px]"
                    :class="fIdx < getVisibleFlotasForPesqueria(pesq.id).length - 1 ? 'border-r border-border/50' : 'border-r border-border bg-surface-muted/10'">
                    {{ flota.nombre }}
                  </th>
                </template>
              </tr>
            </thead>
            <tbody class="divide-y divide-border relative z-0">
              <tr v-for="obs in visibleObservadores" :key="obs.id"
                class="hover:bg-surface-muted/20 transition-colors group">
                <td
                  class="p-3 align-middle sticky left-0 bg-surface z-10 custom-shadow-right border-r border-border group-hover:bg-surface-muted/30">
                  <div class="flex flex-col">
                    <span class="text-sm font-bold text-text truncate max-w-[250px]"
                      :title="`${obs.apellido}, ${obs.nombre}`">{{
                        obs.apellido }}, {{ obs.nombre }}</span>
                    <span class="text-[10px] text-text-muted mt-0.5">COD: {{ obs.codigoInterno }} | {{ obs.tipoContrato
                      || 'S/C'
                    }}</span>
                  </div>
                </td>

                <template v-for="pesq in visiblePesquerias" :key="`p-${pesq.id}`">
                  <td v-for="(flota, fIdx) in getVisibleFlotasForPesqueria(pesq.id)" :key="`f-${flota.id}`"
                    class="p-0 align-middle transition-colors relative" :class="[
                      fIdx < getVisibleFlotasForPesqueria(pesq.id).length - 1 ? 'border-r border-border/50' : 'border-r border-border bg-surface-muted/10',
                      !isEditMode && isEmptyCell(obs.id, pesq.id, flota.id) ? 'bg-surface-muted/5' : ''
                    ]">

                    <!-- Modo Edición -->
                    <template v-if="isEditMode">
                      <div
                        class="flex flex-col gap-1 p-1.5 py-2 relative group/cell hover:bg-surface-muted/30 h-full min-h-[58px] justify-center">
                        <div class="flex items-center gap-1.5">
                          <span class="text-[10px] font-medium text-text-muted w-8 text-right shrink-0"
                            title="Mareas (Nro entero de experiencia)">Mar.</span>
                          <input type="number" min="0" step="1"
                            v-model.number="matrix[obs.id][pesq.id][flota.id].experiencia"
                            @input="() => handleInput(obs.id, pesq.id, flota.id)"
                            class="w-full h-6 px-1 text-center text-[11px] font-semibold bg-surface border border-border rounded focus:ring-1 focus:ring-primary/20 focus:border-primary transition-all outline-none"
                            placeholder="-" />
                        </div>
                        <div class="flex items-center gap-1.5">
                          <span class="text-[10px] font-medium text-text-muted w-8 text-right shrink-0"
                            title="Calificación (Ranking 0 a 5)">Cal.</span>
                          <input type="number" min="0" max="5" step="1"
                            v-model.number="matrix[obs.id][pesq.id][flota.id].valor"
                            @input="() => handleInput(obs.id, pesq.id, flota.id)"
                            class="w-full h-6 px-1 text-center text-[11px] font-bold bg-surface border border-border rounded focus:ring-1 focus:ring-primary/20 focus:border-primary transition-all outline-none"
                            :class="{
                              'text-danger border-danger/30 bg-danger/5': matrix[obs.id][pesq.id][flota.id].valor === 0,
                              'text-warning border-warning/30 bg-warning/5': matrix[obs.id][pesq.id][flota.id].valor && matrix[obs.id][pesq.id][flota.id].valor! > 0
                            }" placeholder="-" />
                        </div>
                        <!-- Limpiar btn -->
                        <button v-if="!isEmptyCell(obs.id, pesq.id, flota.id)"
                          @click.stop="clearCell(obs.id, pesq.id, flota.id)"
                          class="absolute right-0 top-0 text-text-muted hover:text-danger opacity-0 group-hover/cell:opacity-100 transition-all p-0.5 bg-surface rounded-bl z-20"
                          title="Limpiar valor de esta celda">
                          <XIcon class="w-3 h-3" />
                        </button>
                      </div>
                    </template>

                    <!-- Modo Vista -->
                    <template v-else>
                      <div class="h-14 flex flex-col items-center justify-center p-1 px-1.5 gap-0.5">
                        <template v-if="!isEmptyCell(obs.id, pesq.id, flota.id)">
                          <!-- Mareas / Experiencia numerica -->
                          <div
                            class="flex items-center gap-1 text-[11px] font-medium text-text bg-surface-muted px-1.5 rounded"
                            title="Total Mareas">
                            <span class="text-text-muted shrink-0">Mareas: </span>
                            <span>{{ matrix[obs.id]?.[pesq.id]?.[flota.id].experiencia ?? '-' }}</span>
                          </div>

                          <!-- Rating / Valor -->
                          <div class="flex justify-center h-4 items-center">
                            <span v-if="matrix[obs.id]?.[pesq.id]?.[flota.id].valor === 0" class="text-sm cursor-help"
                              title="No Apto">😡</span>
                            <div v-else-if="matrix[obs.id]?.[pesq.id]?.[flota.id].valor"
                              class="flex gap-[1px] cursor-help"
                              :title="`Calificación: ${matrix[obs.id][pesq.id][flota.id].valor}`">
                              <span v-for="i in matrix[obs.id]?.[pesq.id]?.[flota.id].valor" :key="i"
                                class="text-warning text-[10px] leading-none">⭐</span>
                            </div>
                            <span v-else class="text-text-muted/30 text-[10px]">-</span>
                          </div>
                        </template>
                        <span v-else class="text-text-muted/20 text-xs">-</span>
                      </div>
                    </template>
                  </td>
                </template>
              </tr>
              <tr v-if="visibleObservadores.length === 0">
                <td :colspan="(visiblePesquerias.length * visibleFlotas.length) + 1"
                  class="p-8 text-center text-text-muted">
                  No hay relaciones configuradas para mostrar. Seleccione el modo de edición o cambie sus filtros.
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Mobile View (Tarjetas agrupadas por Observador) -->
        <div class="block md:hidden space-y-4">
          <div v-if="visibleObservadores.length === 0"
            class="p-8 text-center text-text-muted bg-surface rounded-xl border border-border">
            No hay relaciones configuradas para mostrar.
          </div>

          <div v-for="obs in visibleObservadores" :key="'mob-' + obs.id"
            class="bg-surface border border-border rounded-xl p-4 shadow-sm">
            <div class="font-bold text-text mb-3 border-b border-border pb-2 flex justify-between items-center">
              <span class="truncate">{{ obs.apellido }}, {{ obs.nombre }}</span>
              <span
                class="text-[10px] text-text-muted font-normal bg-surface-muted px-2 py-0.5 rounded ml-2 shrink-0">{{
                  obs.codigoInterno }}</span>
            </div>

            <div class="space-y-4">
              <!-- Iteramos Pesquerías -->
              <template v-for="pesq in visiblePesquerias" :key="pesq.id">
                <div v-if="getVisibleFlotasForPesqueria(pesq.id).length > 0" class="space-y-2">
                  <h4 class="text-xs font-bold text-text uppercase border-b border-border/50 pb-1">{{ pesq.nombre }}
                  </h4>

                  <!-- Iteramos Flotas dentro de pesqueria -->
                  <div class="space-y-2 pl-2">
                    <div v-for="flota in getVisibleFlotasForPesqueria(pesq.id)" :key="flota.id"
                      class="flex items-center justify-between text-sm">

                      <span class="text-text-muted w-1/3 text-[11px] leading-tight pr-2">{{ flota.nombre }}</span>

                      <template v-if="isEditMode">
                        <div class="flex items-center gap-1 flex-1 justify-end">
                          <div class="flex items-center gap-1">
                            <span class="text-[9px] text-text-muted">Mar.</span>
                            <input type="number" min="0" v-model.number="matrix[obs.id][pesq.id][flota.id].experiencia"
                              @input="() => handleInput(obs.id, pesq.id, flota.id)"
                              class="w-[45px] h-7 px-1 text-center text-[10px] bg-surface-muted border border-border rounded outline-none"
                              placeholder="-" title="Mareas" />
                          </div>
                          <div class="flex items-center gap-1">
                            <span class="text-[9px] text-text-muted">Cal.</span>
                            <input type="number" min="0" max="5"
                              v-model.number="matrix[obs.id][pesq.id][flota.id].valor"
                              @input="() => handleInput(obs.id, pesq.id, flota.id)"
                              class="w-[45px] h-7 px-1 text-center text-[10px] font-bold bg-surface-muted border border-border rounded focus:border-primary outline-none"
                              placeholder="-" title="Calificación" />
                          </div>
                          <button v-if="!isEmptyCell(obs.id, pesq.id, flota.id)"
                            @click="clearCell(obs.id, pesq.id, flota.id)"
                            class="text-text-muted hover:text-danger w-6 h-7 flex items-center justify-center bg-surface-muted rounded transition-colors"
                            title="Limpiar">
                            <XIcon class="w-3 h-3" />
                          </button>
                          <div v-else class="w-6"></div> <!-- Spacer -->
                        </div>
                      </template>
                      <template v-else>
                        <div class="flex flex-col items-end w-2/3">
                          <template v-if="!isEmptyCell(obs.id, pesq.id, flota.id)">
                            <div class="text-[10px] text-text-muted bg-surface-muted px-1.5 rounded mb-0.5">Mareas:
                              <span class="text-text font-medium">{{ matrix[obs.id]?.[pesq.id]?.[flota.id].experiencia
                                ?? '-'
                                }}</span></div>
                            <div class="flex items-center h-4">
                              <span v-if="matrix[obs.id]?.[pesq.id]?.[flota.id].valor === 0" class="text-xs">😡</span>
                              <div v-else-if="matrix[obs.id]?.[pesq.id]?.[flota.id].valor" class="flex gap-0.5">
                                <span v-for="i in matrix[obs.id]?.[pesq.id]?.[flota.id].valor" :key="i"
                                  class="text-warning text-[9px]">⭐</span>
                              </div>
                            </div>
                          </template>
                          <span v-else class="text-text-muted/30 text-[10px]">-</span>
                        </div>
                      </template>
                    </div>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
      </template>
    </div>
  </PlanificacionDashboardLayout>
</template>

<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue';
import PlanificacionDashboardLayout from '../layouts/PlanificacionDashboardLayout.vue';
import BaseSwitch from '@/components/ui/BaseSwitch.vue';
import SearchInput from '@/components/ui/SearchInput.vue';
import { planificacionService } from '../services/planificacion.service';
import catalogosService from '@/modules/mareas/services/catalogos.service';
import { toast } from 'vue-sonner';
import { CheckIcon, XIcon } from '@/icons';

// Estados de la UI
const isLoading = ref(true);
const isSaving = ref(false);
const isEditMode = ref(false);
const isDirty = ref(false);

// Filtros
const filterContrato = ref('');
const filterTipo = ref('');
const filterSearch = ref('');
const selectedPesqueriasIds = ref<string[]>([]);

// Catálogos
const observadores = ref<any[]>([]);
const pesquerias = ref<any[]>([]);
const flotas = ref<any[]>([]);

const contratos = computed(() => {
  const set = new Set(observadores.value.map(o => o.tipoContrato).filter(Boolean));
  return Array.from(set).sort();
});

const tipos = computed(() => {
  const set = new Set(observadores.value.map(o => o.tipoObservador).filter(Boolean));
  return Array.from(set).sort();
});

const activePesquerias = computed(() => {
  return pesquerias.value.filter(p => p.activo).sort((a, b) => a.nombre.localeCompare(b.nombre));
});

/**
 * Matriz Reactiva de Datos Transpuesta
 * Estructura: matrix[observadorId][pesqueriaId][tipoFlotaId] = { valor: number | null, experiencia: number | null }
 */
interface CellData {
  valor: number | null;
  experiencia: number | null;
}
const matrix = ref<Record<string, Record<string, Record<string, CellData>>>>({});

// Helper para comprobar si una celda está vacía
const isEmptyCell = (obsId: string, pesqId: string, flotaId: string) => {
  const cell = matrix.value[obsId]?.[pesqId]?.[flotaId];
  if (!cell) return true;
  return (cell.valor === null || cell.valor === undefined) &&
    (cell.experiencia === null || cell.experiencia === undefined);
};

const clearCell = (obsId: string, pesqId: string, flotaId: string) => {
  if (matrix.value[obsId] && matrix.value[obsId][pesqId] && matrix.value[obsId][pesqId][flotaId]) {
    matrix.value[obsId][pesqId][flotaId].valor = null;
    matrix.value[obsId][pesqId][flotaId].experiencia = null;
    isDirty.value = true;
  }
};

const visibleFlotas = computed(() => {
  return flotas.value
    .filter(f => f.codigo === 'ALTURA_FRESQUERO' || f.codigo === 'ALTURA_CONGELADOR')
    .slice()
    .sort((a: any, b: any) => (a.orden || 0) - (b.orden || 0));
});

const selectAllPesquerias = () => {
  selectedPesqueriasIds.value = activePesquerias.value.map(p => p.id);
};

const deselectAllPesquerias = () => {
  selectedPesqueriasIds.value = [];
};

/**
 * Retorna las flotas que deben mostrarse para una pesquería específica.
 * En modo Edición muestra todas las flotas configuradas.
 * En modo Lectura muestra solo las flotas que tienen datos para los observadores filtrados.
 */
const getVisibleFlotasForPesqueria = (pesqId: string) => {
  const potentialFlotas = visibleFlotas.value;
  if (isEditMode.value) return potentialFlotas;

  // Filtrar flotas que tengan al menos una celda con datos en los observadores actualmente filtrados
  // Para evitar dependencia circular con 'visibleObservadores', usamos los observadores base filtrados por tipos/contratos/búsqueda
  return potentialFlotas.filter(f => {
    return filteredObservadoresBase.value.some(obs => !isEmptyCell(obs.id, pesqId, f.id));
  });
};

// Observadores filtrados por criterios de búsqueda y combos (sin el filtro de "tiene relación")
const filteredObservadoresBase = computed(() => {
  let list = observadores.value.slice();
  const search = filterSearch.value?.toLowerCase().trim() || '';
  const contrato = filterContrato.value;
  const tipo = filterTipo.value;

  return list.filter(o => {
    if (search) {
      const nom = (o.nombre || '').toLowerCase();
      const ape = (o.apellido || '').toLowerCase();
      const cod = o.codigoInterno != null ? String(o.codigoInterno).toLowerCase() : '';
      const full = `${ape} ${nom}`.toLowerCase();
      if (!nom.includes(search) && !ape.includes(search) && !cod.includes(search) && !full.includes(search)) return false;
    }
    if (contrato && o.tipoContrato !== contrato) return false;
    if (tipo && o.tipoObservador !== tipo) return false;
    return true;
  });
});

// En modo de visualización, ocultamos pesquerías o flotas sin datos configurados.
// Para formato en transpuesta, normalmente mostramos todas las flotas de las pesquerías activas.
const visiblePesquerias = computed(() => {
  let list = activePesquerias.value.slice();

  // Filtrar por selección de checkboxes
  list = list.filter(p => selectedPesqueriasIds.value.includes(p.id));

  if (!isEditMode.value) {
    list = list.filter(p => {
      // Oculta pesquería si no tiene ninguna FLOTA visible (es decir, con datos)
      return getVisibleFlotasForPesqueria(p.id).length > 0;
    });
  }
  return list;
});

const visibleObservadores = computed(() => {
  const list = filteredObservadoresBase.value.slice();
  const editMode = isEditMode.value;

  const result = list.filter(o => {
    // 3. Filtro de Relaciones (Modo Lectura): Solo mostrar si tiene datos en las columnas actualmente visibles
    if (!editMode) {
      const hasRel = visiblePesquerias.value.some(p => {
        return getVisibleFlotasForPesqueria(p.id).some(f => !isEmptyCell(o.id, p.id, f.id));
      });
      if (!hasRel) return false;
    }
    return true;
  });

  // Ordenar
  return result.sort((a: any, b: any) => {
    const apeA = (a.apellido || '').toLowerCase();
    const apeB = (b.apellido || '').toLowerCase();
    if (apeA === apeB) {
      return (a.nombre || '').toLowerCase().localeCompare((b.nombre || '').toLowerCase());
    }
    return apeA.localeCompare(apeB);
  });
});

const initMatrix = () => {
  const newMatrix: Record<string, Record<string, Record<string, CellData>>> = {};
  observadores.value.forEach((obs: any) => {
    newMatrix[obs.id] = {};
    pesquerias.value.forEach((p: any) => {
      newMatrix[obs.id][p.id] = {};
      flotas.value.forEach((f: any) => {
        newMatrix[obs.id][p.id][f.id] = { valor: null, experiencia: null };
      });
    });
  });
  matrix.value = newMatrix;
};

const loadData = async () => {
  isLoading.value = true;
  isDirty.value = false;
  try {
    const [obsRes, pesqRes, flotasRes] = await Promise.all([
      catalogosService.getObservadores(),
      catalogosService.getPesquerias(),
      catalogosService.getTiposFlota()
    ]);

    observadores.value = obsRes.filter((o: any) => o.activo);
    pesquerias.value = pesqRes.filter((p: any) => p.activo);
    flotas.value = flotasRes.filter((f: any) => f.activo);

    // Inicializar seleccionados si es la primera vez o está vacío
    if (selectedPesqueriasIds.value.length === 0) {
      selectedPesqueriasIds.value = pesquerias.value.map(p => p.id);
    }

    initMatrix();

    // Cargar experiencias actuales
    const expRes = await planificacionService.getExperienciaObservadores();

    expRes.forEach(exp => {
      if (matrix.value[exp.observadorId] &&
        matrix.value[exp.observadorId][exp.pesqueriaId] &&
        matrix.value[exp.observadorId][exp.pesqueriaId][exp.tipoFlotaId]) {

        matrix.value[exp.observadorId][exp.pesqueriaId][exp.tipoFlotaId] = {
          valor: exp.valor,
          experiencia: exp.experiencia
        };
      }
    });

  } catch (error) {
    console.error("Error al cargar datos", error);
    toast.error('Ocurrió un error al cargar la matriz de experiencia.');
  } finally {
    isLoading.value = false;
  }
};

const handleInput = (obsId: string, pesqId: string, flotaId: string) => {
  isDirty.value = true;
  const cell = matrix.value[obsId][pesqId][flotaId];

  // Limpiar vacíos p.ej. cadenas del type number default handling de Vue
  if (cell.valor === '' as any) cell.valor = null;
  if (cell.experiencia === '' as any) cell.experiencia = null;

  // Validaciones
  if (cell.valor !== null && cell.valor !== undefined) {
    if (cell.valor < 0) cell.valor = 0;
    if (cell.valor > 5) cell.valor = 5;
    cell.valor = Math.floor(cell.valor);
  }

  if (cell.experiencia !== null && cell.experiencia !== undefined) {
    if (cell.experiencia < 0) cell.experiencia = 0;
    cell.experiencia = Math.floor(cell.experiencia);
  }
};

const saveChanges = async () => {
  if (!isDirty.value) return;

  isSaving.value = true;
  try {
    const arrayPlano: any[] = [];

    // Aplanar enviando solo lo que no está vacío
    for (const oId in matrix.value) {
      for (const pId in matrix.value[oId]) {
        for (const fId in matrix.value[oId][pId]) {
          const cell = matrix.value[oId][pId][fId];
          if (!isEmptyCell(oId, pId, fId)) {
            arrayPlano.push({
              observadorId: oId,
              pesqueriaId: pId,
              tipoFlotaId: fId,
              valor: cell.valor,
              experiencia: cell.experiencia
            });
          }
        }
      }
    }

    await planificacionService.upsertExperienciaObservadoresBatch({
      experiencias: arrayPlano
    });

    toast.success('Se actualizó la matriz de experiencia correctamente.');
    isDirty.value = false;
    isEditMode.value = false;

    // Refrescar para ver el listado actualizado en base a persistencia si estuvimos filtrando o similares
    await loadData();

  } catch (error) {
    console.error(error);
    toast.error('Ocurrió un error al intentar guardar la configuración.');
  } finally {
    isSaving.value = false;
  }
};

watch(() => isEditMode.value, (newVal) => {
  if (!newVal && isDirty.value) {
    toast.info('Se descartaron los cambios no guardados');
    loadData();
  }
});

onMounted(() => {
  loadData();
});
</script>

<style scoped>
.custom-shadow-right {
  box-shadow: 4px 0 8px -2px rgba(0, 0, 0, 0.05);
}

.dark .custom-shadow-right {
  box-shadow: 4px 0 8px -2px rgba(0, 0, 0, 0.2);
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
  -webkit-appearance: none;
  margin: 0;
}

input[type=number] {
  -webkit-appearance: textfield;
  -moz-appearance: textfield;
  appearance: textfield;
}

/* Remover fondo autocompletado en navegadores como Chrome para el input tipo celda editada */
input:-webkit-autofill {
  -webkit-box-shadow: 0 0 0 30px transparent inset !important;
  background-color: transparent !important;
}

/* Scrollbar Estilizada - Forzar visibilidad */
.custom-scrollbar {
  scrollbar-width: thin;
  scrollbar-color: #cbd5e1 transparent;
}

.custom-scrollbar::-webkit-scrollbar {
  width: 10px;
  height: 10px;
  display: block !important;
}

.custom-scrollbar::-webkit-scrollbar-track {
  background: #f1f5f9;
  border-radius: 10px;
}

.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #94a3b8;
  border-radius: 10px;
  border: 2px solid #f1f5f9;
}

.custom-scrollbar::-webkit-scrollbar-thumb:hover {
  background: #64748b;
}

/* Asegurar que el contenido no tape la barra horizontal */
.custom-scrollbar {
  padding-bottom: 4px;
}
</style>
