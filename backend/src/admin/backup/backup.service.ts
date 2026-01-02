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

        try {
            // Usamos docker exec ya que la DB está en un contenedor alpine
            const command = `docker exec mareasdb pg_dump -U ${dbUser} ${dbName} > "${filePath}"`;
            this.logger.log(`Executing backup: ${command}`);
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

        try {
            // Para restaurar, primero necesitamos dejar caer la conexión y recrear o simplemente usar pg_restore
            // Dado que es alpine y el dump es .sql (texto), usamos psql para restaurar
            this.logger.warn(`Restoring database from: ${filename}`);

            // Comando para restaurar sobreescribiendo
            const command = `type "${filePath}" | docker exec -i mareasdb psql -U ${dbUser} -d ${dbName}`;

            this.logger.log(`Executing restore: ${command}`);
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
