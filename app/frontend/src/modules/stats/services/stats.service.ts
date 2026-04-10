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
    estadoActual: string;
    tipoMarea: string;
    diasContabilizados: number;
    diasCalendario: number;
    diasTotales: number;
    diasPeriodo: number;
    fechaInicio: string;
    fechaFin: string | null;
    fechaZarpada: string | null;
    fechaArribo: string | null;
    fechaDerivacion: string | null;
}

export interface AuditSpecialMarea {
    id: string;
    id_marea: string;
    buque: string;
    flota: string;
    pesqueria: string;
    observador: string;
    diasNavegados: number;
    fechaEvento: string | null;
    motivo: string | null;
}

export interface AuditSpecialCasesResult {
    canceladas: AuditSpecialMarea[];
    desestimadas: AuditSpecialMarea[];
    pendientesDeInforme: AuditSpecialMarea[];
    delegadasExternas: AuditSpecialMarea[];
}

export interface ProtocolizationMonthItem {
    mes: number;
    label: string;
    cantidad: number;
    enviadas: number;
    acumulado: number;
    pctDelTotal: number;
}

export interface ProtocolizationTimelineResult {
    totalProtocolizadas: number;
    totalEnviadas: number;
    totalEnPeriodo: number;
    sinProtocolizar: number;
    promedioDiasLatencia: number | null;
    maxDiasLatencia: number | null;
    distribucionMensual: ProtocolizationMonthItem[];
}

export interface ObserverSecondaryStats {
    observadorId: string;
    etapasComoSecundario: number;
}

export interface MareaDistributionItem {
    mareaId: string;
    id_marea: string;
    buque: string;
    flota: string;
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
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
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
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);
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
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
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
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);
        const response = await httpClient.get<DashboardStats>(`/stats/dashboard?${params.toString()}`);
        return response.data;
    },

    async getDashboardStatsDetail(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        filterType: 'FISHERY' | 'FLEET' | 'OBSERVER' | null,
        filterValue: string | null,
        daysCalculationMode: 'SHIP' | 'OBSERVER',
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ): Promise<StatsDetailItem[]> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            daysCalculationMode,
            includeCampaigns: String(includeCampaigns),
            ...(startDate && { startDate }),
            ...(endDate && { endDate }),
            ...(protocolizationStartDate && { protocolizationStartDate }),
            ...(protocolizationEndDate && { protocolizationEndDate })
        });
        if (filterType) params.append('filterType', filterType);
        if (filterValue) params.append('filterValue', filterValue);

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
        filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER' | 'COVERAGE' | 'CHART_TREND' | 'CHART_FLEET' | 'CHART_FISHERY' | 'CHART_OBSERVER' | 'CHART_FISHERY_DUAL' | 'WORKFORCE' | 'AUDIT',
        filterValue?: string,
        filename?: string,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
        includeSummaries: boolean = false
    ) {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            daysCalculationMode,
            includeCampaigns: String(includeCampaigns),
            includeSummaries: String(includeSummaries)
        });

        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);

        if (filterType) params.append('filterType', filterType);
        if (filterValue) params.append('filterValue', filterValue);

        const response = await httpClient.get('/stats/export', {
            params,
            responseType: 'blob'
        });

        const blob = new Blob([response.data], {
            type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        });
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', `${filename || 'export'}.xlsx`);
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
    },

    async getSecondaryObserverStats(
        year: number,
        startDate?: string,
        endDate?: string,
    ): Promise<ObserverSecondaryStats[]> {
        const params = new URLSearchParams({ year: year.toString() });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<ObserverSecondaryStats[]>(`/stats/secondary-observers?${params}`);
        return response.data;
    },

    async getAuditSpecialCases(
        year: number,
        startDate?: string,
        endDate?: string,
        includeCampaigns = true,
    ): Promise<AuditSpecialCasesResult> {
        const params = new URLSearchParams({
            year: year.toString(),
            includeCampaigns: String(includeCampaigns),
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<AuditSpecialCasesResult>(`/stats/audit-special-cases?${params}`);
        return response.data;
    },

    async getProtocolizationTimeline(
        year: number,
        startDate?: string,
        endDate?: string,
    ): Promise<ProtocolizationTimelineResult> {
        const params = new URLSearchParams({ year: year.toString() });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        const response = await httpClient.get<ProtocolizationTimelineResult>(`/stats/protocolization-timeline?${params}`);
        return response.data;
    },

    async downloadWorkforceExport(year: number, filterValue?: string) {
        return this.downloadExport(
            year,
            'CALENDAR',
            false,
            false,
            'SHIP',
            true,
            'WORKFORCE',
            filterValue,
            `Dotacion_Personal_Mareas_${year}`
        );
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
        protocolizationStartDate?: string,
        protocolizationEndDate?: string,
    ): Promise<{
        count: number,
        monthly: {
            month: number,
            count: number,
            days: number,
            fleets: { name: string, count: number, days: number }[]
        }[]
    }> {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            includeCampaigns: String(includeCampaigns)
        });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);
        if (fisheryName) {
            params.append('filterType', 'FISHERY');
            params.append('filterValue', fisheryName);
        }
        const response = await httpClient.get<{
            count: number,
            monthly: {
                month: number,
                count: number,
                days: number,
                fleets: { name: string, count: number, days: number }[]
            }[]
        }>(`/stats/vessels-count?${params.toString()}`);
        return response.data;
    },

    async downloadAuditReport(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean,
        filename?: string,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ) {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            includeCampaigns: String(includeCampaigns)
        });

        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);

        const response = await httpClient.get('/reports/audit-report', {
            params,
            responseType: 'blob'
        });

        const blob = new Blob([response.data], {
            type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        });
        const url = window.URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', `${filename || 'Informe_Auditoria'}.docx`);
        document.body.appendChild(link);
        link.click();
        link.remove();
        window.URL.revokeObjectURL(url);
    },

    async openAuditReportPdf(
        year: number,
        mode: 'CALENDAR' | 'TOTAL',
        includeNonProtocolized: boolean,
        includeProtocolizedOutOfPeriod: boolean,
        includeCampaigns: boolean,
        startDate?: string,
        endDate?: string,
        protocolizationStartDate?: string,
        protocolizationEndDate?: string
    ) {
        const params = new URLSearchParams({
            year: year.toString(),
            mode,
            includeNonProtocolized: String(includeNonProtocolized),
            includeProtocolizedOutOfPeriod: String(includeProtocolizedOutOfPeriod),
            includeCampaigns: String(includeCampaigns)
        });

        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        if (protocolizationStartDate) params.append('protocolizationStartDate', protocolizationStartDate);
        if (protocolizationEndDate) params.append('protocolizationEndDate', protocolizationEndDate);

        const response = await httpClient.get('/reports/audit-report/pdf', {
            params,
            responseType: 'blob'
        });

        const blob = new Blob([response.data], { type: 'application/pdf' });
        const url = window.URL.createObjectURL(blob);
        
        // Abrir en una pestaña nueva para previsualización
        window.open(url, '_blank');
        
        // Nota: No podemos hacer revokeObjectURL inmediatamente porque la pestaña necesita la URL
        // El navegador la limpiará al cerrar la pestaña o el documento.
    }
};

export default statsService;
