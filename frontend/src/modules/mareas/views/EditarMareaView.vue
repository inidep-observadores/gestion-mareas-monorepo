<template>
  <div class="min-h-screen bg-surface-muted pb-20 font-brand">
    <!-- Header -->
    <header class="bg-surface border-b border-border sticky top-0 z-30">
      <div class="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
        <div class="flex items-center gap-4">
          <button
            @click="handleCancel"
            class="p-2 rounded-lg text-text-muted hover:bg-surface-muted transition-colors"
            title="Volver"
          >
            <ArrowLeftIcon class="w-5 h-5" />
          </button>

          <div>
            <div class="flex items-center gap-3">
              <h1 class="text-lg font-bold text-text">
                Editar Marea {{ marea?.id_marea || '...' }}
              </h1>
              <span
                v-if="marea?.estadoActual"
                class="px-2.5 py-0.5 rounded-full text-xs font-bold bg-info/10 text-info border border-info/20"
              >
                {{ marea.estadoActual.nombre }}
              </span>
            </div>
            <p v-if="marea?.buque" class="text-sm text-text-muted">
              Buque: {{ marea.buque.nombreBuque }} • {{ marea.anioMarea }}
            </p>
          </div>
        </div>

        <div class="flex items-center gap-3">
          <button
            @click="handleCancel"
            class="px-4 py-2 bg-surface text-text border border-border rounded-lg text-sm font-bold hover:bg-surface-muted transition-colors shadow-sm"
          >
            Cancelar
          </button>

          <button
            @click="handleSave"
            :disabled="saving"
            class="flex items-center gap-2 px-4 py-2 bg-primary hover:bg-primary/90 text-primary-fg rounded-lg text-sm font-bold transition-colors disabled:opacity-50 disabled:cursor-not-allowed shadow-sm shadow-primary/20"
          >
            <div v-if="saving" class="w-4 h-4 border-2 border-primary-fg/30 border-t-primary-fg rounded-full animate-spin"></div>
            <span v-else>Guardar Cambios</span>
          </button>
        </div>
      </div>
    </header>

    <div class="max-w-7xl mx-auto px-6 py-8">
      <div v-if="loading" class="flex justify-center py-20">
        <div class="w-8 h-8 border-4 border-primary/20 border-t-primary rounded-full animate-spin"></div>
      </div>

      <div v-else-if="!marea" class="text-center py-20">
        <p class="text-text-muted">No se encontró la marea.</p>
      </div>

      <div v-else class="grid grid-cols-12 gap-8">
        <!-- Sidebar Navigation -->
        <aside class="col-span-12 lg:col-span-3">
          <nav class="sticky top-24 space-y-1">
            <button
              v-for="tab in tabs"
              :key="tab.id"
              @click="currentTab = tab.id"
              class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-left transition-all duration-200 group"
              :class="[
                currentTab === tab.id
                  ? 'bg-surface text-primary shadow-sm ring-1 ring-border font-bold'
                  : 'text-text-muted hover:bg-surface-muted hover:text-text'
              ]"
            >
              <component :is="tab.icon" class="w-5 h-5 flex-shrink-0" :class="currentTab === tab.id ? 'text-primary' : 'text-text-muted/60 group-hover:text-text-muted'" />
              <span>{{ tab.label }}</span>
              <span v-if="tab.badge" class="ml-auto px-2 py-0.5 text-xs rounded-full bg-surface-muted text-text-muted border border-border">
                {{ tab.badge }}
              </span>
            </button>
          </nav>

          <!-- Quick Actions / Status Card -->
          <div class="mt-8 bg-surface rounded-xl p-4 border border-border shadow-sm">
            <h3 class="text-xs font-bold text-text-muted uppercase tracking-wider mb-4">Estado del Sistema</h3>
            <div class="space-y-3">
              <div class="flex justify-between items-center text-sm">
                <span class="text-text-muted">Progreso</span>
                <span class="font-bold text-text">{{ calculateProgress() }}%</span>
              </div>
              <div class="w-full bg-surface-muted rounded-full h-2">
                <div class="bg-primary h-2 rounded-full transition-all duration-500" :style="{ width: `${calculateProgress()}%` }"></div>
              </div>
              <div class="flex justify-between items-center text-sm pt-2">
                 <span class="text-text-muted">Última act.</span>
                 <span class="text-xs text-text-muted/60">Hace instantes</span>
              </div>
            </div>
          </div>
        </aside>

        <!-- Main Content Area -->
        <main class="col-span-12 lg:col-span-9 space-y-6">

          <!-- TAB: GENERAL -->
          <div v-if="currentTab === 'general'" class="space-y-6">
            <!-- Card: Información Principal -->
            <section class="bg-surface rounded-xl border border-border shadow-sm overflow-hidden">
              <div class="px-6 py-4 border-b border-border flex justify-between items-center bg-surface-muted">
                <h2 class="font-bold text-text flex items-center gap-2">
                  <EditIcon class="w-4 h-4 text-primary" />
                  Información Principal
                </h2>
              </div>
              <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-6">
                <!-- Nro Marea -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Nro. Marea</label>
                  <input
                    v-model.number="form.nroMarea"
                    type="number"
                    class="w-full rounded-lg border-border bg-surface-muted text-text py-2.5 px-3 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors outline-hidden"
                  />
                </div>

                <!-- Año -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Año</label>
                  <input
                    v-model.number="form.anioMarea"
                    type="number"
                    class="w-full rounded-lg border-border bg-surface-muted text-text py-2.5 px-3 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors outline-hidden"
                  />
                </div>

                <!-- Fecha Zarpada Estimada -->
                <div class="space-y-1.5">
                  <label class="block text-sm font-medium text-text-muted">Fecha Zarpada (Estimada/Real)</label>
                  <input
                    v-model="form.fechaZarpadaEstimada"
                    type="date"
                    class="w-full rounded-lg border-border bg-surface-muted text-text py-2.5 px-3 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors outline-hidden"
                  />
                </div>

                <!-- Días Estimados -->
                <div class="space-y-1.5">
                   <label class="block text-sm font-medium text-text-muted">Días de Marea (Estimados)</label>
                   <input
                    v-model.number="form.diasEstimados"
                    type="number"
                    class="w-full rounded-lg border-border bg-surface-muted text-text py-2.5 px-3 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors outline-hidden"
                  />
                </div>

                 <!-- Días Zona Austral -->
                 <div class="space-y-1.5">
                   <label class="block text-sm font-medium text-text-muted">Días Zona Austral</label>
                   <input
                    v-model.number="form.diasZonaAustral"
                    type="number"
                    class="w-full rounded-lg border-border bg-surface-muted text-text py-2.5 px-3 focus:ring-2 focus:ring-primary/20 focus:border-primary transition-colors outline-hidden"
                  />
                   <p class="text-xs text-text-muted">Días computados para zona austral.</p>
                </div>
              </div>
            </section>


          </div>

          <!-- TAB: ETAPAS -->
          <div v-if="currentTab === 'etapas'" class="space-y-6">
             <div class="flex items-center justify-between">
                <h2 class="text-lg font-bold text-text">Derrotero de Marea</h2>
                 <button class="px-3 py-1.5 text-sm bg-surface border border-border hover:bg-surface-muted text-text rounded-lg transition-colors font-bold">
                   + Agregar Etapa
                 </button>
             </div>

             <div class="space-y-4">
               <div
                 v-for="(etapa, index) in marea.etapas"
                 :key="etapa.id"
                 class="group relative bg-white dark:bg-gray-950 rounded-xl border border-gray-200 dark:border-gray-800 shadow-sm p-6 transition-all hover:shadow-md hover:border-brand-200 dark:hover:border-brand-900"
               >
                 <!-- Connector Line overlay -->
                  <div v-if="Number(index) < etapasLength - 1" class="absolute left-9 top-16 bottom-0 w-0.5 bg-gray-200 dark:bg-gray-800 -z-10 group-hover:bg-brand-100 dark:group-hover:bg-brand-900/30 transition-colors"></div>

                 <div class="flex gap-4">
                    <div class="flex-shrink-0 w-8 h-8 rounded-full bg-brand-50 dark:bg-brand-900/30 flex items-center justify-center text-brand-600 dark:text-brand-400 font-bold text-sm border border-brand-100 dark:border-brand-800">
                      {{ etapa.nroEtapa }}
                    </div>

                    <div class="grow grid grid-cols-1 md:grid-cols-2 gap-4">
                       <div>
                         <h3 class="text-sm font-bold text-text uppercase tracking-tight text-[11px]">Etapa {{ etapa.nroEtapa }}</h3>
                         <div class="mt-2 space-y-2">
                           <div>
                             <p class="text-[9px] text-text-muted uppercase tracking-widest font-black">Puerto Zarpada</p>
                             <p class="text-sm font-bold text-text">{{ etapa.puertoZarpada?.nombre || 'Desconocido' }}</p>
                           </div>
                           <div v-if="etapa.fechaZarpada">
                             <p class="text-[9px] text-text-muted uppercase tracking-widest font-black">Fecha Zarpada</p>
                             <p class="text-sm text-text-muted">{{ formatDate(etapa.fechaZarpada) }}</p>
                           </div>
                         </div>
                       </div>

                        <div>
                         <h3 class="text-sm font-semibold text-transparent select-none">&nbsp;</h3>
                         <div class="mt-2 space-y-2">
                           <div>
                             <p class="text-[9px] text-text-muted uppercase tracking-widest font-black">Puerto Arribo</p>
                             <p v-if="etapa.fechaArribo" class="text-sm font-bold text-text">{{ etapa.puertoArribo?.nombre || 'En navegación' }}</p>
                             <span v-else class="text-[10px] font-black px-2 py-0.5 rounded bg-success/10 text-success uppercase tracking-widest">En curso...</span>
                           </div>
                            <div v-if="etapa.fechaArribo">
                             <p class="text-[9px] text-text-muted uppercase tracking-widest font-black">Fecha Arribo</p>
                             <p class="text-sm text-text-muted">{{ formatDate(etapa.fechaArribo) }}</p>
                           </div>
                         </div>
                       </div>
                    </div>

                    <div class="flex-shrink-0 flex flex-col items-end justify-between">
                       <button class="text-text-muted/40 hover:text-primary transition-colors p-1" title="Editar Etapa (Próximamente)">
                          <EditIcon class="w-4 h-4" />
                       </button>
                       <!-- Pesqueria Label -->
                       <span v-if="etapa.pesqueria" class="text-[10px] px-2 py-0.5 rounded-full bg-surface-muted text-text-muted border border-border font-bold uppercase tracking-tight">
                          {{ etapa.pesqueria.nombre }}
                       </span>
                    </div>
                 </div>
               </div>
             </div>
          </div>

           <!-- TAB: OBSERVADORES -->
          <div v-if="currentTab === 'observadores'" class="space-y-6">
            <h2 class="text-lg font-bold text-text">Tripulación Científica</h2>

             <!-- Placeholder for now -->
             <div class="bg-surface rounded-xl border border-border p-8 text-center">
                <UserGroupIcon class="w-12 h-12 text-text-muted/20 mx-auto mb-3" />
                <h3 class="text-text font-bold uppercase tracking-tight">Gestión de Observadores</h3>
                <p class="text-xs text-text-muted mt-1 max-w-sm mx-auto">La asignación avanzada de observadores por etapa estará disponible próximamente. Puedes ver los asignados en la vista de detalle.</p>
             </div>
          </div>

        </main>
      </div>
    </div>


    <!-- Cancel Confirmation Modal -->
    <ConfirmationDialog
      :show="showCancelConfirm"
      title="¿Descartar Cambios?"
      message="Si cancela ahora, perderá los cambios no guardados en esta marea. ¿Está seguro de que desea salir?"
      confirm-text="Si, Salir"
      @close="showCancelConfirm = false"
      @confirm="confirmCancel"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { toast } from 'vue-sonner';
