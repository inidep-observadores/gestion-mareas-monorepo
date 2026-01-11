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
        try {
            const command = `docker exec mareasdb pg_dump -U ${dbUser} ${dbName} > "${filePath}"`;
            this.logger.log(`Executing backup: ${command}`);
            (0, child_process_1.execSync)(command);
            return {
                message: 'Backup created successfully',
                filename,
                path: filePath,
            };
        }
        catch (error) {
            this.logger.error(`Backup failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Backup creation failed');
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
        try {
            this.logger.warn(`Restoring database from: ${filename}`);
            const command = `type "${filePath}" | docker exec -i mareasdb psql -U ${dbUser} -d ${dbName}`;
            this.logger.log(`Executing restore: ${command}`);
            (0, child_process_1.execSync)(command);
            return {
                message: 'Database restored successfully',
                filename,
            };
        }
        catch (error) {
            this.logger.error(`Restore failed: ${error.message}`);
            throw new common_1.InternalServerErrorException('Database restoration failed');
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