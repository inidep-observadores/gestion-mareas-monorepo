import httpClient from '@/config/http/http.client';
import { useConfigStore } from '@/modules/shared/stores/config.store';
import { TipoMarea } from '../types/enums';

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
    tipo_marea: TipoMarea;
    puerto: string;
    puerto_zarpada?: string;
    puerto_arribo?: string;
    fecha_arribo?: string;
    progreso: number;
    observador?: string;
    fecha_fin_observador?: string;
    en_tierra?: boolean;
    total_etapas: number;
    pesquerias_nombres: string[];
    alertas: any[];
    dias_estimados?: number;
    actionsAvailable: Record<string, { enabled: boolean; label: string; blockedReason?: string; claseBoton?: string }>;
}

export interface MareaContext {
    marea: {
        id: string;
        id_marea: string;
        buque_nombre: string;
        puertoBaseId?: string;
        puertoBaseNombre?: string;
        estado: string;
        estado_codigo: string;
        fecha_zarpada_estimada?: string;
        fecha_inicio_observador?: string;
        fecha_fin_observador?: string;
        dias_marea: number;
        dias_navegados: number;
        progreso: number;
        observador: string;
        id_pesqueria?: string;
        tipo_marea: TipoMarea;
        etapas?: any[];
    };
    actions: Record<string, { enabled: boolean; label: string; blockedReason?: string; claseBoton?: string }>;
    lastEvents: { id: string; titulo: string; fecha: string; usuario: string }[];
}

export interface DashboardKpis {
    flotaActiva: number;
    observadoresDisponibles: number;
    mareasDesignadas: number;
    listasParaProtocolizar: number;
    enRevision: number;
}

export interface MovementEvent {
    id: string;
    buque: string;
    marea: string;
    observador: string;
    etapa: number;
    tipo: 'ZARPADA' | 'ARRIBO';
    fecha: string;
    puerto: string;
}

export interface CalendarEvent {
    id: string
    title: string
    start: string
    end?: string
    type: string
}

const mareasService = {
    getDashboardOperativo: async (showAll: boolean = false): Promise<MareaDashboard> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<MareaDashboard>(`/mareas/operativo?year=${selectedYear}&showAll=${showAll}`);
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
    },

    exportToExcel: async (params: { year?: number; searchQuery?: string; ids?: string[] }): Promise<Blob> => {
        const { data } = await httpClient.post('/mareas/export/excel', params, {
            responseType: 'blob'
        });
        return data;
    },

    getRecentMovements: async (days: number): Promise<{ events: MovementEvent[], lastUpdate: string | null }> => {
        const { data } = await httpClient.get<{ events: MovementEvent[], lastUpdate: string | null }>(`/mareas/movimientos-recientes?days=${days}`);
        return data;
    }
};

export default mareasService;
