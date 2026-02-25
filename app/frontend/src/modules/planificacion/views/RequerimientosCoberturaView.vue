<template>
  <PlanificacionDashboardLayout
    title="Requerimientos de Cobertura"
    description="Administración mensual de requerimientos por pesquería y tipo de flota."
  >
    <div class="space-y-6 max-w-7xl mx-auto pb-10">

      <!-- Header actions and modes -->
      <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 p-4 lg:p-6 bg-surface rounded-2xl border border-border mt-6">
        <div>
          <h2 class="text-xl font-bold text-text">Matriz de Requerimientos</h2>
          <p class="text-text-muted text-sm mt-1">Año operativo activo: <span class="font-bold text-info">{{ configStore.selectedYear }}</span></p>
        </div>

        <div class="flex items-center gap-3">
          <!-- Toggle Modo Edición -->
          <!-- Filtro por Pesquería (Solo en modo Vista) -->
          <div v-if="!isEditMode" class="flex items-center gap-2">
            <label for="pesqueria-filter" class="text-xs font-bold text-text-muted uppercase">Filtrar:</label>
            <select id="pesqueria-filter" v-model="selectedPesqueriaId" 
              class="bg-surface border border-border text-sm rounded-lg px-3 py-1.5 focus:border-primary outline-none transition-all">
              <option value="">Todas las pesquerías</option>
              <option v-for="p in catalogos.pesquerias" :key="p.id" :value="p.id">{{ p.nombre }}</option>
            </select>
          </div>

          <div class="flex items-center gap-2 px-3 py-1.5 bg-surface-muted rounded-lg border border-border">
            <span :class="['text-sm font-medium transition-colors', !isEditMode ? 'text-text' : 'text-text-muted']">Lectura</span>
            <BaseSwitch v-model="isEditMode" />
            <span :class="['text-sm font-medium transition-colors', isEditMode ? 'text-primary' : 'text-text-muted']">Edición</span>
          </div>

          <button v-if="isEditMode" @click="saveChanges" :disabled="!isDirty || isSaving"
            class="button-primary min-w-[140px]">
            <span v-if="isSaving" class="button-spinner mr-2"></span>
            {{ isSaving ? 'Guardando...' : 'Guardar Cambios' }}
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="isLoading" class="flex flex-col items-center justify-center p-12 bg-surface rounded-2xl border border-border">
        <span class="button-spinner w-8 h-8 border-primary mb-4"></span>
        <p class="text-text-muted font-medium">Cargando catálogo y matriz de requerimientos...</p>
      </div>

      <!-- Main Content (Loaded) -->
      <template v-else>
        <!-- Desktop / Tablet View: Full Matrix Table -->
        <div class="hidden lg:block bg-surface border border-border rounded-2xl overflow-hidden shadow-sm">
          <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="bg-surface-muted/50 border-b border-border">
                  <th class="p-4 font-semibold text-text text-sm w-[280px] sticky left-0 bg-surface z-10 custom-shadow-right">
                    Pesquería / Flota
                  </th>
                  <th v-for="month in months" :key="month.num" class="p-3 text-center font-semibold text-text-muted text-xs uppercase tracking-wider min-w-[70px]">
                    {{ month.shortStr }}
                  </th>
                  <th class="p-4 font-bold text-info text-sm text-center">
                    Total
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-border">
                <template v-for="pesq in visiblePesquerias" :key="pesq.id">
                  <!-- Solo mostramos aquellas que tienen flotas asociadas -->
                  <tr v-for="(flota, fIdx) in pesq.flotaAsignada" :key="flota.id" class="hover:bg-surface-muted/20 transition-colors">
                    
                    <td class="p-4 align-middle sticky left-0 bg-surface z-10 custom-shadow-right">
                      <div class="flex flex-col">
                        <span v-if="fIdx === 0" class="text-xs font-bold text-text uppercase tracking-wide mb-1">{{ pesq.nombre }}</span>
                        <span class="text-sm text-text-muted font-medium pl-2 border-l-2 border-primary/20">{{ flota.nombre }}</span>
                      </div>
                    </td>

                    <td v-for="month in months" :key="month.num" class="p-2 align-middle text-center border-l border-border/50">
                      <!-- Modo Edición -->
                      <template v-if="isEditMode">
                        <input type="number" min="0" 
                          v-model.number="matrix[pesq.id][flota.id][month.num]"
                          @input="markDirty"
                          class="w-full h-10 px-2 text-center text-sm font-semibold bg-surface-muted border border-border rounded-lg focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all outline-none"
                          :class="{'text-primary border-primary/30 bg-primary/5': (matrix[pesq.id]?.[flota.id]?.[month.num] ?? 0) > 0}"
                          placeholder="0" />
                      </template>
                      <!-- Modo Vista -->
                      <template v-else>
                        <div class="h-10 flex items-center justify-center">
                          <span v-if="matrix[pesq.id]?.[flota.id]?.[month.num] && (matrix[pesq.id]?.[flota.id]?.[month.num] ?? 0) > 0" class="inline-flex items-center justify-center min-w-[2rem] h-8 px-2 rounded-lg bg-info/10 text-info font-bold text-sm">
                            {{ matrix[pesq.id]?.[flota.id]?.[month.num] }}
                          </span>
                          <span v-else class="text-text-muted/30 text-xs">-</span>
                        </div>
                      </template>
                    </td>

                    <td class="p-4 text-center font-bold text-info bg-info/5 border-l border-border">
                      {{ getRowTotal(pesq.id, flota.id) }}
                    </td>

                  </tr>
                </template>
              </tbody>
              <!-- Totales Mensuales -->
              <tfoot>
                <tr class="bg-surface-muted/30 border-t-2 border-border font-bold">
                  <td class="p-4 sticky left-0 bg-surface-muted/30 z-10 custom-shadow-right text-sm text-text">
                    TOTAL MENSUAL REQUERIDO
                  </td>
                  <td v-for="month in months" :key="'footer-'+month.num" class="p-3 text-center text-primary text-sm border-l border-border/50">
                    {{ getMonthTotal(month.num) }}
                  </td>
                  <td class="p-4 text-center text-white bg-primary">
                    {{ getGrandTotal() }}
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

        <!-- Mobile View: Accordion / Cards -->
        <div class="block lg:hidden space-y-6">
          
          <!-- Resumen de Totales Mensuales (Mobile) -->
          <div class="bg-surface rounded-2xl border border-border overflow-hidden shadow-sm">
            <div class="p-4 bg-surface-muted/30 border-b border-border">
              <h3 class="font-bold text-text flex items-center gap-2">
                <span class="w-2 h-2 rounded-full bg-primary"></span>
                Totales Mensuales (Global)
              </h3>
            </div>
            <div class="p-4 grid grid-cols-3 gap-3">
              <div v-for="month in months" :key="'mob-total-'+month.num" class="bg-surface-muted/50 rounded-xl p-2 text-center border border-border/50">
                <span class="block text-[10px] uppercase font-bold text-text-muted mb-1">{{ month.shortStr }}</span>
                <span class="text-sm font-bold text-primary">{{ getMonthTotal(month.num) }}</span>
              </div>
              <div class="col-span-3 bg-primary/10 rounded-xl p-3 text-center border border-primary/20 mt-1 flex justify-between items-center px-6">
                <span class="text-sm font-bold text-primary uppercase">Gran Total Requerido</span>
                <span class="text-lg font-black text-primary">{{ getGrandTotal() }}</span>
              </div>
            </div>
          </div>

          <div v-for="pesq in visiblePesquerias" :key="'mob-' + pesq.id" class="bg-surface rounded-2xl border border-border overflow-hidden">
            <!-- Accordion Header -->
            <button @click="togglePesqueria(pesq.id)" class="w-full p-4 flex items-center justify-between bg-surface-muted/30 hover:bg-surface-muted/50 transition-colors">
              <span class="font-bold text-text">{{ pesq.nombre }}</span>
              <div class="flex items-center gap-3">
                <span class="text-xs font-semibold text-info bg-info/10 px-2 py-1 rounded-md">Total: {{ getPesqueriaTotal(pesq.id) }}</span>
                <svg :class="['w-5 h-5 text-text-muted transition-transform', expandedPesquerias[pesq.id] ? 'rotate-180' : '']" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                </svg>
              </div>
            </button>

            <!-- Accordion Body -->
            <div v-show="expandedPesquerias[pesq.id]" class="p-4 border-t border-border divide-y divide-border/50">
               <div v-for="flota in pesq.flotaAsignada" :key="flota.id" class="py-4 first:pt-0 last:pb-0">
                  <h4 class="text-sm font-semibold text-text-muted mb-3 flex justify-between">
                    <span>{{ flota.nombre }}</span>
                    <span class="text-primary font-bold">{{ getRowTotal(pesq.id, flota.id) }} req.</span>
                  </h4>
                  
                  <div class="grid grid-cols-3 sm:grid-cols-4 gap-2">
                    <div v-for="month in months" :key="month.num" class="flex flex-col gap-1">
                      <label class="text-[10px] uppercase font-bold text-text-muted flex justify-between px-1">
                        {{ month.shortStr }}
                      </label>
                      <template v-if="isEditMode">
                         <input type="number" min="0" 
                          v-model.number="matrix[pesq.id][flota.id][month.num]"
                          @input="markDirty"
                          class="w-full text-center text-sm py-1.5 font-semibold bg-surface-muted border border-border rounded-md focus:border-primary" />
                      </template>
                      <template v-else>
                         <div class="bg-surface-muted/50 rounded-md py-1.5 text-center flex items-center justify-center font-bold text-sm min-h-[34px]">
                           <span v-if="matrix[pesq.id]?.[flota.id]?.[month.num] && (matrix[pesq.id]?.[flota.id]?.[month.num] ?? 0) > 0" class="text-info">{{ matrix[pesq.id]?.[flota.id]?.[month.num] }}</span>
                           <span v-else class="text-text-muted/30">-</span>
                         </div>
                      </template>
                    </div>
                  </div>
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
import { useConfigStore } from '@/modules/shared/stores/config.store';
import catalogosService from '@/modules/mareas/services/catalogos.service';
import { planificacionService } from '../services/planificacion.service';
import { toast } from 'vue-sonner';
const configStore = useConfigStore();

