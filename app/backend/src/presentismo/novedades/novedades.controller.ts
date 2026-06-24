import { Controller, Get, Post, Body, Put, Param, Delete, Query, UseGuards, Req } from '@nestjs/common';
import { NovedadesService } from './novedades.service';
import { CreateNovedadDto } from './dto/create-novedad.dto';
import { UpdateNovedadDto } from './dto/update-novedad.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';

@Controller('presentismo/novedades')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('ADMIN', 'COORDINADOR')
export class NovedadesController {
  constructor(private readonly novedadesService: NovedadesService) {}

  @Post()
  create(@Body() createNovedadDto: CreateNovedadDto, @Req() req: any) {
    return this.novedadesService.create(createNovedadDto, req.user);
  }

  @Get()
  findAll(@Query('observadorId') observadorId?: string) {
    return this.novedadesService.findAll(observadorId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.novedadesService.findOne(id);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateNovedadDto: UpdateNovedadDto) {
    return this.novedadesService.update(id, updateNovedadDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.novedadesService.remove(id);
  }
}
