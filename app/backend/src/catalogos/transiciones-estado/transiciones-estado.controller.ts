import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { TransicionesEstadoService } from './transiciones-estado.service';
import { CreateTransicionEstadoDto, UpdateTransicionEstadoDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/transiciones-estado')
@Auth()
export class TransicionesEstadoController {
    constructor(private readonly transicionesEstadoService: TransicionesEstadoService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() dto: CreateTransicionEstadoDto) {
        return this.transicionesEstadoService.crear(dto);
    }

    @Get()
    obtenerTodos() {
        return this.transicionesEstadoService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.transicionesEstadoService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() dto: UpdateTransicionEstadoDto,
    ) {
        return this.transicionesEstadoService.actualizar(id, dto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.transicionesEstadoService.eliminar(id);
    }
}
