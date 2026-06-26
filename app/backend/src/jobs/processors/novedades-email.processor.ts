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
        let ignoredCount = 0;

        try {
            await this.imapService.connect();
            const emails = await this.imapService.fetchUnprocessedEmails();
            
            for (const email of emails) {
                try {
                    const extracted = await this.novedadesAiService.procesarNovedad(email.text || email.subject || '');
                    
                    let observador = null;
                    if (extracted.cuil) {
                        // Podríamos buscar por cuil si existiera en la DB
                    }
                    if (!observador && extracted.observador) {
                         const parts = extracted.observador.split(' ');
                         if (parts.length > 0) {
                              observador = await this.prisma.observador.findFirst({
                                  where: {
                                      OR: [
                                          { nombre: { contains: parts[0], mode: 'insensitive' } },
                                          { apellido: { contains: parts[0], mode: 'insensitive' } }
                                      ]
                                  }
                              });
                         }
                    }

                    if (!observador) {
                         this.logger.log(`Email ignorado (no se detectó observador): ${email.subject}`);
                         ignoredCount++;
                         await this.imapService.markAsProcessed(email.uid);
                         continue;
                    }

                    const codigoNovedad = extracted.estadoDisponibilidad || 'LICEN';
                    let tipoNovedad = await this.prisma.tipoNovedad.findUnique({
                        where: { codigo: codigoNovedad }
                    });

                    if (!tipoNovedad) {
                        tipoNovedad = await this.prisma.tipoNovedad.findFirst();
                        if (!tipoNovedad) {
                             this.logger.log(`Email ignorado (sin tipo novedad válido): ${codigoNovedad}`);
                             ignoredCount++;
                             await this.imapService.markAsProcessed(email.uid);
                             continue;
                        }
                    }

                    const novedad = await this.prisma.observadorNovedad.create({
                        data: {
                            observadorId: observador.id,
                            tipoNovedadId: tipoNovedad.id,
                            fechaInicio: extracted.fechaInicio ? new Date(extracted.fechaInicio) : new Date(),
                            fechaFin: extracted.fechaFin ? new Date(extracted.fechaFin) : null,
                            estadoAprobacion: 'PENDIENTE',
                            origen: 'EMAIL',
                            motivo: extracted.motivo || email.subject,
                            metadata: {
                                messageId: email.messageId,
                                rawText: email.text,
                                aiExtraction: extracted
                            }
                        }
                    });

                    for (const att of email.attachments) {
                        try {
                            const { fileId, webViewLink } = await this.driveStorageService.uploadFile(
                                att.filename || 'adjunto.pdf',
                                att.contentType || 'application/pdf',
                                att.content
                            );

                            await this.prisma.observadorNovedadArchivo.create({
                                data: {
                                    novedadId: novedad.id,
                                    rutaArchivo: webViewLink,
                                    tipoArchivo: att.contentType || 'application/pdf',
                                    nombreOriginal: att.filename,
                                    driveFileId: fileId,
                                }
                            });
                        } catch (err) {
                            this.logger.error(`Error subiendo adjunto: ${err.message}`);
                        }
                    }

                    await this.imapService.markAsProcessed(email.uid);
                    processedCount++;
                } catch (error) {
                    this.logger.error(`Error procesando email ${email.uid}: ${error.message}`);
                    errorsCount++;
                }
            }

            return {
                total: emails.length,
                processed: processedCount,
                ignored: ignoredCount,
                errors: errorsCount
            };
        } catch (error) {
            this.logger.error('Error in NovedadesEmailProcessor:', error);
            throw error; // Lanzar para que SchedulerService marque el job como FAILED/retries
        } finally {
            await this.imapService.disconnect();
        }
    }
}
