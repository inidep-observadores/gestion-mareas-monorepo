/**
 * Contrato tipado espejo para el campo `metadata` de Marea en el frontend.
 */

export interface ObservadorSecundarioPlanificado {
  /** UUID del observador */
  observadorId: string;
  /** Número de etapa desde la que aplica (inclusivo, base 1) */
  etapaDesde: number;
  /**
   * Número de etapa hasta la que aplica (inclusivo).
   * `null` significa "sin límite / hasta la última etapa".
   */
  etapaHasta: number | null;
  /** Nota interna opcional */
  notas?: string;
}

export interface MareaMetadata {
  observadoresSecundariosPlanificados?: ObservadorSecundarioPlanificado[];
}
