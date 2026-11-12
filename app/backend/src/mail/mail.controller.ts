import { Controller, Post, Get, Body, Query, Param, NotFoundException, BadRequestException, Logger } from '@nestjs/common';
import { Auth } from '../auth/decorators/auth.decorator';
import { ValidRoles } from '../auth/interfaces/valid-roles';
import { SchedulerService } from '../jobs/scheduler.service';
import { JobQueueService } from '../jobs/job-queue.service';
import { PrismaService } from '../prisma/prisma.service';
import { ImapService } from './imap.service';
import { NovedadesAiService } from './novedades-ai.service';
import { JobType } from '@prisma/client';
import * as path from 'path';
import * as fs from 'fs/promises';
import * as os from 'os';

@Controller('mail-admin')
export class MailController {
    private readonly logger = new Logger(MailController.name);

    constructor(
        private readonly schedulerService: SchedulerService,
        private readonly jobQueueService: JobQueueService,
        private readonly prisma: PrismaService,
        private readonly imapService: ImapService,
        private readonly novedadesAiService: NovedadesAiService,
    ) { }

    @Get('logs')
    @Auth(ValidRoles.admin)
    async getLogs(
        @Query('page') page: string = '1', 
        @Query('limit') limit: string = '50',
        @Query('search') search?: string,
        @Query('startDate') startDate?: string,
        @Query('endDate') endDate?: string,
        @Query('sortBy') sortBy: string = 'fechaRecepcion',
        @Query('sortOrder') sortOrder: 'asc' | 'desc' = 'desc'
    ) {
        const pageNum = parseInt(page, 10) || 1;
        const limitNum = parseInt(limit, 10) || 50;
        const skip = (pageNum - 1) * limitNum;

        const where: any = {};

        if (search) {
            where.OR = [
                { asunto: { contains: search, mode: 'insensitive' } },
                { remitente: { contains: search, mode: 'insensitive' } },
                { estado: { contains: search, mode: 'insensitive' } },
                { 
                    detalles: {
                        some: {
                            OR: [
                                { estado: { contains: search, mode: 'insensitive' } },
                                { errorDetalle: { contains: search, mode: 'insensitive' } },
                                { fuente: { contains: search, mode: 'insensitive' } }
                            ]
                        }
                    }
                }
            ];
        }

        if (startDate || endDate) {
            where.fechaRecepcion = {};
            if (startDate) {
                // Asegurar que comience a las 00:00:00
                const start = new Date(startDate);
                start.setHours(0, 0, 0, 0);
                where.fechaRecepcion.gte = start;
            }
            if (endDate) {
                // Asegurar que termine a las 23:59:59
                const end = new Date(endDate);
                end.setHours(23, 59, 59, 999);
                where.fechaRecepcion.lte = end;
            }
        }

        // Reconciliar logs que hayan quedado en PROCESANDO cuyos jobs ya finalizaron
        const logsProcesando = await this.prisma.novedadesEmailLog.findMany({
            where: { estado: 'PROCESANDO' },
            include: { detalles: true }
        });

        for (const log of logsProcesando) {
            const pendingJobs = await this.prisma.jobQueue.count({
                where: {
                    type: 'NOVEDADES_AI_PROCESS',
                    payload: { path: ['emailLogId'], equals: log.id },
                    status: { in: ['PENDING', 'PROCESSING'] }
                }
            });

            if (pendingJobs === 0) {
                if (log.detalles && log.detalles.length > 0) {
                    const tieneErrores = log.detalles.some(d => d.estado === 'ERROR');
                    const tieneErroresTemporales = log.detalles.some(d => d.estado === 'ERROR_TEMPORAL');
                    const tieneRevisiones = log.detalles.some(d => d.estado === 'REQUIERE_REVISION');
                    const estadoSaneado = tieneErroresTemporales ? 'ERROR_TEMPORAL'
                                        : (tieneErrores ? 'CON_ERRORES'
                                        : (tieneRevisiones ? 'CON_ADVERTENCIAS' : 'PROCESADO'));

                    await this.prisma.novedadesEmailLog.update({
                        where: { id: log.id },
                        data: { estado: estadoSaneado }
                    });
                } else {
                    // Si no hay tareas pendientes y no tiene detalles generados, verificar si el triage fue irrelevante o si falló
                    const triage = log.clasificacionTriage as any;
                    const candidatosRelevantes = (triage?.candidatos || []).filter((c: any) => c.tipoDocumento !== 'IRRELEVANTE');
                    const nuevoEstado = (triage && candidatosRelevantes.length === 0) ? 'IGNORADO' : 'ERROR';

                    await this.prisma.novedadesEmailLog.update({
                        where: { id: log.id },
                        data: { estado: nuevoEstado }
                    });
                }
            }
        }

        const orderBy: any = {};
        const validSortFields = ['fechaRecepcion', 'remitente', 'asunto', 'estado'];
        const finalSortBy = validSortFields.includes(sortBy) ? sortBy : 'fechaRecepcion';
        const finalSortOrder = sortOrder === 'asc' ? 'asc' : 'desc';
        orderBy[finalSortBy] = finalSortOrder;

        const [items, total] = await Promise.all([
            this.prisma.novedadesEmailLog.findMany({
                where,
                skip,
                take: limitNum,
                orderBy,
                include: {
                    detalles: {
                        include: {
                            novedad: {
                                include: {
                                    observador: true,
                                    tipoNovedad: true,
                                    archivos: true // Incluir archivos para visualizarlos
                                }
                            }
                        }
                    }
                }
            }),
            this.prisma.novedadesEmailLog.count({ where }),
        ]);

        return { items, total, page: pageNum, limit: limitNum };
    }


