import httpClient from '@/config/http/http.client';
import { useConfigStore } from '@/modules/shared/stores/config.store';
import { TipoMarea } from '../types/enums';

import type { MareaDashboard, MareaContext, DashboardKpis, MovementEvent, CalendarEvent, ZonaAustralResponse } from '../types/marea.types';

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
    },

    getNextMareaNumber: async (year: number, tipo: TipoMarea): Promise<number> => {
        const { data } = await httpClient.get<number>(`/mareas/config/proximo-numero?year=${year}&tipo=${tipo}`);
        return data;
    },

    validateVesselAvailability: async (id: string): Promise<{ available: boolean; marea: string | null }> => {
        const { data } = await httpClient.get<{ available: boolean; marea: string | null }>(`/mareas/valida/buque/${id}`, { skipToast: true });
        return data;
    },

    validateObserverAvailability: async (id: string): Promise<{ available: boolean; marea: string | null }> => {
        const { data } = await httpClient.get<{ available: boolean; marea: string | null }>(`/mareas/valida/observador/${id}`, { skipToast: true });
        return data;
    },

    getZonaAustralDays: async (id: string): Promise<ZonaAustralResponse> => {
        const { data } = await httpClient.get<ZonaAustralResponse>(`/mareas/${id}/zona-austral`);
        return data;
    },

    setIntencionCierre: async (mareaId: string, etapaId: string, activar: boolean): Promise<any> => {
        const { data } = await httpClient.patch(`/mareas/${mareaId}/etapas/${etapaId}/intencion-cierre`, { activar });
        return data;
    },

    aprobarInforme: async (id: string, file: File, comentarios?: string): Promise<any> => {
        const formData = new FormData()
        formData.append('files', file)
        if (comentarios) formData.append('comentarios', comentarios)
        const { data } = await httpClient.post(`/mareas/${id}/actions/APROBAR_INFORME`, formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        })
        return data
    },

    enviarAProtocolizacion: async (formData: FormData): Promise<{ message: string, count: number }> => {
        const { data } = await httpClient.post<{ message: string, count: number }>('/mareas/protocolizacion/enviar', formData, {
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        });
        return data;
    },

    confirmarProtocolizacion: async (id: string, payload: { nroProtocolizacion: number; anioProtocolizacion: number; fechaProtocolizacion: string }): Promise<any> => {
        const { data } = await httpClient.post(`/mareas/protocolizacion/confirmar/${id}`, payload);
        return data;
    },

    getProtocolizacionPendientes: async (): Promise<any[]> => {
        const { data } = await httpClient.get<any[]>('/mareas/protocolizacion/pendientes');
        return data;
    },

    getProtocolizacionEnEspera: async (): Promise<any[]> => {
        const { data } = await httpClient.get<any[]>('/mareas/protocolizacion/en-espera');
        return data;
    },

    getProtocolizacionCompletas: async (): Promise<any[]> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<any[]>(`/mareas/protocolizacion/completas?year=${selectedYear}`);
        return data;
    },

    getProtocolizacionLotes: async (): Promise<any[]> => {
        const { selectedYear } = useConfigStore();
        const { data } = await httpClient.get<any[]>(`/mareas/protocolizacion/lotes?year=${selectedYear}`);
        return data;
    },

    getProtocolizacionLoteDetalle: async (id: string): Promise<any> => {
        const { data } = await httpClient.get<any>(`/mareas/protocolizacion/lotes/${id}`);
        return data;
    }
};

export default mareasService;
