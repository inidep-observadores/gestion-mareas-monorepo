import { Controller, Get, Param, ParseIntPipe, Post, Body, Query, Put, Delete, Res, HttpException, HttpStatus } from '@nestjs/common';
import { Response } from 'express';
import { PlanificacionService } from './planificacion.service';
import { BatchUpsertRequerimientosDto } from './dto/requerimientos.dto';
import { BatchUpsertExperienciaDto } from './dto/experiencia.dto';
import { Auth, GetUser } from '../auth/decorators';
import { ValidRoles, JwtPayload } from '../auth/interfaces';
import { CreateEscenarioDto, UpdateEscenarioDto, CloneEscenarioDto, ExportEscenarioDto, AdquirirLockDto } from './dto/escenarios.dto';

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

  @Get('experiencia-observadores/pesqueria/:pesqueriaId')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getExperienciaPorPesqueria(@Param('pesqueriaId') pesqueriaId: string) {
    return this.planificacionService.getExperienciaPorPesqueria(pesqueriaId);
  }

  @Get('experiencia-observadores/:observadorId/mareas')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getDetalleMareasExperiencia(
    @Param('observadorId') observadorId: string,
    @Query('pesqueriaId') pesqueriaId: string,
  ) {
    return this.planificacionService.getDetalleMareasExperiencia(observadorId, pesqueriaId);
  }

  @Post('experiencia-observadores')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async upsertExperienciaObservadores(@Body() dto: BatchUpsertExperienciaDto) {
    return this.planificacionService.upsertExperienciaObservadoresBatch(dto);
  }

  @Get('simulador/eventos')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async obtenerEventosSimulador(
    @Query('year') yearParam?: string,
    @Query('month') monthParam?: string,
    @Query('horizonMonths') horizonParam?: string,
  ) {
    const year = yearParam ? parseInt(yearParam, 10) : new Date().getFullYear();
    const month = monthParam ? parseInt(monthParam, 10) : new Date().getMonth() + 1;
    const horizon = horizonParam ? parseInt(horizonParam, 10) : 6;
    return this.planificacionService.obtenerEventosSimulador(year, month, horizon);
  }

  @Get('simulador/escenarios/:anio')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getEscenarios(@Param('anio', ParseIntPipe) anio: number) {
    return this.planificacionService.getEscenariosPorAnio(anio);
  }

  @Get('simulador/escenario/:id')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async getEscenario(@Param('id') id: string) {
    return this.planificacionService.getEscenario(id);
  }

  @Post('simulador/escenarios')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async createEscenario(@Body() dto: CreateEscenarioDto) {
    return this.planificacionService.createEscenario(dto);
  }

    @Put('simulador/escenarios/:id')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async updateEscenario(
    @Param('id') id: string, 
    @Body() dto: UpdateEscenarioDto,
    @GetUser() user: JwtPayload
  ) {
    if (dto.tabId) {
      await this.planificacionService.validateLockForUpdate(id, user.id, dto.tabId);
    }
    return this.planificacionService.updateEscenario(id, dto);
  }

  @Post('simulador/escenarios/:id/clonar')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async cloneEscenario(@Param('id') id: string, @Body() dto: CloneEscenarioDto) {
    return this.planificacionService.cloneEscenario(id, dto);
  }


  @Post('simulador/escenarios/:id/lock')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async adquirirLock(
    @Param('id') id: string,
    @Body() dto: AdquirirLockDto,
    @GetUser() user: JwtPayload,
  ) {
    const result = await this.planificacionService.adquirirLock(id, user.id, user.nombre || user.email, dto.tabId);
    if (!result.success) {
      throw new HttpException(
        { message: `El escenario está siendo modificado por ${result.lockedBy}.`, lockedBy: result.lockedBy },
        HttpStatus.LOCKED,
      );
    }
    return { success: true };
  }

  @Delete('simulador/escenarios/:id/lock')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async liberarLock(
    @Param('id') id: string,
    @Query('tabId') tabId: string,
    @GetUser() user: JwtPayload,
  ) {
    if (!tabId) return { success: true }; // ignore if no tabId
    await this.planificacionService.liberarLock(id, user.id, tabId);
    return { success: true };
  }

  @Delete('simulador/escenarios/:id')
  @Auth(ValidRoles.admin, ValidRoles.planificador)
  async deleteEscenario(@Param('id') id: string) {
    return this.planificacionService.deleteEscenario(id);
  }

  @Post('simulador/escenarios/:id/export/excel')
  @Auth(ValidRoles.admin, ValidRoles.planificador, ValidRoles.coordinador)
  async exportEscenarioToExcel(@Param('id') id: string, @Body() dto: ExportEscenarioDto, @Res() res: Response) {
    const buffer = await this.planificacionService.exportarEscenarioExcel(id, dto);
    
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', `attachment; filename=planificacion_${id}.xlsx`);
    
    res.end(buffer);
  }
}
