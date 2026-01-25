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
var AccessImportService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.AccessImportService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
const alerts_service_1 = require("../alerts/alerts.service");
const alerts_enums_1 = require("../alerts/alerts.enums");
const access_reader_service_1 = require("./access-reader.service");
const error_logs_service_1 = require("../common/error-logs/error-logs.service");
const mareas_constants_1 = require("../mareas/mareas.constants");
const crypto = require("crypto");
let AccessImportService = AccessImportService_1 = class AccessImportService {
    constructor(prisma, alertsService, readerService, errorLogsService) {
        this.prisma = prisma;
        this.alertsService = alertsService;
        this.readerService = readerService;
        this.errorLogsService = errorLogsService;
        this.logger = new common_1.Logger(AccessImportService_1.name);
    }
    async processFile(buffer) {
        try {
            const rawRecords = await this.readerService.readAccessFile(buffer);
            return await this.processRecords(rawRecords);
        }
        catch (error) {
            await this.errorLogsService.create({
                level: 'CRITICAL',
                source: 'BACKEND',
                context: 'AccessImportService.processFile',
                message: error.message,
                stack: error.stack,
                detail: { error }
            });
            throw error;
        }
    }
    async processRecords(records) {
        const summary = {
            total: records.length,
            nuevos: 0,
            actualizados: 0,
            sinCambios: 0,
            alertasGeneradas: 0,
        };
        let count = 0;
        for (const record of records) {
            count++;
            if (count % 100 === 0) {
                this.logger.log(`Procesados ${count} de ${records.length} registros...`);
            }
            const result = await this.processSingleRecord(record);
            if (result.type === 'NEW')
                summary.nuevos++;
            if (result.type === 'UPDATED')
                summary.actualizados++;
            if (result.type === 'UNCHANGED')
                summary.sinCambios++;
            if (result.alertGenerated)
                summary.alertasGeneradas++;
        }
        return summary;
    }
    async processSingleRecord(record) {
        const normalizedRecord = {
            ...record,
            Fecha_Zarpada: this.readerService.parseDate(record.Fecha_Zarpada),
            Fecha_Arribo: this.readerService.parseDate(record.Fecha_Arribo)
        };
        const snapshotContent = JSON.stringify(normalizedRecord);
        const hash = crypto.createHash('md5').update(snapshotContent).digest('hex');
        const existing = await this.prisma.importacionAccessSnapshot.findUnique({
            where: { idExterno: record.Id },
        });
        const parsedMarea = this.parseMareaIdentifier(record.NroMarea, normalizedRecord.Fecha_Zarpada);
        const nroEtapa = record.NroEtapa || 1;
        const localMatch = await this.findLocalEntities(parsedMarea, record.Buque, record.CodObs, nroEtapa);
        if (!existing) {
            let tipoHallazgo = 'NUEVA_MAREA';
            if (!localMatch.marea) {
                tipoHallazgo = 'NUEVA_MAREA';
            }
            else if (!localMatch.etapa) {
                tipoHallazgo = 'NUEVA_ETAPA';
            }
            else {
                const zarpadaMatches = this.datesMatch(normalizedRecord.Fecha_Zarpada, localMatch.etapa.fechaZarpada);
                const arriboMatches = this.datesMatch(normalizedRecord.Fecha_Arribo, localMatch.etapa.fechaArribo);
                const observerMatches = localMatch.marea.observadorPrincipalId === localMatch.observador?.id;
                tipoHallazgo = (zarpadaMatches && arriboMatches && observerMatches) ? 'SINCRONIZADO' : 'INCONGRUENCIA';
            }
            await this.prisma.importacionAccessSnapshot.create({
                data: {
                    idExterno: record.Id,
                    nroMarea: parsedMarea.nroMarea,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    nroEtapa: nroEtapa,
                    fechaZarpada: normalizedRecord.Fecha_Zarpada,
                    fechaArribo: normalizedRecord.Fecha_Arribo,
                    buqueNombre: record.Buque,
                    observadorCodigo: record.CodObs,
                    hashContenido: hash,
                    mareaId: localMatch.marea?.id,
                    etapaId: localMatch.etapa?.id,
                },
            });
            await this.createAlertFromHallazgo(tipoHallazgo, record, localMatch, parsedMarea);
            return { type: 'NEW', alertGenerated: tipoHallazgo !== 'SINCRONIZADO' };
        }
        if (existing.hashContenido === hash) {
            return { type: 'UNCHANGED', alertGenerated: false };
        }
        const previousArribo = existing.fechaArribo;
        const currentArribo = normalizedRecord.Fecha_Arribo;
        const isNewArribo = !previousArribo && !!currentArribo;
        await this.prisma.importacionAccessSnapshot.update({
            where: { id: existing.id },
            data: {
                fechaZarpada: normalizedRecord.Fecha_Zarpada,
                fechaArribo: currentArribo,
                hashContenido: hash,
                mareaId: localMatch.marea?.id,
                etapaId: localMatch.etapa?.id,
            },
        });
        if (isNewArribo) {
            await this.createAlertFromHallazgo('ARRIBO', record, localMatch, parsedMarea);
            return { type: 'UPDATED', alertGenerated: true };
        }
        return { type: 'UPDATED', alertGenerated: false };
    }
    parseMareaIdentifier(nroMareaStr, fechaZarpadaRaw) {
        const fechaZarpada = this.readerService.parseDate(fechaZarpadaRaw) || new Date();
        if (nroMareaStr === 'CI') {
            return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: mareas_constants_1.TipoMarea.CI };
        }
        const parts = nroMareaStr.split('/');
        if (parts.length === 2) {
            return {
                nroMarea: parseInt(parts[0], 10),
                anioMarea: parseInt(parts[1], 10),
                tipoMarea: mareas_constants_1.TipoMarea.MC
            };
        }
        return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: mareas_constants_1.TipoMarea.MC };
    }
    async findLocalEntities(parsedMarea, buqueNombre, codObs, nroEtapa) {
        const [marea, buque, observador] = await Promise.all([
            this.prisma.marea.findFirst({
                where: {
                    nroMarea: parsedMarea.nroMarea || undefined,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    activo: true
                },
                include: {
                    etapas: true,
                    observadorPrincipal: true
                }
            }),
            this.prisma.buque.findFirst({
                where: {
                    nombreBuque: { equals: buqueNombre, mode: 'insensitive' },
                    activo: true
                }
            }),
            this.prisma.observador.findFirst({
                where: {
                    codigoInterno: codObs,
                    activo: true
                }
            }),
        ]);
        const mareaConEtapas = marea;
        const etapa = mareaConEtapas?.etapas?.find((eIn) => (eIn.nroEtapa || eIn.nro_etapa) === nroEtapa);
        return { marea, buque, observador, etapa };
    }
    datesMatch(d1, d2) {
        const date1 = this.readerService.parseDate(d1);
        const date2 = this.readerService.parseDate(d2);
        if (!date1 && !date2)
            return true;
        if (!date1 || !date2)
            return false;
        return this.toLocalDateString(date1) === this.toLocalDateString(date2);
    }
    toLocalDateString(date) {
        try {
            return new Intl.DateTimeFormat('sv-SE', {
                timeZone: process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires'
            }).format(date);
        }
        catch (error) {
            return date.toISOString().split('T')[0];
        }
    }
    async createAlertFromHallazgo(tipoHallazgo, record, localMatch, parsedMarea) {
        const { marea, buque, observador, etapa } = localMatch;
        const yearSuffix = String(parsedMarea.anioMarea || '').slice(-2);
        const mareaLabel = parsedMarea.tipoMarea === mareas_constants_1.TipoMarea.CI
            ? `CI-${yearSuffix}`
            : `MC-${parsedMarea.nroMarea}-${yearSuffix}`;
        const nroEtapa = record.NroEtapa || 1;
        let titulo = '';
        let descripcion = '';
        let estado = alerts_enums_1.AlertaEstado.PENDIENTE;
        switch (tipoHallazgo) {
            case 'NUEVA_MAREA':
                titulo = `NUEVA MAREA: ${record.Buque} - ${mareaLabel}`;
                descripcion = `Se detectó una nueva marea en el sistema externo que no existe localmente.`;
                break;
            case 'NUEVA_ETAPA':
                titulo = `NUEVA ETAPA: ${record.Buque} - ${mareaLabel} (Etapa ${nroEtapa})`;
                descripcion = `La marea existe pero tiene una nueva etapa (#${nroEtapa}) en el sistema externo.`;
                break;
            case 'INCONGRUENCIA':
                titulo = `INCONGRUENCIA: ${record.Buque} - ${mareaLabel} (Etapa ${nroEtapa})`;
                descripcion = `Existen diferencias entre las fechas locales y las del sistema externo para la etapa #${nroEtapa}.`;
                break;
            case 'SINCRONIZADO':
                titulo = `SINCRONIZADO: ${record.Buque} - ${mareaLabel}`;
                descripcion = `Los datos del sistema externo coinciden plenamente con los registros locales. Sincronización automática realizada.`;
                estado = alerts_enums_1.AlertaEstado.DESCARTADA;
                break;
            case 'ARRIBO':
                titulo = `ARRIBO: ${record.Buque} - ${mareaLabel} (Etapa ${nroEtapa})`;
                descripcion = `Se detectó arribo en sistema externo para la etapa #${nroEtapa}.`;
                break;
            default:
                titulo = `${tipoHallazgo}: ${record.Buque} - ${mareaLabel}`;
                descripcion = `Novedad detectada en sistema externo.`;
        }
        if (observador) {
            descripcion += ` \nObservador: ${observador.nombre} ${observador.apellido} (Cód: ${observador.codigoInterno})`;
        }
        else if (record.ObservadorNombre) {
            descripcion += ` \nObservador (Access): ${record.ObservadorNombre} ${record.ObservadorApellido} (Cód: ${record.CodObs})`;
        }
        await this.alertsService.create({
            codigoUnico: `EXTERNO-${tipoHallazgo}-${record.Id}`,
            referenciaId: marea?.id || buque?.id || null,
            referenciaTipo: marea ? 'MAREA' : (buque ? 'BUQUE' : 'OTRO'),
            tipo: tipoHallazgo,
            titulo: titulo,
            descripcion: descripcion,
            estado: estado,
            prioridad: alerts_enums_1.AlertaPrioridad.MEDIA,
            visible: tipoHallazgo !== 'SINCRONIZADO',
            metadata: {
                idExterno: record.Id,
                source: 'ACCESS_IMPORT',
                subTipo: tipoHallazgo,
                nroEtapa: nroEtapa,
                anioMarea: parsedMarea.anioMarea || undefined,
                nroMarea: parsedMarea.nroMarea || undefined,
                observerCode: observador?.codigoInterno || record.CodObs || undefined,
                externalObserver: record.ObservadorNombre ? {
                    nombre: record.ObservadorNombre,
                    apellido: record.ObservadorApellido,
                    codigo: record.CodObs
                } : undefined,
                externalData: {
                    fechaZarpada: record.Fecha_Zarpada,
                    fechaArribo: record.Fecha_Arribo,
                    buque: record.Buque,
                    nroMarea: record.NroMarea
                },
                localData: etapa ? {
                    fechaZarpada: etapa.fechaZarpada,
                    fechaArribo: etapa.fechaArribo,
                    id: etapa.id
                } : null
            }
        });
    }
};
exports.AccessImportService = AccessImportService;
exports.AccessImportService = AccessImportService = AccessImportService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        alerts_service_1.AlertsService,
        access_reader_service_1.AccessReaderService,
        error_logs_service_1.ErrorLogsService])
], AccessImportService);
//# sourceMappingURL=access-import.service.js.map