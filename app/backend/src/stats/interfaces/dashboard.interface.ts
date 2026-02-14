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
    diasPeriodo: number;
    fechaInicio: Date | string;
    fechaFin: Date | string | null;
}

export interface UniqueVesselsResult {
    count: number;
    monthly: {
        month: number;
        count: number;
        days: number;
        fleets: { name: string; count: number; days: number }[];
    }[];
}
export interface MareaDistributionItem {
    mareaId: string;
    id_marea: string;
    buque: string;
    pesqueria: string;
    pesqueriaId: string | null;
    nroEtapa: number;
    fechaZarpada: Date | string;
    fechaArribo: Date | string | null;
    observador: string;
    tipoMarea: string;
}
