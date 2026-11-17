import { Module } from '@nestjs/common';
import { FeriadosService } from './feriados.service';
import { FeriadosController } from './feriados.controller';
import { AuthModule } from '../../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [FeriadosController],
  providers: [FeriadosService],
  exports: [FeriadosService],
})
export class FeriadosModule {}
