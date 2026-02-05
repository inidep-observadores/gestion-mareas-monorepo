import { Injectable, Logger, ConflictException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { execSync, spawn } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as archiver from 'archiver';
import * as AdmZip from 'adm-zip';
import * as crypto from 'crypto';
import { Response } from 'express';

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

        // Registrar formato encryptable una sola vez al inicio
        try {
            const archiverEncryptable = require('archiver-zip-encryptable');
            archiver.registerFormat('zip-encryptable', archiverEncryptable);
        } catch (e) {
            this.logger.warn('No se pudo registrar zip-encryptable o ya estaba registrado');
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

    async createBackup(comment?: string, includeTrajectories = false) {
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

            const exclusionArgs = includeTrajectories ? [] : ['--exclude-table-data', 'buque_trayectorias', '--exclude-table-data', 'buque_trayectoria_puntos'];

            try {
                // Intento local
                await this.executeDumpCommand(
                    'pg_dump',
                    [
                        '-h', dbHost, '-p', dbPort, '-U', dbUser, '-d', dbName,
                        '--clean', '--if-exists', '--no-owner', '--no-privileges',
                        ...exclusionArgs
                    ],
                    { PGPASSWORD: dbPass },
                    filePath
                );
                console.log(`[BackupService] Backup local completado exitosamente. Trayectorias: ${includeTrajectories}`);
            } catch (localError: any) {
                // Fallback Docker
                console.warn(`[BackupService] pg_dump local falló o no se encontró. Usando Docker fallback 'mareasdb'...`);

                // IMPORTANTE: Dentro del contenedor el puerto es 5432, NO el 5435 externo
                await this.executeDumpCommand(
                    'docker',
                    [
                        'exec', '-i', '-e', `PGPASSWORD=${dbPass}`, 'mareasdb',
                        'pg_dump', '-h', 'localhost', '-p', '5432', '-U', dbUser, '-d', dbName,
                        '--clean', '--if-exists', '--no-owner', '--no-privileges',
                        ...exclusionArgs
                    ],
                    {},
                    filePath
                );
                console.log(`[BackupService] Backup vía Docker completado exitosamente. Trayectorias: ${includeTrajectories}`);
            }

            // Guardar metadatos (Cálculo de hash por streams)
            const sqlHash = await this.calculateFileHash(filePath);

            const backupSecret = this.configService.get<string>('BACKUP_SECRET') || this.configService.get<string>('JWT_SECRET');

            const metadata: any = {
                filename,
                comment: comment || '',
                createdAt: new Date().toISOString(),
                systemInfo: {
                    dbName: dbName,
                    backupPath: this.backupPath
                },
                security: {
                    sqlHash: sqlHash,
                }
            };

            // Crear firma HMAC de los datos críticos
            const stringToSign = JSON.stringify({ filename, sqlHash });
            metadata.security.signature = crypto
                .createHmac('sha256', backupSecret)
                .update(stringToSign)
                .digest('hex');

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

    async createBackupZip(filename: string, res: Response): Promise<void> {
        const sqlPath = path.join(this.backupPath, filename);
        if (!fs.existsSync(sqlPath)) {
            throw new NotFoundException('Archivo de copia de seguridad no encontrado');
        }

        const jsonPath = sqlPath.replace('.sql', '.json');
        const zipFilename = filename.replace('.sql', '.zip');
        const zipPassword = this.configService.get<string>('BACKUP_ZIP_PASSWORD');

        res.setHeader('Content-Type', 'application/zip');
        res.setHeader('Content-Disposition', `attachment; filename="${zipFilename}"`);
        res.setHeader('X-Accel-Buffering', 'no'); // Desactivar buffering en Nginx para streaming
        res.setHeader('Cache-Control', 'no-cache');
        res.setHeader('Transfer-Encoding', 'chunked');

        // Si no hay contraseña, usamos el archiver estándar que ya tenemos cargado
        // Pero si HAY contraseña, necesitamos el encryptable
        if (zipPassword) {
            const archive = archiver('zip-encryptable' as any, {
                zlib: { level: 5 }, // Nivel 5 es un buen balance entre velocidad y tamaño
                password: zipPassword
            } as any);

            archive.on('error', (err) => {
                this.logger.error(`Error zipping backup with password: ${err.message}`);
                throw new InternalServerErrorException('Error al crear el archivo comprimido protegido');
            });

            archive.pipe(res);
            archive.file(sqlPath, { name: filename });
            if (fs.existsSync(jsonPath)) {
                archive.file(jsonPath, { name: path.basename(jsonPath) });
            }
            await archive.finalize();
        } else {
            // ZIP estándar sin contraseña (usando archiver normal)
            const archive = archiver('zip', { zlib: { level: 5 } });

            archive.on('error', (err) => {
                this.logger.error(`Error zipping backup: ${err.message}`);
                throw new InternalServerErrorException('Error al crear el archivo comprimido');
            });

            archive.pipe(res);
            archive.file(sqlPath, { name: filename });
            if (fs.existsSync(jsonPath)) {
                archive.file(jsonPath, { name: path.basename(jsonPath) });
            }
            await archive.finalize();
        }
    }

    async uploadBackup(file: Express.Multer.File) {
        const tempDir = path.join(this.backupPath, 'temp_upload');
        if (!fs.existsSync(tempDir)) {
            fs.mkdirSync(tempDir, { recursive: true });
        }

        const zipPassword = this.configService.get<string>('BACKUP_ZIP_PASSWORD');

        try {
            const zip = new AdmZip(file.buffer);

            // Intentar extraer con contraseña si existe
            zip.extractAllTo(tempDir, true, false, zipPassword);

            const extractedFiles = fs.readdirSync(tempDir);
            const sqlFile = extractedFiles.find(f => f.endsWith('.sql'));
            const jsonFile = extractedFiles.find(f => f.endsWith('.json'));

            if (!sqlFile || !jsonFile) {
                throw new ConflictException('El archivo ZIP debe contener un archivo .sql y un archivo .json de metadatos.');
            }

            // Validar firma y hash
            const metaContent = fs.readFileSync(path.join(tempDir, jsonFile), 'utf8');
            const metadata = JSON.parse(metaContent);

            if (!metadata.security || !metadata.security.signature || !metadata.security.sqlHash) {
                throw new ConflictException('El archivo de metadatos no contiene información de seguridad válida.');
            }

            const backupSecret = this.configService.get<string>('BACKUP_SECRET') || this.configService.get<string>('JWT_SECRET');
            const stringToSign = JSON.stringify({ filename: metadata.filename, sqlHash: metadata.security.sqlHash });
            const expectedSignature = crypto
                .createHmac('sha256', backupSecret)
                .update(stringToSign)
                .digest('hex');

            if (metadata.security.signature !== expectedSignature) {
                throw new ConflictException('Fallo de autenticidad: La firma del backup no es válida para este servidor.');
            }

            const sqlBuffer = fs.readFileSync(path.join(tempDir, sqlFile));
            const actualHash = crypto.createHash('sha256').update(sqlBuffer).digest('hex');

            if (metadata.security.sqlHash !== actualHash) {
                throw new ConflictException('Fallo de integridad: El contenido del archivo SQL ha sido alterado.');
            }

            // Si todo está bien, mover a la carpeta de backups
            const finalSqlPath = path.join(this.backupPath, sqlFile);
            const finalJsonPath = path.join(this.backupPath, jsonFile);

            // Evitar colisiones o avisar si ya existe
            if (fs.existsSync(finalSqlPath)) {
                // Si ya existe, lo sobreescribimos (o podríamos renombrarlo si preferimos)
                this.logger.warn(`Sobreescribiendo backup existente: ${sqlFile}`);
            }

            fs.renameSync(path.join(tempDir, sqlFile), finalSqlPath);
            fs.renameSync(path.join(tempDir, jsonFile), finalJsonPath);

            return {
                message: 'Backup subido y verificado correctamente',
                filename: sqlFile,
                size: fs.statSync(finalSqlPath).size,
                createdAt: metadata.createdAt,
                comment: metadata.comment
            };

        } catch (error) {
            this.logger.error(`Error procesando subida de backup: ${error.message}`);
            if (error instanceof ConflictException) throw error;
            throw new InternalServerErrorException('Error al procesar el archivo de backup subido.');
        } finally {
            // Limpiar temp dir
            if (fs.existsSync(tempDir)) {
                fs.readdirSync(tempDir).forEach(f => fs.unlinkSync(path.join(tempDir, f)));
                fs.rmdirSync(tempDir);
            }
        }
    }

    private async calculateFileHash(filePath: string): Promise<string> {
        return new Promise((resolve, reject) => {
            const hash = crypto.createHash('sha256');
            const stream = fs.createReadStream(filePath);
            stream.on('data', (data) => hash.update(data));
            stream.on('end', () => resolve(hash.digest('hex')));
            stream.on('error', (err) => reject(err));
        });
    }

    private async executeDumpCommand(command: string, args: string[], env: any, outputPath: string): Promise<void> {
        return new Promise((resolve, reject) => {
            const writeStream = fs.createWriteStream(outputPath);
            const child = spawn(command, args, {
                env: { ...process.env, ...env },
                shell: true // Necesario en Windows para resolver rutas de forma robusta
            });

            child.stdout.pipe(writeStream);

            let stderr = '';
            child.stderr.on('data', (data) => {
                stderr += data.toString();
            });

            child.on('close', (code) => {
                if (code === 0) {
                    resolve();
                } else {
                    const errorMsg = stderr || `Proceso de backup falló con código ${code}`;
                    reject(new Error(errorMsg));
                }
            });

            child.on('error', (err) => {
                reject(err);
            });
        });
    }
}
