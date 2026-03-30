import { Module } from '@nestjs/common';
import { PlanificacionService } from './planificacion.service';
import { PlanificacionController } from './planificacion.controller';
import { PrismaModule } from '../prisma/prisma.module';
import { AuthModule } from '../auth/auth.module';

@Module({
  imports: [PrismaModule, AuthModule],
  providers: [PlanificacionService],
  controllers: [PlanificacionController],
  exports: [PlanificacionService]
})
export class PlanificacionModule {}
