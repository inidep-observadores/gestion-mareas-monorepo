import { Module } from '@nestjs/common';
import { MareasService } from './mareas.service';
import { MareasController } from './mareas.controller';
import { TrackingService } from './tracking.service';
import { TrackingController } from './tracking.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { AlertsModule } from '../alerts/alerts.module';
import { CatalogosModule } from '../catalogos/catalogos.module';
import { BusinessRulesModule } from '../common/business-rules/business-rules.module';
import { ConfigModule } from '@nestjs/config';
import { CommonModule } from '../common/common.module';
import { EventCorrelationService } from '../common/services/event-correlation.service';

@Module({
    controllers: [MareasController, TrackingController],
    providers: [MareasService, TrackingService, EventCorrelationService],
    imports: [PrismaModule, AuthModule, AlertsModule, CatalogosModule, BusinessRulesModule, ConfigModule, CommonModule],
    exports: [MareasService, TrackingService],
})

export class MareasModule { }
