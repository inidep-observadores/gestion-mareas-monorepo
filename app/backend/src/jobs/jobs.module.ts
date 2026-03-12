import { Module, Global, forwardRef } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { SchedulerService } from './scheduler.service';
import { VesselSyncProcessor } from './processors/vessel-sync.processor';
import { CatalogosModule } from '../catalogos/catalogos.module';
import { JobQueueService } from './job-queue.service';
import { JobQueueStatsService } from './job-queue.stats.service';
import { JobQueueController } from './job-queue.controller';
import { AuthModule } from '../auth/auth.module'; // Necesario para AuthGuard
import { PnaApiModule } from '../pna-api/pna-api.module';
import { PnaApiSyncProcessor } from './processors/pna-api-sync.processor';
import { PnaTrackingSyncProcessor } from './processors/pna-tracking-sync.processor';
import { BackupAutoProcessor } from './processors/backup-auto.processor';
import { BackupModule } from '../admin/backup/backup.module';

@Global()
@Module({
    imports: [
        ScheduleModule.forRoot(),
        CatalogosModule,
        AuthModule,
        forwardRef(() => PnaApiModule),
        BackupModule,
    ],
    controllers: [
        JobQueueController,
    ],
    providers: [
        SchedulerService,
        VesselSyncProcessor,
        PnaApiSyncProcessor,
        PnaTrackingSyncProcessor,
        BackupAutoProcessor,
        JobQueueService,
        JobQueueStatsService,
    ],
    exports: [
        SchedulerService,
        JobQueueService,
        JobQueueStatsService,
    ],
})
export class JobsModule { }