    @Get('config')
    @Auth(ValidRoles.admin)
    async getConfig() {
        return this.schedulerService.getNovedadesSyncConfig();
    }

    @Post('config')
    @Auth(ValidRoles.admin)
    async updateConfig(@Body() config: any) {
        return this.schedulerService.updateNovedadesSyncConfig(config);
    }

    @Post('sync-manual')
    @Auth(ValidRoles.admin)
    async triggerManualSync() {
        return this.jobQueueService.triggerJobByType(JobType.NOVEDADES_EMAIL_SYNC);
    }

    @Post('logs/:id/reprocess')
    @Auth(ValidRoles.admin)
    async reprocessLog(@Param('id') id: string) {
        const emailLog = await this.prisma.novedadesEmailLog.findUnique({
            where: { id },
            include: { detalles: true }
        });

        if (!emailLog) {
            throw new NotFoundException('Registro de auditoría de correo no encontrado');
        }

        const pendingJobs = await this.prisma.jobQueue.count({
            where: {
                type: 'NOVEDADES_AI_PROCESS',
                payload: { path: ['emailLogId'], equals: emailLog.id },
                status: { in: ['PENDING', 'PROCESSING'] }
            }
        });

        if (pendingJobs > 0) {
            throw new BadRequestException('El correo se encuentra actualmente siendo procesado en la cola de tareas.');
        }

        // 1. Limpiar detalles de análisis previos y resetear estado a PROCESANDO
        await this.prisma.novedadesEmailLogDetalle.deleteMany({
            where: { emailLogId: emailLog.id }
        });

        await this.prisma.novedadesEmailLog.update({
            where: { id: emailLog.id },
            data: {
                estado: 'PROCESANDO',
                clasificacionTriage: null,
            }
        });

        // 2. Disparar el proceso en background para no demorar la respuesta HTTP (evita timeouts de frontend)
        this.ejecutarReprocesamientoBackground(emailLog.id, emailLog.messageId).catch(err => {
            this.logger.error(`Error en background al reprocesar email ${emailLog.id}: ${err.message}`);
        });

        return { success: true, message: 'Reprocesamiento iniciado exitosamente' };
    }

