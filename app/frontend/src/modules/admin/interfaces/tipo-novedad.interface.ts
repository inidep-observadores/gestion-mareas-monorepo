export interface TipoNovedad {
  id: string;
  codigo: string;
  descripcion: string;
  afectaPresentismo: boolean;
  tiposContratoPermitidos: string[];
  activo: boolean;
  metadata?: any;
}
