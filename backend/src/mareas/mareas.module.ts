import { Module } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { MareasController } from './mareas.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { AlertsModule } from '../alerts/alerts.module';
import { BusinessRulesModule } from '../common/business-rules/business-rules.module';

@Module({
    controllers: [MareasController],
    providers: [MareasService],
    imports: [PrismaModule, AuthModule, AlertsModule, BusinessRulesModule],
    exports: [MareasService],
})
export class MareasModule { }
