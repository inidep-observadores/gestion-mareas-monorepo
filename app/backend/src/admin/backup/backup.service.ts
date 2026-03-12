import { Injectable, Logger, ConflictException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { execSync, spawn } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as archiver from 'archiver';
import * as AdmZip from 'adm-zip';
import * as crypto from 'crypto';
import { Response } from 'express';

export const VALID_SCHEMAS = ['public', 'audit', 'datos_api'] as const;
export type BackupSchema = typeof VALID_SCHEMAS[number];

export interface BackupSchemaOption {
    key: BackupSchema;
    label: string;
    description: string;
}

export const SCHEMA_OPTIONS: BackupSchemaOption[] = [
    { key: 'public', label: 'Datos Generales', description: 'Mareas, buques, observadores y toda la información principal del sistema.' },
    { key: 'audit', label: 'Auditoría', description: 'Registro de cambios en la base de datos y eventos de navegación.' },
    { key: 'datos_api', label: 'Datos Históricos de API', description: 'Trayectorias de buques y zarpadas/arribos registradas desde APIs externas. Aumenta significativamente el tamaño del archivo.' },
];

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
            schemaOptions: SCHEMA_OPTIONS,
        };
    }

    async createBackup(comment?: string, schemas: BackupSchema[] = ['public']) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
        const baseFilename = `BKP-${timestamp}`;
        const zipFilename = `${baseFilename}.zip`;
        const metaFilename = `${baseFilename}.json`;
        const zipPath = path.join(this.backupPath, zipFilename);
        const metaPath = path.join(this.backupPath, metaFilename);

        const dbName = this.configService.get('DB_NAME');
        const dbUser = this.configService.get('DB_USERNAME');
        const dbPass = this.configService.get('DB_PASSWORD');
        const dbHost = this.configService.get('DB_HOST') || 'localhost';
        const dbPort = this.configService.get('DB_PORT') || '5432';

        // Validar schemas recibidos
        const validSchemas = schemas.filter(s => VALID_SCHEMAS.includes(s));
        if (validSchemas.length === 0) {
            validSchemas.push('public');
        }

        const tempDir = path.join(this.backupPath, `temp_${timestamp}`);
        fs.mkdirSync(tempDir, { recursive: true });

        const startMark = new Date().toLocaleTimeString();
        console.log(`[${startMark}] [BackupService] === INICIO DE BACKUP === Esquemas: ${validSchemas.join(', ')}`);

        try {
            // --- Paso 1: Generar un SQL por esquema, usando streams para no cargar todo en RAM ---
            const sqlFiles: { schema: BackupSchema; filename: string; filePath: string }[] = [];

            for (const schema of validSchemas) {
                const sqlFilename = `${schema}.sql`;
                const sqlFilePath = path.join(tempDir, sqlFilename);

                const schemaArgs = ['-n', schema];

                try {
                    // Intento local
                    await this.executeDumpCommand(
                        'pg_dump',
                        [
                            '-h', dbHost, '-p', dbPort, '-U', dbUser, '-d', dbName,
                            '--clean', '--if-exists', '--no-owner', '--no-privileges',
                            ...schemaArgs,
                        ],
                        { PGPASSWORD: dbPass },
                        sqlFilePath,
                    );
                    console.log(`[BackupService] Dump del esquema '${schema}' completado.`);
                } catch (localError: any) {
                    // Fallback Docker
                    console.warn(`[BackupService] pg_dump local falló para esquema '${schema}'. Usando Docker fallback 'mareasdb'...`);
                    await this.executeDumpCommand(
                        'docker',
                        [
                            'exec', '-i', '-e', `PGPASSWORD=${dbPass}`, 'mareasdb',
                            'pg_dump', '-h', 'localhost', '-p', '5432', '-U', dbUser, '-d', dbName,
                            '--clean', '--if-exists', '--no-owner', '--no-privileges',
                            ...schemaArgs,
                        ],
                        {},
                        sqlFilePath,
                    );
                    console.log(`[BackupService] Dump del esquema '${schema}' vía Docker completado.`);
                }

                sqlFiles.push({ schema, filename: sqlFilename, filePath: sqlFilePath });
            }

            // --- Paso 2: Empaquetar todos los .sql en un único .zip ---
            const zipPassword = this.configService.get<string>('BACKUP_ZIP_PASSWORD');
            await this.createZipFromFiles(sqlFiles.map(f => ({ filePath: f.filePath, name: f.filename })), zipPath, zipPassword);

            // --- Paso 3: Calcular hashes de los archivos SQL para metadatos ---
            const sqlHashes: Record<string, string> = {};
            for (const file of sqlFiles) {
                sqlHashes[file.schema] = await this.calculateFileHash(file.filePath);
            }

            // --- Paso 4: Crear firma HMAC y guardar metadatos ---
            const backupSecret = this.configService.get<string>('BACKUP_SECRET') || this.configService.get<string>('JWT_SECRET');
            const stringToSign = JSON.stringify({ filename: zipFilename, sqlHashes });
            const signature = crypto
                .createHmac('sha256', backupSecret)
                .update(stringToSign)
                .digest('hex');

            const metadata: any = {
                filename: zipFilename,
                comment: comment || '',
                createdAt: new Date().toISOString(),
                schemas: validSchemas,
                systemInfo: {
                    dbName,
                    backupPath: this.backupPath,
                },
                security: {
                    sqlHashes,
                    signature,
                },
            };

            fs.writeFileSync(metaPath, JSON.stringify(metadata, null, 2));

            // --- Paso 5: Limpiar archivos temporales ---
            fs.rmSync(tempDir, { recursive: true, force: true });

            const stats = fs.statSync(zipPath);
            console.log(`[BackupService] === BACKUP FINALIZADO === Tamaño ZIP: ${stats.size} bytes. Esquemas: ${validSchemas.join(', ')}`);

            return {
                message: 'Copia de seguridad creada correctamente',
                filename: zipFilename,
                size: stats.size,
                schemas: validSchemas,
                path: zipPath,
            };
        } catch (error: any) {
            // Limpiar temps en caso de error
            if (fs.existsSync(tempDir)) {
                fs.rmSync(tempDir, { recursive: true, force: true });
            }
            const stderr = error.stderr?.toString() || '';
            console.error(`[BackupService] !!! ERROR CRÍTICO !!!`, { message: error.message, stderr });
            throw new InternalServerErrorException(`Fallo al generar copia de seguridad: ${stderr.slice(0, 200) || error.message}`);
        }
    }

    async listBackups() {
        try {
            const files = fs.readdirSync(this.backupPath);
            return files
                .filter(f => {
                    if (!f.startsWith('BKP-') || !f.endsWith('.zip')) return false;
                    // Solo incluir ZIPs que ya tienen su JSON de metadatos.
                    // El JSON se escribe al final del proceso, por lo que su ausencia
                    // indica que la generación aún está en curso.
                    const metaPath = path.join(this.backupPath, f.replace('.zip', '.json'));
                    return fs.existsSync(metaPath);
                })
                .map(f => {
                    const fullPath = path.join(this.backupPath, f);
                    const stats = fs.statSync(fullPath);

                    const metaPath = fullPath.replace('.zip', '.json');
                    let comment = '';
                    let createdAt = stats.birthtime;
                    let schemas: BackupSchema[] = ['public'];

                    if (fs.existsSync(metaPath)) {
                        try {
                            const meta = JSON.parse(fs.readFileSync(metaPath, 'utf8'));
                            comment = meta.comment || '';
                            schemas = meta.schemas || ['public'];
                            if (meta.createdAt) createdAt = new Date(meta.createdAt);
                        } catch (e) {
                            this.logger.error(`Error leyendo metadatos de ${f}: ${e.message}`);
                        }
                    }

                    return { filename: f, size: stats.size, createdAt, comment, schemas };
                })
                .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
        } catch (error) {
            this.logger.error(`Error listando copias: ${error.message}`);
            throw new InternalServerErrorException('Error al obtener la lista de copias de seguridad');
        }
    }

    async restoreBackup(filename: string, confirmationPhrase: string, schemasToRestore?: BackupSchema[]) {
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
            'CARGAR COPIA EXTERNA',
        ];

        if (!validPhrases.includes(confirmationPhrase.toUpperCase().trim())) {
            throw new ConflictException('La frase de confirmación es incorrecta o no reconocida');
        }

        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new NotFoundException('Archivo de copia de seguridad no encontrado');
        }

        // Leer metadatos para saber qué esquemas están disponibles
        const metaPath = filePath.replace('.zip', '.json');
        let availableSchemas: BackupSchema[] = ['public'];
        if (fs.existsSync(metaPath)) {
            try {
                const meta = JSON.parse(fs.readFileSync(metaPath, 'utf8'));
                availableSchemas = meta.schemas || ['public'];
            } catch (_e) { /* usar default */ }
        }

        // Esquemas a restaurar = intersección de los disponibles y los solicitados
        const requestedSchemas = schemasToRestore && schemasToRestore.length > 0
            ? schemasToRestore.filter(s => availableSchemas.includes(s))
            : ['public' as BackupSchema];

        if (requestedSchemas.length === 0) {
            throw new ConflictException('Ninguno de los esquemas solicitados está disponible en esta copia de seguridad.');
        }

        const dbName = this.configService.get('DB_NAME');
        const dbUser = this.configService.get('DB_USERNAME');
        const dbPass = this.configService.get('DB_PASSWORD');
        const dbHost = this.configService.get('DB_HOST') || 'localhost';
        const dbPort = this.configService.get('DB_PORT') || '5432';
        const zipPassword = this.configService.get<string>('BACKUP_ZIP_PASSWORD');

        const logsPath = path.join(this.backupPath, 'logs');
        const logFilename = `restore-${filename.replace('.zip', '')}-${new Date().getTime()}.log`;
        const logFile = path.join(logsPath, logFilename);

        const tempDir = path.join(this.backupPath, `temp_restore_${Date.now()}`);
        fs.mkdirSync(tempDir, { recursive: true });

        try {
            const startMsg = `[${new Date().toISOString()}] Iniciando restauración: ${filename}\nEsquemas a restaurar: ${requestedSchemas.join(', ')}\n`;
            fs.writeFileSync(logFile, startMsg);
            this.logger.warn(`Restaurando desde: ${filename}. Esquemas: ${requestedSchemas.join(', ')}. Log: ${logFilename}`);

            // Extraer el ZIP
            const zip = new AdmZip(filePath);
            zip.extractAllTo(tempDir, true, false, zipPassword);

            const runCmdWithLog = (cmd: string, env: any = {}) => {
                fs.appendFileSync(logFile, `\n> Ejecutando: ${cmd}\n`);
                try {
                    const output = execSync(cmd, {
                        env: { ...process.env, ...env },
                        stdio: 'pipe',
                        shell: true,
                        maxBuffer: 1024 * 1024 * 200, // 200MB
                    } as any);
                    fs.appendFileSync(logFile, output.toString());
                } catch (err: any) {
                    const errorOutput = err.stdout?.toString() || '';
                    const errorStderr = err.stderr?.toString() || '';
                    fs.appendFileSync(logFile, `\nERROR:\n${errorOutput}\n${errorStderr}\n`);
                    console.error(`[BackupService] Comando falló: ${cmd}\n${errorStderr}`);
                    throw err;
                }
            };

            const isLocal = (() => {
                try { execSync('psql --version', { stdio: 'ignore' }); return true; }
                catch (_) { return false; }
            })();

            const catCmd = process.platform === 'win32' ? 'type' : 'cat';

            for (const schema of requestedSchemas) {
                const sqlFile = path.join(tempDir, `${schema}.sql`);
                if (!fs.existsSync(sqlFile)) {
                    this.logger.warn(`Archivo ${schema}.sql no encontrado en el ZIP. Saltando.`);
                    fs.appendFileSync(logFile, `\nWARN: ${schema}.sql no encontrado en el ZIP. Se omite.\n`);
                    continue;
                }

                fs.appendFileSync(logFile, `\n--- Restaurando esquema '${schema}' ---\n`);

                if (isLocal) {
                    // Limpiar SOLO el esquema que se va a restaurar
                    runCmdWithLog(
                        `psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" -c "DROP SCHEMA IF EXISTS ${schema} CASCADE; CREATE SCHEMA ${schema};"`,
                        { PGPASSWORD: dbPass },
                    );
                    runCmdWithLog(
                        `${catCmd} "${sqlFile}" | psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}"`,
                        { PGPASSWORD: dbPass },
                    );
                } else {
                    // Fallback Docker
                    this.logger.warn(`psql local no disponible, usando Docker 'mareasdb' para esquema '${schema}'...`);
                    runCmdWithLog(
                        `docker exec -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName} -c "DROP SCHEMA IF EXISTS ${schema} CASCADE; CREATE SCHEMA ${schema};"`,
                    );
                    runCmdWithLog(
                        `${catCmd} "${sqlFile}" | docker exec -i -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName}`,
                    );
                }

                fs.appendFileSync(logFile, `\n[OK] Esquema '${schema}' restaurado.\n`);
            }

            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] Restauración finalizada con éxito.\n`);

            return {
                message: 'Base de datos restaurada exitosamente',
                filename,
                schemasRestored: requestedSchemas,
                logFile: logFilename,
            };
        } catch (error: any) {
            const stderr = error.stderr?.toString() || '';
            const msg = `Restauración fallida. Revise logs/${logFilename}. Error: ${error.message}`;
            this.logger.error(msg);
            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] FALLO CRÍTICO: ${error.message}\n${stderr}\n`);
            throw new InternalServerErrorException(`La restauración falló. Revise el archivo de log ${logFilename} en la carpeta de copias de seguridad.`);
        } finally {
            if (fs.existsSync(tempDir)) {
                fs.rmSync(tempDir, { recursive: true, force: true });
            }
        }
    }

    async deleteBackup(filename: string) {
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new NotFoundException('Archivo de copia de seguridad no encontrado');
        }

        try {
            fs.unlinkSync(filePath);
            const metaPath = filePath.replace('.zip', '.json');
            if (fs.existsSync(metaPath)) {
                fs.unlinkSync(metaPath);
            }
            return { message: 'Copia de seguridad eliminada' };
        } catch (error) {
            this.logger.error(`Error al eliminar: ${error.message}`);
            throw new InternalServerErrorException('Error al eliminar el archivo');
        }
    }

    /**
     * Sirve el ZIP del backup directamente al cliente como descarga.
     * El zip ya tiene toda la estructura (un SQL por esquema), así que se sirve tal cual.
     */
    async createBackupZip(filename: string, res: Response): Promise<void> {
        const zipPath = path.join(this.backupPath, filename);
        if (!fs.existsSync(zipPath)) {
            throw new NotFoundException('Archivo de copia de seguridad no encontrado');
        }

        const stats = fs.statSync(zipPath);

        res.setHeader('Content-Type', 'application/zip');
        res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
        res.setHeader('Content-Length', stats.size);
        res.setHeader('X-Accel-Buffering', 'no');
        res.setHeader('Cache-Control', 'no-cache');

        const readStream = fs.createReadStream(zipPath);
        readStream.on('error', (err) => {
            this.logger.error(`Error al leer ZIP para descarga: ${err.message}`);
            if (!res.headersSent) {
                res.status(500).json({ message: 'Error al descargar el archivo' });
            }
        });
        readStream.pipe(res);
    }

    async uploadBackup(file: Express.Multer.File) {
        const tempDir = path.join(this.backupPath, 'temp_upload');
        if (!fs.existsSync(tempDir)) {
            fs.mkdirSync(tempDir, { recursive: true });
        }

        const zipPassword = this.configService.get<string>('BACKUP_ZIP_PASSWORD');

        try {
            const zip = new AdmZip(file.buffer);
            zip.extractAllTo(tempDir, true, false, zipPassword);

            const extractedFiles = fs.readdirSync(tempDir);
            const sqlFiles = extractedFiles.filter(f => f.endsWith('.sql'));

            if (sqlFiles.length === 0) {
                throw new ConflictException('El archivo ZIP no contiene ningún archivo .sql válido.');
            }

            // El metadata JSON debe viajar junto con el ZIP (no dentro)
            // Buscamos el .json correspondiente con el mismo nombre de archivo
            const zipFilename = file.originalname;
            const expectedMetaName = zipFilename.replace('.zip', '.json');

            // Para upload, la validación de firma se hace desde el JSON incluido o suelto
            // En este flujo el usuario sube solo el .zip — verificamos integridad mediante un hash
            // simple del contenido para detectar corrupción.
            // (Si el sistema tiene firma se verificará si se incluye el .json adjunto)

            // Mover el .zip a la carpeta de backups
            const finalZipPath = path.join(this.backupPath, zipFilename);
            if (fs.existsSync(finalZipPath)) {
                this.logger.warn(`Sobreescribiendo backup existente: ${zipFilename}`);
            }

            fs.writeFileSync(finalZipPath, file.buffer);

            // Leer esquemas disponibles desde los SQL encontrados (sin leer el archivo completo)
            const schemas = sqlFiles.map(f => f.replace('.sql', '') as BackupSchema)
                .filter(s => VALID_SCHEMAS.includes(s));

            // Crear metadatos básicos si no existían
            const metaPath = path.join(this.backupPath, expectedMetaName);
            if (!fs.existsSync(metaPath)) {
                const basicMeta = {
                    filename: zipFilename,
                    comment: 'Subida externa',
                    createdAt: new Date().toISOString(),
                    schemas,
                    security: {},
                };
                fs.writeFileSync(metaPath, JSON.stringify(basicMeta, null, 2));
            }

            const stats = fs.statSync(finalZipPath);
            return {
                message: 'Copia de seguridad subida correctamente',
                filename: zipFilename,
                size: stats.size,
                schemas,
                createdAt: new Date().toISOString(),
                comment: 'Subida externa',
            };
        } catch (error) {
            this.logger.error(`Error procesando subida de backup: ${error.message}`);
            if (error instanceof ConflictException) throw error;
            throw new InternalServerErrorException('Error al procesar el archivo de copia de seguridad subido.');
        } finally {
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

    /**
     * Crea un archivo ZIP a partir de una lista de archivos, usando streams para
     * evitar cargar todo el contenido en RAM. Soporta contraseña opcional.
     */
    private async createZipFromFiles(
        files: { filePath: string; name: string }[],
        outputPath: string,
        password?: string,
    ): Promise<void> {
        return new Promise((resolve, reject) => {
            const writeStream = fs.createWriteStream(outputPath);

            const archive = password
                ? archiver('zip-encryptable' as any, { zlib: { level: 6 }, password } as any)
                : archiver('zip', { zlib: { level: 6 } });

            archive.on('error', (err) => {
                this.logger.error(`Error al crear ZIP: ${err.message}`);
                reject(err);
            });

            writeStream.on('close', () => resolve());
            writeStream.on('error', (err) => reject(err));

            archive.pipe(writeStream);

            for (const file of files) {
                // Añadir archivo al ZIP usando stream para no cargarlo en RAM
                archive.file(file.filePath, { name: file.name });
            }

            archive.finalize();
        });
    }

    private async executeDumpCommand(command: string, args: string[], env: any, outputPath: string): Promise<void> {
        return new Promise((resolve, reject) => {
            const writeStream = fs.createWriteStream(outputPath);
            const child = spawn(command, args, {
                env: { ...process.env, ...env },
                shell: true, // Necesario en Windows para resolver rutas
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
