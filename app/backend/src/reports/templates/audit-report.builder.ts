/**
 * Builder del informe de auditoría en formato .docx
 *
 * Genera un documento Word profesional con 7 secciones basadas
 * en los datos de auditoría del Programa Observadores a Bordo (INIDEP).
 *
 * Secciones:
 * 1. Portada institucional
 * 2. Introducción
 * 3. Resumen Ejecutivo (KPIs + gráfico donut)
 * 4. Estadísticas por Pesquería (tabla + texto + gráficos)
 * 5. Estadísticas de Personal (indicadores + gráfico + tabla)
 * 6. Detalle de Navegación (mareas finalizadas)
 * 7. Mareas en Ejecución
 * 8. Observaciones Complementarias
 */
import {
    Document, Packer, Paragraph, TextRun, AlignmentType, Table,
    PageBreak, ImageRun, HeadingLevel, TabStopType, TabStopPosition,
    SectionType,
} from 'docx';
import { Injectable } from '@nestjs/common';
import { INIDEP_COLORS, FONTS, FONT_SIZES, SPACING, DOC_IMAGE_DIMENSIONS } from '../docx/docx-styles';
import { createFormattedTable, createKpiTable } from '../docx/docx-tables';
import { DocxChartService } from '../docx/docx-charts';
import {
    PeriodInfo, PeriodDescription, describePeriod,
    formatNumber, formatPercentage,
    generateIntroductionText, generateIntroductionComplementText,
    generateExecutiveSummaryText, generateFisheryAnalysisText,
    generateComplementaryObservations,
} from '../docx/docx-text';
import { CHART_COLORS } from '../docx/docx-styles';

/** Datos necesarios para construir el informe de auditoría */
export interface AuditReportData {
    year: number;
    mode: 'CALENDAR' | 'TOTAL';
    startDate?: string;
    endDate?: string;
    includeCampaigns: boolean;

    /** Estadísticas globales del dashboard */
    stats: {
        totalMareas: number;
        totalDaysNavigated: number;
        avgDaysPerMarea: number;
        fisheries: Array<{
            name: string;
            mareas: number;
            days: number;
            stats?: Record<string, { count: number; nombre: string }>;
        }>;
        fleets: Array<{ name: string; mareas: number; days: number }>;
        observers: Array<{ id: string; name: string; mareas: number; days: number; active: boolean }>;
    };

    /** Dotación activa de observadores */
    dotacionActiva: number;

    /** Detalle de cada marea */
    detailItems: Array<{
        id: string;
        id_marea: string;
        anioMarea: number;
        buque: string;
        flota: string;
        pesqueria: string;
        observador: string;
        estado: string;
        diasCalendario: number;
        diasTotales: number;
        fechaInicio: Date | string;
        fechaFin: Date | string | null;
    }>;

    /** Distribución de mareas (para contar etapas) */
    distribution: Array<{
        mareaId: string;
        id_marea: string;
        nroEtapa: number;
    }>;
}

@Injectable()
export class AuditReportBuilder {
    constructor(private readonly chartService: DocxChartService) { }

