/**
 * Helpers para generación de texto dinámico en informes Word.
 * Centraliza la lógica de redacción adaptativa según período y datos.
 */

const MONTH_NAMES = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

const MONTH_NAMES_CAP = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
];

const QUARTER_NAMES = ['primer', 'segundo', 'tercer', 'cuarto'];
const QUARTER_ORDINAL = ['1er', '2do', '3er', '4to'];

export interface PeriodInfo {
    year: number;
    startDate?: string; // ISO date o undefined
    endDate?: string;   // ISO date o undefined
}

export interface PeriodDescription {
    /** Ej: "primer trimestre del año 2026 (enero – marzo)" o "año 2026" */
    full: string;
    /** Ej: "1er Trimestre 2026" o "Año 2026" o "Feb–Abr 2026" */
    short: string;
    /** Ej: "enero – marzo 2026" o "2026" */
    range: string;
    /** Ej: "el primer trimestre" o "el año" o "el período" */
    article: string;
    /** Ej: "al primer trimestre" o "al año" o "al período" (contracción a+el resuelta) */
    articleAl: string;
    /** Ej: "del período" o "del trimestre" o "del año" */
    genitive: string;
    /** Ej: "Marzo 2026" para la fecha del documento */
    documentDate: string;
    /** Info del trimestre si aplica (null si es año completo o rango libre) */
    quarter: number | null;
    /** Año principal */
    year: number;
    /** Fecha de inicio del período (ISO string) */
    startDate?: string;
    /** Fecha de fin del período (ISO string) */
    endDate?: string;
}

/**
 * Analiza el período seleccionado y genera descripciones textuales adaptativas.
 */
export function describePeriod(info: PeriodInfo): PeriodDescription {
    const { year, startDate, endDate } = info;

    const now = new Date();
    const docMonth = MONTH_NAMES_CAP[now.getMonth()];
    const docYear = now.getFullYear();
    const documentDate = `${docMonth} ${docYear}`;

    // Si no hay fechas customizadas → año completo
    if (!startDate && !endDate) {
        return {
            full: `año ${year}`,
            short: `Año ${year}`,
            range: `${year}`,
            article: 'el año',
            articleAl: 'al año',
            genitive: 'del año',
            documentDate,
            quarter: null,
            year,
            startDate,
            endDate,
        };
    }

    const start = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1));
    const end = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31));

    // Detectar si es un trimestre exacto
    const quarter = detectQuarter(start, end, year);
    if (quarter !== null) {
        const startMonth = quarter * 3;
        const endMonth = startMonth + 2;
        return {
            full: `${QUARTER_NAMES[quarter]} trimestre del año ${year} (${MONTH_NAMES[startMonth]} – ${MONTH_NAMES[endMonth]})`,
            short: `${QUARTER_ORDINAL[quarter]} Trimestre ${year}`,
            range: `${MONTH_NAMES[startMonth]} – ${MONTH_NAMES[endMonth]} ${year}`,
            article: `el ${QUARTER_NAMES[quarter]} trimestre`,
            articleAl: `al ${QUARTER_NAMES[quarter]} trimestre`,
            genitive: 'del trimestre',
            documentDate,
            quarter: quarter + 1,
            year,
            startDate,
            endDate,
        };
    }

    // Rango libre
    const startMonthName = MONTH_NAMES[start.getUTCMonth()];
    const endMonthName = MONTH_NAMES[end.getUTCMonth()];
    const startMonthCap = MONTH_NAMES_CAP[start.getUTCMonth()];
    const endMonthCap = MONTH_NAMES_CAP[end.getUTCMonth()];

    const startYear = start.getUTCFullYear();
    const endYear = end.getUTCFullYear();

    const isSameYear = startYear === endYear;
    const rangeStr = isSameYear
        ? `${startMonthName} – ${endMonthName} ${startYear}`
        : `${startMonthName} ${startYear} – ${endMonthName} ${endYear}`;

    const shortStr = isSameYear
        ? `${startMonthCap}–${endMonthCap} ${startYear}`
        : `${startMonthCap} ${startYear}–${endMonthCap} ${endYear}`;

    return {
        full: `período ${formatDateSpanish(start)} al ${formatDateSpanish(end)}`,
        short: shortStr,
        range: rangeStr,
        article: 'el período',
        articleAl: 'al período',
        genitive: 'del período',
        documentDate,
        quarter: null,
        year,
        startDate,
        endDate,
    };
}

/**
 * Detecta si un rango de fechas corresponde exactamente a un trimestre.
 * @returns Índice del trimestre (0-3) o null
 */
