import httpClient from "@/config/http/http.client";

export interface ErrorLog {
    id: string;
    timestamp: string;
    level: string;
    source: string;
    context?: string;
    userId?: string;
    userEmail?: string;
    message: string;
    stack?: string;
    detail?: any;
    path?: string;
    method?: string;
    ip?: string;
}

const errorLogsApi = {
    getErrorLogs: async (): Promise<ErrorLog[]> => {
        const { data } = await httpClient.get<ErrorLog[]>('/error-logs');
        return data;
    },

    getErrorLog: async (id: string): Promise<ErrorLog> => {
        const { data } = await httpClient.get<ErrorLog>(`/error-logs/${id}`);
        return data;
    }
};

export default errorLogsApi;
