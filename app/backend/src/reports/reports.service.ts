/**
 * Servicio de orquestación de generación de informes.
 *
 * Coordina la obtención de datos desde los servicios de dominio
 * y delega la construcción del documento al builder correspondiente.
 */
import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { StatsService } from '../stats/stats.service';
import { AuditReportBuilder, AuditReportData } from './templates/audit-report.builder';
import { MareaEstado } from '../mareas/mareas.constants';

export interface AuditReportParams {
    year: number;
    mode: 'CALENDAR' | 'TOTAL';
    includeNonProtocolized: boolean;
    includeProtocolizedOutOfPeriod?: boolean;
    includeCampaigns?: boolean;
    startDate?: string;
    endDate?: string;
    protocolizationStartDate?: string;
    protocolizationEndDate?: string;
    includeAnnualAnnex?: boolean;
}

import { ConversionService } from './conversion.service';

@Injectable()
export class ReportsService {
    private readonly logger = new Logger(ReportsService.name);

    constructor(
        private readonly statsService: StatsService,
        private readonly prisma: PrismaService,
        private readonly auditReportBuilder: AuditReportBuilder,
        private readonly conversionService: ConversionService,
    ) {}

    /**
     * Genera el informe de auditoría en formato .docx
     * @returns Buffer con el contenido del archivo Word
     */
    async generateAuditReport(params: AuditReportParams): Promise<Buffer> {
        const {
            year,
            mode,
            includeNonProtocolized,
            includeProtocolizedOutOfPeriod = false,
            includeCampaigns = true,
            startDate,
            endDate,
            protocolizationStartDate,
            protocolizationEndDate,
        } = params;

        const pStart = startDate ? new Date(startDate) : new Date(Date.UTC(year, 0, 1));
        pStart.setUTCHours(0, 0, 0, 0);

        const snapDate = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));
        snapDate.setUTCHours(23, 59, 59, 999);

        this.logger.log(`Generando informe de auditoría: año=${year}, modo=${mode}, snapshot=${snapDate.toISOString()}`);

        // 1. Obtener estadísticas globales (Snapshot Histórico)
        const stats = await this.statsService.getDashboardStats(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            'SHIP', includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
            snapDate
        );

        // 2. Obtener dotación activa
        const allActiveObservers = await this.prisma.observador.findMany({
            where: { activo: true, disponible: true, conImpedimento: false, tipoObservador: 'OBSERVADOR' },
            select: { id: true, nombre: true, apellido: true },
        });
        const dotacionActiva = allActiveObservers.length;

        // 3. Obtener tipo de observador para cruzar en el breakdown
        const observerIds = stats.observers.map((o: any) => o.id);
        const observerIdsSet = new Set(observerIds);
        const observersData = await this.prisma.observador.findMany({
            where: { id: { in: observerIds } },
            select: { id: true, tipoObservador: true, tipoContrato: true },
        });
        const observerDataMap = new Map(observersData.map(o => [o.id, { tipoObservador: o.tipoObservador, tipoContrato: o.tipoContrato }]));

        // Computar observadores sin actividad
        const observadoresSinActividad = allActiveObservers
            .filter(o => !observerIdsSet.has(o.id))
            .map(o => ({ id: o.id, name: `${o.nombre} ${o.apellido}` }));

        // 4. Obtener distribución de mareas (Snapshot Histórico)
        const distribution = await this.statsService.getMareaDistribution(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
            snapDate
        );

        // 5. Obtener detalle de mareas (Snapshot Histórico)
        const detailItems = await this.statsService.getDashboardStatsDetail(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            null, '', 'SHIP', includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
            snapDate
        );

        // --- LÓGICA DE MOVIMIENTOS HISTÓRICOS PARA SNAPSHOT (WORD) ---
        const mareaIdsDelPeriodo = detailItems.filter(item => item.estado === 'Finalizada').map(item => item.id);
        const movsAlCorte = await this.prisma.mareaMovimiento.findMany({
            where: {
                mareaId: { in: mareaIdsDelPeriodo },
                fechaHora: { lte: snapDate },
                estadoHastaId: { not: null }
            },
            orderBy: [{ mareaId: 'asc' }, { fechaHora: 'desc' }],
            include: { estadoHasta: true }
        });

        const lastStateMap = new Map<string, string>();
        const processedMareas = new Set<string>();
        for (const mov of movsAlCorte) {
            if (!processedMareas.has(mov.mareaId)) {
                lastStateMap.set(mov.mareaId, mov.estadoHasta.codigo);
                processedMareas.add(mov.mareaId);
            }
        }

        // 6. Obtener datos adicionales en paralelo (Snapshot Histórico)
        const [secondaryStats, specialCases, protocolizationTimeline, fisheryOrdering] = await Promise.all([
            this.statsService.getSecondaryObserverStats(year, startDate, endDate, snapDate),
            this.statsService.getAuditSpecialCases(year, startDate, endDate, includeCampaigns, snapDate),
            this.statsService.getProtocolizationTimeline(year, startDate, endDate, snapDate, includeCampaigns),
            this.prisma.pesqueria.findMany({
                select: { nombre: true, orden: true }
            }),
        ]);

        const fisheryOrderMap = new Map<string, number>(
            fisheryOrdering.map(f => [f.nombre.trim(), f.orden ?? 999])
        );

        // 6.5. Computar datos del Anexo Anual Comparativo si se requiere
        let annexData;
        if (params.includeAnnualAnnex && startDate && endDate) {
            const startMonth = parseInt(startDate.split('-')[1], 10);
            const endMonth = parseInt(endDate.split('-')[1], 10);
            let selectedQuarter = null;
            if (startMonth === 1 && endMonth === 3) selectedQuarter = 1;
            if (startMonth === 4 && endMonth === 6) selectedQuarter = 2;
            if (startMonth === 7 && endMonth === 9) selectedQuarter = 3;
            if (startMonth === 10 && endMonth === 12) selectedQuarter = 4;

            if (selectedQuarter && selectedQuarter >= 2) {
                const quarters = Array.from({ length: selectedQuarter }, (_, i) => i + 1);
                
                // Get ALL fisheries active in the entire year
                const yearStats = await this.statsService.getDashboardStats(
                    year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
                    'SHIP', includeCampaigns, undefined, undefined,
                    protocolizationStartDate, protocolizationEndDate,
                    snapDate
                );
                
                const activeFisheries = Array.from(new Set(yearStats.fisheries.map((f: any) => f.name)));
                activeFisheries.sort((a, b) => (fisheryOrderMap.get(a.trim()) || 999) - (fisheryOrderMap.get(b.trim()) || 999));

                const fisheriesData: Record<string, number[]> = {};
                for (const name of activeFisheries) {
                    fisheriesData[name] = new Array(selectedQuarter).fill(0);
                }

                for (let q = 1; q <= selectedQuarter; q++) {
                    const qStartMonth = (q - 1) * 3 + 1;
                    const qEndMonth = qStartMonth + 2;
                    const lastDay = new Date(year, qEndMonth, 0).getDate();
                    
                    const qStartDateStr = `${year}-${String(qStartMonth).padStart(2, '0')}-01`;
                    const qEndDateStr = `${year}-${String(qEndMonth).padStart(2, '0')}-${lastDay}`;
                    
                    const qStats = await this.statsService.getDashboardStats(
                        year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
                        'SHIP', includeCampaigns, qStartDateStr, qEndDateStr,
                        protocolizationStartDate, protocolizationEndDate,
                        snapDate
                    );
                    
                    for (const f of qStats.fisheries) {
                        if (fisheriesData[f.name]) {
                            fisheriesData[f.name][q - 1] = f.days;
                        }
                    }
                }
                
                const qStats = await this.statsService.getAuditAnnexStats(
                    year,
                    selectedQuarter,
                    includeCampaigns,
                    snapDate
                );
                
                annexData = {
                    quarters,
                    fisheries: fisheriesData,
                    activeFisheries,
                    mareaStates: qStats.mareaStates,
                    protocolizationStates: qStats.protocolizationStates,
                    finalizedDetails: qStats.finalizedDetails
                };
            }
        }

        // 7. Computar breakdown Observadores vs Técnicos
        const emptySlice = () => ({
            dias: 0, mareasFinalizadas: 0, mareasEnEjecucion: 0, desestimadas: 0,
            informesDeMarea: 0, informesProtocolizados: 0, informesPendientes: 0,
            esperandoEntrega: 0, delegadasExternas: 0,
        });
        const breakdown = { observadores: emptySlice(), tecnicos: emptySlice() };

        // Los días ya se procesaron arriba

        detailItems.forEach((item: any) => {
            if (!item.observadorId) return;
            const t = observerDataMap.get(item.observadorId)?.tipoObservador === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            
            // Acumular días navegados según el modo del reporte
            t.dias += (mode === 'CALENDAR' ? item.diasCalendario : item.diasTotales);
            
            if (item.estado === 'Finalizada') {
                t.mareasFinalizadas++;
                const fEnvio = item.fechaEnvioProtocolizacion ? new Date(item.fechaEnvioProtocolizacion) : null;
                const fProt = item.fechaProtocolizacion ? new Date(item.fechaProtocolizacion) : null;

                if (fEnvio && fEnvio >= pStart && fEnvio <= snapDate) {
                    t.informesDeMarea++; // Balde 1: Enviadas a DNI
                    if (fProt && fProt >= pStart && fProt <= snapDate) {
                        t.informesProtocolizados++;
                    }
                } else {
                    // Etapa Intermedia: Evaluar estado histórico para las NO enviadas
                    const stateAtSnapshot = lastStateMap.get(item.id);
                    if (stateAtSnapshot === MareaEstado.PARA_PROTOCOLIZAR) {
                        t.informesPendientes++; // Balde 2: Listas para envío
                    } else if (stateAtSnapshot === MareaEstado.ESPERANDO_ENTREGA) {
                        t.esperandoEntrega++; 
                    } else if (stateAtSnapshot === MareaEstado.DELEGADA_EXTERNA) {
                        t.delegadasExternas++;
                    } else {
                        // Balde 3: Remanente absoluto (Pendiente de informe puro)
                        t.desestimadas++; // Usamos esto como puente hacia el builder
                    }
                }
            } else {
                t.mareasEnEjecucion++;
            }
        });

        // 8. Construir los datos para el builder
        const limitDateStr = endDate ? endDate : `${year}-12-31`;
        const todayStr = new Date().toISOString().substring(0, 10);
        const isPeriodOpen = limitDateStr >= todayStr;

        const reportData: AuditReportData = {
            year,
            mode,
            startDate,
            endDate,
            includeCampaigns: includeCampaigns!,
            stats: {
                totalMareas: stats.totalMareas,
                totalDaysNavigated: stats.totalDaysNavigated,
                avgDaysPerMarea: stats.totalMareas > 0 ? Math.round(stats.totalDaysNavigated / stats.totalMareas) : 0,
                fisheries: stats.fisheries,
                fleets: stats.fleets,
                observers: stats.observers.map((o: any) => ({
                    ...o,
                    tipoContrato: observerDataMap.get(o.id)?.tipoContrato,
                    tipoObservador: observerDataMap.get(o.id)?.tipoObservador,
                })),
            },
            dotacionActiva,
            observadoresSinActividad,
            secondaryStats,
            specialCases,
            protocolizationTimeline,
            breakdown,
            fisheryOrderMap,
            detailItems: detailItems.map((item: any) => {
                let estadoAuditoria = item.estado; // 'En ejecución' o 'Finalizada' ya resuelto por el snapshot

                // Refinamiento: Si el snapshot dice 'Finalizada' pero la fecha de fin es estrictamente 
                // mayor al límite del periodo, se considera 'En ejecución' para propósitos de este reporte parcial.
                if (estadoAuditoria === 'Finalizada' && item.fechaFin) {
                    const finDateStr = new Date(item.fechaFin).toISOString().substring(0, 10);
                    if (finDateStr > limitDateStr) {
                        estadoAuditoria = 'En ejecución';
                    }
                }

                return {
                    id: item.id,
                    id_marea: item.id_marea,
                    anioMarea: item.anioMarea || year,
                    buque: item.buque,
                    flota: item.flota,
                    pesqueria: item.pesqueria,
                    observador: item.observador || '',
                    estado: estadoAuditoria,
                    estadoActual: item.estadoActual || '',
                    observadorId: item.observadorId || null,
                    estadoOrden: item.estadoOrden ?? 0,
                    diasCalendario: item.diasCalendario,
                    diasTotales: item.diasTotales,
                    fechaInicio: item.fechaInicio,
                    fechaFin: item.fechaFin,
                    fechaZarpada: item.fechaZarpada ?? null,
                    fechaArribo: item.fechaArribo ?? null,
                    fechaDerivacion: item.fechaDerivacion ?? null,
                    fechaEnvioProtocolizacion: item.fechaEnvioProtocolizacion ?? null,
                    nroProtocolizacion: item.nroProtocolizacion ?? null,
                    anioProtocolizacion: item.anioProtocolizacion ?? null,
                    fechaProtocolizacion: item.fechaProtocolizacion ?? null,
                };
            }),
            distribution: distribution.map((d: any) => ({
                mareaId: d.mareaId || d.id,
                id_marea: d.id_marea,
                nroEtapa: d.nroEtapa || 1,
            })),
            annexData,
        };

        this.logger.log(`Datos recopilados: ${reportData.stats.totalMareas} mareas, ${reportData.stats.observers.length} observadores`);

        // 9. Generar el documento
        const buffer = await this.auditReportBuilder.build(reportData);

        this.logger.log(`Informe generado exitosamente (${(buffer.length / 1024).toFixed(0)} KB)`);

        return buffer;
    }

    /**
     * Genera el informe de auditoría en formato .pdf
     * @returns Buffer con el contenido del archivo PDF
     */
    async generateAuditReportPdf(params: AuditReportParams): Promise<Buffer> {
        this.logger.log(`Iniciando generación de PDF para informe de auditoría...`);

        // 1. Generar primero el archivo Word usando la lógica existente
        const wordBuffer = await this.generateAuditReport(params);

        // 2. Convertir el buffer Word a PDF vía Gotenberg
        const fileName = `Informe_Auditoria_${params.year}_${params.mode}.docx`;
        const pdfBuffer = await this.conversionService.convertDocxToPdf(wordBuffer, fileName);

        return pdfBuffer;
    }
}
