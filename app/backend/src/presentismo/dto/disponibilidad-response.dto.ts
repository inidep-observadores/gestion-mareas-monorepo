export interface ObservadorDisponibilidadItemDto {
  id: string;
  startDate: string; // ISO string
  endDate: string;   // ISO string
  estado: 'DISPONIBLE' | 'DISPONIBLE_NO_CONFIRMADA' | 'NAVEGANDO' | 'PUERTO' | 'NOVEDAD' | 'VIAJE' | 'ESPERANDO_ZARPADA' | 'CONFLICTO' | 'IMPEDIMENTO' | 'DESIGNADA';
  estadoSecundario?: string;
  detalle?: string;
  codigoCorto?: string;
  flexible?: boolean; // Permite cancelación anticipada por urgencia (ej: FC o permiteUrgencia=true)
  isPast?: boolean;   // Evento previo a hoy (se atenúa)
}

export interface ObservadorDisponibilidadRowDto {
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
  eventos: ObservadorDisponibilidadItemDto[];
}

export interface DisponibilidadResponseDto {
  fechaInicio: string; // ISO
  fechaFin: string;    // ISO
  fechaHoy: string;    // ISO
  observadores: ObservadorDisponibilidadRowDto[];
}
