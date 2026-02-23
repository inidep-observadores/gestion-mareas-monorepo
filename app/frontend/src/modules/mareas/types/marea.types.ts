import { TipoMarea } from './enums';

export interface MareaDashboard {
    kpis: { label: string; value: number; codigo: string }[];
    items: MareaListItem[];
}

export interface MareaListItem {
    id: string;
    id_marea: string;
    anio_marea: number;
    nro_marea: number;
    buque_nombre: string;
    puertoBaseId?: string;
    estado: string;
    estado_codigo: string;
    fecha_zarpada?: string;
    tipo_marea: TipoMarea;
    puerto: string;
    puerto_zarpada?: string;
    puerto_arribo?: string;
    fecha_arribo?: string;
    progreso: number;
    observador?: string;
    fecha_fin_observador?: string;
    en_tierra?: boolean;
    total_etapas: number;
    pesquerias_nombres: string[];
    alertas: any[];
    dias_estimados?: number;
    actionsAvailable: Record<string, { enabled: boolean; label: string; blockedReason?: string; claseBoton?: string }>;
}

export interface MareaContext {
    marea: {
        id: string;
        id_marea: string;
        buque_nombre: string;
        puertoBaseId?: string;
        puertoBaseNombre?: string;
        puertoBaseCodigo?: string;
        estado: string;
        estado_codigo: string;
        fecha_zarpada_estimada?: string;
        fecha_inicio_observador?: string;
        fecha_fin_observador?: string;
        dias_marea: number;
        dias_navegados: number;
        progreso: number;
        observador: string;
        id_pesqueria?: string;
        tipo_marea: TipoMarea;
        etapas?: any[];
    };
    actions: Record<string, { enabled: boolean; label: string; blockedReason?: string; claseBoton?: string }>;
    lastEvents: { id: string; titulo: string; fecha: string; usuario: string }[];
}

export interface DashboardKpis {
    flotaActiva: number;
    observadoresDisponibles: number;
    mareasDesignadas: number;
    listasParaProtocolizar: number;
    enRevision: number;
}

export interface MovementEvent {
    id: string;
    buque: string;
    marea: string;
    observador: string;
    etapa: number;
    tipo: 'ZARPADA' | 'ARRIBO';
    fecha: string;
    puerto: string;
    fuentes?: any;
    vesselId?: string;
    mareaId: string;
}

export interface CalendarEvent {
    id: string
    title: string
    start: string
    end?: string
    type: string
}

export enum TipoCalculoZonaAustral {
    AUTOMATICO = 'AUTOMATICO',
    MANUAL = 'MANUAL'
}

// Defining a specific Marea interface for use in forms/dialogs if the nested structure in MareaContext isn't sufficient
export interface Marea {
    id: string;
    id_marea: string;
    buque_id: string;
    buque_nombre?: string;
    buque?: { nombre: string };
    puertoBaseId?: string;
    fecha_zarpada_estimada?: string;
    fecha_inicio_observador?: string;
    fecha_fin_observador?: string;
    fechaInicioObservador?: string; // Legacy/CamelCase support if needed temporarily
    fechaFinObservador?: string; // Legacy/CamelCase support if needed temporarily
    id_pesqueria?: string;
    pesqueriaId?: string;
    tipo_marea?: TipoMarea;
    diasZonaAustral?: number | null;
    tipoCalculoZonaAustral?: TipoCalculoZonaAustral;
}

export interface ZonaAustralEtapa {
    etapaId: string;
    nroEtapa: number;
    diasDetectados: string[];
    totalDias: number;
}

export interface ZonaAustralResponse {
    mareaId: string;
    totalDiasMarea: number;
    diasDetectadosMarea: string[];
    etapas: ZonaAustralEtapa[];
}
