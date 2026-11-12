import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../prisma/prisma.service';
import { DriveStorageService } from '../../files/drive-storage.service';
import { JobProcessor, JobType } from '../job-types';
import { JobQueueService } from '../job-queue.service';
import { ConfigService } from '@nestjs/config';
import * as fs from 'fs/promises';

@Injectable()
export class DriveSyncProcessor implements JobProcessor {
    private readonly logger = new Logger(DriveSyncProcessor.name);

    constructor(
        private readonly prisma: PrismaService,
        private readonly driveStorageService: DriveStorageService,
        private readonly jobQueueService: JobQueueService,
        private readonly configService: ConfigService,
    ) {}

    async process(payload: any): Promise<void> {
        const { action } = payload;
        
        if (action === 'UPLOAD') {
            await this.handleUpload(payload);
        } else if (action === 'DELETE') {
            await this.handleDelete(payload);
        } else {
            throw new Error(`Acción desconocida en DRIVE_SYNC: ${action}`);
        }
    }

    private async handleUpload(payload: any) {
        const { mareaArchivoId, categoria } = payload;
        
        const mareaArchivo = await this.prisma.mareaArchivo.findUnique({
            where: { id: mareaArchivoId },
            include: { marea: true }
        });

        if (!mareaArchivo) {
            this.logger.warn(`MareaArchivo ${mareaArchivoId} no encontrado. Omitiendo subida.`);
            return;
        }

        const meta = mareaArchivo.metadata as any;
        if (!meta || !meta.tempFilePath) {
            throw new Error(`El archivo ${mareaArchivoId} no tiene ruta temporal en metadata`);
        }

        const fileBuffer = await fs.readFile(meta.tempFilePath);
        const folderId = this.configService.get<string>('GOOGLE_DRIVE_MAREAS_FOLDER_ID');

        // Subir a Drive
        const result = await this.driveStorageService.uploadFile(
            meta.originalName,
            meta.mimetype,
            fileBuffer,
            folderId
        );

        // Actualizar registro en BD
        meta.driveFileId = result.fileId;
        meta.estadoDrive = 'AVAILABLE';

        await this.prisma.mareaArchivo.update({
            where: { id: mareaArchivoId },
            data: {
                rutaArchivo: result.webViewLink,
                metadata: meta
            }
        });

        // Si es pasaje, encolar procesamiento de IA y no borrar el archivo temporal todavía
        if (categoria === 'PASAJE' && meta.procesadoAi === false) {
            await this.jobQueueService.addJob(
                JobType.NOVEDADES_AI_PROCESS,
                {
                    origen: 'UI',
                    mareaId: mareaArchivo.mareaId,
                    mareaArchivoId: mareaArchivo.id,
                    fuente: `ADJUNTO: ${meta.originalName}`,
                    emailSubject: `Pasaje UI - Marea ${mareaArchivo.mareaId}`,
                    explicitDocType: 'PASAJE',
                    attachmentData: {
                        filePath: meta.tempFilePath,
                        mimetype: meta.mimetype,
                        filename: meta.originalName
                    }
                }
            );
        } else {
            // Eliminar archivo temporal si no se necesita más
            try {
                await fs.unlink(meta.tempFilePath);
            } catch (e) {
                this.logger.warn(`No se pudo eliminar el archivo temporal ${meta.tempFilePath}`);
            }
        }
    }

    private async handleDelete(payload: any) {
        const { driveFileIds } = payload;
        if (!driveFileIds || !Array.isArray(driveFileIds)) return;

        for (const fileId of driveFileIds) {
            try {
                await this.driveStorageService.deleteFile(fileId);
            } catch (e) {
                this.logger.error(`Error borrando archivo ${fileId} de Drive: ${e.message}`);
                // Podríamos relanzar si queremos reintentos para TODO el batch, 
                // pero si uno falla tal vez el archivo ya no exista. 
                // En Drive, borrar algo borrado lanza 404, así que está bien continuar.
            }
        }
    }
}
