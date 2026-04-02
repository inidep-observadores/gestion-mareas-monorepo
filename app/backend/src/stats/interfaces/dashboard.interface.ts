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
    /** Código del estado actual (e.g. 'EN_EJECUCION', 'DELEGADA_EXTERNA', 'PROTOCOLIZADA') */
    estadoActual: string;
    diasContabilizados: number;
    diasCalendario: number;
    diasTotales: number;
    diasPeriodo: number;
    fechaInicio: Date | string;
    fechaFin: Date | string | null;
    /** Fecha de zarpada de la primera etapa del buque */
    fechaZarpada: Date | string | null;
    /** Fecha de arribo de la última etapa del buque */
    fechaArribo: Date | string | null;
    /** Fecha en que la marea fue derivada a proyecto externo (solo para DELEGADA_EXTERNA) */
    fechaDerivacion: Date | string | null;
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
// ─── Audit Special Cases ───────────────────────────────────────────────────

export interface AuditSpecialMarea {
    id: string;
    id_marea: string;
    buque: string;
    flota: string;
    pesqueria: string;
    observador: string;
    diasNavegados: number;
    /** Para canceladas/desestimadas: fecha del movimiento al estado final */
    fechaEvento: Date | string | null;
    /** Motivo/comentario del movimiento (si existe) */
    motivo: string | null;
}

export interface AuditSpecialCasesResult {
    canceladas: AuditSpecialMarea[];
    desestimadas: AuditSpecialMarea[];
    pendientesDeInforme: AuditSpecialMarea[];
    delegadasExternas: AuditSpecialMarea[];
}

// ─── Protocolization Timeline ───────────────────────────────────────────────

export interface ProtocolizationMonthItem {
    mes: number;                // 1-12
    label: string;              // 'Ene', 'Feb', etc.
    cantidad: number;           // protocolizadas en el mes
    enviadas: number;           // enviadas a DNI en el mes
    acumulado: number;
    pctDelTotal: number;
}

export interface ProtocolizationTimelineResult {
    totalProtocolizadas: number;
    totalEnviadas: number;      // total enviadas a DNI en el período
    totalEnPeriodo: number;     // mareas del período (para calcular % pendientes)
    sinProtocolizar: number;
    promedioDiasLatencia: number | null;
    maxDiasLatencia: number | null;
    distribucionMensual: ProtocolizationMonthItem[];
}

// ─── Secondary Observer Stats ───────────────────────────────────────────────

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
    fechaZarpada: Date | string;
    fechaArribo: Date | string | null;
    observador: string;
    tipoMarea: string;
}
