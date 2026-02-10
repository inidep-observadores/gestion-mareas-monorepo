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
    tipoMarea: string;
    buque: string;
    flota: string;
    pesqueria: string;
    observador: string;
    estado: string;
    diasContabilizados: number;
    diasCalendario: number;
    diasTotales: number;
    fechaInicio: Date | string;
    fechaFin: Date | string | null;
}
