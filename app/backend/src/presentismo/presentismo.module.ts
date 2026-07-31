import { Module } from '@nestjs/common';
import { FeriadosModule } from './feriados/feriados.module';
import { PresentismoController } from './presentismo.controller';
import { PresentismoService } from './presentismo.service';
import { PrismaModule } from '../prisma/prisma.module';
import { NovedadesModule } from './novedades/novedades.module';

@Module({
  imports: [FeriadosModule, NovedadesModule, PrismaModule],
  controllers: [PresentismoController],
  providers: [PresentismoService]
})
export class PresentismoModule {}
