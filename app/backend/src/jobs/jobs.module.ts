import { Module, Global } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { SchedulerService } from './scheduler.service';
import { VesselSyncProcessor } from './processors/vessel-sync.processor';
import { CatalogosModule } from '../catalogos/catalogos.module';
import { JobQueueService } from './job-queue.service';
import { JobQueueStatsService } from './job-queue.stats.service';
import { JobQueueController } from './job-queue.controller';
import { AuthModule } from '../auth/auth.module'; // Necesario para AuthGuard

@Global()
@Module({
    imports: [
        ScheduleModule.forRoot(),
        CatalogosModule,
        AuthModule,
    ],
    controllers: [
        JobQueueController,
    ],
    providers: [
        SchedulerService,
        VesselSyncProcessor,
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
