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
            const startMark = new Date().toLocaleTimeString();
            console.log(`[${startMark}] [BackupService] === INICIO DE BACKUP ===`);
            console.log(`[${startMark}] [BackupService] Archivo: ${filename}`);

            try {
                // Intento local
                execSync('pg_dump --version', { stdio: 'ignore' });
                console.log(`[BackupService] pg_dump encontrado en host Windows.`);

                const command = `pg_dump -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" --clean --if-exists -f "${filePath}"`;
                execSync(command, {
                    env: { ...process.env, PGPASSWORD: dbPass },
                    stdio: 'pipe'
                });
            } catch (localError) {
                // Fallback Docker
                console.warn(`[BackupService] pg_dump NO encontrado en host. Usando Docker fallback 'mareasdb'...`);

                // IMPORTANTE: Dentro del contenedor el puerto es 5432, NO el 5435 externo
                const dockerCommand = `docker exec -e PGPASSWORD="${dbPass}" mareasdb pg_dump -h localhost -p 5432 -U "${dbUser}" -d "${dbName}" --clean --if-exists`;

                console.log(`[BackupService] Ejecutando en Docker: ${dockerCommand}`);

                const output = execSync(dockerCommand, {
                    maxBuffer: 1024 * 1024 * 100, // 100MB
                    stdio: ['ignore', 'pipe', 'pipe']
                });

                console.log(`[BackupService] Datos recibidos: ${output.length} bytes.`);
                fs.writeFileSync(filePath, output);
            }

            const stats = fs.statSync(filePath);
            console.log(`[BackupService] === BACKUP FINALIZADO === Tamaño: ${stats.size} bytes`);

            return {
                message: 'Backup created successfully',
                filename,
                size: stats.size,
                path: filePath,
            };
        } catch (error: any) {
            const stderr = error.stderr?.toString() || '';
            console.error(`[BackupService] !!! ERROR CRÍTICO !!!`, {
                message: error.message,
                stderr: stderr
            });
            throw new InternalServerErrorException(`Fallo al generar backup: ${stderr.slice(0, 100) || error.message}`);
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
            this.logger.warn(`Restoring database from: ${filename}`);

            try {
                // Verificar si psql está disponible localmente
                execSync('psql --version', { stdio: 'ignore' });

                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                
                // Fase 1: Limpieza total (Borrar esquema public y recrearlo)
                const dropSchemaCmd = `psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`;
                execSync(dropSchemaCmd, { env: { ...process.env, PGPASSWORD: dbPass }, stdio: 'ignore' });

                // Fase 2: Restauración
                const command = `${catCmd} "${filePath}" | psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" --set ON_ERROR_STOP=on`;

                execSync(command, {
                    env: { ...process.env, PGPASSWORD: dbPass },
                    stdio: 'pipe',
                    shell: true
                } as any);
            } catch (localError) {
                // Fallback vía Docker
                this.logger.warn(`psql error or not found on host, trying via Docker 'mareasdb'...`);

                const catCmd = process.platform === 'win32' ? 'type' : 'cat';

                // Fase 1 Docker: Limpieza total
                const dropSchemaDocker = `docker exec -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName} -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`;
                execSync(dropSchemaDocker, { stdio: 'ignore' });

                // Fase 2 Docker: Restauración
                const dockerCommand = `${catCmd} "${filePath}" | docker exec -i -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName} --set ON_ERROR_STOP=on`;

                execSync(dockerCommand, { stdio: 'pipe', shell: true } as any);
            }

            return {
                message: 'Database restored successfully',
                filename,
            };
        } catch (error: any) {
            const stderr = error.stderr?.toString() || '';
            this.logger.error(`Restore failed. Stderr: ${stderr} - Error: ${error.message}`);

            let userFriendlyMsg = 'La restauración de la base de datos falló.';
            if (error.message.includes('mareasdb') || error.message.includes('No such container')) {
                userFriendlyMsg += ` Detalle técnico: ${error.message}`;
            } else if (stderr.includes('connection failed')) {
                userFriendlyMsg += ' No se pudo conectar a la base de datos dentro del contenedor.';
            } else {
                userFriendlyMsg += ` ${stderr.slice(0, 200) || error.message}`;
            }

            throw new InternalServerErrorException(userFriendlyMsg);
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