function detectQuarter(start: Date, end: Date, year: number): number | null {
    const startMonth = start.getUTCMonth();
    const startDay = start.getUTCDate();
    const endMonth = end.getUTCMonth();
    const endDay = end.getUTCDate();
    const startYear = start.getUTCFullYear();
    const endYear = end.getUTCFullYear();

    if (startYear !== year || endYear !== year) return null;
    if (startDay !== 1) return null;

    // Verificar que el endDay sea el último día del mes
    const lastDayOfEndMonth = new Date(Date.UTC(year, endMonth + 1, 0)).getUTCDate();
    if (endDay !== lastDayOfEndMonth) return null;

    // Q1: Ene-Mar, Q2: Abr-Jun, Q3: Jul-Sep, Q4: Oct-Dic
    const quarters = [
        { startMonth: 0, endMonth: 2 },
        { startMonth: 3, endMonth: 5 },
        { startMonth: 6, endMonth: 8 },
        { startMonth: 9, endMonth: 11 },
    ];

    for (let i = 0; i < quarters.length; i++) {
        if (startMonth === quarters[i].startMonth && endMonth === quarters[i].endMonth) {
            return i;
        }
    }

    return null;
}

/**
 * Formatea una fecha como "15 de febrero de 2026"
 */
function formatDateSpanish(date: Date): string {
    const day = date.getUTCDate();
    const month = MONTH_NAMES[date.getUTCMonth()];
    const year = date.getUTCFullYear();
    return `${day} de ${month} de ${year}`;
}

/**
 * Formatea un número con separador de miles (punto) y decimales opcionales (coma).
 * Ej: 1825 → "1.825", 38.5 → "38,5"
 */
export function formatNumber(value: number, decimals = 0): string {
    const parts = value.toFixed(decimals).split('.');
    parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, '.');
    return parts.join(',');
}

/**
 * Formatea un porcentaje. Ej: 0.98 → "98%", 0.296 → "29,6%"
 */
export function formatPercentage(value: number, decimals = 0): string {
    return formatNumber(value * 100, decimals) + '%';
}

/**
 * Genera el texto de la sección de Introducción.
 */
export function generateIntroductionText(
    period: PeriodDescription,
    includeCampaigns: boolean,
): string {
    const tipoMarea = includeCampaigns
        ? 'mareas comerciales e institucionales'
        : 'mareas comerciales';

    return (
        `El presente informe describe la ejecución de ${tipoMarea} del Programa Observadores ` +
        `a Bordo del INIDEP correspondiente al ${period.full}. ` +
        `El documento consolida las estadísticas operativas de personal embarcado, navegación efectiva ` +
        `y distribución por pesquería, con el objetivo de brindar una visión integral de la actividad ` +
        `de observación durante el período.`
    );
}

/**
 * Genera el texto complementario de la introducción sobre mareas previas.
 */
export function generateIntroductionComplementText(
    period: PeriodDescription,
    hasPreviousYearMareas: boolean,
): string {
    if (!hasPreviousYearMareas) {
        return '';
    }

    const prevYear = period.year - 1;
    return (
        `La información aquí reportada comprende tanto las mareas iniciadas durante ` +
        `${period.article} como aquellas provenientes de ${prevYear} que mantuvieron ` +
        `días de navegación dentro del rango temporal analizado.`
    );
}

/**
 * Genera el texto interpretativo del resumen ejecutivo.
 */
export function generateExecutiveSummaryText(
    period: PeriodDescription,
    obsAfectados: number,
    dotacionRef: number,
    coberturaPct: number,
    totalDias: number,
    totalMareas: number,
    totalEtapas: number,
    pesqueriasCubiertas: number,
): string {
    const coberturaStr = formatNumber(coberturaPct, 0);
    return (
        `El nivel de afectación del personal alcanzó el ${coberturaStr}% de la dotación ` +
        `total del INIDEP (${obsAfectados} de ${dotacionRef} observadores), lo que evidencia ` +
        `un ${coberturaPct >= 90 ? 'alto' : coberturaPct >= 70 ? 'adecuado' : 'moderado'} ` +
        `grado de operatividad. Se acumularon ${formatNumber(totalDias)} días de navegación ` +
        `distribuidos en ${totalMareas} mareas y ${totalEtapas} etapas, con cobertura efectiva ` +
        `en ${pesqueriasCubiertas === 1 ? 'una pesquería' : `las ${pesqueriasCubiertas > 6 ? pesqueriasCubiertas : numberToWord(pesqueriasCubiertas)} pesquerías`} bajo observación.`
    );
}

/**
 * Genera el texto interpretativo de la sección de pesquería.
 */
