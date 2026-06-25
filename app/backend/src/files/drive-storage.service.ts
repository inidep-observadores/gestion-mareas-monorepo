import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { google, drive_v3 } from 'googleapis';
import { Readable } from 'stream';

@Injectable()
export class DriveStorageService {
    private readonly logger = new Logger(DriveStorageService.name);
    private driveClient: drive_v3.Drive;

    constructor(private readonly configService: ConfigService) {
        // Inicializar el cliente de Google Drive API
        const credentialsPath = this.configService.get<string>('GOOGLE_APPLICATION_CREDENTIALS');
        
        if (credentialsPath) {
            const auth = new google.auth.GoogleAuth({
                keyFile: credentialsPath,
                scopes: ['https://www.googleapis.com/auth/drive.file'],
            });
            this.driveClient = google.drive({ version: 'v3', auth });
        } else {
            // Fallback para pruebas si no hay ruta configurada
            this.driveClient = google.drive({ version: 'v3' });
        }
    }

    /**
     * Sube un archivo a Google Drive y devuelve su ID y WebViewLink
     */
    async uploadFile(filename: string, mimeType: string, buffer: Buffer): Promise<{ fileId: string; webViewLink: string }> {
        const folderId = this.configService.get<string>('GOOGLE_DRIVE_FOLDER_ID');
        
        const bufferStream = new Readable();
        bufferStream.push(buffer);
        bufferStream.push(null);

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

            this.logger.log(`Archivo ${filename} subido exitosamente a Google Drive (ID: ${response.data.id})`);

            return {
                fileId: response.data.id,
                webViewLink: response.data.webViewLink,
            };
        } catch (error) {
            this.logger.error(`Error al subir archivo a Google Drive: ${error.message}`);
            throw error;
        }
    }
}
