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

        // 6. Obtener datos adicionales en paralelo (Snapshot Histórico)
        const [secondaryStats, specialCases, protocolizationTimeline] = await Promise.all([
            this.statsService.getSecondaryObserverStats(year, startDate, endDate, snapDate),
            this.statsService.getAuditSpecialCases(year, startDate, endDate, includeCampaigns, snapDate),
            this.statsService.getProtocolizationTimeline(year, startDate, endDate, snapDate, includeCampaigns),
        ]);

        // 7. Computar breakdown Observadores vs Técnicos
        const informeStates = new Set<string>([
            MareaEstado.PARA_PROTOCOLIZAR,
            MareaEstado.ESPERANDO_PROTOCOLIZACION,
            MareaEstado.PROTOCOLIZADA,
        ]);
        const emptySlice = () => ({
            dias: 0, mareasFinalizadas: 0, mareasEnEjecucion: 0, desestimadas: 0,
            informesDeMarea: 0, informesProtocolizados: 0, informesPendientes: 0,
        });
        const breakdown = { observadores: emptySlice(), tecnicos: emptySlice() };

        stats.observers.forEach((obs: any) => {
            const t = observerDataMap.get(obs.id)?.tipoObservador === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            t.dias += obs.days;
        });
        specialCases.desestimadas.forEach((m: any) => {
            const t = m.tipoObservador === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            t.desestimadas++;
        });
        detailItems.forEach((item: any) => {
            if (!item.observadorId) return;
            const t = observerDataMap.get(item.observadorId)?.tipoObservador === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            // El estado se determina más abajo, pero para el breakdown usamos estadoActual
            const isFinalized = item.estadoActual !== MareaEstado.EN_EJECUCION && item.fechaFin;
            if (isFinalized) t.mareasFinalizadas++; else t.mareasEnEjecucion++;
            if (informeStates.has(item.estadoActual)) t.informesDeMarea++;
            if (item.estadoActual === MareaEstado.PROTOCOLIZADA) t.informesProtocolizados++;
            if (item.estadoOrden > 3 && item.estadoOrden < 11) t.informesPendientes++;
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
