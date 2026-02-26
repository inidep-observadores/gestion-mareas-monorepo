<template>
  <PlanificacionDashboardLayout
    title="Matriz de Experiencia"
    description="Administración de la experiencia de los observadores por pesquería."
  >
    <div class="space-y-6 max-w-7xl mx-auto pb-10">

      <!-- Header actions and modes -->
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 p-4 lg:p-6 bg-surface rounded-2xl border border-border mt-6">
        <div>
          <h2 class="text-xl font-bold text-text">Experiencia por Pesquería</h2>
          <p class="text-text-muted text-sm mt-1">Calificación de 0 (No apto) a 5 (Alta experiencia)</p>
        </div>

        <div class="flex items-center gap-3">
          <!-- Filtros -->
          <div class="flex flex-col md:flex-row gap-3 mr-4 flex-1">
            <SearchInput
              v-model="filterSearch"
              placeholder="Buscar por nombre o código..."
              class="max-w-md flex-1"
            />
            <select v-model="filterContrato" class="text-sm border border-border rounded-lg px-3 py-1.5 bg-surface focus:ring-2 focus:ring-primary/20 outline-none min-w-[180px]">
              <option value="">Todos los Contratos</option>
              <option v-for="c in contratos" :key="c" :value="c">{{ c }}</option>
            </select>
            <select v-model="filterTipo" class="text-sm border border-border rounded-lg px-3 py-1.5 bg-surface focus:ring-2 focus:ring-primary/20 outline-none min-w-[180px]">
              <option value="">Todos los Tipos</option>
              <option v-for="t in tipos" :key="t" :value="t">{{ t }}</option>
            </select>
          </div>

          <div class="flex items-center gap-2 px-3 py-1.5 bg-surface-muted rounded-lg border border-border">
            <span :class="['text-sm font-medium transition-colors', !isEditMode ? 'text-text' : 'text-text-muted']">Lectura</span>
            <BaseSwitch v-model="isEditMode" />
            <span :class="['text-sm font-medium transition-colors', isEditMode ? 'text-primary' : 'text-text-muted']">Edición</span>
          </div>

          <button v-if="isEditMode" @click="saveChanges" :disabled="!isDirty || isSaving"
            class="flex items-center justify-center gap-2 px-6 py-2.5 bg-primary hover:opacity-90 text-primary-fg rounded-xl text-sm font-bold transition-all disabled:opacity-50 disabled:cursor-not-allowed shadow-md shadow-primary/20 active:scale-95 min-w-[160px]">
            <template v-if="isSaving">
              <div class="w-4 h-4 border-2 border-primary-fg/30 border-t-primary-fg rounded-full animate-spin"></div>
              <span>Guardando...</span>
            </template>
            <template v-else>
              <CheckIcon class="w-4 h-4" />
              <span>Guardar Cambios</span>
            </template>
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center p-12 bg-surface rounded-2xl border border-border">
        <span class="button-spinner w-8 h-8 border-primary mb-4"></span>
        <p class="text-text-muted font-medium">Cargando catálogo y matriz de experiencia...</p>
      </div>

      <!-- Main Content (Loaded) -->
      <template v-else>
        <!-- Desktop / Tablet View: Full Matrix Table -->
        <div class="hidden md:block bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
          <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-surface-muted/50 border-b border-border">
                  <th class="p-4 font-semibold text-text text-sm min-w-[280px] sticky left-0 bg-surface z-10 custom-shadow-right">
                    Observador
                  </th>
                  <th v-for="pesq in visiblePesquerias" :key="pesq.id" class="p-3 text-center font-semibold text-text-muted text-xs uppercase tracking-wider min-w-[100px] border-l border-border/50">
                    {{ pesq.nombre }}
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border">
                <tr v-for="obs in visibleObservadores" :key="obs.id" class="hover:bg-surface-muted/20 transition-colors">
                  <td class="p-4 align-middle sticky left-0 bg-surface z-10 custom-shadow-right">
                    <div class="flex flex-col">
                      <span class="text-sm font-bold text-text">{{ obs.apellido }}, {{ obs.nombre }}</span>
                      <span class="text-xs text-text-muted mt-0.5">COD: {{ obs.codigoInterno }}</span>
                    </div>
                  </td>

                  <td v-for="pesq in visiblePesquerias" :key="pesq.id" class="p-0 align-middle text-center border-l border-border/50 transition-colors"
                    :class="{
                      'bg-surface-muted/10': !isEditMode && matrix[obs.id]?.[pesq.id] === null
                    }">
                    <!-- Modo Edición -->
                    <template v-if="isEditMode">
                      <div class="p-2 relative group">
                         <input type="number" min="0" max="5"
                          v-model.number="matrix[obs.id][pesq.id]"
                          @input="() => handleInput(obs.id, pesq.id)"
                          class="w-full h-10 px-2 text-center text-sm font-semibold bg-surface-muted border border-border rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none"
                          :class="{
                             'text-danger border-danger/30 bg-danger/5': matrix[obs.id][pesq.id] === 0,
                             'text-primary border-primary/30 bg-primary/5': matrix[obs.id][pesq.id] !== null && matrix[obs.id][pesq.id] !== undefined && (matrix[obs.id][pesq.id] as number) > 0
                          }"
                          placeholder="-" />
                         <button v-if="matrix[obs.id][pesq.id] !== null && matrix[obs.id][pesq.id] !== undefined"
                           @click="() => { (matrix[obs.id][pesq.id] as any) = null; isDirty = true; }"
                           class="absolute right-3 top-1/2 -translate-y-1/2 text-text-muted hover:text-danger opacity-0 group-hover:opacity-100 transition-all p-1"
                           title="Limpiar valor">
                           <XIcon class="w-3.5 h-3.5" />
                         </button>
                      </div>
                    </template>
                    <!-- Modo Vista -->
                    <template v-else>
                      <div class="h-12 flex items-center justify-center p-2">
                        <template v-if="matrix[obs.id]?.[pesq.id] !== null && matrix[obs.id]?.[pesq.id] !== undefined">
                          <span v-if="matrix[obs.id]?.[pesq.id] === 0" class="text-xl" title="No Apto">😡</span>
                          <div v-else class="flex gap-0.5" :title="`Experiencia: ${matrix[obs.id]?.[pesq.id]}`">
                            <span v-for="i in matrix[obs.id]?.[pesq.id]" :key="i" class="text-warning text-sm">⭐</span>
                          </div>
                        </template>
                        <span v-else class="text-text-muted/30 text-xs">-</span>
                      </div>
                    </template>
                  </td>
                </tr>
                <tr v-if="visibleObservadores.length === 0">
                  <td :colspan="visiblePesquerias.length + 1" class="p-8 text-center text-text-muted">
                    No hay relaciones configuradas para mostrar.
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Mobile View -->
        <div class="block md:hidden space-y-4">
           <div v-if="visibleObservadores.length === 0" class="p-8 text-center text-text-muted bg-surface rounded-xl border border-border">
              No hay relaciones configuradas para mostrar.
           </div>
           <div v-for="obs in visibleObservadores" :key="'mob-' + obs.id" class="bg-surface border border-border rounded-xl p-4">
              <div class="font-bold text-text mb-3 border-b border-border pb-2">{{ obs.apellido }}, {{ obs.nombre }} <span class="text-xs text-text-muted font-normal ml-2">ID: {{ obs.codigoInterno }}</span></div>
              <div class="space-y-3">
                 <div v-for="pesq in visiblePesquerias" :key="pesq.id" class="flex items-center justify-between">
                    <span class="text-sm text-text-muted">{{ pesq.nombre }}</span>

                    <template v-if="isEditMode">
                      <div class="flex items-center gap-2">
                         <input type="number" min="0" max="5"
                            v-model.number="matrix[obs.id][pesq.id]"
                            @input="() => handleInput(obs.id, pesq.id)"
                            class="w-16 h-8 px-2 text-center text-sm font-semibold bg-surface-muted border border-border rounded-lg"
                            placeholder="-" />
                         <button v-if="matrix[obs.id][pesq.id] !== null && matrix[obs.id][pesq.id] !== undefined"
                            @click="() => { (matrix[obs.id][pesq.id] as any) = null; isDirty = true; }"
                            class="text-text-muted hover:text-danger transition-colors"
                            title="Limpiar valor">
                            <XIcon class="w-4 h-4" />
                         </button>
                      </div>
                    </template>
                    <template v-else>
                        <template v-if="matrix[obs.id]?.[pesq.id] !== null && matrix[obs.id]?.[pesq.id] !== undefined">
                          <span v-if="matrix[obs.id]?.[pesq.id] === 0" class="text-xl">😡</span>
                          <div v-else class="flex gap-0.5">
                            <span v-for="i in matrix[obs.id]?.[pesq.id]" :key="i" class="text-warning text-sm truncate">⭐</span>
                          </div>
                        </template>
                        <span v-else class="text-text-muted/30 text-xs">-</span>
                    </template>
                 </div>
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

