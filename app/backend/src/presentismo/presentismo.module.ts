import { Module } from '@nestjs/common';
import { FeriadosModule } from './feriados/feriados.module';
import { PresentismoController } from './presentismo.controller';
import { PresentismoService } from './presentismo.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [FeriadosModule, PrismaModule],
  controllers: [PresentismoController],
  providers: [PresentismoService]
})
export class PresentismoModule {}
