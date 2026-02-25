import { Module, forwardRef } from '@nestjs/common';
import { PnaApiService } from './pna-api.service';
import { PnaApiParser } from './pna-api.parser';
import { PnaApiController } from './pna-api.controller';
import { PnaTrackingService } from './pna-tracking.service';
import { PnaTrackingParser } from './pna-tracking.parser';
import { PrismaModule } from '../prisma/prisma.module';
import { CommonModule } from '../common/common.module';
import { AlertsModule } from '../alerts/alerts.module';
import { AuthModule } from '../auth/auth.module';
import { MareasModule } from '../mareas/mareas.module';
import { JobsModule } from '../jobs/jobs.module';

import { ConfigModule } from '@nestjs/config';

@Module({
    imports: [
        PrismaModule,
        AlertsModule,
        CommonModule,
        ConfigModule,
        AuthModule,
        MareasModule,
        forwardRef(() => JobsModule)
    ],
    controllers: [PnaApiController],
    providers: [PnaApiService, PnaApiParser, PnaTrackingService, PnaTrackingParser],
    exports: [PnaApiService, PnaTrackingService],
})
export class PnaApiModule { }
