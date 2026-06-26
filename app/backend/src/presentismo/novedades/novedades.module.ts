import { Module } from '@nestjs/common';
import { NovedadesService } from './novedades.service';
import { NovedadesController } from './novedades.controller';
import { AuthModule } from '../../auth/auth.module';

@Module({
  imports: [AuthModule],
  controllers: [NovedadesController],
  providers: [NovedadesService],
  exports: [NovedadesService]
})
export class NovedadesModule {}
