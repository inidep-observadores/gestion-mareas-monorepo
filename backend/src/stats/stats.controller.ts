import { Controller, Get, Query, ParseIntPipe, ParseBoolPipe, DefaultValuePipe } from '@nestjs/common';
import { StatsService } from './stats.service';

@Controller('stats')
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
}
