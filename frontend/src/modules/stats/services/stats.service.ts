import httpClient from '@/config/http/http.client';

export interface DashboardStats {
    year: number;
    mode: 'CALENDAR' | 'TOTAL';
    totalMareas: number;
    totalDaysNavigated: number;
    avgDaysPerMarea: number;
    monthly: {
        mareas: number[];
        days: number[];
    };
    fisheries: { name: string; mareas: number; days: number }[];
    fleets: { name: string; mareas: number; days: number }[];
    observers: { name: string; id: string; mareas: number; days: number; active: boolean }[];
}

export interface StatsDetailItem {
    id: string;
    id_marea: string;
    anioMarea: number;
    nroMarea: number;
    buque: string;
    flota: string;
    pesqueria: string;
    observador: string;
    estado: string;
    diasContabilizados: number;
    fechaInicio: string;
    fechaFin: string | null;
}

export const statsService = {
    getDashboardStats: async (
        year: number,
        mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        includeNonProtocolized = true,
        includeProtocolizedOutOfPeriod = false
    ): Promise<DashboardStats> => {
        const { data } = await httpClient.get<DashboardStats>(`/stats/dashboard`, {
            params: { year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod }
        });
        return data;
    },

    getDashboardStatsDetail: async (
        year: number,
        mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        includeNonProtocolized = true,
        includeProtocolizedOutOfPeriod = false,
        filterType: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue: string
    ): Promise<StatsDetailItem[]> => {
        const { data } = await httpClient.get<StatsDetailItem[]>(`/stats/detail`, {
            params: { year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, filterType, filterValue }
        });
        return data;
    },

    downloadExport: async (
        year: number,
        mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        includeNonProtocolized = true,
        includeProtocolizedOutOfPeriod = false,
        filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue?: string,
        filename?: string
    ): Promise<void> => {
        const response = await httpClient.get(`/stats/export`, {
            params: { year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, filterType, filterValue, filename },
            responseType: 'blob'
        });

        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;
        const downloadName = filename ? `${filename}.xlsx` : `Estadisticas_Mareas_${year}.xlsx`;
        link.setAttribute('download', downloadName);
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
    }
};
