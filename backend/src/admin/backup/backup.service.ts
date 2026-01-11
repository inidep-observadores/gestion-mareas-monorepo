import { Injectable, Logger, ConflictException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { execSync } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class BackupService {
    private readonly logger = new Logger(BackupService.name);
    private readonly backupPath: string;
    private readonly isConfigured: boolean;

    constructor(private configService: ConfigService) {
        const pathFromConfig = this.configService.get<string>('BACKUP_PATH');

        this.isConfigured = !!pathFromConfig;
        this.backupPath = pathFromConfig || './backups';

        if (!fs.existsSync(this.backupPath)) {
            fs.mkdirSync(this.backupPath, { recursive: true });
        }
    }

    getStatus() {
        return {
            isConfigured: this.isConfigured,
            backupPath: this.backupPath,
        };
    }

    async createBackup() {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        const filename = `BKP-${timestamp}.sql`;
        const filePath = path.join(this.backupPath, filename);

        const dbName = this.configService.get('DB_NAME');
        const dbUser = this.configService.get('DB_USERNAME');
        const dbPass = this.configService.get('DB_PASSWORD');
        const dbHost = this.configService.get('DB_HOST') || 'localhost';
        const dbPort = this.configService.get('DB_PORT') || '5432';

        try {
            // Usamos pg_dump directamente (postgresql-client instalado en Dockerfile)
            // Usamos PGPASSWORD para evitar el prompt interactivo de contraseña
            const command = `PGPASSWORD="${dbPass}" pg_dump -h ${dbHost} -p ${dbPort} -U ${dbUser} -d ${dbName} > "${filePath}"`;

            this.logger.log(`Executing backup: ${filename} on host ${dbHost}`);
            execSync(command);

            return {
                message: 'Backup created successfully',
                filename,
                path: filePath,
            };
        } catch (error) {
            this.logger.error(`Backup failed: ${error.message}`);
            throw new InternalServerErrorException('Backup creation failed');
        }
    }

    async listBackups() {
        try {
            const files = fs.readdirSync(this.backupPath);
            return files
                .filter(f => f.startsWith('BKP-') && f.endsWith('.sql'))
                .map(f => {
                    const stats = fs.statSync(path.join(this.backupPath, f));
                    return {
                        filename: f,
                        size: stats.size,
                        createdAt: stats.birthtime,
                    };
                })
                .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
        } catch (error) {
            this.logger.error(`Listing backups failed: ${error.message}`);
            throw new InternalServerErrorException('Failed to list backups');
        }
    }

    async restoreBackup(filename: string, confirmationPhrase: string) {
        const validPhrases = [
            'RESTAURAR BASE DE DATOS',
            'SOBREESCRIBIR DATOS ACTUALES',
            'ELIMINAR Y REEMPLAZAR TODO',
            'CONFIRMO SOBREESCRITURA TOTAL',
            'REEMPLAZAR BASE DE DATOS',
            'PERDER DATOS ACTUALES',
            'VOLVER A PUNTO ANTERIOR',
            'REINSTALAR COPIA SEGURIDAD',
            'BORRADO TOTAL Y RESTAURACION',
            'CARGAR COPIA EXTERNA'
        ];

        if (!validPhrases.includes(confirmationPhrase.toUpperCase().trim())) {
            throw new ConflictException('La frase de confirmación es incorrecta o no reconocida');
        }

        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new NotFoundException('Backup file not found');
        }

        const dbName = this.configService.get('DB_NAME');
        const dbUser = this.configService.get('DB_USERNAME');
        const dbPass = this.configService.get('DB_PASSWORD');
        const dbHost = this.configService.get('DB_HOST') || 'localhost';
        const dbPort = this.configService.get('DB_PORT') || '5432';

        try {
            // Para restaurar, usamos psql directamente
            this.logger.warn(`Restoring database from: ${filename} on host ${dbHost}`);

            const catCmd = process.platform === 'win32' ? 'type' : 'cat';
            const command = `${catCmd} "${filePath}" | PGPASSWORD="${dbPass}" psql -h ${dbHost} -p ${dbPort} -U ${dbUser} -d ${dbName}`;

            this.logger.log(`Executing restore for: ${filename}`);
            execSync(command);

            return {
                message: 'Database restored successfully',
                filename,
            };
        } catch (error) {
            this.logger.error(`Restore failed: ${error.message}`);
            throw new InternalServerErrorException('Database restoration failed');
        }
    }

    async deleteBackup(filename: string) {
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new NotFoundException('Backup file not found');
        }

        try {
            fs.unlinkSync(filePath);
            return { message: 'Backup deleted successfully' };
        } catch (error) {
            this.logger.error(`Deletion failed: ${error.message}`);
            throw new InternalServerErrorException('Failed to delete backup');
        }
    }
}