// Estados de la UI
const isLoading = ref(true);
const isSaving = ref(false);
const isEditMode = ref(false);
const isDirty = ref(false);
const selectedPesqueriaId = ref('');
const expandedPesquerias = ref<Record<string, boolean>>({});

// Catálogos
const catalogos = ref<{
  pesquerias: any[];
  tiposFlota: any[];
}>({ pesquerias: [], tiposFlota: [] });

// Months Definition
const months = [
  { num: 1, shortStr: 'Ene' }, { num: 2, shortStr: 'Feb' }, { num: 3, shortStr: 'Mar' },
  { num: 4, shortStr: 'Abr' }, { num: 5, shortStr: 'May' }, { num: 6, shortStr: 'Jun' },
  { num: 7, shortStr: 'Jul' }, { num: 8, shortStr: 'Ago' }, { num: 9, shortStr: 'Sep' },
  { num: 10, shortStr: 'Oct' }, { num: 11, shortStr: 'Nov' }, { num: 12, shortStr: 'Dic' },
];

/**
 * Matriz Reactiva de Datos
 * Estructura: matrix[pesqueriaId][tipoFlotaId][mesNum] = numero
 */
const matrix = ref<Record<string, Record<string, Record<number, number | null>>>>({});

// Ordenar pesquerías por nombre y flotas por nombre
const visiblePesquerias = computed(() => {
  let list = sortedPesquerias.value;
  
  // Solo filtramos en modo vista
  if (!isEditMode.value && selectedPesqueriaId.value) {
    list = list.filter(p => p.id === selectedPesqueriaId.value);
  }
  
  return list;
});

