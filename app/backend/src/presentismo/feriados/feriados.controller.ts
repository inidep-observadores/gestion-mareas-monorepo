import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Put,
  ParseIntPipe,
  Query,
} from '@nestjs/common';
import { FeriadosService } from './feriados.service';
import { CreateFeriadoDto } from './dto/create-feriado.dto';

@Controller('feriados')
export class FeriadosController {
  constructor(private readonly feriadosService: FeriadosService) {}

  @Post('sincronizar/:anio')
  sincronizarConApi(@Param('anio', ParseIntPipe) anio: number) {
    return this.feriadosService.sincronizarConApi(anio);
  }

  @Post()
  create(@Body() createFeriadoDto: CreateFeriadoDto) {
    return this.feriadosService.create(createFeriadoDto);
  }

  @Get()
  findAll(@Query('anio') anio?: string) {
    if (anio) {
      return this.feriadosService.findByYear(parseInt(anio, 10));
    }
    return this.feriadosService.findAll();
  }

  @Put(':fecha')
  update(@Param('fecha') fecha: string, @Body() updateFeriadoDto: Partial<CreateFeriadoDto>) {
    return this.feriadosService.update(fecha, updateFeriadoDto);
  }

  @Delete(':fecha')
  remove(@Param('fecha') fecha: string) {
    return this.feriadosService.delete(fecha);
  }
}
