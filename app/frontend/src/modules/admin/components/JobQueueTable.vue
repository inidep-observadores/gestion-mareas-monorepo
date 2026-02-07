<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import {
    RefreshCw,
    Play,
    X,
    ChevronLeft,
    ChevronRight,
    Eye,
    AlertCircle,
    CheckCircle2,
    Clock,
    Activity
} from 'lucide-vue-next';
import { jobQueueService } from '../services/JobQueueService';
import type { JobQueue } from '../interfaces/job-queue.interface';

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
        jobs.value = response.data;
        totalPages.value = response.meta.totalPages;
    } catch (error) {
        console.error('Error loading jobs:', error);
    } finally {
        loading.value = false;
    }
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

const retryJob = async (id: string) => {
    if (!confirm('¿Seguro que desea reintentar esta tarea?')) return;
    try {
        await jobQueueService.retryJob(id);
        await loadJobs();
    } catch (error) {
        alert('Error al reintentar la tarea');
    }
};

const cancelJob = async (id: string) => {
    if (!confirm('¿Seguro que desea cancelar esta tarea?')) return;
    try {
        await jobQueueService.cancelJob(id);
        await loadJobs();
    } catch (error) {
        alert('Error al cancelar la tarea');
    }
};

onMounted(loadJobs);
watch(() => page.value, loadJobs);
watch([statusFilter, typeFilter], () => {
    page.value = 1;
    loadJobs();
});
watch(() => props.refreshTrigger, loadJobs);

import { XCircle } from 'lucide-vue-next';
</script>

<template>
    <div class="w-full">
        <!-- Table Filters -->
        <div class="p-4 border-b border-slate-100 flex flex-wrap gap-4 items-center justify-between bg-slate-50/30">
            <div class="flex gap-4">
                <select v-model="statusFilter"
                    class="bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/20">
                    <option value="">Todos los Estados</option>
                    <option value="PENDING">Pendiente</option>
                    <option value="PROCESSING">Procesando</option>
                    <option value="COMPLETED">Completada</option>
                    <option value="FAILED">Fallida</option>
                    <option value="CANCELLED">Cancelada</option>
                </select>

                <select v-model="typeFilter"
                    class="bg-white border border-slate-200 rounded-lg px-3 py-1.5 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-500/20">
                    <option value="">Todos los Tipos</option>
                    <option value="VESSEL_SYNC">Sincro Buques</option>
                    <option value="TRAJECTORY_SYNC">Sincro Trayectorias</option>
                </select>
            </div>

            <div class="flex items-center gap-2 text-sm text-slate-500">
                Página {{ page }} de {{ totalPages }}
                <div class="flex gap-1 ml-2">
                    <button @click="page > 1 && page--" :disabled="page === 1"
                        class="p-1 hover:bg-slate-200 rounded disabled:opacity-30 transition-colors">
                        <ChevronLeft class="w-5 h-5" />
                    </button>
                    <button @click="page < totalPages && page++" :disabled="page === totalPages"
                        class="p-1 hover:bg-slate-200 rounded disabled:opacity-30 transition-colors">
                        <ChevronRight class="w-5 h-5" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Scrollable Table Body -->
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
                <thead>
                    <tr class="bg-slate-50 text-slate-500 text-xs uppercase tracking-wider font-semibold">
                        <th class="px-6 py-3 border-b border-slate-200">ID / Tipo</th>
                        <th class="px-6 py-3 border-b border-slate-200 text-center">Estado</th>
                        <th class="px-6 py-3 border-b border-slate-200">Intentos</th>
                        <th class="px-6 py-3 border-b border-slate-200">Última Ejecución</th>
                        <th class="px-6 py-3 border-b border-slate-200">Duración</th>
                        <th class="px-6 py-3 border-b border-slate-200 text-right">Acciones</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    <tr v-if="loading" v-for="i in 5" :key="i" class="animate-pulse">
                        <td colspan="6" class="px-6 py-4 bg-slate-50/10"></td>
                    </tr>
                    <tr v-else-if="jobs.length === 0">
                        <td colspan="6" class="px-6 py-12 text-center text-slate-400">
                            No se encontraron tareas con los filtros seleccionados.
                        </td>
                    </tr>
                    <tr v-for="job in jobs" :key="job.id" class="hover:bg-slate-50/80 transition-colors group">
                        <td class="px-6 py-4">
                            <div class="flex flex-col">
                                <span class="text-xs font-mono text-slate-400">{{ job.id }}</span>
                                <span class="font-medium text-slate-700">{{ job.type }}</span>
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
                                :class="job.attempts > 1 ? 'text-amber-600' : 'text-slate-600'">
                                {{ job.attempts }} / {{ job.maxAttempts }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-500">
                            {{ formatDate(job.lastRunAt || job.updatedAt) }}
                        </td>
                        <td class="px-6 py-4">
                            <span v-if="job.duration" class="text-sm font-medium text-slate-600">
                                {{ job.duration }}ms
                            </span>
                            <span v-else class="text-slate-300">-</span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                <button @click="emit('open-detail', job)"
                                    class="p-1.5 hover:bg-slate-100 rounded text-slate-500 hover:text-indigo-600 transition-colors"
                                    title="Ver Detalles">
                                    <Eye class="w-4 h-4" />
                                </button>
                                <button v-if="job.status === 'FAILED' || job.status === 'CANCELLED'"
                                    @click="retryJob(job.id)"
                                    class="p-1.5 hover:bg-emerald-50 rounded text-slate-500 hover:text-emerald-600 transition-colors"
                                    title="Reintentar">
                                    <Play class="w-4 h-4" />
                                </button>
                                <button v-if="job.status === 'PENDING' || job.status === 'PROCESSING'"
                                    @click="cancelJob(job.id)"
                                    class="p-1.5 hover:bg-rose-50 rounded text-slate-500 hover:text-rose-600 transition-colors"
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
</template>
