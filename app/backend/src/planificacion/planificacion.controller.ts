import { Controller, Get, Param, ParseIntPipe, Post, Body } from '@nestjs/common';
import { PlanificacionService } from './planificacion.service';
import { BatchUpsertRequerimientosDto } from './dto/requerimientos.dto';
import { BatchUpsertExperienciaDto } from './dto/experiencia.dto';
import { Auth } from '../auth/decorators';
import { ValidRoles } from '../auth/interfaces';

@Controller('planificacion')
@Auth()
export class PlanificacionController {
  constructor(private readonly planificacionService: PlanificacionService) {}

  @Get('requerimientos/:anio')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getRequerimientos(@Param('anio', ParseIntPipe) anio: number) {
    return this.planificacionService.getRequerimientosPorAnio(anio);
  }

  @Post('requerimientos')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async upsertRequerimientos(@Body() dto: BatchUpsertRequerimientosDto) {
    return this.planificacionService.upsertRequerimientosBatch(dto);
  }

  @Get('experiencia-observadores')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getExperienciaObservadores() {
    return this.planificacionService.getExperienciaObservadores();
  }

  @Post('experiencia-observadores')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async upsertExperienciaObservadores(@Body() dto: BatchUpsertExperienciaDto) {
    return this.planificacionService.upsertExperienciaObservadoresBatch(dto);
  }
}
