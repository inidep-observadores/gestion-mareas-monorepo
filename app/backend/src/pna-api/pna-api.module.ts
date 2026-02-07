import { Module } from '@nestjs/common';
import { PnaApiService } from './pna-api.service';
import { PnaApiParser } from './pna-api.parser';
import { PrismaModule } from '../prisma/prisma.module';
import { AlertsModule } from '../alerts/alerts.module';

@Module({
    imports: [PrismaModule, AlertsModule],
    providers: [PnaApiService, PnaApiParser],
    exports: [PnaApiService],
})
export class PnaApiModule { }
