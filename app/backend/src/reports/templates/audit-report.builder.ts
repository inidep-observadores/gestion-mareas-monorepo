/**
 * Builder del informe de auditoría en formato .docx
 * 
 * Genera un documento Word profesional con 7 secciones basadas
 * en los datos de auditoría del Subprograma Observadores a Bordo (INIDEP).
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
    formatNumber,
    generateIntroductionText, generateIntroductionComplementText,
    generateExecutiveSummaryText, generateFisheryAnalysisText,
    generateComplementaryObservations,
} from '../docx/docx-text';

// ─── Tipos inline para el builder (desacoplados de stats interfaces) ───────────

interface AuditSpecialMareaItem {
    id: string;
    id_marea: string;
    buque: string;
    flota: string;
    pesqueria: string;
    observador: string;
    diasNavegados: number;
    fechaEvento: Date | string | null;
    motivo: string | null;
    tipoObservador: string | null;
    nroProtocolo?: string | null;
}

interface PersonalTypeBreakdownItem {
    dias: number;
    mareasFinalizadas: number;
    mareasEnEjecucion: number;
    desestimadas: number;
    informesDeMarea: number;
    informesProtocolizados: number;
    informesPendientes: number;
    esperandoEntrega: number;
    delegadasExternas: number;
}

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
        observers: Array<{
            id: string;
            name: string;
            mareas: number;
            days: number;
            active: boolean;
            tipoContrato?: string;
            tipoObservador?: string;
        }>;
    };

    /** Dotación activa de observadores */
    dotacionActiva: number;

    /** Observadores que participaron como secundarios en el período */
    secondaryStats: Array<{ observadorId: string; etapasComoSecundario: number }>;

    /** Mareas con estados especiales */
    specialCases: {
        canceladas: AuditSpecialMareaItem[];
        desestimadas: AuditSpecialMareaItem[];
        esperandoEntrega: AuditSpecialMareaItem[];
        pendientesDeInforme: AuditSpecialMareaItem[];
        delegadasExternas: AuditSpecialMareaItem[];
        informesPendientesEnvio: AuditSpecialMareaItem[];
        esperandoProtocolizacion: AuditSpecialMareaItem[];
        enviadasADNI?: AuditSpecialMareaItem[];
    };

    /** Timeline de protocolización */
    protocolizationTimeline: {
        totalProtocolizadas: number;
        totalEnviadas: number;
        totalEnPeriodo: number;
        sinProtocolizar: number;
        tipo: 'WEEKLY' | 'MONTHLY';
        promedioDiasLatencia: number | null;
        maxDiasLatencia: number | null;
        promedioDiasLatenciaTramite: number | null;
        maxDiasLatenciaTramite: number | null;
        distribucionMensual: Array<{
            periodo: number; label: string; cantidad: number;
            enviadas: number; acumulado: number; pctDelTotal: number;
        }>;
        protocolizadasDetalle: Array<{
            id: string;
            id_marea: string;
            buque: string;
            observador: string;
            nroProtocolizacion: number | null;
            anioProtocolizacion: number | null;
            fechaProtocolizacion: Date | string | null;
        }>;
    };

    /** Breakdown de actividad por tipo de observador */
    breakdown: {
        observadores: PersonalTypeBreakdownItem;
        tecnicos: PersonalTypeBreakdownItem;
    };

    /** Datos para el anexo anual comparativo */
    annexData?: {
        quarters: number[];
        fisheries: Record<string, number[]>; // FisheryName -> array of days mapped to quarters index
        activeFisheries: string[]; // List of all active fisheries in the year
        mareaStates: {
            finalizadas: number[];
            canceladas: number[];
        };
        protocolizationStates: {
            enEspera: number[];
            enviadas: number[];
            protocolizadas: number[];
        };
        finalizedDetails: Array<Array<{
            id: string;
            identificacion: string;
            derivada: boolean;
            enviada: boolean;
            protocolizada: boolean;
            orderPriority: number;
        }>>;
        annualFinalizedDetails?: Array<{
            id: string;
            identificacion: string;
            derivada: boolean;
            enviada: boolean;
            protocolizada: boolean;
            orderPriority: number;
        }>;
    };

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
        estadoActual?: string;
        observadorId?: string | null;
        estadoOrden?: number;
        diasCalendario: number;
        diasTotales: number;
        fechaInicio: Date | string;
        fechaFin: Date | string | null;
        fechaZarpada?: Date | string | null;
        fechaArribo?: Date | string | null;
        fechaDerivacion?: Date | string | null;
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

    /** Observadores de la dotación que no tuvieron actividad en el período */
    observadoresSinActividad: Array<{ id: string; name: string }>;

    /** Mapa de ordenamiento de pesquerías (nombre -> orden) */
    fisheryOrderMap?: Map<string, number>;
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
        const [statusChart, fisheryDaysChart, fisheryCountChart, observerChart, specialCasesChart, sigmaLogo] = await Promise.all([
            this.generateStatusChart(processed),
            this.generateFisheryDaysChart(processed),
            this.generateFisheryCountChart(processed),
            this.generateObserverChart(processed),
            this.generateSpecialCasesChart(data, processed.enEjecucion.length),
            this.chartService.renderSigmaLogo(120),
        ]);

        // Construir secciones del documento
        const children = [
            // Portada
            ...this.buildCoverPage(period, sigmaLogo, data),

            // Sección 1: Introducción
            ...this.buildIntroduction(period, data.includeCampaigns, processed.hasPreviousYearMareas),

            // Sección 2: Resumen Ejecutivo
            ...this.buildExecutiveSummary(period, processed, statusChart),

            // Sección 3: Estadísticas por Pesquería
            ...this.buildFisherySection(processed, fisheryDaysChart, fisheryCountChart),

            // Sección 4: Estadísticas de Personal
            ...this.buildPersonnelSection(period, processed, observerChart, data),

            // Sección 5: Detalle de Navegación (Finalizadas + Derivadas)
            ...this.buildNavigationDetail(processed, data),

            // Sección 6: Mareas en Ejecución
            ...this.buildOngoingMareas(period, processed),

            // Sección 7: Mareas con Estado Especial
            ...this.buildSpecialCasesSection(data, period, specialCasesChart),

            // Sección 8: Seguimiento de Protocolización
            ...this.buildProtocolizacionSection(data, period),

            // Sección 9: Observaciones Complementarias
            ...this.buildComplementaryObservations(period, processed, data.includeCampaigns),
        ];

        if (data.annexData) {
            children.push(
                new Paragraph({
                    pageBreakBefore: true,
                    spacing: { before: SPACING.beforeHeading, after: SPACING.afterHeading },
                    children: [
                        new TextRun({
                            text: 'ANEXO 1: COMPARATIVA ANUAL DE ESFUERZO POR PESQUERÍA Y RESUMEN DE ESTADO DE MAREAS',
                            bold: true,
                            size: FONT_SIZES.heading1,
                            color: INIDEP_COLORS.primary,
                        })
                    ]
                }),
                this.bodyParagraph('A continuación se detalla la cantidad de días navegados por cada pesquería que registró actividad durante el año en curso, desglosado por trimestre hasta el período seleccionado en este informe.'),
                ...this.buildAnnexTable(data.annexData)
            );
        }

        const doc = new Document({
            creator: 'SIGMA - Sistema Integral de Gestión de Mareas',
            title: `Informe de Ejecución de Mareas - ${period.short}`,
            description: `Informe de auditoría técnica del Subprograma Observadores a Bordo correspondiente a ${period.article}.`,
            subject: 'Auditoría de Mareas',
            lastModifiedBy: 'SIGMA Auto-generated',
            revision: 1,
            // Modo compatibilidad Office 2013+ (valor 15).
            compatabilityModeVersion: 15,
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
                paragraphStyles: [
                    {
                        id: "Header",
                        name: "Header",
                        run: {
                            font: "Arial",
                            size: 16,
                            color: INIDEP_COLORS.text,
                        },
                    },
                    {
                        id: "Footer",
                        name: "Footer",
                        run: {
                            font: "Arial",
                            size: 16,
                            color: INIDEP_COLORS.text,
                        },
                    },
                ],
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
                    first: new Header({ children: [new Paragraph({ children: [new TextRun("")] })] }),
                },
                footers: {
                    default: this.buildDocumentFooter(),
                    first: new Footer({ children: [new Paragraph({ children: [new TextRun("")] })] }),
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
                const ordA = data.fisheryOrderMap?.get(a.pesqueria.trim()) ?? 999;
                const ordB = data.fisheryOrderMap?.get(b.pesqueria.trim()) ?? 999;
                if (ordA !== ordB) return ordA - ordB;

                const p = a.pesqueria.localeCompare(b.pesqueria);
                return p !== 0 ? p : a.flota.localeCompare(b.flota);
            })
            .map(row => ({
                ...row,
                pctDias: stats.totalDaysNavigated > 0 ? (row.dias / stats.totalDaysNavigated) * 100 : 0,
            }));

        const obsAfectados = stats.observers.length;
        const dotacionRef = obsAfectados + (data.observadoresSinActividad?.length || 0);
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
            uniqueFlotas: Array.from(new Set(fisheryRows.map(r => r.flota))),
            obsAfectados,
            dotacionRef,
            coberturaPct,
            promedioDias,
            stats,
            fisheryOrderMap: data.fisheryOrderMap,
        };
    }

    // ─────────────────────────────────────────────────────────────
    // DISEÑO INSTITUCIONAL (HEADER/FOOTER/COVER)
    // ─────────────────────────────────────────────────────────────

    private buildCoverPage(period: PeriodDescription, sigmaLogo: Buffer, data: AuditReportData): (Paragraph | Table)[] {
        return [
            // Espaciado superior inicial
            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { before: 1440 }, // ~6 líneas
            }),
            this.centeredBold('PROGRAMA DE ADQUISICIÓN DE INFORMACIÓN BIOLÓGICO-PESQUERA', FONT_SIZES.coverSubtitle),
            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { after: 240 },
            }),
            this.centeredBold('SUBPROGRAMA OBSERVADORES', FONT_SIZES.coverSubtitle),

            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { before: 720 }, // ~3 líneas
            }),
            this.centeredBold('INFORME DE EJECUCIÓN DE MAREAS', FONT_SIZES.coverTitle),
            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { after: 240 },
            }),
            this.centered(period.short, FONT_SIZES.coverPeriod),
            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { after: 240 },
            }),
            this.centered(`(${period.range})`, FONT_SIZES.coverPeriod),

            ...(this.isPeriodOpen(data) ? [
                new Paragraph({
                    children: [new TextRun({ text: "\u200B" })],
                    spacing: { before: 240, after: 120 },
                }),
                new Paragraph({
                    alignment: AlignmentType.CENTER,
                    children: [
                        new TextRun({
                            text: `(Informe parcial con datos cerrados al ${this.getTodayFormatted()})`,
                            size: FONT_SIZES.body,
                            color: '555555'
                        })
                    ]
                })
            ] : []),

            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { before: 1920 }, // ~8 líneas
            }),
            this.centeredItalic(`Mar del Plata, ${period.documentDate}`, FONT_SIZES.body),
            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { after: 240 },
            }),
            this.centeredItalic('Documento de circulación interna', FONT_SIZES.small),

            new Paragraph({
                children: [new TextRun({ text: "\u200B" })],
                spacing: { before: 2400 }, // ~10 líneas
            }),

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
                                width: { size: 100, type: WidthType.PERCENTAGE },
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
                                            style: "Header",
                                            children: [
                                                new TextRun({
                                                    text: 'Subprograma Observadores a Bordo - INIDEP',
                                                    bold: false,
                                                    font: "Arial",
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
                                            style: "Header",
                                            children: [
                                                new TextRun({
                                                    text: `Informe de Ejecución de Mareas - ${period.short}`,
                                                    bold: false,
                                                    font: "Arial",
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
                new Paragraph({ children: [new TextRun("\u200B")] }),
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
                                            style: "Footer",
                                            spacing: { before: 100 },
                                            children: [
                                                new TextRun({
                                                    text: 'SIGMA - Sistema Integral de Gestión de Mareas',
                                                    font: "Arial",
                                                    size: 16,
                                                    color: INIDEP_COLORS.text,
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
                                            style: "Footer",
                                            spacing: { before: 100 },
                                            children: [
                                                new TextRun({ text: 'Página ', font: "Arial", size: 16, color: INIDEP_COLORS.text }),
                                                new TextRun({ children: [PageNumber.CURRENT], font: "Arial", size: 16, color: INIDEP_COLORS.text }),
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
                `${processed.uniqueFlotas.length} flotas`,
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
                    r.pesqueria, r.flota, r.mareas.toString(), r.etapas.toString(), r.dias.toString(), formatNumber(r.pctDias, 1) + '%',
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

    private buildPersonnelSection(period: PeriodDescription, processed: any, observerChart: Buffer, data: AuditReportData): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias } = processed;
        const observers = stats.observers;
        const maxObs = observers.length > 0 ? observers[0] : null;
        const minObs = observers.length > 0 ? observers[observers.length - 1] : null;

        const indicatorsText = `Durante ${period.article} se afectaron ${obsAfectados} observadores sobre una dotación de ${dotacionRef}, alcanzando una cobertura del ${coberturaPct}%. El promedio de días navegados por observador fue de ${promedioDias} días` +
            (maxObs && minObs ? `, con un rango que osciló entre ${minObs.days} día${minObs.days !== 1 ? 's' : ''} (mínimo) y ${maxObs.days} día${maxObs.days !== 1 ? 's' : ''} (máximo).` : '.') +
            ` La dispersión refleja la diversidad de asignaciones según pesquería, tipo de buque y duración de las campañas.`;

        const dotacionNoteText = `Nota: La dotación informada corresponde a todos los observadores que participaron en mareas durante el período analizado. Este listado puede incluir observadores que actualmente ya no forman parte del plantel activo, por razones tales como renuncia, jubilación u otras situaciones de egreso ocurridas con posterioridad al período informado.`;

        const { observadores: obs, tecnicos: tec } = data.breakdown;

        // Tabla de breakdown Observadores vs Técnicos
        const breakdownTable = createFormattedTable(
            ['', 'OBSERVADORES', 'TÉCNICOS'],
            [
                ['Días navegados', formatNumber(obs.dias), formatNumber(tec.dias)],
                ['Mareas finalizadas (Período)', obs.mareasFinalizadas.toString(), tec.mareasFinalizadas.toString()],
                ['  ↳ Pendientes de informe', obs.desestimadas.toString(), tec.desestimadas.toString()],
                ['  ↳ Esperando entrega obs.', obs.esperandoEntrega.toString(), tec.esperandoEntrega.toString()],
                ['  ↳ Delegadas externas', obs.delegadasExternas.toString(), tec.delegadasExternas.toString()],
                ['  ↳ Listas para envío a DNI', obs.informesPendientes.toString(), tec.informesPendientes.toString()],
                ['  ↳ Enviadas a DNI', obs.informesDeMarea.toString(), tec.informesDeMarea.toString()],
                ['Protocolizadas', obs.informesProtocolizados.toString(), tec.informesProtocolizados.toString()],
                ['Mareas en ejecución', obs.mareasEnEjecucion.toString(), tec.mareasEnEjecucion.toString()],
            ],
            {
                columnWidths: [55, 22, 23],
                alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER],
            },
        );

        const result: (Paragraph | Table)[] = [
            this.heading1('4. ESTADÍSTICAS DE PERSONAL'),
            this.heading2('4.1 Indicadores generales de dotación'),
            this.bodyParagraph(indicatorsText),
            new Paragraph({
                spacing: { after: SPACING.afterParagraph },
                alignment: AlignmentType.JUSTIFIED,
                children: [new TextRun({ text: dotacionNoteText, size: FONT_SIZES.small, italics: true, color: INIDEP_COLORS.textMuted })],
            }),
            breakdownTable,
            new Paragraph({ spacing: { before: SPACING.afterTable } }),
        ];

        // 4.2 Observadores secundarios (solo si hay datos)
        if (data.secondaryStats.length > 0) {
            const totalEtapasSecundario = data.secondaryStats.reduce((s, x) => s + x.etapasComoSecundario, 0);
            const secText = `Durante ${period.article} se registr${totalEtapasSecundario !== 1 ? 'aron' : 'ó'} ${totalEtapasSecundario} participación${totalEtapasSecundario !== 1 ? 'es' : ''} de observadores en calidad de secundarios, involucrando a ${data.secondaryStats.length} observador${data.secondaryStats.length !== 1 ? 'es' : ''} distinto${data.secondaryStats.length !== 1 ? 's' : ''}. La columna "Etapas Sec." de la tabla siguiente refleja dichas participaciones.`;
            result.push(
                this.heading2('4.2 Observadores secundarios'),
                this.bodyParagraph(secText),
            );
        }

        // Tabla de ranking y distribución agrupada por contrato
        const secondaryMap = new Map(data.secondaryStats.map(s => [s.observadorId, s.etapasComoSecundario]));
        const rankingNum = data.secondaryStats.length > 0 ? '4.3' : '4.2';
        const distNum = data.secondaryStats.length > 0 ? '4.4' : '4.3';
        const inactiveNum = data.secondaryStats.length > 0 ? '4.5' : '4.4';
        const hasSecundarios = data.secondaryStats.length > 0;

        result.push(
            this.heading2(`${rankingNum} Ranking de observadores por días navegados`),
            this.chartImage(observerChart, 14, 0.5),
            this.heading2(`${distNum} Distribución completa de días navegados`),
        );

        // Agrupar observadores por tipo de contrato
        const groups = stats.observers.reduce((acc: Record<string, any[]>, obs) => {
            const key = obs.tipoContrato || 'Otros / Sin especificar';
            if (!acc[key]) acc[key] = [];
            acc[key].push(obs);
            return acc;
        }, {});

        // Ordenar los grupos (ej: PLANTA primero, luego CONTRATO)
        const sortedGroupKeys = Object.keys(groups).sort((a, b) => {
            if (a.toLowerCase().includes('planta')) return -1;
            if (b.toLowerCase().includes('planta')) return 1;
            return a.localeCompare(b);
        });

        sortedGroupKeys.forEach((groupKey, idx) => {
            const groupObs = groups[groupKey];
            const groupTotalMareas = groupObs.reduce((sum, o) => sum + o.mareas, 0);
            const groupTotalDays = groupObs.reduce((sum, o) => sum + o.days, 0);
            const groupTotalSecundario = groupObs.reduce((sum, o) => sum + (secondaryMap.get(o.id) ?? 0), 0);

            result.push(
                this.heading3(`${distNum}.${idx + 1} Personal ${groupKey.toLowerCase()}`),
                createFormattedTable(
                    hasSecundarios
                        ? ['APELLIDO Y NOMBRE', 'MAREAS', 'DÍAS NAVEGADOS', 'ETAPAS SEC.']
                        : ['APELLIDO Y NOMBRE', 'MAREAS', 'DÍAS NAVEGADOS'],
                    groupObs.map((o: any) => {
                        const displayName = o.name + (o.tipoObservador === 'TECNICO' ? ' (Técnico)' : '');
                        return hasSecundarios
                            ? [displayName, o.mareas.toString(), o.days.toString(), (secondaryMap.get(o.id) ?? 0).toString()]
                            : [displayName, o.mareas.toString(), o.days.toString()];
                    }),
                    {
                        columnWidths: hasSecundarios ? [52, 16, 16, 16] : [60, 20, 20],
                        alignments: hasSecundarios
                            ? [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER]
                            : [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER],
                        totalsRow: {
                            label: `SUBTOTAL: ${groupObs.length} agente${groupObs.length !== 1 ? 's' : ''}`,
                            values: hasSecundarios
                                ? [groupTotalMareas.toString(), formatNumber(groupTotalDays), groupTotalSecundario.toString()]
                                : [groupTotalMareas.toString(), formatNumber(groupTotalDays)],
                        },
                    },
                ),
                new Paragraph({ spacing: { after: idx < sortedGroupKeys.length - 1 ? 200 : 0 } }),
            );
        });

        // 4.X Observadores sin actividad
        if (data.observadoresSinActividad && data.observadoresSinActividad.length > 0) {
            const inactive = data.observadoresSinActividad;
            const n = inactive.length;
            const inactiveText = n === 1
                ? `A continuación se lista el observador que, formando parte de la dotación activa en el período analizado, no registró participación en mareas (ni como observador principal ni secundario).`
                : `A continuación se listan los ${n} observadores que, formando parte de la dotación activa en el período analizado, no registraron participación en mareas (ni como observadores principales ni secundarios).`;

            result.push(
                this.heading2(`${inactiveNum} Observadores sin actividad`),
                this.bodyParagraph(inactiveText),
                createFormattedTable(
                    ['APELLIDO Y NOMBRES'],
                    inactive.map(o => [o.name]),
                    {
                        columnWidths: [100],
                        alignments: [AlignmentType.LEFT],
                    },
                ),
            );
        }

        return result;
    }

    private buildNavigationDetail(proc: any, data: AuditReportData): (Paragraph | Table)[] {
        const { finalizadas } = proc;
        const enEjecucionCount = proc.enEjecucion.length;
        const refText = this.getReferenceTimeText(data);
        const canceladasCount = data.specialCases.canceladas.length;
        let canceladasText = '';
        if (canceladasCount > 0) {
            canceladasText = ` No se incluy${canceladasCount === 1 ? 'ó' : 'eron'} en este recuento ${canceladasCount} marea${canceladasCount === 1 ? '' : 's'} cancelada${canceladasCount === 1 ? '' : 's'}, dado que no llegar${canceladasCount === 1 ? 'ó' : 'on'} a ejecutarse.`;
        }

        const introText = `Se detallan a continuación las ${finalizadas.length} mareas que alcanzaron estado "Finalizada" durante el período, agrupadas por pesquería.` +
            (enEjecucionCount > 0 ? ` Las ${enEjecucionCount} mareas restantes se encontraban en estado "En ejecución" ${refText}.` : '') +
            canceladasText;

        const sorted = [...finalizadas].sort((a, b) => {
            const ordA = data.fisheryOrderMap?.get(a.pesqueria.trim()) ?? 999;
            const ordB = data.fisheryOrderMap?.get(b.pesqueria.trim()) ?? 999;
            if (ordA !== ordB) return ordA - ordB;

            const p = a.pesqueria.localeCompare(b.pesqueria);
            if (p !== 0) return p;
            return this.sortMareaId(a.id_marea, b.id_marea);
        });

        const alignments = [
            AlignmentType.LEFT,
            AlignmentType.LEFT,
            AlignmentType.CENTER,
            AlignmentType.CENTER,
            AlignmentType.CENTER,
            AlignmentType.CENTER,
            AlignmentType.CENTER, // Nº Prot.
            AlignmentType.CENTER  // Fecha Prot.
        ];

        const result: (Paragraph | Table)[] = [
            this.heading1('5. DETALLE DE NAVEGACIÓN'),
            this.heading2('5.1 Mareas finalizadas en el período'),
            this.bodyParagraph(introText),
            createFormattedTable(
                ['PESQUERÍA', 'BUQUE', 'MAREA', 'ETAPAS', 'DÍAS', 'ENV. DNI', 'Nº PROT.', 'FECHA PROT.'],
                sorted.map((m: any) => ({
                    data: [
                        m.pesqueria,
                        m.buque,
                        this.formatMareaShort(m.id_marea),
                        m.etapas.toString(),
                        m.dias.toString(),
                        m.fechaEnvioProtocolizacion ? this.formatShortDate(m.fechaEnvioProtocolizacion) : '-',
                        (m.nroProtocolizacion != null && m.anioProtocolizacion != null) ? `${m.nroProtocolizacion}/${m.anioProtocolizacion}` : '-',
                        m.fechaProtocolizacion ? this.formatShortDate(m.fechaProtocolizacion) : '-',
                    ],
                    highlighted: m.estadoActual === 'DELEGADA_EXTERNA',
                })),
                {
                    columnWidths: [18, 20, 11, 8, 9, 11, 11, 12],
                    alignments,
                },
            ),
            new Paragraph({
                spacing: { before: 120, after: 200 },
                children: [
                    new TextRun({
                        text: '* Nota: Las mareas resaltadas son aquellas que se encuentran en espera de validación de datos por parte de programas científicos externos.',
                        italics: true,
                        size: FONT_SIZES.small,
                        color: INIDEP_COLORS.textMuted,
                    }),
                ],
            }),
        ];

        // 5.2 Mareas derivadas a programas científicos externos
        const delegadas = [...data.specialCases.delegadasExternas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
        if (delegadas.length > 0) {
            const n = delegadas.length;
            const delegadasText = `${n} marea${n !== 1 ? 's' : ''} registrada${n !== 1 ? 's' : ''} en el período se encuentra${n !== 1 ? 'n' : ''} derivada${n !== 1 ? 's' : ''} a programas científicos externos para validación de sus datos. La eventual demora en la confección del informe correspondiente es ajena al Subprograma Observadores a Bordo.`;
            result.push(
                this.heading2('5.2 Mareas derivadas a programas científicos externos'),
                this.bodyParagraph(delegadasText),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'FECHA DERIVACIÓN'],
                    delegadas.map(m => [
                        this.formatMareaShort(m.id_marea),
                        m.buque,
                        m.pesqueria,
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: [20, 30, 30, 20],
                        alignments: [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER],
                    },
                ),
            );
        }

        return result;
    }

    private getTodayFormatted(): string {
        const today = new Date();
        const y = today.getFullYear();
        const m = String(today.getMonth() + 1).padStart(2, '0');
        const d = String(today.getDate()).padStart(2, '0');
        return `${d}/${m}/${y}`;
    }

    private isPeriodOpen(data: { year: number, endDate?: string }): boolean {
        const today = new Date();
        const y = today.getFullYear();
        const m = String(today.getMonth() + 1).padStart(2, '0');
        const d = String(today.getDate()).padStart(2, '0');
        const todayStr = `${y}-${m}-${d}`;
        const limitDateStr = data.endDate ? data.endDate.substring(0, 10) : `${data.year}-12-31`;
        return todayStr < limitDateStr;
    }

    private getReferenceTimeText(data: { year: number, endDate?: string }): string {
        if (this.isPeriodOpen(data)) {
            return `al momento de elaborar este informe (${this.getTodayFormatted()})`;
        } else {
            const limitDate = data.endDate ? new Date(data.endDate) : new Date(Date.UTC(data.year, 11, 31));
            return `al cierre del período (${this.formatShortDate(limitDate)})`;
        }
    }

    private buildOngoingMareas(p: PeriodDescription, proc: any): (Paragraph | Table)[] {
        const { enEjecucion } = proc;
        const refText = this.getReferenceTimeText({ year: p.year, endDate: p.endDate });
        if (enEjecucion.length === 0) return [
            this.heading1('6. MAREAS EN EJECUCIÓN'),
            this.bodyParagraph(`No se registraron mareas en ejecución ${refText}.`)
        ];

        const refTextCap = refText.charAt(0).toUpperCase() + refText.slice(1);
        const introText = `${refTextCap}, las siguientes ${enEjecucion.length} mareas se encontraban en curso:`;

        const sorted = [...enEjecucion].sort((a, b) => {
            const ordA = proc.fisheryOrderMap?.get(a.pesqueria.trim()) ?? 999;
            const ordB = proc.fisheryOrderMap?.get(b.pesqueria.trim()) ?? 999;
            if (ordA !== ordB) return ordA - ordB;

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

    private buildSpecialCasesSection(data: AuditReportData, period: PeriodDescription, specialCasesChart?: Buffer): (Paragraph | Table)[] {
        const { canceladas, desestimadas, esperandoEntrega, pendientesDeInforme, informesPendientesEnvio, esperandoProtocolizacion } = data.specialCases;
        const allEmpty = canceladas.length === 0 && desestimadas.length === 0 &&
            esperandoEntrega.length === 0 && pendientesDeInforme.length === 0 &&
            informesPendientesEnvio.length === 0 && esperandoProtocolizacion.length === 0;

        const result: (Paragraph | Table)[] = [
            this.heading1('7. MAREAS SEGÚN ESTADO'),
        ];

        if (allEmpty) {
            result.push(this.bodyParagraph('No se registraron mareas con estados especiales en el período analizado.'));
            return result;
        }

        // Agregar gráfico de dona si existe
        if (specialCasesChart) {
            result.push(this.chartImage(specialCasesChart, 14, 0.75));
        }

        const specialTableCols = ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA'];
        const specialWidths = [16, 26, 24, 14, 20];
        const specialAligns = [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER];

        if (canceladas.length > 0) {
            const n = canceladas.length;
            const sortedCanceladas = [...canceladas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            result.push(
                this.heading2('7.1 Mareas canceladas'),
                this.bodyParagraph(`Se registr${n !== 1 ? 'aron' : 'ó'} ${n} marea${n !== 1 ? 's' : ''} planificada${n !== 1 ? 's' : ''} que no lleg${n !== 1 ? 'aron' : 'ó'} a ejecutarse en el período.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'FECHA CANC.', 'MOTIVO'],
                    sortedCanceladas.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                        m.motivo || '',
                    ]),
                    {
                        columnWidths: [14, 24, 20, 14, 28],
                        alignments: [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.LEFT]
                    },
                ),
            );
        }

        if (desestimadas.length > 0) {
            const n = desestimadas.length;
            const sortedDesestimadas = [...desestimadas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            result.push(
                this.heading2(`7.${canceladas.length > 0 ? 2 : 1} Mareas desestimadas`),
                this.bodyParagraph(`Se registr${n !== 1 ? 'aron' : 'ó'} ${n} marea${n !== 1 ? 's' : ''} ejecutada${n !== 1 ? 's' : ''} cuyos datos fueron descartados. El campo "Motivo" refleja la causa registrada al momento de la desestimación.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'MOTIVO'],
                    sortedDesestimadas.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.motivo || '',
                    ]),
                    {
                        columnWidths: [14, 24, 20, 12, 30],
                        alignments: [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.LEFT],
                    },
                ),
            );
        }

        if (esperandoEntrega.length > 0) {
            const n = esperandoEntrega.length;
            const sortedEsperando = [...esperandoEntrega].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const subsecNum = 1 + (canceladas.length > 0 ? 1 : 0) + (desestimadas.length > 0 ? 1 : 0);
            result.push(
                this.heading2(`7.${subsecNum} Mareas en espera de entrega de datos`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} finalizada${n !== 1 ? 's' : ''} est${n !== 1 ? 'án' : 'á'} en espera de que el observador asignado realice la entrega de los datos recolectados.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'OBSERVADOR', 'DÍAS NAV.', 'FECHA ARRIBO'],
                    sortedEsperando.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.observador,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: [14, 22, 18, 26, 12, 14],
                        alignments: [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER],
                    },
                ),
            );
        }

        if (pendientesDeInforme.length > 0) {
            const n = pendientesDeInforme.length;
            const sortedPendientes = [...pendientesDeInforme].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const subsecNum = 1 + (canceladas.length > 0 ? 1 : 0) + (desestimadas.length > 0 ? 1 : 0) + (esperandoEntrega.length > 0 ? 1 : 0);
            result.push(
                this.heading2(`7.${subsecNum} Mareas pendientes de informe`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} se encontraba${n !== 1 ? 'n' : ''} en alguna etapa de corrección de datos o confección del informe ${this.getReferenceTimeText(data)}, sin estar aún listas para protocolizar.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA REC.'],
                    sortedPendientes.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    { columnWidths: specialWidths, alignments: specialAligns },
                ),
            );
        }

        if (informesPendientesEnvio.length > 0) {
            const n = informesPendientesEnvio.length;
            const sortedPendientesEnvio = [...informesPendientesEnvio].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const subsecNum = 1 + (canceladas.length > 0 ? 1 : 0) + (desestimadas.length > 0 ? 1 : 0) + (esperandoEntrega.length > 0 ? 1 : 0) + (pendientesDeInforme.length > 0 ? 1 : 0);
            result.push(
                this.heading2(`7.${subsecNum} Informes pendientes de envío a DNI`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} cuenta${n !== 1 ? 'n' : ''} con su informe técnico finalizado ${this.getReferenceTimeText(data)}, pendiente${n !== 1 ? 's' : ''} de ser enviada${n !== 1 ? 's' : ''} formalmente a la Dirección Nacional de Investigación para su protocolización.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA FIN INF.'],
                    sortedPendientesEnvio.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    { columnWidths: specialWidths, alignments: specialAligns },
                ),
            );
        }

        if (esperandoProtocolizacion.length > 0) {
            // Dividir entre las que solo se enviaron y las que ya tienen nro de protocolo
            const soloEnviadas = esperandoProtocolizacion.filter(m => !m.nroProtocolo);
            const yaProtocolizadas = esperandoProtocolizacion.filter(m => !!m.nroProtocolo);

            let subsecNum = 1 + (canceladas.length > 0 ? 1 : 0) + (desestimadas.length > 0 ? 1 : 0) +
                (esperandoEntrega.length > 0 ? 1 : 0) + (pendientesDeInforme.length > 0 ? 1 : 0) +
                (informesPendientesEnvio.length > 0 ? 1 : 0);

            if (soloEnviadas.length > 0) {
                const n = soloEnviadas.length;
                const sortedSoloEnviadas = [...soloEnviadas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));

                result.push(
                    this.heading2(`7.${subsecNum} Mareas esperando protocolización`),
                    this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} fu${n !== 1 ? 'eron enviadas' : 'e enviada'} a la DNI y se encuentr${n !== 1 ? 'an aguardando' : 'a aguardando'} la asignación de su número de protocolo oficial.`),
                    createFormattedTable(
                        ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA ENVÍO'],
                        sortedSoloEnviadas.map(m => [
                            this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                            m.diasNavegados.toString(),
                            m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                        ]),
                        { columnWidths: specialWidths, alignments: specialAligns },
                    ),
                );
                subsecNum++;
            }

            if (yaProtocolizadas.length > 0) {
                const n = yaProtocolizadas.length;
                const sortedYaProt = [...yaProtocolizadas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));

                result.push(
                    this.heading2(`7.${subsecNum} Mareas ya protocolizadas`),
                    this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} complet${n !== 1 ? 'aron' : 'ó'} el circuito administrativo, obteniendo su correspondiente número de protocolo dentro del período analizado.`),
                    createFormattedTable(
                        ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'PROTOCOLO'],
                        sortedYaProt.map(m => [
                            this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                            m.diasNavegados.toString(),
                            m.nroProtocolo || '-',
                        ]),
                        { columnWidths: specialWidths, alignments: specialAligns },
                    ),
                );
            }
        }

        return result;
    }

    private buildProtocolizacionSection(data: AuditReportData, period: PeriodDescription): (Paragraph | Table)[] {
        const tl = data.protocolizationTimeline;
        const result: (Paragraph | Table)[] = [
            this.heading1('8. SEGUIMIENTO DE PROTOCOLIZACIÓN'),
        ];

        const totalFinalizadas = data.breakdown.observadores.mareasFinalizadas + data.breakdown.tecnicos.mareasFinalizadas;
        const totalListas = data.breakdown.observadores.informesPendientes + data.breakdown.tecnicos.informesPendientes;
        const totalEnviadas = data.breakdown.observadores.informesDeMarea + data.breakdown.tecnicos.informesDeMarea;
        const totalProtocolizadasL = data.breakdown.observadores.informesProtocolizados + data.breakdown.tecnicos.informesProtocolizados;

        const pctDeEnviadas = totalEnviadas > 0 ? Math.round((totalProtocolizadasL / totalEnviadas) * 100) : 0;
        const pctGestion = totalFinalizadas > 0 ? Math.round((totalEnviadas / totalFinalizadas) * 100) : 0;
        const pctListas = totalFinalizadas > 0 ? Math.round((totalListas / totalFinalizadas) * 100) : 0;

        let narrativa = '';
        if (totalFinalizadas === 1) {
            narrativa = 'De la marea que finalizó su operación en el período, ';
        } else {
            narrativa = `De las ${totalFinalizadas} mareas que finalizaron su operación en el período, `;
        }

        if (totalEnviadas === 1) {
            narrativa += `1 informe fue elevado a la DNI para su protocolización (${pctGestion}% de gestión)`;
        } else {
            narrativa += `${totalEnviadas} informes fueron elevados a la DNI para su protocolización (${pctGestion}% de gestión)`;
        }

        if (totalListas > 0) {
            if (totalListas === 1) {
                narrativa += `, mientras que 1 adicional se encuentra procesado y pendiente de envío (${pctListas}%)`;
            } else {
                narrativa += `, mientras que ${totalListas} adicionales se encuentran procesados y pendientes de envío (${pctListas}%)`;
            }
        }

        narrativa += '. ';
        if (totalProtocolizadasL === 1) {
            narrativa += `Del total de informes elevados, 1 ya ha sido efectivamente protocolizado (${pctDeEnviadas}% de efectividad de cierre).`;
        } else {
            narrativa += `Del total de informes elevados, ${totalProtocolizadasL} ya han sido efectivamente protocolizados (${pctDeEnviadas}% de efectividad de cierre).`;
        }
        if (tl.promedioDiasLatencia !== null) {
            narrativa += ` La latencia promedio entre la recepción de datos y la protocolización fue de ${Math.round(tl.promedioDiasLatencia)} días (máximo: ${tl.maxDiasLatencia} días).`;
            if (tl.promedioDiasLatenciaTramite !== null) {
                narrativa += ` El tiempo promedio entre el envío a la DNI y la obtención del número de protocolo fue de ${Math.round(tl.promedioDiasLatenciaTramite)} días (máximo: ${tl.maxDiasLatenciaTramite} días).`;
            }
        }
        result.push(this.bodyParagraph(narrativa));

        // Tabla mensual
        const activeRows = tl.distribucionMensual.filter(r => r.cantidad > 0 || r.enviadas > 0);
        if (activeRows.length > 0) {
            result.push(
                this.heading2('8.1 Distribución temporal'),
                createFormattedTable(
                    ['MES/SEMANA', 'ENVIADAS A DNI', 'PROTOCOLIZADAS', 'ACUMULADO', '% DEL TOTAL'],
                    activeRows.map(r => [
                        r.label,
                        r.enviadas.toString(),
                        r.cantidad.toString(),
                        r.acumulado.toString(),
                        `${r.pctDelTotal}%`,
                    ]),
                    {
                        columnWidths: [18, 20, 20, 18, 24],
                        alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                        totalsRow: {
                            label: 'TOTAL',
                            values: [
                                tl.totalEnviadas.toString(),
                                tl.totalProtocolizadas.toString(),
                                '',
                                tl.totalEnPeriodo > 0 ? '100%' : 'N/D',
                            ],
                        },
                    },
                ),
            );
        }

        // Nueva Tabla: Detalle de protocolizaciones
        if (tl.protocolizadasDetalle && tl.protocolizadasDetalle.length > 0) {
            result.push(
                this.heading2('8.2 Protocolizaciones durante el período'),
                this.bodyParagraph('A continuación se listan las mareas que obtuvieron su número de protocolo oficial dentro del período analizado:'),
                createFormattedTable(
                    ['PROTOCOLIZACIÓN', 'FECHA PROTOC.', 'MAREA', 'BUQUE', 'OBSERVADOR'],
                    tl.protocolizadasDetalle.map(m => [
                        (m.nroProtocolizacion && m.anioProtocolizacion) ? `${m.nroProtocolizacion}/${m.anioProtocolizacion}` : '-',
                        m.fechaProtocolizacion ? this.formatShortDate(m.fechaProtocolizacion) : '',
                        this.formatMareaShort(m.id_marea),
                        m.buque,
                        m.observador
                    ]),
                    {
                        columnWidths: [20, 16, 16, 23, 25],
                        alignments: [AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT],
                        totalsRow: {
                            label: 'TOTAL',
                            values: [
                                tl.protocolizadasDetalle.length.toString(),
                                '',
                                '',
                                '',
                            ],
                        },
                    },
                ),
            );
        } else if (activeRows.length === 0) {
            result.push(this.bodyParagraph('Sin actividad de protocolización registrada en el período.'));
        }

        return result;
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
        const children: (Paragraph | Table)[] = [this.heading1('9. OBSERVACIONES COMPLEMENTARIAS')];
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

    private buildAnnexTable(annexData: NonNullable<AuditReportData['annexData']>): (Paragraph | Table)[] {
        const result: (Paragraph | Table)[] = [];

        // 1. Tabla de Esfuerzo por Pesquería
        const headers = ['PESQUERÍA'];
        const numToOrdinal = ['Primer', 'Segundo', 'Tercer', 'Cuarto'];

        for (const q of annexData.quarters) {
            headers.push(`${numToOrdinal[q - 1]} trimestre`);
        }

        const rows = annexData.activeFisheries.map(fishery => {
            const daysArr = annexData.fisheries[fishery];
            const cols = [fishery.toUpperCase()];
            for (let i = 0; i < annexData.quarters.length; i++) {
                const days = daysArr[i];
                cols.push(days > 0 ? days.toString() : '-');
            }
            return cols;
        });

        const numCols = headers.length;
        const columnWidths = [40];
        const remainingWidth = Math.floor(60 / (numCols - 1));
        const alignments: any[] = [AlignmentType.LEFT];

        for (let i = 1; i < numCols; i++) {
            columnWidths.push(remainingWidth);
            alignments.push(AlignmentType.CENTER);
        }

        result.push(
            createFormattedTable(headers, rows, {
                columnWidths,
                alignments
            })
        );

        // 2. Tabla de Mareas según Estado
        if (annexData.mareaStates) {
            result.push(
                this.heading2('Recuento de mareas según estado por trimestre'),
                createFormattedTable(
                    ['Estado de marea', ...annexData.quarters.map(q => `${numToOrdinal[q - 1]} trimestre`)],
                    [
                        [
                            'FINALIZADAS',
                            ...annexData.mareaStates.finalizadas.map(val => val.toString())
                        ],
                        [
                            'CANCELADAS',
                            ...annexData.mareaStates.canceladas.map(val => val.toString())
                        ]
                    ],
                    {
                        columnWidths: [40, ...new Array(annexData.quarters.length).fill(remainingWidth)],
                        alignments: [AlignmentType.LEFT, ...new Array(annexData.quarters.length).fill(AlignmentType.CENTER)]
                    }
                )
            );
        }

        // 3. Tabla de Mareas según Estado de Protocolización
        if (annexData.protocolizationStates) {
            result.push(
                this.heading2('Recuento de mareas según estado de protocolización'),
                createFormattedTable(
                    ['Estado de marea', ...annexData.quarters.map(q => `${numToOrdinal[q - 1]} trimestre`)],
                    [
                        [
                            'EN ESPERA (PROGRAMAS EXTERNOS)',
                            ...annexData.protocolizationStates.enEspera.map(val => val.toString())
                        ],
                        [
                            'ENVIADAS A PROTOCOLIZAR',
                            ...annexData.protocolizationStates.enviadas.map(val => val.toString())
                        ],
                        [
                            'PROTOCOLIZADAS',
                            ...annexData.protocolizationStates.protocolizadas.map(val => val.toString())
                        ]
                    ],
                    {
                        columnWidths: [40, ...new Array(annexData.quarters.length).fill(remainingWidth)],
                        alignments: [AlignmentType.LEFT, ...new Array(annexData.quarters.length).fill(AlignmentType.CENTER)]
                    }
                )
            );
        }

        // 4. ANEXO 2: DETALLE DE PROTOCOLIZACIÓN TRIMESTRAL
        if (annexData.finalizedDetails) {
            result.push(
                new Paragraph({ children: [new PageBreak()] }),
                this.heading1('ANEXO 2: DETALLE DE PROTOCOLIZACIÓN TRIMESTRAL'),
                this.bodyParagraph('A continuación se detalla el estado de las mareas finalizadas durante cada trimestre, ordenadas según su avance en el proceso de protocolización.')
            );

            for (let q = 1; q <= annexData.quarters.length; q++) {
                const mareasTrimestre = annexData.finalizedDetails[q - 1];
                if (!mareasTrimestre) continue;

                result.push(
                    this.heading2(`Detalle de mareas finalizadas según estado – ${numToOrdinal[q - 1]} trimestre`)
                );

                if (mareasTrimestre.length === 0) {
                    result.push(
                        new Paragraph({
                            spacing: { after: SPACING.afterParagraph },
                            children: [
                                new TextRun({ text: 'Sin mareas finalizadas en este trimestre', italics: true, color: '666666' })
                            ],
                            alignment: AlignmentType.CENTER
                        })
                    );
                } else {
                    const detailHeaders = ['Marea', 'Derivada', 'Enviada', 'Protocolizada'];
                    const detailRows = mareasTrimestre.map(m => {
                        return {
                            data: [
                                m.identificacion,
                                m.derivada ? '✓' : '',
                                m.enviada ? '✓' : '',
                                m.protocolizada ? '✓' : ''
                            ],
                            highlighted: m.derivada
                        };
                    });

                    result.push(
                        createFormattedTable(
                            detailHeaders,
                            detailRows,
                            {
                                columnWidths: [55, 15, 15, 15],
                                alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER]
                            }
                        )
                    );
                }
            }
        }

        // 5. ANEXO 3: DETALLE DE PROTOCOLIZACIÓN ANUAL
        if (annexData.annualFinalizedDetails) {
            result.push(
                new Paragraph({ children: [new PageBreak()] }),
                this.heading1('ANEXO 3: DETALLE DE PROTOCOLIZACIÓN ANUAL'),
                this.bodyParagraph('A continuación se detalla el estado general de todas las mareas finalizadas en el año, ordenadas según su avance en el proceso de protocolización.'),
                this.heading2('Detalle de mareas finalizadas según estado – Resumen anual')
            );

            const mareasAnuales = annexData.annualFinalizedDetails;

            if (mareasAnuales.length === 0) {
                result.push(
                    new Paragraph({
                        spacing: { after: SPACING.afterParagraph },
                        children: [
                            new TextRun({ text: 'Sin mareas finalizadas en el año', italics: true, color: '666666' })
                        ],
                        alignment: AlignmentType.CENTER
                    })
                );
            } else {
                const detailHeaders = ['Marea', 'Derivada', 'Enviada', 'Protocolizada'];
                const detailRows = mareasAnuales.map(m => {
                    return {
                        data: [
                            m.identificacion,
                            m.derivada ? '✓' : '',
                            m.enviada ? '✓' : '',
                            m.protocolizada ? '✓' : ''
                        ],
                        highlighted: m.derivada
                    };
                });

                result.push(
                    createFormattedTable(
                        detailHeaders,
                        detailRows,
                        {
                            columnWidths: [55, 15, 15, 15],
                            alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER]
                        }
                    )
                );
            }
        }

        return result;
    }

    // ─────────────────────────────────────────────────────────────
    // GENERACIÓN DE GRÁFICOS
    // ─────────────────────────────────────────────────────────────

    private async generateStatusChart(proc: any): Promise<Buffer> {
        return this.chartService.renderDoughnutChart(
            ['Finalizadas', 'En ejecución'],
            [proc.finalizadas.length, proc.enEjecucion.length],
            {
                title: 'Estado de Mareas',
                colors: [CHART_COLORS.success, CHART_COLORS.sky],
                displayLabels: true
            }
        );
    }

    private async generateFisheryDaysChart(proc: any): Promise<Buffer> {
        const byF = new Map<string, number>();
        proc.fisheryRows.forEach((r: any) => byF.set(r.pesqueria, (byF.get(r.pesqueria) || 0) + r.dias));
        const sorted = Array.from(byF.entries()).sort((a, b) => {
            const ordA = proc.fisheryOrderMap?.get(a[0].trim()) ?? 999;
            const ordB = proc.fisheryOrderMap?.get(b[0].trim()) ?? 999;
            if (ordA !== ordB) return ordA - ordB;
            return a[0].localeCompare(b[0]);
        });
        return this.chartService.renderBarChart(
            sorted.map(([n]) => n),
            [{ label: 'Días', data: sorted.map(([, d]) => d) }],
            { title: 'Esfuerzo (Días) por Pesquería', displayLabels: true }
        );
    }

    private async generateFisheryCountChart(proc: any): Promise<Buffer> {
        const byF = new Map<string, any>();
        proc.fisheryRows.forEach((r: any) => {
            const e = byF.get(r.pesqueria) || { mareas: 0, etapas: 0 };
            e.mareas += r.mareas; e.etapas += r.etapas;
            byF.set(r.pesqueria, e);
        });
        const s = Array.from(byF.entries()).sort((a, b) => {
            const ordA = proc.fisheryOrderMap?.get(a[0].trim()) ?? 999;
            const ordB = proc.fisheryOrderMap?.get(b[0].trim()) ?? 999;
            if (ordA !== ordB) return ordA - ordB;
            return a[0].localeCompare(b[0]);
        });
        return this.chartService.renderBarChart(
            s.map(([n]) => n),
            [
                { label: 'Mareas', data: s.map(([, d]) => d.mareas) },
                { label: 'Etapas', data: s.map(([, d]) => d.etapas) }
            ],
            { title: 'Mareas y Etapas por Pesquería', displayLabels: true }
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
                barColor: CHART_COLORS.violet,
                displayLabels: true
            }
        );
    }

    private async generateSpecialCasesChart(data: AuditReportData, enEjecucionCount: number): Promise<Buffer> {
        const {
            canceladas,
            desestimadas,
            esperandoEntrega,
            pendientesDeInforme,
            delegadasExternas,
            informesPendientesEnvio,
            esperandoProtocolizacion,
            enviadasADNI,
        } = data.specialCases;

        const enviadasADNISolo = esperandoProtocolizacion.length;
        const protocolizadas = (enviadasADNI?.length || 0) - enviadasADNISolo;

        const counts = [
            enEjecucionCount,
            canceladas.length,
            desestimadas.length,
            esperandoEntrega.length,
            pendientesDeInforme.length,
            delegadasExternas.length,
            informesPendientesEnvio.length,
            enviadasADNISolo,
            protocolizadas > 0 ? protocolizadas : 0,
        ].filter(c => c > 0);

        const labels = [
            enEjecucionCount > 0 ? `En Ejecución (${enEjecucionCount})` : null,
            canceladas.length > 0 ? `Canceladas (${canceladas.length})` : null,
            desestimadas.length > 0 ? `Desestimadas (${desestimadas.length})` : null,
            esperandoEntrega.length > 0 ? `Esperando Entrega (${esperandoEntrega.length})` : null,
            pendientesDeInforme.length > 0 ? `Pendientes de Informe (${pendientesDeInforme.length})` : null,
            delegadasExternas.length > 0 ? `Delegadas Externas (${delegadasExternas.length})` : null,
            informesPendientesEnvio.length > 0 ? `Pendientes de Envío (${informesPendientesEnvio.length})` : null,
            enviadasADNISolo > 0 ? `Enviadas a DNI (${enviadasADNISolo})` : null,
            protocolizadas > 0 ? `Protocolizadas (${protocolizadas})` : null,
        ].filter((l): l is string => l !== null);

        return this.chartService.renderDoughnutChart(labels, counts, {
            title: 'MAREAS SEGÚN ESTADO',
            displayLabels: true
        });
    }

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

    private heading3(text: string): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading / 2, after: SPACING.afterHeading / 2 },
            children: [
                new TextRun({
                    text,
                    size: 22, // Un poco más pequeño que h2 (24)
                    bold: true,
                    color: INIDEP_COLORS.primary
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
        const regex = /^([A-Z]+)-(\d+)-(\d+)$/;
        const matchA = a.match(regex);
        const matchB = b.match(regex);

        if (matchA && matchB) {
            const [, typeA, numA, yearA] = matchA;
            const [, typeB, numB, yearB] = matchB;

            // 1. Año (Ascendente: 23, 24, 25...)
            if (yearA !== yearB) return yearA.localeCompare(yearB);
            // 2. Número (Ascendente: 1, 2, 3...)
            const nA = parseInt(numA);
            const nB = parseInt(numB);
            if (nA !== nB) return nA - nB;
            // 3. Tipo (Descendente: TAL, OBS, MB) para consistencia SIGMA
            return typeB.localeCompare(typeA);
        }

        return a.localeCompare(b);
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
