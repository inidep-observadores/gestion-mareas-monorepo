import { Controller, Get, Post, Body, Put, Param, Delete, Query } from '@nestjs/common';
import { NovedadesService } from './novedades.service';
import { CreateNovedadDto } from './dto/create-novedad.dto';
import { UpdateNovedadDto } from './dto/update-novedad.dto';
import { Auth, GetUser } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';
import { User } from '@prisma/client';

@Controller('presentismo/novedades')
@Auth(ValidRoles.admin, ValidRoles.tecnico)
export class NovedadesController {
  constructor(private readonly novedadesService: NovedadesService) {}

  @Post()
  create(@Body() createNovedadDto: CreateNovedadDto, @GetUser() user: User) {
    return this.novedadesService.create(createNovedadDto, user);
  }

  @Get()
  findAll(
    @Query('observadorId') observadorId?: string,
    @Query('estadoAprobacion') estadoAprobacion?: string
  ) {
    return this.novedadesService.findAll(observadorId, estadoAprobacion);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.novedadesService.findOne(id);
  }

  @Put(':id')
  update(
    @Param('id') id: string, 
    @Body() updateNovedadDto: UpdateNovedadDto,
    @GetUser() user: User
  ) {
    return this.novedadesService.update(id, updateNovedadDto, user);
  }

  @Delete(':id')
  remove(@Param('id') id: string, @GetUser() user: User) {
    return this.novedadesService.remove(id, user);
  }
}
