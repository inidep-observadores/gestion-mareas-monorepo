import type { Observador } from '../../observadores/interfaces/observador.interface';

export interface Novedad {
  id: string;
  observadorId: string;
  estadoDisponibilidad: string; // LICEN, FC, RP, ENFERMEDAD, MATERNIDAD, NACIMIENTO, FALLECIMIENTO, EXAMEN, DONACION_SANGRE, VIAJE
  fechaInicio: string;
  fechaFin?: string | null;
  permiteUrgencia: boolean;
  motivo?: string | null;
  estadoAprobacion: string; // APROBADA, PENDIENTE, RECHAZADA
  origen: string; // MANUAL, EMAIL, AUTOMATICO
  creadoPorId?: string | null;
  fechaCreacion: string;
  fechaActualizacion: string;
  observador?: Observador;
  creadoPor?: {
    id: string;
    email: string;
    name: string;
  };
}

export interface CreateNovedadDto {
  observadorId: string;
  estadoDisponibilidad: string;
  fechaInicio: string;
  fechaFin?: string | null;
  permiteUrgencia?: boolean;
  motivo?: string | null;
}

export interface UpdateNovedadDto extends Partial<CreateNovedadDto> {}
