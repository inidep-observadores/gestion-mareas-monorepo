import httpClient from '@/config/http/http.client';
import { useConfigStore } from '@/modules/shared/stores/config.store';

export interface MareaDashboard {
    kpis: { label: string; value: number; codigo: string }[];
    items: MareaListItem[];
}

export interface MareaListItem {
    id: string;
    id_marea: string;
    anio_marea: number;
    nro_marea: number;
    buque_nombre: string;
    puertoBaseId?: string;
    estado: string;
    estado_codigo: string;
    fecha_zarpada?: string;
    puerto: string;
    progreso: number;
    observador?: string;
    fecha_fin_observador?: string;
    en_tierra?: boolean;
    alertas: any[];
    actionsAvailable: Record<string, { enabled: boolean; label: string; blockedReason?: string }>;
}

export interface MareaContext {
    marea: {
        id: string;
        id_marea: string;
        buque_nombre: string;
        puertoBaseId?: string;
        estado: string;
        estado_codigo: string;
        fecha_zarpada_estimada?: string;
        fecha_fin_observador?: string;
        dias_marea: number;
        dias_navegados: number;
        etapas?: any[];
    };
    actions: Record<string, { enabled: boolean; label: string; blockedReason?: string }>;
    lastEvents: { id: string; titulo: string; fecha: string; usuario: string }[];
}

export interface DashboardKpis {
    flotaActiva: number;
    observadoresDisponibles: number;
    mareasDesignadas: number;
    listasParaProtocolizar: number;
    enRevision: number;
}

export interface CalendarEvent {
    id: string
    title: string
    start: string
    end?: string
    type: string
}

const mareasService = {
    getDashboardOperativo: async (): Promise<MareaDashboard> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<MareaDashboard>(`/mareas/operativo?year=${selectedYear}`);
        return data;
    },

    getDashboardKpis: async (): Promise<DashboardKpis> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<DashboardKpis>(`/mareas/kpis?year=${selectedYear}`);
        return data;
    },

    getInbox: async (): Promise<{ alerts: any[], tasks: any[] }> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<{ alerts: any[], tasks: any[] }>(`/mareas/inbox?year=${selectedYear}`);
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
    },

    getCalendarEvents: async (): Promise<CalendarEvent[]> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<CalendarEvent[]>(`/mareas/calendar/events?year=${selectedYear}`);
        return data;
    }
};

export default mareasService;
