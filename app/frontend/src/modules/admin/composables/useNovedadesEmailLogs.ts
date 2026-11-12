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

    const isReprocessing = ref(false);

    const reprocessLog = async (id: string) => {
        isReprocessing.value = true;
        try {
            const result = await novedadesEmailLogsApi.reprocessLog(id);
            toast.success(result.message || 'Reprocesamiento iniciado exitosamente');
            if (selectedLog.value && selectedLog.value.id === id) {
                selectedLog.value.estado = 'PROCESANDO';
            }
            const item = logs.value.find(l => l.id === id);
            if (item) {
                item.estado = 'PROCESANDO';
            }
            // Refrescar en unos segundos para reflejar los resultados finales
            setTimeout(() => {
                fetchLogs(currentPage.value);
            }, 3000);
            return true;
        } catch (error: any) {
            const msg = error.response?.data?.message || 'Error al solicitar el reprocesamiento del correo';
            toast.error(msg);
            return false;
        } finally {
            isReprocessing.value = false;
        }
    };

    onMounted(() => {
        fetchLogs();
    });

    return {
        logs,
        selectedLog,
        isLoading,
        isReprocessing,
        currentPage,
        totalItems,
        fetchLogs,
        selectLog,
        reprocessLog
    };
}
