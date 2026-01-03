import { Controller, Post, Get, Res, UploadedFile, UseInterceptors, Param, BadRequestException } from '@nestjs/common';
import { DataExportService } from './data-export.service';
import { Response } from 'express';
import { FileInterceptor } from '@nestjs/platform-express';
import { Express } from 'express';

@Controller('admin/data-export')
export class DataExportController {
    constructor(private readonly dataExportService: DataExportService) { }

    @Post()
    async generateExport() {
        return this.dataExportService.generateExport();
    }

    @Get()
    async listExports() {
        return this.dataExportService.listExports();
    }

    @Get(':filename')
    async downloadExport(@Param('filename') filename: string, @Res() res: Response) {
        const filePath = await this.dataExportService.getExportFilePath(filename);
        res.download(filePath);
    }

    @Post('import')
    @UseInterceptors(FileInterceptor('file', { dest: './uploads/temp' }))
    async importData(@UploadedFile() file: Express.Multer.File) {
        if (!file) throw new BadRequestException('File is required');
        return this.dataExportService.importData(file.path);
    }
}
