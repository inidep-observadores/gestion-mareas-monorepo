import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/catalogos/observadores')
@Auth(ValidRoles.admin)
export class ObservadoresController {
    constructor(private readonly observadoresService: ObservadoresService) { }

    @Post()
    crear(@Body() createObservadorDto: CreateObservadorDto) {
        return this.observadoresService.crear(createObservadorDto);
    }

    @Get()
    obtenerTodos() {
        return this.observadoresService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.observadoresService.obtenerUno(id);
    }

    @Patch(':id')
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateObservadorDto: UpdateObservadorDto,
    ) {
        return this.observadoresService.actualizar(id, updateObservadorDto);
    }

    @Delete(':id')
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.observadoresService.eliminar(id);
    }
}
