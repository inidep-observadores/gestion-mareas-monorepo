import type { Observador } from './observador.interface';
import type { TipoNovedad } from './tipo-novedad.interface';

export interface Novedad {
  id: string;
  observadorId: string;
  tipoNovedadId: string;
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
  tipoNovedad?: TipoNovedad;
  metadata?: any;
  archivos?: any[];
  movimientos?: any[];
  creadoPor?: {
    id: string;
    email: string;
    name: string;
  };
  activo: boolean;
}

export interface CreateNovedadDto {
  observadorId: string;
  tipoNovedadId: string;
  fechaInicio: string;
  fechaFin?: string | null;
  permiteUrgencia?: boolean;
  motivo?: string | null;
}

export interface UpdateNovedadDto extends Partial<CreateNovedadDto> {
  estadoAprobacion?: 'APROBADA' | 'RECHAZADA' | 'PENDIENTE';
  comentarioMovimiento?: string;
}
