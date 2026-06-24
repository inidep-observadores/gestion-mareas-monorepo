import { Controller, Get, Query, ParseIntPipe, BadRequestException } from '@nestjs/common';
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
}
