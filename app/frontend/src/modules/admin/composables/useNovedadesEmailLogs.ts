import { ref, onMounted } from 'vue';
import novedadesEmailLogsApi, { type NovedadesEmailLog } from '../services/novedades-email-logs.service';
import { toast } from 'vue-sonner';

export function useNovedadesEmailLogs() {
    const logs = ref<NovedadesEmailLog[]>([]);
    const selectedLog = ref<NovedadesEmailLog | null>(null);
    const isLoading = ref(false);
    const currentPage = ref(1);
    const totalItems = ref(0);

    const fetchLogs = async (page: number = 1) => {
        isLoading.value = true;
        try {
            const response = await novedadesEmailLogsApi.getLogs(page, 50);
            logs.value = response.items;
            totalItems.value = response.total;
            currentPage.value = response.page;
        } catch (error) {
            toast.error('Error al cargar historial de correos de novedades');
        } finally {
            isLoading.value = false;
        }
    };

    const selectLog = (log: NovedadesEmailLog) => {
        selectedLog.value = log;
    };

    onMounted(() => {
        fetchLogs();
    });

    return {
        logs,
        selectedLog,
        isLoading,
        currentPage,
        totalItems,
        fetchLogs,
        selectLog
    };
}
