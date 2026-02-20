import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, Res, Query } from '@nestjs/common';
import { Response } from 'express';
import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('catalogos/observadores')
@Auth()
export class ObservadoresController {
    constructor(private readonly observadoresService: ObservadoresService) { }

    @Post()
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    crear(@Body() createObservadorDto: CreateObservadorDto) {
        return this.observadoresService.crear(createObservadorDto);
    }

    @Get()
    obtenerTodos(@Query('soloDisponibles') soloDisponibles?: string) {
        return this.observadoresService.obtenerTodos(soloDisponibles === 'true');
    }

    @Post('export/excel')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    async exportExcel(
        @Body('searchQuery') searchQuery: string,
        @Res() res: Response
    ) {
        const workbook = await this.observadoresService.exportToExcel(searchQuery);

        res.setHeader(
            'Content-Type',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        );
        res.setHeader(
            'Content-Disposition',
            `attachment; filename=OBSERVADORES.xlsx`,
        );

        await workbook.xlsx.write(res);
        res.end();
    }

    @Get(':id')
    obtenerUno(@Param('id', ParseUUIDPipe) id: string) {
        return this.observadoresService.obtenerUno(id);
    }

    @Get(':id/historial/:year')
    obtenerHistorial(
        @Param('id', ParseUUIDPipe) id: string,
        @Param('year') year: string
    ) {
        return this.observadoresService.obtenerHistorial(id, parseInt(year));
    }

    @Patch(':id')
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    actualizar(
        @Param('id', ParseUUIDPipe) id: string,
        @Body() updateObservadorDto: UpdateObservadorDto,
    ) {
        return this.observadoresService.actualizar(id, updateObservadorDto);
    }

    @Delete(':id')
    @Auth(ValidRoles.admin)
    eliminar(@Param('id', ParseUUIDPipe) id: string) {
        return this.observadoresService.eliminar(id);
    }
}
