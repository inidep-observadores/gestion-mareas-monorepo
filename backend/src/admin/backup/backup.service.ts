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

        const logsPath = path.join(this.backupPath, 'logs');
        if (!fs.existsSync(logsPath)) {
            fs.mkdirSync(logsPath, { recursive: true });
        }
    }

    getStatus() {
        return {
            isConfigured: this.isConfigured,
            backupPath: this.backupPath,
        };
    }

    async createBackup(comment?: string) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        const filename = `BKP-${timestamp}.sql`;
        const metaFilename = `BKP-${timestamp}.json`;
        const filePath = path.join(this.backupPath, filename);
        const metaPath = path.join(this.backupPath, metaFilename);

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

                const command = `pg_dump -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" --clean --if-exists --no-owner --no-privileges -f "${filePath}"`;
                execSync(command, {
                    env: { ...process.env, PGPASSWORD: dbPass },
                    stdio: 'pipe',
                    maxBuffer: 1024 * 1024 * 100 // 100MB
                });
            } catch (localError) {
                // Fallback Docker
                console.warn(`[BackupService] pg_dump NO encontrado en host. Usando Docker fallback 'mareasdb'...`);

                // IMPORTANTE: Dentro del contenedor el puerto es 5432, NO el 5435 externo
                const dockerCommand = `docker exec -e PGPASSWORD="${dbPass}" mareasdb pg_dump -h localhost -p 5432 -U "${dbUser}" -d "${dbName}" --clean --if-exists --no-owner --no-privileges`;

                console.log(`[BackupService] Ejecutando en Docker: ${dockerCommand}`);

                const output = execSync(dockerCommand, {
                    maxBuffer: 1024 * 1024 * 100, // 100MB
                    stdio: ['ignore', 'pipe', 'pipe']
                });

                console.log(`[BackupService] Datos recibidos: ${output.length} bytes.`);
                fs.writeFileSync(filePath, output);
            }

            // Guardar metadatos
            const metadata = {
                filename,
                comment: comment || '',
                createdAt: new Date().toISOString(),
                systemInfo: {
                    dbName: dbName,
                    backupPath: this.backupPath
                }
            };
            fs.writeFileSync(metaPath, JSON.stringify(metadata, null, 2));

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
                    const fullPath = path.join(this.backupPath, f);
                    const stats = fs.statSync(fullPath);
                    
                    const metaPath = fullPath.replace('.sql', '.json');
                    let comment = '';
                    let createdAt = stats.birthtime;

                    if (fs.existsSync(metaPath)) {
                        try {
                            const meta = JSON.parse(fs.readFileSync(metaPath, 'utf8'));
                            comment = meta.comment || '';
                            if (meta.createdAt) createdAt = new Date(meta.createdAt);
                        } catch (e) {
                            this.logger.error(`Error reading metadata for ${f}: ${e.message}`);
                        }
                    }

                    return {
                        filename: f,
                        size: stats.size,
                        createdAt,
                        comment
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

        const logsPath = path.join(this.backupPath, 'logs');
        const logFilename = `restore-${filename.replace('.sql', '')}-${new Date().getTime()}.log`;
        const logFile = path.join(logsPath, logFilename);

        try {
            // Para restaurar, usamos psql directamente
            const startMsg = `[${new Date().toISOString()}] Starting restoration: ${filename}\n`;
            fs.writeFileSync(logFile, startMsg);
            this.logger.warn(`Restoring database from: ${filename}. Log: ${logFilename}`);

            const runCmdWithLog = (cmd: string, env: any = {}) => {
                fs.appendFileSync(logFile, `\n> Executing: ${cmd}\n`);
                try {
                    const output = execSync(cmd, { 
                        env: { ...process.env, ...env },
                        stdio: 'pipe', 
                        shell: true,
                        maxBuffer: 1024 * 1024 * 100 // 100MB
                    } as any);
                    fs.appendFileSync(logFile, output.toString());
                    console.log(output.toString());
                } catch (err: any) {
                    const errorOutput = err.stdout?.toString() || '';
                    const errorStderr = err.stderr?.toString() || '';
                    fs.appendFileSync(logFile, `\nERROR:\n${errorOutput}\n${errorStderr}\n`);
                    console.error(`[BackupService] Command failed: ${cmd}\n${errorStderr}`);
                    throw err;
                }
            };

            try {
                // Verificar si psql está disponible localmente
                execSync('psql --version', { stdio: 'ignore' });
                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                
                // Fase 1: Limpieza total
                runCmdWithLog(`psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`, { PGPASSWORD: dbPass });

                // Fase 2: Restauración
                runCmdWithLog(`${catCmd} "${filePath}" | psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}"`, { PGPASSWORD: dbPass });

            } catch (localError) {
                // Fallback vía Docker
                this.logger.warn(`Host psql failed, trying via Docker 'mareasdb'...`);
                fs.appendFileSync(logFile, `\n[Fallback] Host psql failed, trying via Docker.\n`);

                const catCmd = process.platform === 'win32' ? 'type' : 'cat';

                // Fase 1 Docker: Limpieza
                runCmdWithLog(`docker exec -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName} -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`);

                // Fase 2 Docker: Restauración
                runCmdWithLog(`${catCmd} "${filePath}" | docker exec -i -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName}`);
            }

            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] Restoration finished successfully.\n`);

            return {
                message: 'Database restored successfully',
                filename,
                logFile: logFilename
            };
        } catch (error: any) {
            const stderr = error.stderr?.toString() || '';
            const msg = `Restore failed. See logs/ ${logFilename} for details. Error: ${error.message}`;
            this.logger.error(msg);
            
            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] CRITICAL FAILURE: ${error.message}\n${stderr}\n`);

            throw new InternalServerErrorException(`La restauración falló. Revisa el archivo de log ${logFilename} en la carpeta de backups.`);
        }
    }

    async deleteBackup(filename: string) {
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new NotFoundException('Backup file not found');
        }

        try {
            fs.unlinkSync(filePath);
            const metaPath = filePath.replace('.sql', '.json');
            if (fs.existsSync(metaPath)) {
                fs.unlinkSync(metaPath);
            }
            return { message: 'Backup deleted successfully' };
        } catch (error) {
            this.logger.error(`Deletion failed: ${error.message}`);
            throw new InternalServerErrorException('Failed to delete backup');
        }
    }
}
