import httpClient from '@/config/http/http.client';

export interface MareaDashboard {
    kpis: { label: string; value: number; codigo: string }[];
    items: MareaListItem[];
}

export interface MareaListItem {
    id: string;
    id_marea: string;
    buque_nombre: string;
    estado: string;
    estado_codigo: string;
    fecha_zarpada?: string;
    puerto: string;
    progreso: number;
    alertas: any[];
    actionsAvailable: Record<string, { enabled: boolean; label: string; blockedReason?: string }>;
}

export interface MareaContext {
    marea: {
        id: string;
        id_marea: string;
        buque_nombre: string;
        estado: string;
        estado_codigo: string;
        dias_marea: number;
        dias_navegados: number;
    };
    actions: Record<string, { enabled: boolean; label: string; blockedReason?: string }>;
    lastEvents: { id: string; titulo: string; fecha: string; usuario: string }[];
}

const mareasService = {
    getDashboardOperativo: async (): Promise<MareaDashboard> => {
        const { data } = await httpClient.get<MareaDashboard>('/mareas/operativo');
        return data;
    },

    getMareaContext: async (id: string): Promise<MareaContext> => {
        const { data } = await httpClient.get<MareaContext>(`/mareas/${id}/context`);
        return data;
    },

    search: async (q: string): Promise<any[]> => {
        const { data } = await httpClient.get<any[]>(`/mareas/search?q=${q}`);
        return data;
    },

    executeAction: async (id: string, actionKey: string, payload: any = {}): Promise<any> => {
        const { data } = await httpClient.post(`/mareas/${id}/actions/${actionKey}`, payload);
        return data;
    },

    create: async (mareaData: any): Promise<any> => {
        const { data } = await httpClient.post('/mareas', mareaData);
        return data;
    },

    getById: async (id: string): Promise<any> => {
        const { data } = await httpClient.get<any>(`/mareas/${id}`);
        return data;
    },

    update: async (id: string, updateData: any): Promise<any> => {
        const { data } = await httpClient.patch<any>(`/mareas/${id}`, updateData);
        return data;
    }
};

export default mareasService;
