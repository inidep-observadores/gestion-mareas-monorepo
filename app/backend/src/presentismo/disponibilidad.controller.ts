import { Controller, Get, Query, ParseIntPipe, BadRequestException } from '@nestjs/common';
import { DisponibilidadService } from './disponibilidad.service';
import { DisponibilidadResponseDto } from './dto/disponibilidad-response.dto';

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
}
