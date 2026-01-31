import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { PuertosService } from './puertos.service';
import { CreatePuertoDto, UpdatePuertoDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/puertos')
@Auth()
export class PuertosController {
    constructor(private readonly puertosService: PuertosService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createPuertoDto: CreatePuertoDto) {
        return this.puertosService.crear(createPuertoDto);
    }

    @Get()
    obtenerTodos() {
        return this.puertosService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.puertosService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updatePuertoDto: UpdatePuertoDto,
    ) {
        return this.puertosService.actualizar(id, updatePuertoDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.puertosService.eliminar(id);
    }
}
