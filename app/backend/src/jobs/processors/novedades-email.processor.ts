import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { ImapService } from '../../mail/imap.service';
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

                // 2. Procesar el Cuerpo del Email (Encolar)
                const bodyFuente = 'CUERPO';
                if (email.text && email.text.trim().length > 10 && !yaEncolado(bodyFuente)) {
                    await this.jobQueueService.addJob(
                        JobType.NOVEDADES_AI_PROCESS,
                        {
                            emailLogId: emailLog.id,
                            fuente: bodyFuente,
                            texto: email.text,
                            emailSubject: email.subject,
                            emailData: { from: email.from, date: email.date }
                        },
                        10
                    );
                }

                // 3. Procesar cada Adjunto por separado (Guardar temp y Encolar)
                if (email.attachments && email.attachments.length > 0) {
                    for (let i = 0; i < email.attachments.length; i++) {
                        const att = email.attachments[i];
                        const filename = att.filename || `adjunto_${i}.pdf`;
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
