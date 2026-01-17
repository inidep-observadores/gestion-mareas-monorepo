import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { AlertaEstado, AlertaPrioridad } from '../alerts/alerts.enums';
import { AccessReaderService, ExternalRecord } from './access-reader.service';
import { ErrorLogsService } from '../common/error-logs/error-logs.service';
import * as crypto from 'crypto';

export interface ProcessingSummary {
    total: number;
    nuevos: number;
    actualizados: number;
    sinCambios: number;
    alertasGeneradas: number;
}

@Injectable()
export class AccessImportService {
    private readonly logger = new Logger(AccessImportService.name);

    constructor(
        private prisma: PrismaService,
        private alertsService: AlertsService,
        private readerService: AccessReaderService,
        private errorLogsService: ErrorLogsService,
    ) { }

    /**
     * Procesa el archivo subido
     */
    async processFile(buffer: Buffer): Promise<ProcessingSummary> {
        try {
            const rawRecords = await this.readerService.readAccessFile(buffer);
            return await this.processRecords(rawRecords);
        } catch (error) {
            await this.errorLogsService.create({
                level: 'CRITICAL',
                source: 'BACKEND',
                context: 'AccessImportService.processFile',
                message: error.message,
                stack: error.stack,
                detail: { error }
            });
            throw error; // Re-lanzar para que el controlador también responda con error
        }
    }

    /**
     * Lógica central de procesamiento de registros
     */
    async processRecords(records: ExternalRecord[]): Promise<ProcessingSummary> {
        const summary: ProcessingSummary = {
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
            if (result.type === 'NEW') summary.nuevos++;
            if (result.type === 'UPDATED') summary.actualizados++;
            if (result.type === 'UNCHANGED') summary.sinCambios++;
            if (result.alertGenerated) summary.alertasGeneradas++;
        }

        return summary;
    }

