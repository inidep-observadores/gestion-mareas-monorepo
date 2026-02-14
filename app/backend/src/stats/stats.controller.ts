import { Controller, Get, Query, Res } from '@nestjs/common';
import { Response } from 'express';
import { StatsService } from './stats.service';
import { Auth } from '../auth/decorators';
import { GetStatsDto } from './dto/get-stats.dto';

@Controller('stats')
@Auth()
export class StatsController {
    constructor(private readonly statsService: StatsService) { }

    @Get('dashboard')
    getDashboardStats(@Query() query: GetStatsDto) {
        return this.statsService.getDashboardStats(
            query.year,
            query.mode,
            query.includeNonProtocolized,
            query.includeProtocolizedOutOfPeriod,
            query.daysCalculationMode,
            query.includeCampaigns,
            query.startDate,
            query.endDate
        );
    }

    @Get('detail')
    getDashboardStatsDetail(@Query() query: GetStatsDto) {
        return this.statsService.getDashboardStatsDetail(
            query.year,
            query.mode,
            query.includeNonProtocolized,
            query.includeProtocolizedOutOfPeriod,
            query.filterType,
            query.filterValue,
            query.daysCalculationMode,
            query.includeCampaigns,
            query.startDate,
            query.endDate
        );
    }

    @Get('distribution')
    getMareaDistribution(@Query() query: GetStatsDto) {
        return this.statsService.getMareaDistribution(
            query.year,
            query.mode || 'CALENDAR',
            query.includeNonProtocolized,
            query.includeProtocolizedOutOfPeriod,
            query.daysCalculationMode,
            query.includeCampaigns,
            query.startDate,
            query.endDate
        );
    }

    @Get('export')
    async exportStats(
        @Res() res: Response,
        @Query() query: GetStatsDto
    ) {
        const workbook = await this.statsService.getExportWorkbook(
            query.year,
            query.mode,
            query.includeNonProtocolized,
            query.includeProtocolizedOutOfPeriod,
            query.daysCalculationMode,
            query.includeCampaigns,
            query.filterType,
            query.filterValue,
            query.startDate,
            query.endDate
        );

        const filename = query.customFilename ? `${query.customFilename}.xlsx` : `Estadisticas_Mareas_${query.year}.xlsx`;

        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.setHeader('Content-Disposition', `attachment; filename=${filename}`);

        await workbook.xlsx.write(res);
        res.end();
    }
}
