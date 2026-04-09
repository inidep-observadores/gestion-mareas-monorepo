/**
 * Tokens de diseño centralizados para la generación de documentos Word.
 * Todos los informes del sistema SIGMA deben utilizar estos tokens
 * para mantener consistencia visual con la identidad INIDEP.
 */

/** Paleta de colores institucional INIDEP */
export const INIDEP_COLORS = {
    /** Azul marino institucional - Encabezados, títulos principales */
    primary: '00548B',
    /** Azul claro - Fondos sutiles, KPIs */
    primaryLight: 'DBEAFE',
    /** Azul muy claro - Fondos de cards */
    primaryUltraLight: 'EFF6FF',
    /** Texto principal */
    text: '1E293B',
    /** Texto secundario / notas */
    textMuted: '64748B',
    /** Verde - Indicadores positivos */
    success: '10B981',
    /** Ámbar - Indicadores de advertencia */
    warning: 'F59E0B',
    /** Rojo - Indicadores críticos */
    danger: 'EF4444',
    /** Fondo encabezados de tabla */
    tableHeaderBg: '00548B',
    /** Texto encabezados de tabla */
    tableHeaderText: 'FFFFFF',
    /** Fila alternada de tabla */
    tableRowAlt: 'F8FAFC',
    /** Fila resaltada de tabla (ej: delegadas) - Ámbar suave para mayor contraste */
    tableRowHighlighted: 'FEF3C7',
    /** Fila total de tabla */
    tableTotalBg: 'EFF6FF',
    /** Bordes de tabla */
    tableBorder: 'CBD5E1',
    /** Negro puro */
    black: '000000',
    /** Blanco puro */
    white: 'FFFFFF',
} as const;

/** Familias tipográficas */
export const FONTS = {
    /** Fuente principal para títulos y cuerpo */
    primary: 'Calibri',
    /** Fuente monoespaciada para datos numéricos */
    monospace: 'Consolas',
} as const;

/** Tamaños de fuente en half-points (Word usa half-points: size * 2) */
export const FONT_SIZES = {
    /** Título de portada */
    coverTitle: 36,
    /** Subtítulo de portada */
    coverSubtitle: 24,
    /** Período de portada */
    coverPeriod: 20,
    /** Nota de circulación */
    coverNote: 16,
    /** Título de sección (H1) */
    heading1: 28,
    /** Subtítulo de sección (H2) */
    heading2: 24,
    /** Cuerpo de texto */
    body: 22,
    /** Texto pequeño (notas, complementarios) */
    small: 18,
    /** Encabezado de tabla */
    tableHeader: 20,
    /** Celda de tabla */
    tableCell: 19,
    /** KPI valor grande */
    kpiValue: 36,
    /** KPI etiqueta */
    kpiLabel: 16,
} as const;

/** Espaciado entre párrafos (en twips: 1 punto = 20 twips) */
export const SPACING = {
    /** Después de título de sección */
    afterHeading: 200,
    /** Después de párrafo normal */
    afterParagraph: 120,
    /** Antes de título de sección */
    beforeHeading: 360,
    /** Antes de tabla */
    beforeTable: 200,
    /** Después de tabla */
    afterTable: 200,
    /** Interlineado (1.15) */
    lineSpacing: 276,
} as const;

/** Colores para gráficos Chart.js (RGBA) */
export const CHART_COLORS = {
    primary: 'rgba(0, 84, 139, 1)',
    primaryLight: 'rgba(0, 84, 139, 0.7)',
    success: 'rgba(16, 185, 129, 1)',
    successLight: 'rgba(16, 185, 129, 0.7)',
    warning: 'rgba(245, 158, 11, 1)',
    warningLight: 'rgba(245, 158, 11, 0.7)',
    danger: 'rgba(239, 68, 68, 1)',
    dangerLight: 'rgba(239, 68, 68, 0.7)',
    violet: 'rgba(139, 92, 246, 1)',
    violetLight: 'rgba(139, 92, 246, 0.7)',
    sky: 'rgba(14, 165, 233, 1)',
    skyLight: 'rgba(14, 165, 233, 0.7)',
    /** Paleta ordenada para series múltiples */
    palette: [
        'rgba(0, 84, 139, 0.85)',
        'rgba(14, 165, 233, 0.85)',
        'rgba(16, 185, 129, 0.85)',
        'rgba(139, 92, 246, 0.85)',
        'rgba(245, 158, 11, 0.85)',
        'rgba(239, 68, 68, 0.85)',
        'rgba(236, 72, 153, 0.85)',
        'rgba(107, 114, 128, 0.85)',
    ],
    paletteSolid: [
        'rgba(0, 84, 139, 1)',
        'rgba(14, 165, 233, 1)',
        'rgba(16, 185, 129, 1)',
        'rgba(139, 92, 246, 1)',
        'rgba(245, 158, 11, 1)',
        'rgba(239, 68, 68, 1)',
        'rgba(236, 72, 153, 1)',
        'rgba(107, 114, 128, 1)',
    ],
} as const;

/** Dimensiones de gráficos en píxeles (se renderizan a 2x para buena resolución) */
export const CHART_DIMENSIONS = {
    /** Ancho estándar */
    width: 1200,
    /** Altura estándar */
    height: 600,
    /** Ancho para gráficos tipo donut/pie */
    pieWidth: 800,
    /** Altura para gráficos tipo donut/pie */
    pieHeight: 600,
    /** Altura para gráficos de barras horizontales (se ajusta con datos) */
    horizontalBarMinHeight: 500,
} as const;

/** Dimensiones de imágenes dentro del documento Word (en EMUs o centímetros) */
export const DOC_IMAGE_DIMENSIONS = {
    /** Ancho de imagen estándar en centímetros */
    standardWidthCm: 16,
    /** Ancho de imagen pie/donut en centímetros */
    pieWidthCm: 12,
} as const;