const sortedPesquerias = computed(() => {
  return catalogos.value.pesquerias.map((p: any) => ({
    ...p,
    flotaAsignada: [...catalogos.value.tiposFlota].sort((a: any, b: any) => a.nombre.localeCompare(b.nombre))
  })).sort((a: any, b: any) => a.nombre.localeCompare(b.nombre));
});

// Métodos de inicialización
const initMatrix = () => {
  const newMatrix: Record<string, Record<string, Record<number, number | null>>> = {};
  catalogos.value.pesquerias.forEach((p: any) => {
    newMatrix[p.id] = {};
    catalogos.value.tiposFlota.forEach((f: any) => {
      newMatrix[p.id][f.id] = {};
      months.forEach((m: any) => {
        newMatrix[p.id][f.id][m.num] = null;
      });
    });
  });
  matrix.value = newMatrix;
};

const loadData = async () => {
  isLoading.value = true;
  isDirty.value = false;
  try {
    // 1. Cargar Catálogos si no existen
    if (!catalogos.value.pesquerias.length) {
      const [pesquerias, tiposFlota] = await Promise.all([
        catalogosService.getPesquerias(),
        catalogosService.getTiposFlota()
      ]);
      
      catalogos.value.pesquerias = pesquerias;
      catalogos.value.tiposFlota = tiposFlota;
      initMatrix();
    } else {
      initMatrix();
    }

    // 2. Cargar Requerimientos del año actual
    const reqs = await planificacionService.getRequerimientosPorAnio(configStore.selectedYear);
    
    // 3. Poblar la matriz
    reqs.forEach(req => {
      if (matrix.value[req.pesqueriaId] && matrix.value[req.pesqueriaId][req.tipoFlotaId]) {
        matrix.value[req.pesqueriaId][req.tipoFlotaId][req.mes] = req.cantidad;
      }
    });

  } catch (error) {
    console.error("Error al cargar planificacion", error);
    toast.error('Ocurrió un error al cargar la información de cobertura.');
  } finally {
    isLoading.value = false;
  }
};

