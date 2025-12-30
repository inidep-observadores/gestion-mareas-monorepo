import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { EstadosMareaService } from './estados-marea.service';
import { CreateEstadoMareaDto, UpdateEstadoMareaDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/estados-marea')
@Auth()
export class EstadosMareaController {
    constructor(private readonly estadosMareaService: EstadosMareaService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createEstadoMareaDto: CreateEstadoMareaDto) {
        return this.estadosMareaService.crear(createEstadoMareaDto);
    }

    @Get()
    obtenerTodos() {
        return this.estadosMareaService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.estadosMareaService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateEstadoMareaDto: UpdateEstadoMareaDto,
    ) {
        return this.estadosMareaService.actualizar(id, updateEstadoMareaDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.estadosMareaService.eliminar(id);
    }
}