    /**
     * Construye el informe de auditoría completo y retorna el Buffer del .docx
     */
    async build(data: AuditReportData): Promise<Buffer> {
        const period = describePeriod({
            year: data.year,
            startDate: data.startDate,
            endDate: data.endDate,
        });

        // Pre-procesar datos
        const processed = this.preprocessData(data, period);

        // Generar gráficos en paralelo
        const [statusChart, fisheryDaysChart, fisheryCountChart, observerChart] = await Promise.all([
            this.generateStatusChart(processed),
            this.generateFisheryDaysChart(processed),
            this.generateFisheryCountChart(processed),
            this.generateObserverChart(processed),
        ]);

        // Construir secciones del documento
        const children = [
            // Portada
            ...this.buildCoverPage(period),

            // Sección 1: Introducción
            ...this.buildIntroduction(period, data.includeCampaigns, processed.hasPreviousYearMareas),

            // Sección 2: Resumen Ejecutivo
            ...this.buildExecutiveSummary(period, processed, statusChart),

            // Sección 3: Estadísticas por Pesquería
            ...this.buildFisherySection(processed, fisheryDaysChart, fisheryCountChart),

            // Sección 4: Estadísticas de Personal
            ...this.buildPersonnelSection(period, processed, observerChart),

            // Sección 5: Detalle de Navegación (Finalizadas)
            ...this.buildNavigationDetail(processed),

            // Sección 6: Mareas en Ejecución
            ...this.buildOngoingMareas(period, processed),

            // Sección 7: Observaciones Complementarias
            ...this.buildComplementaryObservations(period, processed, data.includeCampaigns),
        ];

        const doc = new Document({
            creator: 'SIGMA - Sistema Integral de Gestión de Mareas',
            title: `Informe de Ejecución de Mareas - ${period.short}`,
            description: `Informe de auditoría del Programa Observadores a Bordo - ${period.range}`,
            styles: {
                default: {
                    document: {
                        run: {
                            font: FONTS.primary,
                            size: FONT_SIZES.body,
                            color: INIDEP_COLORS.text,
                        },
                        paragraph: {
                            spacing: { line: SPACING.lineSpacing },
                        },
                    },
                },
            },
            sections: [{
                properties: {
                    page: {
                        margin: {
                            top: 1134, // ~2cm
                            bottom: 1134,
                            left: 1418, // ~2.5cm
                            right: 1134,
                        },
                    },
                },
                children,
            }],
        });

        return Packer.toBuffer(doc);
    }

    // ─────────────────────────────────────────────────────────────
    // PRE-PROCESAMIENTO DE DATOS
    // ─────────────────────────────────────────────────────────────

