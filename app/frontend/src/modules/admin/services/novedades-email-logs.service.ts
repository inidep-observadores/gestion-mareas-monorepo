import httpClient from "@/config/http/http.client";

export interface NovedadesEmailLog {
    id: string;
    messageId?: string;
    asunto?: string;
    remitente?: string;
    fechaRecepcion?: string;
    fechaProcesamiento: string;
    estado: string;
    extraccionAi?: any;
    novedadId?: string;
    errorDetalle?: string;
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
    }
};

export default novedadesEmailLogsApi;
