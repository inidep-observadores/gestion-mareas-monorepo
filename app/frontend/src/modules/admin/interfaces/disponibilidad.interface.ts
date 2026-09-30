export interface ObservadorDisponibilidadItem {
  id: string;
  startDate: string;
  endDate: string;
  estado: 'DISPONIBLE' | 'DISPONIBLE_NO_CONFIRMADA' | 'NAVEGANDO' | 'PUERTO' | 'NOVEDAD' | 'VIAJE' | 'ESPERANDO_ZARPADA' | 'CONFLICTO' | 'IMPEDIMENTO' | 'DESIGNADA';
  estadoSecundario?: string;
  detalle?: string;
  codigoCorto?: string;
  flexible?: boolean;
  isPast?: boolean;
  buqueId?: string;
  buqueNombre?: string;
}

export interface ObservadorDisponibilidadRow {
  observador: {
    id: string;
    nombre: string;
    apellido: string;
    codigoInterno: number;
    tipoObservador: string;
    tipoContrato: string;
    conImpedimento: boolean;
    motivoImpedimento?: string | null;
    disponible: boolean;
  };
  eventos: ObservadorDisponibilidadItem[];
}

export interface DisponibilidadResponse {
  fechaInicio: string;
  fechaFin: string;
  fechaHoy: string;
  observadores: ObservadorDisponibilidadRow[];
}
