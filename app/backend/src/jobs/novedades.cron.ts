import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../prisma/prisma.service';
import { ImapService } from '../mail/imap.service';
import { NovedadesAiService } from '../mail/novedades-ai.service';
import { DriveStorageService } from '../files/drive-storage.service';

@Injectable()
export class NovedadesCronService {
    private readonly logger = new Logger(NovedadesCronService.name);
    private isProcessing = false;

    constructor(
        private readonly prisma: PrismaService,
        private readonly imapService: ImapService,
        private readonly novedadesAiService: NovedadesAiService,
        private readonly driveStorageService: DriveStorageService,
    ) {}

    @Cron(CronExpression.EVERY_HOUR)
    async processNovedadesEmails() {
        if (this.isProcessing) return;
        this.isProcessing = true;

        try {
            await this.imapService.connect();
            const emails = await this.imapService.fetchUnreadEmails();
            
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
                         this.logger.warn(`No se pudo encontrar el observador para el email: ${email.subject}`);
                         continue;
                    }

                    const novedad = await this.prisma.observadorNovedad.create({
                        data: {
                            observadorId: observador.id,
                            estadoDisponibilidad: extracted.estadoDisponibilidad || 'PENDIENTE',
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
                } catch (error) {
                    this.logger.error(`Error procesando email ${email.uid}: ${error.message}`);
                }
            }

        } catch (error) {
            this.logger.error('Error in processNovedadesEmails cron:', error);
        } finally {
            await this.imapService.disconnect();
            this.isProcessing = false;
        }
    }
}
