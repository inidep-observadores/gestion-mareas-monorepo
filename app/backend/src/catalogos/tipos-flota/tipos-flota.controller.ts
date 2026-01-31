import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { TiposFlotaService } from './tipos-flota.service';
import { CreateTipoFlotaDto, UpdateTipoFlotaDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/tipos-flota')
@Auth()
export class TiposFlotaController {
    constructor(private readonly tiposFlotaService: TiposFlotaService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createTipoFlotaDto: CreateTipoFlotaDto) {
        return this.tiposFlotaService.crear(createTipoFlotaDto);
    }

    @Get()
    obtenerTodos() {
        return this.tiposFlotaService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.tiposFlotaService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateTipoFlotaDto: UpdateTipoFlotaDto,
    ) {
        return this.tiposFlotaService.actualizar(id, updateTipoFlotaDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.tiposFlotaService.eliminar(id);
    }
}