// Catálogos
const observadores = ref<any[]>([]);
const pesquerias = ref<any[]>([]);

const contratos = computed(() => {
  const set = new Set(observadores.value.map(o => o.tipoContrato).filter(Boolean));
  return Array.from(set).sort();
});

const tipos = computed(() => {
  const set = new Set(observadores.value.map(o => o.tipoObservador).filter(Boolean));
  return Array.from(set).sort();
});

/**
 * Matriz Reactiva de Datos
 * Estructura: matrix[observadorId][pesqueriaId] = numero | null
 */
const matrix = ref<Record<string, Record<string, number | null>>>({});

// En modo edición mostramos todos. En visualización filtramos filas y columnas sin relaciones registradas.
const visiblePesquerias = computed(() => {
  let list = pesquerias.value.slice().sort((a: any, b: any) => a.nombre.localeCompare(b.nombre));

  if (!isEditMode.value) {
     list = list.filter(p => {
       // Buscar si al menos un observador tiene una relación con esta pesquería
       return observadores.value.some(obs => matrix.value[obs.id]?.[p.id] != null);
     });
  }
  return list;
});

const visibleObservadores = computed(() => {
  let list = observadores.value.slice();

  const search = filterSearch.value?.toLowerCase().trim() || '';
  const contrato = filterContrato.value;
  const tipo = filterTipo.value;
  const editMode = isEditMode.value;

  list = list.filter(o => {
    // 1. Filtro de Búsqueda
    if (search) {
      const nom = (o.nombre || '').toLowerCase();
      const ape = (o.apellido || '').toLowerCase();
      const cod = o.codigoInterno != null ? String(o.codigoInterno).toLowerCase() : '';
      const full = `${ape} ${nom}`.toLowerCase();

      if (!nom.includes(search) && !ape.includes(search) && !cod.includes(search) && !full.includes(search)) {
        return false;
      }
    }

    // 2. Filtros de Combo
    if (contrato && o.tipoContrato !== contrato) return false;
    if (tipo && o.tipoObservador !== tipo) return false;

    // 3. Filtro de Relaciones (Modo Lectura)
    if (!editMode) {
       const hasRel = pesquerias.value.some(p => matrix.value[o.id]?.[p.id] != null);
       if (!hasRel) return false;
    }

    return true;
  });

  // Ordenar
  return list.sort((a: any, b: any) => {
    const apeA = (a.apellido || '').toLowerCase();
    const apeB = (b.apellido || '').toLowerCase();
    if (apeA === apeB) {
      return (a.nombre || '').toLowerCase().localeCompare((b.nombre || '').toLowerCase());
    }
    return apeA.localeCompare(apeB);
  });
});

