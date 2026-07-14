import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ImapService } from '../../mail/imap.service';
import { NovedadesAiService } from '../../mail/novedades-ai.service';
import { DriveStorageService } from '../../files/drive-storage.service';
import { JobProcessor } from '../job-types';

@Injectable()
export class NovedadesEmailProcessor implements JobProcessor {
    private readonly logger = new Logger(NovedadesEmailProcessor.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly imapService: ImapService,
        private readonly novedadesAiService: NovedadesAiService,
        private readonly driveStorageService: DriveStorageService,
    ) {}

    async process(payload: any): Promise<any> {
        let processedCount = 0;
        let errorsCount = 0;
        let emailsTotal = 0;

        try {
            await this.imapService.connect();
            const emails = await this.imapService.fetchUnprocessedEmails();
            emailsTotal = emails.length;
            
            for (const email of emails) {
                // 1. Crear el Log Maestro
                const emailLog = await this.prisma.novedadesEmailLog.create({
                    data: {
                        messageId: email.messageId,
                        asunto: email.subject,
                        remitente: email.from,
                        fechaRecepcion: email.date ? new Date(email.date) : null,
                        estado: 'PROCESANDO'
                    }
                });

                let detallesCreados = 0;
                let detallesConError = 0;
                let detallesRequierenRevision = 0;

                // 2. Procesar el Cuerpo del Email
                if (email.text && email.text.trim().length > 10) {
                    await this.analizarYGuardarElemento(
                        email.text, 
                        undefined, 
                        'CUERPO', 
                        emailLog.id, 
                        email
                    );
                }

                // 3. Procesar cada Adjunto por separado
                if (email.attachments && email.attachments.length > 0) {
                    for (let i = 0; i < email.attachments.length; i++) {
                        const att = email.attachments[i];
                        const attachmentData = {
                            buffer: att.content,
                            mimetype: att.contentType || 'application/pdf',
                            filename: att.filename || `adjunto_${i}.pdf`
                        };
                        await this.analizarYGuardarElemento(
                            '', 
                            attachmentData, 
                            `ADJUNTO: ${attachmentData.filename}`, 
                            emailLog.id, 
                            email
                        );
                    }
                }

                // 4. Actualizar estado del Log Maestro
                const detalles = await this.prisma.novedadesEmailLogDetalle.findMany({
                    where: { emailLogId: emailLog.id }
                });

                const tieneErrores = detalles.some(d => d.estado === 'ERROR');
                const tieneRevisiones = detalles.some(d => d.estado === 'REQUIERE_REVISION');
                const nuevoEstado = tieneErrores ? 'CON_ERRORES' : (tieneRevisiones ? 'CON_ADVERTENCIAS' : 'PROCESADO');

                await this.prisma.novedadesEmailLog.update({
                    where: { id: emailLog.id },
                    data: { estado: nuevoEstado }
                });

                // 5. Marcar como leído en IMAP
                await this.imapService.markAsProcessed(email.uid);
                processedCount++;

                // Pequeño delay de 10s para cuota de Gemini
                await new Promise(resolve => setTimeout(resolve, 10000));
            }

            return {
                total: emailsTotal,
                processed: processedCount,
                errors: errorsCount
            };
        } catch (error) {
            this.logger.error('Error in NovedadesEmailProcessor:', error);
            throw error;
        } finally {
            await this.imapService.disconnect();
        }
    }

    private async analizarYGuardarElemento(
        texto: string, 
        attachment: any, 
        fuente: string, 
        emailLogId: string,
        emailData: any
    ) {
        let extracted: any = null;
        let estadoDetalle = 'PROCESADO';
        let errorDetalle = null;
        let novedadesIds: string[] = [];

        try {
            // Extraer JSON estructurado con la IA
            extracted = await this.novedadesAiService.procesarElemento(texto, attachment);
            
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
                            const novedad = await this.prisma.observadorNovedad.create({
                                data: {
                                    observadorId: observador.id,
                                    tipoNovedadId: tipoNovedad.id,
                                    fechaInicio: periodo.fechaInicio ? new Date(periodo.fechaInicio) : new Date(),
                                    fechaFin: periodo.fechaFin ? new Date(periodo.fechaFin) : null,
                                    estadoAprobacion: 'PENDIENTE',
                                    origen: 'EMAIL',
                                    motivo: periodo.motivo || emailData.subject,
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

                            // Subir archivo a Drive si es adjunto, solo a la primera novedad del grupo
                            if (attachment && novedadesIds.length === 1) {
                                try {
                                    const { fileId, webViewLink } = await this.driveStorageService.uploadFile(
                                        attachment.filename,
                                        attachment.mimetype,
                                        attachment.buffer
                                    );

                                    await this.prisma.observadorNovedadArchivo.create({
                                        data: {
                                            novedadId: novedad.id,
                                            rutaArchivo: webViewLink,
                                            tipoArchivo: attachment.mimetype,
                                            nombreOriginal: attachment.filename,
                                            driveFileId: fileId,
                                        }
                                    });
                                } catch (err: any) {
                                    this.logger.error(`Error subiendo adjunto a Drive: ${err.message}`);
                                }
                            }
                        }
                    }
                }
            } else {
                estadoDetalle = 'ERROR';
                errorDetalle = 'SIN_PERIODOS_EXTRAIDOS';
            }
        } catch (error: any) {
            this.logger.error(`Error analizando elemento (${fuente}): ${error.message}`);
            estadoDetalle = 'ERROR';
            errorDetalle = error.message;
        }

        // Crear el registro de Detalle
        // Si hay varias novedades, creamos un registro de detalle por la primera (o una iteración)
        // O más bien, creamos un registro de detalle que puede enlazar a una novedad específica o dejar en nulo.
        // Como tenemos una relación NovedadesEmailLogDetalle -> novedadId, lo haremos para la primera por simplificación del modelo.
        
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
        
        // Agregar un retraso de 15 segundos para evitar golpear el límite de cuota (Rate Limit) de la IA
        // Dado que la velocidad no es crítica, 15s es muy seguro para el modelo.
        await new Promise(resolve => setTimeout(resolve, 15000));
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
}
