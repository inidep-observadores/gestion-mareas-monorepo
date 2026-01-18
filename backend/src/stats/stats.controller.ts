import { Controller, Get, Query, ParseIntPipe, ParseBoolPipe, DefaultValuePipe, Res } from '@nestjs/common';
import { Response } from 'express';
import { StatsService } from './stats.service';
import { Auth } from '../auth/decorators';

@Controller('stats')
@Auth()
export class StatsController {
    constructor(private readonly statsService: StatsService) { }

    @Get('dashboard')
    getDashboardStats(
        @Query('year', ParseIntPipe) year: number,
        @Query('mode') mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        @Query('includeNonProtocolized', new DefaultValuePipe(false), ParseBoolPipe) includeNonProtocolized: boolean,
        @Query('includeProtocolizedOutOfPeriod', new DefaultValuePipe(false), ParseBoolPipe) includeProtocolizedOutOfPeriod: boolean,
    ) {
        return this.statsService.getDashboardStats(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod);
    }

    @Get('detail')
    getDashboardStatsDetail(
        @Query('year', ParseIntPipe) year: number,
        @Query('mode') mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        @Query('includeNonProtocolized', new DefaultValuePipe(false), ParseBoolPipe) includeNonProtocolized: boolean,
        @Query('includeProtocolizedOutOfPeriod', new DefaultValuePipe(false), ParseBoolPipe) includeProtocolizedOutOfPeriod: boolean,
        @Query('filterType') filterType: 'FISHERY' | 'FLEET' | 'OBSERVER',
        @Query('filterValue') filterValue: string,
    ) {
        return this.statsService.getDashboardStatsDetail(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, filterType, filterValue);
    }

    @Get('export')
    async exportStats(
        @Res() res: Response,
        @Query('year', ParseIntPipe) year: number,
        @Query('mode') mode: 'CALENDAR' | 'TOTAL' = 'CALENDAR',
        @Query('includeNonProtocolized', new DefaultValuePipe(false), ParseBoolPipe) includeNonProtocolized: boolean,
        @Query('includeProtocolizedOutOfPeriod', new DefaultValuePipe(false), ParseBoolPipe) includeProtocolizedOutOfPeriod: boolean,
        @Query('filterType') filterType?: 'FISHERY' | 'FLEET' | 'OBSERVER',
        @Query('filterValue') filterValue?: string,
        @Query('filename') customFilename?: string,
    ) {
        const workbook = await this.statsService.getExportWorkbook(year, mode, includeNonProtocolized, includeProtocolizedOutOfPeriod, filterType, filterValue);

        const filename = customFilename ? `${customFilename}.xlsx` : `Estadisticas_Mareas_${year}.xlsx`;

        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.setHeader('Content-Disposition', `attachment; filename=${filename}`);

        await workbook.xlsx.write(res);
        res.end();
    }
}
