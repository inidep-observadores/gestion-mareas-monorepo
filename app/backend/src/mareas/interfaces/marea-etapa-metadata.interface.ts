export interface MareaOpcionesCierre {
  finalizarMareaAlArribo: boolean;
  marcadoPorUsuarioId?: string;
  fechaMarca?: Date | string;
}

export interface MareaEtapaMetadata {
  opcionesCierre?: MareaOpcionesCierre;
  // Permitir la extensibilidad futura
  [key: string]: any;
}
