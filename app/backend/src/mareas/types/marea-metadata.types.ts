/**
 * Contrato tipado para el campo `metadata` de la tabla `mareas`.
 *
 * Este campo almacena datos de planificación (borradores) que no requieren
 * integridad referencial estricta en la base de datos.
 *
 * REGLA: Siempre usar este tipo al leer/escribir `mareas.metadata`.
 * NUNCA tratar el campo como `any` o `Record<string, unknown>` libre.
 */

export interface ObservadorSecundarioPlanificado {
    /** UUID del observador. Validar existencia antes de materializar. */
    observadorId: string;
    /** Número de etapa desde la que aplica (inclusivo, base 1). */
    etapaDesde: number;
    /**
     * Número de etapa hasta la que aplica (inclusivo).
     * `null` o undefined significa "sin límite" (aplica desde etapaDesde hasta el final).
     */
    etapaHasta?: number | null;
    /** Nota interna opcional (uso administrativo). */
    notas?: string;
}

export interface MareaMetadata {
    /**
     * Lista de observadores secundarios cuya presencia está planificada
     * pero aún no se ha materializado en `mareas_etapas_observadores`.
     *
     * Al materializar (crear etapa), la entrada correspondiente se elimina
     * de este array. Al cancelar la marea, el array se limpia completamente.
     */
    observadoresSecundariosPlanificados?: ObservadorSecundarioPlanificado[];
}
