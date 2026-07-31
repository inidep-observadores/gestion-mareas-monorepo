export type TipoBloqueTimeline = 'MAREA_SIMULADA' | 'MAREA_REAL' | 'LICENCIA' | 'FRANCO' | 'NOVEDAD';

export type EstadoSimulacionItem = 'PENDIENTE' | 'DESIGNADO' | 'RECHAZADO';

export interface MareaSimuladaItem {
  id: string;
  observadorId: string | null;
  observadorNombre?: string;
  pesqueriaId: string;
  pesqueriaNombre: string;
  buqueId?: string;
  buqueNombre?: string;
  puertoZarpadaId?: string;
  puertoZarpadaNombre?: string;
  fechaZarpada: Date | string;
  fechaArribo: Date | string;
  diasEstimados: number;
  estado: EstadoSimulacionItem;
  esInamovible?: boolean;
  tipoBloque: TipoBloqueTimeline;
  color?: string;
  observaciones?: string;
  alertas?: string[];
}

export interface RecursoMareaPendiente {
  id: string;
  pesqueriaId: string;
  pesqueriaNombre: string;
  buqueId?: string;
  buqueNombre?: string;
  diasEstimados: number;
  puertoSugerido?: string;
  prioridad: 'ALTA' | 'MEDIA' | 'BAJA';
  mesProyectado?: number;
}

export interface EscenarioSimulacionState {
  id: string;
  nombre: string;
  descripcion?: string;
  anioOperativo: number;
  estado: 'BORRADOR' | 'EN_REVISION' | 'APROBADO';
  fechaCreacion: string;
  fechaUltimaModificacion?: string;
  items: MareaSimuladaItem[];
}
