import { Controller, Get, Query, Res } from '@nestjs/common';
import { Response } from 'express';
import { Auth } from '../auth/decorators';
import { ReportsService } from './reports.service';
import { GetStatsDto } from '../stats/dto/get-stats.dto';

@Controller('reports')
@Auth()
export class ReportsController {
    constructor(private readonly reportsService: ReportsService) {}

    /**
     * Endpoint para generar el informe de auditoría en formato .docx
     * GET /reports/audit-report
     */
    @Get('audit-report')
    async getAuditReport(
        @Res() res: Response,
        @Query() query: GetStatsDto,
    ) {
        const toBool = (val: any) => val === 'true' || val === true;

        const buffer = await this.reportsService.generateAuditReport({
            year: Number(query.year),
            mode: query.mode || 'CALENDAR',
            includeNonProtocolized: toBool(query.includeNonProtocolized),
            includeProtocolizedOutOfPeriod: toBool(query.includeProtocolizedOutOfPeriod),
            includeCampaigns: toBool(query.includeCampaigns),
            startDate: query.startDate,
            endDate: query.endDate,
            protocolizationStartDate: query.protocolizationStartDate,
            protocolizationEndDate: query.protocolizationEndDate,
        });

        const filename = query.customFilename
            ? `${query.customFilename}.docx`
            : `Informe_Auditoria_Mareas_${query.year}.docx`;

        res.setHeader(
            'Content-Type',
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        );
        res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
        res.send(buffer);
    }
}
