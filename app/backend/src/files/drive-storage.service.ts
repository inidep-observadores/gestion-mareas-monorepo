import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { google, drive_v3 } from 'googleapis';
import { Readable } from 'stream';
import { ErrorLogsService } from '../common/error-logs/error-logs.service';

@Injectable()
export class DriveStorageService {
    private readonly logger = new Logger(DriveStorageService.name);
    private driveClient: drive_v3.Drive;

    constructor(
        private readonly configService: ConfigService,
        private readonly errorLogsService: ErrorLogsService,
    ) {
        // Inicializar el cliente de Google Drive API usando OAuth2
        const clientId = this.configService.get<string>('GOOGLE_CLIENT_ID');
        const clientSecret = this.configService.get<string>('GOOGLE_CLIENT_SECRET');
        const refreshToken = this.configService.get<string>('GOOGLE_REFRESH_TOKEN');
        
        if (clientId && clientSecret && refreshToken) {
            const oauth2Client = new google.auth.OAuth2(clientId, clientSecret);
            oauth2Client.setCredentials({ refresh_token: refreshToken });
            
            this.driveClient = google.drive({ version: 'v3', auth: oauth2Client });
        } else {
            // Fallback para pruebas si no hay variables configuradas
            this.driveClient = google.drive({ version: 'v3' });
        }
    }

    /**
     * Sube un archivo a Google Drive y devuelve su ID y WebViewLink
     */
    async uploadFile(filename: string, mimeType: string, buffer: Buffer, folderIdParam?: string): Promise<{ fileId: string; webViewLink: string }> {
        const folderId = folderIdParam || this.configService.get<string>('GOOGLE_DRIVE_NOVEDADES_FOLDER_ID');
        
        const { PassThrough } = require('stream');
        const bufferStream = new PassThrough();
        bufferStream.end(buffer);

        try {
            const response = await this.driveClient.files.create({
                requestBody: {
                    name: filename,
                    parents: folderId ? [folderId] : undefined,
                },
                media: {
                    mimeType: mimeType,
                    body: bufferStream,
                },
                fields: 'id, webViewLink',
            });

            if (!response.data.id || !response.data.webViewLink) {
                throw new Error('No se recibió el ID o el link desde Google Drive');
            }

            // Dar permisos de vista pública (cualquiera con el enlace puede leer)
            await this.driveClient.permissions.create({
                fileId: response.data.id,
                requestBody: {
                    role: 'reader',
                    type: 'anyone',
                },
            });

            this.logger.log(`Archivo ${filename} subido exitosamente a Google Drive (ID: ${response.data.id})`);

            return {
                fileId: response.data.id,
                webViewLink: response.data.webViewLink,
            };
        } catch (error: any) {
            this.logger.error(`Error al subir archivo a Google Drive: ${error.message}`);
            await this.errorLogsService.create({
                level: 'ERROR',
                source: 'GOOGLE_DRIVE',
                context: 'DriveStorageService.uploadFile',
                message: `Error al subir archivo a Google Drive (${filename}): ${error.message}`,
                stack: error.stack,
                detail: {
                    filename,
                    mimeType,
                    folderId,
                },
            });
            throw error;
        }
    }
    /**
     * Actualiza el contenido y metadatos de un archivo existente en Google Drive
     */
    async updateFile(fileId: string, filename: string, mimeType: string, buffer: Buffer): Promise<{ fileId: string; webViewLink: string }> {
        const { PassThrough } = require('stream');
        const bufferStream = new PassThrough();
        bufferStream.end(buffer);

        try {
            const response = await this.driveClient.files.update({
                fileId: fileId,
                requestBody: {
                    name: filename
                },
                media: {
                    mimeType: mimeType,
                    body: bufferStream
                },
                fields: 'id, webViewLink'
            });

            this.logger.log(`Archivo ${fileId} (${filename}) actualizado exitosamente en Google Drive`);

            return {
                fileId: response.data.id || fileId,
                webViewLink: response.data.webViewLink || `https://drive.google.com/file/d/${fileId}/view`
            };
        } catch (error: any) {
            this.logger.error(`Error al actualizar archivo en Google Drive (ID: ${fileId}): ${error.message}`);
            await this.errorLogsService.create({
                level: 'ERROR',
                source: 'GOOGLE_DRIVE',
                context: 'DriveStorageService.updateFile',
                message: `Error al actualizar archivo en Google Drive (${filename}, ID: ${fileId}): ${error.message}`,
                stack: error.stack,
                detail: {
                    fileId,
                    filename,
                    mimeType,
                },
            });
            throw error;
        }
    }

    /**
     * Elimina permanentemente un archivo de Google Drive
     */
    async deleteFile(fileId: string): Promise<void> {
        try {
            await this.driveClient.files.delete({
                fileId: fileId
            });
            this.logger.log(`Archivo eliminado permanentemente de Google Drive (ID: ${fileId})`);
        } catch (error: any) {
            const isNotFound = error?.code === 404 || error?.status === 404 || error?.message?.includes('File not found') || error?.message?.includes('404');
            if (isNotFound) {
                this.logger.warn(`Archivo no encontrado al intentar eliminar en Google Drive (ID: ${fileId})`);
            } else {
                this.logger.error(`Error al eliminar archivo de Google Drive (ID: ${fileId}): ${error.message}`);
                await this.errorLogsService.create({
                    level: 'ERROR',
                    source: 'GOOGLE_DRIVE',
                    context: 'DriveStorageService.deleteFile',
                    message: `Error al eliminar archivo de Google Drive (ID: ${fileId}): ${error.message}`,
                    stack: error.stack,
                    detail: { fileId },
                });
            }
        }
    }
}
