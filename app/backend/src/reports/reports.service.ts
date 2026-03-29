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

        // 3. Obtener distribución de mareas (para etapas)
        const distribution = await this.statsService.getMareaDistribution(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
        );

        // 4. Obtener detalle de mareas
        const detailItems = await this.statsService.getDashboardStatsDetail(
            year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod,
            null, '', 'SHIP', includeCampaigns, startDate, endDate,
            protocolizationStartDate, protocolizationEndDate,
        );

        // 5. Construir los datos para el builder
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
            detailItems: detailItems.map((item: any) => {
                const limitDateStr = endDate ? endDate : `${year}-12-31`;
                const todayStr = new Date().toISOString().substring(0, 10);
                const isPeriodOpen = limitDateStr >= todayStr;

                let estadoAuditoria = 'Finalizada';
                if (isPeriodOpen && item.estado === 'En ejecución') {
                    estadoAuditoria = 'En ejecución';
                } else if (!item.fechaFin) {
                    estadoAuditoria = 'En ejecución';
                } else {
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
                    diasCalendario: item.diasCalendario,
                    diasTotales: item.diasTotales,
                    fechaInicio: item.fechaInicio,
                    fechaFin: item.fechaFin,
                };
            }),
            distribution: distribution.map((d: any) => ({
                mareaId: d.mareaId || d.id,
                id_marea: d.id_marea,
                nroEtapa: d.nroEtapa || 1,
            })),
        };

        this.logger.log(`Datos recopilados: ${reportData.stats.totalMareas} mareas, ${reportData.stats.observers.length} observadores`);

        // 6. Generar el documento
        const buffer = await this.auditReportBuilder.build(reportData);

        this.logger.log(`Informe generado exitosamente (${(buffer.length / 1024).toFixed(0)} KB)`);

        return buffer;
    }
}