    private async ejecutarReprocesamientoBackground(emailLogId: string, messageId?: string | null) {
        if (!messageId) {
            await this.prisma.novedadesEmailLog.update({
                where: { id: emailLogId },
                data: { estado: 'ERROR' }
            });
            return;
        }

        try {
            await this.imapService.connect();
            try {
                const email = await this.imapService.fetchEmailByMessageId(messageId);
                if (!email) {
                    await this.prisma.novedadesEmailLog.update({
                        where: { id: emailLogId },
                        data: { estado: 'ERROR' }
                    });
                    return;
                }

                await this.prisma.novedadesEmailLog.update({
                    where: { id: emailLogId },
                    data: {
                        asunto: email.subject,
                        remitente: email.from,
                        fechaRecepcion: email.date ? new Date(email.date) : undefined
                    }
                });

                // Directorio temporal para adjuntos
                const tempDir = path.join(os.tmpdir(), 'novedades-ai-attachments');
                await fs.mkdir(tempDir, { recursive: true });

                const attachmentsData = (email.attachments || []).map((att: any, i: number) => {
                    let fname = att.filename;
                    if (!fname) {
                        const ext = (att.contentType || '').split('/')[1] || 'pdf';
                        fname = `adjunto_${i}.${ext}`;
                    }
                    return { ...att, resolvedFilename: fname };
                });

                // Triage con IA
                const attachmentsParaTriage = attachmentsData.map((a: any) => ({
                    buffer: a.content,
                    mimetype: a.contentType || 'application/pdf',
                    filename: a.resolvedFilename
                }));

                const triageResult = await this.novedadesAiService.clasificarEmail(email.subject, email.text, attachmentsParaTriage);
                await this.prisma.novedadesEmailLog.update({
                    where: { id: emailLogId },
                    data: { clasificacionTriage: triageResult }
                });

                const candidatos = triageResult?.candidatos || [];
                const candidatosRelevantes = candidatos.filter((c: any) => c.tipoDocumento !== 'IRRELEVANTE');

                if (candidatosRelevantes.length === 0) {
                    await this.prisma.novedadesEmailLog.update({
                        where: { id: emailLogId },
                        data: { estado: 'IGNORADO' }
                    });
                    return;
                }

                // Encolar análisis de cuerpo si aplica
                const cuerpoCandidato = candidatosRelevantes.find((c: any) => c.fuente === 'CUERPO_EMAIL');
                if (cuerpoCandidato && email.text) {
                    await this.jobQueueService.addJob(
                        JobType.NOVEDADES_AI_PROCESS,
                        {
                            emailLogId: emailLogId,
                            fuente: 'CUERPO',
                            texto: email.text,
                            emailSubject: email.subject,
                            emailData: { from: email.from, to: email.to, date: email.date },
                            explicitDocType: cuerpoCandidato.tipoDocumento
                        },
                        10
                    );
                }

                // Encolar análisis de adjuntos relevantes
                for (let i = 0; i < attachmentsData.length; i++) {
                    const att = attachmentsData[i];
                    const filename = att.resolvedFilename;
                    const adjuntoCandidato = candidatosRelevantes.find((c: any) => c.fuente === 'ADJUNTO' && c.nombreArchivo === filename);

                    if (adjuntoCandidato) {
                        const attFuente = `ADJUNTO: ${filename}`;
                        const filePath = path.join(tempDir, `${emailLogId}_${i}_${filename}`);
                        await fs.writeFile(filePath, att.content);

                        await this.jobQueueService.addJob(
                            JobType.NOVEDADES_AI_PROCESS,
                            {
                                emailLogId: emailLogId,
                                fuente: attFuente,
                                emailSubject: email.subject,
                                emailData: { from: email.from, to: email.to, date: email.date },
                                explicitDocType: adjuntoCandidato.tipoDocumento,
                                attachmentData: {
                                    filePath,
                                    mimetype: att.contentType || 'application/pdf',
                                    filename
                                }
                            },
                            10
                        );
                    }
                }
            } finally {
                await this.imapService.disconnect();
            }
        } catch (error: any) {
            this.logger.error(`Error en background al reprocesar email ${emailLogId}: ${error.message}`);
            await this.prisma.novedadesEmailLog.update({
                where: { id: emailLogId },
                data: { estado: 'ERROR' }
            });
        }
    }
}
