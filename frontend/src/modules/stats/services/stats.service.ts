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
    observers: { name: string; mareas: number; days: number; active: boolean }[];
}

export const statsService = {
    getDashboardStats: async (
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean
    ): Promise<DashboardStats> => {
        // Note: Backend expects 'includeNonProtocolized', but UI toggle is "Protocolized Only".
        // So if protocolizedOnly is true -> includeNonProtocolized = false.
        const query = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: includeNonProtocolized.toString(),
            includeProtocolizedOutOfPeriod: includeProtocolizedOutOfPeriod.toString(),
        });

        const { data } = await httpClient.get<DashboardStats>(`/stats/dashboard?${query.toString()}`);
        return data;
    }
};
