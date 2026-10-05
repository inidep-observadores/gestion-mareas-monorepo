import { Controller, Get, Post, Body, Patch, Param, Delete, ParseUUIDPipe, Res, Query } from '@nestjs/common';
import { Response } from 'express';
import { ObservadoresService } from './observadores.service';
import { CreateObservadorDto, UpdateObservadorDto } from './dto';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';
import { DriveStorageService } from '../../files/drive-storage.service';
import { ConversionService } from '../../reports/conversion.service';

@Controller('catalogos/observadores')
@Auth()
export class ObservadoresController {
    constructor(
        private readonly observadoresService: ObservadoresService,
        private readonly driveStorageService: DriveStorageService,
        private readonly conversionService: ConversionService
    ) { }

    @Post()
    @Auth(ValidRoles.admin, ValidRoles.tecnico)
    crear(@Body() createObservadorDto: CreateObservadorDto) {
        return this.observadoresService.crear(createObservadorDto);
    }

    @Get()
    obtenerTodos(
        @Query('soloDisponibles') soloDisponibles?: string,
        @Query('incluirInactivos') incluirInactivos?: string
    ) {
        return this.observadoresService.obtenerTodos(
            soloDisponibles === 'true',
            incluirInactivos === 'true'
        );
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

    @Get(':id/historial')
    @Get(':id/historial/:year')
    obtenerHistorial(
        @Param('id', ParseUUIDPipe) id: string,
        @Param('year') year?: string
    ) {
        const parsedYear = year ? parseInt(year) : 0;
        return this.observadoresService.obtenerHistorial(id, parsedYear);
    }

    @Get(':id/archivos')
    obtenerArchivos(@Param('id', ParseUUIDPipe) id: string) {
        return this.observadoresService.obtenerArchivos(id);
    }

    @Get('archivos/:archivoId/preview-pdf')
    async previewPdf(
        @Param('archivoId', ParseUUIDPipe) archivoId: string,
        @Res() res: Response
    ) {
        try {
            const driveFileId = await this.observadoresService.getArchivoDriveId(archivoId);
            const docxBuffer = await this.driveStorageService.downloadFile(driveFileId);
            const pdfBuffer = await this.conversionService.convertDocxToPdf(docxBuffer, `preview-${archivoId}.pdf`);
            
            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader('Content-Disposition', `inline; filename="preview-${archivoId}.pdf"`);
            res.send(pdfBuffer);
        } catch (error) {
            res.status(500).json({ statusCode: 500, message: 'Error al previsualizar el archivo', error: error.message });
        }
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
