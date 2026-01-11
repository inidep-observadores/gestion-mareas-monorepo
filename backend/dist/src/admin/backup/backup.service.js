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
                (0, child_process_1.execSync)('pg_dump --version', { stdio: 'ignore' });
                console.log(`[BackupService] pg_dump encontrado en host Windows.`);
                const command = `pg_dump -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}" -f "${filePath}"`;
                (0, child_process_1.execSync)(command, {
                    env: { ...process.env, PGPASSWORD: dbPass },
                    stdio: 'pipe'
                });
            }
            catch (localError) {
                console.warn(`[BackupService] pg_dump NO encontrado en host. Usando Docker fallback 'mareasdb'...`);
                const dockerCommand = `docker exec -e PGPASSWORD="${dbPass}" mareasdb pg_dump -h localhost -p 5432 -U "${dbUser}" -d "${dbName}"`;
                console.log(`[BackupService] Ejecutando en Docker: ${dockerCommand}`);
                const output = (0, child_process_1.execSync)(dockerCommand, {
                    maxBuffer: 1024 * 1024 * 100,
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
                const stats = fs.statSync(path.join(this.backupPath, f));
                return {
                    filename: f,
                    size: stats.size,
                    createdAt: stats.birthtime,
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
        try {
            this.logger.warn(`Restoring database from: ${filename}`);
            try {
                (0, child_process_1.execSync)('psql --version', { stdio: 'ignore' });
                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                const command = `${catCmd} "${filePath}" | psql -h "${dbHost}" -p "${dbPort}" -U "${dbUser}" -d "${dbName}"`;
                (0, child_process_1.execSync)(command, {
                    env: { ...process.env, PGPASSWORD: dbPass },
                    stdio: 'pipe',
                    shell: true
                });
            }
            catch (localError) {
                this.logger.warn(`psql not found on host, trying via Docker 'mareasdb'...`);
                const catCmd = process.platform === 'win32' ? 'type' : 'cat';
                const dockerCommand = `${catCmd} "${filePath}" | docker exec -i -e PGPASSWORD="${dbPass}" mareasdb psql -U ${dbUser} -d ${dbName}`;
                (0, child_process_1.execSync)(dockerCommand, { stdio: 'pipe', shell: true });
            }
            return {
                message: 'Database restored successfully',
                filename,
            };
        }
        catch (error) {
            const stderr = error.stderr?.toString() || '';
            this.logger.error(`Restore failed. Stderr: ${stderr} - Error: ${error.message}`);
            let userFriendlyMsg = 'La restauración de la base de datos falló.';
            if (error.message.includes('mareasdb') || error.message.includes('No such container')) {
                userFriendlyMsg += ' El contenedor "mareasdb" no está corriendo.';
            }
            else if (stderr.includes('connection failed')) {
                userFriendlyMsg += ' No se pudo conectar a la base de datos dentro del contenedor.';
            }
            else {
                userFriendlyMsg += ` ${stderr.slice(0, 100)}`;
            }
            throw new common_1.InternalServerErrorException(userFriendlyMsg);
        }
    }
    async deleteBackup(filename) {
        const filePath = path.join(this.backupPath, filename);
        if (!fs.existsSync(filePath)) {
            throw new common_1.NotFoundException('Backup file not found');
        }
        try {
            fs.unlinkSync(filePath);
            return { message: 'Backup deleted successfully' };
        }
        catch (error) {
            this.logger.error(`Deletion failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Failed to delete backup');
        }
    }
};
exports.BackupService = BackupService;
exports.BackupService = BackupService = BackupService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], BackupService);
//# sourceMappingURL=backup.service.js.map