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
