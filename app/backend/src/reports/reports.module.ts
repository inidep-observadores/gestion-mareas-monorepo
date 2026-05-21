/**
 * Módulo de generación de informes.
 *
 * Centraliza la lógica de generación de documentos Word (.docx)
 * para que pueda ser reutilizado por cualquier módulo del sistema.
 */
import { Module } from '@nestjs/common';
import { ReportsService } from './reports.service';
import { DocxChartService } from './docx/docx-charts';
import { AuditReportBuilder } from './templates/audit-report.builder';
import { ReportsController } from './reports.controller';
import { StatsModule } from '../stats/stats.module';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { ConversionService } from './conversion.service';

@Module({
    imports: [StatsModule, PrismaModule, AuthModule],
    controllers: [ReportsController],
    providers: [
        ReportsService,
        DocxChartService,
        AuditReportBuilder,
        ConversionService,
    ],
    exports: [ReportsService],
})
export class ReportsModule {}
