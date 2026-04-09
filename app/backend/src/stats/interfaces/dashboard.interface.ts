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
    /** Fecha de envío a la DNI para protocolización */
    fechaEnvioProtocolizacion: Date | string | null;
    /** Número de protocolo asignado por la DNI */
    nroProtocolizacion: number | null;
    /** Año del número de protocolo */
    anioProtocolizacion: number | null;
    /** Fecha de protocolización oficial */
    fechaProtocolizacion: Date | string | null;
    /** ID del observador principal (para cruzar con tipoObservador) */
    observadorId: string | null;
    /** Orden del estado actual (para calcular "pendientes": orden > 3 y < 11) */
    estadoOrden: number;
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
    /** Tipo de observador del principal (OBSERVADOR | TECNICO | etc.) */
    tipoObservador: string | null;
}

export interface AuditSpecialCasesResult {
    canceladas: AuditSpecialMarea[];
    desestimadas: AuditSpecialMarea[];
    esperandoEntrega: AuditSpecialMarea[];
    pendientesDeInforme: AuditSpecialMarea[];
    delegadasExternas: AuditSpecialMarea[];
    esperandoProtocolizacion: AuditSpecialMarea[];
}

// ─── Protocolization Timeline ───────────────────────────────────────────────

export interface ProtocolizationTimelineItem {
    periodo: number;            // 1-12 para meses, o 1-N para semanas
    label: string;              // 'Ene', 'Feb' o '01/01 - 07/01'
    cantidad: number;           // protocolizadas en el periodo
    enviadas: number;           // enviadas a DNI en el periodo
    acumulado: number;
    pctDelTotal: number;
}

export interface ProtocolizedMareaDetail {
    id: string;
    id_marea: string;
    buque: string;
    observador: string;
    nroProtocolizacion: number | null;
    anioProtocolizacion: number | null;
    fechaProtocolizacion: Date | string | null;
}

export interface ProtocolizationTimelineResult {
    totalProtocolizadas: number;
    totalEnviadas: number;      // total enviadas a DNI en el período
    totalEnPeriodo: number;     // mareas del período (para calcular % pendientes)
    sinProtocolizar: number;
    tipo: 'WEEKLY' | 'MONTHLY';
    promedioDiasLatencia: number | null;       // recepción de datos → protocolización
    maxDiasLatencia: number | null;
    promedioDiasLatenciaTramite: number | null; // envío a DNI → protocolización
    maxDiasLatenciaTramite: number | null;
    distribucionMensual: ProtocolizationTimelineItem[]; // Mantenemos el nombre por compatibilidad o renombramos a timeline
    protocolizadasDetalle: ProtocolizedMareaDetail[];
}

// ─── Personal Breakdown (Observadores vs Técnicos) ───────────────────────────

export interface PersonalTypeBreakdown {
    dias: number;
    mareasFinalizadas: number;
    mareasEnEjecucion: number;
    desestimadas: number;
    informesDeMarea: number;      // PARA_PROTOCOLIZAR + ESPERANDO_PROTOCOLIZACION + PROTOCOLIZADA
    informesProtocolizados: number; // PROTOCOLIZADA
    informesPendientes: number;   // estado.orden > 3 y < 11
}

export interface PersonalBreakdown {
    observadores: PersonalTypeBreakdown;
    tecnicos: PersonalTypeBreakdown;
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
