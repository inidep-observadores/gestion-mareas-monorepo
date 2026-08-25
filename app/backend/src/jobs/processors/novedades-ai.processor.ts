import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { NovedadesAiService } from '../../mail/novedades-ai.service';
import { DriveStorageService } from '../../files/drive-storage.service';
import { GotenbergService } from '../../files/gotenberg.service';
import { JobProcessor } from '../job-types';
import { DateUtils } from '../../common/utils/date.utils';
import { ErrorLogsService } from '../../common/error-logs/error-logs.service';
import * as fs from 'fs/promises';

@Injectable()
export class NovedadesAiProcessor implements JobProcessor {
    private readonly logger = new Logger(NovedadesAiProcessor.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly novedadesAiService: NovedadesAiService,
        private readonly driveStorageService: DriveStorageService,
        private readonly gotenbergService: GotenbergService,
        private readonly errorLogsService: ErrorLogsService,
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
                    extracted.dni,
                    emailData?.from
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
                            const escapeHtml = (unsafe: string) => {
                                return (unsafe || '')
                                    .replace(/&/g, '&amp;')
                                    .replace(/</g, '&lt;')
                                    .replace(/>/g, '&gt;')
                                    .replace(/"/g, '&quot;')
                                    .replace(/'/g, '&#039;');
                            };

                            const sanitize = (val: string) =>
                                (val || '')
                                    .normalize('NFD')
                                    .replace(/[\u0300-\u036f]/g, '')
                                    .replace(/[^a-zA-Z0-9]/g, '_')
                                    .replace(/_+/g, '_')
                                    .replace(/^_|_$/g, '');

                            const timestampStr = DateUtils.formatForFilename(emailData?.date);
                            const ape = sanitize(observador?.apellido);
                            const nom = sanitize(observador?.nombre);
                            const obsFilePrefix = [ape, nom].filter(Boolean).join('_');
                            const filename = obsFilePrefix ? `Email_${obsFilePrefix}_${timestampStr}.pdf` : `Email_${timestampStr}.pdf`;

                            const fromText = emailData?.from || 'No especificado';
                            const toText = emailData?.to || '';
                            const fechaHoraText = DateUtils.formatDateTime(emailData?.date || DateUtils.getNow(true));
                            const obsDocText = observador
                                ? `${observador.apellido || ''}, ${observador.nombre || ''} (DNI: ${observador.dni || 'S/D'}${observador.cuil ? ' / CUIL: ' + observador.cuil : ''})`
                                : '';

                            const toRow = toText
                                ? `<tr><td class="meta-label">Para (Destinatario):</td><td class="meta-value">${escapeHtml(toText)}</td></tr>`
                                : '';

                            const obsRow = obsDocText
                                ? `<tr><td class="meta-label">Observador asociado:</td><td class="meta-value"><strong>${escapeHtml(obsDocText)}</strong></td></tr>`
                                : '';

                            const htmlContent = `
                                <!DOCTYPE html>
                                <html lang="es">
                                <head>
                                    <meta charset="UTF-8">
                                    <style>
                                        body {
                                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                                            color: #1e293b;
                                            margin: 0;
                                            padding: 32px;
                                            font-size: 13px;
                                        }
                                        .header-title {
                                            font-size: 17px;
                                            font-weight: 700;
                                            color: #0f172a;
                                            margin: 0 0 16px 0;
                                            padding-bottom: 8px;
                                            border-bottom: 2px solid #0284c7;
                                            display: flex;
                                            justify-content: space-between;
                                            align-items: center;
                                        }
                                        .header-tag {
                                            font-size: 10px;
                                            font-weight: 600;
                                            color: #0284c7;
                                            background: #e0f2fe;
                                            padding: 3px 8px;
                                            border-radius: 4px;
                                            text-transform: uppercase;
                                            letter-spacing: 0.5px;
                                        }
                                        .meta-table {
                                            width: 100%;
                                            border-collapse: collapse;
                                            margin-bottom: 20px;
                                            background-color: #f8fafc;
                                            border: 1px solid #e2e8f0;
                                            border-radius: 6px;
                                            overflow: hidden;
                                        }
                                        .meta-table td {
                                            padding: 8px 12px;
                                            border-bottom: 1px solid #e2e8f0;
                                            vertical-align: top;
                                            font-size: 12px;
                                        }
                                        .meta-table tr:last-child td {
                                            border-bottom: none;
                                        }
                                        .meta-label {
                                            font-weight: 600;
                                            color: #475569;
                                            width: 160px;
                                            background-color: #f1f5f9;
                                        }
                                        .meta-value {
                                            color: #0f172a;
                                        }
                                        .body-container {
                                            border: 1px solid #cbd5e1;
                                            border-radius: 6px;
                                            padding: 16px;
                                            background-color: #ffffff;
                                        }
                                        .body-title {
                                            font-size: 11px;
                                            font-weight: 600;
                                            color: #64748b;
                                            text-transform: uppercase;
                                            letter-spacing: 0.5px;
                                            margin-bottom: 10px;
                                            border-bottom: 1px dashed #e2e8f0;
                                            padding-bottom: 4px;
                                        }
                                        .body-content {
                                            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, monospace, sans-serif;
                                            white-space: pre-wrap;
                                            word-wrap: break-word;
                                            margin: 0;
                                            line-height: 1.6;
                                            color: #1e293b;
                                            font-size: 12px;
                                        }
                                        .footer {
                                            margin-top: 24px;
                                            padding-top: 12px;
                                            border-top: 1px solid #e2e8f0;
                                            font-size: 10px;
                                            color: #94a3b8;
                                            display: flex;
                                            justify-content: space-between;
                                        }
                                    </style>
                                </head>
                                <body>
                                    <div class="header-title">
                                        <span>SIGMA - Registro de Comunicación por Correo Electrónico</span>
                                        <span class="header-tag">Documento de Respaldo</span>
                                    </div>
                                    <table class="meta-table">
                                        <tr>
                                            <td class="meta-label">De (Remitente):</td>
                                            <td class="meta-value">${escapeHtml(fromText)}</td>
                                        </tr>
                                        ${toRow}
                                        <tr>
                                            <td class="meta-label">Fecha y hora:</td>
                                            <td class="meta-value">${escapeHtml(fechaHoraText)}</td>
                                        </tr>
                                        <tr>
                                            <td class="meta-label">Asunto:</td>
                                            <td class="meta-value"><strong>${escapeHtml(emailSubject || '(Sin asunto)')}</strong></td>
                                        </tr>
                                        ${obsRow}
                                    </table>

                                    <div class="body-container">
                                        <div class="body-title">Contenido del Correo</div>
                                        <pre class="body-content">${escapeHtml(texto)}</pre>
                                    </div>

                                    <div class="footer">
                                        <span>Sistema Integral de Gestión de Mareas (SIGMA) - INIDEP</span>
                                        <span>Log ID: ${escapeHtml(emailLogId || 'N/A')}</span>
                                    </div>
                                </body>
                                </html>
                            `;
                            const pdfBuffer = await this.gotenbergService.convertHtmlToPdf(htmlContent);
                            archivoFinal = {
                                buffer: pdfBuffer,
                                mimetype: 'application/pdf',
                                filename: filename
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

                            const tiposPuntuales = ['VIAJE_INICIO', 'VIAJE_FIN', 'FC', 'RP', 'DONACION_SANGRE', 'EXAMEN', 'NACIMIENTO', 'FALLECIMIENTO'];
                            if (tiposPuntuales.includes(tipoNovedad.codigo)) {
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
                                    activo: true,
                                    AND: overlapConditions
                                }
                            });

                            let esCorreccion = false;
                            let novedadOriginalId: string | null = null;
                            let reemplazaNovedadId: string | null = null;
                            let esAjustePeriodo = false;
                            let tipoAjuste: string | null = null;
                            let novedadAjustarId: string | null = null;
                            let fechaCortePropuesta: Date | null = null;
                            let novedadOpuestaEncontrada: any = null;

                            if (overlaps) {
                                if (overlaps.estadoAprobacion === 'PENDIENTE') {
                                    await this.prisma.observadorNovedad.update({
                                        where: { id: overlaps.id },
                                        data: {
                                            activo: false,
                                            estadoAprobacion: 'RECHAZADA',
                                            movimientos: {
                                                create: {
                                                    tipoEvento: 'REEMPLAZADA_POR_EMAIL',
                                                    estadoAnterior: overlaps.estadoAprobacion,
                                                    estadoNuevo: 'RECHAZADA',
                                                    comentarios: 'Anulada automáticamente por recepción de un nuevo correo con fechas rectificadas.',
                                                }
                                            }
                                        }
                                    });
                                    reemplazaNovedadId = overlaps.id;
                                } else if (overlaps.estadoAprobacion === 'APROBADA') {
                                    esCorreccion = true;
                                    novedadOriginalId = overlaps.id;
                                    estadoDetalle = 'REQUIERE_REVISION';
                                } else {
                                    throw new Error('El observador ya tiene una novedad de este tipo registrada en estas fechas');
                                }
                            } else {
                                const isIncomingDisponible = ['DISPONIBLE', 'DISPONIBILIDAD'].includes(tipoNovedad.codigo);
                                const isIncomingNoDisponible = ['NO_DISPONIBLE'].includes(tipoNovedad.codigo);

                                if (isIncomingDisponible || isIncomingNoDisponible) {
                                    const oppositeCodes = isIncomingDisponible
                                        ? ['NO_DISPONIBLE', 'LICEN', 'LICENCIA']
                                        : ['DISPONIBLE', 'DISPONIBILIDAD'];

                                    const oppositeOverlap = await this.prisma.observadorNovedad.findFirst({
                                        where: {
                                            observadorId: observador.id,
                                            tipoNovedad: { codigo: { in: oppositeCodes } },
                                            estadoAprobacion: 'APROBADA',
                                            activo: true,
                                            AND: overlapConditions
                                        },
                                        include: { tipoNovedad: true }
                                    });

                                    if (oppositeOverlap) {
                                        esAjustePeriodo = true;
                                        novedadAjustarId = oppositeOverlap.id;
                                        novedadOpuestaEncontrada = oppositeOverlap;
                                        estadoDetalle = 'REQUIERE_REVISION';

                                        const fechaInicioOpuesta = new Date(oppositeOverlap.fechaInicio);
                                        if (start > fechaInicioOpuesta) {
                                            tipoAjuste = isIncomingDisponible ? 'ADELANTO_DISPONIBILIDAD' : 'INTERRUPCION_DISPONIBILIDAD';
                                            fechaCortePropuesta = new Date(start.getTime() - 24 * 60 * 60 * 1000);
                                        } else {
                                            tipoAjuste = isIncomingDisponible ? 'REEMPLAZO_TOTAL_DISPONIBILIDAD' : 'REEMPLAZO_TOTAL_NO_DISPONIBILIDAD';
                                        }
                                    }
                                }
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
                                        emailLogId: emailLogId || null,
                                        fuente,
                                        certezaAi: obsBusqueda.certeza,
                                        requiereRevision: estadoDetalle === 'REQUIERE_REVISION' || esCorreccion || esAjustePeriodo,
                                        aiExtraction: periodo,
                                        numeroGde: extracted.numeroGde,
                                        ...(esCorreccion ? { esCorreccion: true, novedadOriginalId } : {}),
                                        ...(reemplazaNovedadId ? { reemplazaNovedadId } : {}),
                                        ...(esAjustePeriodo ? {
                                            esAjustePeriodo: true,
                                            tipoAjuste,
                                            novedadAjustarId,
                                            fechaCortePropuesta: fechaCortePropuesta ? DateUtils.formatDate(fechaCortePropuesta) : null
                                        } : {})
                                    },
                                    movimientos: {
                                        create: {
                                            tipoEvento: esCorreccion
                                                ? 'CREACION_CORRECCION'
                                                : (esAjustePeriodo ? 'CREACION_AJUSTE_PERIODO' : 'CREACION_EMAIL'),
                                            estadoNuevo: 'PENDIENTE',
                                            comentarios: esCorreccion
                                                ? `Solicitud de rectificación recibida por correo para el período aprobado del ${DateUtils.formatDate(overlaps?.fechaInicio)} ${overlaps?.fechaFin ? 'al ' + DateUtils.formatDate(overlaps.fechaFin) : 'en adelante'}`
                                                : (esAjustePeriodo && novedadOpuestaEncontrada
                                                    ? (tipoAjuste === 'ADELANTO_DISPONIBILIDAD'
                                                        ? `Adelanto de disponibilidad recibido por correo. Al aprobarse ajustará la fecha de fin de la ${novedadOpuestaEncontrada.tipoNovedad?.descripcion || 'No Disponibilidad'} vigente al ${DateUtils.formatDate(fechaCortePropuesta)}`
                                                        : `Declaración recibida por correo que intersecta con la ${novedadOpuestaEncontrada.tipoNovedad?.descripcion || 'Disponibilidad'} vigente`)
                                                    : 'Novedad ingresada automáticamente por procesamiento de correo')
                                        }
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

            await this.errorLogsService.create({
                level: 'ERROR',
                source: 'AI_PROCESSING',
                context: 'NovedadesAiProcessor.process',
                message: `Error al procesar novedades con IA (${fuente}): ${error.message}`,
                stack: error.stack,
                detail: {
                    emailLogId,
                    fuente,
                    emailSubject,
                    explicitDocType,
                    origen: origen || 'EMAIL',
                    mareaId,
                    mareaArchivoId,
                },
            });
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

        // Verificamos si aún quedan otros jobs pendientes en cola para este log
        const pendingJobs = await this.prisma.jobQueue.count({
            where: {
                type: 'NOVEDADES_AI_PROCESS',
                payload: { path: ['emailLogId'], equals: emailLogId },
                status: 'PENDING'
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

    private async buscarObservador(nombreStr?: string, cuil?: string, dni?: string, senderEmail?: string) {
        // 1. CUIL (Certeza ALTA)
        if (cuil) {
            const obs = await this.prisma.observador.findFirst({ where: { cuil } });
            if (obs) return { observador: obs, certeza: 'ALTA' };
        }
        // 2. DNI (Certeza ALTA)
        if (dni) {
            const obs = await this.prisma.observador.findFirst({ where: { dni } });
            if (obs) return { observador: obs, certeza: 'ALTA' };
        }

        // 3 y 4. Búsqueda por Nombre y Apellido
        if (nombreStr) {
            const normalize = (s: string) => s.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
            const cleanName = normalize(nombreStr);
            const parts = cleanName.split(/[\s,]+/).filter(p => p.length > 2);

            if (parts.length > 0) {
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

                // 3. Nombre y Apellido sólido (>= 2 palabras coincidentes y único) -> Certeza MEDIA
                if (mejoresCandidatos.length === 1 && maxPuntos >= 2) {
                    return { observador: mejoresCandidatos[0], certeza: 'MEDIA' }; 
                } 
                // 4. Nombre parcial / dudoso -> Certeza BAJA (Requiere revisión humana)
                else if (mejoresCandidatos.length > 0) {
                    return { observador: mejoresCandidatos[0], certeza: 'BAJA' }; 
                }
            }
        }

        // 5. Email de Remitente (Última instancia absoluta)
        if (senderEmail) {
            const emailMatch = senderEmail.match(/<([^>]+)>/) || [null, senderEmail.trim()];
            const cleanEmail = (emailMatch[1] || senderEmail).trim().toLowerCase();

            if (cleanEmail && cleanEmail.includes('@')) {
                const obs = await this.prisma.observador.findFirst({
                    where: {
                        email: {
                            equals: cleanEmail,
                            mode: 'insensitive'
                        }
                    }
                });

                if (obs) {
                    return { observador: obs, certeza: 'BAJA' }; // Certeza BAJA para requerir revisión humana obligatoria
                }
            }
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
