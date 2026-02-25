import httpClient from "@/config/http/http.client";

export interface AlertLogEntry {
    id: string;
    tipo: 'ZARPADA' | 'ARRIBO' | string;
    titulo: string;
    estado: 'PENDIENTE' | 'RESUELTA' | 'DESCARTADA';
    prioridad: string;
    fechaDetectada: string;
    fechaCierre?: string;
    metadata?: {
        sources?: any[];
        isAuto?: boolean;
        [key: string]: any;
    };
    referenciaId?: string;
    referenciaTipo?: string;
}

export interface AlertQueryParams {
    page?: number;
    limit?: number;
    status?: string;
    type?: string;
    busqueda?: string;
    sortBy?: string;
    sortOrder?: 'asc' | 'desc';
}

export interface PaginatedAlertsResponse {
    data: AlertLogEntry[];
    total: number;
    page: number;
    limit: number;
}

export interface BatchProcessResult {
    total: number;
    processed: number;
    details: Array<{
        id: string;
        titulo: string;
        status: 'CONFIRMED' | 'SKIPPED' | 'ERROR';
        reason?: string;
    }>;
}

const alertsAdminApi = {
    getAlertsLog: async (params: AlertQueryParams): Promise<PaginatedAlertsResponse> => {
        const { data } = await httpClient.get<PaginatedAlertsResponse>('/alerts', {
            params: {
                ...params,
                showHidden: 'true' // Para ver todas en auditoría
            }
        });
        return data;
    },

    processBatchAutomation: async (): Promise<BatchProcessResult> => {
        const { data } = await httpClient.post<BatchProcessResult>('/alerts/automation/batch');
        return data;
    },

    syncTracking: async (): Promise<any> => {
        const { data } = await httpClient.post('/pna-api/sync-tracking');
        return data;
    },

    getConfig: async (): Promise<any> => {
        const { data } = await httpClient.get('/pna-api/config');
        return data;
    },

    updateConfig: async (config: any): Promise<void> => {
        await httpClient.post('/pna-api/config', config);
    },

    syncManual: async (params: { type: 'API' | 'TRACKING', fromDate: string, toDate: string }): Promise<any> => {
        const { data } = await httpClient.post('/pna-api/sync-manual', params);
        return data;
    }
};

export default alertsAdminApi;
