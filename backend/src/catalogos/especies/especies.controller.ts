import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { EspeciesService } from './especies.service';
import { CreateEspecieDto, UpdateEspecieDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/catalogos/especies')
@Auth(ValidRoles.admin)
export class EspeciesController {
    constructor(private readonly especiesService: EspeciesService) { }

    @Post()
    crear(@Body() createEspecieDto: CreateEspecieDto) {
        return this.especiesService.crear(createEspecieDto);
    }

    @Get()
    obtenerTodos() {
        return this.especiesService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.especiesService.obtenerUno(id);
    }

    @Patch(':id')
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateEspecieDto: UpdateEspecieDto,
    ) {
        return this.especiesService.actualizar(id, updateEspecieDto);
    }

    @Delete(':id')
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.especiesService.eliminar(id);
    }
}
