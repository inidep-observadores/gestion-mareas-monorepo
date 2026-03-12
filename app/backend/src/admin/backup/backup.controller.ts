import { Controller, Post, Get, Body, Param, Delete, Res, UseInterceptors, UploadedFile } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { BackupService, BackupSchema } from './backup.service';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/backup')
@Auth(ValidRoles.admin)
export class BackupController {
    constructor(private readonly backupService: BackupService) { }

    @Post()
    createBackup(
        @Body('comment') comment?: string,
        @Body('schemas') schemas?: BackupSchema[],
    ) {
        // Disparar el proceso en background para no bloquear la respuesta HTTP.
        // El cliente realiza polling de GET /admin/backup para detectar el nuevo archivo.
        this.backupService.createBackup(comment, schemas).catch(() => {
            // Silenciar: el error ya fue logeado en el servicio.
        });
        return { message: 'Proceso de copia de seguridad iniciado. Actualizando la lista automáticamente...' };
    }


    @Get('status')
    getStatus() {
        return this.backupService.getStatus();
    }

    @Get()
    listBackups() {
        return this.backupService.listBackups();
    }

    @Get('download/:filename')
    async downloadBackup(
        @Param('filename') filename: string,
        @Res() res: Response,
    ) {
        await this.backupService.createBackupZip(filename, res);
    }

    @Post('upload')
    @UseInterceptors(FileInterceptor('file'))
    uploadBackup(@UploadedFile() file: Express.Multer.File) {
        return this.backupService.uploadBackup(file);
    }

    @Post('restore/:filename')
    restoreBackup(
        @Param('filename') filename: string,
        @Body('confirmationPhrase') confirmationPhrase: string,
        @Body('schemas') schemasToRestore?: BackupSchema[],
    ) {
        return this.backupService.restoreBackup(filename, confirmationPhrase, schemasToRestore);
    }

    @Delete(':filename')
    deleteBackup(@Param('filename') filename: string) {
        return this.backupService.deleteBackup(filename);
    }
}
