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
    fisheries: { name: string; mareas: number; days: number; stats?: Record<string, { count: number, nombre: string }> }[];
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
    tipoMarea: string;
    diasContabilizados: number;
    diasCalendario: number;
    diasTotales: number;
    fechaInicio: string;
    fechaFin: string | null;
}

export interface MareaDistributionItem {
    mareaId: string;
    id_marea: string;
    buque: string;
    pesqueria: string;
    pesqueriaId: string | null;
    nroEtapa: number;
    fechaZarpada: string;
    fechaArribo: string | null;
    observador: string;
    tipoMarea: string;
}

export const statsService = {
    async getMareaDistribution(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string
    ): Promise<MareaDistributionItem[]> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode: mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            includeCampaigns: String(includeCampaigns)
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<MareaDistributionItem[]>(`/stats/distribution?${params.toString()}`);
        return response.data;
    },

    async getDashboardStats(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        daysCalculationMode: 'SHIP' | 'OBSERVER',
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string
    ): Promise<DashboardStats> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            daysCalculationMode,
            includeCampaigns: String(includeCampaigns)
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<DashboardStats>(`/stats/dashboard?${params.toString()}`);
        return response.data;
    },

    async getDashboardStatsDetail(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        filterType: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue: string,
        daysCalculationMode: 'SHIP' | 'OBSERVER',
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string
    ): Promise<StatsDetailItem[]> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            filterType,
            filterValue,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            daysCalculationMode,
            includeCampaigns: String(includeCampaigns)
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<StatsDetailItem[]>(`/stats/detail?${params.toString()}`);
        return response.data;
    },

    async downloadExport(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        daysCalculationMode: 'SHIP' | 'OBSERVER',
        includeCampaigns: boolean,
        filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER',
        filterValue?: string,
        filename?: string,
        startDate?: string,
        endDate?: string
    ): Promise<void> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            daysCalculationMode,
            includeCampaigns: String(includeCampaigns)
        });

        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);

        if (filterType && filterValue) {
            params.append('filterType', filterType);
            params.append('filterValue', filterValue);
        }

        if (filename) {
            params.append('customFilename', filename);
        }

        const response = await httpClient.get(`/stats/export?${params.toString()}`, {
            responseType: 'blob',
        });

        // Create a URL for the blob
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;

        // Use provided filename or default
        const downloadFilename = filename ? `${filename}.xlsx` : `Estadisticas_${year}.xlsx`;
        link.setAttribute('download', downloadFilename);

        document.body.appendChild(link);
        link.click();

        // Clean up
        link.remove();
        window.URL.revokeObjectURL(url);
    },

    async getUniqueVesselsCount(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string,
        fisheryName?: string,
    ): Promise<{ count: number, monthly: { month: number, count: number }[] }> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            includeCampaigns: String(includeCampaigns)
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        if (fisheryName) {
            params.append('filterType', 'FISHERY');
            params.append('filterValue', fisheryName);
        }
        const response = await httpClient.get<{ count: number, monthly: { month: number, count: number }[] }>(`/stats/vessels-count?${params.toString()}`);
        return response.data;
    }
};
