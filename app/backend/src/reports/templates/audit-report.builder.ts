/**
 * Builder del informe de auditoría en formato .docx
 * 
 * Genera un documento Word profesional con 7 secciones basadas
 * en los datos de auditoría del Programa Observadores a Bordo (INIDEP).
 */
import {
    Document, Packer, Paragraph, TextRun, AlignmentType, Table,
    PageBreak, ImageRun, Header, Footer, PageNumber,
    TableRow, TableCell, WidthType, BorderStyle, VerticalAlign,
} from 'docx';
import { Injectable } from '@nestjs/common';
import { INIDEP_COLORS, FONTS, FONT_SIZES, SPACING, CHART_COLORS } from '../docx/docx-styles';
import { createFormattedTable, createKpiTable } from '../docx/docx-tables';
import { DocxChartService } from '../docx/docx-charts';
import {
    PeriodDescription, describePeriod,
    formatNumber, formatPercentage,
    generateIntroductionText, generateIntroductionComplementText,
    generateExecutiveSummaryText, generateFisheryAnalysisText,
    generateComplementaryObservations,
} from '../docx/docx-text';

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
        fechaEnvioProtocolizacion?: Date | string | null;
        nroProtocolizacion?: number | null;
        anioProtocolizacion?: number | null;
        fechaProtocolizacion?: Date | string | null;
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

        // Generar gráficos y logo en paralelo
        const [statusChart, fisheryDaysChart, fisheryCountChart, observerChart, sigmaLogo] = await Promise.all([
            this.generateStatusChart(processed),
            this.generateFisheryDaysChart(processed),
            this.generateFisheryCountChart(processed),
            this.generateObserverChart(processed),
            this.chartService.renderSigmaLogo(120),
        ]);

        // Construir secciones del documento
        const children = [
            // Portada
            ...this.buildCoverPage(period, sigmaLogo),

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
            // Modo compatibilidad Office 2010+ (valor 14). Sin esto, Office 2013 y
            // anteriores pueden mostrar "el archivo fue creado en una versión más nueva"
            // o fallar al abrir el documento.
            compatabilityModeVersion: 14,
            styles: {
                default: {
                    document: {
                        run: {
                            font: FONTS.primary,
                            size: FONT_SIZES.body,
                            color: INIDEP_COLORS.text,
                        },
                    },
                },
            },
            sections: [{
                properties: {
                    titlePage: true,
                    page: {
                        margin: {
                            top: 1134,
                            bottom: 1134,
                            left: 1418,
                            right: 1134,
                        },
                    },
                },
                headers: {
                    default: this.buildDocumentHeader(period),
                },
                footers: {
                    default: this.buildDocumentFooter(),
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

        // Items procesados con etapas y días según modo (CALENDAR vs TOTAL)
        const items = detailItems.map(item => ({
            ...item,
            etapas: etapasPorMarea.get(item.id_marea) || 1,
            dias: mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales,
        }));

        const finalizadas = items.filter(m => m.estado === 'Finalizada');
        const enEjecucion = items.filter(m => m.estado !== 'Finalizada');
        const hasPreviousYearMareas = items.some(m => m.anioMarea < period.year);
        const totalEtapas = items.reduce((sum, m) => sum + m.etapas, 0);

        const fisheryFlotaMap = new Map<string, any>();
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
                pctDias: stats.totalDaysNavigated > 0 ? (row.dias / stats.totalDaysNavigated) * 100 : 0,
            }));

        const obsAfectados = stats.observers.length;
        const dotacionRef = Math.max(data.dotacionActiva, obsAfectados);
        const coberturaPct = dotacionRef > 0 ? Math.round((obsAfectados / dotacionRef) * 100) : 0;
        const promedioDias = obsAfectados > 0 ? Math.round(stats.totalDaysNavigated / obsAfectados) : 0;

        return {
            items,
            finalizadas,
            enEjecucion,
            hasPreviousYearMareas,
            totalEtapas,
            fisheryRows,
            uniqueFisheries: new Set(fisheryRows.map(r => r.pesqueria)).size,
            uniqueFlotas: new Set(fisheryRows.map(r => r.flota)).size,
            obsAfectados,
            dotacionRef,
            coberturaPct,
            promedioDias,
            stats,
        };
    }

    // ─────────────────────────────────────────────────────────────
    // DISEÑO INSTITUCIONAL (HEADER/FOOTER/COVER)
    // ─────────────────────────────────────────────────────────────

    private buildCoverPage(period: PeriodDescription, sigmaLogo: Buffer): (Paragraph | Table)[] {
        return [
            ...Array(6).fill(null).map(() => new Paragraph({ children: [] })),
            this.centeredBold('INSTITUTO NACIONAL DE INVESTIGACIÓN', FONT_SIZES.coverSubtitle),
            this.centeredBold('Y DESARROLLO PESQUERO (INIDEP)', FONT_SIZES.coverSubtitle),
            new Paragraph({ children: [] }),
            this.centeredBold('PROGRAMA OBSERVADORES A BORDO', FONT_SIZES.coverSubtitle),

            ...Array(3).fill(null).map(() => new Paragraph({ children: [] })),
            this.centeredBold('INFORME DE EJECUCIÓN DE MAREAS', FONT_SIZES.coverTitle),
            new Paragraph({ children: [] }),
            this.centered(period.short, FONT_SIZES.coverPeriod),
            new Paragraph({ children: [] }),
            this.centered(`(${period.range})`, FONT_SIZES.coverPeriod),

            ...Array(8).fill(null).map(() => new Paragraph({ children: [] })),
            this.centeredItalic(`Mar del Plata, ${period.documentDate}`, FONT_SIZES.body),
            new Paragraph({ children: [] }),
            this.centeredItalic('Documento de circulación interna', FONT_SIZES.small),

            ...Array(12).fill(null).map(() => new Paragraph({ children: [] })),

            new Table({
                width: { size: 100, type: WidthType.PERCENTAGE },
                borders: {
                    top: { style: BorderStyle.NONE }, bottom: { style: BorderStyle.NONE },
                    left: { style: BorderStyle.NONE }, right: { style: BorderStyle.NONE },
                    insideVertical: { style: BorderStyle.NONE },
                    insideHorizontal: { style: BorderStyle.NONE },
                },
                rows: [
                    new TableRow({
                        children: [
                            new TableCell({
                                verticalAlign: VerticalAlign.BOTTOM,
                                children: [
                                    new Paragraph({
                                        alignment: AlignmentType.CENTER,
                                        children: [
                                            new ImageRun({
                                                data: sigmaLogo,
                                                transformation: { width: 35, height: 35 },
                                                type: 'png',
                                            }),
                                        ],
                                    }),
                                    new Paragraph({
                                        alignment: AlignmentType.CENTER,
                                        children: [
                                            new TextRun({
                                                text: 'Generado por SIGMA',
                                                bold: true,
                                                size: 16,
                                                color: INIDEP_COLORS.primary,
                                            }),
                                        ],
                                    }),
                                    new Paragraph({
                                        alignment: AlignmentType.CENTER,
                                        children: [
                                            new TextRun({
                                                text: 'Sistema Integral de Gestión de Mareas',
                                                size: 14,
                                                color: INIDEP_COLORS.textMuted,
                                            }),
                                        ],
                                    }),
                                    new Paragraph({
                                        alignment: AlignmentType.CENTER,
                                        children: [
                                            new TextRun({
                                                text: '"Rigor científico en cada registro"',
                                                italics: true,
                                                size: 14,
                                                color: INIDEP_COLORS.textMuted,
                                            }),
                                        ],
                                    }),
                                ],
                            }),
                        ],
                    }),
                ],
            }),

            new Paragraph({ children: [new PageBreak()] }),
        ];
    }

    private buildDocumentHeader(period: PeriodDescription): Header {
        return new Header({
            children: [
                new Table({
                    width: { size: 100, type: WidthType.PERCENTAGE },
                    borders: {
                        top: { style: BorderStyle.NONE },
                        bottom: { style: BorderStyle.NONE }, // Quitamos borde de tabla para ponerlo en celdas
                        left: { style: BorderStyle.NONE },
                        right: { style: BorderStyle.NONE },
                        insideVertical: { style: BorderStyle.NONE },
                    },
                    rows: [
                        new TableRow({
                            children: [
                                new TableCell({
                                    width: { size: 50, type: WidthType.PERCENTAGE },
                                    borders: {
                                        bottom: { style: BorderStyle.SINGLE, size: 4, color: INIDEP_COLORS.primary },
                                        top: { style: BorderStyle.NONE }, left: { style: BorderStyle.NONE }, right: { style: BorderStyle.NONE },
                                    },
                                    children: [
                                        new Paragraph({
                                            alignment: AlignmentType.LEFT,
                                            children: [
                                                new TextRun({
                                                    text: 'Programa Observadores a Bordo - INIDEP',
                                                    bold: false,
                                                    color: INIDEP_COLORS.text,
                                                    size: 16,
                                                }),
                                            ],
                                        }),
                                    ],
                                    verticalAlign: VerticalAlign.BOTTOM,
                                }),
                                new TableCell({
                                    width: { size: 50, type: WidthType.PERCENTAGE },
                                    borders: {
                                        bottom: { style: BorderStyle.SINGLE, size: 4, color: INIDEP_COLORS.primary },
                                        top: { style: BorderStyle.NONE }, left: { style: BorderStyle.NONE }, right: { style: BorderStyle.NONE },
                                    },
                                    children: [
                                        new Paragraph({
                                            alignment: AlignmentType.RIGHT,
                                            children: [
                                                new TextRun({
                                                    text: `Informe de Ejecución de Mareas - ${period.short}`,
                                                    bold: false,
                                                    size: 16,
                                                    color: INIDEP_COLORS.text,
                                                }),
                                            ],
                                        }),
                                    ],
                                    verticalAlign: VerticalAlign.BOTTOM,
                                }),
                            ],
                        }),
                    ],
                }),
                new Paragraph({ children: [] }),
            ],
        });
    }

    private buildDocumentFooter(): Footer {
        return new Footer({
            children: [
                new Table({
                    width: { size: 100, type: WidthType.PERCENTAGE },
                    borders: {
                        top: { style: BorderStyle.NONE },
                        bottom: { style: BorderStyle.NONE },
                        left: { style: BorderStyle.NONE },
                        right: { style: BorderStyle.NONE },
                        insideHorizontal: { style: BorderStyle.NONE },
                        insideVertical: { style: BorderStyle.NONE },
                    },
                    rows: [
                        new TableRow({
                            children: [
                                new TableCell({
                                    width: { size: 50, type: WidthType.PERCENTAGE },
                                    borders: {
                                        top: { style: BorderStyle.SINGLE, size: 1, color: INIDEP_COLORS.tableBorder },
                                        bottom: { style: BorderStyle.NONE },
                                        left: { style: BorderStyle.NONE },
                                        right: { style: BorderStyle.NONE },
                                    },
                                    children: [
                                        new Paragraph({
                                            alignment: AlignmentType.LEFT,
                                            spacing: { before: 100 },
                                            children: [
                                                new TextRun({
                                                    text: 'SIGMA - Sistema Integral de Gestión de Mareas',
                                                    size: 16,
                                                    color: INIDEP_COLORS.textMuted,
                                                }),
                                            ],
                                        }),
                                    ],
                                }),
                                new TableCell({
                                    width: { size: 50, type: WidthType.PERCENTAGE },
                                    borders: {
                                        top: { style: BorderStyle.SINGLE, size: 1, color: INIDEP_COLORS.tableBorder },
                                        bottom: { style: BorderStyle.NONE },
                                        left: { style: BorderStyle.NONE },
                                        right: { style: BorderStyle.NONE },
                                    },
                                    children: [
                                        new Paragraph({
                                            alignment: AlignmentType.RIGHT,
                                            spacing: { before: 100 },
                                            children: [
                                                new TextRun({ text: 'Página ', size: 16, color: INIDEP_COLORS.textMuted }),
                                                new TextRun({ children: [PageNumber.CURRENT], size: 16, color: INIDEP_COLORS.textMuted }),
                                            ],
                                        }),
                                    ],
                                }),
                            ],
                        }),
                    ],
                }),
            ],
        });
    }

    // ─────────────────────────────────────────────────────────────
    // SECCIONES DE CONTENIDO (LÓGICA DE DOMINIO)
    // ─────────────────────────────────────────────────────────────

    private buildIntroduction(period: PeriodDescription, includeCampaigns: boolean, hasPrev: boolean): (Paragraph | Table)[] {
        const paragraphs: (Paragraph | Table)[] = [
            this.heading1('1. INTRODUCCIÓN'),
            this.bodyParagraph(generateIntroductionText(period, includeCampaigns)),
        ];
        const complement = generateIntroductionComplementText(period, hasPrev);
        if (complement) {
            paragraphs.push(this.bodyParagraph(complement));
        }
        return paragraphs;
    }

    private buildExecutiveSummary(period: PeriodDescription, processed: any, statusChart: Buffer): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias, totalEtapas } = processed;
        const finalizadas = processed.finalizadas.length;
        const enEjecucion = processed.enEjecucion.length;

        return [
            this.heading1('2. RESUMEN EJECUTIVO'),
            this.bodyParagraph('A continuación se presentan los indicadores clave de gestión del período:'),
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
            new Paragraph({ spacing: { before: SPACING.afterTable } }),
            this.chartImage(statusChart, 10, 0.75),
        ];
    }

    private buildFisherySection(processed: any, daysChart: Buffer, countChart: Buffer): (Paragraph | Table)[] {
        const { fisheryRows, stats } = processed;
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
            createFormattedTable(
                ['PESQUERÍA', 'FLOTA', 'MAREAS', 'ETAPAS', 'DÍAS', '% DÍAS'],
                fisheryRows.map((r: any) => [
                    r.pesqueria, r.flota, r.mareas.toString(), r.etapas.toString(), r.dias.toString(), formatPercentage(r.pctDias),
                ]),
                {
                    columnWidths: [25, 25, 12, 12, 13, 13],
                    alignments: [AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                    totalsRow: totals,
                },
            ),
            new Paragraph({ spacing: { before: SPACING.afterTable } }),
            this.bodyParagraph(generateFisheryAnalysisText(fisheryRows, stats.totalDaysNavigated)),
            this.chartImage(daysChart, 14, 0.5),
            this.chartImage(countChart, 14, 0.5),
        ];
    }

    private buildPersonnelSection(period: PeriodDescription, processed: any, observerChart: Buffer): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias } = processed;
        const observers = stats.observers;
        const maxObs = observers.length > 0 ? observers[0] : null;
        const minObs = observers.length > 0 ? observers[observers.length - 1] : null;

        const indicatorsText = `Durante ${period.article} se afectaron ${obsAfectados} observadores sobre una dotación de ${dotacionRef}, alcanzando una cobertura del ${coberturaPct}%. El promedio de días navegados por observador fue de ${promedioDias} días` +
            (maxObs && minObs ? `, con un rango que osciló entre ${minObs.days} día${minObs.days !== 1 ? 's' : ''} (mínimo) y ${maxObs.days} días (máximo).` : '.') +
            ` La dispersión refleja la diversidad de asignaciones según pesquería, tipo de buque y duración de las campañas.`;

        const dotacionNoteText = `Nota: La dotación informada corresponde a todos los observadores que participaron en mareas durante el período analizado. Este listado puede incluir observadores que actualmente ya no forman parte del plantel activo, por razones tales como renuncia, jubilación u otras situaciones de egreso ocurridas con posterioridad al período informado.`;

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
                        size: FONT_SIZES.small,
                        italics: true,
                        color: INIDEP_COLORS.textMuted
                    })
                ],
            }),
            this.heading2('4.2 Ranking de observadores por días navegados'),
            this.chartImage(observerChart, 14, 0.5),
            this.heading2('4.3 Distribución completa de días navegados'),
            createFormattedTable(
                ['OBSERVADOR', 'MAREAS', 'DÍAS NAVEGADOS'],
                stats.observers.map((o: any) => [o.name, o.mareas.toString(), o.days.toString()]),
                {
                    columnWidths: [60, 20, 20],
                    alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER],
                    totalsRow: { label: `TOTAL: ${obsAfectados} observadores`, values: ['', formatNumber(stats.totalDaysNavigated)] },
                },
            ),
        ];
    }

    private buildNavigationDetail(proc: any): (Paragraph | Table)[] {
        const { finalizadas } = proc;
        const enEjecucionCount = proc.enEjecucion.length;
        const introText = `Se detallan a continuación las ${finalizadas.length} mareas que alcanzaron estado "Finalizada" durante el período, agrupadas por pesquería.` +
            (enEjecucionCount > 0 ? ` Las ${enEjecucionCount} mareas restantes se encontraban en estado "En ejecución" al cierre del período.` : '');

        const sorted = [...finalizadas].sort((a, b) => {
            const p = a.pesqueria.localeCompare(b.pesqueria);
            if (p !== 0) return p;
            return this.sortMareaId(a.id_marea, b.id_marea);
        });

        return [
            new Paragraph({ children: [new PageBreak()] }),
            this.heading1('5. DETALLE DE NAVEGACIÓN'),
            this.heading2('5.1 Mareas finalizadas en el período'),
            this.bodyParagraph(introText),
            createFormattedTable(
                ['PESQUERÍA', 'BUQUE', 'MAREA', 'ETAPAS', 'DÍAS', 'ENV. DNI', 'PROTOCOLIZ.'],
                sorted.map((m: any) => [
                    m.pesqueria,
                    m.buque,
                    this.formatMareaShort(m.id_marea),
                    m.etapas.toString(),
                    m.dias.toString(),
                    m.fechaEnvioProtocolizacion ? this.formatShortDate(m.fechaEnvioProtocolizacion) : '',
                    this.formatProtocolizacionCell(m.nroProtocolizacion, m.anioProtocolizacion, m.fechaProtocolizacion),
                ]),
                {
                    columnWidths: [20, 22, 12, 10, 10, 13, 13],
                    alignments: [AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                },
            ),
        ];
    }

    private buildOngoingMareas(p: PeriodDescription, proc: any): (Paragraph | Table)[] {
        const { enEjecucion } = proc;
        if (enEjecucion.length === 0) return [
            this.heading1('6. MAREAS EN EJECUCIÓN'),
            this.bodyParagraph('No se registraron mareas en ejecución al cierre del período.')
        ];

        const closeDateText = p.endDate ? p.endDate : `31 de diciembre de ${p.year}`;
        const introText = `Al cierre del período (${closeDateText}), las siguientes ${enEjecucion.length} mareas se encontraban en curso:`;

        const sorted = [...enEjecucion].sort((a, b) => {
            const p = a.pesqueria.localeCompare(b.pesqueria);
            if (p !== 0) return p;
            return this.sortMareaId(a.id_marea, b.id_marea);
        });

        return [
            this.heading1('6. MAREAS EN EJECUCIÓN'),
            this.bodyParagraph(introText),
            createFormattedTable(
                ['PESQUERÍA', 'BUQUE', 'MAREA', 'ETAPAS', 'DÍAS'],
                sorted.map((m: any) => [m.pesqueria, m.buque, this.formatMareaShort(m.id_marea), m.etapas.toString(), m.dias.toString()]),
                {
                    columnWidths: [28, 28, 16, 14, 14],
                    alignments: [AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                },
            ),
        ];
    }

    private buildComplementaryObservations(p: PeriodDescription, proc: any, camp: boolean): (Paragraph | Table)[] {
        const obs = generateComplementaryObservations(
            p,
            proc.uniqueFisheries,
            proc.uniqueFlotas,
            proc.obsAfectados,
            proc.stats.observers,
            proc.stats.totalDaysNavigated,
            proc.hasPreviousYearMareas,
            camp,
        );
        const children: (Paragraph | Table)[] = [this.heading1('7. OBSERVACIONES COMPLEMENTARIAS')];
        for (const o of obs) {
            children.push(new Paragraph({
                spacing: { before: SPACING.beforeHeading / 2, after: SPACING.afterParagraph },
                children: [
                    new TextRun({ text: `${o.title}: `, bold: true }),
                    new TextRun({ text: o.text })
                ],
            }));
        }
        return children;
    }

    // ─────────────────────────────────────────────────────────────
    // GENERACIÓN DE GRÁFICOS
    // ─────────────────────────────────────────────────────────────

    private async generateStatusChart(proc: any): Promise<Buffer> {
        return this.chartService.renderDoughnutChart(
            ['Finalizadas', 'En ejecución'],
            [proc.finalizadas.length, proc.enEjecucion.length],
            { title: 'Estado de Mareas', colors: [CHART_COLORS.success, CHART_COLORS.sky] }
        );
    }

    private async generateFisheryDaysChart(proc: any): Promise<Buffer> {
        const byF = new Map<string, number>();
        proc.fisheryRows.forEach((r: any) => byF.set(r.pesqueria, (byF.get(r.pesqueria) || 0) + r.dias));
        const sorted = Array.from(byF.entries()).sort((a, b) => b[1] - a[1]);
        return this.chartService.renderBarChart(
            sorted.map(([n]) => n),
            [{ label: 'Días', data: sorted.map(([, d]) => d) }],
            { title: 'Esfuerzo (Días) por Pesquería' }
        );
    }

    private async generateFisheryCountChart(proc: any): Promise<Buffer> {
        const byF = new Map<string, any>();
        proc.fisheryRows.forEach((r: any) => {
            const e = byF.get(r.pesqueria) || { mareas: 0, etapas: 0 };
            e.mareas += r.mareas; e.etapas += r.etapas;
            byF.set(r.pesqueria, e);
        });
        const s = Array.from(byF.entries()).sort((a, b) => a[0].localeCompare(b[0]));
        return this.chartService.renderBarChart(
            s.map(([n]) => n),
            [
                { label: 'Mareas', data: s.map(([, d]) => d.mareas) },
                { label: 'Etapas', data: s.map(([, d]) => d.etapas) }
            ],
            { title: 'Mareas y Etapas por Pesquería' }
        );
    }

    private async generateObserverChart(proc: any): Promise<Buffer> {
        const top10 = proc.stats.observers.slice(0, 10);
        return this.chartService.renderHorizontalBarChart(
            top10.map((o: any) => o.name),
            top10.map((o: any) => o.days),
            {
                title: 'Top 10 Observadores con Mayor Actividad',
                avgLine: proc.promedioDias,
                barColor: CHART_COLORS.violet
            }
        );
    }

    // ─────────────────────────────────────────────────────────────
    // HELPERS DE ESTILO Y FORMATEO
    // ─────────────────────────────────────────────────────────────

    private heading1(text: string): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading, after: SPACING.afterHeading },
            children: [
                new TextRun({
                    text,
                    size: FONT_SIZES.heading1,
                    bold: true,
                    color: INIDEP_COLORS.primary
                })
            ]
        });
    }

    private heading2(text: string): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading / 1.5, after: SPACING.afterHeading },
            children: [
                new TextRun({
                    text,
                    size: FONT_SIZES.heading2,
                    bold: true,
                    color: INIDEP_COLORS.text
                })
            ]
        });
    }

    private bodyParagraph(text: string): Paragraph {
        return new Paragraph({
            spacing: { after: SPACING.afterParagraph },
            alignment: AlignmentType.JUSTIFIED,
            children: [new TextRun({ text, size: FONT_SIZES.body })]
        });
    }

    private centeredBold(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [new TextRun({ text, size, bold: true })]
        });
    }

    private centered(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [new TextRun({ text, size })]
        });
    }

    private centeredItalic(text: string, size: number): Paragraph {
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
                new TextRun({
                    text,
                    size,
                    italics: true,
                    color: INIDEP_COLORS.textMuted
                })
            ]
        });
    }

    private chartImage(buffer: Buffer, widthCm: number, aspectRatio = 0.5): Paragraph {
        const CM_TO_PX = 360000 / 9525;
        const w = Math.round(widthCm * CM_TO_PX);
        const h = Math.round(w * aspectRatio);
        return new Paragraph({
            alignment: AlignmentType.CENTER,
            children: [
                new ImageRun({
                    data: buffer,
                    transformation: { width: w, height: h },
                    type: 'png'
                })
            ]
        });
    }

    private sortMareaId(a: string, b: string): number {
        const partsA = a.split('-').map(Number);
        const partsB = b.split('-').map(Number);
        if (partsA[0] !== partsB[0]) return partsA[0] - partsB[0];
        return (partsA[1] || 0) - (partsB[1] || 0);
    }

    private formatMareaShort(id: string): string {
        return id.replace(/^MB-/, '');
    }

    private formatShortDate(date: Date | string): string {
        const d = date instanceof Date ? date : new Date(date);
        const day = String(d.getUTCDate()).padStart(2, '0');
        const month = String(d.getUTCMonth() + 1).padStart(2, '0');
        const year = d.getUTCFullYear();
        return `${day}/${month}/${year}`;
    }

    private formatProtocolizacionCell(
        nro?: number | null,
        anio?: number | null,
        fecha?: Date | string | null,
    ): string | string[] {
        const line1 = (nro != null && anio != null) ? `${nro}/${anio}` : '';
        const line2 = fecha ? this.formatShortDate(fecha) : '';
        if (!line1 && !line2) return '';
        if (line1 && line2) return [line1, line2];
        return line1 || line2;
    }
}
