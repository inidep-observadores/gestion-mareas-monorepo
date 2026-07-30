import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { StatsService } from './stats/stats.service';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const statsService = app.get(StatsService);

    console.log('--- TEST NAVEGACION TAB (No SnapDate) ---');
    const uiStats = await statsService.getDashboardStats(
        2026,
        'CALENDAR',
        true, // includeNonProtocolized (default is true based on UI "!props.protocolizedOnly")
        false,
        'SHIP',
        false, // includeCampaigns
        '2026-07-01',
        '2026-09-30',
        '2026-07-01',
        '2026-09-30',
        undefined
    );
    console.log(`UI totalDaysNavigated: ${uiStats.totalDaysNavigated}`);

    console.log('--- TEST PDF GENERATION (With SnapDate) ---');
    const snapDate = new Date(Date.UTC(2026, 11, 31, 23, 59, 59, 999));
    snapDate.setUTCHours(23, 59, 59, 999);
    
    // In reports.service.ts:
    // const snapDate = endDate ? new Date(endDate) : new Date(Date.UTC(year, 11, 31, 23, 59, 59, 999));
    // snapDate.setUTCHours(23, 59, 59, 999);
    const snapDate2 = new Date('2026-09-30');
    snapDate2.setUTCHours(23, 59, 59, 999);
    const now = new Date();
    if (snapDate2 > now) {
        snapDate2.setTime(now.getTime());
    }

    const pdfStats = await statsService.getDashboardStats(
        2026,
        'CALENDAR',
        true,
        false,
        'SHIP',
        false,
        '2026-07-01',
        '2026-09-30',
        '2026-07-01',
        '2026-09-30',
        snapDate2
    );
    console.log(`PDF totalDaysNavigated: ${pdfStats.totalDaysNavigated}`);

    await app.close();
}

bootstrap();
