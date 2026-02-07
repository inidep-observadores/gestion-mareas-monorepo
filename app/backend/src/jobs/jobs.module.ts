import { Module, Global } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { SchedulerService } from './scheduler.service';
import { VesselSyncProcessor } from './processors/vessel-sync.processor';
import { CatalogosModule } from '../catalogos/catalogos.module';

@Global()
@Module({
    imports: [
        ScheduleModule.forRoot(),
        CatalogosModule,
    ],
    providers: [
        SchedulerService,
        VesselSyncProcessor,
    ],
    exports: [SchedulerService],
})
export class JobsModule { }
