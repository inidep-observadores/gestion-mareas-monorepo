import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { BuquesService } from './buques.service';
import { CreateBuqueDto, UpdateBuqueDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/buques')
@Auth()
export class BuquesController {
    constructor(private readonly buquesService: BuquesService) { }

    @Post()
    @Auth(ValidRoles.admin)
    crear(@Body() createBuqueDto: CreateBuqueDto) {
        return this.buquesService.crear(createBuqueDto);
    }

    @Get()
    obtenerTodos() {
        return this.buquesService.obtenerTodos();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.buquesService.obtenerUno(id);
    }

    @Patch(':id')
    @Auth(ValidRoles.admin)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateBuqueDto: UpdateBuqueDto,
    ) {
        return this.buquesService.actualizar(id, updateBuqueDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.buquesService.eliminar(id);
    }
}
