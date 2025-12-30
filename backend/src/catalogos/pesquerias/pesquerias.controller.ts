import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { PesqueriasService } from './pesquerias.service';
import { CreatePesqueriaDto, UpdatePesqueriaDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/pesquerias')
@Auth()
export class PesqueriasController {
    constructor(private readonly pesqueriasService: PesqueriasService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createPesqueriaDto: CreatePesqueriaDto) {
        return this.pesqueriasService.crear(createPesqueriaDto);
    }

    @Get()
    obtenerTodos() {
        return this.pesqueriasService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.pesqueriasService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updatePesqueriaDto: UpdatePesqueriaDto,
    ) {
        return this.pesqueriasService.actualizar(id, updatePesqueriaDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.pesqueriasService.eliminar(id);
    }
}
