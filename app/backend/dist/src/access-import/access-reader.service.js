"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var AccessReaderService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccessReaderService = void 0;
const common_1 = require("@nestjs/common");
const mdb_reader_1 = require("mdb-reader");
let AccessReaderService = AccessReaderService_1 = class AccessReaderService {
    constructor() {
        this.logger = new common_1.Logger(AccessReaderService_1.name);
    }
    async readAccessFile(buffer) {
        try {
            const reader = new mdb_reader_1.default(buffer);
            const tables = reader.getTableNames();
            this.logger.log(`Tablas encontradas en el archivo Access: ${tables.join(', ')}`);
            const agentsMap = new Map();
            if (tables.includes('Agentes')) {
                const agentsTable = reader.getTable('Agentes');
                const agentsData = agentsTable.getData();
                for (const agent of agentsData) {
                    if (agent.CodigoObs) {
                        agentsMap.set(Number(agent.CodigoObs), {
                            nombre: String(agent.Nombre || '').trim(),
                            apellido: String(agent.Apellido || '').trim()
                        });
                    }
                }
            }
            const targetTable = tables.find(t => t === 'Mareas') ||
                tables.find(t => !t.startsWith('MSys')) ||
                tables[0];
            if (!targetTable) {
                throw new Error('No se encontraron tablas procesables en el archivo Access.');
            }
            this.logger.log(`Leyendo tabla de novedades: ${targetTable}`);
            const table = reader.getTable(targetTable);
            const data = table.getData();
            const enrichedData = data.map(record => {
                const agent = agentsMap.get(record.CodObs);
                return {
                    ...record,
                    ObservadorNombre: agent?.nombre,
                    ObservadorApellido: agent?.apellido
                };
            });
            return enrichedData;
        }
        catch (error) {
            this.logger.error(`Error al leer archivo Access: ${error.message}`);
            throw new Error(`Error al procesar el archivo .accdb: ${error.message}`);
        }
    }
    parseDate(value) {
        if (!value)
            return null;
        if (value instanceof Date) {
            return isNaN(value.getTime()) ? null : value;
        }
        if (typeof value === 'string' && value.includes('T')) {
            const date = new Date(value);
            return isNaN(date.getTime()) ? null : date;
        }
        if (typeof value === 'string' && value.includes('/')) {
            const parts = value.split('/');
            if (parts.length === 3) {
                const day = parseInt(parts[0], 10);
                const month = parseInt(parts[1], 10) - 1;
                const year = parseInt(parts[2], 10);
                const date = new Date(year, month, day);
                return isNaN(date.getTime()) ? null : date;
            }
        }
        return null;
    }
};
exports.AccessReaderService = AccessReaderService;
exports.AccessReaderService = AccessReaderService = AccessReaderService_1 = __decorate([
    (0, common_1.Injectable)()
], AccessReaderService);
//# sourceMappingURL=access-reader.service.js.map