import mareasService from '../services/mareas.service';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import ArrowLeftIcon from '@/icons/ArrowLeftIcon.vue';
import EditIcon from '@/icons/EditIcon.vue';
import SettingsIcon from '@/icons/SettingsIcon.vue';
import MapPinIcon from '@/icons/MapPinIcon.vue';
import UserGroupIcon from '@/icons/UserGroupIcon.vue';

const route = useRoute();
const router = useRouter();

const marea = ref<any>(null);
const loading = ref(true);
const saving = ref(false);

const tabs = computed(() => [
  { id: 'general', label: 'General', icon: EditIcon },
  { id: 'etapas', label: 'Derrotero', icon: MapPinIcon, badge: marea.value?.etapas?.length || 0 },
  { id: 'observadores', label: 'Observadores', icon: UserGroupIcon }
]);

const etapasLength = computed<number>(() => Number(marea.value?.etapas?.length ?? 0));

const currentTab = ref('general');

const form = ref({
  nroMarea: null,
  anioMarea: null,
  diasEstimados: null,
  diasZonaAustral: null,
  fechaZarpadaEstimada: ''
});

const initialForm = ref<any>(null);
const showCancelConfirm = ref(false);

function hasChanges() {
    return JSON.stringify(form.value) !== JSON.stringify(initialForm.value);
}

