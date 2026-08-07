import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ImapService } from '../../mail/imap.service';
import { NovedadesAiService } from '../../mail/novedades-ai.service';
import { JobQueueService } from '../job-queue.service';
import { JobProcessor, JobType, JobStatus } from '../job-types';
import * as path from 'path';
import * as fs from 'fs/promises';
import * as os from 'os';

@Injectable()
export class NovedadesEmailProcessor implements JobProcessor {
    private readonly logger = new Logger(NovedadesEmailProcessor.name);
    private readonly tempDir = path.join(os.tmpdir(), 'novedades-ai-attachments');

    constructor(
        private readonly prisma: PrismaService,
        private readonly imapService: ImapService,
        private readonly jobQueueService: JobQueueService,
        private readonly novedadesAiService: NovedadesAiService
    ) {
        // Asegurar que el directorio temporal exista
        fs.mkdir(this.tempDir, { recursive: true }).catch(err => {
            this.logger.error(`Error creando directorio temporal: ${err.message}`);
        });
    }

    async process(payload: any): Promise<any> {
        let processedCount = 0;
        let errorsCount = 0;
        let emailsTotal = 0;

        try {
            await this.imapService.connect();
            const emails = await this.imapService.fetchUnprocessedEmails();
            emailsTotal = emails.length;
            
            for (const email of emails) {
                // 1. Verificar si ya existe un log (parcialmente procesado)
                let emailLog = await this.prisma.novedadesEmailLog.findFirst({
                    where: { messageId: email.messageId },
                    include: { detalles: true }
                });

                if (emailLog && emailLog.estado !== 'ERROR_TEMPORAL' && emailLog.estado !== 'PROCESANDO') {
                    // Si ya está completamente procesado, en cola o tiene error permanente, lo marcamos leído y saltamos
                    await this.imapService.markAsProcessed(email.uid);
                    continue;
                }

                if (!emailLog) {
                    emailLog = await this.prisma.novedadesEmailLog.create({
                        data: {
                            messageId: email.messageId,
                            asunto: email.subject,
                            remitente: email.from,
                            fechaRecepcion: email.date ? new Date(email.date) : null,
                            estado: 'PROCESANDO'
                        },
                        include: { detalles: true }
                    });
                } else {
                    await this.prisma.novedadesEmailLog.update({
                        where: { id: emailLog.id },
                        data: { estado: 'PROCESANDO' }
                    });
                }

                let enqueueSuccess = true;
                const detallesPrevios = emailLog.detalles || [];
                const yaEncolado = (fuente: string) => detallesPrevios.some(d => d.fuente === fuente);

                // Asegurar nombres únicos para adjuntos sin nombre
                const attachmentsData = (email.attachments || []).map((att, i) => {
                    let fname = att.filename;
                    if (!fname) {
                        const ext = (att.contentType || '').split('/')[1] || 'pdf';
                        fname = `adjunto_${i}.${ext}`;
                    }
                    return { ...att, resolvedFilename: fname };
                });

                // --- FASE 1: Triage ---
                let triageResult: any = emailLog.clasificacionTriage;
                if (!triageResult) {
                    const attachmentsParaTriage = attachmentsData.map(a => ({
                        buffer: a.content,
                        mimetype: a.contentType || 'application/pdf',
                        filename: a.resolvedFilename
                    }));
                    triageResult = await this.novedadesAiService.clasificarEmail(email.subject, email.text, attachmentsParaTriage);
                    
                    await this.prisma.novedadesEmailLog.update({
                        where: { id: emailLog.id },
                        data: { clasificacionTriage: triageResult }
                    });
                }

                const candidatos = triageResult.candidatos || [];
                const candidatosRelevantes = candidatos.filter((c: any) => c.tipoDocumento !== 'IRRELEVANTE');

                if (candidatosRelevantes.length === 0) {
                    // No hay información relevante, marcar como ignorado
                    await this.prisma.novedadesEmailLog.update({
                        where: { id: emailLog.id },
                        data: { estado: 'IGNORADO' }
                    });
                    await this.imapService.markAsProcessed(email.uid);
                    processedCount++;
                    continue; // Siguiente email
                }

                // --- FASE 2: Encolar Extracciones Específicas ---
                
                // 2. Procesar el Cuerpo del Email si el Triage lo indicó
                const cuerpoCandidato = candidatosRelevantes.find((c: any) => c.fuente === 'CUERPO_EMAIL');
                if (cuerpoCandidato && email.text && !yaEncolado('CUERPO')) {
                    await this.jobQueueService.addJob(
                        JobType.NOVEDADES_AI_PROCESS,
                        {
                            emailLogId: emailLog.id,
                            fuente: 'CUERPO',
                            texto: email.text,
                            emailSubject: email.subject,
                            emailData: { from: email.from, date: email.date },
                            explicitDocType: cuerpoCandidato.tipoDocumento
                        },
                        10
                    );
                }

                // 3. Procesar cada Adjunto marcado como relevante
                if (attachmentsData.length > 0) {
                    for (let i = 0; i < attachmentsData.length; i++) {
                        const att = attachmentsData[i];
                        const filename = att.resolvedFilename;
                        
                        const adjuntoCandidato = candidatosRelevantes.find((c: any) => c.fuente === 'ADJUNTO' && c.nombreArchivo === filename);
                        if (adjuntoCandidato) {
                            const attFuente = `ADJUNTO: ${filename}`;
                            if (!yaEncolado(attFuente)) {
                                try {
                                    const filePath = path.join(this.tempDir, `${emailLog.id}_${i}_${filename}`);
                                    await fs.writeFile(filePath, att.content);

                                    await this.jobQueueService.addJob(
                                        JobType.NOVEDADES_AI_PROCESS,
                                        {
                                            emailLogId: emailLog.id,
                                            fuente: attFuente,
                                            emailSubject: email.subject,
                                            explicitDocType: adjuntoCandidato.tipoDocumento,
                                            attachmentData: {
                                                filePath,
                                                mimetype: att.contentType || 'application/pdf',
                                                filename: filename
                                            }
                                        },
                                        10
                                    );
                                } catch (err: any) {
                                    this.logger.error(`Error guardando adjunto o encolando IA para ${attFuente}: ${err.message}`);
                                    enqueueSuccess = false;
                                }
                            }
                        }
                    }
                }

                // 4. Actualizar estado del Log Maestro a PROCESANDO (hasta que el AI processor finalice)
                // O si hubo error en encolar, lo dejamos en ERROR_TEMPORAL
                const nuevoEstado = enqueueSuccess ? 'PROCESANDO' : 'ERROR_TEMPORAL';

                await this.prisma.novedadesEmailLog.update({
                    where: { id: emailLog.id },
                    data: { estado: nuevoEstado }
                });

                // 5. Marcar como leído en IMAP SOLO si no hay errores al encolar
                if (enqueueSuccess) {
                    await this.imapService.markAsProcessed(email.uid);
                    processedCount++;
                } else {
                    this.logger.warn(`El email ${email.subject} tuvo errores al encolar. Se deja como no leído.`);
                    errorsCount++;
                }
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
}
