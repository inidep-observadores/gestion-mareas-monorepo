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

@Injectable()
export class ReportsService {
    private readonly logger = new Logger(ReportsService.name);

    constructor(
        private readonly statsService: StatsService,
        private readonly prisma: PrismaService,
        private readonly auditReportBuilder: AuditReportBuilder,
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

        this.logger.log(`Generando informe de auditoría: año=${year}, modo=${mode}`);

        // 1. Obtener estadísticas globales
        const stats = await this.statsService.getDashboardStats(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            'SHIP', includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
        );

        // 2. Obtener dotación activa
        const dotacionActiva = await this.prisma.observador.count({
            where: { activo: true, conImpedimento: false, tipoObservador: 'OBSERVADOR' },
        });

        // 3. Obtener tipo de observador para cruzar en el breakdown
        const observerIds = stats.observers.map((o: any) => o.id);
        const observersData = await this.prisma.observador.findMany({
            where: { id: { in: observerIds } },
            select: { id: true, tipoObservador: true },
        });
        const observerTypeMap = new Map(observersData.map(o => [o.id, o.tipoObservador]));

        // 4. Obtener distribución de mareas (para etapas)
        const distribution = await this.statsService.getMareaDistribution(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
        );

        // 5. Obtener detalle de mareas (incluye protocolización y campos de navegación)
        const detailItems = await this.statsService.getDashboardStatsDetail(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            null, '', 'SHIP', includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
        );

        // 6. Obtener datos adicionales en paralelo
        const [secondaryStats, specialCases, protocolizationTimeline] = await Promise.all([
            this.statsService.getSecondaryObserverStats(year, startDate, endDate),
            this.statsService.getAuditSpecialCases(year, startDate, endDate, includeCampaigns),
            this.statsService.getProtocolizationTimeline(year, startDate, endDate),
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
            const t = observerTypeMap.get(obs.id) === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            t.dias += obs.days;
        });
        specialCases.desestimadas.forEach((m: any) => {
            const t = m.tipoObservador === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
            t.desestimadas++;
        });
        detailItems.forEach((item: any) => {
            if (!item.observadorId) return;
            const t = observerTypeMap.get(item.observadorId) === 'OBSERVADOR' ? breakdown.observadores : breakdown.tecnicos;
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
                observers: stats.observers,
            },
            dotacionActiva,
            secondaryStats,
            specialCases,
            protocolizationTimeline,
            breakdown,
            detailItems: detailItems.map((item: any) => {
                let estadoAuditoria = 'Finalizada';
                if (isPeriodOpen && item.estado === 'En ejecución') {
                    estadoAuditoria = 'En ejecución';
                } else if (!item.fechaFin) {
                    estadoAuditoria = 'En ejecución';
                } else {
                    const finDateStr = new Date(item.fechaFin).toISOString().substring(0, 10);
                    if (finDateStr > limitDateStr) estadoAuditoria = 'En ejecución';
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
}
