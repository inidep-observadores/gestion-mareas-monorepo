import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, Res } from '@nestjs/common';
import { Response } from 'express';
import { BuquesService } from './buques.service';
import { VesselExportService } from './vessel-export.service';
import { CreateBuqueDto, UpdateBuqueDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/buques')
@Auth()
export class BuquesController {
    constructor(
        private readonly buquesService: BuquesService,
        private readonly vesselExportService: VesselExportService,
    ) { }

    @Get('export/dbf')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    async exportarDbf(@Res() res: Response) {
        const buffer = await this.vesselExportService.exportToDbf();
        
        res.set({
            'Content-Type': 'application/x-dbf',
            'Content-Disposition': 'attachment; filename="BUQUES.DBF"',
            'Content-Length': buffer.length,
        });
        
        res.send(buffer);
    }

    @Post()
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
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
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
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
