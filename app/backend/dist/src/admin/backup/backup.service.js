"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var BackupService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.BackupService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const child_process_1 = require("child_process");
const fs = require("fs");
const path = require("path");
const archiver = require("archiver");
const AdmZip = require("adm-zip");
const crypto = require("crypto");
let BackupService = BackupService_1 = class BackupService {
    constructor(configService) {
        this.configService = configService;
        this.logger = new common_1.Logger(BackupService_1.name);
        const pathFromConfig = this.configService.get('BACKUP_PATH');
        this.isConfigured = !!pathFromConfig;
        this.backupPath = pathFromConfig || './backups';
        if (!fs.existsSync(this.backupPath)) {
            fs.mkdirSync(this.backupPath, { recursive: true });
        }
        try {
            const archiverEncryptable = require('archiver-zip-encryptable');
            archiver.registerFormat('zip-encryptable', archiverEncryptable);
        }
        catch (e) {
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
    async createBackup(comment) {
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
                await this.executeDumpCommand('pg_dump', [
                    '-h', dbHost, '-p', dbPort, '-U', dbUser, '-d', dbName,
                    '--clean', '--if-exists', '--no-owner', '--no-privileges',
                    '--exclude-table-data', 'buque_trayectorias', '--exclude-table-data', 'buque_trayectoria_puntos'
                ], { PGPASSWORD: dbPass }, filePath);
                console.log(`[BackupService] Backup local completado exitosamente.`);
            }
            catch (localError) {
                console.warn(`[BackupService] pg_dump local falló o no se encontró. Usando Docker fallback 'mareasdb'...`);
                await this.executeDumpCommand('docker', [
                    'exec', '-i', '-e', `PGPASSWORD=${dbPass}`, 'mareasdb',
                    'pg_dump', '-h', 'localhost', '-p', '5432', '-U', dbUser, '-d', dbName,
                    '--clean', '--if-exists', '--no-owner', '--no-privileges',
                    '--exclude-table-data', 'buque_trayectorias', '--exclude-table-data', 'buque_trayectoria_puntos'
                ], {}, filePath);
                console.log(`[BackupService] Backup vía Docker completado exitosamente.`);
            }
            const sqlHash = await this.calculateFileHash(filePath);
            const backupSecret = this.configService.get('BACKUP_SECRET') || this.configService.get('JWT_SECRET');
            const metadata = {
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
        }
        catch (error) {
            const stderr = error.stderr?.toString() || '';
            console.error(`[BackupService] !!! ERROR CRÍTICO !!!`, {
                message: error.message,
                stderr: stderr
            });
            throw new common_1.InternalServerErrorException(`Fallo al generar backup: ${stderr.slice(0, 100) || error.message}`);
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
                        if (meta.createdAt)
                            createdAt = new Date(meta.createdAt);
                    }
                    catch (e) {
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
        }
        catch (error) {
            this.logger.error(`Listing backups failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Failed to list backups');
        }
    }
    async restoreBackup(filename, confirmationPhrase) {
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
            throw new common_1.ConflictException('La frase de confirmación es incorrecta o no reconocida');
        }
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new common_1.NotFoundException('Backup file not found');
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
            const startMsg = `[${new Date().toISOString()}] Starting restoration: ${filename}\n`;
            fs.writeFileSync(logFile, startMsg);
            this.logger.warn(`Restoring database from: ${filename}. Log: ${logFilename}`);
            const runCmdWithLog = (cmd, env = {}) => {
                fs.appendFileSync(logFile, `\n> Executing: ${cmd}\n`);
                try {
                    const output = (0, child_process_1.execSync)(cmd, {
                        env: { ...process.env, ...env },
                        stdio: 'pipe',
                        shell: true,
                        maxBuffer: 1024 * 1024 * 100
                    });
                    fs.appendFileSync(logFile, output.toString());
                    console.log(output.toString());
                }
                catch (err) {
                    const errorOutput = err.stdout?.toString() || '';
                    const errorStderr = err.stderr?.toString() || '';
                    fs.appendFileSync(logFile, `\nERROR:\n${errorOutput}\n${errorStderr}\n`);
                    console.error(`[BackupService] Command failed: ${cmd}\n${errorStderr}`);
                    throw err;
                }
            };
            try {
                (0, child_process_1.execSync)('psql --version', { stdio: 'ignore' });
                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                runCmdWithLog(`psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`, { PGPASSWORD: dbPass });
                runCmdWithLog(`${catCmd} "${filePath}" | psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}"`, { PGPASSWORD: dbPass });
            }
            catch (localError) {
                this.logger.warn(`Host psql failed, trying via Docker 'mareasdb'...`);
                fs.appendFileSync(logFile, `\n[Fallback] Host psql failed, trying via Docker.\n`);
                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                runCmdWithLog(`docker exec -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName} -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"`);
                runCmdWithLog(`${catCmd} "${filePath}" | docker exec -i -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName}`);
            }
            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] Restoration finished successfully.\n`);
            return {
                message: 'Database restored successfully',
                filename,
                logFile: logFilename
            };
        }
        catch (error) {
            const stderr = error.stderr?.toString() || '';
            const msg = `Restore failed. See logs/ ${logFilename} for details. Error: ${error.message}`;
            this.logger.error(msg);
            fs.appendFileSync(logFile, `\n[${new Date().toISOString()}] CRITICAL FAILURE: ${error.message}\n${stderr}\n`);
            throw new common_1.InternalServerErrorException(`La restauración falló. Revisa el archivo de log ${logFilename} en la carpeta de backups.`);
        }
    }
    async deleteBackup(filename) {
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new common_1.NotFoundException('Backup file not found');
        }
        try {
            fs.unlinkSync(filePath);
            const metaPath = filePath.replace('.sql', '.json');
            if (fs.existsSync(metaPath)) {
                fs.unlinkSync(metaPath);
            }
            return { message: 'Backup deleted successfully' };
        }
        catch (error) {
            this.logger.error(`Deletion failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Failed to delete backup');
        }
    }
    async createBackupZip(filename, res) {
        const sqlPath = path.join(this.backupPath, filename);
        if (!fs.existsSync(sqlPath)) {
            throw new common_1.NotFoundException('Archivo de copia de seguridad no encontrado');
        }
        const jsonPath = sqlPath.replace('.sql', '.json');
        const zipFilename = filename.replace('.sql', '.zip');
        const zipPassword = this.configService.get('BACKUP_ZIP_PASSWORD');
        res.setHeader('Content-Type', 'application/zip');
        res.setHeader('Content-Disposition', `attachment; filename="${zipFilename}"`);
        if (zipPassword) {
            const archive = archiver('zip-encryptable', {
                zlib: { level: 9 },
                password: zipPassword
            });
            archive.on('error', (err) => {
                this.logger.error(`Error zipping backup with password: ${err.message}`);
                throw new common_1.InternalServerErrorException('Error al crear el archivo comprimido protegido');
            });
            archive.pipe(res);
            archive.file(sqlPath, { name: filename });
            if (fs.existsSync(jsonPath)) {
                archive.file(jsonPath, { name: path.basename(jsonPath) });
            }
            await archive.finalize();
        }
        else {
            const archive = archiver('zip', { zlib: { level: 9 } });
            archive.on('error', (err) => {
                this.logger.error(`Error zipping backup: ${err.message}`);
                throw new common_1.InternalServerErrorException('Error al crear el archivo comprimido');
            });
            archive.pipe(res);
            archive.file(sqlPath, { name: filename });
            if (fs.existsSync(jsonPath)) {
                archive.file(jsonPath, { name: path.basename(jsonPath) });
            }
            await archive.finalize();
        }
    }
    async uploadBackup(file) {
        const tempDir = path.join(this.backupPath, 'temp_upload');
        if (!fs.existsSync(tempDir)) {
            fs.mkdirSync(tempDir, { recursive: true });
        }
        const zipPassword = this.configService.get('BACKUP_ZIP_PASSWORD');
        try {
            const zip = new AdmZip(file.buffer);
            zip.extractAllTo(tempDir, true, false, zipPassword);
            const extractedFiles = fs.readdirSync(tempDir);
            const sqlFile = extractedFiles.find(f => f.endsWith('.sql'));
            const jsonFile = extractedFiles.find(f => f.endsWith('.json'));
            if (!sqlFile || !jsonFile) {
                throw new common_1.ConflictException('El archivo ZIP debe contener un archivo .sql y un archivo .json de metadatos.');
            }
            const metaContent = fs.readFileSync(path.join(tempDir, jsonFile), 'utf8');
            const metadata = JSON.parse(metaContent);
            if (!metadata.security || !metadata.security.signature || !metadata.security.sqlHash) {
                throw new common_1.ConflictException('El archivo de metadatos no contiene información de seguridad válida.');
            }
            const backupSecret = this.configService.get('BACKUP_SECRET') || this.configService.get('JWT_SECRET');
            const stringToSign = JSON.stringify({ filename: metadata.filename, sqlHash: metadata.security.sqlHash });
            const expectedSignature = crypto
                .createHmac('sha256', backupSecret)
                .update(stringToSign)
                .digest('hex');
            if (metadata.security.signature !== expectedSignature) {
                throw new common_1.ConflictException('Fallo de autenticidad: La firma del backup no es válida para este servidor.');
            }
            const sqlBuffer = fs.readFileSync(path.join(tempDir, sqlFile));
            const actualHash = crypto.createHash('sha256').update(sqlBuffer).digest('hex');
            if (metadata.security.sqlHash !== actualHash) {
                throw new common_1.ConflictException('Fallo de integridad: El contenido del archivo SQL ha sido alterado.');
            }
            const finalSqlPath = path.join(this.backupPath, sqlFile);
            const finalJsonPath = path.join(this.backupPath, jsonFile);
            if (fs.existsSync(finalSqlPath)) {
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
        }
        catch (error) {
            this.logger.error(`Error procesando subida de backup: ${error.message}`);
            if (error instanceof common_1.ConflictException)
                throw error;
            throw new common_1.InternalServerErrorException('Error al procesar el archivo de backup subido.');
        }
        finally {
            if (fs.existsSync(tempDir)) {
                fs.readdirSync(tempDir).forEach(f => fs.unlinkSync(path.join(tempDir, f)));
                fs.rmdirSync(tempDir);
            }
        }
    }
    async calculateFileHash(filePath) {
        return new Promise((resolve, reject) => {
            const hash = crypto.createHash('sha256');
            const stream = fs.createReadStream(filePath);
            stream.on('data', (data) => hash.update(data));
            stream.on('end', () => resolve(hash.digest('hex')));
            stream.on('error', (err) => reject(err));
        });
    }
    async executeDumpCommand(command, args, env, outputPath) {
        return new Promise((resolve, reject) => {
            const writeStream = fs.createWriteStream(outputPath);
            const child = (0, child_process_1.spawn)(command, args, {
                env: { ...process.env, ...env },
                shell: true
            });
            child.stdout.pipe(writeStream);
            let stderr = '';
            child.stderr.on('data', (data) => {
                stderr += data.toString();
            });
            child.on('close', (code) => {
                if (code === 0) {
                    resolve();
                }
                else {
                    const errorMsg = stderr || `Proceso de backup falló con código ${code}`;
                    reject(new Error(errorMsg));
                }
            });
            child.on('error', (err) => {
                reject(err);
            });
        });
    }
};
exports.BackupService = BackupService;
exports.BackupService = BackupService = BackupService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], BackupService);
//# sourceMappingURL=backup.service.js.map