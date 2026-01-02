import { Controller, Post, Get, Body, Param, Delete } from '@nestjs/common';
import { BackupService } from './backup.service';
import { Auth } from '../../auth/decorators';
import { ValidRoles } from '../../auth/interfaces';

@Controller('admin/backup')
@Auth(ValidRoles.admin)
export class BackupController {
    constructor(private readonly backupService: BackupService) { }

    @Post()
    createBackup() {
        return this.backupService.createBackup();
    }

    @Get('status')
    getStatus() {
        return this.backupService.getStatus();
    }

    @Get()
    listBackups() {
        return this.backupService.listBackups();
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
