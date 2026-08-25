import httpClient from "@/config/http/http.client";

export interface NovedadesEmailLogDetalle {
    id: string;
    emailLogId: string;
    fuente: string;
    extraccionAi?: any;
    numeroGde?: string;
    estado: string;
    errorDetalle?: string;
    novedadId?: string;
    novedad?: any;
}

export interface NovedadesEmailLog {
    id: string;
    messageId?: string;
    asunto?: string;
    remitente?: string;
    fechaRecepcion?: string;
    fechaProcesamiento: string;
    estado: string;
    detalles?: NovedadesEmailLogDetalle[];
}

export interface NovedadesEmailLogResponse {
    items: NovedadesEmailLog[];
    total: number;
    page: number;
    limit: number;
}

const novedadesEmailLogsApi = {
    getLogs: async (page: number = 1, limit: number = 50): Promise<NovedadesEmailLogResponse> => {
        const { data } = await httpClient.get<NovedadesEmailLogResponse>('/mail-admin/logs', {
            params: { page, limit }
        });
        return data;
    },

    reprocessLog: async (id: string): Promise<{ success: boolean; message: string }> => {
        const { data } = await httpClient.post<{ success: boolean; message: string }>(`/mail-admin/logs/${id}/reprocess`);
        return data;
    }
};

export default novedadesEmailLogsApi;