function handleCancel() {
    if (initialForm.value && hasChanges()) {
        showCancelConfirm.value = true;
    } else {
        router.back();
    }
}

function confirmCancel() {
    showCancelConfirm.value = false;
    router.back();
}

onMounted(async () => {
    try {
        const id = route.params.id as string;
        const data = await mareasService.getById(id);
        marea.value = data;

        // Helper to get local YYYY-MM-DD
        const toLocalISO = (isoStr: string) => {
            if (!isoStr) return '';
            const d = new Date(isoStr);
            if (isNaN(d.getTime())) return '';
            const year = d.getFullYear();
            const month = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };

        // Init form
        form.value = {
            nroMarea: data.nroMarea,
            anioMarea: data.anioMarea,
            diasEstimados: data.diasEstimados,
            diasZonaAustral: data.diasZonaAustral,
            fechaZarpadaEstimada: toLocalISO(data.fechaZarpadaEstimada)
        };
        initialForm.value = JSON.parse(JSON.stringify(form.value));
    } catch (e) {
        console.error("Error cargando marea", e);
        toast.error("Error al cargar la marea");
    } finally {
        loading.value = false;
    }
});

async function handleSave() {
    try {
        saving.value = true;

        // Prepare payload
        const payload = {
            ...form.value,
            // Convertir fechas vacías a null si fuera necesario, o dejar string ISO
            fechaZarpadaEstimada: form.value.fechaZarpadaEstimada ? new Date(form.value.fechaZarpadaEstimada).toISOString() : null
        };

        await mareasService.update(marea.value.id, payload);
        // Reload to refresh data
        const fresh = await mareasService.getById(marea.value.id);
        marea.value = fresh;

        toast.success("Marea actualizada correctamente");

        setTimeout(() => {
            router.back();
        }, 800);

    } catch (e: any) {
        console.error("Error guardando marea", e);
        const msg = e.response?.data?.message || e.message || "Error al guardar cambios";
        toast.error(Array.isArray(msg) ? msg.join(', ') : msg);
    } finally {
        saving.value = false;
    }
}

function calculateProgress() {
    if (!marea.value) return 0;
    // Basic calculation logic mirrored from backend or just show persisted if available?
    // Frontend logic for visual feedback: (days elapsed / estimated)
    const start = marea.value.fechaZarpadaEstimada ? new Date(marea.value.fechaZarpadaEstimada) : null;
    if (!start) return 0;

    // Only if en Ejecucion
    if (marea.value.estadoActual?.codigo === 'EN_EJECUCION' || marea.value.estadoActual?.codigo === 'NAVEGANDO') {
        const now = new Date();
        const diff = Math.max(0, now.getTime() - start.getTime());
        const days = diff / (1000 * 60 * 60 * 24);
        const est = marea.value.diasEstimados || 1;
        return Math.min(100, Math.round((days / est) * 100));
    }
    return 0; // Default or handled by state
}

function formatDate(iso: string) {
    if (!iso) return '-';
    return new Date(iso).toLocaleDateString('es-AR');
}
</script>
