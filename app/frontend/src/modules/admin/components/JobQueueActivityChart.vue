<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';
import VueApexCharts from 'vue3-apexcharts';
import type { ApexOptions } from 'apexcharts';
import { jobQueueService } from '../services/JobQueueService';
import type { JobTimeseriesData } from '../interfaces/job-queue.interface';

const props = defineProps<{
    refreshTrigger?: number;
}>();

const chartOptions = ref<ApexOptions>({
    chart: {
        id: 'job-activity-chart',
        type: 'area' as const,
        toolbar: { show: false },
        fontFamily: 'Inter, sans-serif',
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
            style: { colors: '#64748b' }
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

const series = ref([
    { name: 'Completadas', data: [] as any[] },
    { name: 'Fallidas', data: [] as any[] }
]);

const loading = ref(true);

const loadData = async () => {
    loading.value = true;
    try {
        const data = await jobQueueService.getTimeseriesStats(7);
        series.value[0].data = data.map(d => ({ x: new Date(d.timestamp).getTime(), y: d.completed }));
        series.value[1].data = data.map(d => ({ x: new Date(d.timestamp).getTime(), y: d.failed }));
    } catch (error) {
        console.error('Error loading timeseries stats:', error);
    } finally {
        loading.value = false;
    }
};

onMounted(loadData);
watch(() => props.refreshTrigger, loadData);
</script>

<template>
    <div class="h-full w-full relative">
        <div v-if="loading" class="absolute inset-0 flex items-center justify-center bg-white/50 z-10">
            <div class="animate-spin rounded-full h-8 w-8 border-b-2 border-indigo-500"></div>
        </div>
        <VueApexCharts height="100%" width="100%" :options="chartOptions" :series="series" />
    </div>
</template>
