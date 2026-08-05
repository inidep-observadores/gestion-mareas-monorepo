import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { NovedadesAiService } from '../../mail/novedades-ai.service';
import { DriveStorageService } from '../../files/drive-storage.service';
import { GotenbergService } from '../../files/gotenberg.service';
import { JobProcessor } from '../job-types';
import { DateUtils } from '../../common/utils/date.utils';
import * as fs from 'fs/promises';

@Injectable()
export class NovedadesAiProcessor implements JobProcessor {
    private readonly logger = new Logger(NovedadesAiProcessor.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly novedadesAiService: NovedadesAiService,
        private readonly driveStorageService: DriveStorageService,
        private readonly gotenbergService: GotenbergService,
    ) {}

    async process(payload: any): Promise<any> {
        const { emailLogId, fuente, texto, attachmentData, emailSubject, emailData, explicitDocType, origen, mareaId, mareaArchivoId } = payload;
        const isUiOrigen = origen === 'UI';
        this.logger.log(`Procesando IA | Origen: ${origen || 'EMAIL'} | Log ID: ${emailLogId || 'N/A'} | Fuente: ${fuente}`);

        let extracted: any = null;
        let estadoDetalle = 'PROCESADO';
        let errorDetalle = null;
        let novedadesIds: string[] = [];

        // Leer adjunto desde disco si aplica
        let attachment = null;
        if (attachmentData && attachmentData.filePath) {
            try {
                const buffer = await fs.readFile(attachmentData.filePath);
                attachment = {
                    buffer,
                    mimetype: attachmentData.mimetype,
                    filename: attachmentData.filename
                };
            } catch (error) {
                this.logger.error(`Error leyendo archivo temporal ${attachmentData.filePath}`, error);
                throw new Error(`Error leyendo adjunto local: ${error.message}`);
            }
        }

        try {
            // Extraer JSON estructurado con la IA
            extracted = await this.novedadesAiService.procesarElemento(texto || '', attachment, explicitDocType);
            
            if (extracted.periodos && Array.isArray(extracted.periodos) && extracted.periodos.length > 0) {
                // Buscar al observador
                const obsBusqueda = await this.buscarObservador(
                    extracted.observador, 
                    extracted.cuil, 
                    extracted.dni
                );

                if (!obsBusqueda) {
                    estadoDetalle = 'ERROR';
                    errorDetalle = 'OBSERVADOR_NO_ENCONTRADO';
                } else {
                    if (obsBusqueda.certeza === 'BAJA') {
                        estadoDetalle = 'REQUIERE_REVISION';
                        errorDetalle = 'OBSERVADOR_DUDOSO (Múltiples coincidencias parciales)';
                    }

                    const observador = obsBusqueda.observador;
                    
                    let uploadedDriveInfo: { fileId: string; webViewLink: string } | null = null;
                    let archivoFinal = attachment;

                    // Si la fuente es el cuerpo del correo, generamos un PDF con Gotenberg
                    if (fuente === 'CUERPO' && texto) {
                        try {
                            const htmlContent = `
                                <html>
                                <head><style>body { font-family: sans-serif; padding: 20px; }</style></head>
                                <body>
                                    <h2>Asunto: ${emailSubject}</h2>
                                    <hr/>
                                    <pre style="white-space: pre-wrap;">${texto}</pre>
                                </body>
                                </html>
                            `;
                            const pdfBuffer = await this.gotenbergService.convertHtmlToPdf(htmlContent);
                            archivoFinal = {
                                buffer: pdfBuffer,
                                mimetype: 'application/pdf',
                                filename: 'Cuerpo_Correo.pdf'
                            };
                        } catch (err: any) {
                            this.logger.error(`Error generando PDF del cuerpo con Gotenberg: ${err.message}`);
                        }
                    }

                    if (archivoFinal) {
                        try {
                            uploadedDriveInfo = await this.driveStorageService.uploadFile(
                                archivoFinal.filename,
                                archivoFinal.mimetype,
                                archivoFinal.buffer
                            );
                        } catch (err: any) {
                            this.logger.error(`Error subiendo archivo a Drive: ${err.message}`);
                        }
                    }

                    // Procesar y crear cada período
                    for (const periodo of extracted.periodos) {
                        const codigoNovedad = periodo.tipoNovedad || 'LICEN';
                        let tipoNovedad = await this.prisma.tipoNovedad.findUnique({
                            where: { codigo: codigoNovedad }
                        });

                        if (!tipoNovedad) {
                            tipoNovedad = await this.prisma.tipoNovedad.findFirst();
                        }

                        if (tipoNovedad) {
                            const start = periodo.fechaInicio ? DateUtils.parseToAppZone(periodo.fechaInicio) : DateUtils.getNow(false);
                            let end: Date | null = periodo.fechaFin ? DateUtils.parseToAppZone(periodo.fechaFin) : null;
                            let isInfinite = false;

                            if (['VIAJE_INICIO', 'VIAJE_FIN'].includes(tipoNovedad.codigo)) {
                                if (!end) end = start;
                            } else {
                                if (!end) isInfinite = true;
                            }

                            const overlapConditions: any[] = [
                                {
                                    OR: [
                                        { fechaFin: { gte: start } },
                                        { fechaFin: null }
                                    ]
                                }
                            ];

                            if (!isInfinite) {
                                overlapConditions.push({ fechaInicio: { lte: end } });
                            }

                            const overlaps = await this.prisma.observadorNovedad.findFirst({
                                where: {
                                    observadorId: observador.id,
                                    tipoNovedadId: tipoNovedad.id,
                                    estadoAprobacion: { not: 'RECHAZADA' },
                                    AND: overlapConditions
                                }
                            });

                            if (overlaps) {
                                throw new Error('El observador ya tiene una novedad de este tipo registrada en estas fechas');
                            }

                            const novedad = await this.prisma.observadorNovedad.create({
                                data: {
                                    observadorId: observador.id,
                                    tipoNovedadId: tipoNovedad.id,
                                    fechaInicio: start,
                                    fechaFin: end,
                                    estadoAprobacion: 'PENDIENTE',
                                    origen: 'EMAIL',
                                    motivo: periodo.motivo || emailSubject,
                                    metadata: {
                                        fuente,
                                        certezaAi: obsBusqueda.certeza,
                                        requiereRevision: estadoDetalle === 'REQUIERE_REVISION',
                                        aiExtraction: periodo,
                                        numeroGde: extracted.numeroGde
                                    }
                                }
                            });
                            novedadesIds.push(novedad.id);

                            if (uploadedDriveInfo && archivoFinal) {
                                try {
                                    await this.prisma.observadorNovedadArchivo.create({
                                        data: {
                                            novedadId: novedad.id,
                                            rutaArchivo: uploadedDriveInfo.webViewLink,
                                            tipoArchivo: archivoFinal.mimetype,
                                            nombreOriginal: archivoFinal.filename,
                                            driveFileId: uploadedDriveInfo.fileId,
                                        }
                                    });
                                } catch (err: any) {
                                    this.logger.error(`Error guardando referencia de archivo en base de datos: ${err.message}`);
                                }

                                if (isUiOrigen && mareaArchivoId) {
                                    // Actualizar metadata del mareaArchivo ya existente
                                    const ma = await this.prisma.mareaArchivo.findUnique({ where: { id: mareaArchivoId } });
                                    if (ma) {
                                        const meta: any = ma.metadata || {};
                                        meta.novedadId = novedad.id;
                                        await this.prisma.mareaArchivo.update({
                                            where: { id: mareaArchivoId },
                                            data: { metadata: meta }
                                        });
                                    }
                                } else if (!isUiOrigen && ['VIAJE_INICIO', 'VIAJE_FIN'].includes(tipoNovedad.codigo)) {
                                    // Lógica para emails: vincular a la marea correspondiente
                                    const mareaIdEncontrada = await this.buscarMareaCercana(observador.id, start, tipoNovedad.codigo);
                                    if (mareaIdEncontrada) {
                                        await this.prisma.mareaArchivo.create({
                                            data: {
                                                mareaId: mareaIdEncontrada,
                                                tipoArchivo: 'PASAJE',
                                                formato: archivoFinal.filename.split('.').pop()?.toUpperCase() || 'UNKNOWN',
                                                rutaArchivo: uploadedDriveInfo.webViewLink,
                                                descripcion: `Pasaje detectado por correo electrónico (${emailSubject})`,
                                                metadata: {
                                                    driveFileId: uploadedDriveInfo.fileId,
                                                    originalName: archivoFinal.filename,
                                                    mimetype: archivoFinal.mimetype,
                                                    novedadId: novedad.id
                                                }
                                            }
                                        });
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                estadoDetalle = 'ERROR';
                if (extracted?._metadata?.motivoDescarte === 'VIAJE_SIN_MDQ') {
                    errorDetalle = 'VIAJE_SIN_MDQ';
                } else {
                    errorDetalle = 'SIN_PERIODOS_EXTRAIDOS';
                }
            }
        } catch (error: any) {
            this.logger.error(`Error analizando elemento (${fuente}): ${error.message}`);
            
            const msg = (error.message || '').toLowerCase();
            const isTemporary = error.status === 429 || error.status === 503 || error.status === 504 ||
                                msg.includes('429') || msg.includes('quota') || msg.includes('exhausted') || 
                                msg.includes('timeout') || msg.includes('socket') || msg.includes('reintentos');

            if (isTemporary) {
                // Si es un error temporal (Rate limit de Gemini), lanzamos error para que JobQueueService haga backoff.
                throw error;
            }

            estadoDetalle = 'ERROR';
            errorDetalle = error.message;
        } finally {
            // Eliminar archivo temporal si existía
            if (attachmentData && attachmentData.filePath) {
                try {
                    await fs.unlink(attachmentData.filePath);
                } catch (err) {
                    this.logger.warn(`No se pudo eliminar archivo temporal ${attachmentData.filePath}`);
                }
            }
        }
        if (!isUiOrigen && emailLogId) {
            // Crear el registro de Detalle
            await this.prisma.novedadesEmailLogDetalle.create({
                data: {
                    emailLogId,
                    fuente,
                    extraccionAi: extracted,
                    numeroGde: extracted?.numeroGde,
                    estado: estadoDetalle,
                    errorDetalle,
                    novedadId: novedadesIds.length > 0 ? novedadesIds[0] : null
                }
            });

            // Actualizar el estado global del EmailLog
            await this.actualizarEstadoEmailLog(emailLogId);
        }

        return { procesado: true, novedades: novedadesIds.length, estado: estadoDetalle };
    }

    private async actualizarEstadoEmailLog(emailLogId: string) {
        const detalles = await this.prisma.novedadesEmailLogDetalle.findMany({
            where: { emailLogId }
        });

        // Verificamos si aún quedan jobs encolados para este log (pendientes o procesando)
        const pendingJobs = await this.prisma.jobQueue.count({
            where: {
                type: 'NOVEDADES_AI_PROCESS',
                payload: { path: ['emailLogId'], equals: emailLogId },
                status: { in: ['PENDING', 'PROCESSING'] }
            }
        });

        // Si todavía hay tareas pendientes, no finalizamos el estado aún.
        if (pendingJobs > 0) {
            return;
        }

        const tieneErrores = detalles.some(d => d.estado === 'ERROR');
        const tieneErroresTemporales = detalles.some(d => d.estado === 'ERROR_TEMPORAL');
        const tieneRevisiones = detalles.some(d => d.estado === 'REQUIERE_REVISION');
        
        const nuevoEstado = tieneErroresTemporales ? 'ERROR_TEMPORAL' 
                          : (tieneErrores ? 'CON_ERRORES' 
                          : (tieneRevisiones ? 'CON_ADVERTENCIAS' : 'PROCESADO'));

        await this.prisma.novedadesEmailLog.update({
            where: { id: emailLogId },
            data: { estado: nuevoEstado }
        });
    }

    private async buscarObservador(nombreStr?: string, cuil?: string, dni?: string) {
        if (cuil) {
            const obs = await this.prisma.observador.findFirst({ where: { cuil } });
            if (obs) return { observador: obs, certeza: 'ALTA' };
        }
        if (dni) {
            const obs = await this.prisma.observador.findFirst({ where: { dni } });
            if (obs) return { observador: obs, certeza: 'ALTA' };
        }

        if (!nombreStr) return null;

        const normalize = (s: string) => s.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
        const cleanName = normalize(nombreStr);
        const parts = cleanName.split(/[\s,]+/).filter(p => p.length > 2);

        if (parts.length === 0) return null;

        const observadores = await this.prisma.observador.findMany();
        
        let mejoresCandidatos: any[] = [];
        let maxPuntos = 0;

        for (const obs of observadores) {
            const obsFullName = normalize(`${obs.nombre} ${obs.apellido}`);
            let puntos = 0;
            for (const part of parts) {
                if (obsFullName.includes(part)) {
                    puntos++;
                }
            }
            if (puntos > 0) {
                if (puntos > maxPuntos) {
                    maxPuntos = puntos;
                    mejoresCandidatos = [obs];
                } else if (puntos === maxPuntos) {
                    mejoresCandidatos.push(obs);
                }
            }
        }

        if (mejoresCandidatos.length === 1 && maxPuntos >= 2) {
            return { observador: mejoresCandidatos[0], certeza: 'MEDIA' }; 
        } else if (mejoresCandidatos.length > 0) {
            return { observador: mejoresCandidatos[0], certeza: 'BAJA' }; 
        }

        return null;
    }

    private async buscarMareaCercana(observadorId: string, fechaNovedad: Date, codigoNovedad: string): Promise<string | null> {
        const umbralDias = 5;
        const fechaNov = fechaNovedad.getTime();
        
        const mareas = await this.prisma.marea.findMany({
            where: {
                observadorPrincipalId: observadorId,
                activo: true,
            },
            include: { etapas: { orderBy: { nroEtapa: 'asc' } } }
        });

        for (const marea of mareas) {
            if (codigoNovedad === 'VIAJE_INICIO') {
                const fechaReferencia = marea.etapas.length > 0 && marea.etapas[0].fechaZarpada
                    ? marea.etapas[0].fechaZarpada.getTime()
                    : marea.fechaZarpadaEstimada?.getTime();
                
                if (fechaReferencia && Math.abs(fechaReferencia - fechaNov) / 86400000 <= umbralDias) {
                    return marea.id;
                }
            } else if (codigoNovedad === 'VIAJE_FIN') {
                const ultimaEtapa = marea.etapas.length > 0 ? marea.etapas[marea.etapas.length - 1] : null;
                if (ultimaEtapa?.fechaArribo) {
                    if (Math.abs(ultimaEtapa.fechaArribo.getTime() - fechaNov) / 86400000 <= umbralDias) {
                        return marea.id;
                    }
                }
            }
        }
        return null;
    }
}
