
import { ref, onMounted, onUnmounted } from 'vue';
import httpClient from '@/config/http/http.client';
import type { TrackingPoint } from '../data/mockTracking';

export interface FleetVessel {
    id: string;
    name: string;
    matricula: string;
    type: string;
    status: 'OK' | 'OLD' | 'ALARM';
    lat: number;
    lon: number;
    course: number;
    speed: number;
    lastUpdate: string;
    mareaId: string;
}

export function useMonitorVMS() {
    const fleet = ref<FleetVessel[]>([]);
    const isUploading = ref(false);
    const uploadError = ref<string | null>(null);

    const fetchFleet = async () => {
        try {
            const { data } = await httpClient.get<FleetVessel[]>('/tracking/fleet');
            fleet.value = data;
        } catch (e) {
            console.error('Error fetching fleet:', e);
        }
    };

    const triggerHeartbeat = async () => {
        try {
            await httpClient.get('/tracking/heartbeat');
        } catch (e) { }
    };

    const uploadFile = async (file: File) => {
        isUploading.value = true;
        uploadError.value = null;
        try {
            const formData = new FormData();
            formData.append('file', file);
            await httpClient.post('/tracking/upload', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            });
            await triggerHeartbeat();
            await fetchFleet();
            return true;
        } catch (e: any) {
            uploadError.value = 'Error al subir archivo';
            return false;
        } finally {
            isUploading.value = false;
        }
    };

    const getHistory = async (buqueId: string): Promise<TrackingPoint[]> => {
        try {
            const { data } = await httpClient.get<any[]>(`/tracking/history/${buqueId}`);
            return data.map((p: any) => ({
                lat: p.lat,
                lon: p.lon,
                timestamp: p.timestamp,
                speed: p.speed,
                course: p.course,
                status: 'sailing'
            }));
        } catch (e) {
            return [];
        }
    };

    let interval: any;
    onMounted(() => {
        fetchFleet();
        // triggerHeartbeat is global in layout, but good to ensure here too if accessed directly
        interval = setInterval(fetchFleet, 60000);
    });

    onUnmounted(() => {
        if (interval) clearInterval(interval);
    });

    return {
        fleet,
        isUploading,
        uploadFile,
        fetchFleet,
        getHistory,
        triggerHeartbeat
    };
}
