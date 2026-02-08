import { Module } from '@nestjs/common';
import { PnaApiService } from './pna-api.service';
import { PnaApiParser } from './pna-api.parser';
import { PrismaModule } from '../prisma/prisma.module';
import { CommonModule } from '../common/common.module';
import { AlertsModule } from '../alerts/alerts.module';

@Module({
    imports: [PrismaModule, AlertsModule, CommonModule],
    providers: [PnaApiService, PnaApiParser],
    exports: [PnaApiService],
})
export class PnaApiModule { }
