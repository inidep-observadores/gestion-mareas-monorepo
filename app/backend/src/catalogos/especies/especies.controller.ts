import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { EspeciesService } from './especies.service';
import { CreateEspecieDto, UpdateEspecieDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/especies')
@Auth()
export class EspeciesController {
    constructor(private readonly especiesService: EspeciesService) { }

    @Post()
    @Auth(ValidRoles.admin)
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
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateEspecieDto: UpdateEspecieDto,
    ) {
        return this.especiesService.actualizar(id, updateEspecieDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.especiesService.eliminar(id);
    }
}
