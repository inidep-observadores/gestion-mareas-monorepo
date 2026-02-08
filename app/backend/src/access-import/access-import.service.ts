import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { AlertsService } from '../alerts/alerts.service';
import { AlertaEstado, AlertaPrioridad } from '../alerts/alerts.enums';
import { AlertMetadata } from '@sigma/types';
import { AccessReaderService, ExternalRecord } from './access-reader.service';
import { ErrorLogsService } from '../common/error-logs/error-logs.service';
import { TipoMarea } from '../mareas/mareas.constants';
import * as crypto from 'crypto';
import { DateTime } from 'luxon';

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
        // Normalizar fechas del record antes de generar hash y procesar
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

        // 1. Intentar matching con entidades locales (Prioridad 1: Match Directo)
        const localMatch = await this.findLocalEntities(parsedMarea, normalizedRecord, nroEtapa);

        if (!existing) {
            // Registro nuevo -> Determinar tipo de hallazgo
            let tipoHallazgo: 'NUEVA_MAREA' | 'NUEVA_ETAPA' | 'ERROR_FECHA_MOVIMIENTO' | 'SINCRONIZADO' | 'POSIBLE_ZARPADA' | 'ETAPA_FALTANTE' = 'NUEVA_MAREA';

            if (!localMatch.marea) {
                tipoHallazgo = 'NUEVA_MAREA';
            } else if (!localMatch.etapa) {
                // Validar coherencia de etapas: verificar que no haya saltos
                const etapasExistentes = localMatch.marea.etapas || [];
                const maxEtapa = etapasExistentes.length > 0
                    ? Math.max(...etapasExistentes.map((e: any) => e.nroEtapa || 0))
                    : 0;

                if (nroEtapa > maxEtapa + 1) {
                    // Hay etapas faltantes (ej: existe etapa 1, pero Access reporta etapa 3)
                    tipoHallazgo = 'ETAPA_FALTANTE';
                } else if (localMatch.marea.estadoActual?.codigo === 'DESIGNADA' && nroEtapa === 1) {
                    // Si es marea DESIGNADA, solo permitimos Etapa #1 como zarpada automática
                    tipoHallazgo = 'POSIBLE_ZARPADA';
                } else {
                    tipoHallazgo = 'NUEVA_ETAPA';
                }
            } else {
                // Existe marea y etapa -> ¿Coinciden las fechas? (Considerando UTC-3 y tolerancia)
                const zarpadaMatches = this.datesMatch(normalizedRecord.Fecha_Zarpada, localMatch.etapa.fechaZarpada);
                const arriboMatches = this.datesMatch(normalizedRecord.Fecha_Arribo, localMatch.etapa.fechaArribo);

                tipoHallazgo = (zarpadaMatches && arriboMatches) ? 'SINCRONIZADO' : 'ERROR_FECHA_MOVIMIENTO';
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

        // El hash cambió -> Detectar qué cambió específicamente
        const previousZarpada = existing.fechaZarpada;
        const previousArribo = existing.fechaArribo;
        const currentZarpada = normalizedRecord.Fecha_Zarpada;
        const currentArribo = normalizedRecord.Fecha_Arribo;

        await this.prisma.importacionAccessSnapshot.update({
            where: { id: existing.id },
            data: {
                fechaZarpada: currentZarpada,
                fechaArribo: currentArribo,
                hashContenido: hash,
                mareaId: localMatch.marea?.id,
                etapaId: localMatch.etapa?.id,
            },
        });

        let alertGenerated = false;

        // Detectar cambio en ZARPADA
        if (previousZarpada && currentZarpada && !this.datesMatch(previousZarpada, currentZarpada)) {
            if (localMatch.etapa) {
                // Verificar si la nueva fecha difiere de la local
                if (!this.datesMatch(currentZarpada, localMatch.etapa.fechaZarpada)) {
                    await this.createAlertFromHallazgo('ERROR_FECHA_MOVIMIENTO', record, localMatch, parsedMarea);
                    alertGenerated = true;
                }
            }
        }

        // Detectar cambio en ARRIBO (nuevo o modificado)
        const isNewArribo = !previousArribo && !!currentArribo;
        const isModifiedArribo = previousArribo && currentArribo && !this.datesMatch(previousArribo, currentArribo);

        if (isNewArribo || isModifiedArribo) {
            if (localMatch.etapa) {
                // Verificar si la fecha de arribo difiere de la local
                if (!this.datesMatch(currentArribo, localMatch.etapa.fechaArribo)) {
                    await this.createAlertFromHallazgo('ERROR_FECHA_MOVIMIENTO', record, localMatch, parsedMarea);
                    alertGenerated = true;
                }
            } else {
                // No hay etapa local, reportar como arribo nuevo
                await this.createAlertFromHallazgo('ARRIBO', record, localMatch, parsedMarea);
                alertGenerated = true;
            }
        }

        return { type: 'UPDATED', alertGenerated };
    }

    private parseMareaIdentifier(nroMareaStr: string, fechaZarpadaRaw: Date | string) {
        const fechaZarpada = this.readerService.parseDate(fechaZarpadaRaw) || new Date();

        if (nroMareaStr === 'CI') {
            return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: TipoMarea.CI };
        }

        const parts = nroMareaStr.split('/');
        if (parts.length === 2) {
            return {
                nroMarea: parseInt(parts[0], 10),
                anioMarea: parseInt(parts[1], 10),
                tipoMarea: TipoMarea.MC
            };
        }

        return { nroMarea: null, anioMarea: fechaZarpada.getFullYear(), tipoMarea: TipoMarea.MC };
    }

    private async findLocalEntities(parsedMarea: any, record: ExternalRecord, nroEtapa: number) {
        const buqueNombre = record.Buque;
        const codObs = record.CodObs;

        // Prioridad 1: Match Directo por Nro/Año/Tipo
        let marea = await this.prisma.marea.findFirst({
            where: {
                nroMarea: parsedMarea.nroMarea || undefined,
                anioMarea: parsedMarea.anioMarea,
                tipoMarea: parsedMarea.tipoMarea,
                activo: true
            },
            include: {
                etapas: true,
                buque: true,
                observadorPrincipal: true,
                estadoActual: true
            }
        });

        // Prioridad 2: Match por Buque y Cercanía Temporal (si P1 falla)
        if (!marea && buqueNombre && parsedMarea.anioMarea) {
            const buque = await this.prisma.buque.findFirst({
                where: { nombreBuque: { equals: buqueNombre, mode: 'insensitive' } }
            });

            if (buque) {
                // Ventana temporal: +/- 1 año del año de la marea en Access
                const minYear = parsedMarea.anioMarea - 1;
                const maxYear = parsedMarea.anioMarea + 1;

                marea = await this.prisma.marea.findFirst({
                    where: {
                        buqueId: buque.id,
                        activo: true,
                        anioMarea: { gte: minYear, lte: maxYear },
                        OR: [
                            { etapas: { some: { fechaZarpada: { not: null } } } },
                            { estadoActual: { codigo: 'DESIGNADA' } }
                        ]
                    },
                    include: {
                        etapas: true,
                        buque: true,
                        observadorPrincipal: true,
                        estadoActual: true
                    },
                    orderBy: { anioMarea: 'desc' } // Tomar la más reciente dentro de la ventana
                }) as any;
            }
        }

        const mareaConEtapas = marea as (any & { etapas: any[] });
        let etapa = mareaConEtapas?.etapas?.find((eIn: any) => (eIn.nroEtapa || eIn.nro_etapa) === nroEtapa);

        // SEGUNDA PASADA: Si no hay match por nroEtapa, buscar por coincidencia de fechas (+/- 1 día)
        if (!etapa && mareaConEtapas?.etapas?.length > 0) {
            etapa = mareaConEtapas.etapas.find((eIn: any) => {
                const accessZarpada = record.Fecha_Zarpada;
                const accessArribo = record.Fecha_Arribo;

                // Match por Zarpada
                if (accessZarpada && eIn.fechaZarpada && this.datesMatchWithTolerance(accessZarpada, eIn.fechaZarpada, 1)) {
                    return true;
                }

                // Match por Arribo
                if (accessArribo && eIn.fechaArribo && this.datesMatchWithTolerance(accessArribo, eIn.fechaArribo, 1)) {
                    return true;
                }

                return false;
            });

            if (etapa) {
                this.logger.log(`Etapa #${nroEtapa} de Access vinculada a Etapa Local #${etapa.nroEtapa} por coincidencia de fechas.`);
            }
        }

        const observador = await this.prisma.observador.findFirst({
            where: { codigoInterno: codObs, activo: true }
        });

        // Extraer buque de la marea o del buque encontrado individualmente
        const finalBuque = marea?.buque || (await this.prisma.buque.findFirst({
            where: { nombreBuque: { equals: buqueNombre, mode: 'insensitive' } }
        }));

        return { marea, buque: finalBuque, observador, etapa };
    }

    private datesMatchWithTolerance(d1: Date | string | null | undefined, d2: Date | string | null | undefined, daysTolerance: number = 1): boolean {
        const dateEx = this.readerService.parseDate(d1);
        const dateLoc = this.readerService.parseDate(d2);

        if (!dateEx || !dateLoc) return false;

        const luxEx = DateTime.fromJSDate(dateEx).setZone('America/Argentina/Buenos_Aires').startOf('day');
        const luxLoc = DateTime.fromJSDate(dateLoc).setZone('America/Argentina/Buenos_Aires').startOf('day');

        const diffInDays = Math.abs(luxEx.diff(luxLoc, 'days').days);
        return diffInDays <= daysTolerance;
    }

    private datesMatch(d1: Date | string | null | undefined, d2: Date | string | null | undefined): boolean {
        const dateEx = this.readerService.parseDate(d1);
        const dateLoc = this.readerService.parseDate(d2);

        if (!dateEx && !dateLoc) return true;
        if (!dateEx || !dateLoc) return false;

        // Comparar SOLO por fecha, ignorando completamente la hora
        // Forzar UTC-3 para ambos
        const luxEx = DateTime.fromJSDate(dateEx).setZone('America/Argentina/Buenos_Aires');
        const luxLoc = DateTime.fromJSDate(dateLoc).setZone('America/Argentina/Buenos_Aires');

        // Comparación estricta por día calendario (YYYY-MM-DD)
        return luxEx.toISODate() === luxLoc.toISODate();
    }

    private toLocalDateString(date: Date): string {
        try {
            return new Intl.DateTimeFormat('sv-SE', {
                timeZone: process.env.APP_TIMEZONE || 'America/Argentina/Buenos_Aires'
            }).format(date);
        } catch (error) {
            // Fallback en caso de zona horaria inválida
            return date.toISOString().split('T')[0];
        }
    }

    private async createAlertFromHallazgo(
        tipoHallazgo: 'NUEVA_MAREA' | 'NUEVA_ETAPA' | 'ERROR_FECHA_MOVIMIENTO' | 'SINCRONIZADO' | 'ARRIBO' | 'POSIBLE_ZARPADA' | 'ETAPA_FALTANTE',
        record: ExternalRecord,
        localMatch: any,
        parsedMarea: any
    ) {
        if (tipoHallazgo === 'SINCRONIZADO') return;

        const { marea, buque, observador, etapa } = localMatch;
        const yearSuffix = String(parsedMarea.anioMarea || '').slice(-2);
        const mareaLabel = parsedMarea.tipoMarea === TipoMarea.CI
            ? `CI - ${yearSuffix} `
            : `MC - ${parsedMarea.nroMarea} -${yearSuffix} `;

        const nroEtapa = record.NroEtapa || 1;
        const buqueNombre = marea?.buque?.nombreBuque || buque?.nombreBuque || record.Buque;

        let titulo = '';
        let descripcion = '';
        let alertTypeBase = 'OTRO';
        let subTipo = tipoHallazgo === 'ERROR_FECHA_MOVIMIENTO' ? 'EDITAR_ETAPA' : tipoHallazgo;

        switch (tipoHallazgo) {
            case 'NUEVA_MAREA':
                alertTypeBase = 'NUEVA_MAREA';
                titulo = `NUEVA MAREA(Access): ${buqueNombre} - ${mareaLabel} `;
                descripcion = `Se detectó una nueva marea en Access que no existe localmente.`;
                break;
            case 'NUEVA_ETAPA':
                alertTypeBase = 'NUEVA_ETAPA';
                titulo = `NUEVA ETAPA(Access): ${buqueNombre} - ${mareaLabel} (Etapa ${nroEtapa})`;
                descripcion = `La marea existe pero tiene una nueva etapa(#${nroEtapa}) en Access.`;
                break;
            case 'ERROR_FECHA_MOVIMIENTO':
                alertTypeBase = 'ERROR_FECHA_MOVIMIENTO';
                subTipo = 'EDITAR_ETAPA';
                titulo = `Incongruencia de FECHA(Access): ${buqueNombre} (${mareaLabel})`;

                // Formatear fechas para mostrar en la descripción
                const formatDate = (date: Date | string | null | undefined) => {
                    if (!date) return 'N/D';
                    const parsedDate = this.readerService.parseDate(date);
                    if (!parsedDate) return 'N/D';
                    return new Intl.DateTimeFormat('es-AR', {
                        day: '2-digit',
                        month: '2-digit',
                        year: 'numeric'
                    }).format(parsedDate);
                };

                const accessZarpada = formatDate(record.Fecha_Zarpada);
                const accessArribo = formatDate(record.Fecha_Arribo);
                const localZarpada = formatDate(etapa?.fechaZarpada);
                const localArribo = formatDate(etapa?.fechaArribo);

                descripcion = `Existen diferencias entre las fechas locales y las de Access para la etapa #${nroEtapa}.\n\n` +
                    `📅 FECHAS EN ACCESS: \n` +
                    `  • Zarpada: ${accessZarpada} \n` +
                    `  • Arribo: ${accessArribo} \n\n` +
                    `📅 FECHAS LOCALES: \n` +
                    `  • Zarpada: ${localZarpada} \n` +
                    `  • Arribo: ${localArribo} \n\n` +
                    `Se sugiere EDITAR LA ETAPA para corregir la fecha oficial.`;
                break;
            case 'ARRIBO':
                alertTypeBase = 'POSIBLE_ARRIBO';
                titulo = `ARRIBO(Access): ${buqueNombre} - ${mareaLabel} (Etapa ${nroEtapa})`;
                descripcion = `Se detectó arribo en sistema externo para la etapa #${nroEtapa}.`;
                break;
            case 'POSIBLE_ZARPADA':
                alertTypeBase = 'POSIBLE_ZARPADA';
                subTipo = 'ZARPADA'; // Alinear con CSV (subTipo es el evento)
                titulo = `ZARPADA(Access): ${buqueNombre} - ${mareaLabel} `;
                descripcion = `Se detectó la zarpada de una marea designada en el sistema externo.`;
                break;
            case 'ETAPA_FALTANTE':
                alertTypeBase = 'NUEVA_ETAPA';
                subTipo = 'EDITAR_ETAPA';
                titulo = `ETAPAS FALTANTES(Access): ${buqueNombre} - ${mareaLabel} `;
                descripcion = `Se detectó la etapa #${nroEtapa} en Access, pero faltan etapas intermedias en el sistema local.Se recomienda EDITAR LAS ETAPAS para completar la información.`;
                break;
            default:
                titulo = `${tipoHallazgo} (Access): ${buqueNombre} - ${mareaLabel} `;
                descripcion = `Novedad detectada en sistema externo.`;
        }

        if (observador) {
            descripcion += `\n\nObservador: ${observador.nombre} ${observador.apellido} (Cód: ${observador.codigoInterno})`;
        }

        const eventDate = this.readerService.parseDate(record.Fecha_Arribo || record.Fecha_Zarpada);
        const type = record.Fecha_Arribo ? 'ARRIBO' : 'ZARPADA';

        await this.alertsService.create({
            codigoUnico: `ACCESS - ${tipoHallazgo} -${record.Id} `,
            referenciaId: marea?.id || buque?.id || null,
            referenciaTipo: marea ? 'MAREA' : (buque ? 'BUQUE' : 'OTRO'),
            tipo: alertTypeBase as any,
            titulo: titulo,
            descripcion: descripcion,
            estado: AlertaEstado.PENDIENTE,
            prioridad: AlertaPrioridad.MEDIA,
            visible: true,
            metadata: {
                // Metadata Estandarizada - Igual al proceso CSV
                type,
                portId: null,
                buqueId: buque?.id || marea?.buqueId || null,
                mareaId: marea?.id || null,
                subTipo: subTipo,
                nroEtapa: nroEtapa,
                portName: null,
                eventDate: eventDate,
                mareaCode: mareaLabel,
                vesselName: buqueNombre,
                fechaZarpada: record.Fecha_Zarpada,
                fechaArribo: record.Fecha_Arribo,

                // Campos adicionales específicos de Access (no interfieren)
                idExterno: record.Id?.toString(),
                source: 'ACCESS_IMPORT',

                externalData: {
                    fechaZarpada: record.Fecha_Zarpada,
                    fechaArribo: record.Fecha_Arribo,
                    buque: record.Buque,
                    nroMarea: record.NroMarea ? parseInt(record.NroMarea, 10) : undefined,
                    // Datos del observador externo si no hay match local
                    observer: !observador ? {
                        nombre: record.ObservadorNombre,
                        apellido: record.ObservadorApellido,
                        codigo: record.CodObs?.toString()
                    } : undefined
                },
                localData: etapa ? {
                    fechaZarpada: etapa.fechaZarpada,
                    fechaArribo: etapa.fechaArribo,
                    id: etapa.id
                } : null
            } as AlertMetadata
        });
    }
}