    private preprocessData(data: AuditReportData, period: PeriodDescription) {
        const { stats, detailItems, distribution, mode } = data;

        // Mapa de etapas por marea
        const etapasPorMarea = new Map<string, number>();
        distribution.forEach(item => {
            const current = etapasPorMarea.get(item.id_marea) || 0;
            etapasPorMarea.set(item.id_marea, Math.max(current, item.nroEtapa));
        });

        // Items procesados con etapas y días según modo
        const items = detailItems.map(item => ({
            ...item,
            etapas: etapasPorMarea.get(item.id_marea) || 1,
            dias: mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales,
        }));

        // Separar finalizadas y en ejecución
        const finalizadas = items.filter(m => m.estado === 'Finalizada');
        const enEjecucion = items.filter(m => m.estado !== 'Finalizada');

        // ¿Hay mareas del año anterior?
        const hasPreviousYearMareas = items.some(m => m.anioMarea < period.year);

        // Total de etapas
        const totalEtapas = items.reduce((sum, m) => sum + m.etapas, 0);

        // Resumen por pesquería + flota
        const fisheryFlotaMap = new Map<string, {
            pesqueria: string; flota: string; mareas: number; etapas: number; dias: number;
        }>();
        items.forEach(item => {
            const key = `${item.pesqueria}||${item.flota}`;
            if (!fisheryFlotaMap.has(key)) {
                fisheryFlotaMap.set(key, {
                    pesqueria: item.pesqueria,
                    flota: item.flota,
                    mareas: 0,
                    etapas: 0,
                    dias: 0,
                });
            }
            const row = fisheryFlotaMap.get(key)!;
            row.mareas++;
            row.etapas += item.etapas;
            row.dias += item.dias;
        });

        const fisheryRows = Array.from(fisheryFlotaMap.values())
            .sort((a, b) => {
                const p = a.pesqueria.localeCompare(b.pesqueria);
                return p !== 0 ? p : a.flota.localeCompare(b.flota);
            })
            .map(row => ({
                ...row,
                pctDias: stats.totalDaysNavigated > 0
                    ? (row.dias / stats.totalDaysNavigated) * 100
                    : 0,
            }));

        // Conteo de pesquerías y flotas únicas
        const uniqueFisheries = new Set(fisheryRows.map(r => r.pesqueria));
        const uniqueFlotas = new Set(fisheryRows.map(r => r.flota));

        // KPIs
        const obsAfectados = stats.observers.length;
        const dotacionRef = Math.max(data.dotacionActiva, obsAfectados);
        const coberturaPct = dotacionRef > 0
            ? Math.round((obsAfectados / dotacionRef) * 100)
            : 0;
        const promedioDias = obsAfectados > 0
            ? Math.round(stats.totalDaysNavigated / obsAfectados)
            : 0;

        return {
            items,
            finalizadas,
            enEjecucion,
            hasPreviousYearMareas,
            totalEtapas,
            fisheryRows,
            uniqueFisheries: uniqueFisheries.size,
            uniqueFlotas: uniqueFlotas.size,
            obsAfectados,
            dotacionRef,
            coberturaPct,
            promedioDias,
            stats,
        };
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN: PORTADA
    // ─────────────────────────────────────────────────────────────

    private buildCoverPage(period: PeriodDescription): (Paragraph | Table)[] {
        return [
            // Espaciado superior
            ...Array(6).fill(null).map(() => new Paragraph({ children: [] })),
            // Institución
            this.centeredBold('INSTITUTO NACIONAL DE INVESTIGACIÓN', FONT_SIZES.coverSubtitle),
            this.centeredBold('Y DESARROLLO PESQUERO (INIDEP)', FONT_SIZES.coverSubtitle),
            new Paragraph({ children: [] }),
            this.centeredBold('PROGRAMA OBSERVADORES A BORDO', FONT_SIZES.coverSubtitle),
            new Paragraph({ children: [] }),
            new Paragraph({ children: [] }),
            // Título del informe
            this.centeredBold('INFORME DE EJECUCIÓN DE MAREAS', FONT_SIZES.coverTitle),
            new Paragraph({ children: [] }),
            // Período
            this.centered(period.short, FONT_SIZES.coverPeriod),
            new Paragraph({ children: [] }),
            this.centered(`(${period.range})`, FONT_SIZES.coverPeriod),
            // Espaciado inferior
            ...Array(4).fill(null).map(() => new Paragraph({ children: [] })),
            // Fecha y nota
            this.centeredItalic(`Mar del Plata, ${period.documentDate}`, FONT_SIZES.body),
            new Paragraph({ children: [] }),
            this.centeredItalic('Documento de circulación interna', FONT_SIZES.small),
            // Salto de página
            new Paragraph({ children: [new PageBreak()] }),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 1: INTRODUCCIÓN
    // ─────────────────────────────────────────────────────────────

    private buildIntroduction(
        period: PeriodDescription,
        includeCampaigns: boolean,
        hasPreviousYearMareas: boolean,
    ): (Paragraph | Table)[] {
        const paragraphs: Paragraph[] = [
            this.heading1('1. INTRODUCCIÓN'),
            this.bodyParagraph(generateIntroductionText(period, includeCampaigns)),
        ];

        const complement = generateIntroductionComplementText(period, hasPreviousYearMareas);
        if (complement) {
            paragraphs.push(this.bodyParagraph(complement));
        }

        return paragraphs;
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 2: RESUMEN EJECUTIVO
    // ─────────────────────────────────────────────────────────────

    private buildExecutiveSummary(
        period: PeriodDescription,
        processed: ReturnType<typeof this.preprocessData>,
        statusChart: Buffer,
    ): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias, totalEtapas } = processed;
        const finalizadas = processed.finalizadas.length;
        const enEjecucion = processed.enEjecucion.length;

        return [
            this.heading1('2. RESUMEN EJECUTIVO'),
            this.bodyParagraph('A continuación se presentan los indicadores clave de gestión del período:'),

            // KPIs
            createKpiTable([
                { value: obsAfectados, label: 'Observadores afectados' },
                { value: stats.totalMareas, label: 'Mareas registradas' },
                { value: formatNumber(stats.totalDaysNavigated), label: 'Días navegados' },
                { value: finalizadas, label: 'Mareas finalizadas' },
                { value: enEjecucion, label: 'Mareas en ejecución' },
                { value: totalEtapas, label: 'Etapas totales' },
                { value: `${coberturaPct}%`, label: 'Cobertura dotación' },
                { value: promedioDias, label: 'Promedio días/obs.' },
                { value: processed.uniqueFisheries, label: 'Pesquerías cubiertas' },
            ], 3),

            new Paragraph({ spacing: { before: SPACING.afterTable } }),

            // Texto interpretativo
            this.bodyParagraph(generateExecutiveSummaryText(
                period,
                obsAfectados,
                dotacionRef,
                coberturaPct,
                stats.totalDaysNavigated,
                stats.totalMareas,
                totalEtapas,
                processed.uniqueFisheries,
            )),

            // Gráfico de estado de mareas (800×600 → ratio 0.75)
            this.chartImage(statusChart, DOC_IMAGE_DIMENSIONS.pieWidthCm, 0.75),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 3: ESTADÍSTICAS POR PESQUERÍA
    // ─────────────────────────────────────────────────────────────

    private buildFisherySection(
        processed: ReturnType<typeof this.preprocessData>,
        daysChart: Buffer,
        countChart: Buffer,
    ): (Paragraph | Table)[] {
        const { fisheryRows, stats } = processed;

        const headers = ['Pesquería', 'Flota', 'Mareas', 'Etapas', 'Días Nav.', '% Días'];
        const rows = fisheryRows.map(r => [
            r.pesqueria,
            r.flota,
            String(r.mareas),
            String(r.etapas),
            formatNumber(r.dias),
            formatNumber(r.pctDias, 1) + '%',
        ]);
        const totals = {
            label: 'TOTAL',
            values: [
                `${processed.uniqueFlotas} flotas`,
                String(stats.totalMareas),
                String(processed.totalEtapas),
                formatNumber(stats.totalDaysNavigated),
                '100%',
            ],
        };

        return [
            this.heading1('3. ESTADÍSTICAS POR PESQUERÍA'),
            this.heading2('3.1 Distribución de mareas, etapas y días navegados'),
            this.bodyParagraph('La siguiente tabla presenta el desglose de la actividad por pesquería y tipo de flota:'),

            createFormattedTable(headers, rows, {
                alignments: [
                    AlignmentType.LEFT, AlignmentType.LEFT,
                    AlignmentType.CENTER, AlignmentType.CENTER,
                    AlignmentType.CENTER, AlignmentType.CENTER,
                ],
                totalsRow: totals,
            }),

            new Paragraph({ spacing: { before: SPACING.afterTable } }),

            this.bodyParagraph(generateFisheryAnalysisText(fisheryRows, stats.totalDaysNavigated)),

            this.chartImage(daysChart, DOC_IMAGE_DIMENSIONS.standardWidthCm),
            this.chartImage(countChart, DOC_IMAGE_DIMENSIONS.standardWidthCm),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 4: ESTADÍSTICAS DE PERSONAL
    // ─────────────────────────────────────────────────────────────

    private buildPersonnelSection(
        period: PeriodDescription,
        processed: ReturnType<typeof this.preprocessData>,
        observerChart: Buffer,
    ): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias } = processed;
        const observers = stats.observers;

        // Indicadores generales
        const maxObs = observers.length > 0 ? observers[0] : null;
        const minObs = observers.length > 0 ? observers[observers.length - 1] : null;

        const indicatorsText = `Durante ${period.article} se afectaron ${obsAfectados} observadores ` +
            `sobre una dotación de ${dotacionRef}, alcanzando una cobertura del ${coberturaPct}%. ` +
            `El promedio de días navegados por observador fue de ${promedioDias} días` +
            (maxObs && minObs ? `, con un rango que osciló entre ${minObs.days} día${minObs.days !== 1 ? 's' : ''} (mínimo) y ${maxObs.days} días (máximo).` : '.') +
            ` La dispersión refleja la diversidad de asignaciones según pesquería, tipo de buque y duración de las campañas.`;

        // Top 10 para descripción
        const top10Text = `El siguiente gráfico muestra los diez observadores con mayor cantidad ` +
            `de días navegados durante el período, junto con la línea de promedio general (${promedioDias} días):`;

        // Tabla completa de observadores
        const headers = ['Observador', 'Mareas', 'Días Nav.'];
        const rows = observers.map(o => [o.name, String(o.mareas), String(o.days)]);
        const totalDias = observers.reduce((sum, o) => sum + o.days, 0);
        const totals = {
            label: `TOTAL: ${obsAfectados} observadores`,
            values: ['', formatNumber(totalDias)],
        };

        const dotacionNoteText =
            `Nota: La dotación informada corresponde a todos los observadores que participaron en ` +
            `mareas durante el período analizado. Este listado puede incluir observadores que ` +
            `actualmente ya no forman parte del plantel activo, por razones tales como renuncia, ` +
            `jubilación u otras situaciones de egreso ocurridas con posterioridad al período informado.`;

        return [
            this.heading1('4. ESTADÍSTICAS DE PERSONAL'),
            this.heading2('4.1 Indicadores generales de dotación'),
            this.bodyParagraph(indicatorsText),
            new Paragraph({
                spacing: { after: SPACING.afterParagraph },
                alignment: AlignmentType.JUSTIFIED,
                children: [
                    new TextRun({
                        text: dotacionNoteText,
                        font: FONTS.primary,
                        size: FONT_SIZES.small,
                        italics: true,
                        color: INIDEP_COLORS.textMuted,
                    }),
                ],
            }),

            this.heading2('4.2 Ranking de observadores por días navegados'),
            this.bodyParagraph(top10Text),
            this.chartImage(observerChart, DOC_IMAGE_DIMENSIONS.standardWidthCm),

            this.heading2('4.3 Distribución completa de días navegados'),
            this.bodyParagraph('La tabla siguiente detalla la totalidad de los observadores afectados, ordenados por días navegados de mayor a menor:'),

            createFormattedTable(headers, rows, {
                alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER],
                columnWidths: [60, 20, 20],
                totalsRow: totals,
            }),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 5: DETALLE DE NAVEGACIÓN (FINALIZADAS)
    // ─────────────────────────────────────────────────────────────

    private buildNavigationDetail(
        processed: ReturnType<typeof this.preprocessData>,
    ): (Paragraph | Table)[] {
        const { finalizadas, stats } = processed;
        const enEjecucionCount = processed.enEjecucion.length;

        const introText = `Se detallan a continuación las ${finalizadas.length} mareas que alcanzaron ` +
            `estado "Finalizada" durante el período, agrupadas por pesquería.` +
            (enEjecucionCount > 0
                ? ` Las ${enEjecucionCount} mareas restantes se encontraban en estado "En ejecución" al cierre del período.`
                : '');

        // Ordenar por pesquería y luego por id_marea
        const sorted = [...finalizadas].sort((a, b) => {
            const p = a.pesqueria.localeCompare(b.pesqueria);
            if (p !== 0) return p;
            return this.sortMareaId(a.id_marea, b.id_marea);
        });

        const headers = ['Pesquería', 'Buque', 'Marea', 'Estado', 'Etapas', 'Días'];
        const rows = sorted.map(m => [
            m.pesqueria,
            m.buque,
            this.formatMareaShort(m.id_marea),
            'Finalizada',
            String(m.etapas),
            String(m.dias),
        ]);

        return [
            new Paragraph({ children: [new PageBreak()] }),
            this.heading1('5. DETALLE DE NAVEGACIÓN'),
            this.heading2('5.1 Mareas finalizadas en el período'),
            this.bodyParagraph(introText),

            createFormattedTable(headers, rows, {
                alignments: [
                    AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER,
                    AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER,
                ],
            }),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 6: MAREAS EN EJECUCIÓN
    // ─────────────────────────────────────────────────────────────

    private buildOngoingMareas(
        period: PeriodDescription,
        processed: ReturnType<typeof this.preprocessData>,
    ): (Paragraph | Table)[] {
        const { enEjecucion } = processed;

        if (enEjecucion.length === 0) {
            return [
                this.heading1('6. MAREAS EN EJECUCIÓN'),
                this.bodyParagraph('No se registraron mareas en ejecución al cierre del período.'),
            ];
        }

        // Fecha de cierre genérica
        const closeDateText = period.endDate
            ? this.formatClosingDate(new Date(period.endDate))
            : `31 de diciembre de ${period.year}`;

        const introText = `Al cierre del período (${closeDateText}), las siguientes ${enEjecucion.length} mareas se encontraban en curso:`;

        const sorted = [...enEjecucion].sort((a, b) => {
            const p = a.pesqueria.localeCompare(b.pesqueria);
            if (p !== 0) return p;
            return this.sortMareaId(a.id_marea, b.id_marea);
        });

        const headers = ['Pesquería', 'Buque', 'Marea', 'Estado', 'Etapas', 'Días'];
        const rows = sorted.map(m => [
            m.pesqueria,
            m.buque,
            this.formatMareaShort(m.id_marea),
            'En ejecución',
            String(m.etapas),
            String(m.dias),
        ]);

        return [
            this.heading1('6. MAREAS EN EJECUCIÓN'),
            this.bodyParagraph(introText),

            createFormattedTable(headers, rows, {
                alignments: [
                    AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER,
                    AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER,
                ],
            }),
        ];
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIÓN 7: OBSERVACIONES COMPLEMENTARIAS
    // ─────────────────────────────────────────────────────────────

    private buildComplementaryObservations(
        period: PeriodDescription,
        processed: ReturnType<typeof this.preprocessData>,
        includeCampaigns: boolean,
    ): (Paragraph | Table)[] {
        const observations = generateComplementaryObservations(
            period,
            processed.uniqueFisheries,
            processed.uniqueFlotas,
            processed.obsAfectados,
            processed.stats.observers,
            processed.stats.totalDaysNavigated,
            processed.hasPreviousYearMareas,
            includeCampaigns,
        );

        const children: Paragraph[] = [
            this.heading1('7. OBSERVACIONES COMPLEMENTARIAS'),
        ];

        for (const obs of observations) {
            children.push(
                new Paragraph({
                    spacing: { before: SPACING.beforeHeading / 2, after: SPACING.afterParagraph },
                    children: [
                        new TextRun({
                            text: `${obs.title}: `,
                            font: FONTS.primary,
                            size: FONT_SIZES.body,
                            bold: true,
                            color: INIDEP_COLORS.text,
                        }),
                        new TextRun({
                            text: obs.text,
                            font: FONTS.primary,
                            size: FONT_SIZES.body,
                            color: INIDEP_COLORS.text,
                        }),
                    ],
                }),
            );
        }

        return children;
    }

    // ─────────────────────────────────────────────────────────────
    // GENERACIÓN DE GRÁFICOS
    // ─────────────────────────────────────────────────────────────

    private async generateStatusChart(
        processed: ReturnType<typeof this.preprocessData>,
    ): Promise<Buffer> {
        return this.chartService.renderDoughnutChart(
            ['Finalizadas', 'En ejecución'],
            [processed.finalizadas.length, processed.enEjecucion.length],
            {
                title: 'Estado de mareas',
                colors: [CHART_COLORS.success, CHART_COLORS.sky],
            },
        );
    }

    private async generateFisheryDaysChart(
        processed: ReturnType<typeof this.preprocessData>,
    ): Promise<Buffer> {
        // Agrupar por pesquería
        const byFishery = new Map<string, number>();
        processed.fisheryRows.forEach(r => {
            byFishery.set(r.pesqueria, (byFishery.get(r.pesqueria) || 0) + r.dias);
        });

        const sorted = Array.from(byFishery.entries()).sort((a, b) => b[1] - a[1]);

        return this.chartService.renderBarChart(
            sorted.map(([name]) => name),
            [{ label: 'Días navegados', data: sorted.map(([, days]) => days) }],
            { title: 'Días navegados por pesquería', yAxisLabel: 'Días' },
        );
    }

    private async generateFisheryCountChart(
        processed: ReturnType<typeof this.preprocessData>,
    ): Promise<Buffer> {
        // Agrupar por pesquería
        const byFishery = new Map<string, { mareas: number; etapas: number }>();
        processed.fisheryRows.forEach(r => {
            const existing = byFishery.get(r.pesqueria) || { mareas: 0, etapas: 0 };
            existing.mareas += r.mareas;
            existing.etapas += r.etapas;
            byFishery.set(r.pesqueria, existing);
        });

        const sorted = Array.from(byFishery.entries()).sort((a, b) =>
            a[0].localeCompare(b[0]),
        );

        return this.chartService.renderBarChart(
            sorted.map(([name]) => name),
            [
                { label: 'Mareas', data: sorted.map(([, d]) => d.mareas) },
                { label: 'Etapas', data: sorted.map(([, d]) => d.etapas) },
            ],
            { title: 'Mareas y etapas por pesquería' },
        );
    }

    private async generateObserverChart(
        processed: ReturnType<typeof this.preprocessData>,
    ): Promise<Buffer> {
        const top10 = processed.stats.observers.slice(0, 10);

        return this.chartService.renderHorizontalBarChart(
            top10.map(o => o.name),
            top10.map(o => o.days),
            {
                title: 'Top 10 observadores por días navegados',
                avgLine: processed.promedioDias,
                barColor: CHART_COLORS.violet,
            },
        );
    }

    // ─────────────────────────────────────────────────────────────
    // HELPERS DE CONSTRUCCIÓN DE PÁRRAFOS
    // ─────────────────────────────────────────────────────────────

    private heading1(text: string): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading, after: SPACING.afterHeading },
            children: [
                new TextRun({
                    text,
                    font: FONTS.primary,
                    size: FONT_SIZES.heading1,
                    bold: true,
                    color: INIDEP_COLORS.primary,
                }),
            ],
        });
    }

    private heading2(text: string): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading / 1.5, after: SPACING.afterHeading },
            children: [
                new TextRun({
                    text,
                    font: FONTS.primary,
                    size: FONT_SIZES.heading2,
                    bold: true,
                    color: INIDEP_COLORS.text,
                }),
            ],
        });
    }

