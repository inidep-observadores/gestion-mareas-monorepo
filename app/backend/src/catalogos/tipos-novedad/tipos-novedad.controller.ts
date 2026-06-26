import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { TiposNovedadService } from './tipos-novedad.service';
import { CreateTipoNovedadDto } from './dto/create-tipo-novedad.dto';
import { UpdateTipoNovedadDto } from './dto/update-tipo-novedad.dto';
import { Auth } from '../../auth/decorators';

@Auth()
@Controller('catalogos/tipos-novedad')
export class TiposNovedadController {
    constructor(private readonly tiposNovedadService: TiposNovedadService) {}

    @Post()
    create(@Body() createTipoNovedadDto: CreateTipoNovedadDto) {
        return this.tiposNovedadService.create(createTipoNovedadDto);
    }

    @Get()
    findAll() {
        return this.tiposNovedadService.findAll();
    }

    @Get('activos')
    findActivos() {
        return this.tiposNovedadService.findActivos();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.tiposNovedadService.findOne(id);
    }

    @Patch(':id')
    update(@Param('id') id: string, @Body() updateTipoNovedadDto: UpdateTipoNovedadDto) {
        return this.tiposNovedadService.update(id, updateTipoNovedadDto);
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.tiposNovedadService.remove(id);
    }
}
