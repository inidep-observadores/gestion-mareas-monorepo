<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import {
    RefreshCw,
    Play,
    X,
    ChevronLeft,
    ChevronRight,
    ChevronDown,
    Eye,
    AlertCircle,
    CheckCircle2,
    Clock,
    Activity,
    XCircle
} from 'lucide-vue-next';
import { jobQueueService } from '../services/JobQueueService';
import type { JobQueue } from '../interfaces/job-queue.interface';
import ConfirmationDialog from '@/components/common/ConfirmationDialog.vue';
import { toast } from 'vue-sonner';

const props = defineProps<{
    refreshTrigger?: number;
}>();

const emit = defineEmits(['open-detail']);

const jobs = ref<JobQueue[]>([]);
const loading = ref(true);
const page = ref(1);
const totalPages = ref(1);
const limit = ref(20);
const statusFilter = ref('');
const typeFilter = ref('');
const searchSearch = ref('');

// Ordenamiento
const sortBy = ref<string>('createdAt');
const sortOrder = ref<'asc' | 'desc'>('desc');

// Modales de confirmación
const showRetryModal = ref(false);
const showCancelModal = ref(false);
const selectedJobId = ref<string | null>(null);

const loadJobs = async () => {
    loading.value = true;
    try {
        const response = await jobQueueService.getJobs({
            page: page.value,
            limit: limit.value,
            status: statusFilter.value || undefined,
            type: typeFilter.value || undefined,
            search: searchSearch.value || undefined
        });
        jobs.value = sortJobs(response.data);
        totalPages.value = response.meta.totalPages;
    } catch (error) {
        console.error('Error loading jobs:', error);
    } finally {
        loading.value = false;
    }
};

const toggleSort = (field: string) => {
    if (sortBy.value === field) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    } else {
        sortBy.value = field;
        sortOrder.value = 'asc';
    }
    jobs.value = sortJobs(jobs.value);
};

const sortJobs = (jobsList: JobQueue[]) => {
    return [...jobsList].sort((a, b) => {
        let aVal: any;
        let bVal: any;

        switch (sortBy.value) {
            case 'type':
                aVal = a.type;
                bVal = b.type;
                break;
            case 'status':
                aVal = a.status;
                bVal = b.status;
                break;
            case 'attempts':
                aVal = a.attempts;
                bVal = b.attempts;
                break;
            case 'lastRunAt':
                aVal = a.lastRunAt ? new Date(a.lastRunAt).getTime() : 0;
                bVal = b.lastRunAt ? new Date(b.lastRunAt).getTime() : 0;
                break;
            case 'duration':
                aVal = a.duration || 0;
                bVal = b.duration || 0;
                break;
            case 'createdAt':
            default:
                aVal = new Date(a.createdAt).getTime();
                bVal = new Date(b.createdAt).getTime();
                break;
        }

        if (aVal < bVal) return sortOrder.value === 'asc' ? -1 : 1;
        if (aVal > bVal) return sortOrder.value === 'asc' ? 1 : -1;
        return 0;
    });
};

const getStatusConfig = (status: string) => {
    switch (status) {
        case 'COMPLETED': return { label: 'Completada', color: 'bg-emerald-100 text-emerald-700', icon: CheckCircle2 };
        case 'FAILED': return { label: 'Fallida', color: 'bg-rose-100 text-rose-700', icon: XCircle };
        case 'PENDING': return { label: 'Pendiente', color: 'bg-amber-100 text-amber-700', icon: Clock };
        case 'PROCESSING': return { label: 'Procesando', color: 'bg-sky-100 text-sky-700', icon: Activity };
        case 'CANCELLED': return { label: 'Cancelada', color: 'bg-slate-100 text-slate-700', icon: X };
        default: return { label: status, color: 'bg-slate-100 text-slate-700', icon: AlertCircle };
    }
};

const formatDate = (dateStr: string | null) => {
    if (!dateStr) return '-';
    return new Date(dateStr).toLocaleString('es-AR', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
    });
};

const confirmRetry = (id: string) => {
    selectedJobId.value = id;
    showRetryModal.value = true;
};

const retryJob = async () => {
    if (!selectedJobId.value) return;
    showRetryModal.value = false;
    try {
        await jobQueueService.retryJob(selectedJobId.value);
        toast.success('Tarea reintentada correctamente');
        await loadJobs();
    } catch (error) {
        toast.error('Error al reintentar la tarea');
    } finally {
        selectedJobId.value = null;
    }
};