    private bodyParagraph(text: string): Paragraph {
        return new Paragraph({
            spacing: { after: SPACING.afterParagraph },
            alignment: AlignmentType.JUSTIFIED,
            children: [
                new TextRun({
                    text,
                    font: FONTS.primary,
                    size: FONT_SIZES.body,
                    color: INIDEP_COLORS.text,
                }),
            ],
        });
    }

    private centered(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
                new TextRun({ text, font: FONTS.primary, size, color: INIDEP_COLORS.text }),
            ],
        });
    }

    private centeredBold(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
                new TextRun({ text, font: FONTS.primary, size, bold: true, color: INIDEP_COLORS.text }),
            ],
        });
    }

    private centeredItalic(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
                new TextRun({ text, font: FONTS.primary, size, italics: true, color: INIDEP_COLORS.textMuted }),
            ],
        });
    }

    private chartImage(buffer: Buffer, widthCm: number, aspectRatio = 0.5): Paragraph {
        // docx v9: transformation espera píxeles (convierte internamente a EMUs × 9525)
        // 1 cm = 360000 EMUs / 9525 EMU/px ≈ 37.795 px a 96 DPI
        const CM_TO_PX = 360000 / 9525;
        const widthPx = Math.round(widthCm * CM_TO_PX);
        const heightPx = Math.round(widthPx * aspectRatio);

        return new Paragraph({
            alignment: AlignmentType.CENTER,
            spacing: { before: SPACING.beforeTable, after: SPACING.afterTable },
            children: [
                new ImageRun({
                    data: buffer,
                    transformation: {
                        width: widthPx,
                        height: heightPx,
                    },
                    type: 'png',
                }),
            ],
        });
    }

    // ─────────────────────────────────────────────────────────────
    // UTILIDADES
    // ─────────────────────────────────────────────────────────────

    /** Ordena IDs de marea con el formato MC-NRO-AÑO */
    private sortMareaId(a: string, b: string): number {
        const regex = /^([A-Z]+)-(\d+)-(\d+)$/;
        const matchA = a.match(regex);
        const matchB = b.match(regex);

        if (matchA && matchB) {
            const [, typeA, numA, yearA] = matchA;
            const [, typeB, numB, yearB] = matchB;
            if (typeA !== typeB) return typeB.localeCompare(typeA);
            if (yearA !== yearB) return yearA.localeCompare(yearB);
            return parseInt(numA) - parseInt(numB);
        }
        return a.localeCompare(b);
    }

    /** Formatea MC-5-2026 → 5/2026 */
    private formatMareaShort(idMarea: string): string {
        const regex = /^[A-Z]+-(\d+)-(\d+)$/;
        const match = idMarea.match(regex);
        if (match) {
            return `${match[1]}/${match[2]}`;
        }
        return idMarea;
    }

    /** Formatea fecha de cierre: "31 de marzo de 2026" */
    private formatClosingDate(date: Date): string {
        const months = [
            'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
            'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
        ];
        const day = date.getUTCDate();
        const month = months[date.getUTCMonth()];
        const year = date.getUTCFullYear();
        return `${day} de ${month} de ${year}`;
    }
}
