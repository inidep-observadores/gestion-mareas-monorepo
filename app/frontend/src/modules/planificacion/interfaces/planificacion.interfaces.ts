export interface RequerimientoCobertura {
  id: string;
  anioOperativo: number;
  mes: number;
  cantidad: number | null;
  pesqueriaId: string;
  tipoFlotaId: string;
  pesqueria?: {
    id: string;
    nombre: string;
  };
  tipoFlota?: {
    id: string;
    nombre: string;
  };
}

export interface UpsertRequerimientoDto {
  anioOperativo: number;
  mes: number;
  cantidad: number | null;
  pesqueriaId: string;
  tipoFlotaId: string;
}

export interface BatchUpsertRequerimientosDto {
  anioOperativo: number;
  requerimientos: UpsertRequerimientoDto[];
}

export interface ExperienciaObservador {
  id: string;
  observadorId: string;
  pesqueriaId: string;
  valor: number | null;
  fechaActualizacion: string;
  observador?: {
    id: string;
    nombre: string;
    apellido: string;
  };
  pesqueria?: {
    id: string;
    nombre: string;
  };
}

export interface UpsertExperienciaDto {
  observadorId: string;
  pesqueriaId: string;
  valor: number | null;
}

export interface BatchUpsertExperienciaDto {
  experiencias: UpsertExperienciaDto[];
}
