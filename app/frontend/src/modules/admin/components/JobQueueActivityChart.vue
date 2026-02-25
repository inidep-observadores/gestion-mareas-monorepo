<script setup lang="ts">
import { ref, onMounted, watch, computed } from 'vue';
import VueApexCharts from 'vue3-apexcharts';
import type { ApexOptions } from 'apexcharts';
import { jobQueueService } from '../services/JobQueueService';
import type { JobTimeseriesData } from '../interfaces/job-queue.interface';

const props = defineProps<{
    refreshTrigger?: number;
}>();

const typeFilter = ref<string>('');

const chartOptions = ref<ApexOptions>({
    chart: {
        id: 'job-activity-chart',
        type: 'area' as const,
        toolbar: { show: false },
        fontFamily: 'Inter, sans-serif',
        height: '100%',
        offsetY: -10,
        parentHeightOffset: 0,
    },
    colors: ['#10b981', '#f43f5e'], // Emerald-500, Rose-500
    stroke: {
        curve: 'smooth',
        width: 2,
    },
    fill: {
        type: 'gradient',
        gradient: {
            shadeIntensity: 1,
            opacityFrom: 0.45,
            opacityTo: 0.05,
            stops: [20, 100, 100, 100]
        }
    },
    xaxis: {
        type: 'datetime',
        labels: {
            style: { colors: '#64748b' },
            offsetY: -5,
            rotate: 0,
        },
        axisBorder: { show: false },
        axisTicks: { show: false },
    },
    yaxis: {
        labels: {
            style: { colors: '#64748b' }
        }
    },
    grid: {
        borderColor: '#f1f5f9',
        strokeDashArray: 4,
    },
    dataLabels: { enabled: false },
    tooltip: {
        x: { format: 'dd MMM HH:mm' },
        theme: 'light',
    },
    legend: {
        position: 'top',
        horizontalAlign: 'right',
        labels: { colors: '#64748b' }
    }
});

const rawData = ref<JobTimeseriesData[]>([]);

const series = ref([
    { name: 'Completadas', data: [] as any[] },
    { name: 'Fallidas', data: [] as any[] }
]);

const loading = ref(true);

const loadData = async () => {
    loading.value = true;
    try {
        rawData.value = await jobQueueService.getTimeseriesStats(7);
        updateChartData();
    } catch (error) {
        console.error('Error loading timeseries stats:', error);
    } finally {
        loading.value = false;
    }
};

const updateChartData = () => {
    // Agrupar datos por timestamp, sumando completed y failed de todos los tipos
    const groupedData = new Map<number, { completed: number; failed: number }>();
    
    const filteredData = typeFilter.value 
        ? rawData.value.filter(d => d.type === typeFilter.value)
        : rawData.value;
    
    filteredData.forEach(d => {
        const timestamp = new Date(d.timestamp).getTime();
        const existing = groupedData.get(timestamp) || { completed: 0, failed: 0 };
        groupedData.set(timestamp, {
            completed: existing.completed + d.completed,
            failed: existing.failed + d.failed
        });
    });
    
    // Convertir a array y ordenar por timestamp
    const sortedData = Array.from(groupedData.entries())
        .sort((a, b) => a[0] - b[0]);
    
    series.value[0].data = sortedData.map(([x, data]) => ({ x, y: data.completed }));
    series.value[1].data = sortedData.map(([x, data]) => ({ x, y: data.failed }));
};

// Obtener tipos únicos de los datos
const availableTypes = computed(() => {
    const types = new Set(rawData.value.map(d => d.type));
    return Array.from(types).sort();
});

onMounted(loadData);
watch(() => props.refreshTrigger, loadData);
watch(typeFilter, updateChartData);
</script>

<template>
    <div class="h-full w-full relative flex flex-col">
        <!-- Filtro de Tipo -->
        <div class="flex justify-end mb-3 px-1">
            <select v-model="typeFilter"
                class="bg-surface border border-border rounded-lg px-3 py-1.5 text-xs text-text focus:outline-none focus:ring-2 focus:ring-primary/20">
                <option value="">Todos los Tipos</option>
                <option v-for="type in availableTypes" :key="type" :value="type">{{ type }}</option>
            </select>
        </div>
        
        <!-- Gráfico -->
        <div class="flex-1 relative min-h-0">
            <div v-if="loading" class="absolute inset-0 flex items-center justify-center bg-surface/50 z-10">
                <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
            </div>
            <VueApexCharts height="100%" width="100%" :options="chartOptions" :series="series" />
        </div>
    </div>
</template>
