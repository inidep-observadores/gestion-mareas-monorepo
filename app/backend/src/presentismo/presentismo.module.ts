import { Module } from '@nestjs/common';
import { FeriadosModule } from './feriados/feriados.module';
import { PresentismoController } from './presentismo.controller';
import { PresentismoService } from './presentismo.service';
import { DisponibilidadController } from './disponibilidad.controller';
import { DisponibilidadService } from './disponibilidad.service';
import { PrismaModule } from '../prisma/prisma.module';
import { NovedadesModule } from './novedades/novedades.module';

@Module({
  imports: [FeriadosModule, NovedadesModule, PrismaModule],
  controllers: [PresentismoController, DisponibilidadController],
  providers: [PresentismoService, DisponibilidadService],
  exports: [PresentismoService, DisponibilidadService],
})
export class PresentismoModule {}