const initMatrix = () => {
  const newMatrix: Record<string, Record<string, number | null>> = {};
  observadores.value.forEach((obs: any) => {
    newMatrix[obs.id] = {};
    pesquerias.value.forEach((p: any) => {
       newMatrix[obs.id][p.id] = null;
    });
  });
  matrix.value = newMatrix;
};

const loadData = async () => {
  isLoading.value = true;
  isDirty.value = false;
  try {
    // 1. Cargar observadores activos y pesquerías activas
    const [obsRes, pesqRes] = await Promise.all([
      catalogosService.getObservadores(),
      catalogosService.getPesquerias()
    ]);

    // Todos los observadores activos entran, incluso los no disponibles o con impedimento.
    observadores.value = obsRes.filter((o:any) => o.activo);
    pesquerias.value = pesqRes.filter((p:any) => p.activo);

    initMatrix();

    // 2. Cargar experiencias actuales
    const expRes = await planificacionService.getExperienciaObservadores();

    // 3. Poblar matriz
    expRes.forEach(exp => {
      // Validamos que el observador y la pesquería sigan activos/existan
      if (matrix.value[exp.observadorId] && matrix.value[exp.observadorId][exp.pesqueriaId] !== undefined) {
         matrix.value[exp.observadorId][exp.pesqueriaId] = exp.valor;
      }
    });

  } catch (error) {
    console.error("Error al cargar datos", error);
    toast.error('Ocurrió un error al cargar la información de experiencia.');
  } finally {
    isLoading.value = false;
  }
};

const handleInput = (obsId: string, pesqId: string) => {
  isDirty.value = true;

  // Validar el rango 0..5
  const val = matrix.value[obsId][pesqId];
  if (val !== null && val !== undefined) {
     if (val < 0) matrix.value[obsId][pesqId] = 0;
     if (val > 5) matrix.value[obsId][pesqId] = 5;

     // Evitar que el input numeric ponga un string si se escribe a mano y no falla la conversión en VUE
     matrix.value[obsId][pesqId] = Math.floor(matrix.value[obsId][pesqId]!);
  }
};

const saveChanges = async () => {
  if (!isDirty.value) return;

  isSaving.value = true;
  try {
    const arrayPlano: { observadorId: string; pesqueriaId: string; valor: number | null }[] = [];

    // Aplanar la matriz solo con las celdas que fueron tocadas o todas
    for (const oId in matrix.value) {
      for (const pId in matrix.value[oId]) {
        const val = matrix.value[oId][pId];
        // si es vacío en string también lo pasaremos como null
        if (val === '' as any) {
           matrix.value[oId][pId] = null;
        }

        arrayPlano.push({
          observadorId: oId,
          pesqueriaId: pId,
          valor: matrix.value[oId][pId]
        });
      }
    }

    const res = await planificacionService.upsertExperienciaObservadoresBatch({
      experiencias: arrayPlano
    });

    toast.success('Se actualizó la matriz de experiencia correctamente.');
    isDirty.value = false;
    isEditMode.value = false;

    await loadData(); // recargar para asegurar sincronización y refrescar grilla de visualización

  } catch (error) {
    console.error(error);
    toast.error('Ocurrió un error al intentar guardar la matriz.');
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
  -moz-appearance: textfield;
}
</style>
