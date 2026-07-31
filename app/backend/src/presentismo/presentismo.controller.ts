import { Controller, Get, Query, ParseIntPipe, BadRequestException, Post, Body, Res } from '@nestjs/common';
import { Response } from 'express';
import { PresentismoService } from './presentismo.service';
import { PlanillaMensualResponseDto } from './dto/planilla-mensual-response.dto';

@Controller('presentismo')
export class PresentismoController {
  constructor(private readonly presentismoService: PresentismoService) {}

  @Get('mensual')
  async obtenerPlanillaMensual(
    @Query('year') yearParam?: string,
    @Query('month') monthParam?: string,
  ): Promise<PlanillaMensualResponseDto> {
    const year = yearParam ? parseInt(yearParam, 10) : new Date().getFullYear();
    const month = monthParam ? parseInt(monthParam, 10) : new Date().getMonth() + 1;

    if (isNaN(year) || isNaN(month) || month < 1 || month > 12) {
      throw new BadRequestException('Parámetros de año y mes inválidos');
    }

    return this.presentismoService.obtenerPlanillaMensual(year, month);
  }

  @Post('export/excel')
  async exportToExcel(@Body() body: { year: number; month: number; ids?: string[] }, @Res() res: Response) {
    if (!body.year || !body.month) {
      throw new BadRequestException('Faltan parámetros año y mes');
    }
    const workbook = await this.presentismoService.exportToExcel(body.year, body.month, body.ids);
    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', `attachment; filename="PRESENTISMO_${body.year}_${body.month.toString().padStart(2, '0')}.xlsx"`);
    await workbook.xlsx.write(res);
    res.end();
  }
}
