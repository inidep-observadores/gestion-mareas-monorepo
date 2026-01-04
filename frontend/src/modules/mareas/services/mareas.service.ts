import httpClient from '@/config/http/http.client';
import { useConfigStore } from '@/modules/shared/stores/config.store';

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
    observador?: string;
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

export interface MareaEtapaDetalle {
    id: string;
    nroEtapa: number;
    fechaZarpada?: string | null;
    fechaArribo?: string | null;
    tipoEtapa: string;
    puertoZarpada?: { nombre: string } | null;
    puertoArribo?: { nombre: string } | null;
    pesqueria?: { nombre: string } | null;
    observadores: Array<{
        rol: string;
        esDesignado: boolean;
        observador: {
            id: string;
            nombre: string;
            apellido: string;
            codigoInterno?: number | null;
        };
    }>;
}

export interface MareaDetalle {
    id: string;
    anioMarea: number;
    nroMarea: number;
    tipoMarea?: string | null;
    titulo?: string | null;
    descripcion?: string | null;
    activo: boolean;
    fechaCreacion: string;
    fechaUltimaActualizacion: string;
    fechaZarpadaEstimada?: string | null;
    fechaInicioObservador?: string | null;
    fechaFinObservador?: string | null;
    buque: {
        id: string;
        nombreBuque: string;
        matricula?: string | null;
    };
    estadoActual: {
        id: string;
        nombre: string;
        codigo: string;
    };
    etapas: MareaEtapaDetalle[];
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

    getById: async (id: string): Promise<MareaDetalle> => {
        const { data } = await httpClient.get<MareaDetalle>(`/mareas/${id}`);
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