// Acciones de Usuario
const togglePesqueria = (id: string) => {
  expandedPesquerias.value[id] = !expandedPesquerias.value[id];
};

const markDirty = () => {
  isDirty.value = true;
};

const getRowTotal = (pesqueriaId: string, flotaId: string) => {
  if (!matrix.value[pesqueriaId] || !matrix.value[pesqueriaId][flotaId]) return 0;
  let total = 0;
  months.forEach(m => {
    const val = matrix.value[pesqueriaId]?.[flotaId]?.[m.num];
    if (val && val > 0) total += val;
  });
  return total;
};

const getPesqueriaTotal = (pesqueriaId: string) => {
  const pesq = sortedPesquerias.value.find(p => p.id === pesqueriaId);
  if (!pesq) return 0;
  
  let total = 0;
  pesq.flotaAsignada.forEach((f: any) => {
    total += getRowTotal(pesqueriaId, f.id);
  });
  return total;
};

const getMonthTotal = (monthNum: number) => {
  let total = 0;
  visiblePesquerias.value.forEach(pesq => {
    pesq.flotaAsignada.forEach((flota: any) => {
      const val = matrix.value[pesq.id]?.[flota.id]?.[monthNum];
      if (val && val > 0) total += val;
    });
  });
  return total;
};

const getGrandTotal = () => {
  let total = 0;
  visiblePesquerias.value.forEach(pesq => {
    total += getPesqueriaTotal(pesq.id);
  });
  return total;
};

const saveChanges = async () => {
  if (!isDirty.value) return;
  
  isSaving.value = true;
  try {
    const arrayPlano = [];
    
    // Aplanar matriz
    for (const pId in matrix.value) {
      for (const fId in matrix.value[pId]) {
        for (const mNum in matrix.value[pId][fId]) {
          const m = parseInt(mNum);
          const cantidad = matrix.value[pId][fId][m];
          // Solo enviaremos los > 0
          if (cantidad !== null && cantidad !== undefined && cantidad > 0) {
            arrayPlano.push({
              anioOperativo: configStore.selectedYear,
              pesqueriaId: pId,
              tipoFlotaId: fId,
              mes: m,
              cantidad: cantidad
            });
          }
        }
      }
    }

    const res = await planificacionService.upsertRequerimientosBatch({
      anioOperativo: configStore.selectedYear,
      requerimientos: arrayPlano
    });

    toast.success(`Se actualizaron ${res.count} requerimientos correctamente.`);
    isDirty.value = false;
    isEditMode.value = false;

  } catch (error) {
    console.error(error);
    toast.error('Ocurrió un error al intentar guardar la matriz.');
  } finally {
    isSaving.value = false;
  }
};

// Watchers
watch(() => configStore.selectedYear, () => {
  loadData();
});

onMounted(() => {
  loadData();
});

</script>

<style scoped>
/* Sombra interna sutil para fijar columnas en desktop */
.custom-shadow-right {
  box-shadow: 4px 0 8px -2px rgba(0, 0, 0, 0.05);
}
.dark .custom-shadow-right {
  box-shadow: 4px 0 8px -2px rgba(0, 0, 0, 0.2);
}

/* Remover flechas del input number para una vista de grilla mas limpia */
input[type=number]::-webkit-inner-spin-button, 
input[type=number]::-webkit-outer-spin-button { 
  -webkit-appearance: none; 
  margin: 0; 
}
input[type=number] {
  -moz-appearance: textfield;
}
</style>
