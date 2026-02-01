import { Controller, Post, Get, Body, Param, Delete, Res, UseInterceptors, UploadedFile } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { Response } from 'express';
import { BackupService } from './backup.service';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/backup')
@Auth(ValidRoles.admin)
export class BackupController {
    constructor(private readonly backupService: BackupService) { }

    @Post()
    createBackup(
        @Body('comment') comment?: string,
        @Body('includeTrajectories') includeTrajectories?: boolean
    ) {
        return this.backupService.createBackup(comment, includeTrajectories);
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
        @Res() res: Response
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
    ) {
        return this.backupService.restoreBackup(filename, confirmationPhrase);
    }

    @Delete(':filename')
    deleteBackup(@Param('filename') filename: string) {
        return this.backupService.deleteBackup(filename);
    }
}
