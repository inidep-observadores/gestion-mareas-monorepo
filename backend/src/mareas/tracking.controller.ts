
import { Controller, Post, Get, Param, UseInterceptors, UploadedFile, ParseFilePipeBuilder, HttpStatus, UnprocessableEntityException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { TrackingService } from './tracking.service';

@Controller('tracking')
export class TrackingController {
    constructor(private readonly trackingService: TrackingService) { }

    @Post('upload')
    @UseInterceptors(FileInterceptor('file'))
    async uploadFile(
        @UploadedFile() file: Express.Multer.File,
    ) {
        if (!file) {
            throw new UnprocessableEntityException('No se ha recibido ningún archivo');
        }

        console.log(`[TrackingController] Recibido: ${file.originalname}, Mime: ${file.mimetype}`);

        // Validación manual de tipo (más permisiva y con mensaje en español)
        const allowedTypes = ['text/csv', 'application/vnd.ms-excel', 'text/plain', 'application/octet-stream'];
        const isCsv = file.originalname.toLowerCase().endsWith('.csv');

        if (!allowedTypes.includes(file.mimetype) && !isCsv) {
            throw new UnprocessableEntityException('El archivo debe ser un CSV válido');
        }

        try {
            return await this.trackingService.importTrackingData(file.buffer);
        } catch (error) {
            console.error('[TrackingController] Error al importar:', error);
            throw new UnprocessableEntityException('Error al procesar el contenido del CSV. Verifique el formato.');
        }
    }

    @Get('heartbeat')
    async heartbeat() {
        return this.trackingService.checkHeartbeat();
    }

    @Get('fleet')
    async getFleet() {
        return this.trackingService.getLatestFleetPositions();
    }

    @Get('history/:buqueId')
    async getHistory(@Param('buqueId') buqueId: string) {
        return this.trackingService.getVesselHistory(buqueId);
    }
}
