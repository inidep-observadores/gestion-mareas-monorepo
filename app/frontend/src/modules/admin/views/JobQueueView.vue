<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import {
    Activity,
    CheckCircle2,
    XCircle,
    Clock,
    AlertCircle,
    RefreshCw,
    Search,
    Filter,
    BarChart3
} from 'lucide-vue-next';
import { jobQueueService } from '../services/JobQueueService';
import type { JobQueue, JobQueueStats } from '../interfaces/job-queue.interface';

// Components
import AdminDashboardLayout from '../layouts/AdminDashboardLayout.vue';
import JobQueueActivityChart from '../components/JobQueueActivityChart.vue';
import JobQueuePerformanceChart from '../components/JobQueuePerformanceChart.vue';
import JobQueueTable from '../components/JobQueueTable.vue';
import JobDetailDialog from '../components/JobDetailDialog.vue';

const stats = ref<JobQueueStats | null>(null);
const loading = ref(true);
const refreshing = ref(false);
const triggeringPna = ref(false);
const triggeringVessel = ref(false);

const selectedJob = ref<JobQueue | null>(null);
const detailVisible = ref(false);

const openDetail = (job: JobQueue) => {
    selectedJob.value = job;
    detailVisible.value = true;
};

const triggerPnaSync = async () => {
    triggeringPna.value = true;
    try {
        await jobQueueService.triggerJob('PNA_API_SYNC');
        await refreshData();
    } catch (error) {
        console.error('Error triggering PNA sync:', error);
    } finally {
        triggeringPna.value = false;
    }
};

const triggerVesselSync = async () => {
    triggeringVessel.value = true;
    try {
        await jobQueueService.triggerJob('VESSEL_SYNC');
        await refreshData();
    } catch (error) {
        console.error('Error triggering Vessel sync:', error);
    } finally {
        triggeringVessel.value = false;
    }
};

const loadStats = async () => {
    try {
        stats.value = await jobQueueService.getSummaryStats();
    } catch (error) {
        console.error('Error loading job stats:', error);
    }
};

const refreshData = async () => {
    refreshing.value = true;
    await loadStats();
    // Emitir evento a componentes hijos si es necesario
    refreshing.value = false;
};

onMounted(() => {
    loadStats();
    loading.value = false;
});

const cards = computed(() => [
    { title: 'Total Tareas', value: stats.value?.total || 0, icon: Activity, color: 'text-slate-600', bg: 'bg-slate-100' },
    { title: 'Completadas', value: stats.value?.completed || 0, icon: CheckCircle2, color: 'text-emerald-600', bg: 'bg-emerald-100' },
    { title: 'Fallidas', value: stats.value?.failed || 0, icon: XCircle, color: 'text-rose-600', bg: 'bg-rose-100' },
    { title: 'Pendientes', value: stats.value?.pending || 0, icon: Clock, color: 'text-amber-600', bg: 'bg-amber-100' },
    { title: 'Tasa Éxito', value: `${stats.value?.successRate || 0}%`, icon: BarChart3, color: 'text-sky-600', bg: 'bg-sky-100' },
]);
</script>

<template>
    <AdminDashboardLayout title="Cola de Tareas"
        description="Monitoreo y gestión de la cola de procesamiento en segundo plano.">
        <div class="space-y-6">
            <!-- Header (Simplificado ya que el layout ya tiene título) -->
            <div class="flex justify-end items-center gap-3">
                <button @click="triggerPnaSync"
                    class="flex items-center gap-2 px-4 py-2 bg-primary/10 border border-primary/20 text-primary rounded-lg hover:bg-primary/20 transition-colors shadow-sm font-medium"
                    :disabled="triggeringPna">
                    <Activity class="w-4 h-4" :class="{ 'animate-pulse': triggeringPna }" />
                    Sincronizar PNA
                </button>

                <button @click="triggerVesselSync"
                    class="flex items-center gap-2 px-4 py-2 bg-secondary/10 border border-secondary/20 text-secondary rounded-lg hover:bg-secondary/20 transition-colors shadow-sm font-medium"
                    :disabled="triggeringVessel">
                    <RefreshCw class="w-4 h-4" :class="{ 'animate-spin': triggeringVessel }" />
                    Sincronizar Buques
                </button>

                <div class="h-6 w-px bg-border mx-2"></div>

                <button @click="refreshData"
                    class="flex items-center gap-2 px-4 py-2 bg-surface border border-border rounded-lg hover:bg-surface-muted transition-colors shadow-sm text-text font-medium"
                    :disabled="refreshing">
                    <RefreshCw class="w-4 h-4" :class="{ 'animate-spin': refreshing }" />
                    Actualizar
                </button>
            </div>

            <!-- KPIs -->
            <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4">
                <div v-for="card in cards" :key="card.title"
                    class="bg-surface p-4 rounded-xl border border-border shadow-sm flex items-center gap-4">
                    <div :class="[card.bg, card.color, 'p-3 rounded-lg']">
                        <component :is="card.icon" class="w-6 h-6" />
                    </div>
                    <div>
                        <p class="text-xs font-medium text-text-muted uppercase tracking-wider">{{ card.title }}</p>
                        <p class="text-xl font-bold text-text">{{ card.value }}</p>
                    </div>
                </div>
            </div>

            <!-- Charts Row -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <!-- Evolución Temporal -->
                <div class="bg-surface p-6 rounded-xl border border-border shadow-sm h-[400px]">
                    <h3 class="text-lg font-semibold text-text mb-4 flex items-center gap-2">
                        <Activity class="w-5 h-5 text-primary" />
                        Evolución de Tareas (7 días)
                    </h3>
                    <JobQueueActivityChart :refresh-trigger="refreshing ? 1 : 0" />
                </div>

                <!-- Rendimiento por Tipo -->
                <div class="bg-surface p-6 rounded-xl border border-border shadow-sm h-[400px]">
                    <h3 class="text-lg font-semibold text-text mb-4 flex items-center gap-2">
                        <Clock class="w-5 h-5 text-secondary" />
                        Rendimiento por Tipo (ms)
                    </h3>
                    <JobQueuePerformanceChart :refresh-trigger="refreshing ? 1 : 0" />
                </div>
            </div>

            <!-- Table Row -->
            <div class="bg-surface rounded-xl border border-border shadow-sm overflow-hidden">
                <JobQueueTable :refresh-trigger="refreshing ? 1 : 0" @open-detail="openDetail" />
            </div>

            <!-- Detail Dialog -->
            <JobDetailDialog v-model:visible="detailVisible" :job="selectedJob" />
        </div>
    </AdminDashboardLayout>
</template>