export function generateFisheryAnalysisText(
    fisheryRows: Array<{ pesqueria: string; flota: string; mareas: number; etapas: number; dias: number; pctDias: number }>,
    totalDias: number,
): string {
    if (fisheryRows.length === 0) return '';

    // Agrupar por pesquería para tener los totales
    const byFishery = new Map<string, { mareas: number; dias: number; pctDias: number }>();
    for (const row of fisheryRows) {
        const existing = byFishery.get(row.pesqueria);
        if (existing) {
            existing.mareas += row.mareas;
            existing.dias += row.dias;
            existing.pctDias = (existing.dias / totalDias) * 100;
        } else {
            byFishery.set(row.pesqueria, {
                mareas: row.mareas,
                dias: row.dias,
                pctDias: (row.dias / totalDias) * 100,
            });
        }
    }

    const sorted = Array.from(byFishery.entries()).sort((a, b) => b[1].dias - a[1].dias);
    const parts: string[] = [];

    // Top pesquería
    if (sorted.length > 0) {
        const [topName, topData] = sorted[0];
        parts.push(
            `La pesquería de ${topName.toLowerCase()} concentró la mayor actividad con ` +
            `${topData.mareas} mareas y ${formatNumber(topData.dias)} días navegados, ` +
            `representando el ${formatNumber(topData.pctDias, 1)}% del esfuerzo total.`
        );
    }

    // Resto de pesquerías principales (top 2-4)
    if (sorted.length > 1) {
        const following = sorted.slice(1, Math.min(4, sorted.length));
        const followingText = following.map(([name, data]) =>
            `${name.toLowerCase()} (${formatNumber(data.pctDias, 1)}%)`
        ).join(', ');
        parts.push(`Le siguen ${followingText}.`);
    }

    return parts.join(' ');
}

/**
 * Genera las observaciones complementarias (Sección 7).
 */
export function generateComplementaryObservations(
    period: PeriodDescription,
    fisheryCount: number,
    flotaCount: number,
    obsAfectados: number,
    observers: Array<{ name: string; mareas: number; days: number }>,
    totalDias: number,
    hasPreviousYearMareas: boolean,
    includeCampaigns: boolean,
): Array<{ title: string; text: string }> {
    const observations: Array<{ title: string; text: string }> = [];

    // 1. Diversificación de pesquerías
    const tipoFlota = flotaCount > 1
        ? `en ${flotaCount} tipos de flota`
        : 'en un tipo de flota';

    const diversText = includeCampaigns
        ? `El programa mantuvo cobertura en ${fisheryCount === 1 ? 'una pesquería' : `${numberToWord(fisheryCount)} pesquerías`} principales, operando ${tipoFlota}, equilibrando la representación por tipo de operación.`
        : `El programa mantuvo cobertura en las ${numberToWord(fisheryCount)} pesquerías principales bajo observación comercial, operando ${tipoFlota}.`;

    observations.push({
        title: 'Diversificación de pesquerías',
        text: diversText,
    });

    // 2. Continuidad operativa (solo si hay mareas del año anterior)
    if (hasPreviousYearMareas) {
        observations.push({
            title: 'Continuidad operativa',
            text: `Se registraron mareas provenientes del año ${period.year - 1} que extendieron su navegación ${period.articleAl} ${period.year} (identificadas con numeración de marea del ciclo anterior). Esto refleja la naturaleza continua de la operación pesquera y la adecuada transición entre períodos.`,
        });
    }

    // 3. Rotación de personal
    const obsMultiMarea = observers.filter(o => o.mareas > 1).length;
    const pctMulti = obsAfectados > 0 ? Math.round((obsMultiMarea / obsAfectados) * 100) : 0;

    observations.push({
        title: 'Rotación de personal',
        text: `El ${pctMulti}% de los observadores (${obsMultiMarea} de ${obsAfectados}) participó en más de una marea durante ${period.article}, lo que indica una ${pctMulti >= 50 ? 'adecuada' : 'limitada'} rotación y aprovechamiento de la dotación disponible.`,
    });

    // 4. Carga de trabajo
    if (observers.length > 0) {
        const avgDias = totalDias / obsAfectados;
        const maxObs = observers.reduce((max, o) => o.days > max.days ? o : max, observers[0]);
        const ratio = avgDias > 0 ? maxObs.days / avgDias : 0;
        const ratioText = ratio >= 2 ? 'duplicó' : ratio >= 1.5 ? 'superó significativamente' : 'superó';

        observations.push({
            title: 'Carga de trabajo',
            text: `El observador con mayor cantidad de días embarcado (${maxObs.days} días) ${ratioText} el promedio general (${formatNumber(avgDias, 0)} días). Se recomienda monitorear la distribución de carga para optimizar la equidad en las asignaciones futuras.`,
        });
    }

    return observations;
}

function numberToWord(n: number): string {
    const words = ['cero', 'una', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho', 'nueve', 'diez'];
    return n <= 10 ? words[n] : String(n);
}
