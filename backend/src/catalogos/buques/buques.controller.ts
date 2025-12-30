import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe } from '@nestjs/common';
import { BuquesService } from './buques.service';
import { CreateBuqueDto, UpdateBuqueDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/catalogos/buques')
@Auth(ValidRoles.admin)
export class BuquesController {
    constructor(private readonly buquesService: BuquesService) { }

    @Post()
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
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateBuqueDto: UpdateBuqueDto,
    ) {
        return this.buquesService.actualizar(id, updateBuqueDto);
    }

    @Delete(':id')
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.buquesService.eliminar(id);
    }
}
