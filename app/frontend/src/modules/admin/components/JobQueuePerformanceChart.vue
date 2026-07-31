<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import VueApexCharts from 'vue3-apexcharts';
import type { ApexOptions } from 'apexcharts';
import { jobQueueService } from '../services/JobQueueService';

const props = defineProps<{
    refreshTrigger?: number;
}>();

const chartOptions = ref<ApexOptions>({
    chart: {
        id: 'job-performance-chart',
        type: 'bar' as const,
        toolbar: { show: false },
        fontFamily: 'Inter, sans-serif',
        height: '100%',
        offsetY: -10,
        parentHeightOffset: 0,
    },
    plotOptions: {
        bar: {
            borderRadius: 6,
            horizontal: true,
            distributed: true,
            barHeight: '60%',
        }
    },
    colors: ['#6366f1', '#8b5cf6', '#ec4899', '#f97316'], // Mix of Indigo, Violet, Pink, Orange
    xaxis: {
        categories: [] as string[],
        labels: {
            style: { colors: '#64748b' },
            formatter: (val: any) => `${Math.round(Number(val))}ms`,
            offsetY: -5,
        }
    },
    yaxis: {
        labels: {
            style: { colors: '#64748b' }
        }
    },
    grid: {
        borderColor: '#f1f5f9',
        xaxis: { lines: { show: true } },
        yaxis: { lines: { show: false } },
    },
    dataLabels: {
        enabled: true,
        formatter: (val: any) => `${Math.round(Number(val))}ms`,
        style: { fontSize: '12px' }
    },
    legend: { show: false },
    tooltip: { theme: 'light' }
});

const series = ref([{
    name: 'Promedio Duración',
    data: [] as number[]
}]);

const loading = ref(true);

const jobTypeLabels: Record<string, string> = {
    'VESSEL_SYNC': 'Sincro Buques',
    'PNA_API_SYNC': 'Sincro PNA (Eventos)',
    'PNA_TRACKING_SYNC': 'Sincro Tracking',
    'TRAJECTORY_SYNC': 'Sincro Trayectorias',
    'DAILY_BACKUP': 'Resguardo Diario',
    'NOVEDADES_EMAIL_SYNC': 'Sincro Novedades Email',
};

const loadData = async () => {
    loading.value = true;
    try {
        const data = await jobQueueService.getPerformanceStats();
        
        // Update data
        series.value = [{
            name: 'Promedio Duración',
            data: data.map(d => d.avgDuration)
        }];

        // Update categories reactively
        const categories = data.map(d => jobTypeLabels[d.type] || d.type);
        
        chartOptions.value = {
            ...chartOptions.value,
            xaxis: {
                ...chartOptions.value.xaxis,
                categories: categories
            }
        };
    } catch (error) {
        console.error('Error loading performance stats:', error);
    } finally {
        loading.value = false;
    }
};

onMounted(loadData);
watch(() => props.refreshTrigger, loadData);
</script>

<template>
    <div class="h-full w-full relative">
        <div v-if="loading" class="absolute inset-0 flex items-center justify-center bg-surface/50 z-10">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-primary"></div>
        </div>
        <VueApexCharts height="100%" width="100%" :options="chartOptions" :series="series" />
    </div>
</template>
