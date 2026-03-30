import { Module } from '@nestjs/common';
import { StatsService } from './stats.service';
import { StatsController } from './stats.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';
import { PlanificacionModule } from '../planificacion/planificacion.module';
import { BusinessRulesModule } from '../common/business-rules/business-rules.module';
import { MareasModule } from '../mareas/mareas.module';

@Module({
    imports: [PrismaModule, AuthModule, PlanificacionModule, BusinessRulesModule, MareasModule],
    controllers: [StatsController],
    providers: [StatsService],
    exports: [StatsService],
})
export class StatsModule { }
