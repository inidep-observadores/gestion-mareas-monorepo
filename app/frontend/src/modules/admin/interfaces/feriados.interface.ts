export interface Feriado {
  fecha: string;
  nombre: string;
  tipo: string;
  origen: string;
}

export interface CreateFeriadoDto {
  fecha: string;
  nombre: string;
  tipo: string;
  origen?: string;
}

export interface SyncFeriadosResponse {
  message: string;
  count: number;
  year: number;
}