    private async processSingleRecord(record: ExternalRecord) {
        const snapshotContent = JSON.stringify(record);
        const hash = crypto.createHash('md5').update(snapshotContent).digest('hex');

        const existing = await this.prisma.importacionAccessSnapshot.findUnique({
            where: { idExterno: record.Id },
        });

        const parsedMarea = this.parseMareaIdentifier(record.NroMarea, record.Fecha_Zarpada);
        const nroEtapa = record.NroEtapa || 1;

        // 1. Intentar matching con entidades locales
        const localMatch = await this.findLocalEntities(parsedMarea, record.Buque, record.CodObs, nroEtapa);

        if (!existing) {
            // Registro nuevo -> Determinar tipo de hallazgo
            let tipoHallazgo: 'NUEVA_MAREA' | 'NUEVA_ETAPA' | 'INCONGRUENCIA' | 'SINCRONIZADO' = 'NUEVA_MAREA';

            if (!localMatch.marea) {
                tipoHallazgo = 'NUEVA_MAREA';
            } else if (!localMatch.etapa) {
                tipoHallazgo = 'NUEVA_ETAPA';
            } else {
                // Existe marea y etapa -> ¿Coinciden las fechas?
                const zarpadaMatches = this.datesMatch(record.Fecha_Zarpada, localMatch.etapa.fechaZarpada);
                const arriboMatches = this.datesMatch(record.Fecha_Arribo, localMatch.etapa.fechaArribo);

                tipoHallazgo = (zarpadaMatches && arriboMatches) ? 'SINCRONIZADO' : 'INCONGRUENCIA';
            }

            await this.prisma.importacionAccessSnapshot.create({
                data: {
                    idExterno: record.Id,
                    nroMarea: parsedMarea.nroMarea,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    nroEtapa: nroEtapa,
                    fechaZarpada: this.readerService.parseDate(record.Fecha_Zarpada),
                    fechaArribo: this.readerService.parseDate(record.Fecha_Arribo),
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

        // El hash cambió -> ¿Es un arribo nuevo o un cambio de fechas?
        const previousArribo = existing.fechaArribo;
        const currentArribo = this.readerService.parseDate(record.Fecha_Arribo);
        const isNewArribo = !previousArribo && !!currentArribo;

        await this.prisma.importacionAccessSnapshot.update({
            where: { id: existing.id },
            data: {
                fechaZarpada: this.readerService.parseDate(record.Fecha_Zarpada),
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

    private parseMareaIdentifier(nroMareaStr: string, fechaZarpadaRaw: Date | string) {
        const fechaZarpada = this.readerService.parseDate(fechaZarpadaRaw) || new Date();

        if (nroMareaStr === 'CI') {
            return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: 'CI' };
        }

        const parts = nroMareaStr.split('/');
        if (parts.length === 2) {
            return {
                nroMarea: parseInt(parts[0], 10),
                anioMarea: parseInt(parts[1], 10),
                tipoMarea: 'MC'
            };
        }

        return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: 'MC' };
    }

    private async findLocalEntities(parsedMarea: any, buqueNombre: string, codObs: number, nroEtapa: number) {
        const [marea, buque, observador] = await Promise.all([
            // Matching de marea
            this.prisma.marea.findFirst({
                where: {
                    nroMarea: parsedMarea.nroMarea || undefined,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    activo: true
                },
                include: { etapas: true }
            } as any),
            // Matching de buque
            this.prisma.buque.findFirst({
                where: {
                    nombreBuque: { equals: buqueNombre, mode: 'insensitive' },
                    activo: true
                }
            }),
            // Matching de observador
            this.prisma.observador.findFirst({
                where: {
                    codigoInterno: codObs,
                    activo: true
                }
            }) as any,
        ]);

        const mareaConEtapas = marea as (any & { etapas: any[] });
        const etapa = mareaConEtapas?.etapas?.find((eIn: any) => (eIn.nroEtapa || eIn.nro_etapa) === nroEtapa);

        return { marea, buque, observador, etapa };
    }

    private datesMatch(d1: Date | string | null | undefined, d2: Date | string | null | undefined): boolean {
        const date1 = this.readerService.parseDate(d1);
        const date2 = this.readerService.parseDate(d2);
        if (!date1 && !date2) return true;
        if (!date1 || !date2) return false;
        return date1.toISOString().split('T')[0] === date2.toISOString().split('T')[0];
    }

    private async createAlertFromHallazgo(
        tipoHallazgo: 'NUEVA_MAREA' | 'NUEVA_ETAPA' | 'INCONGRUENCIA' | 'SINCRONIZADO' | 'ARRIBO' | 'ZARPADA',
        record: ExternalRecord,
        localMatch: any,
        parsedMarea: any
    ) {
        const { marea, buque, observador, etapa } = localMatch;

        const mareaLabel = parsedMarea.tipoMarea === 'CI'
            ? `CI (${parsedMarea.anioMarea})`
            : `${parsedMarea.tipoMarea} ${parsedMarea.nroMarea}/${parsedMarea.anioMarea}`;

        const nroEtapa = record.NroEtapa || 1;
        let titulo = '';
        let descripcion = '';
        let estado = AlertaEstado.PENDIENTE;

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
                estado = AlertaEstado.DESCARTADA;
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

        await this.alertsService.create({
            codigoUnico: `EXTERNO-${tipoHallazgo}-${record.Id}`,
            referenciaId: marea?.id || buque?.id || null,
            referenciaTipo: marea ? 'MAREA' : (buque ? 'BUQUE' : 'OTRO'),
            tipo: tipoHallazgo,
            titulo: titulo,
            descripcion: descripcion,
            estado: estado,
            prioridad: AlertaPrioridad.MEDIA,
            visible: tipoHallazgo !== 'SINCRONIZADO',
            metadata: {
                idExterno: record.Id,
                source: 'ACCESS_IMPORT',
                subTipo: tipoHallazgo,
                nroEtapa: nroEtapa,
                anioMarea: parsedMarea.anioMarea || undefined,
                nroMarea: parsedMarea.nroMarea || undefined,
                observerCode: observador?.codigoInterno || undefined, // ADDED
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
}
