import { Controller, Post, UploadedFile, UseInterceptors, Logger } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { AccessImportService } from './access-import.service';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';

@Controller('access-import')
@Auth(ValidRoles.admin) // Restringido a administradores como pidió el usuario
export class AccessImportController {
    private readonly logger = new Logger(AccessImportController.name);

    constructor(private readonly importService: AccessImportService) { }

    @Post('upload')
    @UseInterceptors(FileInterceptor('file'))
    async uploadFile(@UploadedFile() file: Express.Multer.File) {
        if (!file) {
            throw new Error('No se ha subido ningún archivo.');
        }

        this.logger.log(`Recibido archivo para importación: ${file.originalname} (${file.size} bytes)`);

        // Soporta .accdb y .mdb (vía mdb-reader)
        // El usuario mencionó que se sube el .accdb directamente
        const summary = await this.importService.processFile(file.buffer);

        return {
            message: 'Archivo procesado exitosamente',
            summary,
        };
    }
}
