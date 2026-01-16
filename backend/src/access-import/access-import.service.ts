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

        // 1. Intentar matching con entidades locales
        const localMatch = await this.findLocalEntities(parsedMarea, record.Buque, record.CodObs);

        if (!existing) {
            // Registro nuevo -> Alerta ZARPADA (si tiene fecha)
            const hasZarpada = !!record.Fecha_Zarpada;

            await this.prisma.importacionAccessSnapshot.create({
                data: {
                    idExterno: record.Id,
                    nroMarea: parsedMarea.nroMarea,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    nroEtapa: record.NroEtapa || 1,
                    fechaZarpada: this.readerService.parseDate(record.Fecha_Zarpada),
                    fechaArribo: this.readerService.parseDate(record.Fecha_Arribo),
                    buqueNombre: record.Buque,
                    observadorCodigo: record.CodObs,
                    hashContenido: hash,
                    mareaId: localMatch.marea?.id,
                    etapaId: localMatch.etapa?.id,
                },
            });

            if (hasZarpada) {
                await this.createAlert('ZARPADA', record, localMatch, parsedMarea);
                return { type: 'NEW', alertGenerated: true };
            }
            return { type: 'NEW', alertGenerated: false };
        }

        if (existing.hashContenido === hash) {
            return { type: 'UNCHANGED', alertGenerated: false };
        }

        // El hash cambió -> ¿Es un arribo nuevo?
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
            await this.createAlert('ARRIBO', record, localMatch, parsedMarea);
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

    private async findLocalEntities(parsedMarea: any, buqueNombre: string, codObs: number) {
        const [marea, buque, observador] = await Promise.all([
            // Matching de marea
            this.prisma.marea.findFirst({
                where: {
                    nroMarea: parsedMarea.nroMarea || undefined,
                    anioMarea: parsedMarea.anioMarea,
                    tipoMarea: parsedMarea.tipoMarea,
                    activo: true
                },
                include: { etapas: true } // Cambiar por 'etapas' si ese es el nombre
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

        // Intentar encontrar la etapa específica si hay marea
        const mareaConEtapas = marea as (any & { etapas: any[] });
        const etapa = mareaConEtapas?.etapas?.find((e: any) => e.nroEtapa === 1);

        return { marea, buque, observador, etapa };
    }

    private async createAlert(tipo: 'ZARPADA' | 'ARRIBO', record: ExternalRecord, localMatch: any, parsedMarea: any) {
        const { marea, buque, observador } = localMatch;

        const mareaLabel = parsedMarea.tipoMarea === 'CI'
            ? `CI (${parsedMarea.anioMarea})`
            : `${parsedMarea.tipoMarea} ${parsedMarea.nroMarea}/${parsedMarea.anioMarea}`;

        const fecha = tipo === 'ZARPADA' ? record.Fecha_Zarpada : record.Fecha_Arribo;

        let descripcion = `Se detectó ${tipo.toLowerCase()} en sistema externo para ${record.Buque} (${mareaLabel}).`;

        if (!marea) {
            descripcion += ` \n⚠️ ATENCIÓN: La marea no fue encontrada en nuestro sistema.`;
        }

        if (observador) {
            descripcion += ` \nObservador vinculado: ${observador.nombre} ${observador.apellido} (Cód: ${observador.codigoInterno})`;
        } else {
            descripcion += ` \nObservador externo: Cód ${record.CodObs} (No encontrado en DB local)`;
        }

        await this.alertsService.create({
            codigoUnico: `EXTERNO-${tipo}-${record.Id}`,
            referenciaId: marea?.id || buque?.id || null,
            referenciaTipo: marea ? 'MAREA' : (buque ? 'BUQUE' : 'OTRO'),
            tipo: tipo,
            titulo: `${tipo}: ${record.Buque} - ${mareaLabel}`,
            descripcion: descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            metadata: {
                idExterno: record.Id,
                source: 'ACCESS_IMPORT',
                fechaEvento: fecha,
                etapa: record.NroEtapa
            }
        });
    }
}
