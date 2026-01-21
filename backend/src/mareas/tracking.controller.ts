
import { Controller, Post, Get, Param, UseInterceptors, UploadedFile, ParseFilePipeBuilder, HttpStatus } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { TrackingService } from './tracking.service';

@Controller('tracking')
export class TrackingController {
    constructor(private readonly trackingService: TrackingService) { }

    @Post('upload')
    @UseInterceptors(FileInterceptor('file'))
    async uploadFile(
        @UploadedFile(
            new ParseFilePipeBuilder()
                .addFileTypeValidator({
                    fileType: 'csv|text/csv',
                })
                .build({
                    errorHttpStatusCode: HttpStatus.UNPROCESSABLE_ENTITY,
                }),
        )
        file: Express.Multer.File,
    ) {
        return this.trackingService.importTrackingData(file.buffer);
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
