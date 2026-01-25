import { ref, onMounted } from 'vue';
import errorLogsApi, { type ErrorLog } from '../services/error-logs.service';
import { toast } from 'vue-sonner';

export function useErrorLogs() {
    const errorLogs = ref<ErrorLog[]>([]);
    const selectedLog = ref<ErrorLog | null>(null);
    const isLoading = ref(false);

    const fetchErrorLogs = async () => {
        isLoading.value = true;
        try {
            errorLogs.value = await errorLogsApi.getErrorLogs();
        } catch (error) {
            toast.error('Error al cargar logs de errores');
        } finally {
            isLoading.value = false;
        }
    };

    const selectLog = (log: ErrorLog) => {
        selectedLog.value = log;
    };

    onMounted(() => {
        fetchErrorLogs();
    });

    return {
        errorLogs,
        selectedLog,
        isLoading,
        fetchErrorLogs,
        selectLog
    };
}
