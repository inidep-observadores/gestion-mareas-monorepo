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
            pesqueria: string;
            observador: string;
            diasNavegados: number;
            fechaFinalizacion: Date | string | null;
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
        /**
         * Categoría administrativa de la marea finalizada según su estado REAL al cierre del período
         * (reconstruido desde los movimientos hasta la fecha de corte). Null si no está finalizada.
         */
        categoriaCierre?: 'PROTOCOLIZADA' | 'ENVIADA' | 'DERIVADA' | 'REVISION' | null;
        /** Código de estado real al cierre (movimientos hasta la fecha de corte). Null si no está finalizada. */
        estadoCierre?: string | null;
        /** Fecha del movimiento que fijó el estado al cierre. */
        fechaEstadoCierre?: Date | string | null;
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

        const sumDays = (collection: any[], field: string = 'diasNavegados') => collection.reduce((sum, m) => sum + (m[field] || 0), 0);

        const { desestimadas, canceladas } = data.specialCases;

        // Fuente única: las mismas mareas (processed.finalizadas) y el mismo estado histórico al cierre
        // (categoriaCierre) que utiliza la tabla de la sección 4, para garantizar consistencia total.
        const porCategoria = (cat: string) => processed.finalizadas.filter((m: any) => m.categoriaCierre === cat);
        const catStats = (cat: string) => {
            const list = porCategoria(cat);
            return { count: list.length, days: sumDays(list, 'dias') };
        };

        const desgloseFinalizadas = {
            revision: catStats('REVISION'),
            derivadas: catStats('DERIVADA'),
            desestimadas: { count: desestimadas.length + canceladas.length, days: sumDays(desestimadas) + sumDays(canceladas) },
            esperandoProtocolizacion: catStats('ENVIADA'),
            protocolizadas: catStats('PROTOCOLIZADA'),
            enEjecucion: { count: processed.enEjecucion.length, days: sumDays(processed.enEjecucion, 'dias') }
        };

        const mareasGantt = processed.items.map((m: any) => ({
            start: new Date(m.fechaInicio),
            end: m.fechaFin ? new Date(m.fechaFin) : null,
            isFinalizada: m.estado === 'Finalizada',
            estimatedDays: m.diasEstimados || 45,
            estado: m.estadoActual || m.estado || 'Desconocido'
        }));

        const pStart = data.startDate ? new Date(data.startDate) : new Date(Date.UTC(data.year, 0, 1));
        const pEnd = data.endDate ? new Date(data.endDate) : new Date(Date.UTC(data.year, 11, 31, 23, 59, 59));

        // Generar gráficos y logo en paralelo
        const [statusChart, fisheryDaysChart, fisheryCountChart, observerChart, specialCasesChart, sigmaLogo, annexEffortChart, treeChart, ganttChart] = await Promise.all([
            this.generateStatusChart(processed),
            this.generateFisheryDaysChart(processed),
            this.generateFisheryCountChart(processed),
            this.generateObserverChart(processed),
            this.generateSpecialCasesChart(data, processed.enEjecucion.length),
            this.chartService.renderSigmaLogo(120),

            data.annexData ? this.generateAnnexEffortChart(data.annexData) : Promise.resolve(undefined),
            this.chartService.renderMareasTreeChart(
                {
                    count: desgloseFinalizadas.enEjecucion.count + desgloseFinalizadas.revision.count + desgloseFinalizadas.derivadas.count + desgloseFinalizadas.esperandoProtocolizacion.count + desgloseFinalizadas.protocolizadas.count,
                    days: desgloseFinalizadas.enEjecucion.days + desgloseFinalizadas.revision.days + desgloseFinalizadas.derivadas.days + desgloseFinalizadas.esperandoProtocolizacion.days + desgloseFinalizadas.protocolizadas.days
                },
                {
                    count: desgloseFinalizadas.revision.count + desgloseFinalizadas.derivadas.count + desgloseFinalizadas.esperandoProtocolizacion.count + desgloseFinalizadas.protocolizadas.count,
                    days: desgloseFinalizadas.revision.days + desgloseFinalizadas.derivadas.days + desgloseFinalizadas.esperandoProtocolizacion.days + desgloseFinalizadas.protocolizadas.days
                },
                desgloseFinalizadas
            ),
            this.chartService.renderMareasGanttChart(
                pStart,
                pEnd,
                mareasGantt
            ),
        ]);

        // Construir secciones del documento
        const children = [
            // Portada
            ...this.buildCoverPage(period, sigmaLogo, data),

            // Sección 1: Introducción
            ...this.buildIntroduction(period, data.includeCampaigns, processed.hasPreviousYearMareas),

            // Sección 2: Resumen Ejecutivo
            ...this.buildExecutiveSummary(period, processed, statusChart, treeChart, ganttChart),

            // Sección 3: Estadísticas por Pesquería
            ...this.buildFisherySection(processed, fisheryDaysChart, fisheryCountChart),

            // Sección 4: Comparativa entre mareas finalizadas y protocolizadas en el período
            ...this.buildComparativaSection(period, processed, data),

            // Sección 5: Detalle de Navegación (Finalizadas + Derivadas)
            ...this.buildNavigationDetail(processed, data),

            // Sección 6: Mareas Según Estado (incluye En Ejecución y Casos Especiales)
            ...this.buildSpecialCasesSection(data, period, processed, specialCasesChart),

            // Sección 7: Estadísticas de Personal
            ...this.buildPersonnelSection(period, processed, observerChart, data),

            // Sección 8: Observaciones Complementarias
            ...this.buildComplementaryObservations(period, processed, data.includeCampaigns),
        ];

        if (data.annexData) {
            children.push(
                new Paragraph({
                    pageBreakBefore: true,
                    spacing: { before: SPACING.beforeHeading, after: SPACING.afterHeading },
                    children: [
                        new TextRun({
                            text: 'ANEXO 1: COMPARATIVA ANUAL DE ESFUERZO POR PESQUERÍA',
                            bold: true,
                            size: FONT_SIZES.heading1,
                            color: INIDEP_COLORS.primary,
                        })
                    ]
                }),
                this.bodyParagraph('A continuación se detalla la cantidad de días navegados por cada pesquería que registró actividad durante el año en curso, desglosado por trimestre hasta el período seleccionado en este informe.'),
                ...this.buildAnnexSection(data.annexData, annexEffortChart)
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
                    mareasEnEjecucion: 0,
                    mareasFinalizadas: 0,
                    etapas: 0,
                    dias: 0,
                });
            }
            const row = fisheryFlotaMap.get(key)!;
            row.mareas++;
            if (item.estado === 'Finalizada') {
                row.mareasFinalizadas++;
            } else {
                row.mareasEnEjecucion++;
            }
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

    private buildExecutiveSummary(period: PeriodDescription, processed: any, statusChart: Buffer, treeChart: Buffer, ganttChart: Buffer): (Paragraph | Table)[] {
        const { stats, obsAfectados, dotacionRef, coberturaPct, promedioDias, totalEtapas } = processed;
        const finalizadas = processed.finalizadas.length;
        const enEjecucion = processed.enEjecucion.length;

        const ganttHeight = Math.max(300, processed.items.length * 12 + 120);

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

            this.heading2('2.1 DESGLOSE DE ESTADOS DE MAREAS'),
            this.bodyParagraph('Relación jerárquica y flujos entre los diferentes estados al cierre del período.'),
            this.chartImage(treeChart, 16, 850 / 1200),
            new Paragraph({ spacing: { before: SPACING.afterTable } }),

            this.heading2('2.2 LÍNEA DE TIEMPO DE EJECUCIÓN DE MAREAS'),
            this.bodyParagraph('Proyección temporal y continuidad de la actividad de los observadores respecto a la fecha de corte.'),
            this.chartImage(ganttChart, 16, ganttHeight / 1200),

            new Paragraph({ spacing: { before: SPACING.afterTable } }),
            this.heading3('Nota aclaratoria sobre plazos de procesamiento'),
            this.bodyParagraph('Para la correcta interpretación de la información expuesta, debe tenerse en cuenta que el reglamento interno del Programa establece un plazo de quince (15) días corridos para que los observadores realicen la entrega de datos y el informe correspondiente a la marea realizada. Asimismo, el Programa dispone de un plazo adicional de siete (7) días corridos para la evaluación, corrección de los datos y la confección del informe de marea.'),
            this.bodyParagraph('En consecuencia, aquellas mareas que hayan finalizado dentro de los veintidós (22) días previos a la fecha de corte del período en estudio, podrían encontrarse aún en fase de revisión, en estricto cumplimiento de los plazos reglamentarios mencionados.')
        ];
    }

    private buildFisherySection(processed: any, daysChart: Buffer, countChart: Buffer): (Paragraph | Table)[] {
        const { fisheryRows, stats } = processed;

        const totalEjecucion = processed.enEjecucion.length;
        const totalFinalizadas = processed.finalizadas.length;

        const totals = {
            label: 'TOTAL',
            values: [
                `${processed.uniqueFlotas.length} flotas`,
                totalEjecucion > 0 ? String(totalEjecucion) : '-',
                totalFinalizadas > 0 ? String(totalFinalizadas) : '-',
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
                ['PESQUERÍA', 'FLOTA', 'EN EJECUCIÓN', 'FINALIZADAS', 'ETAPAS', 'DÍAS', '% DÍAS'],
                fisheryRows.map((r: any) => [
                    r.pesqueria,
                    r.flota,
                    r.mareasEnEjecucion > 0 ? r.mareasEnEjecucion.toString() : '-',
                    r.mareasFinalizadas > 0 ? r.mareasFinalizadas.toString() : '-',
                    r.etapas.toString(),
                    r.dias.toString(),
                    formatNumber(r.pctDias, 1) + '%'
                ]),
                {
                    columnWidths: [22, 18, 13, 16, 10, 10, 11],
                    alignments: [AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                    totalsRow: totals,
                },
            ),
            new Paragraph({ spacing: { before: SPACING.afterTable } }),
            this.bodyParagraph(generateFisheryAnalysisText(fisheryRows, stats.totalDaysNavigated)),
            this.chartImage(daysChart, 14, 0.5),
            this.chartImage(countChart, 14, 0.5),
        ];
    }

    private buildComparativaSection(period: PeriodDescription, proc: any, data: AuditReportData): (Paragraph | Table)[] {
        const pEnd = period.endDate ? new Date(period.endDate) : new Date(Date.UTC(period.year, 11, 31, 23, 59, 59, 999));
        pEnd.setUTCHours(23, 59, 59, 999);

        const allMareas = [...proc.enEjecucion, ...proc.finalizadas];

        const mappedMareas = allMareas.map(m => {
            const esEnEjecucion = m.estado !== 'Finalizada';
            const esDesestimada = data.specialCases.desestimadas.some((d: any) => d.id === m.id);

            // Estado REAL al cierre del período (snapshot desde movimientos), no fechas lógicas ni estado actual
            const cat = esEnEjecucion ? null : m.categoriaCierre;
            const esDerivada = cat === 'DERIVADA';
            const isProtocolizadaPeriodo = cat === 'PROTOCOLIZADA';
            const isEnviadaPeriodo = cat === 'ENVIADA' || isProtocolizadaPeriodo;

            // Protocolizada con posterioridad al cierre (hasta 7 días): se informa la fecha como dato adicional
            // Inhabilitado temporalmente (seteado a 0). Restablecer a 7 cuando se requiera reactivar la búsqueda futura.
            const MAX_POST_CLOSURE_DAYS = 0;
            const fProt = m.fechaProtocolizacion ? new Date(m.fechaProtocolizacion) : null;
            let isProtocolizadaPost = false;
            if (cat === 'ENVIADA' && fProt) {
                const diffDays = (fProt.getTime() - pEnd.getTime()) / (1000 * 60 * 60 * 24);
                if (diffDays > 0 && diffDays <= MAX_POST_CLOSURE_DAYS) {
                    isProtocolizadaPost = true;
                }
            }

            const isEnRevision = cat === 'REVISION';

            let orderPriority = 0;
            if (esEnEjecucion) orderPriority = 1;
            else if (isProtocolizadaPeriodo) orderPriority = 5;
            else if (isEnviadaPeriodo) orderPriority = 4;
            else if (esDerivada) orderPriority = 3;
            else orderPriority = 2; // En revisión

            const colEnEjecucion = esEnEjecucion ? '✓' : '';
            const colEnRevision = isEnRevision ? '✓' : '';
            const colDerivada = esDerivada ? (m.pesqueria || '') : '';

            let colEnviada = '';
            if (isEnviadaPeriodo && !isProtocolizadaPeriodo) {
                colEnviada = esDesestimada ? 'Desestimada' : '✓';
            }

            let colProtocolizada = '';
            if (isProtocolizadaPeriodo) {
                colProtocolizada = '✓';
            } else if (isProtocolizadaPost && fProt) {
                colProtocolizada = `(${this.formatShortDate(fProt)})`;
            }

            return {
                m,
                orderPriority,
                row: [
                    this.formatMareaShort(m.id_marea),
                    colEnEjecucion,
                    colEnRevision,
                    colDerivada,
                    colEnviada,
                    colProtocolizada,
                    m.dias.toString()
                ],
                cols: { colEnEjecucion, colEnRevision, colDerivada, colEnviada, colProtocolizada }
            };
        });

        mappedMareas.sort((a, b) => {
            if (a.orderPriority !== b.orderPriority) return a.orderPriority - b.orderPriority;
            if (a.m.anioMarea !== b.m.anioMarea) return a.m.anioMarea - b.m.anioMarea;
            return this.sortMareaId(a.m.id_marea, b.m.id_marea);
        });

        let tEjecucion = 0;
        let tRevision = 0;
        let tDerivada = 0;
        let tEnviada = 0;
        let tProtocolizada = 0;
        let tDias = 0;

        const rows = mappedMareas.map(item => {
            if (item.cols.colEnEjecucion) tEjecucion++;
            if (item.cols.colEnRevision) tRevision++;
            if (item.cols.colDerivada) tDerivada++;
            if (item.cols.colEnviada) tEnviada++;
            if (item.cols.colProtocolizada === '✓') tProtocolizada++;
            tDias += item.m.dias;
            return item.row;
        });

        const result: (Paragraph | Table)[] = [
            this.heading1('4. COMPARATIVA ENTRE MAREAS FINALIZADAS Y PROTOCOLIZADAS EN EL PERÍODO'),
            this.bodyParagraph('A continuación se detalla el estado de las mareas gestionadas en el período, ordenadas por su estado operativo al cierre del mismo.'),
            createFormattedTable(
                ['MAREA', 'EN EJECUCIÓN', 'EN REVISIÓN', 'DERIVADA', 'ENVIADA', 'PROTOCOLIZADA', 'DÍAS'],
                rows,
                {
                    columnWidths: [16, 14, 14, 18, 14, 16, 8],
                    alignments: [
                        AlignmentType.CENTER,
                        AlignmentType.CENTER,
                        AlignmentType.CENTER,
                        AlignmentType.CENTER,
                        AlignmentType.CENTER,
                        AlignmentType.CENTER,
                        AlignmentType.CENTER
                    ],
                    totalsRow: {
                        label: 'TOTALES',
                        values: [
                            '',
                            tRevision.toString(),
                            tDerivada.toString(),
                            tEnviada.toString(),
                            tProtocolizada.toString(),
                            tDias.toString()
                        ]
                    }
                }
            ),
            new Paragraph({
                spacing: { before: 120, after: SPACING.afterTable },
                children: [
                    new TextRun({
                        text: '* Nota aclaratoria: Las mareas catalogadas como "En ejecución" aportan días efectivos de esfuerzo a las estadísticas de navegación del período. Sin embargo, dado que no han concluido su actividad operativa al momento del corte, no se contabilizan en los totales de mareas finalizadas ni integran los índices de revisión y protocolización.',
                        italics: true,
                        size: FONT_SIZES.small,
                        color: INIDEP_COLORS.textMuted,
                    }),
                ],
            }),
        ];


        return result;
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
            this.heading1('7. ESTADÍSTICAS DE PERSONAL'),
            this.heading2('7.1 Indicadores generales de dotación'),
            this.bodyParagraph(indicatorsText),
            new Paragraph({
                spacing: { after: SPACING.afterParagraph },
                alignment: AlignmentType.JUSTIFIED,
                children: [new TextRun({ text: dotacionNoteText, size: FONT_SIZES.small, italics: true, color: INIDEP_COLORS.textMuted })],
            }),
            // breakdownTable,
            // new Paragraph({ spacing: { before: SPACING.afterTable } }),
        ];

        // 5.2 Observadores secundarios (solo si hay datos)
        if (data.secondaryStats.length > 0) {
            const totalEtapasSecundario = data.secondaryStats.reduce((s, x) => s + x.etapasComoSecundario, 0);
            const secText = `Durante ${period.article} se registr${totalEtapasSecundario !== 1 ? 'aron' : 'ó'} ${totalEtapasSecundario} participación${totalEtapasSecundario !== 1 ? 'es' : ''} de observadores en calidad de secundarios, involucrando a ${data.secondaryStats.length} observador${data.secondaryStats.length !== 1 ? 'es' : ''} distinto${data.secondaryStats.length !== 1 ? 's' : ''}. La columna "Etapas Sec." de la tabla siguiente refleja dichas participaciones.`;
            result.push(
                this.heading2('7.2 Observadores secundarios'),
                this.bodyParagraph(secText),
            );
        }

        // Tabla de ranking y distribución agrupada por contrato
        const secondaryMap = new Map(data.secondaryStats.map(s => [s.observadorId, s.etapasComoSecundario]));
        const rankingNum = data.secondaryStats.length > 0 ? '7.3' : '7.2';
        const distNum = data.secondaryStats.length > 0 ? '7.4' : '7.3';
        const inactiveNum = data.secondaryStats.length > 0 ? '7.5' : '7.4';
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
            canceladasText = ` No se incluy${canceladasCount === 1 ? 'ó' : 'eron'} en este recuento ${canceladasCount} marea${canceladasCount === 1 ? '' : 's'} cancelada${canceladasCount === 1 ? '' : 's'}, dado que no lleg${canceladasCount === 1 ? 'ó' : 'aron'} a ejecutarse.`;
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

        const totalDias = sorted.reduce((sum, m) => sum + m.dias, 0);

        const pEnd = data.endDate ? new Date(data.endDate) : new Date(Date.UTC(data.year, 11, 31, 23, 59, 59, 999));
        pEnd.setUTCHours(23, 59, 59, 999);

        const sortedMap = sorted.map((m: any) => {
            let fEnvio = m.fechaEnvioProtocolizacion ? new Date(m.fechaEnvioProtocolizacion) : null;
            let fProt = m.fechaProtocolizacion ? new Date(m.fechaProtocolizacion) : null;
            
            if (fEnvio && fEnvio.getTime() > pEnd.getTime()) fEnvio = null;
            if (fProt && fProt.getTime() > pEnd.getTime()) fProt = null;

            return { m, fEnvio, fProt };
        });

        const countEnvDni = sortedMap.filter(item => item.fEnvio != null).length;
        const countProt = sortedMap.filter(item => item.fProt != null).length;

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
                sortedMap.map(({ m, fEnvio, fProt }) => {
                    const fEnvioStr = fEnvio ? this.formatShortDate(fEnvio).replace(/\d{4}$/, y => y.slice(-2)) : '-';
                    const fProtStr = fProt ? this.formatShortDate(fProt).replace(/\d{4}$/, y => y.slice(-2)) : '-';
                    const protNumStr = (fProt && m.nroProtocolizacion != null && m.anioProtocolizacion != null) ? `${m.nroProtocolizacion}/${String(m.anioProtocolizacion).slice(-2)}` : '-';

                    return {
                        data: [
                            m.pesqueria,
                            m.buque,
                            this.formatMareaShort(m.id_marea),
                            m.etapas.toString(),
                            m.dias.toString(),
                            fEnvioStr,
                            protNumStr,
                            fProtStr,
                        ],
                        highlighted: m.estadoActual === 'DELEGADA_EXTERNA',
                    };
                }),
                {
                    columnWidths: [18, 20, 11, 8, 9, 11, 11, 12],
                    alignments,
                    totalsRow: {
                        label: 'TOTALES',
                        values: ['', sorted.length.toString(), '', totalDias.toString(), countEnvDni.toString(), countProt.toString(), '']
                    }
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
                        totalsRow: { label: `Total: ${delegadas.length} marea${delegadas.length !== 1 ? 's' : ''}` }
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

    private buildOngoingMareas(p: PeriodDescription, proc: any, subsecNum: number): (Paragraph | Table)[] {
        const { enEjecucion } = proc;
        const refText = this.getReferenceTimeText({ year: p.year, endDate: p.endDate });
        if (enEjecucion.length === 0) return [
            this.heading2(`6.${subsecNum} Mareas en ejecución`),
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

        const totalDias = sorted.reduce((sum, m) => sum + m.dias, 0);

        return [
            this.heading2(`6.${subsecNum} Mareas en ejecución`),
            this.bodyParagraph(introText),
            createFormattedTable(
                ['PESQUERÍA', 'BUQUE', 'MAREA', 'ETAPAS', 'DÍAS'],
                sorted.map((m: any) => [m.pesqueria, m.buque, this.formatMareaShort(m.id_marea), m.etapas.toString(), m.dias.toString()]),
                {
                    columnWidths: [28, 28, 16, 14, 14],
                    alignments: [AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                    totalsRow: {
                        label: `Total: ${sorted.length} marea${sorted.length !== 1 ? 's' : ''}`,
                        values: ['', '', '', totalDias.toString()]
                    }
                },
            ),
        ];
    }

    private buildSpecialCasesSection(data: AuditReportData, period: PeriodDescription, proc: any, specialCasesChart?: Buffer): (Paragraph | Table)[] {
        const { canceladas, desestimadas } = data.specialCases;

        // Fuente única: mismas mareas finalizadas y mismo estado real al cierre que el resto del informe.
        // Se adapta cada ítem al formato de las tablas (días = campo 'dias', consistente con las secciones 4 y 5).
        const toRow = (m: any, fechaEvento: Date | string | null | undefined) => ({
            ...m,
            diasNavegados: m.dias || 0,
            fechaEvento: fechaEvento ?? null,
        });
        const porEstado = (codigos: string[], fecha: (m: any) => Date | string | null | undefined) =>
            proc.finalizadas.filter((m: any) => codigos.includes(m.estadoCierre)).map((m: any) => toRow(m, fecha(m)));

        const fechaCierre = (m: any) => m.fechaEstadoCierre;
        const esperandoEntrega = porEstado(['ESPERANDO_ENTREGA'], fechaCierre);
        const informesPendientesEnvio = porEstado(['PARA_PROTOCOLIZAR'], fechaCierre);
        const esperandoProtocolizacion = porEstado(['ESPERANDO_PROTOCOLIZACION'], (m: any) => m.fechaEnvioProtocolizacion ?? m.fechaEstadoCierre);
        const delegadasExternas = porEstado(['DELEGADA_EXTERNA'], (m: any) => m.fechaDerivacion ?? m.fechaEstadoCierre);
        const protocolizadasFiltradas = porEstado(['PROTOCOLIZADA'], fechaCierre);
        const estadosConocidos = ['ESPERANDO_ENTREGA', 'PARA_PROTOCOLIZAR', 'ESPERANDO_PROTOCOLIZACION', 'DELEGADA_EXTERNA', 'PROTOCOLIZADA'];
        const pendientesDeInforme = proc.finalizadas
            .filter((m: any) => !estadosConocidos.includes(m.estadoCierre))
            .map((m: any) => toRow(m, fechaCierre(m)));

        const allEmpty = proc.enEjecucion.length === 0 &&
            canceladas.length === 0 && desestimadas.length === 0 &&
            esperandoEntrega.length === 0 && pendientesDeInforme.length === 0 &&
            informesPendientesEnvio.length === 0 && esperandoProtocolizacion.length === 0 &&
            delegadasExternas.length === 0 && protocolizadasFiltradas.length === 0;

        const result: (Paragraph | Table)[] = [
            this.heading1('6. MAREAS SEGÚN ESTADO'),
        ];

        if (allEmpty) {
            result.push(this.bodyParagraph('No se registraron mareas en ejecución ni con estados especiales en el período analizado.'));
            return result;
        }

        // Agregar gráfico de dona si existe (Oculto a petición del usuario)
        if (specialCasesChart) {
            // result.push(this.chartImage(specialCasesChart, 14, 0.75));
        }

        let subsecNum = 1;

        if (proc.enEjecucion.length > 0) {
            result.push(...this.buildOngoingMareas(period, proc, subsecNum));
            subsecNum++;
        }

        const specialTableCols = ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA'];
        const specialWidths = [16, 26, 24, 14, 20];
        const specialAligns = [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER];

        if (canceladas.length > 0) {
            const n = canceladas.length;
            const sortedCanceladas = [...canceladas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            result.push(
                this.heading2(`6.${subsecNum} Mareas canceladas`),
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
                        alignments: [AlignmentType.CENTER, AlignmentType.LEFT, AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.LEFT],
                        totalsRow: { label: `Total: ${sortedCanceladas.length} marea${sortedCanceladas.length !== 1 ? 's' : ''}` }
                    },
                ),
            );
            subsecNum++;
        }

        if (desestimadas.length > 0) {
            const n = desestimadas.length;
            const sortedDesestimadas = [...desestimadas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedDesestimadas.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);
            result.push(
                this.heading2(`6.${subsecNum} Mareas desestimadas`),
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
                        totalsRow: {
                            label: `Total: ${sortedDesestimadas.length} marea${sortedDesestimadas.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (esperandoEntrega.length > 0) {
            const n = esperandoEntrega.length;
            const sortedEsperando = [...esperandoEntrega].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedEsperando.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);
            result.push(
                this.heading2(`6.${subsecNum} Mareas en espera de entrega de datos`),
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
                        totalsRow: {
                            label: `Total: ${sortedEsperando.length} marea${sortedEsperando.length !== 1 ? 's' : ''}`,
                            values: ['', '', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (pendientesDeInforme.length > 0) {
            const n = pendientesDeInforme.length;
            const sortedPendientes = [...pendientesDeInforme].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedPendientes.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);
            result.push(
                this.heading2(`6.${subsecNum} Mareas pendientes de informe`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} se encontraba${n !== 1 ? 'n' : ''} en alguna etapa de corrección de datos o confección del informe ${this.getReferenceTimeText(data)}, sin estar aún listas para protocolizar.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA REC.'],
                    sortedPendientes.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: specialWidths,
                        alignments: specialAligns,
                        totalsRow: {
                            label: `Total: ${sortedPendientes.length} marea${sortedPendientes.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (informesPendientesEnvio.length > 0) {
            const n = informesPendientesEnvio.length;
            const sortedPendientesEnvio = [...informesPendientesEnvio].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedPendientesEnvio.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);
            result.push(
                this.heading2(`6.${subsecNum} Informes pendientes de envío a DNI`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} cuenta${n !== 1 ? 'n' : ''} con su informe técnico finalizado ${this.getReferenceTimeText(data)}, pendiente${n !== 1 ? 's' : ''} de ser enviada${n !== 1 ? 's' : ''} formalmente a la Dirección Nacional de Investigación para su protocolización.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA FIN INF.'],
                    sortedPendientesEnvio.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: specialWidths,
                        alignments: specialAligns,
                        totalsRow: {
                            label: `Total: ${sortedPendientesEnvio.length} marea${sortedPendientesEnvio.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (esperandoProtocolizacion.length > 0) {
            const n = esperandoProtocolizacion.length;
            const sortedSoloEnviadas = [...esperandoProtocolizacion].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedSoloEnviadas.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);

            result.push(
                this.heading2(`6.${subsecNum} Mareas esperando protocolización`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} fu${n !== 1 ? 'eron enviadas' : 'e enviada'} a la DNI y se encuentr${n !== 1 ? 'an aguardando' : 'a aguardando'} la asignación de su número de protocolo oficial.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA ENVÍO'],
                    sortedSoloEnviadas.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: specialWidths,
                        alignments: specialAligns,
                        totalsRow: {
                            label: `Total: ${sortedSoloEnviadas.length} marea${sortedSoloEnviadas.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (protocolizadasFiltradas.length > 0) {
            const n = protocolizadasFiltradas.length;
            const sortedProt = [...protocolizadasFiltradas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedProt.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);

            result.push(
                this.heading2(`6.${subsecNum} Mareas protocolizadas`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} complet${n !== 1 ? 'aron' : 'ó'} el circuito administrativo, obteniendo su correspondiente número de protocolo dentro del período analizado.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA PROTOCOLIZACIÓN'],
                    sortedProt.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaProtocolizacion ? this.formatShortDate(m.fechaProtocolizacion) : '-',
                    ]),
                    {
                        columnWidths: specialWidths,
                        alignments: specialAligns,
                        totalsRow: {
                            label: `Total: ${sortedProt.length} marea${sortedProt.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (delegadasExternas && delegadasExternas.length > 0) {
            const n = delegadasExternas.length;
            const sortedDelegadas = [...delegadasExternas].sort((a, b) => this.sortMareaId(a.id_marea, b.id_marea));
            const totalDias = sortedDelegadas.reduce((sum, m) => sum + (m.diasNavegados || 0), 0);

            result.push(
                this.heading2(`6.${subsecNum} Mareas delegadas a programas externos`),
                this.bodyParagraph(`${n} marea${n !== 1 ? 's' : ''} finalizada${n !== 1 ? 's' : ''} en el período se encontraba${n !== 1 ? 'n' : ''} derivada${n !== 1 ? 's' : ''} a programas científicos externos para validación de datos al momento del cierre.`),
                createFormattedTable(
                    ['MAREA', 'BUQUE', 'PESQUERÍA', 'DÍAS NAV.', 'FECHA DERIVACIÓN'],
                    sortedDelegadas.map(m => [
                        this.formatMareaShort(m.id_marea), m.buque, m.pesqueria,
                        m.diasNavegados.toString(),
                        m.fechaEvento ? this.formatShortDate(m.fechaEvento) : '',
                    ]),
                    {
                        columnWidths: specialWidths,
                        alignments: specialAligns,
                        totalsRow: {
                            label: `Total: ${sortedDelegadas.length} marea${sortedDelegadas.length !== 1 ? 's' : ''}`,
                            values: ['', '', totalDias.toString(), '']
                        }
                    },
                ),
            );
            subsecNum++;
        }

        if (!allEmpty) {
            const sumRow = (label: string, collection: any[], daysField: string = 'diasNavegados') => {
                const count = collection.length;
                const days = collection.reduce((acc: number, m: any) => acc + (m[daysField] || 0), 0);
                return { label, count, days };
            };

            const summaryRows = [
                sumRow('En ejecución', proc.enEjecucion, 'dias'),
                sumRow('En espera de entrega de datos', esperandoEntrega),
                sumRow('Pendientes de informe', pendientesDeInforme),
                sumRow('Informes pendientes de envío a DNI', informesPendientesEnvio),
                sumRow('Esperando protocolización', esperandoProtocolizacion),
                sumRow('Protocolizadas', protocolizadasFiltradas),
                sumRow('Delegadas a programas externos', delegadasExternas),
            ].filter(r => r.count > 0);

            if (summaryRows.length > 0) {
                const totalEjecucion = summaryRows.filter(r => r.label === 'En ejecución').reduce((acc, r) => acc + r.count, 0);
                const totalFinalizadas = summaryRows.filter(r => r.label !== 'En ejecución').reduce((acc, r) => acc + r.count, 0);
                const totalDias = summaryRows.reduce((acc, r) => acc + r.days, 0);

                result.push(
                    new Paragraph({ spacing: { before: SPACING.beforeHeading, after: SPACING.afterParagraph } }),
                    this.heading2(`6.${subsecNum} Resumen de estados`),
                    this.bodyParagraph('A continuación se expone un resumen con la cantidad de mareas y días navegados agrupados por su estado administrativo (excluyendo canceladas y desestimadas):'),
                    createFormattedTable(
                        ['ESTADO', 'EN EJECUCIÓN', 'FINALIZADAS', 'DÍAS NAV.'],
                        summaryRows.map(r => {
                            const isEjecucion = r.label === 'En ejecución';
                            return [
                                r.label,
                                isEjecucion ? r.count.toString() : '-',
                                !isEjecucion ? r.count.toString() : '-',
                                r.days.toString()
                            ];
                        }),
                        {
                            columnWidths: [45, 18, 17, 20],
                            alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                            totalsRow: {
                                label: 'TOTAL',
                                values: [totalEjecucion.toString(), totalFinalizadas.toString(), totalDias.toString()]
                            }
                        }
                    )
                );
            }
        }

        return result;
    }

    private buildProtocolizacionSection(data: AuditReportData, period: PeriodDescription): (Paragraph | Table)[] {
        const tl = data.protocolizationTimeline;
        const result: (Paragraph | Table)[] = [
            this.heading1('9. SEGUIMIENTO DE PROTOCOLIZACIÓN'),
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
                this.heading2('9.1 Distribución temporal'),
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
                this.heading2('9.2 Protocolizaciones durante el período'),
                this.bodyParagraph('A continuación se listan las mareas que obtuvieron su número de protocolo oficial dentro del período analizado (incluye mareas que finalizaron en períodos anteriores):'),
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
        const children: (Paragraph | Table)[] = [this.heading1('8. OBSERVACIONES COMPLEMENTARIAS')];
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

    private buildAnnexSection(annexData: NonNullable<AuditReportData['annexData']>, effortChart?: Buffer): (Paragraph | Table)[] {
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

        const totalsPesqueria = new Array(annexData.quarters.length).fill(0);
        for (const fishery of annexData.activeFisheries) {
            const daysArr = annexData.fisheries[fishery];
            for (let i = 0; i < annexData.quarters.length; i++) {
                totalsPesqueria[i] += daysArr[i] || 0;
            }
        }

        result.push(
            createFormattedTable(headers, rows, {
                columnWidths,
                alignments,
                totalsRow: {
                    label: 'TOTAL',
                    values: totalsPesqueria.map(val => val > 0 ? val.toString() : '-')
                }
            })
        );

        if (effortChart) {
            result.push(
                new Paragraph({ spacing: { before: SPACING.afterTable } }),
                this.chartImage(effortChart, 15, 0.4)
            );
        }

        // 2. Tabla de Mareas según Estado
        /*
        if (annexData.mareaStates) {
            const totalsEstadoMarea = new Array(annexData.quarters.length).fill(0);
            for (let i = 0; i < annexData.quarters.length; i++) {
                 totalsEstadoMarea[i] = annexData.mareaStates.finalizadas[i] + annexData.mareaStates.canceladas[i];
            }

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
                        alignments: [AlignmentType.LEFT, ...new Array(annexData.quarters.length).fill(AlignmentType.CENTER)],
                        totalsRow: {
                            label: 'TOTAL',
                            values: totalsEstadoMarea.map(val => val.toString())
                        }
                    }
                )
            );
        }

        // 3. Tabla de Mareas según Estado de Protocolización
        if (annexData.protocolizationStates) {
            const totalsEstadoProt = new Array(annexData.quarters.length).fill(0);
            for (let i = 0; i < annexData.quarters.length; i++) {
                 totalsEstadoProt[i] = annexData.protocolizationStates.enEspera[i] + 
                                       annexData.protocolizationStates.enviadas[i] + 
                                       annexData.protocolizationStates.protocolizadas[i];
            }

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
                        alignments: [AlignmentType.LEFT, ...new Array(annexData.quarters.length).fill(AlignmentType.CENTER)],
                        totalsRow: {
                            label: 'TOTAL',
                            values: totalsEstadoProt.map(val => val.toString())
                        }
                    }
                )
            );
        }
        */

        // 4. ANEXO 2: DETALLE DE PROTOCOLIZACIÓN TRIMESTRAL
        /*
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
                    const detailHeaders = ['Marea', 'En revisión', 'Derivada', 'Enviada', 'Protocolizada'];
                    let tRevision = 0, tDerivada = 0, tEnviada = 0, tProtocolizada = 0;

                    const detailRows = mareasTrimestre.map(m => {
                        const enRevision = !m.derivada && !m.enviada && !m.protocolizada;
                        if (enRevision) tRevision++;
                        if (m.derivada) tDerivada++;
                        if (m.enviada) tEnviada++;
                        if (m.protocolizada) tProtocolizada++;

                        return {
                            data: [
                                m.identificacion,
                                enRevision ? '✓' : '',
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
                                columnWidths: [48, 13, 13, 13, 13],
                                alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                                totalsRow: { 
                                    label: `Total: ${mareasTrimestre.length} marea${mareasTrimestre.length !== 1 ? 's' : ''}`,
                                    values: [
                                        tRevision > 0 ? tRevision.toString() : '-',
                                        tDerivada > 0 ? tDerivada.toString() : '-',
                                        tEnviada > 0 ? tEnviada.toString() : '-',
                                        tProtocolizada > 0 ? tProtocolizada.toString() : '-'
                                    ]
                                }
                            }
                        )
                    );
                }
            }
        }
        */

        // 4. ANEXO 2: DETALLE DE PROTOCOLIZACIÓN ANUAL
        if (annexData.annualFinalizedDetails) {
            result.push(
                new Paragraph({ children: [new PageBreak()] }),
                this.heading1('ANEXO 2: DETALLE DE PROTOCOLIZACIÓN ANUAL'),
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
                const detailHeaders = ['Marea', 'En revisión', 'Derivada', 'Enviada', 'Protocolizada'];
                let tRevision = 0, tDerivada = 0, tEnviada = 0, tProtocolizada = 0;

                const detailRows = mareasAnuales.map(m => {
                    const enRevision = !m.derivada && !m.enviada && !m.protocolizada;
                    if (enRevision) tRevision++;
                    if (m.derivada) tDerivada++;
                    if (m.enviada) tEnviada++;
                    if (m.protocolizada) tProtocolizada++;

                    return {
                        data: [
                            m.identificacion,
                            enRevision ? '✓' : '',
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
                            columnWidths: [48, 13, 13, 13, 13],
                            alignments: [AlignmentType.LEFT, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER, AlignmentType.CENTER],
                            totalsRow: {
                                label: `Total: ${mareasAnuales.length} marea${mareasAnuales.length !== 1 ? 's' : ''}`,
                                values: [
                                    tRevision > 0 ? tRevision.toString() : '-',
                                    tDerivada > 0 ? tDerivada.toString() : '-',
                                    tEnviada > 0 ? tEnviada.toString() : '-',
                                    tProtocolizada > 0 ? tProtocolizada.toString() : '-'
                                ]
                            }
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
                colors: [CHART_COLORS.primary, 'rgba(203, 213, 225, 1)'],
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

    private heading2(text: string, pageBreakBefore: boolean = false): Paragraph {
        return new Paragraph({
            spacing: { before: SPACING.beforeHeading / 1.5, after: SPACING.afterHeading },
            pageBreakBefore,
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

    private async generateComparativaChart(period: PeriodDescription, proc: any): Promise<{ chartReal: Buffer; chartPost?: Buffer; tPost: number }> {
        const pEnd = period.endDate ? new Date(period.endDate) : new Date(Date.UTC(period.year, 11, 31, 23, 59, 59, 999));
        pEnd.setUTCHours(23, 59, 59, 999);

        const allMareas = [...proc.enEjecucion, ...proc.finalizadas];

        let tEnviada = 0;
        let tProtocolizada = 0;
        let tPost = 0;

        allMareas.forEach(m => {
            if (m.estado !== 'Finalizada') return;

            // Estado REAL al cierre (snapshot desde movimientos)
            if (m.categoriaCierre === 'ENVIADA') {
                tEnviada++;
                const fProt = m.fechaProtocolizacion ? new Date(m.fechaProtocolizacion) : null;
                if (fProt) {
                    const diffDays = (fProt.getTime() - pEnd.getTime()) / (1000 * 60 * 60 * 24);
                    if (diffDays > 0 && diffDays <= 7) {
                        tPost++;
                    }
                }
            }
            if (m.categoriaCierre === 'PROTOCOLIZADA') tProtocolizada++;
        });

        const chartReal = await this.chartService.renderDoughnutChart(
            ['En espera', 'Protocolizadas'],
            [tEnviada, tProtocolizada],
            {
                title: 'Al cierre del período',
                colors: ['rgba(203, 213, 225, 1)', CHART_COLORS.primary],
                displayLabels: true
            }
        );

        let chartPost: Buffer | undefined;
        if (tPost > 0) {
            chartPost = await this.chartService.renderDoughnutChart(
                ['En espera', 'Protocolizadas'],
                [tEnviada - tPost, tProtocolizada + tPost],
                {
                    title: 'Incluyendo pos-cierre',
                    colors: ['rgba(203, 213, 225, 1)', CHART_COLORS.primary],
                    displayLabels: true
                }
            );
        }

        return { chartReal, chartPost, tPost };
    }

    private async generateAnnexEffortChart(annexData: NonNullable<AuditReportData['annexData']>): Promise<Buffer> {
        const numToOrdinal = ['1º Trim.', '2º Trim.', '3º Trim.', '4º Trim.'];
        const datasets = annexData.quarters.map((q, i) => {
            const data = annexData.activeFisheries.map(fishery => annexData.fisheries[fishery][i] || 0);
            return {
                label: numToOrdinal[q - 1],
                data
            };
        });

        return this.chartService.renderBarChart(
            annexData.activeFisheries,
            datasets,
            {
                title: 'Esfuerzo Acumulado por Trimestre',
                stacked: true,
                displayLabels: false
            }
        );
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
