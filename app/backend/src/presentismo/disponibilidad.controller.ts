import { Controller, Get, Post, Body, Res, Query, BadRequestException } from '@nestjs/common';
import { Response } from 'express';
import { DisponibilidadService } from './disponibilidad.service';
import { DisponibilidadResponseDto } from './dto/disponibilidad-response.dto';
import { ExportarDisponibilidadExcelDto } from './dto/exportar-disponibilidad-excel.dto';

@Controller('presentismo/disponibilidad')
export class DisponibilidadController {
  constructor(private readonly disponibilidadService: DisponibilidadService) {}

  @Get()
  async obtenerDisponibilidad(
    @Query('horizonte') horizonteParam?: string,
  ): Promise<DisponibilidadResponseDto> {
    let horizonte = 6;
    if (horizonteParam) {
      const parsed = parseInt(horizonteParam, 10);
      if (isNaN(parsed) || parsed < 1 || parsed > 12) {
        throw new BadRequestException('El parámetro horizonte debe ser un número entero entre 1 y 12');
      }
      horizonte = parsed;
    }

    return this.disponibilidadService.obtenerDisponibilidad(horizonte);
  }

  @Post('export/excel')
  async exportarExcel(
    @Body() dto: ExportarDisponibilidadExcelDto,
    @Res() res: Response,
  ) {
    if (!dto.fechaDesde || !dto.fechaHasta) {
      throw new BadRequestException('Faltan parámetros fechaDesde y fechaHasta');
    }

    const workbook = await this.disponibilidadService.exportarAExcel(
      dto.fechaDesde,
      dto.fechaHasta,
      dto.observadorIds,
    );

    res.setHeader(
      'Content-Type',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
    const cleanIni = dto.fechaDesde.includes('T') ? dto.fechaDesde.split('T')[0] : dto.fechaDesde;
    const cleanFin = dto.fechaHasta.includes('T') ? dto.fechaHasta.split('T')[0] : dto.fechaHasta;
    const filename = `DISPONIBILIDAD_OBSERVADORES_${cleanIni}_a_${cleanFin}.xlsx`;
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    await workbook.xlsx.write(res);
    res.end();
  }
}
