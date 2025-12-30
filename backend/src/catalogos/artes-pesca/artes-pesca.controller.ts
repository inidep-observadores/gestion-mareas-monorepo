import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { ArtesPescaService } from './artes-pesca.service';
import { CreateArtePescaDto, UpdateArtePescaDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/artes-pesca')
@Auth()
export class ArtesPescaController {
    constructor(private readonly artesPescaService: ArtesPescaService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createArtePescaDto: CreateArtePescaDto) {
        return this.artesPescaService.crear(createArtePescaDto);
    }

    @Get()
    obtenerTodos() {
        return this.artesPescaService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.artesPescaService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateArtePescaDto: UpdateArtePescaDto,
    ) {
        return this.artesPescaService.actualizar(id, updateArtePescaDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.artesPescaService.eliminar(id);
    }
}