const confirmCancel = (id: string) => {
    selectedJobId.value = id;
    showCancelModal.value = true;
};

const cancelJob = async () => {
    if (!selectedJobId.value) return;
    showCancelModal.value = false;
    try {
        await jobQueueService.cancelJob(selectedJobId.value);
        toast.success('Tarea cancelada correctamente');
        await loadJobs();
    } catch (error) {
        toast.error('Error al cancelar la tarea');
    } finally {
        selectedJobId.value = null;
    }
};

onMounted(loadJobs);
watch(() => page.value, loadJobs);
watch([statusFilter, typeFilter], () => {
    page.value = 1;
    loadJobs();
});
watch(() => props.refreshTrigger, loadJobs);
</script>

<template>
    <div class="w-full">
        <!-- Table Filters -->
        <div class="p-4 border-b border-border flex flex-wrap gap-4 items-center justify-between bg-surface-muted/30">
            <div class="flex gap-4">
                <select v-model="statusFilter"
                    class="bg-surface border border-border rounded-lg px-3 py-1.5 text-sm text-text focus:outline-none focus:ring-2 focus:ring-primary/20">
                    <option value="">Todos los Estados</option>
                    <option value="PENDING">Pendiente</option>
                    <option value="PROCESSING">Procesando</option>
                    <option value="COMPLETED">Completada</option>
                    <option value="FAILED">Fallida</option>
                    <option value="CANCELLED">Cancelada</option>
                </select>

                <select v-model="typeFilter"
                    class="bg-surface border border-border rounded-lg px-3 py-1.5 text-sm text-text focus:outline-none focus:ring-2 focus:ring-primary/20">
                    <option value="">Todos los Tipos</option>
                    <option value="VESSEL_SYNC">Sincro Buques</option>
                    <option value="PNA_API_SYNC">Sincro PNA (Alertas)</option>
                    <option value="PNA_TRACKING_SYNC">Sincro Tracking</option>
                    <option value="NOVEDADES_EMAIL_SYNC">Sincro Novedades Email</option>
                </select>
            </div>

            <div class="flex items-center gap-2 text-sm text-text-muted">
                Página {{ page }} de {{ totalPages }}
                <div class="flex gap-1 ml-2">
                    <button @click="page > 1 && page--" :disabled="page === 1"
                        class="p-1 hover:bg-surface-muted rounded disabled:opacity-30 transition-colors">
                        <ChevronLeft class="w-5 h-5" />
                    </button>
                    <button @click="page < totalPages && page++" :disabled="page === totalPages"
                        class="p-1 hover:bg-surface-muted rounded disabled:opacity-30 transition-colors">
                        <ChevronRight class="w-5 h-5" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Scrollable Table Body -->
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-surface-muted text-text-muted text-xs uppercase tracking-wider font-semibold">
                        <th @click="toggleSort('type')"
                            class="px-6 py-3 border-b border-border cursor-pointer hover:text-primary transition-colors">
                            <div class="flex items-center gap-1">
                                ID / Tipo
                                <ChevronDown v-if="sortBy === 'type'"
                                    class="w-3.5 h-3.5 text-primary transition-transform duration-300"
                                    :class="{ 'rotate-180': sortOrder === 'asc' }" />
                            </div>
                        </th>
                        <th @click="toggleSort('status')"
                            class="px-6 py-3 border-b border-border text-center cursor-pointer hover:text-primary transition-colors">
                            <div class="flex items-center justify-center gap-1">
                                Estado
                                <ChevronDown v-if="sortBy === 'status'"
                                    class="w-3.5 h-3.5 text-primary transition-transform duration-300"
                                    :class="{ 'rotate-180': sortOrder === 'asc' }" />
                            </div>
                        </th>
                        <th @click="toggleSort('attempts')"
                            class="px-6 py-3 border-b border-border cursor-pointer hover:text-primary transition-colors">
                            <div class="flex items-center gap-1">
                                Intentos
                                <ChevronDown v-if="sortBy === 'attempts'"
                                    class="w-3.5 h-3.5 text-primary transition-transform duration-300"
                                    :class="{ 'rotate-180': sortOrder === 'asc' }" />
                            </div>
                        </th>
                        <th @click="toggleSort('lastRunAt')"
                            class="px-6 py-3 border-b border-border cursor-pointer hover:text-primary transition-colors">
                            <div class="flex items-center gap-1">
                                Última Ejecución
                                <ChevronDown v-if="sortBy === 'lastRunAt'"
                                    class="w-3.5 h-3.5 text-primary transition-transform duration-300"
                                    :class="{ 'rotate-180': sortOrder === 'asc' }" />
                            </div>
                        </th>
                        <th @click="toggleSort('duration')"
                            class="px-6 py-3 border-b border-border cursor-pointer hover:text-primary transition-colors">
                            <div class="flex items-center gap-1">
                                Duración
                                <ChevronDown v-if="sortBy === 'duration'"
                                    class="w-3.5 h-3.5 text-primary transition-transform duration-300"
                                    :class="{ 'rotate-180': sortOrder === 'asc' }" />
                            </div>
                        </th>
                        <th class="px-6 py-3 border-b border-border text-right">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-border">
                    <tr v-if="loading" v-for="i in 5" :key="i" class="animate-pulse">
                        <td colspan="6" class="px-6 py-4 bg-surface-muted/10"></td>
                    </tr>
                    <tr v-else-if="jobs.length === 0">
                        <td colspan="6" class="px-6 py-12 text-center text-text-muted">
                            No se encontraron tareas con los filtros seleccionados.
                        </td>
                    </tr>
                    <tr v-for="job in jobs" :key="job.id" class="hover:bg-surface-muted/80 transition-colors group">
                        <td class="px-6 py-4">
                            <div class="flex flex-col">
                                <span class="text-xs font-mono text-text-muted">{{ job.id }}</span>
                                <span class="font-medium text-text">{{ job.type }}</span>
                            </div>
                        </td>
                        <td class="px-6 py-4 text-center">
                            <div
                                :class="[getStatusConfig(job.status).color, 'inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold']">
                                <component :is="getStatusConfig(job.status).icon" class="w-3.5 h-3.5" />
                                {{ getStatusConfig(job.status).label }}
                            </div>
                        </td>
                        <td class="px-6 py-4 text-center">
                            <span class="text-sm font-semibold"
                                :class="job.attempts > 1 ? 'text-warning' : 'text-text-muted'">
                                {{ job.attempts }} / {{ job.maxAttempts }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-text-muted">
                            {{ formatDate(job.lastRunAt || job.updatedAt) }}
                        </td>
                        <td class="px-6 py-4">
                            <span v-if="job.duration" class="text-sm font-medium text-text-muted">
                                {{ job.duration }}ms
                            </span>
                            <span v-else class="text-text-muted/30">-</span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                <button @click="emit('open-detail', job)"
                                    class="p-1.5 hover:bg-surface-muted rounded text-text-muted hover:text-primary transition-colors"
                                    title="Ver Detalles">
                                    <Eye class="w-4 h-4" />
                                </button>
                                <button v-if="job.status === 'FAILED' || job.status === 'CANCELLED'"
                                    @click="confirmRetry(job.id)"
                                    class="p-1.5 hover:bg-success/10 rounded text-text-muted hover:text-success transition-colors"
                                    title="Reintentar">
                                    <Play class="w-4 h-4" />
                                </button>
                                <button v-if="job.status === 'PENDING' || job.status === 'PROCESSING'"
                                    @click="confirmCancel(job.id)"
                                    class="p-1.5 hover:bg-error/10 rounded text-text-muted hover:text-error transition-colors"
                                    title="Cancelar">
                                    <X class="w-4 h-4" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Modal de Confirmación de Reintentar -->
    <ConfirmationDialog
        :show="showRetryModal"
        title="Reintentar Tarea"
        message="¿Está seguro que desea reintentar esta tarea?"
        confirm-text="Reintentar"
        confirm-button-class="bg-emerald-600 hover:bg-emerald-700 shadow-emerald-600/20"
        @close="showRetryModal = false"
        @confirm="retryJob"
    />

    <!-- Modal de Confirmación de Cancelar -->
    <ConfirmationDialog
        :show="showCancelModal"
        title="Cancelar Tarea"
        message="¿Está seguro que desea cancelar esta tarea?"
        confirm-text="Cancelar Tarea"
        confirm-button-class="bg-error hover:bg-error-hover shadow-error/20"
        @close="showCancelModal = false"
        @confirm="cancelJob"
    />
</template>
