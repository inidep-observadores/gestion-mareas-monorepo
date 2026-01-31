import { ref, watch } from 'vue';
import auditApi, {
    type AuditApiLog,
    type AuditEntityLog,
    type AuditEventLog,
    type AuditNavigationLog,
    type AuditQueryParams
} from '../services/audit.service';
import { toast } from 'vue-sonner';

export type AuditType = 'api' | 'entidades' | 'eventos' | 'navegacion';

export function useAuditLogs() {
    const activeType = ref<AuditType>('api');
    const apiLogs = ref<AuditApiLog[]>([]);
    const entityLogs = ref<AuditEntityLog[]>([]);
    const eventLogs = ref<AuditEventLog[]>([]);
    const navigationLogs = ref<AuditNavigationLog[]>([]);

    const selectedLog = ref<any | null>(null);
    const isLoading = ref(false);
    const totalItems = ref(0);

    const filters = ref<AuditQueryParams>({
        page: 1,
        limit: 20,
        busqueda: '',
        desde: '',
        hasta: '',
        soloErrores: false
    });

    const fetchLogs = async () => {
        isLoading.value = true;
        try {
            let response;
            switch (activeType.value) {
                case 'api':
                    response = await auditApi.getApiLogs(filters.value);
                    apiLogs.value = response.data;
                    break;
                case 'entidades':
                    response = await auditApi.getEntityLogs(filters.value);
                    entityLogs.value = response.data;
                    break;
                case 'eventos':
                    response = await auditApi.getEventLogs(filters.value);
                    eventLogs.value = response.data;
                    break;
                case 'navegacion':
                    response = await auditApi.getNavigationLogs(filters.value);
                    navigationLogs.value = response.data;
                    break;
            }
            totalItems.value = response?.total || 0;
        } catch (error) {
            toast.error('Error al cargar logs de auditoría');
        } finally {
            isLoading.value = false;
        }
    };

    const selectLog = (log: any) => {
        selectedLog.value = log;
    };

    const setAuditType = (type: AuditType) => {
        activeType.value = type;
        filters.value.page = 1;
        selectedLog.value = null;
        fetchLogs();
    };

    // Watchers for automatic fetch on filter change
    watch(() => filters.value.page, () => fetchLogs());
    watch(() => filters.value.soloErrores, () => {
        filters.value.page = 1;
        fetchLogs();
    });

    return {
        activeType,
        apiLogs,
        entityLogs,
        eventLogs,
        navigationLogs,
        selectedLog,
        isLoading,
        totalItems,
        filters,
        fetchLogs,
        selectLog,
        setAuditType
    };
}
